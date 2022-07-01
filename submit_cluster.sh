#!/usr/bin/env bash

# Resource settings (per parameter set)
MAX_TIME='16:00'  # requires around 1 min per 100 epochs; round up generously
NUM_CPU_CORES=16
MEM_PER_CPU=1000

# Determine common paths
REPOSITORY_DIR="$(realpath $(dirname $BASH_SOURCE))"

for config_file in "${REPOSITORY_DIR}"/config_*.json; do
  echo "Submitting job for config ${config_file}"
  bsub \
      -W "${MAX_TIME}" \
      -n $NUM_CPU_CORES \
      -R "rusage[ngpus_excl_p=1]" \
      -R "select[gpu_model0==NVIDIAGeForceGTX1080Ti]" \
      -R "rusage[mem=${MEM_PER_CPU}]" \
      -cwd "${REPOSITORY_DIR}" \
      "python train.py --config ${config_file}"
done
