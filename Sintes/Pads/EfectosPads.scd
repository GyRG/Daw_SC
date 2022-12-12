//EfectosPads
(//Efectos Percusiones
if(~outletPadsPos==[~busPads],
	{

		~noduloPadsPos.free;
		~noduloPadsFx.free;
	},{
		// Creación de buses

		~busPadsFx = Bus.audio(s,2);
		~busPadsFxPos = Bus.audio(s,2);

});



//PadsFx
~inletPadsFx = [~busPadsFx];
~outletPadsFx = [~busPadsFxPos];
// PadsPos
~inletPadsPos = [~busPadsFxPos];
~outletPadsPos = [~busPads];

// Efectos de las Pads
~crearNodulo.value(\noduloPadsFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPadsFx,
~outletPadsFx
);

// Mezcla de percusiones Pos Fx
~crearNodulo.value(\noduloPadsPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPadsPos,
~outletPadsPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de las percusiones
	~noduloPadsFx = Synth(\noduloPadsFx,
		[\gate,1,\wet,1],
		target:~grupoFxPads,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Pads
	~noduloPadsPos = Synth(\noduloPadsPos,
		[\gate,1,\wet,1],
		target:~grupoFxPads,
		addAction:\addToTail
	);
});
)