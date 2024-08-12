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
    logic b;

    logic c;

    logic d;

    logic key;



	wire _unused = &{ena, uio_in,ui_in[7:3],1'b0};

	
	assign a=ui_in[0];
    assign b=ui_in[1];
    assign key=ui_in[2];

	assign uio_out=0;
	assign uo_out[0] =c;	
    assign uo_out[1]=d;	
    assign uo_out[7:2]=0;	
	assign uio_oe[7:0]=8'b11111111;
	
    tt_mult_22 tt_mult_22(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .key(key));



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


