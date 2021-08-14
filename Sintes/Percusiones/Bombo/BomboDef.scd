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
	env = EnvGen.kr(Env([0,1,0.1,0.0],[0.02,0.18,0.011],[0,-5]),doneAction:2);
	enf = EnvGen.ar(Env([12,3/2,1/3],[0.01,0.4,0.1],[-2,-8]));
	sig = SinOsc.ar(freq*enf)!2;
	sig  = sig * env *amp;
	Out.ar(~busBombo,sig)
}).add;
)
~noduloMaster.set(\amp,1);
~noduloConvergencia.set(\wet,1);

(
~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\group, ~grupoBombo,
		\dur, Pseq([1]*0.66666,inf),
		\freq, 66,
		\amp,1
));
)

~bombos.play(t, quant:1);
~bombos.stop;