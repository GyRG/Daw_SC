// Electrico
(// ElectricoDef
if(~outletElectricoPre==[~busElectricoFx],
	{
		~noduloElectricoPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busElectrico = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef Electrico
~inletElectricoPre = [
	~busElectrico
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del Electrico
~outletElectricoPre = [
	~busElectricoFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloElectricoPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletElectricoPre,
~outletElectricoPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloElectricoPre = Synth(\noduloElectricoPre,
		[\gate,1,\wet,1],
		target:~grupoElectrico,
		addAction:\addToHead
	);
});
)

(
SynthDef(\electrico,{

	|out = 0, freq=400,amp=0.2|
	var sig=0, env, enf;
	6.do({
		sig = sig+SinOsc.ar(freq+rrand(-2,2),0,0.1);
	});
	sig = sig + VarSaw.ar(freq/2,0,LFNoise0.kr(5,0.01,0.5),0.5)+LFNoise2.ar(2,1,0.5);
	sig = PanB.ar(sig,SinOsc.kr(SinOsc.kr(100,0,0.5,1),0,0.5pi,0),LFNoise1.kr(0.3,0.2*pi,0));
	env = EnvGen.kr(Env([0,1,0.4,0],[0.2,0.3,4],[7,-5,-3]),doneAction:2);
	sig = sig *env * amp;
	Out.ar(~busElectrico,sig);
}).add;
)