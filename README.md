# Get started

## Compilation
`-iverilog -o output.out *.v`

## Simulation
`-vvp output.out`
This command produces `.vcd` file if `$dumpfile` is called in orginial file.

## Wave
`gtkwave output.vcd`

# Utility

## $dumpfile
`$dumpfile("file_name")`

## $dumpvars
usage
`$dumpvars(level, module)`

Information about module
