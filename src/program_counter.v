module program_counter
(
    input clk,
    input [31:0] pc_update,
    input rst,
    output reg [31:0] pc
);

always @(posedge clk) 
begin
if (rst == 1'b1)
begin
    pc <= 32'h00000000;
end
else
begin
    pc <= pc_update;
end

end
endmodule
