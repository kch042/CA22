all:
	iverilog -o test.out test.v
	vvp test.out
	gtkwave test.vcd

clean:
	rm *.out *.vcd