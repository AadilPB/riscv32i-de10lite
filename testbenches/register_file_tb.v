`timescale 1ns / 1ps

module register_file_tb;
    reg clk;
    reg wr_enable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] wr_address;
    reg [31:0] wr_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    integer i;

    register_file DUT 
    (.clk(clk),
     .wr_enable(wr_enable),
     .rs1(rs1),
     .rs2(rs2),
     .wr_address(wr_address),
     .wr_data(wr_data),
     .rs1_data(rs1_data),
     .rs2_data(rs2_data)
    );

    always #1 clk = ~clk;

    initial begin
        $dumpfile("sim/register_file_sim.vcd");
        $dumpvars(0, register_file_tb);
        clk = 1'b0;
        wr_enable = 1'b0;
        wr_address = 5'b00001;
        wr_data = 32'h0000000A;
        rs1 = 5'b00001;
        rs2 = 5'b10000;
        i = 0;

        #3 wr_enable = 1'b1;

        for(i = 0; i < 32; i = i + 1) begin
            wr_address = i;
            wr_data = i * 10;
            #2;
        end

        #2 wr_enable = 1'b0;

        for(i = 0; i < 16; i = i + 1) begin
            rs1 = i;
            rs2 = i + 16;
            #2;
        end

        $finish;

    end

endmodule
