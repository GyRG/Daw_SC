// Ambiental
(// AmbientalDef
if(~outletAmbientalPre==[~busAmbientalFx],
	{
		~noduloAmbientalPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busAmbiental = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef Ambiental
~inletAmbientalPre = [
	~busAmbiental
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del Ambiental
~outletAmbientalPre = [
	~busAmbientalFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloAmbientalPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletAmbientalPre,
~outletAmbientalPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloAmbientalPre = Synth(\noduloAmbientalPre,
		[\gate,1,\wet,1],
		target:~grupoAmbiental,
		addAction:\addToHead
	);
});
)

(
SynthDef(\ambiental,{

	|out = 0, freq=400,amp=0.2|
	var sig=0, env, enf;
	6.do({
		sig = sig+SinOsc.ar(freq+rrand(-2,2),0,0.1);
	});
	sig = sig + VarSaw.ar(freq/2,0,LFNoise0.kr(5,0.01,0.5),0.5)+LFNoise2.ar(2,1,0.5);
	sig = PanB.ar(sig,SinOsc.kr(SinOsc.kr(100,0,0.5,1),0,0.5pi,0),LFNoise1.kr(0.3,0.2*pi,0));
	env = EnvGen.kr(Env([0,1,0.4,0],[0.2,0.3,4],[7,-5,-3]),doneAction:2);
	sig = sig *env * amp;
	Out.ar(~busAmbiental,sig);
}).add;
)
~noduloMaster.set(\amp,1);
~noduloConvergencia.set(\amp,1);
(
~ambientals = Pdef(\ambientals,Pbind(\instrument, \ambiental,
	\group, ~grupoAmbiental,

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
~ambientals.play(t, quant:1);
~ambientals.stop;