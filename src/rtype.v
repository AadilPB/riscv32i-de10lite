module rtype
(
    input rst,
    input clk,
    input  [31:0] pc_update,
    output [31:0] inst,
    output [31:0] pc
);




program_counter pc_reg 
(
    .clk(clk),
    .rst(rst),
    .pc_update(pc_update),
    .pc(pc)
);

instruction_mem instr_mem
(
    .inst_rd(pc),
    .inst(inst)
);

endmodule
