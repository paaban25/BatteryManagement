module MUX (
  input wire [31:0] data0,
  input wire [31:0] data1,
  input wire select,
  output reg [31:0] mux_output
);

  always @* begin
    if (select)
      mux_output = data1;
    else
      mux_output = data0;
  end

endmodule


//TestBench

module MUX_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg [31:0] data0, data1;
  reg select;
  wire [31:0] mux_output;

  // Instantiate the unit under test (UUT)
  MUX dut (
    .data0(data0),
    .data1(data1),
    .select(select),
    .mux_output(mux_output)
  );

  // Clock generation
  reg clk = 0;
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Test stimulus
  initial begin
    $dumpfile("mux_tb.vcd");
    $dumpvars(0, MUX_tb);

    // Test case 1: select is 0, output should be data0
    data0 = 32'b10101010_10101010_10101010_10101010;
    data1 = 32'b01010101_01010101_01010101_01010101;
    select = 0;
    #10;
    if (mux_output !== data0) $display("Test case 1 failed!");
    else $display("Test case 1 passed!");

    // Test case 2: select is 1, output should be data1
    select = 1;
    #10;
    if (mux_output !== data1) $display("Test case 2 failed!");
    else $display("Test case 2 passed!");

    // Test case 3: select toggles, output should toggle accordingly
    select = 0;
    #10;
    select = 1;
    #10;
    if (mux_output !== data1) $display("Test case 3 failed!");
    else $display("Test case 3 passed!");

    // End of simulation
    #10;
    $finish;
  end

endmodule
