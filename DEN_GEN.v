`include "Reciprocal.v"
`include "MUX.v"
`include "AdderN.v"

module DEN_GEN(soc, den, mode);
  parameter N = 3;
  input wire [31:0] soc[N-1:0];
  input mode;
  output reg [31:0] den;
  reg resp[N-1:0];
  reg addent[N-1:0];
  
  genvar iterations;
  generate
    for (iterations = 0; iterations < N; iterations = iterations + 1) begin : Modules
      Reciprocal Reciprocator(.Input(soc[iterations]), .Reciprocal(resp[iterations]));
      MUX Multiplexers(.data0(soc[iterations]), .data1(resp[iterations]), .select(mode), .mux_output(addent[iterations]));
    end
  endgenerate
  
  AdderN ADD(.A(addent), .Sum(den));
endmodule