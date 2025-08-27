
module MEM_Reg(
input clk, rst, WB_en_in, MEM_R_en_in,
input [31:0] ALU_result_in, Mem_read_value_in,
input [3:0] Dest_in, src1_in, src2_in,
input freeze,
output reg WB_en, MEM_R_en,
output reg[31:0] ALU_result, Mem_read_value,
output reg [3:0] Dest, src1, src2

);
always @(posedge clk , posedge rst) begin
    if(rst)begin
      ALU_result <= 32'b0;
      Mem_read_value <= 32'b0;
      Dest <= 4'b0;
      WB_en <= 1'b0;
      MEM_R_en <= 1'b0;
      src1 <= 0;
      src2 <= 0;
    end
    else if (freeze == 0) begin
      ALU_result <= ALU_result_in;
      Mem_read_value <= Mem_read_value_in;
      Dest <= Dest_in;
      WB_en <= WB_en_in;
      MEM_R_en <= MEM_R_en_in;
      src1 <= src1_in;
      src2 <= src2_in;
    end
end

endmodule