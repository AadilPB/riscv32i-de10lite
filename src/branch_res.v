module branch_res
(
    input alu_result_lsb,
    input branch_src,
    input zero,
    input invert,
    input branch,
    output reg pc_sel
);

reg branch_con;
reg inversion;
reg branching;

always @(*) begin
    branch_con = (branch_src) ? alu_result_lsb : zero;
    inversion = branch_con ^ invert;
    branching = inversion & branch;

    pc_sel = branching;
    

end

endmodule
