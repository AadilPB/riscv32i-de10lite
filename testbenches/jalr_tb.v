`timescale 1ns / 1ps

module jalr_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;
    reg [31:0] result;

rv32i_top #(.memfile("mem/jalr.hex")) DUT
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
    $dumpfile("sim/jalr.vcd");
    $dumpvars(0, jalr_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #20; rst = 0;

    wait (DUT.pc == 32'h14);
    #10;

    reg_check(3, 2, "addi x3, x0, 99 jumped over");
    reg_check(4, 55, "addi x4, x0, 55 jumped to");

    $display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
    