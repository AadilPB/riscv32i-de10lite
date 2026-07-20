module ALU
(
    input [31:0] a, b,
    input [3:0] alu_op,
    output reg [31:0] result,
    output zero
);

wire [4:0] shft_amt = b[4:0];

always @(*) begin
    case (alu_op)
    4'b0000 : result = a & b;                                     // AND
    4'b0001 : result = a | b;                                     // OR
    4'b0010 : result = a ^ b;                                     // XOR
    4'b0011 : result = a + b;                                     // ADD
    4'b0100 : result = a - b;                                     // SUB
    4'b0101 : result = a << shft_amt;                             // SLL
    4'b0110 : result = a >> shft_amt;                             // SRL
    4'b0111 : result = $signed(a) >>> shft_amt;                   // SRA
    4'b1000 : result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT
    4'b1001 : result = (a < b) ? 32'b1 : 32'b0;                   // SLTU
    default : result = 32'b0;
    endcase
end

assign zero = (result == 32'b0) ? 1 : 0;

endmodule
