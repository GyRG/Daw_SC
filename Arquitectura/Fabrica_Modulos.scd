(//Fábrica de módulos
s.waitForBoot({

	// Liberar Grupos
	if(~busDAC==0,
		{
			s.newBusAllocators;
			~noduloMaster.free;
			~noduloMezclaFxFinales.free;
			~noduloFxFinalPrueba1.free;
			~noduloFxFinalPrueba2.free;
			~noduloConvergencia.free;
			~noduloMezclaFxCentrales.free;
			~noduloMezclaSintes.free;
		},
		{
			//Crear Buses

			//Buses entrada y salida de Master
			~busDAC = 0;
			~busMaster = Bus.audio(s,2);

			//Buses Efectos Finales
			~busFxPrueba1 = Bus.audio(s,2);
			~busFxPrueba2 = Bus.audio(s,2);

			//Buses Salida de convergencia a efectos finales
			~busConvergenciaPrueba1 = Bus.audio(s,2);
			~busConvergenciaPrueba2 = Bus.audio(s,2);

			//Bus de salida de la mezcla de todo el
			// conjunto de señales de los efectos centrales
			~busMezclaFxCentrales = Bus.audio(s,2);
			//Señal proveniente de cada efect central
			~busMezclaFxCentralesDelay = Bus.audio(s,2);
			~busMezclaFxCentralesReverb = Bus.audio(s,2);
			~busMezclaFxCentralesSideChain = Bus.audio(s,2);

			// Bus de salida de mezcla total de señales de todas las secciones de sintes
			~busMezclaSintes = Bus.audio(s,2);
			//Señal proveniente de una sección de sintes
			~busPercs = Bus.audio(s,2);
			//Crear Buses

			//Buses entrada y salida de Master
			~busDAC = 0;
			~busMaster = Bus.audio(s,2);

			//Buses Efectos Finales
			~busFxPrueba1 = Bus.audio(s,2);
			~busFxPrueba2 = Bus.audio(s,2);

			//Buses Salida de convergencia a efectos finales
			~busConvergenciaPrueba1 = Bus.audio(s,2);
			~busConvergenciaPrueba2 = Bus.audio(s,2);

			//Bus de salida de la mezcla de todo el
			// conjunto de señales de los efectos centrales
			~busMezclaFxCentrales = Bus.audio(s,2);
			//Señal proveniente de cada efect central
			~busMezclaFxCentralesDelay = Bus.audio(s,2);
			~busMezclaFxCentralesReverb = Bus.audio(s,2);
			~busMezclaFxCentralesSideChain = Bus.audio(s,2);

			// Bus de salida de mezcla total de señales de todas las secciones de sintes
			~busMezclaSintes = Bus.audio(s,2);
			//Señal proveniente de una sección de sintes
			~busPercs = Bus.audio(s,2);
	});

	// Conexiones

	//lets Master
	~inletMaster =[
		~busMaster
	];
	~outletMaster = [
		~busDAC
	];

	//Lets Efectos Finales
	~inletFxFinales =[
		~busFxPrueba1,
		~busFxPrueba2
	];
	~outletFxFinales =[
		~busMaster
	];

	// Lets Efectos Finales  de prueba
	~inletPrueba1 =[
		~busConvergenciaPrueba1
	];
	~outletPrueba1 =[
		~busFxPrueba1
	];
	~inletPrueba2 =[
		~busConvergenciaPrueba2
	];
	~outletPrueba2 =[
		~busFxPrueba2
	];

	//Lets de la convergencia
	~inletConvergencia =[
		~busMezclaFxCentrales,
		~busMezclaSintes
	];
	~outletConvergencia = [
		~busConvergenciaPrueba1,
		~busConvergenciaPrueba2
	];

	//Lets provenientes de los efectos centrales
	~inletMezclaFxCentrales = [
		~busMezclaFxCentralesDelay,
		~busMezclaFxCentralesReverb,
		~busMezclaFxCentralesSideChain
	];
	~outletMezclaFxCentrales = [
		~busMezclaFxCentrales
	];

	// Lets para la señal proveniente de todas las agrupaciones de sintes
	~inletMezclaSintes = [
		~busPercs
	];
	~outletMezclaSintes = [
		~busMezclaSintes
	];

	// Esta función genera una fábrica de efectos
	// Al ejecutarla hay que introducir los argumentos nombre, función, lags y número de canales
	~crearNodulo = { |name, func, lags, numChannels = 2, inlets = 0, outlets = 0 |
		SynthDef(name, { |gate = 1, wet = 1,amp=1|
			var in=0, sound, env, lfo;
			inlets.size.do({|i|
				in = in + In.ar(inlets[i],numChannels)*(1/inlets.size);
			});
			// in = In.ar(inlet, numChannels);
			env = Linen.kr(gate, 2, 1, 2, 2);
			//Se llama a la función wrap para empaquetar las caracteristicas distintivas del efecto
			// de la misma manera, se hace uso de in y env como prependArgs simplemente para no convertirlos
			// en instancias de Control
			sound = SynthDef.wrap(func, lags, [in, env]);
			name.postln;
			inlets.size.postln;
			outlets.size.postln;
			inlets.postln;
			outlets.postln;
			postln("");
			outlets.size.do({|i|
				XOut.ar(outlets[i], wet * env, sound*amp);
			});
		}, [0, 0, 0.1] ).add;
	};

	//Definición de los nodulos

	// Master
	~crearNodulo.value(\noduloMaster,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~inletMaster,
		~outletMaster
	);

	// Mezcla Efectos Convergencia
	~crearNodulo.value(\noduloMezclaFxFinales,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~inletFxFinales,
		~outletFxFinales
	);

	//Prueba efecto final 1
	~crearNodulo.value(\noduloFxFinalPrueba1,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~inletPrueba1,
		~outletPrueba1
	);

	// Prueba efecto final 2
	~crearNodulo.value(\noduloFxFinalPrueba2,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~inletPrueba2,
		~outletPrueba2
	);

	// Convergencia
	~crearNodulo.value(\noduloConvergencia,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~inletConvergencia,
		~outletConvergencia
	);

	//Mezcla de todos los efectos centrales
	~crearNodulo.value(\noduloMezclaFxCentrales,{
		|in,env|
		var input;
		input = in;
		input;
	},nil,2,
	~inletMezclaFxCentrales,
	~outletMezclaFxCentrales
	);

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


	// Instanciación de los módulos
s.waitForBoot({
	// Master
	~noduloMaster = Synth(\noduloMaster,
		[\gate,1,\wet,1],
		target:~grupoMaster,
		addAction:\addToTail
	);

	//Mezcla Efectos Convergencia
	~noduloMezclaFxFinales= Synth(\noduloMezclaFxFinales,
		[\gate,1,\wet,1],
		target:~grupoFxFinales,
		addAction:\addToTail
	);

	//Prueba efecto final 1
	~noduloFxFinalPrueba1 = Synth(\noduloFxFinalPrueba1,
		[\gate,1,\wet,1],
		target:~grupoFxFinales,
		addAction:\addToHead
	);

	//Prueba Efecto Final 2
	~noduloFxFinalPrueba2 = Synth(\noduloFxFinalPrueba2,
		[\gate,1,\wet,1],
		target:~grupoFxFinales,
		addAction:\addToHead
	);

	//Convergencia
	~noduloConvergencia = Synth(\noduloConvergencia,
		[\gate,1,\wet,1],
		target:~grupoConvergencia,
		addAction:\addToTail
	);

	// Mezcla de todos los efectos centrales
	~noduloMezclaFxCentrales = Synth(\noduloMezclaFxCentrales,
		[\gate,1,\wet,1],
		target:~grupoMezclaFxCentrales,
		addAction:\addToTail
	);

	//Mezcla de agrupaciones de los sintes
	~noduloMezclaSintes = Synth(\noduloMezclaSintes,
		[\gate,1,\wet,1],
		target:~grupoMezclaSintes,
		addAction:\addToTail
	);
	});

};
)
)
