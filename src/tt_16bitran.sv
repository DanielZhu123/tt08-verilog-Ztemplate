`timescale 1ns / 1ps
`default_nettype none
//16unit MLS
module tt_16bitran #(
	parameter integer count = 16

)
(
        input wire clk,
        input wire rst_n,
	output wire ran16out
);

	logic [count:0] connection;//connect all filpflop
        assign ran16out =connection[0];


	always@(posedge clk)begin//pass down bit each clk 
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
	end
        
    	always@(posedge rst_n)begin//reset all to 0000_0000_0000_0001
		connection[16:1]<=16'b1;
	end

        assign connection[0] = connection[4]^^connection[13]^^connection[15]^^connection[16];

	
endmodule 


module tt_16bitran_tb;
logic  ran16out_out;
logic clk_in;
logic rst_n_in;
tt_16bitran tt_16bitran(
.ran16out(ran16out_out),
.clk(clk_in),
.rst_n(rst_n_in)
);
initial begin
     clk_in=0;rst_n_in=0;
#20 rst_n_in=1;
#40 rst_n_in=0;
#10000 $stop;
end
always #10 clk_in=~clk_in;
endmodule