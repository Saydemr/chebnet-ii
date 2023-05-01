
from genericpath import isfile

with open('./results.csv', 'w') as g:
    g.write('dataset,xi0,xi1,val_acc,test_acc,test_std\n')
    for t0 in [-1.0, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1.0]:
        for t1 in [-1.0, -0.75, -0.5, -0.25, 0.25, 0.5, 0.75, 1.0]:
            for t in [-1.0, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1.0]:
                for name in ['Texas', 'Citeseer', 'Pubmed', 'Cora', 'Cornell']:
                    xi0 = t0/t1
                    xi1 = t/t1
                    if isfile('./o{}-{}-{}-{}.txt'.format(t0, t1, t, name)):
                        with open('./o{}-{}-{}-{}.txt'.format(t0, t1, t, name), 'r') as f:
                            lines = f.readlines()
                            last_line = lines[-1]
                            if last_line.startswith('test acc mean'):
                                # keep only digits and spaces
                                last_line = ''.join([c for c in last_line if c.isdigit() or c == ' ' or c == '.'])
                                last_line = last_line.strip().split()
                                test_acc = float(last_line[0])
                                test_std = float(last_line[1])
                                val_acc = float(last_line[2])
                                g.write('{},{},{},{},{},{}\n'.format(name, xi0, xi1, val_acc, test_acc, test_std))
