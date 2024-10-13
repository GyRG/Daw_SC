(//Instrumentos
s.waitForBoot({
if(~outletMezclaSintes==[~busMezclaSintes],
	{
		~noduloMezclaSintes.free;
	},{
		//Buses provenientes de cada una de las secciones de sintes
		~busPercs = Bus.audio(s,2);
		~busPads = Bus.audio(s,2);
		~busBajos = Bus.audio(s,2);
		~busModulares = Bus.audio(s,2);
		~busSamplers = Bus.audio(s,2);
});


// Conexiones
// Lets para la señal proveniente de todas las agrupaciones de sintes
~inletMezclaSintes = [
	~busPercs,
	~busPads
];
~outletMezclaSintes = [
	~busMezclaSintes
];

// Definición del módulo
//Mezcla de todas las agrupaciones de sintes
~createDevice.value(\noduloMezclaSintes,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletMezclaSintes,
~outletMezclaSintes
);

s.sync;
//Instanciación de los efectos centrales
	//Mezcla de agrupaciones de los sintes
	~noduloMezclaSintes = Synth(\noduloMezclaSintes,
		[\gate,1,\wet,1],
		target:~grupoMezclaSintes,
		addAction:\addToTail
	);


s.sync;
	Require("Percusiones/EfectosPercusiones.scd");
	Require("Bajos/EfectosBajos.scd");
	Require("Pads/EfectosPads.scd");

});
)
