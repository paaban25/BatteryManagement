// Code your design here
module ZeroComparator(
  input [31:0] in,
  output reg gt,
  output reg lt,
  output reg eq
);

  always @* begin
    // IEEE 754 representation of zero for single precision (32 bits)
    if (in == 32'b00000000_00000000_00000000_00000000) begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b1;
    end
    // Check if the number is positive (including positive zero)
    else if (in[31] == 0 && |in[30:23] != 8'b00000000) begin
      gt <= 1'b1;
      lt <= 1'b0;
      eq <= 1'b0;
    end
    // Check if the number is negative
    else if (in[31] == 1) begin
      gt <= 1'b0;
      lt <= 1'b1;
      eq <= 1'b0;
    end
    // Handle negative zero separately
    else if (in[31] == 0 && |in[30:0] == 0) begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b1;
    end
    // All other cases
    else begin
      gt <= 1'b0;
      lt <= 1'b0;
      eq <= 1'b0;
    end
  end

endmodule




//Test Bench
module ZeroComparator_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg [31:0] in;
  wire gt, lt, eq;

  // Instantiate the unit under test (UUT)
  ZeroComparator dut (
    .in(in),
    .gt(gt),
    .lt(lt),
    .eq(eq)
  );

  // Clock generation
  reg clk = 0;
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Test stimulus
  initial begin
    $dumpfile("zerocomparator_tb.vcd");
    $dumpvars(0, ZeroComparator_tb);

    // Test case 1: Input is zero
    in <= 32'b00000000_00000000_00000000_00000000;
    #10;
    $display("Test case 1: Input is zero");
    if (gt || lt || !eq) $display("Test failed!");
    else $display("Test passed!");

    // Test case 2: Input is positive non-zero
    in <= 32'b01000000_10000000_00000000_00000000; // 100
    #10;
    $display("Test case 2: Input is positive non-zero");
    if (!gt || lt || eq) $display("Test failed!");
    else $display("Test passed!");

    // Test case 3: Input is negative non-zero
    in <= 32'b11000000_10000000_00000000_00000000; // -100
    #10;
    $display("Test case 3: Input is negative non-zero");
    if (gt || !lt || eq) $display("Test failed!");
    else $display("Test passed!");

    // Test case 4: Input is positive zero
    in <= 32'b00000000_00000000_00000000_00000000; // Positive zero
    #10;
    $display("Test case 4: Input is positive zero");
    if (gt || lt || !eq) $display("Test failed!");
    else $display("Test passed!");

    // End of simulation
    #10;
    $finish;
  end

endmodule
