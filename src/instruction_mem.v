module instruction_mem 
(
    input  [31:0] inst_rd,
    output [31:0] inst
);

    reg [31:0] mem [1023:0];

 
    initial begin
        $readmemh("program.hex", mem);
    end 


    assign inst = mem[inst_rd[31:2]];

endmodule
