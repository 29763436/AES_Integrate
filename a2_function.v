module a2_function(
    input  [7:0] i,   // 8-bit input
    output [7:0] o    // 8-bit output
);
    reg [7:0] c;

    always @(*) begin
        c[7] = ((i >> 7) & 1) ^ ((i >> 6) & 1);
        c[6] = ((i >> 5) & 1) ^ ((i >> 3) & 1);
        c[5] = ((i >> 6) & 1) ^ ((i >> 5) & 1);
        c[4] = ((i >> 2) & 1) ^ ((i >> 4) & 1) ^ ((i >> 7) & 1);
        c[3] = ((i >> 4) & 1) ^ ((i >> 5) & 1) ^ ((i >> 6) & 1) ^ ((i >> 7) & 1);
        c[2] = ((i >> 1) & 1) ^ ((i >> 5) & 1);
        c[1] = ((i >> 4) & 1) ^ ((i >> 6) & 1) ^ ((i >> 7) & 1);
        c[0] = ((i >> 0) & 1) ^ ((i >> 4) & 1) ^ ((i >> 6) & 1);
    end

    assign o = c;
endmodule

module top_module(
    input  [7:0] A,       // 8-bit input 'A'
    output [7:0] result,  // 8-bit output 'result'
    output [7:0] m5       // 8-bit output intermediate value 'm5'
);
    wire [7:0] A2, A4, A8, A16, A32, A64, A128;
    wire [7:0] m0, m1, m2, m3, m4;

    // Instantiate the a2_function for each step
    a2_function a2_1(.i(A),    .o(A2));
    a2_function a2_2(.i(A2),   .o(A4));
    a2_function a2_3(.i(A4),   .o(A8));
    a2_function a2_4(.i(A8),   .o(A16));
    a2_function a2_5(.i(A16),  .o(A32));
    a2_function a2_6(.i(A32),  .o(A64));
    a2_function a2_7(.i(A64),  .o(A128));

    // Wire to connect GFM modules
    wire [7:0] gfm_result_0, gfm_result_1, gfm_result_2, gfm_result_3, gfm_result_4, gfm_result_5;

    // Instantiate GFM modules for multiplication steps
    GFM gfm0 (.a(A2),    .b(A4),   .c(gfm_result_0));
    GFM gfm1 (.a(gfm_result_0), .b(A8),  .c(gfm_result_1));
    GFM gfm2 (.a(gfm_result_1), .b(A16), .c(gfm_result_2));
    GFM gfm3 (.a(gfm_result_2), .b(A32), .c(gfm_result_3));
    GFM gfm4 (.a(gfm_result_3), .b(A64), .c(gfm_result_4));
    GFM gfm5 (.a(gfm_result_4), .b(A128), .c(gfm_result_5));

    assign m5 = gfm_result_5; // Intermediate value

    // Final multiplication with A
    GFM gfm_final (.a(gfm_result_5), .b(A), .c(result));

endmodule
