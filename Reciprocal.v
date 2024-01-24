`include "Divider.v" // Include Divider module

module Reciprocal (
  input wire [31:0] Input, // Single precision input
  output reg [31:0] Reciprocal // Single precision reciprocal output
);

  // Constants for IEEE 754 single-precision format
  parameter EXPONENT_BITS = 8;
  parameter MANTISSA_BITS = 23;
  parameter BIAS = 127;

  // Signals
  wire [31:0] One = 32'h3F800000; // Represents 1.0 in IEEE 754 format

  // Divider module instance to calculate reciprocal (1 / Input)
  Divider myDivider (
    .A(One),
    .B(Input),
    .Quotient(Reciprocal)
  );

endmodule