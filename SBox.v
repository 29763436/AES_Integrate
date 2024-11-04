module SBox (
    input [7:0] B,  // 8-byte input B
    output [7:0] D // 8-byte output D
);

    // Intermediate wires for T, F, G calculations
    wire [7:0] GFM_T0_a, GFM_T0_b, GFM_T1_a, GFM_T1_b, GFM_T2_a, GFM_T2_b, GFM_T3_a, GFM_T3_b;
    wire [7:0] GFM_F0_a, GFM_F0_b, GFM_F1_a, GFM_F1_b, GFM_F2_a, GFM_F2_b, GFM_F3_a, GFM_F3_b;
    wire [7:0] GFM_G0_a, GFM_G0_b, GFM_G1_a, GFM_G1_b, GFM_G2_a, GFM_G2_b, GFM_G3_a, GFM_G3_b;
    wire [7:0] GFM_T0_c, GFM_T0_d, GFM_T1_c, GFM_T1_d, GFM_T2_c, GFM_T2_d, GFM_T3_c, GFM_T3_d;
    wire [7:0] GFM_F0_c, GFM_F0_d, GFM_F1_c, GFM_F1_d, GFM_F2_c, GFM_F2_d, GFM_F3_c, GFM_F3_d;
    wire [7:0] GFM_G0_c, GFM_G0_d, GFM_G1_c, GFM_G1_d, GFM_G2_c, GFM_G2_d, GFM_G3_c, GFM_G3_d;

    wire [7:0] GFM_T0, GFM_T1, GFM_T2, GFM_T3;
    wire [7:0] GFM_F0, GFM_F1, GFM_F2, GFM_F3;
    wire [7:0] GFM_G0, GFM_G1, GFM_G2, GFM_G3;
	 
	 wire [7:0] b; 
    
    // Constants for C vector
    wire [7:0] C[0:7];
    assign C[0] = 8'h1; assign C[1] = 8'h1; assign C[2] = 8'h0; assign C[3] = 8'h0;
    assign C[4] = 8'h0; assign C[5] = 8'h1; assign C[6] = 8'h1; assign C[7] = 8'h0;
	 
	 ninv n0(.I(B), .O(b));

	 
    // T calculation
    GFM gfm_T0_1 (.a(8'h01), .b(b[0] ^ b[4]), .c(GFM_T0_a)); 
    GFM gfm_T0_2 (.a(8'h01), .b(b[1] ^ b[5]), .c(GFM_T0_b)); 
	 GFM gfm_T0_3 (.a(8'h01), .b(b[2] ^ b[6]), .c(GFM_T0_c)); 
    GFM gfm_T0_4 (.a(8'h01), .b(b[3] ^ b[7]), .c(GFM_T0_d)); 

    GFM gfm_T1_1 (.a(8'h00), .b(b[0] ^ b[4]), .c(GFM_T1_a)); 
    GFM gfm_T1_2 (.a(8'h01), .b(b[1] ^ b[5]), .c(GFM_T1_b)); 
    GFM gfm_T1_3 (.a(8'h01), .b(b[2] ^ b[6]), .c(GFM_T1_c)); 
    GFM gfm_T1_4 (.a(8'h01), .b(b[3] ^ b[7]), .c(GFM_T1_d)); 

    GFM gfm_T2_1 (.a(8'h00), .b(b[0] ^ b[4]), .c(GFM_T2_a));  
    GFM gfm_T2_2 (.a(8'h00), .b(b[1] ^ b[5]), .c(GFM_T2_b));  
    GFM gfm_T2_3 (.a(8'h01), .b(b[2] ^ b[6]), .c(GFM_T2_c));  
    GFM gfm_T2_4 (.a(8'h01), .b(b[3] ^ b[7]), .c(GFM_T2_d)); 

    GFM gfm_T3_1 (.a(8'h00), .b(b[0] ^ b[4]), .c(GFM_T3_a)); 
    GFM gfm_T3_2 (.a(8'h00), .b(b[1] ^ b[5]), .c(GFM_T3_b)); 
    GFM gfm_T3_3 (.a(8'h00), .b(b[2] ^ b[6]), .c(GFM_T3_c)); 
    GFM gfm_T3_4 (.a(8'h01), .b(b[3] ^ b[7]), .c(GFM_T3_d)); 

    // F calculation
    GFM gfm_F0_1 (.a(8'h01 ^ 8'h01), .b(b[0]), .c(GFM_F0_a)); 
    GFM gfm_F0_2 (.a(8'h00 ^ 8'h01), .b(b[1]), .c(GFM_F0_b));
    GFM gfm_F0_3 (.a(8'h00 ^ 8'h01), .b(b[2]), .c(GFM_F0_c)); 
    GFM gfm_F0_4 (.a(8'h00 ^ 8'h01), .b(b[3]), .c(GFM_F0_d));	 

    GFM gfm_F1_1 (.a(8'h01 ^ 8'h00), .b(b[0]), .c(GFM_F1_a)); 
    GFM gfm_F1_2 (.a(8'h01 ^ 8'h01), .b(b[1]), .c(GFM_F1_b)); 
    GFM gfm_F1_3 (.a(8'h00 ^ 8'h01), .b(b[2]), .c(GFM_F1_c)); 
    GFM gfm_F1_4 (.a(8'h00 ^ 8'h01), .b(b[3]), .c(GFM_F1_d)); 

    GFM gfm_F2_1 (.a(8'h01 ^ 8'h00), .b(b[0]), .c(GFM_F2_a));  
    GFM gfm_F2_2 (.a(8'h01 ^ 8'h00), .b(b[1]), .c(GFM_F2_b));  
	 GFM gfm_F2_3 (.a(8'h01 ^ 8'h01), .b(b[2]), .c(GFM_F2_c));  
    GFM gfm_F2_4 (.a(8'h00 ^ 8'h01), .b(b[3]), .c(GFM_F2_d));  

    GFM gfm_F3_1 (.a(8'h01 ^ 8'h00), .b(b[0]), .c(GFM_F3_a)); 
    GFM gfm_F3_2 (.a(8'h01 ^ 8'h00), .b(b[1]), .c(GFM_F3_b)); 
	 GFM gfm_F3_3 (.a(8'h01 ^ 8'h00), .b(b[2]), .c(GFM_F3_c)); 
    GFM gfm_F3_4 (.a(8'h01 ^ 8'h01), .b(b[3]), .c(GFM_F3_d)); 

    // G calculation
    GFM gfm_G0_1 (.a(8'h01 ^ 8'h01), .b(b[4]), .c(GFM_G0_a)); 
    GFM gfm_G0_2 (.a(8'h00 ^ 8'h01), .b(b[5]), .c(GFM_G0_b)); 
    GFM gfm_G0_3 (.a(8'h00 ^ 8'h01), .b(b[6]), .c(GFM_G0_c)); 
    GFM gfm_G0_4 (.a(8'h00 ^ 8'h01), .b(b[7]), .c(GFM_G0_d));  

    GFM gfm_G1_1 (.a(8'h01 ^ 8'h00), .b(b[4]), .c(GFM_G1_a)); 
    GFM gfm_G1_2 (.a(8'h01 ^ 8'h01), .b(b[5]), .c(GFM_G1_b));  
    GFM gfm_G1_3 (.a(8'h00 ^ 8'h01), .b(b[6]), .c(GFM_G1_c)); 
    GFM gfm_G1_4 (.a(8'h00 ^ 8'h01), .b(b[7]), .c(GFM_G1_d));

    GFM gfm_G2_1 (.a(8'h01 ^ 8'h00), .b(b[4]), .c(GFM_G2_a)); 
    GFM gfm_G2_2 (.a(8'h01 ^ 8'h00), .b(b[5]), .c(GFM_G2_b));  
    GFM gfm_G2_3 (.a(8'h01 ^ 8'h01), .b(b[6]), .c(GFM_G2_c)); 
    GFM gfm_G2_4 (.a(8'h00 ^ 8'h01), .b(b[7]), .c(GFM_G2_d)); 

    GFM gfm_G3_1 (.a(8'h01 ^ 8'h00), .b(b[4]), .c(GFM_G3_a));  
    GFM gfm_G3_2 (.a(8'h01 ^ 8'h00), .b(b[5]), .c(GFM_G3_b)); 
    GFM gfm_G3_3 (.a(8'h01 ^ 8'h00), .b(b[6]), .c(GFM_G3_c));  
    GFM gfm_G3_4 (.a(8'h01 ^ 8'h01), .b(b[7]), .c(GFM_G3_d)); 

    // combine GFM results
    assign GFM_T0 = GFM_T0_a ^ GFM_T0_b ^ GFM_T0_c ^ GFM_T0_d;
    assign GFM_T1 = GFM_T1_a ^ GFM_T1_b ^ GFM_T1_c ^ GFM_T1_d;
    assign GFM_T2 = GFM_T2_a ^ GFM_T2_b ^ GFM_T2_c ^ GFM_T2_d;
    assign GFM_T3 = GFM_T3_a ^ GFM_T3_b ^ GFM_T3_c ^ GFM_T3_d;

    assign GFM_F0 = GFM_F0_a ^ GFM_F0_b ^ GFM_F0_c ^ GFM_F0_d;
    assign GFM_F1 = GFM_F1_a ^ GFM_F1_b ^ GFM_F1_c ^ GFM_F1_d;
    assign GFM_F2 = GFM_F2_a ^ GFM_F2_b ^ GFM_F2_c ^ GFM_F2_d;
    assign GFM_F3 = GFM_F3_a ^ GFM_F3_b ^ GFM_F3_c ^ GFM_F3_d;

    assign GFM_G0 = GFM_G0_a ^ GFM_G0_b ^ GFM_G0_c ^ GFM_G0_d;
    assign GFM_G1 = GFM_G1_a ^ GFM_G1_b ^ GFM_G1_c ^ GFM_G1_d;
    assign GFM_G2 = GFM_G2_a ^ GFM_G2_b ^ GFM_G2_c ^ GFM_G2_d;
    assign GFM_G3 = GFM_G3_a ^ GFM_G3_b ^ GFM_G3_c ^ GFM_G3_d;

    // Final output D calculation (similar to Python)
    assign D[0] = GFM_T0 ^ GFM_F0 ^ C[0];
    assign D[1] = GFM_T1 ^ GFM_F1 ^ C[1];
    assign D[2] = GFM_T2 ^ GFM_F2 ^ C[2];
    assign D[3] = GFM_T3 ^ GFM_F3 ^ C[3];
    assign D[4] = GFM_T0 ^ GFM_G0 ^ C[4];
    assign D[5] = GFM_T1 ^ GFM_G1 ^ C[5];
    assign D[6] = GFM_T2 ^ GFM_G2 ^ C[6];
    assign D[7] = GFM_T3 ^ GFM_G3 ^ C[7];

endmodule
