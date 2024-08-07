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


