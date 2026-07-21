`timescale 1ns / 1ps

module instruction_mem_tb;
reg [31:0] inst_rd;
wire [31:0] inst;

instruction_mem #(.memfile("sim/test.hex")) DUT
(
    .inst_rd(inst_rd),
    .inst(inst)
);

initial begin
    $dumpfile("sim/instruction_mem_sim.vcd");
    $dumpvars(0, instruction_mem_tb);
    
    inst_rd = 32'h00000000;
    #1
    if(inst != 32'hfeedbeef) $display("Fail: expected 0xfeedbeef got %h", inst);
    else $display ("Success: feedbeef found in memory address 0x00");

    inst_rd = 32'h00000004;
    #1
    if(inst != 32'hbedbedbe) $display("Fail: expected 0xbedbedbe got %h", inst);
    else $display ("Success: bedbedbe found in memory address 0x00");

    inst_rd = 32'h00000008;
    #1
    if(inst != 32'hdeaddead) $display("Fail: expected 0xdeaddead got %h", inst);
    else $display ("Success: deaddead found in memory address 0x00");

    inst_rd = 32'h0000000C;
    #1
    if(inst != 32'h12345678) $display("Fail: expected 0x12345678 got %h", inst);
    else $display ("Success: 12345678 found in memory address 0x00");

    inst_rd = 32'h00000010;
    #1
    if(inst != 32'h11223344) $display("Fail: expected 0x11223344 got %h", inst);
    else $display ("Success: 11223344 found in memory address 0x00");

end




endmodule
