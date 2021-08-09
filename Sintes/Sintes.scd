(//Instrumentos
if(~inletMezclaSintes==[~busMezclaSintes],
	{
		~noduloMezclaSintes.free;
	},{
		//Buses provenientes de cada una de las secciones de sintes
		~busPercs = Bus.audio(s,2);
});


// Conexiones
// Lets para la señal proveniente de todas las agrupaciones de sintes
~inletMezclaSintes = [
	~busPercs
];
~outletMezclaSintes = [
	~busMezclaSintes
];

// Definición del módulo
//Mezcla de todas las agrupaciones de sintes
~crearNodulo.value(\noduloMezclaSintes,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletMezclaSintes,
~outletMezclaSintes
);


//Instanciación de los efectos centrales
s.waitForBoot({
	//Mezcla de agrupaciones de los sintes
	~noduloMezclaSintes = Synth(\noduloMezclaSintes,
		[\gate,1,\wet,1],
		target:~grupoMezclaSintes,
		addAction:\addToTail
	);
});
)
