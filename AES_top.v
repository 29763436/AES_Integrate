module AES_top (
    input wire CLK,                 // 時鐘信號
    input wire reset,               // 重置信號 (低電平有效)
    input wire start,               // 開始加密的信號
    input wire [127:0] in,          // 128-bit input block
    input wire [127:0] key,         // 128-bit key (AES-128)
    output reg [127:0] out,
	 //output reg [127:0] rok
	 //output reg [127:0] sb,
	 //output reg [127:0] mix,
    output reg ready	 
);

    reg [127:0] state;
    wire [127:0] roundKey;
    reg [3:0] round;
    reg sel; // 控制 `AESK` 啟動
    reg aesk_reset; // 控制 `AESK` 重置
    wire [127:0] mixed_state;
	 reg [127:0] in_state;
	 reg [127:0] min_state;
	 wire [127:0] sbox_state;
	 reg rd;
    // 使用新的 AESK 模組
    Keyexpansion key_expansion (
        .rd(rd),
		  .CLK(CLK),
        .sel(sel),
        .key(key),
        .rk(roundKey)
    );
	 SBox Sbox_inst (
		  .state_in(in_state),
		  .state_out(sbox_state)
	 );
	 MixColumns Mix_inst (
		  .B(min_state), 
		  .D(mixed_state)
	 );
	 function [127:0] ShiftRows;
    input [127:0] state;
    reg [127:0] shifted_state;
    begin
        shifted_state[127:120] = state[127:120]; // No shift for byte 0
        shifted_state[119:112] = state[87:80];   // Shift byte 4 to position of byte 1
        shifted_state[111:104] = state[47:40];   // Shift byte 8 to position of byte 2
        shifted_state[103:96]  = state[7:0];     // Shift byte 12 to position of byte 3

        shifted_state[95:88]   = state[95:88];   // No shift for byte 5
        shifted_state[87:80]   = state[55:48];   // Shift byte 9 to position of byte 6
        shifted_state[79:72]   = state[15:8];    // Shift byte 13 to position of byte 7
        shifted_state[71:64]   = state[103:96];  // Shift byte 1 to position of byte 4

        shifted_state[63:56]   = state[63:56];   // No shift for byte 10
        shifted_state[55:48]   = state[23:16];   // Shift byte 14 to position of byte 11
        shifted_state[47:40]   = state[111:104]; // Shift byte 2 to position of byte 8
        shifted_state[39:32]   = state[71:64];   // Shift byte 6 to position of byte 9

        shifted_state[31:24]   = state[31:24];   // No shift for byte 15
        shifted_state[23:16]   = state[119:112]; // Shift byte 3 to position of byte 12
        shifted_state[15:8]    = state[79:72];   // Shift byte 7 to position of byte 13
        shifted_state[7:0]     = state[39:32];   // Shift byte 11 to position of byte 14

        // Return the shifted state
        ShiftRows = shifted_state;
    end
	 endfunction
    // FSM 狀態控制
    reg [1:0] state_reg;
	 reg [1:0] t;
    localparam IDLE = 2'b00, INIT = 2'b01, ROUND = 2'b10, FINAL = 2'b11;
    localparam t1 = 2'b00, t2 = 2'b01, t3 = 2'b10, t4 = 2'b11;
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            round = 0;
            out = 0;
            sel = 1;
				rd=0;
				ready = 0;
				t<=t1;
        end else begin
            case (state_reg)
                IDLE: begin
                    if (start) begin
                        state = in;
								ready = 0;
                        round = 0;
                        sel = 1;
								rd=0;
                        state_reg <= INIT;
                    end
                end
                
                INIT: begin
                    //sb = roundKey;
						  state = state ^ roundKey;
						  in_state=state;
						  sel <= 0;
						  rd=1;
						  t<=t1;
                    state_reg <= ROUND;
                end
                
                ROUND: begin
                    case (t)
								t1: begin
									state=sbox_state;
									rd<=0;
									t<=t2;
									end
								 t2:begin
									state = ShiftRows(state);
									min_state=state;
									t<=t3;
									end
								 t3:begin
									state=mixed_state;
									t<=t4;
									rd<=1;
									end
								 t4:begin
						         //sb = roundKey;    
								   state = state ^ roundKey;
									in_state=state;
								   round = round + 1;
									t<=t1;
									rd=0;
								   if (round > 8) begin
										state_reg <= FINAL;
										rd=1;
										end
									end
							endcase
                end
                
                FINAL: begin
						  state=sbox_state;
                    state = ShiftRows(state);
						  //sb = roundKey;
                    state = state ^ roundKey; // Final AddRoundKey
                    out = state; // 輸出加密結果
                    state_reg <= IDLE; // 回到閒置狀態
						  ready = 1;
						  sel <= 1;
                end
            endcase
        end
    end
endmodule
