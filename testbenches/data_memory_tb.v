`timescale 1ns / 1ps

module data_memory_tb;
reg         clk;
reg         wr_mem;
reg  [31:0] addr;
reg  [31:0] wr_data;
wire [31:0] rd_data;   


data_memory DUT
(
    .clk(clk),
    .wr_mem(wr_mem),
    .addr(addr),
    .wr_data(wr_data),
    .rd_data(rd_data)
);

always #1 clk = ~clk;

initial begin
    $dumpfile("sim/data_memory_sim.vcd");
    $dumpvars(0, data_memory_tb);
    
    clk = 1'b0;
    wr_mem = 1'b1;
    addr = 32'h00000000;
    wr_data = 32'hBEEFBEEF;
    #1;
    
    @(posedge clk);
    wr_mem = 1'b0;
    #1;
    if(rd_data != 32'hBEEFBEEF) $display("Fail: expected 0xBEEFBEEF at memory location 0x00, got %h ! !", rd_data);
    else $display("Success: 0xBEEFBEEF successfully written to memory and read ! !");

    @(posedge clk);
    wr_data = 32'hFEEDFEED;
    #1;
    if(rd_data == 32'hFEEDFEED) $display("Fail: expected 0xBEEFBEEF at memory location 0x00, got %h ! !", rd_data);
    else $display("Success: memory is not written to if wr_mem is low ! !");

    @(posedge clk);
    wr_mem = 1'b1;
    #1;
    if(rd_data != 32'hFEEDFEED) $display("Fail: expected 0xFEEDFEED at memory location 0x00, got %h ! !", rd_data);
    else $display("Success: 0xFEEDFEED successfully overwrote 0xBEEFBEEF at memory location 0x00 ! !");

    @(posedge clk);
    wr_mem = 1'b1;
    addr = 32'h00000004;
    wr_data = 32'h12345678;
    #1;
    if(rd_data != 32'h12345678) $display("Fail: expected 0x12345678 at memory location 0x04, got %h ! !", rd_data);
    else $display("Success: %h successfully written to memory and read ! !", rd_data);

    @(posedge clk);
    addr = 32'h00000003;
    wr_data = 32'h89ABCDEF;
    #1;
    if(rd_data != 32'h89ABCDEF) $display("Fail: Expected 89ABCDEF got %h", rd_data);
    else $display("Success: %h successfully written to memory and read ! !", rd_data);

    @(posedge clk);
    wr_mem = 1'b0;
    addr = 32'h00000004;
    #1;
    if(rd_data != 32'h12345678) $display("Fail: Expected 12345678 got %h ! !", rd_data);
    else $display("Success: No data leakage at 0x04 from data written to 0x03 ! !");

    $finish;
end

endmodule
