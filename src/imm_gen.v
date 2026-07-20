module imm_gen
(
    input      [31:0] inst,
    output reg [31:0] imm
);

wire [6:0] op_code; 
assign op_code = inst[6:0];

always @(*)
begin
    case(op_code) 
        7'b0010011 : imm = {{20{inst[31]}}, inst[31:20]};                                        // I-type instructions
        7'b0000011 : imm = {{20{inst[31]}}, inst[31:20]};                                        // I-type instructions
        7'b0100011 : imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};                            // S-type instructions 
        7'b1100011 : imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};   // B-type instructions
        7'b1101111 : imm = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; // J-type : jal
        7'b1100111 : imm = {{20{inst[31]}}, inst[31:20]};                                        // I-type : jalr
        7'b0110111 : imm = {inst[31:12], 12'b0};                                                 // U-type : lui
        7'b0010111 : imm = {inst[31:12], 12'b0};                                                 // U-type : auipc
        7'b1110011 : imm = {{20{inst[31]}}, inst[31:20]};                                        // I-type : ecall & ebreak
        default    : imm = 32'b0;
    endcase
    
end
