//EfectosModulares
(//Efectos Percusiones
if(~outletModularesPos==[~busModulares],
	{

		~noduloModularesPos.free;
		~noduloModularesFx.free;
	},{
		// Creación de buses

		~busModularesFx = Bus.audio(s,2);
		~busModularesFxPos = Bus.audio(s,2);

});



//ModularesFx
~inletModularesFx = [~busModularesFx];
~outletModularesFx = [~busModularesFxPos];
// ModularesPos
~inletModularesPos = [~busModularesFxPos];
~outletModularesPos = [~busModulares];

// Efectos de las Modulares
~crearNodulo.value(\noduloModularesFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletModularesFx,
~outletModularesFx
);

// Mezcla de percusiones Pos Fx
~crearNodulo.value(\noduloModularesPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletModularesPos,
~outletModularesPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de las percusiones
	~noduloModularesFx = Synth(\noduloModularesFx,
		[\gate,1,\wet,1],
		target:~grupoFxModulares,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Modulares
	~noduloModularesPos = Synth(\noduloModularesPos,
		[\gate,1,\wet,1],
		target:~grupoFxModulares,
		addAction:\addToTail
	);
});
)