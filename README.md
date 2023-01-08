# CA22

Risc V CPU implementation 

## Contents
+ hw3: single cycle CPU
+ lab1: pipelined CPU + forwarding unit + hazard detection unit
+ lab2: add a 2-bit dynamic branch predictor

## Tools
+ compiler: iverilog
+ simulator: vvp filename
+ debugger: gtkwave

### Compilation
`$ iverilog -o output.out *.v`

### Simulation
`$ vvp output.out`
This command produces `.vcd` file if `$dumpfile` is called in orginial file.

### Debugging
`$ gtkwave output.vcd`