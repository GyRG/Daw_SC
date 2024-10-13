(// TarolaDef
if(~outletTarolaPre==[~busTarolaFx],
	{
		~noduloTarolaPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busTarola = Bus.audio(s,2);
});


// Conexiones
// Lets para ingresar todas las instancias del synthdef Tarola
~inletTarolaPre = [
	~busTarola
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del Tarola
~outletTarolaPre = [
	~busTarolaFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~createDevice.value(\noduloTarolaPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletTarolaPre,
~outletTarolaPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloTarolaPre = Synth(\noduloTarolaPre,
		[\gate,1,\wet,1],
		target:~grupoTarola,
		addAction:\addToHead
	);
});
)

(
SynthDef(\tarola, {
	|out = 0,amp=0.6, freq=70, crtlRuido=0.7, atk=0.01, rel=5,gate=0|
	var cuero, ruido, sig, env, envf, envr;
	env = EnvGen.kr(Env.new([0,1,0.4,0],[0.001,Rand(0.2,0.6),0.1],[0,-1,-5]),doneAction:2);
	envf = EnvGen.kr(Env.new([2,Rand(0.25,1/32),1/32],[0.01,0.1,0.1],[4,0,-5]));
	envr = EnvGen.kr(Env.new([0,1,0.8,0.01,0],[0.001, 0.07 , 0.5],[0,4,-4]));
	ruido = PinkNoise.ar(0.5)*envr;
	cuero = SinOsc.ar(freq*envf);
	sig = cuero*0.7 + ruido * 0.4;
	sig = sig * amp * env;
	sig = sig!2;
	Out.ar(~busTarola, sig);
}).add;
)
~noduloMaster.set(\amp,1);
~noduloTarolaFx.set(\amp,1);

(
~tarolas = Pdef(\tarolas,
	Pbind(
		\instrument, \tarola,
		\group, ~grupoTarola,
		\dur, Prand([0.125,0.25,0.125]*1,inf),
		\freq, Pwhite(66,77,inf),
		\amp,Pbrown(0,0.7,0.3,inf),
));
)
t = TempoClock.default;
t.tempo_(0.8);

~tarolas.play(t, quant:1);
~tarolas.stop;