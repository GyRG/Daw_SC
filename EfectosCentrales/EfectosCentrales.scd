(// Efectos Centrales
if(~inletDelayCentral==[~busDelayCentral],{
~noduloDelayCentral.free;
~noduloReverbCentral.free;
~noduloSideChainCentral.free;
},
{
// Creación de buses
~busDelayCentral = Bus.audio(s,2);
~busReverbCentral = Bus.audio(s,2);
~busSideChainCentral = Bus.audio(s,2);
}
);


// Conexiones
~inletDelayCentral =[
	~busDelayCentral
];
~outletDelayCentral = [
	~busMezclaFxCentralesDelay
];

~inletReverbCentral = [
	~busReverbCentral
];

~outletReverbCentral = [
	~busMezclaFxCentralesReverb
];

~inletSideChainCentral =[
	~busSideChainCentral
];

~outletSideChainCentral = [
	~busMezclaFxCentralesSideChain
];


//Definición de los efectos Centrales


// Delay Central
~crearNodulo.value(\noduloDelayCentral,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletDelayCentral,
~outletDelayCentral
);

//Reverb Central
~crearNodulo.value(\noduloReverbCentral,
	{|in,env|
		var input;
		input = in;
		input;
},nil,2,
	~inletReverbCentral,
	~outletReverbCentral
);

//SideChain
~crearNodulo.value(\noduloSideChainCentral,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletSideChainCentral,
~outletSideChainCentral
);

//Instanciación de los efectos centrales
s.waitForBoot({
//Delay Central
~noduloDelayCentral = Synth(\noduloDelayCentral,
	[\gate,1,\wet,1],
	target:~grupoDelayCentral,
	addAction:\addToTail
);

// Reverb Central
~noduloReverbCentral = Synth(\noduloReverbCentral,
	[\gate,1,\wet,1],
	target:~grupoReverbCentral,
	addAction:\addToTail
);

// SideChain Central
~noduloSideChainCentral = Synth(\noduloSideChainCentral,
	[\gate,1,\wet,1],
	target:~grupoSideChainCentral,
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

// Synth(\ruidoPrueba,[\freq,120,\gate,1,\out,~busPercs],target:~grupoMezclaSintes,addAction:\addToHead);
Synth(\ruidoPrueba,[\freq,800,\gate,1,\out,~busPercs],target:~grupoPercs,addAction:\addToHead);
// Synth(\ruidoPrueba,[\freq,500,\gate,1,\out,~busPercs],target:~grupoMezclaSintes,addAction:\addToHead);
)
~noduloConvergencia.set(\amp,0.8);
~noduloDelayCentral.set(\amp,1);

~busDelayCentral.value