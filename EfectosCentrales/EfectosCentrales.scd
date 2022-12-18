(// Efectos Centrales
s.waitForBoot({
if(~inletDelayCentral==[~busDelayCentral],{
	~noduloDelayCentral.free;
	~noduloReverbCentral.free;
	~noduloSideChainCentral.free;
	~noduloMezclaFxCentrales.free;
},
{
	// Creación de buses
	~busDelayCentral = Bus.audio(s,2);
	~busReverbCentral = Bus.audio(s,2);
	~busSideChainCentral = Bus.audio(s,2);


	//Señal proveniente de cada efect central
	~busMezclaFxCentralesDelay = Bus.audio(s,2);
	~busMezclaFxCentralesReverb = Bus.audio(s,2);
	~busMezclaFxCentralesSideChain = Bus.audio(s,2);

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

//Lets del módulo de cuyas señal resultante será procesada por el módulo convergencia
~inletMezclaFxCentrales = [
	~busMezclaFxCentralesDelay,
	~busMezclaFxCentralesReverb,
	~busMezclaFxCentralesSideChain
];
~outletMezclaFxCentrales = [
	~busMezclaFxCentrales
];

//Mezcla de todos los efectos centrales
	~crearNodulo.value(\noduloMezclaFxCentrales,{
		|in,env|
		var input;
		input = in;
		input;
	},nil,2,
	~inletMezclaFxCentrales,
	~outletMezclaFxCentrales
	);

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
s.sync;
// Mezcla de todos los efectos centrales
	~noduloMezclaFxCentrales = Synth(\noduloMezclaFxCentrales,
		[\gate,1,\wet,1],
		target:~grupoMezclaFxCentrales,
		addAction:\addToTail
	);

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
s.sync;
});
)