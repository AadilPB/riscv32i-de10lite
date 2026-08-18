`timescale 1ns / 1ps

module beq_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;
    reg [31:0] result;

rv32i_top #(.memfile("mem/btype_test_word.hex")) DUT
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
    $dumpfile("sim/btype.vcd");
    $dumpvars(0, btype_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

    @(posedge clk);
    #1;
    
    while (DUT.pc_reg_unit.pc !== 32'h00000018) @(posedge clk);
    #1;
    reg_check(3, 12, "beq taken - x3 check");
    
    while (DUT.pc_reg_unit.pc !== 32'h00000024) @(posedge clk);
    #1;
    reg_check(3, 5, "beq not taken - x3 check");



    $display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
