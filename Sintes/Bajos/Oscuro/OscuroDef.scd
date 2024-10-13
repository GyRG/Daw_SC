// Oscuro
(// OscuroDef
if(~outletOscuroPre==[~busOscuroFx],
	{
		~noduloOscuroPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busOscuro = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef Oscuro
~inletOscuroPre = [
	~busOscuro
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del Oscuro
~outletOscuroPre = [
	~busOscuroFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~createDevice.value(\noduloOscuroPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletOscuroPre,
~outletOscuroPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloOscuroPre = Synth(\noduloOscuroPre,
		[\gate,1,\wet,1],
		target:~grupoOscuro,
		addAction:\addToHead
	);
});
)

(
SynthDef(\oscuro,{

	|out = 0, freq=400,amp=0.2|
	var sig=0, env, enf;
	6.do({
		sig = sig+SinOsc.ar(freq+rrand(-2,2),0,0.1);
	});
	sig = sig + VarSaw.ar(freq/2,0,LFNoise0.kr(5,0.01,0.5),0.5)+LFNoise2.ar(2,1,0.5);
	sig = PanB.ar(sig,SinOsc.kr(SinOsc.kr(100,0,0.5,1),0,0.5pi,0),LFNoise1.kr(0.3,0.2*pi,0));
	env = EnvGen.kr(Env([0,1,0.4,0],[0.2,0.3,4],[7,-5,-3]),doneAction:2);
	sig = sig *env * amp;
	Out.ar(~busOscuro,sig);
}).add;
)