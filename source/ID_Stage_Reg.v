module ID_Stage_Reg (

input clk, rst, flush,
input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
input B_IN,S_IN,
input [3:0] EXE_CMD_IN,
input [31:0] PC_IN,
input [31:0] Val_Rn_IN, Val_Rm_IN,
input imm_IN,
input [11:0] Shift_operand_IN,
input [23:0] Signed_imm_24_IN,
input [3:0] Dest_IN,
input [3:0] Dest_from_EXE_IN,
input [3:0] src1_in, src2_in,
input freeze,

output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S,
output reg [3:0] EXE_CMD,
output reg [31:0] PC,
output reg [31:0] Val_Rn, Val_Rm,
output reg imm,
output reg[11:0] Shift_operand,
output reg [23:0] Signed_imm_24,
output reg [3:0] Dest, Dest_from_EXE,
output reg [3:0] src1, src2
);

    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, PC,
            Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Dest_from_EXE} <= 150'b0;
            src1 <= 0;
            src2 <= 0;
        end
        else if (flush == 1'b1) begin
            {WB_EN, MEM_R_EN, MEM_W_EN, B, S, EXE_CMD, PC,
            Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24, Dest, Dest_from_EXE} <= 150'b0;
            src1 <= 0;
            src2 <= 0;
        end
        else if (freeze == 0) begin
            WB_EN <= WB_EN_IN;
            MEM_R_EN <= MEM_R_EN_IN;
            MEM_W_EN <= MEM_W_EN_IN;
            B <= B_IN;
            S <= S_IN;
            EXE_CMD <= EXE_CMD_IN;
            PC <= PC_IN;
            Val_Rn <= Val_Rn_IN;
            Val_Rm <= Val_Rm_IN;
            imm <= imm_IN;
            Shift_operand <= Shift_operand_IN;
            Signed_imm_24 <= Signed_imm_24_IN;
            Dest <= Dest_IN;
            Dest_from_EXE <= Dest_from_EXE_IN;
            src1 <= src1_in;
            src2 <= src2_in;
        end
        
    end
endmodule
