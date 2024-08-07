`default_nettype none
//a single inverter
module tt_inv #(
	parameter real INV_DELAY_NS = 0.07) //single inverter delay 
	
	(input  wire a,
         output wire y);

	not #(INV_DELAY_NS) (y, a);

endmodule 
