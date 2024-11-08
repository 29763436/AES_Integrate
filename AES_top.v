module AES_top (
    input wire CLK,                 // 時鐘信號
    input wire reset,               // 重置信號 (低電平有效)
    input wire start,               // 開始加密的信號
    input wire [127:0] in,          // 128-bit input block
    input wire [127:0] key,         // 128-bit key (AES-128)
    output reg [127:0] out,
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

    Keyexpansion key_expansion (
        .rd(rd),
		  .CLK(CLK),
        .sel(sel),
        .key(key),
        .rk(roundKey)
    );
	 SBox Sbox15 (.B(in_state[127:120]),.D(sbox_state[127:120]));
	 SBox Sbox14 (.B(in_state[119:112]),.D(sbox_state[119:112]));
	 SBox Sbox13 (.B(in_state[111:104]),.D(sbox_state[111:104]));
	 SBox Sbox12 (.B(in_state[103:96]),.D(sbox_state[103:96]));
	 SBox Sbox11 (.B(in_state[95:88]),.D(sbox_state[95:88]));
	 SBox Sbox10 (.B(in_state[87:80]),.D(sbox_state[87:80]));
	 SBox Sbox9 (.B(in_state[79:72]),.D(sbox_state[79:72]));
	 SBox Sbox8 (.B(in_state[71:64]),.D(sbox_state[71:64]));
	 SBox Sbox7 (.B(in_state[63:56]),.D(sbox_state[63:56]));
	 SBox Sbox6 (.B(in_state[55:48]),.D(sbox_state[55:48]));
	 SBox Sbox5 (.B(in_state[47:40]),.D(sbox_state[47:40]));
	 SBox Sbox4 (.B(in_state[39:32]),.D(sbox_state[39:32]));
	 SBox Sbox3 (.B(in_state[31:24]),.D(sbox_state[31:24]));
	 SBox Sbox2 (.B(in_state[23:16]),.D(sbox_state[23:16]));
	 SBox Sbox1 (.B(in_state[15:8]),.D(sbox_state[15:8]));
	 SBox Sbox0 (.B(in_state[7:0]),.D(sbox_state[7:0]));
	 
	 MixColumns Mix_inst (
		  .B(min_state), 
		  .D(mixed_state)
	 );
	 function [127:0] ShiftRows;
    input [127:0] state;
    reg [127:0] shifted_state;
    begin
        shifted_state[127:120] = state[127:120]; 
        shifted_state[119:112] = state[87:80];   
        shifted_state[111:104] = state[47:40];   
        shifted_state[103:96]  = state[7:0];     

        shifted_state[95:88]   = state[95:88];   
        shifted_state[87:80]   = state[55:48];   
        shifted_state[79:72]   = state[15:8];    
        shifted_state[71:64]   = state[103:96];  

        shifted_state[63:56]   = state[63:56]; 
        shifted_state[55:48]   = state[23:16];  
        shifted_state[47:40]   = state[111:104]; 
        shifted_state[39:32]   = state[71:64];   

        shifted_state[31:24]   = state[31:24];   
        shifted_state[23:16]   = state[119:112]; 
        shifted_state[15:8]    = state[79:72];
        shifted_state[7:0]     = state[39:32];   
        ShiftRows = shifted_state;
    end
	 endfunction
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
                    state = state ^ roundKey;
                    out = state; // 輸出加密結果
                    state_reg <= IDLE; // 回到閒置狀態
						  ready = 1;
						  sel <= 1;
                end
            endcase
        end
    end
endmodule
