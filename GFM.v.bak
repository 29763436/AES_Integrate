module GFM(
    input  [7:0] a, // 8-bit input 'a'
    input  [7:0] b, // 8-bit input 'b'
    output [7:0] c  // 8-bit output 'c'
);

    reg [7:0] LT [3:0]; // Lookup Table for 'LT'
    reg [7:0] FT [3:0]; // Lookup Table for 'FT'
    reg [7:0] c_temp;
    integer t;

    always @(*) begin
        // Initialize LT Table
        LT[0] = 8'h00;
        LT[1] = b;
        LT[2] = ((b << 1) & 8'hff) ^ 8'h1b;
        LT[3] = LT[1] ^ LT[2];

        // Initialize FT Table
        FT[0] = 8'h00;
        FT[1] = 8'h1b;
        FT[2] = (8'h1b << 1);
        FT[3] = FT[1] ^ FT[2];

        // c = (A7x + A6) * x^2
        t = (a >> 6) & 8'h03;
        c_temp = LT[t];
        c_temp = ((c_temp << 2) & 8'hff) ^ FT[c_temp >> 6];

        // c = (c + A5x + A4) * x^2
        t = (a >> 4) & 8'h03;
        c_temp = c_temp ^ LT[t];
        c_temp = ((c_temp << 2) & 8'hff) ^ FT[c_temp >> 6];

        // c = (c + A3x + A2) * x
        t = (a >> 2) & 8'h03;
        c_temp = c_temp ^ LT[t];
        c_temp = ((c_temp << 1) & 8'hff) ^ FT[c_temp >> 7];

        // c = (c + A1x) * x
        t = (a >> 1) & 8'h01;
        c_temp = c_temp ^ LT[t];
        c_temp = ((c_temp << 1) & 8'hff) ^ FT[c_temp >> 7];

        // c = c + A0B
        c_temp = c_temp ^ LT[a & 8'h01];
    end

    // Assign result to output
    assign c = c_temp;

endmodule
