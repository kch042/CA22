all:
	iverilog -o CPU.out *.v
	vvp CPU.out

run:
	gtkwave CPU.vcd

clean:
	rm *.out *.vcd