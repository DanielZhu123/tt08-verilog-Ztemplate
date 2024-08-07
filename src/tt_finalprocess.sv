`timescale 1ns / 1ps
`default_nettype none
module tt_finalprocess #(
	parameter integer multblock_len =4)
	
	(input wire pulse,
        input  wire switchAB,
	input wire [3:0] key_4,
	output wire [13:0] disppinout);

	logic [3:0] multblockA;
	logic [3:0] multblockB;

	logic [3:0] num1;
	logic [3:0] num2;

	logic [7:0]multblockout;
	
	assign num1=key_4;


	
	genvar i;
	generate
		for (i = 0; i < 8; i = i + 1) begin
			tt_multblock multblock(
				.pulse(pulse),
				.key_4(key_4),
				.multblockout(multblockout[i])
			);
		end
       
	endgenerate

        assign multblockA={multblockout[3],multblockout[2],multblockout[1],multblockout[0]};
        assign multblockB={multblockout[7],multblockout[6],multblockout[5],multblockout[4]};

	always_comb begin
               if(switchAB==1)
		 num2=multblockA;
		else
		 num2=multblockB;
	end

tt_display tt_display(
.number1(num1),
.number2(num2),
.displaypin(disppinout)
);

	
	
       
endmodule 


module tt_finalprocess_tb;
logic pulse_in;
logic switchAB_in;
logic [3:0] key_4_in;
logic [13:0] disppinout_out;




tt_finalprocess tt_finalprocess(
.pulse(pulse_in),
.switchAB(switchAB_in),
.key_4(key_4_in),
.disppinout(disppinout_out)
);
initial begin
     pulse_in=0;switchAB_in=0;key_4_in=0;
#300 key_4_in=1;
#30000 $stop;
end
always #30 switchAB_in=~switchAB_in;
endmodule