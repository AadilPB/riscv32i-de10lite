module data_memory
(
    input             clk,
    input             wr_mem,
    input             rd_mem,
    input      [31:0] addr,
    input      [31:0] wr_data,
    input      [ 2:0] funct3,
    output reg [31:0] rd_data
);

reg [7:0] mem [4095:0];

always @(posedge clk) begin
    if(wr_mem) begin
        case(funct3) 
            3'b000 : begin // sb
                mem[addr]     <= wr_data[7:0];
            end
            3'b001 : begin // sh
                mem[addr]     <= wr_data[7:0];
                mem[addr + 1] <= wr_data[15:8];
            end 
            3'b010 : begin // sw
                mem[addr]     <= wr_data[7:0];
                mem[addr + 1] <= wr_data[15:8];
                mem[addr + 2] <= wr_data[23:16];
                mem[addr + 3] <= wr_data[31:24];
            end
            default : ;
        endcase
    end
end
    

always @(*) begin
    if(rd_mem) begin
        case(funct3)
        3'b000 : rd_data = {{24{mem[addr][7]}}, mem[addr]};                          // lb
        3'b001 : rd_data = {{16{mem[addr+1][7]}}, mem[addr + 1], mem[addr]};         // lh
        3'b010 : rd_data = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]}; // lw
        3'b100 : rd_data = {24'b0, mem[addr]};                                       // lbu
        3'b101 : rd_data = {16'b0, mem[addr + 1], mem[addr]};                        // lhu
        default : rd_data = 32'bx;
        endcase
    end
    else rd_data = 32'bx;
end


endmodule
