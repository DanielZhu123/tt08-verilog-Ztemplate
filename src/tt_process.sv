`timescale 1ns / 1ps
`default_nettype none
//make 0 and 1 equal possibility
module tt_process 
(
        input wire clk,
        input wire rst_n,
        input wire num,
	output wire ranprocessout
);


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
                .ran13nout(bitaft13n)


);
        always @(posedge clk)begin//prepare for grouping
		bitsadjacent[0]<=num;
                bitsadjacent[1]<=bitsadjacent[0];
		bitsadjacent[2]<=bitsadjacent[1];
        end

 
        always@(posedge clk or posedge rst_n) begin//generate half clk frequency
  		if (rst_n==1) begin
  		  clk_half <= 0;
                 end
 		 else
 	          clk_half <= ~clk_half;
		end

	always @(posedge clk_half)begin//every two clk cycle, the prepared number will update in to the second stage
			bitsgroup[0]<=bitsadjacent[0];
			bitsgroup[1]<=bitsadjacent[1];

 	end

	always @(*)begin
		Gxor=bitsgroup[0]^bitsgroup[1];
                if(Gxor==1)begin//the output will choose the first of the grouped number
                   bitsend=bitsgroup[1];
                end
                else
                   bitsend=bitaft13n;//choose the one coming out of 13n
	end
endmodule 


module tt_process_tb;
logic  ranprocessout_out;
logic clk_in;
logic num_in;
logic rst_n_in;


tt_process tt_process(
.ranprocessout(ranprocessout_out),
.clk(clk_in),
.num(num_in),
.rst_n(rst_n_in)
);
initial begin
     clk_in=0;num_in=0;rst_n_in=0;
#40 rst_n_in=1;
#40 rst_n_in=0;
#20 num_in=0;
#20 num_in=1;
#20 num_in=1;
#20 num_in=0;
#20 num_in=1;
#20 num_in=0;
#20 num_in=0;
#20 num_in=0;
#20 num_in=1;
#20 num_in=0;
#20 num_in=1;
#20 num_in=0;
#20 num_in=0;
#20 num_in=1;
#1000 $stop;
end
always #10 clk_in=~clk_in;



endmodule