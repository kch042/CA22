`include "util.v"

// testbench
module test();

reg clk;
reg init;
wire [3:0] c;
wire [3:0] c1;
wire [3:0] c2;

// instantiate a dut (device under test)
util ut(
    .clk(clk),
    .init(init),
    .cnt(c)
);

// parameter ONE = 1;
// p p1(
//     .clk(clk),
//     .in(ONE),
//     .out(c1)
// );

// p p2(
//     .clk(clk),
//     .in(c1),
//     .out(c2)
// );



initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, ut);

    clk = 0;
    init = 0;

    // initialize cnt in dut
    #1
    init = 1;
    #1

    init = 0;

    #100
    init=1;
    #1

    init=0;

end


always #10 begin
    clk = ~clk;

    // if (out == 4'b1111)
    //     $finish;
end


// in case bugs happen
always #400 begin
    $finish;
end


endmodule