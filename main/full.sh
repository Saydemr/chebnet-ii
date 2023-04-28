#!/bin/bash
#SBATCH --partition mllab  # the partition for the Lab course
#SBATCH -N 1 # number of nodes
#SBATCH --gres=gpu:1 # number of GPUs to be allocated
#SBATCH -t 0-08:00 # time after which the process will be killed (D-HH:MM)
#SBATCH -o "/nfs/homedirs/%u/slurm-output/slurm-%j.out"  # where the output log will be stored
#SBATCH --mem=8000 # the memory (MB) that is allocated to the job. If your job exceeds this it will be killed -- but don't set it too large since it will block resources and will lead to your job being given a low priority by the scheduler.
#SBATCH --qos=interactivelab   # this line ensures a very high priority (e.g. start a Jupyter notebook) but only one job per user can run under this mode (remove for normal compute jobs).
cd ${SLURM_SUBMIT_DIR}
echo Starting job ${SLURM_JOBID}
echo SLURM assigned me these nodes:
squeue -j ${SLURM_JOBID} -O nodelist | tail -n +2

conda activate chebnetii

for t0 in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
do
    for t1 in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
    do
        for t in -1.0 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1.0
        do
            python training.py --net ChebNetII --dataset Texas  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0 --dprate 0.6 --prop_lr 0.001 --theta $t --theta0 $t0 --theta1 $t1
            python training.py --net ChebNetII --dataset Cornell  --full True --lr 0.05 --weight_decay 0.0005 --prop_wd 0.0005 --dprate 0.5 --prop_lr 0.001 --theta $t --theta0 $t0 --theta1 $t1
            python training.py --net ChebNetII --dataset Cora  --full True --lr 0.01  --weight_decay 0.0005 --dprate 0.0 --theta $t --theta0 $t0 --theta1 $t1
            python training.py --net ChebNetII --dataset Citeseer  --full True --lr 0.01  --weight_decay 0.0005 --prop_wd 0.0 --theta $t --theta0 $t0 --theta1 $t1
            python training.py --net ChebNetII --dataset Pubmed  --full True --lr 0.01  --weight_decay 0.0 --prop_wd 0.0 --dprate 0.0 --theta $t --theta0 $t0 --theta1 $t1
        done
    done
done
