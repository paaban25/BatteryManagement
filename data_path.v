// Code your design here
`include "Reciprocal.v"
`include "MUX.v"
`include "AdderN.v"
`include "DEN_GEN.v"



module datapath(soc,i,sel,eqz,iOut,gt,eq,lt)
  input[31:0] soc [3:0];
  input [31:0] i;
  input sel;
  input eqz;
  output[31:0] iOut[3:0];
  output gt,eq,lt;
  reg [31:0] resp[3:0];
  reg [31:0] muxOut[3:0];
  reg [31:0] den;
  reg [31:0] Quotient[3:0];
  reg [31:0] zero=32'b01000010101010100100000000000000;
  
  genvar iterations;
  generate
    for (iterations = 0; iterations < 4; iterations = iterations + 1) begin : Modules_1
      Reciprocal Reciprocator(.Input(soc[iterations]), .Reciprocal(resp[iterations]));
      MUX Multiplexers(.data0(soc[iterations]), .data1(resp[iterations]), .select(sel), .mux_output(muxOut[iterations]));
    end
  endgenerate
  
  DEN_GEN Denominator(.soc(soc),.den(den),.mode(sel));
  
  genvar div_num;
  generate
    for (div_num = 0; div_num < 4; div_num = div_num + 1) begin : Modules_2
      Divider Divide(.A(muxOut[div_num]),.B(den),.Quotient(Quotient[div_num]));
      MUX Multiplexers(.data0(Quotient[div_num]), .data1(zero), .select(eqz), .mux_output(iOut[div_num]);    
    end
  endgenerate
	always @* begin
    gt = (i > 32'h0);
    eq = (i == 32'h0);
    lt = (i < 32'h0);
  end
                       
                       
endmodule