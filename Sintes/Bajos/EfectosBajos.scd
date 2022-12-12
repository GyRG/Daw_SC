//EfectosBajos
(//Efectos Percusiones
if(~outletBajosPos==[~busBajos],
	{

		~noduloBajosPos.free;
		~noduloBajosFx.free;
	},{
		// Creación de buses

		~busBajosFx = Bus.audio(s,2);
		~busBajosFxPos = Bus.audio(s,2);

});



//BajosFx
~inletBajosFx = [~busBajosFx];
~outletBajosFx = [~busBajosFxPos];
// BajosPos
~inletBajosPos = [~busBajosFxPos];
~outletBajosPos = [~busBajos];

// Efectos de las Bajos
~crearNodulo.value(\noduloBajosFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBajosFx,
~outletBajosFx
);

// Mezcla de percusiones Pos Fx
~crearNodulo.value(\noduloBajosPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBajosPos,
~outletBajosPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de las percusiones
	~noduloBajosFx = Synth(\noduloBajosFx,
		[\gate,1,\wet,1],
		target:~grupoFxBajos,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Bajos
	~noduloBajosPos = Synth(\noduloBajosPos,
		[\gate,1,\wet,1],
		target:~grupoFxBajos,
		addAction:\addToTail
	);
});
)