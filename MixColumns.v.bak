module MixColumns(
    input  [7:0] B0, B1, B2, B3,  // 4 input bytes
    output [7:0] D0, D1, D2, D3   // 4 output bytes
);
    wire [7:0] A [3:0][3:0];      // Matrix A for MixColumns
    wire [7:0] tmp0, tmp1, tmp2, tmp3;

    // MixColumns matrix (AES standard)
    assign A[0][0] = 8'h02; assign A[0][1] = 8'h03; assign A[0][2] = 8'h01; assign A[0][3] = 8'h01;
    assign A[1][0] = 8'h01; assign A[1][1] = 8'h02; assign A[1][2] = 8'h03; assign A[1][3] = 8'h01;
    assign A[2][0] = 8'h01; assign A[2][1] = 8'h01; assign A[2][2] = 8'h02; assign A[2][3] = 8'h03;
    assign A[3][0] = 8'h03; assign A[3][1] = 8'h01; assign A[3][2] = 8'h01; assign A[3][3] = 8'h02;

    // Output wires for GFM results
    wire [7:0] GFM_00, GFM_01, GFM_02, GFM_03;
    wire [7:0] GFM_10, GFM_11, GFM_12, GFM_13;
    wire [7:0] GFM_20, GFM_21, GFM_22, GFM_23;
    wire [7:0] GFM_30, GFM_31, GFM_32, GFM_33;

    // Perform GFM operations (matrix multiplication in GF(2^8))
    GFM gfm00 (.a(A[0][0]), .b(B0), .c(GFM_00));
    GFM gfm01 (.a(A[0][1]), .b(B1), .c(GFM_01));
    GFM gfm02 (.a(A[0][2]), .b(B2), .c(GFM_02));
    GFM gfm03 (.a(A[0][3]), .b(B3), .c(GFM_03));

    GFM gfm10 (.a(A[1][0]), .b(B0), .c(GFM_10));
    GFM gfm11 (.a(A[1][1]), .b(B1), .c(GFM_11));
    GFM gfm12 (.a(A[1][2]), .b(B2), .c(GFM_12));
    GFM gfm13 (.a(A[1][3]), .b(B3), .c(GFM_13));

    GFM gfm20 (.a(A[2][0]), .b(B0), .c(GFM_20));
    GFM gfm21 (.a(A[2][1]), .b(B1), .c(GFM_21));
    GFM gfm22 (.a(A[2][2]), .b(B2), .c(GFM_22));
    GFM gfm23 (.a(A[2][3]), .b(B3), .c(GFM_23));

    GFM gfm30 (.a(A[3][0]), .b(B0), .c(GFM_30));
    GFM gfm31 (.a(A[3][1]), .b(B1), .c(GFM_31));
    GFM gfm32 (.a(A[3][2]), .b(B2), .c(GFM_32));
    GFM gfm33 (.a(A[3][3]), .b(B3), .c(GFM_33));

    // XOR results to compute final D0-D3
    assign D0 = GFM_00 ^ GFM_01 ^ GFM_02 ^ GFM_03;
    assign D1 = GFM_10 ^ GFM_11 ^ GFM_12 ^ GFM_13;
    assign D2 = GFM_20 ^ GFM_21 ^ GFM_22 ^ GFM_23;
    assign D3 = GFM_30 ^ GFM_31 ^ GFM_32 ^ GFM_33;

endmodule
