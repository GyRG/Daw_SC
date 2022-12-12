(//Efectos de los Bombos
if(~outletBomboPos==[~busBomboPos],
	{

		~noduloBomboPos.free;
		~noduloBomboFx.free;
	},{
		// Creación de buses

		~busBomboFx = Bus.audio(s,2);
		~busBomboFxPos = Bus.audio(s,2);

});


//BomboFx
~inletBomboFx = [~busBomboFx];
~outletBomboFx = [~busBomboFxPos];
// BomboPos
~inletBomboPos = [~busBomboFxPos];
~outletBomboPos = [~busBomboPos];

// Efectos de los Bombos
~crearNodulo.value(\noduloBomboFx,{
	|in,env|
	var input;
	input =  in ;
	input  = HPF.ar(LPF.ar(input,600),22,0.5);
	input;
},nil,2,
~inletBomboFx,
~outletBomboFx
);

// Mezcla de Bombo Pos Fx
~crearNodulo.value(\noduloBomboPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBomboPos,
~outletBomboPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de los Bombos
	~noduloBomboFx = Synth(\noduloBomboFx,
		[\gate,1,\wet,1],
		target:~grupoFxBombo,
		addAction:\addToHead
	);

	// Mezcla de los efectos de los bombos
	~noduloBomboPos = Synth(\noduloBomboPos,
		[\gate,1,\wet,1],
		target:~grupoFxBombo,
		addAction:\addToTail
	);
});
)