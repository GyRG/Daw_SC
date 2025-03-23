(
~clock_1 = {TempoClock(120/80)}.value;

~rutinas = Routine({
	Require("Entropia.scd");
	~pads.play(~clock_1);
	~hihat.play(~clock_1);
	~ride.play(~clock);

	40.yield;
	~tomb.play(~clock_1);
	~snr.play(~clock_1);
	//~bombos.play(~clock_1);
	~crash.play(~clock_1);
	60.yield;
	~crash.stop;
	~pads.stop;
	~hihat.stop;
	~tomb.stop;
	~snr.stop;
	~bombos.stop;
	~ride.stop;

});

~rutinas.reset;
~rutinas.play(~clock_1);
)
~ride.play;
~snr.play(~clock_1);

