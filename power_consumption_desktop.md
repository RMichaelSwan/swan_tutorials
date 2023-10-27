# Power Consumption Tutorial

Use these instructions to get the rough idle and max power usage of a system without using external phyiscal power monitoring tools (e.g. power clamp). The CPU usage is based off RAPL implementation provided in recent processors, while Nvidia has their own on-gpu power monitoring apparently.

### Isn't There An Easier Way?

Not really! The main reason we have to do CPU and GPU separately is that this gives us fairly accurate power estimation for systems that do not run on battery. For battery powered systems you can try using a tool like `powertop`, though I was not able to get accurate numbers out of it.

## Requirements

Debian based system (e.g. `Ubuntu 20.04`) with an Nvidia GPU. It should be possible to do something similar with a Radeon GPU.

## Tutorial

**Verify usage tools are working:**
1. Run `nvidia-smi` (if this doesn't work, check nvidia drivers)
2. Test `scaphandre` (requires `docker`): verify this command gives you real numbers: `docker run -v /sys/class/powercap:/sys/class/powercap -v /proc:/proc -ti hubblo/scaphandre stdout -p 20 -t 5`

**Install stress tools:**
1. `sudo apt-get install stress`
2. Install/test `gpu-burn` (verify this runs!):
```
git clone https://github.com/wilicc/gpu-burn
cd gpu-burn
make
./gpu_burn 5
```
3. Copy power.bash script to gpu-burn folder. If needed, change cpu count on the `stress` command in the script. Commanding fewer threads will actually get higher usage/throughput in many cases (probably less thrashing of the scheduler).

**Gather Data:**
```
### Test 1
# terminal 1
cd ./gpu-burn
sudo ./power.bash
# terminal 2
docker run -v /sys/class/powercap:/sys/class/powercap -v /proc:/proc -ti hubblo/scaphandre stdout -p 20 -t 60 > cpu_idle.log

### Test 2
# terminal 1
### ctrl+c after 60 seconds (starts logging next command set)
# terminal 2
docker run -v /sys/class/powercap:/sys/class/powercap -v /proc:/proc -ti hubblo/scaphandre stdout -p 20 -t 60 > cpu_high.log

### terminal 1: ctrl+c after 60 seconds
```
**Send data report:**
1. Send screenshot of `htop`
2. Send `os-info.txt`, `cpu-info.txt`, `hw-info.txt`
3. Send  `gpu_idle.csv`, `gpu_high.csv`, `cpu_idle.log`, and `cpu_high.log`

## References:

1. https://github.com/wilicc/gpu-burn
2. https://github.com/resurrecting-open-source-projects/stress
3. https://github.com/hubblo-org/scaphandre/
