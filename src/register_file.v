module register_file 
(
    input         clk,
    input         wr_enable,
    input  [4:0]  rs1,
    input  [4:0]  rs2,
    input  [4:0]  wr_address,
    input  [31:0] wr_data,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);

reg [31:0] gpr [31:0];
initial gpr[0] = 32'b0;

always @(posedge clk)
    if(wr_enable == 1 && wr_address != 5'b00000 )
        gpr[wr_address] <= wr_data;

assign rs1_data = gpr[rs1];
assign rs2_data = gpr[rs2];

endmodule
