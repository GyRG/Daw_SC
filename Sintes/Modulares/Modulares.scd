//Modulares
(// Percusiones
if(~outletModularesPre==[~busModularesFx],
	{
		~noduloModularesPre.free;
	},{
		//Bus que será procesado por el nódulo ModularesFx
		// ~busModularesFx = Bus.audio(s,2);
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busAmbientalPos = Bus.audio(s,2);

});


// Conexiones
// Lets para la señal proveniente de todos los sintes de la agrupación
~inletModularesPre = [
	~busAmbientalPos
];
//La salida en este caso apunta a todos los efectos disponibles para el conjunto de sintes
~outletModularesPre = [
	~busModularesFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~createDevice.value(\noduloModularesPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletModularesPre,
~outletModularesPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloModularesPre = Synth(\noduloModularesPre,
		[\gate,1,\wet,1],
		target:~grupoModularesPre,
		addAction:\addToHead
	);
});
)
// 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