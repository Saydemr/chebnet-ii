for xi0 in -1.0 0 0.5 1.0
do
    for xi1 in -1.0 -0.5 0 0.5 1.0
    do
        python training.py --net ChebNetII --dataset Texas  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0 --dprate 0.6 --prop_lr 0.001 --xi0 $xi0 --xi1 $xi1 2>&1 | tee o$xi0-$xi1-Texas.txt
        python training.py --net ChebNetII --dataset Cornell  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0005 --dprate 0.5 --prop_lr 0.001 --xi0 $xi0 --xi1 $xi1 2>&1 | tee o$xi0-$xi1-Cornell.txt
        python training.py --net ChebNetII --dataset Cora  --full True --lr 0.01  --weight_decay 0.0005 --dprate 0.0 --xi0 $xi0 --xi1 $xi1 2>&1 | tee o$xi0-$xi1-Cora.txt
        python training.py --net ChebNetII --dataset Citeseer  --full True --lr 0.01  --weight_decay 0.0005 --prop_wd 0.0 --xi0 $xi0 --xi1 $xi1 2>&1 | tee o$xi0-$xi1-Citeseer.txt
        python training.py --net ChebNetII --dataset Pubmed  --full True --lr 0.01  --weight_decay 0.0 --prop_wd 0.0 --dprate 0.0 --xi0 $xi0 --xi1 $ 2>&1 | tee o$xi0-$xi1-Pubmed.txt
    done
done
