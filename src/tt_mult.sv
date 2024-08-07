`timescale 1ns / 1ps
`default_nettype none
module tt_mult (
	input  wire a,
	input  wire b,
	input  wire key,
        output wire c,
        output wire d);

	logic midc;
	logic midd;
	assign c=midc;
	assign d=midd;

	always_comb begin
		if(key==0)begin
                	midc=a;
			midd=b;
		end
		else begin
                	midd=a;
			midc=b;
		end
	end
endmodule 



module tt_mult_tb;
logic c_out;
logic d_out;
logic a_in;
logic b_in;
logic key_in;

tt_mult tt_mult(
.d(d_out),
.c(c_out),
.a(a_in),
.b(b_in),
.key(key_in)
);
initial begin
     a_in=0;b_in=1;key_in=0;

#100 $stop;
end
always #10 key_in=~key_in;

endmodule