//Pads
(// Percusiones
s.waitForBoot({
if(~outletPadsPre==[~busPadsFx],
	{
		~noduloPadsPre.free;
	},{
		//Bus que será procesado por el nódulo PadsFx
		// ~busPadsFx = Bus.audio(s,2);
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busAmbientalPos = Bus.audio(s,2);

});


// Conexiones
// Lets para la señal proveniente de todos los sintes de la agrupación
~inletPadsPre = [
	~busAmbientalPos
];
//La salida en este caso apunta a todos los efectos disponibles para el conjunto de sintes
~outletPadsPre = [
	~busPadsFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~crearNodulo.value(\noduloPadsPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletPadsPre,
~outletPadsPre
);
s.sync;
//Instanciar nódulo Pre efectos del conjunto de sintes
~noduloPadsPre = Synth(\noduloPadsPre,
		[\gate,1,\wet,1],
		target:~grupoPadsPre,
		addAction:\addToHead
	);
s.sync;
});
)
