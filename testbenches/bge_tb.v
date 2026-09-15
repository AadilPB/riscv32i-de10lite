`timescale 1ns / 1ps

module beq_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;
    reg [31:0] result;

rv32i_top #(.memfile("mem/beq.hex")) DUT
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
    $dumpfile("sim/beq.vcd");
    $dumpvars(0, beq_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

    @(posedge clk);
    #1;
    //bge greater than not taken
    while (DUT.pc_reg_unit.pc != 32'h00000010);
    #1;
    reg_check(3, 1, "bge not taken")

    //bge greater than taken
    while (DUT.pc_reg_unit.pc != 32'h00000030);
    #1;
    reg_check(3, 2, "bge taken")

    //bge equal taken
    while (DUT.pc_reg_unit.pc != 32'h0000004C);
    #1;
    reg_check(3, 3, "bge equal test")

    //bge signed not taken
    while (DUT.pc_reg_unit.pc != 32'h00000058);
    #1;
    reg_check(3, 4, "bge signed not taken")

    //bge signed taken
    while (DUT.pc_reg_unit.pc != 32'h00000080);
    #1;
    reg_check(3, 5, "bge signed taken")




    $display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
