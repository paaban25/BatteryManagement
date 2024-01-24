module AdderN (
  input wire [31:0] A[4-1:0], 
  output reg [31:0] Sum 
);

  // Constants for IEEE 754 single-precision format
  parameter EXPONENT_BITS = 8;
  parameter MANTISSA_BITS = 23;
  parameter BIAS = 127;

  always @* begin
    // Initialize sum to zero
    Sum = 32'b0;

    // Iterate over each input number
    for (int i = 0; i < 4; i = i + 1) begin
      // Extract components of the IEEE 754 format
      reg sign = A[i][31];
      reg exponent = A[i][30:23];
      reg mantissa = A[i][22:0];

      // Handle special cases
      if (exponent == 8'b00000000 && mantissa == 23'b00000000000000000000000) begin
        // Zero, do nothing
      end else if (exponent == 8'b11111111 && mantissa == 23'b00000000000000000000000) begin
        // NaN or infinity, handle as needed
        // For simplicity, treating as zero in this example
      end else begin
        // Normalization and rounding (simple rounding to the nearest integer)
        reg [30:0] normalized_mantissa = {1'b1, mantissa, 23'b0};
        reg [7:0] shift_amount = BIAS - exponent;
        reg [31:0] normalized_sum = {1'b0, normalized_mantissa} << shift_amount;

        // Add to the running sum
        if (sign == 1'b0) begin
          Sum = Sum + normalized_sum;
        end else begin
          Sum = Sum - normalized_sum;
        end
      end
    end
  end

endmodule