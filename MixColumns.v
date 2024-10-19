module MixColumns(
    input  [127:0] B,   // 128-bit input (16 bytes)
    output [127:0] D    // 128-bit output (16 bytes)
);
    wire [7:0] A [3:0][3:0];   // MixColumns matrix
    wire [7:0] B_array [15:0]; // Split input B into bytes
    wire [7:0] D_array [15:0]; // Split output D into bytes

    // Assign input bytes to array
    assign {B_array[0], B_array[1], B_array[2], B_array[3],
            B_array[4], B_array[5], B_array[6], B_array[7],
            B_array[8], B_array[9], B_array[10], B_array[11],
            B_array[12], B_array[13], B_array[14], B_array[15]} = B;


    // MixColumns matrix (AES standard)
    assign A[0][0] = 8'h02; assign A[0][1] = 8'h03; assign A[0][2] = 8'h01; assign A[0][3] = 8'h01;
    assign A[1][0] = 8'h01; assign A[1][1] = 8'h02; assign A[1][2] = 8'h03; assign A[1][3] = 8'h01;
    assign A[2][0] = 8'h01; assign A[2][1] = 8'h01; assign A[2][2] = 8'h02; assign A[2][3] = 8'h03;
    assign A[3][0] = 8'h03; assign A[3][1] = 8'h01; assign A[3][2] = 8'h01; assign A[3][3] = 8'h02;

    // Intermediate wires for GFM results
    wire [7:0] GFM [3:0][3:0][3:0];

    genvar i, j, k;
    generate
        for (i = 0; i < 4; i = i + 1) begin : row_loop
            for (j = 0; j < 4; j = j + 1) begin : col_loop
                for (k = 0; k < 4; k = k + 1) begin : gfm_loop
                    GFM gfm_inst (
                        .a(A[i][k]), 
                        .b(B_array[j*4 + k]), 
                        .c(GFM[i][j][k])
                    );
                end
            end
        end
    endgenerate

    // XOR to get the final D_array values
    generate
        for (i = 0; i < 4; i = i + 1) begin : mix_columns_result
            assign D_array[i*4 + 0] = GFM[i][0][0] ^ GFM[i][0][1] ^ GFM[i][0][2] ^ GFM[i][0][3];
            assign D_array[i*4 + 1] = GFM[i][1][0] ^ GFM[i][1][1] ^ GFM[i][1][2] ^ GFM[i][1][3];
            assign D_array[i*4 + 2] = GFM[i][2][0] ^ GFM[i][2][1] ^ GFM[i][2][2] ^ GFM[i][2][3];
            assign D_array[i*4 + 3] = GFM[i][3][0] ^ GFM[i][3][1] ^ GFM[i][3][2] ^ GFM[i][3][3];
        end
    endgenerate

    // Assign final output bytes
    assign D = {D_array[0], D_array[4], D_array[8], D_array[12],
                D_array[1], D_array[5], D_array[9],  D_array[13],
                D_array[2],  D_array[6],  D_array[10],  D_array[14],
                D_array[3],  D_array[7],  D_array[11],  D_array[15]};
endmodule
