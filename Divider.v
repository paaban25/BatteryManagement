// Code your design here
// Divider.sv

module Divider (
  input wire [31:0] A, // Dividend
  input wire [31:0] B, // Divisor
  output reg [31:0] Quotient // Result of division
);

  // Constants for IEEE 754 single-precision format
  parameter EXPONENT_BITS = 8;
  parameter MANTISSA_BITS = 23;
  parameter BIAS = 127;
  
  reg sign_A, sign_B;
  reg [7:0] exponent_A, exponent_B;
  reg [22:0] mantissa_A, mantissa_B;
  reg [7:0] exponent_diff;
  reg [31:0] mantissa_result;

  always @* begin
    // Extract components of the IEEE 754 format
    sign_A = A[31];
    exponent_A = A[30:23];
    mantissa_A = A[22:0];

    sign_B = B[31];
    exponent_B = B[30:23];
    mantissa_B = B[22:0];

    // Handle special cases
    if (exponent_A == 8'b11111111 && mantissa_A == 23'b00000000000000000000000) begin
      // NaN or infinity, handle as needed
      // For simplicity, treating as zero in this example
      Quotient = 32'b0;
    end else if (exponent_B == 8'b11111111 && mantissa_B == 23'b00000000000000000000000) begin
      // NaN or infinity, handle as needed
      // For simplicity, treating as zero in this example
      Quotient = 32'b0;
    end else if (B == 32'b0) begin
      // Division by zero, handle as needed
      // For simplicity, treating as zero in this example
      Quotient = 32'b0;
    end else begin
      // Perform division
      exponent_diff = exponent_A - exponent_B + BIAS;
      
      if (exponent_diff[7] == 1'b1) begin
        // Shift mantissa of A to the right to align with B
        mantissa_result = {1'b1, mantissa_A} >> exponent_diff[6:0];
      end else begin
        // Shift mantissa of A to the left to align with B
        mantissa_result = {1'b1, mantissa_A} << -exponent_diff[6:0];
      end

      // Perform division of mantissas
      Quotient = {sign_A ^ sign_B, exponent_diff, mantissa_result} / {1'b0, mantissa_B};
    end
  end

endmodule