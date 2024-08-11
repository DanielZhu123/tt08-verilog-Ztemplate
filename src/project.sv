/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ran_DanielZhu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n);     // reset_n - low to reset



	logic startring;
    logic inverterringout;
	logic ran;


	wire _unused = &{ena, uio_in,ui_in[7:1], uio_out, uo_out[7:1], 1'b0};

	assign startring=ui_in[0];
	assign uo_out[0]=ran;	
	assign uio_oe[7:0]=8'b11111111;
	

	tt_invring tt_invring(
		.startring(startring),
        .inverterringout(inverterringout));

	always@(posedge clk)begin
		ran<=inverterringout;
	end

endmodule 




module tt_prim_inv (
	input  wire a,
  output wire y
);

  sky130_fd_sc_hd__inv_2 cnt_bit_I (
    .A     (a),
    .Y     (y)
  );

endmodule // tt_prim_inv



module tt_invring #(
	parameter integer OSC_LEN = 11)
	
	(input wire startring,//rings oscillate,else rings stop oscillate
	output wire inverterringout);//generate random bit string
	wire [OSC_LEN-1:0] osc;
    assign inverterringout=osc[OSC_LEN - 1];
	genvar i;
	generate
		// Oscillator
		for (i = 0; i < OSC_LEN; i = i + 1) begin: ringosc
			wire y;
			if (i == 0)
				assign y = startring ? osc[OSC_LEN - 1]:0 ;
			else
				assign y = osc[i - 1];
			
			tt_prim_inv inv (
				.a (y),
				.y (osc[i])
			);
		end
	endgenerate 
endmodule

