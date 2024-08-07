`timescale 1ns / 1ps
`default_nettype none

module tt_um_ran_DanielZhu
(
        input wire clk,
        input wire rst_n,
        input wire startring,
        input wire pulse,
	input wire sample,
        input wire diplaychoose,
	output wire [13:0] displaypin
);


logic inverterringout;
logic ranprocessout;
logic ran16out;
logic ranbitstring;
logic [3:0] samplednum;



tt_invring tt_invring(
		.clk(clk),
		.startring(startring),
                .inverterringout(inverterringout)


);
tt_process tt_process(
		.clk(clk),
		.rst_n(rst_n),
                .num(inverterringout),
		.ranprocessout(ranprocessout)


);
tt_16bitran tt_16bitran(
		.clk(clk),
		.rst_n(rst_n),
                .ran16out(ran16out)


);

always@(*)
ranbitstring = ran16out^ranprocessout;

tt_samplekey tt_samplekey(
	.clk(clk),
	.sample(sample),
	.num(ranbitstring),
	.samplednum(samplednum));

tt_finalprocess tt_finalprocess(
.pulse(pulse),
.switchAB(diplaychoose),
.key_4(samplednum),
.disppinout(displaypin));




endmodule 



module tt_um_ran_DanielZhu_tb;
        logic clk_in;
        logic rst_n_in;
        logic startring_in;
        logic pulse_in;
	logic sample_in;
        logic diplaychoose_in;
	logic [13:0] displaypin_in;

tt_um_ran_DanielZhu tt_um_ran_DanielZhu(
        .clk(clk_in),
        .rst_n(rst_n_in),
        .startring(startring_in),
        .pulse(pulse_in),
	.sample(sample_in),
        .diplaychoose(diplaychoose_in),
	.displaypin(displaypin_in)
);
initial begin
     clk_in=0;startring_in=0;rst_n_in=0;sample_in=0;diplaychoose_in=0;pulse_in=0;
#40 rst_n_in=1;
#40 rst_n_in=0;
#40 startring_in=1;
#100000 startring_in=1;
#100000 $stop;
end
always #10 clk_in=~clk_in;
always #300 sample_in=~sample_in;
always #50 diplaychoose_in=~diplaychoose_in;


endmodule
