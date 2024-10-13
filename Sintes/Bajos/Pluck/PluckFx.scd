// Polyphonic FX
(//Efectos de los Electricos
if(~outletElectricoPos==[~busElectricoPos],
	{

		~noduloElectricoPos.free;
		~noduloElectricoFx.free;
	},{
		// Creación de buses

		~busElectricoFx = Bus.audio(s,2);
		~busElectricoFxPos = Bus.audio(s,2);

});


//ElectricoFx
~inletElectricoFx = [~busElectricoFx];
~outletElectricoFx = [~busElectricoFxPos];
// ElectricoPos
~inletElectricoPos = [~busElectricoFxPos];
~outletElectricoPos = [~busElectricoPos];

// Efectos de los Electricos
~createDevice.value(\noduloElectricoFx,{
	|in,env|
	var input;
	input =  in ;
	input  = HPF.ar(LPF.ar(input,600),22,0.5);
	input;
},nil,2,
~inletElectricoFx,
~outletElectricoFx
);

// Mezcla de Electrico Pos Fx
~createDevice.value(\noduloElectricoPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletElectricoPos,
~outletElectricoPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Electricos
	~noduloElectricoFx = Synth(\noduloElectricoFx,
		[\gate,1,\wet,1],
		target:~grupoFxElectrico,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los Electricos
	~noduloElectricoPos = Synth(\noduloElectricoPos,
		[\gate,1,\wet,1],
		target:~grupoFxElectrico,
		addAction:\addToTail
	);
});
)