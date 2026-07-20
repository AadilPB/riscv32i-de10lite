module mux2to1
(
    input  [31:0] data0,
    input  [31:0] data1,
    input         sel,
    output [31:0] result
);

assign result = (sel) ? data1 : data0;

endmodule
