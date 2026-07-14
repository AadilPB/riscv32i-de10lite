module data_memory
(
    input         clk,
    input         wr_mem,
    input  [31:0] addr,
    input  [31:0] wr_data,
    output [31:0] rd_data
);

reg [31:0] mem [1023:0];

always @(posedge clk)
    if(wr_mem)
        mem[addr] <= wr_data;
    

assign rd_data = mem[addr];


endmodule
