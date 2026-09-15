import sys
import os

asm_dir = "asm"
tb_dir = "testbenches"


def make_test(filename):

    asm_contents = """.global _begin

_begin:

_end:"""

    tb_contents = tb_contents = f"""`timescale 1ns / 1ps

module {filename}_tb;
    reg rst;
    reg clk;
    integer total_passes;
    integer total_tests;
    reg [31:0] result;

rv32i_top #(.memfile("mem/{filename}.hex")) DUT
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
        result = {{DUT.dmem_unit.mem[addr+3], DUT.dmem_unit.mem[addr+2],
        DUT.dmem_unit.mem[addr+1], DUT.dmem_unit.mem[addr]}};

        if(result !== expected)
        $display("Fail: %0s expected %d, got %d", label, expected, result);
        else begin
            total_passes = total_passes + 1;
            $display("Pass: %0s", label);
        end
    end
endtask

initial begin
    $dumpfile("sim/{filename}.bcd");
    $dumpvars(0, {filename}_tb);

    total_tests = 0;
    total_passes = 0;

    clk = 0;
    rst = 1;
    #2;
    rst = 0;

$display("%0d / %0d tests passed", total_passes, total_tests);

    $finish;
end

endmodule
    """

    tb_path = os.path.join(tb_dir, filename + "_tb.v")
    asm_path = os.path.join(asm_dir, filename + ".s")

    if not os.path.exists(tb_path):
        with open(tb_path, 'w') as output:
            output.write(tb_contents)
        print(f"{tb_path} created")
    else:
        print(f"{tb_path} already exists ! !")
        

    if not os.path.exists(asm_path):
        with open(asm_path, 'w') as output:
             output.write(asm_contents)
        print(f"{asm_path} created")
    else:
        print(f"{asm_path} already exists ! !")
        

if __name__ == "__main__":
    make_test(sys.argv[1])