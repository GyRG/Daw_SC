(//Efectos Percusiones
s.waitForBoot({
if(~outletPercsPos==[~busPercs],
	{

		~noduloPercsPos.free;
		~noduloPercsFx.free;
	},{
		// Creación de buses

		~busPercsFx = Bus.audio(s,2);
		~busPercsFxPos = Bus.audio(s,2);

});



//PercsFx
~inletPercsFx = [~busPercsFx];
~outletPercsFx = [~busPercsFxPos];
// PercsPos
~inletPercsPos = [~busPercsFxPos];
~outletPercsPos = [~busPercs];

// Efectos de las percs
~crearNodulo.value(\noduloPercsFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsFx,
~outletPercsFx
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



//Instanciación de los efectos de cada conjunto de sintes
s.sync;
	// Fx de las percusiones
	~noduloPercsFx = Synth(\noduloPercsFx,
		[\gate,1,\wet,1],
		target:~grupoFxPercs,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Percs
	~noduloPercsPos = Synth(\noduloPercsPos,
		[\gate,1,\wet,1],
		target:~grupoFxPercs,
		addAction:\addToTail
	);
	s.sync;
	Require("Percusiones.scd");

});
)