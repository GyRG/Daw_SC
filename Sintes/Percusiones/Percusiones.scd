(// Percusiones
if(~outletPercsPre==[~busPercsFx],
	{
		~noduloPercsPre.free;
	},{
		//Bus que será procesado por el nódulo PercsFx
		// ~busPercsFx = Bus.audio(s,2);
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busBomboPos = Bus.audio(s,2);
		// ~busTarolaPos = Bus.audio(s,2);
});


// Conexiones
// Lets para la señal proveniente de todos los sintes de la agrupación
~inletPercsPre = [
	~busBomboPos
];
//La salida en este caso apunta a todos los efectos disponibles para el conjunto de sintes
~outletPercsPre = [
	~busPercsFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloPercsPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPercsPre,
~outletPercsPre
);

//Instanciar nódulo Pre efectos del conjunto de sintes
s.waitForBoot({
~noduloPercsPre = Synth(\noduloPercsPre,
		[\gate,1,\wet,1],
		target:~grupoPercsPre,
		addAction:\addToHead
	);
});

)