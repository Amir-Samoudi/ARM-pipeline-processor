module hazard_Detection_Unit(

input [3:0]src1,
input [3:0]src2,
input [3:0] Exe_Dest,
input Exe_WB_EN,
input EXE_Mem_R_EN,
input [3:0] Mem_Dest,
input Mem_WB_EN,
input Two_src,
input select_Forwarding,
output reg hazard
);

  always @(src1, src2, Exe_Dest, Mem_Dest, Exe_WB_EN, Mem_WB_EN, Two_src, select_Forwarding, EXE_Mem_R_EN) begin
      hazard = 1'b0;
        if (select_Forwarding == 0) begin  // No Forwarding
            if (Exe_WB_EN) begin
                if (src1 == Exe_Dest || (Two_src && src2 == Exe_Dest)) begin
                    hazard = 1'b1;
                end
            end
            if (Mem_WB_EN) begin
                if (src1 == Mem_Dest || (Two_src && src2 == Mem_Dest)) begin
                    hazard = 1'b1;
                end
            end
        end
        else if (select_Forwarding == 1) begin  //Forwarding
            if (EXE_Mem_R_EN == 1) begin
                if ((src1 == Exe_Dest) || (Two_src && (src2 == Exe_Dest))) begin
                    hazard = 1'b1;
                end
            end
        end
              
    end


endmodule
