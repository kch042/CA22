CC = iverilog

compile:
	$(CC) -o CPU.out *.v
	vvp CPU.out

main:
	$(CC) -o CPU.out *.v

vvp:
	vvp CPU.out

gtk:
	gtkwave CPU.vcd

clean:
	rm -f CPU.out CPU.vcd
