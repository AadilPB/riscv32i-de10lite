module rv32i_top #(parameter memfile = "mem/default.hex")
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

instruction_mem #(.memfile(memfile)) instr_mem_unit
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

register_file reg_file_unit
(
    .clk(clk),
    .wr_enable(reg_wr_enable),
    .rs1(rs1),
    .rs2(rs2),
    .wr_address(wr_address),
    .wr_data(wr_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

wire [1:0] alu_op; 
wire alu_src;
wire rd_mem;
wire wr_mem;
wire mem_to_reg;


control_unit control
(
    .opcode(opcode),
    .reg_wr_enable(reg_wr_enable),
    .alu_op(alu_op),
    .rd_mem(rd_mem),
    .wr_mem(wr_mem),
    .alu_src(alu_src),
    .mem_to_reg(mem_to_reg)

);

wire [31:0] imm;

imm_gen imm_gen_unit
(
    .inst(inst),
    .imm(imm)
);

wire [31:0] alu_src_result;

mux2to1 alu_src_unit
(
    .data0(rs2_data),
    .data1(imm),
    .sel(alu_src),
    .result(alu_src_result)
);

wire [2:0] funct3 = inst[14:12];
wire [6:0] funct7 = inst[31:25];
wire [3:0] alu_ctrl;

alu_control alu_ctrl_unit
(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl)
);

wire [31:0] alu_result;
wire alu_zero;

ALU alu_unit
(
    .a(rs1_data),
    .b(alu_src_result),
    .alu_ctrl(alu_ctrl),
    .result(alu_result),
    .zero(alu_zero)
);

wire [31:0] rd_data;

data_memory dmem_unit
(
    .clk(clk),
    .wr_mem(wr_mem),
    .rd_mem(rd_mem),
    .addr(alu_result),
    .wr_data(rs2_data),
    .funct3(funct3),
    .rd_data(rd_data)
);

mux2to1 reg_wr_src_unit
(
    .data0(alu_result),
    .data1(rd_data),
    .sel(mem_to_reg),
    .result(wr_data)
);

endmodule
