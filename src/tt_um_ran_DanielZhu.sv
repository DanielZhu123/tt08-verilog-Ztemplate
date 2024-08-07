
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




