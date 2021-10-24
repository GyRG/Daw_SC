(//Efectos de los Tarolas
if(~outletTarolaPos==[~busTarolaPos],
	{

		~noduloTarolaPos.free;
		~noduloTarolaFx.free;
	},{
		// Creación de buses

		~busTarolaFx = Bus.audio(s,2);
		~busTarolaFxPos = Bus.audio(s,2);

});


//TarolaFx
~inletTarolaFx = [~busTarolaFx];
~outletTarolaFx = [~busTarolaFxPos];
// TarolaPos
~inletTarolaPos = [~busTarolaFxPos];
~outletTarolaPos = [~busTarolaPos];

// Efectos de los Tarolas
~crearNodulo.value(\noduloTarolaFx,{
	|in,env|
	var input;
	input =  in ;
	input = in + DynKlank.ar(`[[1/2,5,3/2,1/4],[0.04,0.01,0.04,0.05],[0.15,0.4,0.2,0.3]],in,66,LFNoise2.kr(100,20,110),0.4);
	input  = HPF.ar(LPF.ar(input,9500),550);
	input;
},nil,2,
~inletTarolaFx,
~outletTarolaFx
);

// Mezcla de Tarola Pos Fx
~crearNodulo.value(\noduloTarolaPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletTarolaPos,
~outletTarolaPos
);

//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Tarolas
	~noduloTarolaFx = Synth(\noduloTarolaFx,
		[\gate,1,\wet,1],
		target:~grupoFxTarola,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los Tarolas
	~noduloTarolaPos = Synth(\noduloTarolaPos,
		[\gate,1,\wet,1],
		target:~grupoFxTarola,
		addAction:\addToTail
	);
});
)

