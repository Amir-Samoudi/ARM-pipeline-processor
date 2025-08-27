module Forwarding_Unit(
    input [3:0] src1, src2,
    input [3:0] Mem_Dest,
    input Mem_WB_EN,
    input [3:0] WB_Dest,
    input WB_WB_EN,
    input select_Forwarding,
    output reg [1:0] Sel_src1, Sel_src2
);

    always @(src1, src2, WB_Dest, WB_WB_EN, Mem_Dest, Mem_WB_EN, select_Forwarding) begin
        Sel_src1 = 2'b0;
        Sel_src2 = 2'b0;
        if (select_Forwarding == 1) begin
            if ((src1 == Mem_Dest) && Mem_WB_EN) begin
                Sel_src1 = 2'b01;
            end
            else if ((src1 == WB_Dest) && WB_WB_EN) begin
                Sel_src1 = 2'b10;
            end

            if ((src2 == Mem_Dest) && Mem_WB_EN) begin
                Sel_src2 = 2'b01;
            end
            else if ((src2 == WB_Dest) && WB_WB_EN) begin
                Sel_src2 = 2'b10;
            end
        end
    end

endmodule
