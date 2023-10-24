#!/bin/bash
echo "Testing Idle for 1 minute. Press Ctrl+c when 1 minute done!"
nvidia-smi --query-gpu=timestamp,name,utilization.gpu,utilization.memory,memory.used,memory.free,power.draw --format=csv -l 1 -f gpu_idle.csv
echo "Testing power run for 1 minute. Press Ctrl+c when 1 minute done!"
./gpu_burn 60 & stress --cpu 16 --io 4 --vm 2 --vm-bytes 128M --timeout 60 & nvidia-smi --query-gpu=timestamp,name,utilization.gpu,utilization.memory,memory.used,memory.free,power.draw --format=csv -l 1 -f gpu_high.csv 
