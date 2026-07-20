`timescale 1ns / 1ps

module program_counter_tb;
    reg clk;
    reg [31:0] pc_update;
    reg rst;
    wire[31:0] pc;

    program_counter DUT
    (
        .clk(clk),
        .pc_update(pc_update),
        .rst(rst),
        .pc(pc)
    );

    always #1 clk = ~clk;

    initial begin 
        $dumpfile("sim/program_counter_sim.vcd");
        $dumpvars(0, program_counter_tb);
        clk = 1'b0;
        pc_update = 32'h0000000A;
        rst = 0;

        @(negedge clk);
        rst = 1;
        @(posedge clk);
        #1;
        if (pc != 32'b0) begin
                $display("Fail: rst does not result in a value of 0 in the program counter ! !");
        end

        @(negedge clk);
        rst = 0;
        pc_update = 32'h000000B0;
        @(posedge clk);
        #1;
        if(pc != 32'h000000B0) begin
            $display("Fail: pc does not update to 000000B0 after asserting update and deasserting rst ! !");
        end

        @(negedge clk);
        rst = 1;
        pc_update = 32'h00000C00;
        @(posedge clk);
        #1;
        if(pc == 32'h00000C00) begin
            $display("Fail: pc rst does not override pc_update ! !");
        end
        
        @(negedge clk);
        rst = 0;
        pc_update = 32'h0000DC00;
        @(posedge clk);
        #1;
        if(pc != 32'h0000DC00) begin
            $display("Fail: pc does not update value after deasserting rst ! !");
        end

        $finish;
    end

endmodule

