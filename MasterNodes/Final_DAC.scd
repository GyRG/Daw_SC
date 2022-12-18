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

			// Bus de salida de mezcla total de señales de todas las secciones de sintes
			~busMezclaSintes = Bus.audio(s,2);

			//Buses entrada y salida de Master
			~busDAC = 0;
			~busMaster = Bus.audio(s,2);

			//Buses Efectos Finales
			~busFxPrueba1 = Bus.audio(s,2);
			~busFxPrueba2 = Bus.audio(s,2);

			//Buses Salida de convergencia a efectos finales
			~busConvergenciaPrueba1 = Bus.audio(s,2);
			~busConvergenciaPrueba2 = Bus.audio(s,2);

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

	//Definición de los nodulos del procesamiento final
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



	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

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
s.sync;
};
)
)
