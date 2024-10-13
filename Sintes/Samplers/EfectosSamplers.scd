//EfectosSamplers
(//Efectos Percusiones
if(~outletSamplersPos==[~busSamplers],
	{

		~noduloSamplersPos.free;
		~noduloSamplersFx.free;
	},{
		// Creación de buses

		~busSamplersFx = Bus.audio(s,2);
		~busSamplersFxPos = Bus.audio(s,2);

});



//SamplersFx
~inletSamplersFx = [~busSamplersFx];
~outletSamplersFx = [~busSamplersFxPos];
// SamplersPos
~inletSamplersPos = [~busSamplersFxPos];
~outletSamplersPos = [~busSamplers];

// Efectos de las Samplers
~createDevice.value(\noduloSamplersFx,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletSamplersFx,
~outletSamplersFx
);

// Mezcla de percusiones Pos Fx
~createDevice.value(\noduloSamplersPos,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletSamplersPos,
~outletSamplersPos
);



//Instanciación de los efectos de cada conjunto de sintes
s.waitForBoot({

	// Fx de las percusiones
	~noduloSamplersFx = Synth(\noduloSamplersFx,
		[\gate,1,\wet,1],
		target:~grupoFxSamplers,
		addAction:\addToHead
	);

	// Mezcla de los efectos de las Samplers
	~noduloSamplersPos = Synth(\noduloSamplersPos,
		[\gate,1,\wet,1],
		target:~grupoFxSamplers,
		addAction:\addToTail
	);
});
)