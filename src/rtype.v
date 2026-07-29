module rtype
(
    input rst,
    input clk
);

// output from the pc_reg, input to the instruction memory and pc_plus_4
wire [31:0] pc;

//input to the pc_reg, output from the pc_plus_4
wire [31:0] pc_update;

program_counter pc_reg_unit 
(
    .clk(clk),
    .rst(rst),
    .pc_update(pc_update),
    .pc(pc)
);

adder pc_plus_4_unit
(
    .a(32'd4),
    .b(pc),
    .sum(pc_update)
);

// output from instr_mem, input to reg_file and control
wire [31:0] inst;

instruction_mem instr_mem_unit
(
    .inst_rd(pc),
    .inst(inst)
);

wire [6:0] opcode = inst[6:0];
wire [4:0] wr_address = inst[11:7];
wire [4:0] rs1 = inst[19:15];
wire [4:0] rs2 = inst[24:20];

wire reg_wr_enable;

wire [31:0] wr_data;
wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] alu_result;

register_file reg_file_unit
(
    .clk(clk),
    .wr_enable(reg_wr_enable),
    .rs1(rs1),
    .rs2(rs2),
    .wr_address(wr_address),
    .wr_data(alu_result),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);


wire alu_zero;
wire [3:0] alu_ctrl;

ALU alu_unit
(
    .a(rs1_data),
    .b(rs2_data),
    .alu_ctrl(alu_ctrl),
    .result(alu_result),
    .zero(alu_zero)
);



wire [1:0] alu_op; 

control_unit control
(
    .opcode(opcode),
    .reg_wr_enable(reg_wr_enable),
    .alu_op(alu_op)

);


wire [2:0] funct3 = inst[14:12];
wire [6:0] funct7 = inst[31:25];

alu_control alu_ctrl_unit
(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl)
);

endmodule
