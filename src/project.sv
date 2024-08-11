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


	wire _unused = &{ena, uio_in,ui_in[7:1], uio_out, uo_out[7:1], 1'b0};

	assign startring=ui_in[0];
	assign uo_out[0]=inverterringout;	
	assign uio_oe[7:0]=8'b11111111;
	

	tt_invring tt_invring(
		.clk(clk),
		.startring(startring),
        .inverterringout(inverterringout));

endmodule 




module tt_inv (
	input  wire a,
  	output wire y);

  	sky130_fd_sc_hd__inv_2 cnt_bit_I (
    	.A     (a),
    	.Y     (y));

endmodule 



module tt_invring #(
	parameter integer OSC_LEN_1 = 11,//length of each inverter
    parameter integer OSC_LEN_2 = 19,
    parameter integer OSC_LEN_3 = 23,
    parameter integer OSC_LEN_4 = 29)
	
	(input wire clk,
	input wire startring,//rings oscillate,else rings stop oscillate
	output wire inverterringout);//generate random bit string

	wire [OSC_LEN_1-1:0] osc_1;//wire for connecting inverters
	wire [OSC_LEN_2-1:0] osc_2;
	wire [OSC_LEN_3-1:0] osc_3;
	wire [OSC_LEN_4-1:0] osc_4;

    logic [3:0] ringout;//collect each rings last inverters output
    logic [3:0] ringoutsam;//after sample
    logic  rannum;//bit string this system generate

	assign ringout ={osc_4[OSC_LEN_4-1],osc_3[OSC_LEN_3-1],osc_2[OSC_LEN_2-1],osc_1[OSC_LEN_1-1]};
    assign inverterringout=rannum;

	genvar i;
	generate
		//4 Oscillator
		for (i = 0; i < OSC_LEN_1; i = i + 1) begin: ringosc1
			wire y;
			if (i == 0)begin:gen_1
				assign y = startring? osc_1[OSC_LEN_1 - 1]:0;//if start is off,the ring will not connect its head and tail
			end
			else begin:gen_11
				assign y = osc_1[i - 1];
			end
			tt_inv inv (
				.a (y),
				.y (osc_1[i]));
		end

		for (i = 0; i < OSC_LEN_2; i = i + 1) begin: ringosc2
			wire y;
			if (i == 0)begin:gen_2
				assign y = startring? osc_2[OSC_LEN_2 - 1]:0;
			end
			else begin:gen_22
				assign y = osc_2[i - 1];
			end
			tt_inv inv (
				.a (y),
				.y (osc_2[i]));
		end

		for (i = 0; i < OSC_LEN_3; i = i + 1) begin: ringosc3
			wire y;
			if (i == 0)begin:gen_3
				assign y = startring? osc_3[OSC_LEN_3 - 1]:0;
			end
			else begin:gen_33
				assign y = osc_3[i - 1];
			end
			tt_inv inv (
				.a (y),
				.y (osc_3[i]));
		end

		for (i = 0; i < OSC_LEN_4; i = i + 1) begin: ringosc4
			wire y;
			if (i == 0)begin:gen_4
				assign y = startring? osc_4[OSC_LEN_4 - 1]:0;
			end
			else begin:gen_44
				assign y = osc_4[i - 1];
			end
			tt_inv inv (
				.a (y),
				.y (osc_4[i]));
		end

	endgenerate

    always @(posedge clk)begin//sample ringout each clk cycle
        ringoutsam[0]<=ringout[0];
		ringoutsam[1]<=ringout[1];
		ringoutsam[2]<=ringout[2];
		ringoutsam[3]<=ringout[3];
	end
    always_comb
        rannum= ringoutsam[0]^^ringoutsam[1]^^ringoutsam[2]^^ringoutsam[3];//create random number by xor
       
endmodule

