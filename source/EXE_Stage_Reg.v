module EXE_Stage_Reg(
    input clk,
    input rst,WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
    input[31:0] ALU_result_in, ST_val_in, PC_IN,
    input[3:0] Destin,
    input [3:0] src1_IN, src2_IN,
    input freeze,
    output reg WB_en, MEM_R_EN, MEM_W_EN,
    output reg[31:0] ALU_result, ST_val, PC,
    output reg[3:0] Dest,
    output reg [3:0] src1, src2


);
always @(posedge clk , posedge rst) begin
    if(rst) begin
        {WB_en , MEM_R_EN , MEM_W_EN , ALU_result , ST_val , Dest} <= 71'b0;
        PC <= 0;
        src1 <= 0;
        src2 <= 0;
    end
    else if (freeze == 0) begin
      WB_en <= WB_en_in;
      MEM_R_EN <= MEM_R_EN_in;
      MEM_W_EN <= MEM_W_EN_in;
      ALU_result <= ALU_result_in;
      ST_val <= ST_val_in;  //Val_Rm
      Dest <= Destin;
      PC <= PC_IN;
      src1 <= src1_IN;
      src2 <= src2_IN;
     end
end
    

endmodule
