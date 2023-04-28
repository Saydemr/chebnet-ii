for t0 in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
do
    for t1 in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
    do
        for t in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
        do
            python training.py --net ChebNetII --dataset Texas  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0 --dprate 0.6 --prop_lr 0.001 --theta $t --theta0 $t0 --theta1 $t1 2>&1 | tee o$t-$t0-$t1-Texas.txt
            python training.py --net ChebNetII --dataset Cornell  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0005 --dprate 0.5 --prop_lr 0.001 --theta $t --theta0 $t0 --theta1 $t1 2>&1 | tee o$t-$t0-$t1-Cornell.txt
            python training.py --net ChebNetII --dataset Cora  --full True --lr 0.01  --weight_decay 0.0005 --dprate 0.0 --theta $t --theta0 $t0 --theta1 $t1 2>&1 | tee o$t-$t0-$t1-Cora.txt
            python training.py --net ChebNetII --dataset Citeseer  --full True --lr 0.01  --weight_decay 0.0005 --prop_wd 0.0 --theta $t --theta0 $t0 --theta1 $t1 2>&1 | tee o$t-$t0-$t1-Citeseer.txt
            python training.py --net ChebNetII --dataset Pubmed  --full True --lr 0.01  --weight_decay 0.0 --prop_wd 0.0 --dprate 0.0 --theta $t --theta0 $t0 --theta1 $t1 2>&1 | tee o$t-$t0-$t1-Pubmed.txt
        done
    done
done
