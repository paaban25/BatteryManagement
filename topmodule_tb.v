// Code your testbench here
// or browse Examples
//TestBench

`timescale 1ns/1ns // Specify timescale


module topmodule_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in time units

  // Inputs
  reg [31:0] soc1, soc2, soc3, soc4, I;
  reg sel, eqz;
  reg clk;

  // Outputs
  wire gt, lt, eq;
  wire [31:0] I1, I2, I3, I4;

  // Instantiate the datapath module
  topLevel dut (
    .soc1(soc1),
    .soc2(soc2),
    .soc3(soc3),
    .soc4(soc4),
    .I(I),
    
    .i1(I1),
    .i2(I2),
    .i3(I3),
    .i4(I4)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Initial stimulus
  initial begin
    // Initialize inputs
    soc1 = 32'h3f800000;
    soc2 = 32'h40000000;
    soc3 = 32'h40400000;
    soc4 = 32'h40800000;
    I = 32'hc1200000; // Some initial value for I
    

    // Apply inputs and observe outputs for 20 clock cycles
    $monitor("Time=%0t: soc1=%h, soc2=%h, soc3=%h, soc4=%h, I=%h,  I1=%h, I2=%h, I3=%h, I4=%h", $time, soc1, soc2, soc3, soc4, I,  I1, I2, I3, I4);
    #10; // Initial delay to stabilize signals

    // Iterate for some clock cycles
    
    // End simulation
    $finish;
  end

endmodule
