//Bajos
(// Percusiones
if(~outletBajosPre==[~busBajosFx],
	{
		~noduloBajosPre.free;
	},{
		//Bus que será procesado por el nódulo BajosFx
		// ~busBajosFx = Bus.audio(s,2);
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busAmbientalPos = Bus.audio(s,2);

});


// Conexiones
// Lets para la señal proveniente de todos los sintes de la agrupación
~inletBajosPre = [
	~busAmbientalPos
];
//La salida en este caso apunta a todos los efectos disponibles para el conjunto de sintes
~outletBajosPre = [
	~busBajosFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloBajosPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBajosPre,
~outletBajosPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloBajosPre = Synth(\noduloBajosPre,
		[\gate,1,\wet,1],
		target:~grupoBajosPre,
		addAction:\addToHead
	);
});
)
// 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