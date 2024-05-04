module handshake_p3(input clock, reset,
          input [3:0] ps2_data, input ps2_en,
          output [3:0] sound_code,
          input data_rq,    
          output data_rd);    

reg [3:0] temp;
reg [3:0] sound;
reg [2:0] counter;
reg ready;

initial begin
  temp <= 4'b0;
  counter <= 3'b0;
  ready = 1'b0;
end

assign sound_code = sound;
assign data_rd = ready;

always @(posedge clock, posedge reset) begin
  if (reset) begin
    sound <= 4'b1;
    ready <= 1'b0;
  end
  else begin
    if (data_rq) begin
      if (ps2_en) begin
        temp <= ps2_data;
      end
      counter <= counter + 1;
      if (counter > 3'b100) begin
        counter <= 3'b0;
        sound <= temp;
        ready <= 1'b1;
      end
		//else done <= 1'b0;
    end
    else 
    begin
      ready <= 1'b0;
      sound <= 4'b1;
    end
  end
end

endmodule