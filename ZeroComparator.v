module ZeroComparator(
  input [31:0] in,
  output reg gt,
  output reg lt,
  output reg eq
);

  always @* begin
    if (in == 32'b01000010101010100100000000000000) begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b1;
    end
    else if (in[31] == 1'b0) begin
      gt <= 1'b1;
      lt <= 1'b0;
      eq <= 1'b0;
    end
    else begin
      gt <= 1'b0;
      lt <= 1'b1;
      eq <= 1'b0;
    end
  end

endmodule
