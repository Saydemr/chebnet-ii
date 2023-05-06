import math
import torch
from torch.nn import Parameter
from torch_geometric.nn.conv import MessagePassing
from torch_geometric.utils import add_self_loops
from get_laplacian import get_laplacian
import torch.nn.functional as F
from utils import cheby
from torch_sparse import coalesce


class ChebnetII_prop(MessagePassing):
    def __init__(self, K, Init=False, bias=True, **kwargs):
        super(ChebnetII_prop, self).__init__(aggr='add', **kwargs)
        self.K = K
        self.kwargs = kwargs
        self.laplacian = kwargs.get('laplacian', 'gcn')
        self.temp = Parameter(torch.Tensor(self.K+1))
        self.Init=Init
        self.reset_parameters()

    def reset_parameters(self):
        self.temp.data.fill_(1.0)

        if self.Init:
            for j in range(self.K+1):
                x_j=math.cos((self.K-j+0.5)*math.pi/(self.K+1))
                self.temp.data[j] = x_j**2
        
    def forward(self, x, edge_index, edge_weight=None):
        coe_tmp=F.relu(self.temp)
        coe=coe_tmp.clone()
        
        for i in range(self.K+1):
            coe[i]=coe_tmp[0]*cheby(i,math.cos((self.K+0.5)*math.pi/(self.K+1)))
            for j in range(1,self.K+1):
                x_j=math.cos((self.K-j+0.5)*math.pi/(self.K+1))
                coe[i]=coe[i]+coe_tmp[j]*cheby(i,x_j)
            coe[i]=2*coe[i]/(self.K+1)


        edge_index1, norm1 = get_laplacian(edge_index, edge_weight, normalization=self.laplacian, dtype=x.dtype, num_nodes=x.size(self.node_dim), kwargs=self.kwargs)
        
        adj = torch.sparse_coo_tensor(edge_index1, norm1, (x.size(self.node_dim), x.size(self.node_dim)))
        max_eigenvalue = torch.lobpcg(adj, k=1)[0]
        norm1 = 2 / max_eigenvalue * norm1  # Then the eigenvalue is always in the range [0, 2]

        # L_tilde= 2/lambda_max * L - I
        edge_index_tilde, norm_tilde = add_self_loops(edge_index1, norm1, fill_value=-1.0, num_nodes=x.size(self.node_dim))
        
        edge_index_tilde, norm_tilde = coalesce(edge_index_tilde, norm_tilde, x.size(self.node_dim), x.size(self.node_dim))
        
        Tx_0=x
        Tx_1=self.propagate(edge_index_tilde,x=x,norm=norm_tilde,size=None)

        out=coe[0]/2*Tx_0+coe[1]*Tx_1

        for i in range(2,self.K+1):
            Tx_2=self.propagate(edge_index_tilde,x=Tx_1,norm=norm_tilde,size=None)
            Tx_2=2*Tx_2-Tx_0
            out=out+coe[i]*Tx_2
            Tx_0,Tx_1 = Tx_1, Tx_2
        
        
        return out

    def message(self, x_j, norm):
        return norm.view(-1, 1) * x_j

    def __repr__(self):
        return '{}(K={}, temp={})'.format(self.__class__.__name__, self.K,
                                          self.temp)
