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

    logic ranprocessout;

    logic ran16out;

    logic ranbitstring;

    logic sample;
    logic [3:0] samplednum;



	wire _unused = &{ena, uio_in,ui_in[7:2],1'b0};
	assign uio_out=0;
	assign uo_out[7:4] =0;
	assign startring=ui_in[0];
    assign sample=ui_in[1];
	assign uo_out[3:0]=samplednum;	
	assign uio_oe[7:0]=8'b11111111;
	

	tt_invring tt_invring(
        .clk(clk),
		.startring(startring),
        .inverterringout(inverterringout),
        .rst_n(rst_n));

	tt_process tt_process(
		.clk(clk),
		.rst_n(rst_n),
        .num(inverterringout),
		.ranprocessout(ranprocessout));

	tt_16bitran tt_16bitran(
		.clk(clk),
		.rst_n(rst_n),
        .ran16out(ran16out));

	always@(*)
		ranbitstring = ran16out^ranprocessout;


	tt_samplekey tt_samplekey(
		.clk(clk),
		.rst_n(rst_n),
		.sample(sample),
		.num(ranbitstring),
		.samplednum(samplednum));


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
	input wire rst_n,
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
        if (rst_n==0) begin
            ringoutsam[0]<=0;
		    ringoutsam[1]<=0;
		    ringoutsam[2]<=0;
		    ringoutsam[3]<=0;
        end
        else begin
            ringoutsam[0]<=ringout[0];
		    ringoutsam[1]<=ringout[1];
		    ringoutsam[2]<=ringout[2];
		    ringoutsam[3]<=ringout[3]; 
        end

	end
    always_comb
        rannum= ringoutsam[0]^^ringoutsam[1]^^ringoutsam[2]^^ringoutsam[3];//create random number by xor
       
endmodule

module tt_13n #(
	parameter integer count = 13)(
    input wire clk,
    input wire rst_n,//set all flipflop to 0
    input wire num,//bit string to be preccess
	output wire ran13nout);

	logic [count:0] connection;//all of the wire required in the connection
	always@(posedge clk)begin//pass down bit each clk 
		if (rst_n==0) begin
			connection[13:1]<=0;
		end
		else begin
			connection[13]<=connection[12];
			connection[12]<=connection[11];
			connection[11]<=connection[10];
			connection[10]<=connection[9];
			connection[9]<=connection[8];
			connection[8]<=connection[7];
			connection[7]<=connection[6];
			connection[6]<=connection[5];
			connection[5]<=connection[4];		
			connection[4]<=connection[3];
			connection[3]<=connection[2];
			connection[2]<=connection[1];
			connection[1]<=connection[0];
	   		connection[0]<=num;
		end

	end
        
		
                
	assign ran13nout = connection[1]^^connection[2]^^connection[3]^^connection[4]^^
			connection[5]^^connection[6]^^connection[7]^^connection[8]^^connection[9]^^
			connection[10]^^connection[11]^^connection[12]^^connection[13];

endmodule 

module tt_process (
    input wire clk,
    input wire rst_n,
    input wire num,
	output wire ranprocessout);


	logic [2:0] bitsadjacent;
	logic [1:0] bitsgroup;
    logic bitsend;
	logic bitaft13n;
	logic  Gxor;//xor gate for the grouped number
	logic clk_half;//half clk frequency
        
	assign ranprocessout=bitsend;

	tt_13n tt_13n(
		.clk(clk),
		.rst_n(rst_n),
		.num(bitsadjacent[2]),
        .ran13nout(bitaft13n));

    always @(posedge clk)begin//prepare for grouping
    if (rst_n==0) begin
        bitsadjacent[0]<=0;
        bitsadjacent[1]<=0;
		bitsadjacent[2]<=0;
    end
		bitsadjacent[0]<=num;
        bitsadjacent[1]<=bitsadjacent[0];
		bitsadjacent[2]<=bitsadjacent[1];
    end

 
    always@(posedge clk) begin//generate half clk frequency
  		if (rst_n==0) begin
  			clk_half <= 0;
            end
 		else
 	        clk_half <= ~clk_half;
		end

	always @(posedge clk_half)begin//every two clk cycle, the prepared number will update in to the second stage
		bitsgroup[0]<=bitsadjacent[0];
		bitsgroup[1]<=bitsadjacent[1];
	end

	always_comb begin
		Gxor=bitsgroup[0]^bitsgroup[1];
        if(Gxor==1)begin//the output will choose the first of the grouped number
            bitsend=bitsgroup[1];
        end
        else
            bitsend=bitaft13n;//choose the one coming out of 13n
	end
endmodule

module tt_16bitran #(
	parameter integer count = 16)
	(input wire clk,
    input wire rst_n,
	output wire ran16out);

	logic [count:0] connection;//connect all filpflop
    assign ran16out =connection[0];


	always@(posedge clk)begin//pass down bit each clk 
		if (rst_n==1) begin
			connection[16]<=connection[15];
			connection[15]<=connection[14];
			connection[14]<=connection[13];
			connection[13]<=connection[12];
			connection[12]<=connection[11];
			connection[11]<=connection[10];
			connection[10]<=connection[9];
			connection[9]<=connection[8];
			connection[8]<=connection[7];
			connection[7]<=connection[6];
			connection[6]<=connection[5];
			connection[5]<=connection[4];		
			connection[4]<=connection[3];
			connection[3]<=connection[2];
			connection[2]<=connection[1];
			connection[1]<=connection[0];
			connection[0]<=connection[4]^^connection[13]^^connection[15]^^connection[16];
		end
		else begin
			connection[16:1]<=16'b1;
		end
	end




	
endmodule 



module tt_samplekey(
    input wire clk,
    input wire sample,
    input wire num,
	input wire rst_n,
	output wire [3:0] samplednum);


	logic [3:0] bitsadjacent;
	logic [3:0] sample_4;

        
	assign samplednum=sample_4;


    always @(posedge clk)begin
		if (rst_n==0) begin
			bitsadjacent[0]<=0;
    		bitsadjacent[1]<=0;
			bitsadjacent[2]<=0;
			bitsadjacent[3]<=0;
		end
		else begin
			bitsadjacent[0]<=num;
    		bitsadjacent[1]<=bitsadjacent[0];
			bitsadjacent[2]<=bitsadjacent[1];
			bitsadjacent[3]<=bitsadjacent[2];
		end

    end

	always @(posedge sample)begin
		sample_4<={bitsadjacent[3],bitsadjacent[2],bitsadjacent[1],bitsadjacent[0]};
 	end


endmodule 
