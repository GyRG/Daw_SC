(// HihatDef
if(~outletHihatPre==[~busHihatFx],
	{
		~noduloHihatPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busHihat = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef Hihat
~inletHihatPre = [
	~busHihat
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del Hihat
~outletHihatPre = [
	~busHihatFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloHihatPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletHihatPre,
~outletHihatPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloHihatPre = Synth(\noduloHihatPre,
		[\gate,1,\wet,1],
		target:~grupoHihat,
		addAction:\addToHead
	);
});
)

(
SynthDef(\hihat,{
	|out = 0, freq = 50000, amp = 0.7|
	var sig, env, enf;
	enf = EnvGen.ar(Env([1,2,1],[0.001,0.208],[-6,-2]));
	sig = LFNoise1.ar(freq*enf,0.1)!2;
	env = EnvGen.kr(Env([0,1,0.2,0],[0.01,exprand(0.01,0.2),2.75],[3,-3,-5]),doneAction:2);
	sig = LinPan2.ar(sig,LFPar.kr(100,0,2,0));
	sig  = sig * env *amp;
	Out.ar(~busHihat,sig)
}).add;
)

~noduloMaster.set(\amp,1);
~noduloHihatFx.set(\amp,1);

(
~hihats = Pdef(\hihats,
	Pbind(
		\instrument, \hihat,
		\group, ~grupoHihat,
		\dur, Pseq([1]*0.2,inf),
		\freq, 50000,
		\amp,0.1
));
)
t = TempoClock.default;
t.tempo_(1);

~hihats.play(t, quant:1);
~hihats.stop;