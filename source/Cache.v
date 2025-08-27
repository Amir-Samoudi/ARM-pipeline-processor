module Cache(
    input clk, rst,
    input rdEn, wrEn,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData,
    output ready,
    // Sram Controller
    input sramReady,
    input [63:0] sramReadData,
    output sramWrEn, sramRdEn
);
    // Cache
    reg [31:0] way0First  [0:63];
    reg [31:0] way0Second [0:63];
    reg [31:0] way1First  [0:63];
    reg [31:0] way1Second [0:63];
    reg [9:0] way0Tag [0:63];
    reg [9:0] way1Tag [0:63];
    reg [63:0] way0Valid;
    reg [63:0] way1Valid;
    reg [63:0] indexLru;

    // Address Decode
    wire [2:0] offset;
    wire [5:0] index;
    wire [9:0] tag;
    assign offset = address[2:0];
    assign index = address[8:3];
    assign tag = address[18:9];

    // Way Decode
    wire [31:0] dataWay0, dataWay1;
    wire [9:0] tagWay0, tagWay1;
    wire validWay0, validWay1;
    assign dataWay0 = (offset[2] == 1'b0) ? way0First[index] : way0Second[index];
    assign dataWay1 = (offset[2] == 1'b0) ? way1First[index] : way1Second[index];
    assign tagWay0 = way0Tag[index];
    assign tagWay1 = way1Tag[index];
    assign validWay0 = way0Valid[index];
    assign validWay1 = way1Valid[index];

    // Hit Controller
    wire hit;
    wire hitWay0, hitWay1;
    assign hitWay0 = (tagWay0 == tag && validWay0 == 1'b1);
    assign hitWay1 = (tagWay1 == tag && validWay1 == 1'b1);
    assign hit = hitWay0 | hitWay1;

    // Data Controller
    wire [31:0] data;
    wire [31:0] readDataQ;
    assign data = hitWay0 ? dataWay0 :
                  hitWay1 ? dataWay1 : 32'dz;
    assign readDataQ = hit ? data :
                       sramReady ? (offset[2] == 1'b0 ? sramReadData[31:0] : sramReadData[63:32]) : 32'bz;
    assign readData = rdEn ? readDataQ : 32'bz;
    assign ready = sramReady;

    // Sram Controller
    assign sramRdEn = ~hit & rdEn;
    assign sramWrEn = wrEn;

    always @(posedge clk) begin
        if (wrEn) begin
            if (hitWay0) begin
                way0Valid[index] = 1'b0;
                indexLru[index] = 1'b1;
            end
            else if (hitWay1) begin
                way1Valid[index] = 1'b0;
                indexLru[index] = 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (rdEn) begin
            if (hit) begin
                indexLru[index] = hitWay1;
            end
            else begin
                if (sramReady) begin
                    if (indexLru[index] == 1'b1) begin
                        {way0Second[index], way0First[index]} = sramReadData;
                        way0Valid[index] = 1'b1;
                        way0Tag[index] = tag;
                        indexLru[index] = 1'b0;
                    end
                    else begin
                        {way1Second[index], way1First[index]} = sramReadData;
                        way1Valid[index] = 1'b1;
                        way1Tag[index] = tag;
                        indexLru[index] = 1'b1;
                    end
                end
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            way0Valid = 64'd0;
            way1Valid = 64'd0;
            indexLru = 64'd0;
        end
    end
endmodule

// module Cache(
//     input clk, rst,
//     input [63:0] write_data,
//     input invalidate, LRU_update,
//     input [18:0] address,
//     input WriteEN, MEM_R_EN,
//     output [31:0] readData,
//     output isHit
// );

//     wire [2:0] offset;
//     wire [5:0] index;
//     wire [9:0] tag;
//     assign offset = address[2:0];
//     assign index = address[8:3];
//     assign tag = address[18:9];


//     wire hit0, hit1;
//     wire  wr_en_LRU, wr_data_LRU, lru;

//     wire wr_en_valid0, wr_en_valid1;
//     wire wr_data_valid0, wr_data_valid1;
//     wire v0, v1;

//     wire wr_en_data0, wr_en_data1;
//     wire [31:0] wr_data_data00, wr_data_data01, wr_data_data10, wr_data_data11;
//     wire [31:0] data00, data01, data00, data01;

//     wire wr_en_tag0 , wr_en_tag1;
//     wire [9:0] wr_data_tag0 , wr_data_tag1;
//     wire [9:0] tag0 , tag1;

//     assign wr_data_valid0 = (invalidate == 0) ? (WriteEN ? 1'b1 : 1'b0) : 1'b0;
//     assign wr_data_valid1 = (invalidate == 0) ? (WriteEN ? 1'b1 : 1'b0) : 1'b0;
//     assign wr_en_valid0 = (hit0 == 1 && invalidate == 1) ? 1'b1 :
//                           (WriteEN == 1'b1 && lru == 1'b1) ? 1'b1 :
//                           1'b0;
//     assign wr_en_valid1 = (hit1 == 1 && invalidate == 1) ? 1'b1 :
//                           (WriteEN == 1'b1 && lru == 1'b0) ? 1'b1 :
//                           1'b0;

//     Memory MEM_Valid0 (WORDLENGHT = 1)(clk, rst, index, wr_en_valid0, wr_data_valid0, v0);
//     Memory MEM_Valid1 (WORDLENGHT = 1)(clk, rst, index, wr_en_valid1, wr_data_valid1, v1);

//     ///
//     assign wr_en_data0 = (writeEN == 1 && lru == 1) ? 1'b1 : 1'b0;
//     assign wr_en_data1 = (writeEN == 1 && lru == 0) ? 1'b1 : 1'b0;
//     assign wr_data_data00 = write_data[31:0];
//     assign wr_data_data01 = write_data[63:32];
//     assign wr_data_data10 = write_data[31:0];
//     assign wr_data_data11 = write_data[63:32];

//     Memory MEM_Data00 (WORDLENGHT = 32)(clk, rst, index, wr_en_data0, wr_data_data00, data00);
//     Memory MEM_Data01 (WORDLENGHT = 32)(clk, rst, index, wr_en_data0, wr_data_data01, data01);
//     Memory MEM_Data10 (WORDLENGHT = 32)(clk, rst, index, wr_en_data1, wr_data_data10, data10);
//     Memory MEM_Data11 (WORDLENGHT = 32)(clk, rst, index, wr_en_data1, wr_data_data11, data11);

//     ///
//     assign wr_data_tag0 = tag;
//     assign wr_data_tag1 = tag;
//     assign wr_en_tag0 = (writeEN == 1 && lru == 1) ? 1'b1 : 1'b0;
//     assign wr_en_tag1 = (writeEN == 1 && lru == 0) ? 1'b1 : 1'b0;

//     Memory MEM_Tag0 (WORDLENGHT = 10)(clk, rst, index, wr_en_tag0, wr_data_tag0, tag0);
//     Memory MEM_Tag1 (WORDLENGHT = 10)(clk, rst, index, wr_en_tag1, wr_data_tag1, tag1);

//     ///

//     assign wr_data_LRU = (WriteEN == 1) ? ((lru == 1) ? 1'b0 : 1'b1) :
//                          ((MEM_R_EN == 1) ? (hit0 == 1 ? 1'b0 : (hit1 == 1) ? 1'b1 : 1'b0) : 1'b0);
//     assign wr_en_LRU = (LRU_update || writeEN) ? 1'b1 : 1'b0;
    
//     Memory MEM_LRU (WORDLENGHT = 1)(clk, rst, index, wr_en_LRU, wr_data_LRU, lru);

    
//     assign hit0 = ((tag == tag0) && v0) ? 1'b1 : 1'b0;
//     assign hit1 = ((tag == tag1) && v1) ? 1'b1 : 1'b0;
//     assign isHit = (hit0 || hit1) ? 1'b1 : 1'b0;
    
//     assign readData = (hit0 == 1 && offset[2] == 0) ? data00 :
//                       (hit0 == 1 && offset[2] == 1) ? data01 :
//                       (hit1 == 1 && offset[2] == 0) ? data10 :
//                       (hit1 == 1 && offset[2] == 1) ? data11 :
//                       32'b0;

// endmodule

