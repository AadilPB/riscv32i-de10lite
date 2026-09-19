module mux3to1
(
    input  [31:0] data0,
    input  [31:0] data1,
    input  [31:0] data2,
    input  [ 1:0] sel,
    output [31:0] result
);

assign result = (sel == 2'b10) ? data2 :
                (sel == 2'b01) ? data1 : data0;

endmodule
