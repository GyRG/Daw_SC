(//Efectos Percusiones
if(~inletPercsPre==[~busPercsPre],
	{

		~noduloPercsPos.free;
		~noduloPercsFx.free;
	},{
		// Creación de buses

		~busPercsFx = Bus.audio(s,2);
		~busPercsFxPos = Bus.audio(s,2);

});



//PercsFx
~inletPercsFx = [~busPercsFx];
~outletPercsFx = [~busPercsFxPos];
// PercsPos
~inletPercsPos = [~busPercsFxPos];
~outletPercsPos = [~busPercs];

// Efectos de las percs
~crearNodulo.value(\noduloPercsFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsFx,
~outletPercsFx
);

// Mezcla de percusiones Pos Fx
~crearNodulo.value(\noduloPercsPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsPos,
~outletPercsPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de las percusiones
	~noduloPercsFx = Synth(\noduloPercsFx,
		[\gate,1,\wet,1],
		target:~grupoFxPercs,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Percs
	~noduloPercsPos = Synth(\noduloPercsPos,
		[\gate,1,\wet,1],
		target:~grupoFxPercs,
		addAction:\addToTail
	);
});
)

(
SynthDef(\ruidoPrueba,
	{
		|out = 0, gate=0, freq|
		var sig, env;
		env = EnvGen.kr(Env.perc,gate,doneAction:2);
		// sig = PinkNoise.ar(0.7)!2;
		sig = SinOsc.ar({freq+Rand(2,20)})+PinkNoise.ar(1.2);
		sig = Pan2.ar(sig,LFNoise2.kr(500,1,0));
		Out.ar(out,sig*env);
}).add;

Synth(\ruidoPrueba,[\freq,120,\gate,1,\out,~busBomboWShPre],target:~grupoBombo,addAction:\addToHead);

)


~noduloMaster.set(\amp,0.01);