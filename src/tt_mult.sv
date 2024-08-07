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


