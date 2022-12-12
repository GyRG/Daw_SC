// Polyphonic FX
(//Efectos de los Ambientals
if(~outletAmbientalPos==[~busAmbientalPos],
	{

		~noduloAmbientalPos.free;
		~noduloAmbientalFx.free;
	},{
		// Creación de buses

		~busAmbientalFx = Bus.audio(s,2);
		~busAmbientalFxPos = Bus.audio(s,2);

});


//AmbientalFx
~inletAmbientalFx = [~busAmbientalFx];
~outletAmbientalFx = [~busAmbientalFxPos];
// AmbientalPos
~inletAmbientalPos = [~busAmbientalFxPos];
~outletAmbientalPos = [~busAmbientalPos];

// Efectos de los Ambientals
~crearNodulo.value(\noduloAmbientalFx,{
	|in,env|
	var input;
	input =  in ;
	input  = HPF.ar(LPF.ar(input,600),22,0.5);
	input;
},nil,2,
~inletAmbientalFx,
~outletAmbientalFx
);

// Mezcla de Ambiental Pos Fx
~crearNodulo.value(\noduloAmbientalPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletAmbientalPos,
~outletAmbientalPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Ambientals
	~noduloAmbientalFx = Synth(\noduloAmbientalFx,
		[\gate,1,\wet,1],
		target:~grupoFxAmbiental,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los Ambientals
	~noduloAmbientalPos = Synth(\noduloAmbientalPos,
		[\gate,1,\wet,1],
		target:~grupoFxAmbiental,
		addAction:\addToTail
	);
});
)