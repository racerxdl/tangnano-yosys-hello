module top (
  input   SYS_CLK,
  output  LED_R,
  output  LED_G,
  output  LED_B
);

reg [25:0] counter;

always @(posedge SYS_CLK)
begin
  counter <= counter + 1;
end

assign LED_R = counter[25];
assign LED_G = counter[24];
assign LED_B = counter[23];

endmodule