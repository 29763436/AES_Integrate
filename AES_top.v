module AES_Cipher (
    input wire CLK,                 // 時鐘信號
    input wire reset,               // 重置信號 (低電平有效)
    input wire start,               // 開始加密的信號
    input wire [127:0] in,          // 128-bit input block
    input wire [127:0] key,         // 128-bit key (AES-128)
    output reg [127:0] out          // 128-bit output block
);

    reg [127:0] state;
    wire [127:0] roundKey;
    reg [3:0] round;
    reg sel; // 控制 `AESK` 啟動
    reg aesk_reset; // 控制 `AESK` 重置
    
    // 使用新的 AESK 模組
    Keyexpansion key_expansion (
        .CLK(CLK),
        .reset(aesk_reset),
        .sel(sel),
        .key(key),
        .rk(roundKey)
    );

    // FSM 狀態控制
    reg [1:0] state_reg;
    localparam IDLE = 2'b00, INIT = 2'b01, ROUND = 2'b10, FINAL = 2'b11;
    
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            round <= 0;
            out <= 0;
            sel <= 0;
            aesk_reset <= 1; // 重置 AESK 模組
        end else begin
            case (state_reg)
                IDLE: begin
                    if (start) begin
                        state <= in;
                        round <= 0;
                        sel <= 1;  // 啟動 `AESK` 生成第一個 roundKey
                        aesk_reset <= 0; // 確保 AESK 不被重置
                        state_reg <= INIT;
                    end
                end
                
                INIT: begin
                    state = state ^ roundKey; // Initial AddRoundKey
                    sel <= 0; // 後續需要使用生成的 `roundKey`
                    state_reg <= ROUND;
                end
                
                ROUND: begin
                    if (round < 9) begin
                        // 每一輪的加密操作
                        state = SubBytes(state);
                        state = ShiftRows(state);
                        state = MixColumns(state);
                        state = state ^ roundKey;  // AddRoundKey
                        round <= round + 1;
                        sel <= 0; // 繼續生成下一個 roundKey
                    end else begin
                        state_reg <= FINAL;
                    end
                end
                
                FINAL: begin
                    state = SubBytes(state);
                    state = ShiftRows(state);
                    state = state ^ roundKey; // Final AddRoundKey
                    out <= state; // 輸出加密結果
                    state_reg <= IDLE; // 回到閒置狀態
                    aesk_reset <= 1; // 重置 `AESK`，準備下一次加密
                end
            endcase
        end
    end
endmodule
