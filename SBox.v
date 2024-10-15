module SBox (
    input [127:0] state_in, // 128-bit 輸入資料
    output [127:0] state_out // 128-bit 輸出資料 (經過 SubBytes 替換)
);
    
    // 使用 s_box 函數替換每個 byte
    parameter m = 8; 
    parameter mask = (1 << m) - 1;
    parameter p = 27;
	 function [7:0] GFM;
        input [7:0] a;
        input [7:0] b;
        integer i;
        begin
            GFM = 0;
            for (i = m-1; i > 0; i = i - 1) begin
                GFM = GFM ^ (((a >> i) & 8'h01) * b);
                GFM = ((GFM << 1) & mask) ^ (((GFM >> (m-1)) & 8'h01) * p);
            end
            GFM = GFM ^ ((a & 8'h01) * b);
        end
    endfunction

    function [7:0] inv1;
        input [7:0] a;
        reg [7:0] a2;
        integer i;
        begin
            inv1 = 8'h01;
            a2 = GFM(a, a);
            inv1 = GFM(inv1, a2);
            for (i = 0; i < 6; i = i + 1) begin
                a2 = GFM(a2, a2);
                inv1 = GFM(inv1, a2);
            end
        end
    endfunction
	 function [7:0] s_box;
        input [7:0] byte;
        reg [7:0] d;
        reg bit;
        integer i;
        begin
            d = 8'h63;
            s_box = 8'h00;
            byte = inv1(byte); // 使用反元素運算
            for (i = 0; i < 8; i = i + 1) begin
                bit = ((byte >> i) & 1) ^ ((byte >> ((i + 4) % 8)) & 1) ^ 
                      ((byte >> ((i + 5) % 8)) & 1) ^ ((byte >> ((i + 6) % 8)) & 1) ^ 
                      ((byte >> ((i + 7) % 8)) & 1);
                s_box = s_box | (bit ^ ((d >> i) & 1)) << i;
            end
        end
    endfunction

    // 將 128-bit 輸入拆分成 16 個 byte，進行 S-Box 替換
    assign state_out[127:120] = s_box(state_in[127:120]);
    assign state_out[119:112] = s_box(state_in[119:112]);
    assign state_out[111:104] = s_box(state_in[111:104]);
    assign state_out[103:96]  = s_box(state_in[103:96]);
    assign state_out[95:88]   = s_box(state_in[95:88]);
    assign state_out[87:80]   = s_box(state_in[87:80]);
    assign state_out[79:72]   = s_box(state_in[79:72]);
    assign state_out[71:64]   = s_box(state_in[71:64]);
    assign state_out[63:56]   = s_box(state_in[63:56]);
    assign state_out[55:48]   = s_box(state_in[55:48]);
    assign state_out[47:40]   = s_box(state_in[47:40]);
    assign state_out[39:32]   = s_box(state_in[39:32]);
    assign state_out[31:24]   = s_box(state_in[31:24]);
    assign state_out[23:16]   = s_box(state_in[23:16]);
    assign state_out[15:8]    = s_box(state_in[15:8]);
    assign state_out[7:0]     = s_box(state_in[7:0]);
    
endmodule
