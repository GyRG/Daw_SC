//Samplers
(// Percusiones
if(~outletSamplersPre==[~busSamplersFx],
	{
		~noduloSamplersPre.free;
	},{
		//Bus que será procesado por el nódulo SamplersFx
		// ~busSamplersFx = Bus.audio(s,2);
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busAmbientalPos = Bus.audio(s,2);

});


// Conexiones
// Lets para la señal proveniente de todos los sintes de la agrupación
~inletSamplersPre = [
	~busAmbientalPos
];
//La salida en este caso apunta a todos los efectos disponibles para el conjunto de sintes
~outletSamplersPre = [
	~busSamplersFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloSamplersPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletSamplersPre,
~outletSamplersPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloSamplersPre = Synth(\noduloSamplersPre,
		[\gate,1,\wet,1],
		target:~grupoSamplersPre,
		addAction:\addToHead
	);
});
)
// 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