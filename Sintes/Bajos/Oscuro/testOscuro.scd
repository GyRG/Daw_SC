~noduloMaster.set(\amp,1);
~noduloConvergencia.set(\amp,1);
(
~oscuros = Pdef(\oscuros,Pbind(\instrument, \oscuro,
	\group, ~grupoOscuro,

	\dur,Pseq([2,3,2],inf),
		\freq,Ptuple(
			[
				Pseq([55,52,50,57,50,52,56,\n].midicps,inf),
				Pseq([65,60,\n,62,67,64,60,64].midicps,inf),
				Pseq([69,67,64,70,68,\n,69,71].midicps,inf)
		]
			,inf)
	));
)
~oscuros.play(t, quant:1);
~oscuros.stop;