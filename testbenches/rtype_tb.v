`timescale 1ns / 1ps

module rtype_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;
    reg [31:0] result;

rv32i_top #(.memfile("mem/rtype_test_word.hex")) DUT
(
  .rst(rst),
  .clk(clk)
);

always #1 clk = ~clk;

task reg_check(input [4:0] num_reg, input [31:0] expected, input [255:0] label);
    begin
        total_tests = total_tests + 1;
        if(DUT.reg_file_unit.gpr[num_reg] !== expected)
            $display("Fail: %0s expected %d, got %d", label, expected, DUT.reg_file_unit.gpr[num_reg]);
        else begin
            total_passes = total_passes + 1;
            $display("Pass: %0s", label);
        end
    end
endtask

task mem_check(input [31:0] addr, input [31:0] expected, input [255:0] label);
    begin
        total_tests = total_tests +1;
        result = {DUT.dmem_unit.mem[addr+3], DUT.dmem_unit.mem[addr+2],
        DUT.dmem_unit.mem[addr+1], DUT.dmem_unit.mem[addr]};

        if(result !== expected)
            $display("Fail: %0s expected %d, got %d", label, expected, result);
        else begin
            total_passes = total_passes + 1;
            $display("Pass: %0s", label);
        end
    end
endtask


initial begin
    $dumpfile("sim/rtype.vcd");
    $dumpvars(0, rtype_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

    @(posedge clk);
    #1;
    reg_check(1, 32'd3, "addi x1, x0, 3");
    
    @(posedge clk);
    #1;
    reg_check(2, 32'd7, "addi x2, x0, 7");
    
    @(posedge clk);
    #1;
    reg_check(3, 32'd10, "add x3, x1, x2");

    @(posedge clk);
    #1;
    reg_check(4, 32'd4, "sub x4, x2, x1");

    @(posedge clk);
    #1;
    reg_check(5, 32'd4, "xor x5, x1, x2");

    @(posedge clk);
    #1;
    reg_check(6, 32'd7, "or x6, x1, x2");

    @(posedge clk);
    #1;
    reg_check(7, 32'd3, "and x7, x1, x2");



    $display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
