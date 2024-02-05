# Collection of IP cores, replicated in both VHDL and verilog 
This repositry is for documenting my progress in VHDL and verilog. It will contain re-usable low level IP cores. Each core will be written in both VHDL and Verilog. Each core will contain:

1. A VHDL description
   1. A VHDL test bench
2. Verilog description  
   1. Verilog test bench
3. Cocotb - python testbench that is the same for both cores
4. In the future I plan to add memory-mapped axi4-lite interfaces to each core using rg-gen

I plan to add github actions CI to run the cocotb testbenchs for every commit

# To simulate:
The repository requires [GHDL](https://github.com/ghdl/ghdl), [Icarus verilog](https://github.com/steveicarus/iverilog) and (Cocotb)[https://github.com/cocotb/cocotb] to run. 

At the moment to simulate `fifo` using `cocotb` execute the following:

```
cd fifo
make
```
In order to simulate the individual testbenches for each language, execute the following:
```
cd fifo/vhdl
make
```


This was run using the following versions:
```
Iverilog: 13.0 
GHDL: 4.0.0
Cocotb: 1.8.1
Python: 3.9.2
```
