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



	logic a;
    logic [3:0] b;

    logic c;




	wire _unused = &{ena, uio_in,ui_in[7:1],1'b0};

	
	assign a=ui_in[0];

    assign b=ui_in[4:1];
	
    assign uio_out=0;
	assign uo_out[0] =c;	

    assign uo_out[7:1]=0;	
	assign uio_oe[7:0]=8'b11111111;
	
    tt_multblock tt_multblock(
        .pulse(a),
        .key_4(b),
        .multblockout(c));



endmodule 





module tt_mult(
	input  wire sel,
	input  wire A,
	input  wire B,
	output wire out);

	sky130_fd_sc_hd__mux2_1 cell0_I (
        `ifdef WITH_POWER
		    .VPWR (1'b1),
		    .VGND (1'b0),
		    .VPB  (1'b1),
		    .VNB  (1'b0),
        `endif
		    .S      (sel),
	    	.A0    (A),
	    	.A1     (B),
	    	.X      (out));
endmodule

module tt_mult_22 (
	input  wire a,
	input  wire b,
	input  wire key,
    output wire c,
    output wire d);

    generate
        tt_mult mult_1(
            .A(a),
            .B(b),
            .sel(key),
            .out(c));

        tt_mult mult_2(
            .A(b),
            .B(a),
            .sel(key),
            .out(d));
    endgenerate


endmodule 


module tt_multblock #(
	parameter integer mult_len =12)
	
	(input wire pulse,
	input wire [3:0] key_4,
	output wire multblockout);

	wire [mult_len:0] A;//A B are wire to connect the switch
	wire [mult_len:0] B;
	wire [mult_len-1:0] key;
	logic [1:0]anda;
	logic andaout;
	logic [1:0]andb;
	logic andbout;

	assign A[0]=pulse;
	assign B[0]=pulse;

	
	genvar i;
	generate
		//4 Oscillator
		for (i = 0; i < mult_len; i = i + 1) begin
			tt_mult_22 mult_22(
				.a (A[i]),
				.b (B[i]),
 				.c(A[i+1]),
				.d(B[i+1]),
				.key(key[i]));
		end
       
	endgenerate

    assign key[0]=key_4[0];
    assign key[1]=key_4[0];
    assign key[2]=key_4[0];
    assign key[3]=key_4[1];
    assign key[4]=key_4[1];
    assign key[5]=key_4[1];
    assign key[6]=key_4[2];
    assign key[7]=key_4[2];
    assign key[8]=key_4[2];
    assign key[9]=key_4[3];
    assign key[10]=key_4[3];
    assign key[11]=key_4[3];
	assign anda[0]=A[12];
	assign andb[0]=B[12];
	assign anda[1]=andbout;
	assign andb[1]=andaout;
	assign multblockout=andaout;

        
	always_comb begin
        andaout=~(anda[0]&anda[1]);
        andbout=~(andb[0]&andb[1]);
	end


	
	
       
endmodule 
