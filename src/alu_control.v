module alu_control(
    input  [1:0] alu_op,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg [3:0] alu_ctrl,
    output reg invert
);

always @(*) begin
    alu_ctrl = 4'bxxxx;
    invert = 1'bx;
    case(alu_op)
    2'b00 : alu_ctrl = 4'b0011; // add
    2'b01 : // B-type instructions
        case (funct3) 
            3'b000 : begin
                alu_ctrl = 4'b0100;
                invert = 1'b0;
            end
            3'b001 : begin
                alu_ctrl = 4'b0100;
                invert = 1'b1;
            end
            3'b100 : begin
                alu_ctrl = 4'b1000;
                invert = 1'b0;
            end
            3'b101 : begin
                alu_ctrl = 4'b1000;
                invert = 1'b1;
            end
            3'b110 : begin
                alu_ctrl = 4'b1001;
                invert = 1'b0;
            end
            3'b111 : begin
                alu_ctrl = 4'b1001;
                invert = 1'b1;
            end 
            default: begin 
                alu_ctrl = 4'bxxxx;
                invert = 1'bx;
            end
        endcase
    2'b10 :                     // R-type instructions
        case(funct3) 
        3'b000 : begin
            if(funct7[5]) alu_ctrl =  4'b0100; // sub
            else alu_ctrl = 4'b0011;           // add
        end
        3'b001 : alu_ctrl = 4'b0101; // sll
        3'b010 : alu_ctrl = 4'b1000; // slt
        3'b011 : alu_ctrl = 4'b1001; // sltu
        3'b100 : alu_ctrl = 4'b0010; // xor
        3'b101 : begin
            if(funct7[5]) alu_ctrl = 4'b0111; // sra
            else          alu_ctrl = 4'b0110; // srl
        end
        3'b110 : alu_ctrl = 4'b0001; // or
        3'b111 : alu_ctrl = 4'b0000; // and
        default : alu_ctrl = 4'bxxxx;
        endcase
    2'b11 :                    // I-type instructions
        case(funct3) 
        3'b000 : alu_ctrl = 4'b0011; // add
        3'b001 : alu_ctrl = 4'b0101; // sll
        3'b010 : alu_ctrl = 4'b1000; // slt
        3'b011 : alu_ctrl = 4'b1001; // sltu
        3'b100 : alu_ctrl = 4'b0010; // xor
        3'b101 : begin
            if(funct7[5]) alu_ctrl = 4'b0111; // sra
            else          alu_ctrl = 4'b0110; // srl
        end
        3'b110 : alu_ctrl = 4'b0001; // or
        3'b111 : alu_ctrl = 4'b0000; // and
        default : alu_ctrl = 4'bxxxx;
        endcase

    default: alu_ctrl = 4'bxxxx;
    endcase
end

endmodule
