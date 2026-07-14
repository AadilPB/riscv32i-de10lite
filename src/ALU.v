module ALU
(
    input [31:0] a, b,
    input [3:0] op,
    output reg [31:0] result,
    output zero
);



always @(*) begin
    case (op)
    4'b0000 : result = a & b;
    4'b0001 : result = a | b;
    4'b0010 : result = a + b;
    4'b0110 : result = a - b;
    default : result = 32'b0;
    endcase
end

assign zero = (result == 32'b0) ? 1 : 0;

endmodule
