`timescale 1ns / 1ps

module rtype_tb;
    reg rst;
    reg clk;

rtype DUT
(
  .rst(rst),
  .clk(clk)
);

always #1 clk = ~clk;

initial begin
    $dumpfile("sim/rtype.vcd");
    $dumpvars(0, rtype_tb);

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

    DUT.reg_file_unit.gpr[1] = 32'd10;
    DUT.reg_file_unit.gpr[2] = 32'd05;

    #20;

    if(DUT.reg_file_unit.gpr[3] !== 32'd15)
        $display("Fail: add x3, x1, x2 - expected 15, got %d", DUT.reg_file_unit.gpr[3]);
    else 
        $display("Pass: add x3, x1, x2");
    

    $finish;
end

endmodule
