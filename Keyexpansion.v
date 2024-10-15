module Keyexpansion (CLK, reset, sel, key, rk);

    input sel;
    input CLK;
    input reset;           // 新增 reset 端口
    input [127:0] key;     // 2b7e151628aed2a6abf7158809cf4f3c
    output reg [127:0] rk;

    reg [31:0] Rcon [0:9];
    parameter m = 8; 
    parameter mask = (1 << m) - 1;
    parameter p = 27;

    reg [3:0] i;           // 記錄現在第幾輪 round key

    initial begin
        Rcon[0] = 32'h01000000;
        Rcon[1] = 32'h02000000;
        Rcon[2] = 32'h04000000;
        Rcon[3] = 32'h08000000;
        Rcon[4] = 32'h10000000;
        Rcon[5] = 32'h20000000;
        Rcon[6] = 32'h40000000;
        Rcon[7] = 32'h80000000;
        Rcon[8] = 32'h1b000000;
        Rcon[9] = 32'h36000000;
    end

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

    function [31:0] RotWord;
        input [31:0] value;
        begin
            RotWord = ((value << 8) & 32'hffffffff) | (value >> 24);
        end
    endfunction

    function [31:0] SubWord;
        input [31:0] temp;
        begin
            integer i;
            SubWord = 32'h0;
            for (i = 3; i >= 0; i = i - 1) begin
                SubWord = SubWord | (s_box(inv1((temp >> (i * 8)) & 8'hff)) << (i * 8));
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
            for (i = 0; i < 8; i = i + 1) begin
                bit = ((byte >> i) & 1) ^ ((byte >> ((i + 4) % 8)) & 1) ^ 
                      ((byte >> ((i + 5) % 8)) & 1) ^ ((byte >> ((i + 6) % 8)) & 1) ^ 
                      ((byte >> ((i + 7) % 8)) & 1);
                s_box = s_box | (bit ^ ((d >> i) & 1)) << i;
            end
        end
    endfunction

    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            rk = 128'b0; // 重置 rk 為 0
            i = 0;       // 重置輪次計數器
        end else if (sel) begin
            rk = key;
            i = 0;
        end else begin
            if (i < 10) begin
                rk[127:96] = rk[127:96] ^ (SubWord(RotWord(rk[31:0])) ^ Rcon[i]);
                rk[95:64] = rk[95:64] ^ rk[127:96];
                rk[63:32] = rk[63:32] ^ rk[95:64];
                rk[31:0] = rk[31:0] ^ rk[63:32];
                i = i + 1;
            end
        end
    end
endmodule
