(//Efectos de los Hihats
if(~outletHihatPos==[~busHihatPos],
	{

		~noduloHihatPos.free;
		~noduloHihatFx.free;
	},{
		// Creación de buses

		~busHihatFx = Bus.audio(s,2);
		~busHihatFxPos = Bus.audio(s,2);

});


//HihatFx
~inletHihatFx = [~busHihatFx];
~outletHihatFx = [~busHihatFxPos];
// HihatPos
~inletHihatPos = [~busHihatFxPos];
~outletHihatPos = [~busHihatPos];

// Efectos de los Hihats
~crearNodulo.value(\noduloHihatFx,{
	|in,env|
	var input;
	input =  in ;
	input = in + DynKlank.ar(`[[1/2,3,3/2],[0.04,0.01,0.04],[0.15,0.4,0.2]],in,160,LFNoise2.kr(100,20,510),0.4);
	input  = HPF.ar(LPF.ar(input,10000),5000);
	input;
},nil,2,
~inletHihatFx,
~outletHihatFx
);

// Mezcla de Hihat Pos Fx
~crearNodulo.value(\noduloHihatPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletHihatPos,
~outletHihatPos
);

//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Hihats
	~noduloHihatFx = Synth(\noduloHihatFx,
		[\gate,1,\wet,1],
		target:~grupoFxHihat,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los Hihats
	~noduloHihatPos = Synth(\noduloHihatPos,
		[\gate,1,\wet,1],
		target:~grupoFxHihat,
		addAction:\addToTail
	);
});
)