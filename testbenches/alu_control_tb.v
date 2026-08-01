`timescale 1ns / 1ps

module alu_control_tb;
reg [1:0] alu_op;
reg [2:0] funct3;
reg [6:0] funct7;
wire [3:0] alu_ctrl;
integer total_passes;
integer total_tests;


alu_control DUT
(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl)
);

task check_alu_ctrl( input [1:0] alu_op_t, input [2:0] funct3_t, input [6:0] funct7_t, input [3:0] expected_ctrl_t);
    begin 
        alu_op = alu_op_t;
        funct3 = funct3_t;
        funct7 = funct7_t;
        #1;
        total_tests = total_tests + 1;
        if(alu_ctrl !== expected_ctrl_t)
            $display("Fail: alu_op = %b, funct3 = %b, funct7 = %b, expected %b, got %b", 
                        alu_op_t, funct3_t, funct7_t, expected_ctrl_t, alu_ctrl);
        else
            total_passes = total_passes + 1;
    end
endtask

initial begin
    $dumpfile("sim/alu_control_sim.vcd");
    $dumpvars(0, alu_control_tb);

    total_passes = 0;
    total_tests = 0;

    // alu_op codes:
    // 00 -> add
    // 01 -> sub
    // 10 -> R-type
    // 11 -> I-type

    // lw/sw with add
    check_alu_ctrl(2'b00, 3'bxxx, 7'bxxxxxxx, 4'b0011);

    // branch comparisons with sub
    check_alu_ctrl(2'b01, 3'bxxx, 7'bxxxxxxx, 4'b0100);

    // R-type instructions
    check_alu_ctrl(2'b10, 3'b000, 7'b0000000, 4'b0011); // add
    check_alu_ctrl(2'b10, 3'b000, 7'b0100000, 4'b0100);   // sub
    check_alu_ctrl(2'b10, 3'b001, 7'bxxxxxxx, 4'b0101);   // sll
    check_alu_ctrl(2'b10, 3'b010, 7'bxxxxxxx, 4'b1000);   // slt
    check_alu_ctrl(2'b10, 3'b011, 7'bxxxxxxx, 4'b1001);   // sltu
    check_alu_ctrl(2'b10, 3'b100, 7'bxxxxxxx, 4'b0010);   // xor
    check_alu_ctrl(2'b10, 3'b101, 7'b0000000, 4'b0110);   // srl
    check_alu_ctrl(2'b10, 3'b101, 7'b0100000, 4'b0111);   // sra
    check_alu_ctrl(2'b10, 3'b110, 7'bxxxxxxx, 4'b0001);   // or
    check_alu_ctrl(2'b10, 3'b111, 7'bxxxxxxx, 4'b0000);   // and

    // I-type instructions
    check_alu_ctrl(2'b11, 3'b000, 7'bxxxxxxx, 4'b0011); // addi
    check_alu_ctrl(2'b11, 3'b001, 7'bxxxxxxx, 4'b0101); // slli
    check_alu_ctrl(2'b11, 3'b010, 7'bxxxxxxx, 4'b1000); // slti
    check_alu_ctrl(2'b11, 3'b011, 7'bxxxxxxx, 4'b1001); // sltiu
    check_alu_ctrl(2'b11, 3'b100, 7'bxxxxxxx, 4'b0010); // xori
    check_alu_ctrl(2'b11, 3'b101, 7'b0000000, 4'b0110); // srli
    check_alu_ctrl(2'b11, 3'b101, 7'b0100000, 4'b0111); // srai
    check_alu_ctrl(2'b11, 3'b110, 7'bxxxxxxx, 4'b0001); // ori
    check_alu_ctrl(2'b11, 3'b111, 7'bxxxxxxx, 4'b0000); // and

    $display("%0d / %0d tests passed", total_passes, total_tests);
    

    $finish;
end


endmodule
