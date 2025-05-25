(


~rutinas = Routine({
	Require("Abismo/Grieta_00.scd");

	Require("Fijos.scd");
	4.yield;
	~pads.play(~clock_1);
	~hihat.play(~clock_1);
	~ride.play(~clock_1);
	64.yield;
	~crash.play(~clock_1);
	~tomb.play(~clock_1);
	~snr.play(~clock_1);
	~bombos.play(~clock_1);
	64.yield;
	~crash.stop;
	~pads.stop;
	~hihat.stop;
	~tomb.stop;
	~snr.stop;
	~bombos.stop;
	~ride.stop;
	Require("Abismo/Grieta_01.scd");
	8.yield;
	~bassLine.play(~clock_1);
	~hihat.play(~clock_1);
	~ride.play(~clock_1);
	64.yield;
	~tomb.play(~clock_1);
	~snr.play(~clock_1);
	~bombos.play(~clock_1);
	~crash.play(~clock_1);
	32.yield;
	~crash.stop;
	~pads.stop;
	~hihat.stop;
	~tomb.stop;
	~snr.stop;
	~bombos.stop;
	~ride.stop;
	~bassLine.stop;
	Require("Abismo/Grieta_02.scd");
	8.yield;
	~bassLine.play(~clock_2);
	~tomb.play(~clock_2);
	~snr.play(~clock_2);
	~bombos.play(~clock_2);
	~crash.play(~clock_2);
	~hihat.play(~clock_2);
	~ride.play(~clock_2);
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
