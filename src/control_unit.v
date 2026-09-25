module control_unit
(
   input [6:0] opcode,
   output reg [1:0] alu_op,
   output reg branch,
   output reg rd_mem,
   output reg wr_mem,
   output reg alu_src,
   output reg reg_wr_enable,
   output reg [1:0] mem_to_reg,
   output reg jump
);


always @(*) begin
   reg_wr_enable = 1'b0;
   alu_src       = 1'b0;
   wr_mem        = 1'b0;
   rd_mem        = 1'b0;
   branch        = 1'b0;
   alu_op        = 2'bxx;
   mem_to_reg    = 2'bxx;
   jump          = 1'b0;

   case(opcode) 
      // alu_op codes: 00: add
      //               01: B-type
      //               10: R-type
      //               11: I-type

      7'b0110011 : begin // R-type
      alu_src       = 1'b0;
      reg_wr_enable = 1'b1;
      mem_to_reg    = 2'b00;
      rd_mem        = 1'b0;
      wr_mem        = 1'b0;
      branch        = 1'b0;
      alu_op        = 2'b10;
      end

      7'b0010011 : begin // I-type
      alu_src       = 1'b1;
      reg_wr_enable = 1'b1;
      mem_to_reg    = 2'b00;
      rd_mem        = 1'b0;
      wr_mem        = 1'b0;
      branch        = 1'b0;
      alu_op        = 2'b11;
      end

      7'b0000011 : begin // Loads
      alu_src       = 1'b1;
      mem_to_reg    = 2'b01;
      reg_wr_enable = 1'b1;
      rd_mem        = 1'b1;
      wr_mem        = 1'b0;
      branch        = 1'b0;
      alu_op        = 2'b00;
      end

      7'b0100011 : begin // Stores
      alu_src       = 1'b1;
      reg_wr_enable = 1'b0;
      rd_mem        = 1'b0;
      wr_mem        = 1'b1;
      branch        = 1'b0;
      alu_op        = 2'b00;
      end 

      7'b1100011 : begin // B-type
      alu_src       = 1'b0;
      reg_wr_enable = 1'b0;
      rd_mem        = 1'b0;
      wr_mem        = 1'b0;
      branch        = 1'b1;
      alu_op        = 2'b01;
      end

      7'b1101111 : begin// J-type: jal
      jump          = 1'b1;
      reg_wr_enable = 1'b1;
      mem_to_reg    = 2'b10;
      alu_src       = 1'b0;
      alu_op        = 2'b00;
      end
      
      7'b1100111 : begin// jalr
      alu_op        = 2'b11;
      reg_wr_enable = 1'b1;
      mem_to_reg    = 2'b10;
      alu_src       = 1'b1;
      jump          = 1'b1;
      end

      7'b0110111 : // U-type: lui
      ;
      7'b0010111 : // U-type: auipc
      ;
      7'b1110011 : //ecall & ebreak
      ;
      default : ;
   endcase
end
endmodule
