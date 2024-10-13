module AESK (CLK,sel,key,w0,w1,w2,w3);

input sel;
input CLK;
input [127:0] key;  //2b7e151628aed2a6abf7158809cf4f3c
output reg [31:0] w0;
output reg [31:0] w1;
output reg [31:0] w2;
output reg [31:0] w3;
reg [31:0] Rcon [0:9];
parameter m = 8; 
parameter mask = (1 << m) - 1;
parameter p = 27;
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
                bit = ((byte>>i)&1)^((byte>>((i+4)%8))&1)^((byte >> ((i+5)%8))&1)^((byte>>((i+6)%8))&1)^((byte >>((i+7)%8))&1);
                s_box = s_box | (bit ^ ((d >> i) & 1)) << i;
            end
        end
    endfunction
reg [3:0] i;
always @(posedge CLK) begin
	if(sel) begin
		w3= key[31:0];
		w2= key[63:32];
		w1= key[95:64];
		w0= key[127:96];
		//i = 4'b0000;
	end
	else 
		begin		
		w0=w0^(SubWord(RotWord(w3)) ^ Rcon[i]);
		w1=w1^w0;
		w2=w2^w1;
		w3=w3^w2;
		i=(i+1)%10;
	end
end
endmodule
