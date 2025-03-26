(
~clock_1 = {TempoClock(80/60)}.value;

~rutinas = Routine({
	Require("Fijos.scd");
	Require("Abismo/Grieta_00.scd");
	~pads.play(~clock_1);
	~hihat.play(~clock_1);
	~ride.play(~clock_1);

	14.yield;
	~tomb.play(~clock_1);
	~snr.play(~clock_1);
	~bombos.play(~clock_1);
	~crash.stop(~clock_1);
	64.yield;
	~crash.stop;
	~pads.stop;
	~hihat.stop;
	~tomb.stop;
	~snr.stop;
	~bombos.stop;
	~ride.stop;
	1.yield;
	//Require("Abismo/Grieta_01.scd");
/*	~pads.play(~clock_1);
	~hihat.play(~clock_1);
	~ride.play(~clock_1);
	20.yield;
	~tomb.play(~clock_1);
	~snr.play(~clock_1);
	~bombos.play(~clock_1);
	~crash.play(~clock_1);
	20.yield;
	~crash.stop;
	~pads.stop;
	~hihat.stop;
	~tomb.stop;
	~snr.stop;
	~bombos.stop;
	~ride.stop;*/

});

~rutinas.reset;
~rutinas.play(~clock_1);
)
~ride.play;
~snr.stop(~clock_1);

(
~bombos.stop;
~clock_1 = {TempoClock(4)}.value;
~bombos.play(~clock_1);
);
