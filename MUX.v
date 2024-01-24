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