`timescale 1ns / 1ps

module rv32i_top_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;

rv32i_top DUT
(
  .rst(rst),
  .clk(clk)
);

always #1 clk = ~clk;

task reg_check;
    input [4:0] num_reg;
    input [31:0] expected;
    input [255:0] label;
    

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

initial begin
    $dumpfile("sim/rv32i_top.vcd");
    $dumpvars(0, rv32i_top_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

    @(posedge clk);
    #1;
    reg_check(1, 32'd10, "addi x1, x0, 10");
    
    @(posedge clk);
    #1;
    reg_check(2, 32'd20, "addi x2, x0, 20");
    
    @(posedge clk);
    #1;
    reg_check(3, 32'd30, "addi x3, x1, x2");

    @(posedge clk);
    #1;
    total_tests = total_tests + 1;

    if(DUT.dmem_unit.mem[0] !== 32'd30)
        $display("Fail: sw x3, 0(x0), expected 30, got %d", DUT.dmem_unit.mem[0]);
    else begin
        total_passes = total_passes + 1;
        $display("Pass: sw x3, 0(x0)");
    end

    @(posedge clk);
    #1;
    reg_check(4, 32'd30, "lw x4, 0(x0)");

    @(posedge clk);
    #1;
    reg_check(5, 32'd40, "add x5, x4, x1");

    $display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
