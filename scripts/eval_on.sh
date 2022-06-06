#!/bin/bash
#SBATCH --job-name=eval_obj
#SBATCH --gres gpu:1
#SBATCH --constraint=rtx_6000
#SBATCH -p long
#SBATCH --output=slurm_logs/ddppo-eval-%j.out
#SBATCH --error=slurm_logs/ddppo-eval-%j.err

hostname

source /nethome/rramrakhya6/miniconda3/etc/profile.d/conda.sh
cd /srv/share3/rramrakhya6/objectnav_aux/objectnav/
conda deactivate
conda activate habitat

echo $#
# * We hardcode a python exe here to get cronjob working. A more straightforward script is available in `eval_local.sh`
if [[ $# -eq 3 ]]
then
    echo "in herer"
    all_args=("$@")
    echo "arg ${1}"
    echo "arg ${2}"
    echo "arg ${3}"
    echo $all_args
    python -u /srv/share3/rramrakhya6/objectnav_aux/objectnav/habitat_baselines/run.py \
        --run-type eval \
        --exp-config /srv/share3/rramrakhya6/objectnav_aux/objectnav/habitat_baselines/config/objectnav/full/$1.on.yaml \
        --ckpt-path $2
elif [[ $# -ge 4 ]]
then
    all_args=("$@")
    echo $all_args
    rest_args=("${all_args[@]:3}")
    echo ${rest_args[@]}
    /srv/flash1/jye72/anaconda3/envs/habitat2/bin/python -u /srv/flash1/jye72/projects/embodied-recall/habitat_baselines/run.py \
        --run-type eval \
        --exp-config /srv/flash1/jye72/projects/embodied-recall/habitat_baselines/config/objectnav/$1.on.yaml \
        --run-suffix $2 \
        --ckpt-path /srv/share/jye72/objectnav/$1/$1.$3.pth ${rest_args[@]}
else
    echo "Invalid config"
fi
