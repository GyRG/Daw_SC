(//Efectos Percusiones
if(~inletBomboWSh==[~busBomboWShPre],
	{
		~noduloBomboWSh.free;
		~noduloBomboPos.free;
		~noduloPercsPre.free;
		~noduloPercsPos.free;
		~noduloPercsComp.free;
},{
	// Creación de buses
~busBomboWShPre = Bus.audio(s,2);
~busBomboWShPos = Bus.audio(s,2);
~busPercsPre = Bus.audio(s,2);
~busPercsComPre = Bus.audio(s,2);
~busPercsComPos = Bus.audio(s,2);
		// ~busPercs = Bus.audio(s,2);
});



// Conexiones
//BomboWSh
~inletBomboWSh = [~busBomboWShPre];
~outletBomboWSh = [~busBomboWShPos];
// BomboPos
~inletBomboPos = [~busBomboWShPos];
~outletBomboPos = [~busPercsPre];
//PercsPre
~inletPercsPre = [~busPercsPre];
~outletPercsPre = [~busPercsComPre];
//PercsFx
~inletPercsComp = [~busPercsComPre];
~outletPercsComp = [~busPercsComPos];
// PercsPos
~inletPercsPos = [~busPercsComPos];
~outletPercsPos = [~busPercs];



// WaveShaper del bombo
~crearNodulo.value(\noduloBomboWSh,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBomboWSh,
~outletBomboWSh
);

// Mezcla del bombo Pos Fx
~crearNodulo.value(\noduloBomboPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBomboPos,
~outletBomboPos
);

// Mezcla de todas las Percs
~crearNodulo.value(\noduloPercsPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsPre,
~outletPercsPre
);

// Efectos de las percs en este caso un compresor
~crearNodulo.value(\noduloPercsComp,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsComp,
~outletPercsComp
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



//Instanciación de los efectos centrales
s.waitForBoot({


// WaveShaper del bombo
~noduloBomboWSh = Synth(\noduloBomboWSh,
	[\gate,1,\wet,1],
	target:~grupoFxBombo,
	addAction:\addToTail
);


// Mezcla final del bombo
~noduloBomboPos = Synth(\noduloBomboPos,
	[\gate,1,\wet,1],
	target:~grupoFxBombo,
	addAction:\addToTail
);

// Mezcla Percs
~noduloPercs = Synth(\noduloPercsPre,
	[\gate,1,\wet,1],
	target:~grupoPercsPre,
	addAction:\addToTail
);

// Compresor de las percusiones
~noduloPercsComp = Synth(\noduloPercsComp,
	[\gate,1,\wet,1],
	target:~grupoFxPercs,
	addAction:\addToHead
);

// Mezcla Percs
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
// Synth(\ruidoPrueba,[\freq,1200,\gate,1,\out,~busMezclaFxCentralesDelay],target:~grupoMezclaFxCentrales,addAction:\addToHead);
// Synth(\ruidoPrueba,[\freq,500,\gate,1,\out,~busSeccionPercusiones],target:~grupoMezclaSintes,addAction:\addToHead);
)


~noduloMaster.set(\amp,0.01);