module datapath(
  input [31:0] soc1,input [31:0]soc2,input [31:0] soc3,input [31:0] soc4,input [31:0]I,input sel,input eqz,
  output reg gt,lt,eq,
  output [31:0] I1,I2,I3,I4);
  
  
  ZeroComparator Zero(.in(I),.gt(gt),.lt(lt),.eq(eq));
  
  
  reg [31:0] resp[0:3];
  reg [31:0] muxOut[0:3];
  reg [31:0] den;
  reg [31:0] Quotient[0:3];
  reg [31:0] zero=32'h00000000;
  
  reg [31:0] SOC [0:3];
  
  reg [31:0]iOut [0:3];

assign SOC[0] = soc1;
assign SOC[1] = soc2;
assign SOC[2] = soc3;
assign SOC[3] = soc4;
  
  genvar iterations;
  generate
    for (iterations = 0; iterations < 4; iterations = iterations + 1) begin : Modules_1
      FloatingReciprocal Reciprocator(.B(SOC[iterations]), .reciprocal(resp[iterations]),.clk(clk));
      MUX Multiplexers(.data0(SOC[iterations]), .data1(resp[iterations]), .select(sel), .mux_output(muxOut[iterations]));
    end
  endgenerate
  
  
  DEN_GEN Denominator(.mode(sel),.soc1(soc1),.soc2(soc2),.soc3(soc3),.soc4(soc4),.den(den),.clk(clk));
  
  
    genvar div_num;
  generate
    for (div_num = 0; div_num < 4; div_num = div_num + 1) begin : Modules_2
      Divider Divide(.A(muxOut[div_num]),.B(den),.result(Quotient[div_num]),.clk(clk));
      MUX Multiplexers(
  .data0(Quotient[div_num]), 
  .data1(zero), 
  .select(eqz), 
  .mux_output(iOut[div_num])
);  
    end
  endgenerate
                       
                       assign I1=iOut[0];
                       assign I2=iOut[1];
                       assign I3=iOut[2];
                       assign I4=iOut[3];
endmodule