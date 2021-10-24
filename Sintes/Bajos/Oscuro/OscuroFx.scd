// Polyphonic FX
(//Efectos de los Oscuros
if(~outletOscuroPos==[~busOscuroPos],
	{

		~noduloOscuroPos.free;
		~noduloOscuroFx.free;
	},{
		// Creación de buses

		~busOscuroFx = Bus.audio(s,2);
		~busOscuroFxPos = Bus.audio(s,2);

});


//OscuroFx
~inletOscuroFx = [~busOscuroFx];
~outletOscuroFx = [~busOscuroFxPos];
// OscuroPos
~inletOscuroPos = [~busOscuroFxPos];
~outletOscuroPos = [~busOscuroPos];

// Efectos de los Oscuros
~crearNodulo.value(\noduloOscuroFx,{
	|in,env|
	var input;
	input =  in ;
	input  = HPF.ar(LPF.ar(input,600),22,0.5);
	input;
},nil,2,
~inletOscuroFx,
~outletOscuroFx
);

// Mezcla de Oscuro Pos Fx
~crearNodulo.value(\noduloOscuroPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletOscuroPos,
~outletOscuroPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Oscuros
	~noduloOscuroFx = Synth(\noduloOscuroFx,
		[\gate,1,\wet,1],
		target:~grupoFxOscuro,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los Oscuros
	~noduloOscuroPos = Synth(\noduloOscuroPos,
		[\gate,1,\wet,1],
		target:~grupoFxOscuro,
		addAction:\addToTail
	);
});
)