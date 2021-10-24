(// BomboDef
if(~outletBomboPre==[~busBomboFx],
	{
		~noduloBomboPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busBombo = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef bombo
~inletBomboPre = [
	~busBombo
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del bombo
~outletBomboPre = [
	~busBomboFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloBomboPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBomboPre,
~outletBomboPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloBomboPre = Synth(\noduloBomboPre,
		[\gate,1,\wet,1],
		target:~grupoBombo,
		addAction:\addToHead
	);
});
)

(
SynthDef(\bombo,{
	|out = 0, freq = 50, amp = 0.7|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.1,0.0],[0.02,0.15,0.01],[1,-1]),doneAction:2);
	enf = EnvGen.ar(Env([12,3/2,1/3],[0.006,0.21,0.01],[-3,-7]));
	sig = SinOsc.ar(freq*enf)!2;
	sig  = sig * env *amp;
	Out.ar(~busBombo,sig)
}).add;
)
~noduloMaster.set(\amp,1);
~noduloConvergencia.set(\amp,1);

(
~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\group, ~grupoBombo,
		\dur, Pseq([0.25,0.125,0.125,0.25,0.125,0.25,0.25],inf),
		\freq, 70,
		\amp,Pseq([0.7,0.2,0.5,0.2,0.5,0.3,0.2]*4,inf)
));
)
FFT
~bombos.play(t, quant:1);
~bombos.stop;