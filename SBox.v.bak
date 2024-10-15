module SBox(
    input [7:0] B0, B1, B2, B3, B4, B5, B6, B7, // 8-byte input matrix B
    output [7:0] D0, D1, D2, D3, D4, D5, D6, D7 // 8-byte output matrix D
);

    // Coefficients matrix C
    wire [7:0] C[7:0];
    assign C[0] = 8'h01;
    assign C[1] = 8'h01;
    assign C[2] = 8'h00;
    assign C[3] = 8'h00;
    assign C[4] = 8'h00;
    assign C[5] = 8'h01;
    assign C[6] = 8'h01;
    assign C[7] = 8'h00;

    // Wires for GFM results
    wire [7:0] GFM_result_T[3:0];
    wire [7:0] GFM_result_F[3:0];
    wire [7:0] GFM_result_G[3:0];

    // Temp wires for intermediate results
    wire [7:0] T[3:0];
    wire [7:0] F[3:0];
    wire [7:0] G[3:0];

    // Instantiate GFM modules for each operation
    GFM gfm_T0 (.a(8'h01), .b(B0 ^ B4), .c(GFM_result_T[0]));
    GFM gfm_T1 (.a(8'h01), .b(B1 ^ B5), .c(GFM_result_T[1]));
    GFM gfm_T2 (.a(8'h01), .b(B2 ^ B6), .c(GFM_result_T[2]));
    GFM gfm_T3 (.a(8'h01), .b(B3 ^ B7), .c(GFM_result_T[3]));

    GFM gfm_F0 (.a(8'h01), .b(B0 ^ B1), .c(GFM_result_F[0]));
    GFM gfm_F1 (.a(8'h01), .b(B2 ^ B3), .c(GFM_result_F[1]));
    GFM gfm_F2 (.a(8'h01), .b(B4 ^ B5), .c(GFM_result_F[2]));
    GFM gfm_F3 (.a(8'h01), .b(B6 ^ B7), .c(GFM_result_F[3]));

    GFM gfm_G0 (.a(8'h01), .b(B0 ^ B1), .c(GFM_result_G[0]));
    GFM gfm_G1 (.a(8'h01), .b(B2 ^ B3), .c(GFM_result_G[1]));
    GFM gfm_G2 (.a(8'h01), .b(B4 ^ B5), .c(GFM_result_G[2]));
    GFM gfm_G3 (.a(8'h01), .b(B6 ^ B7), .c(GFM_result_G[3]));

    // Calculate the T, F, and G matrices
    assign T[0] = GFM_result_T[0];
    assign T[1] = GFM_result_T[1];
    assign T[2] = GFM_result_T[2];
    assign T[3] = GFM_result_T[3];

    assign F[0] = GFM_result_F[0];
    assign F[1] = GFM_result_F[1];
    assign F[2] = GFM_result_F[2];
    assign F[3] = GFM_result_F[3];

    assign G[0] = GFM_result_G[0];
    assign G[1] = GFM_result_G[1];
    assign G[2] = GFM_result_G[2];
    assign G[3] = GFM_result_G[3];

    // Calculate the D matrix
    assign D0 = T[0] ^ F[0] ^ C[0];
    assign D1 = T[1] ^ F[1] ^ C[1];
    assign D2 = T[2] ^ F[2] ^ C[2];
    assign D3 = T[3] ^ F[3] ^ C[3];
    assign D4 = T[0] ^ G[0] ^ C[4];
    assign D5 = T[1] ^ G[1] ^ C[5];
    assign D6 = T[2] ^ G[2] ^ C[6];
    assign D7 = T[3] ^ G[3] ^ C[7];

endmodule
