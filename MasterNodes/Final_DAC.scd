(//Final DAC
s.waitForBoot({
	var rackName = \DAC;
	var deviceName = \finalDAC;
	var grupoEntrada = \Convergencia, grupoSalida = \Master;
	var fxGroup = \FxFinales;
	var rackOutlet = \outletMaster, rackInlet = \inletConvergencia;
	var outModule = \moduloMaster;
	var num_output_channels = 2;


	// Liberar Grupos
	if(~grupos[rackName][\instanciada] == false,
		{

			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~grupos.add(rackName -> IdentityDictionary.new);

			//Grupo Master
			~grupos[rackName].add(grupoSalida -> Group.tail(s.defaultGroup));

			//Grupo efectos convergencia
			~grupos[rackName].add(fxGroup -> Group.before(~grupos[rackName][grupoSalida]));

			//Grupo convergencia
			~grupos[rackName].add(grupoEntrada -> Group.before(~grupos[rackName][fxGroup]));


		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~grupos[rackName].add(\instanciateda-> true);


	~dac.add(deviceName -> IdentityDictionary.new);

	//Crear Buses
	~dac[deviceName].add(
		\buses -> IdentityDictionary.with(*[
			//Buses entrada y salida de Master
			\busDAC -> 0,
			\busMaster -> Bus.audio(s,num_output_channels),
			//Buses Efectos Finales
			\busFxPrueba1 -> Bus.audio(s,num_output_channels),
			\busFxPrueba2 -> Bus.audio(s,num_output_channels),
			//Buses Salida de convergencia a efectos finales
			\busConvergenciaPrueba1 -> Bus.audio(s,num_output_channels),
			\busConvergenciaPrueba2 -> Bus.audio(s,num_output_channels),
			//Bus de salida de la mezcla de todo el
			// conjunto de señales de los efectos centrales
			\busMezclaFxCentrales -> Bus.audio(s,num_output_channels),
			// Bus de salida de mezcla total de señales de todas las secciones de sintes
			\busMezclaSintes -> Bus.audio(s,num_output_channels)

		]);
	);



	~dac[deviceName].add(
		\lets -> IdentityDictionary.with(*[
			//Entradas y salidas principales del módulo Master
			rackOutlet -> [
				~dac[deviceName][\buses][\busDAC]
			],
			\inletMaster -> [
				~dac[deviceName][\buses][\busMaster]
			],

			// Lets Efectos Finales  de prueba
			\inletFxFinales -> [
				~dac[deviceName][\buses][\busFxPrueba1],
				~dac[deviceName][\buses][\busFxPrueba2]
			],
			\outletFxFinales -> [
				~dac[deviceName][\buses][\busMaster]
			],

			\outletPrueba1 -> [
				~dac[deviceName][\buses][\busFxPrueba1]
			],
			\inletPrueba1 -> [
				~dac[deviceName][\buses][\busConvergenciaPrueba1]
			],
			\outletPrueba2 -> [
				~dac[deviceName][\buses][\busFxPrueba2]
			],
			\inletPrueba2 -> [
				~dac[deviceName][\buses][\busConvergenciaPrueba2]
			],

			\outletConvergencia -> [
				~dac[deviceName][\buses][\busConvergenciaPrueba1],
				~dac[deviceName][\buses][\busConvergenciaPrueba2]
			],
			rackInlet -> [
				~dac[deviceName][\buses][\busMezclaFxCentrales],
				~dac[deviceName][\buses][\busMezclaSintes]
			]
		]);
	);


	//Definición de los nodulos del procesamiento final
	// Master
	~crearNodulo.value(outModule,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletMaster],
		~dac[deviceName][\lets][rackOutlet]
	);

	// Mezcla Efectos Convergencia
	~crearNodulo.value(\moduloMezclaFxFinales,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletFxFinales],
		~dac[deviceName][\lets][\outletFxFinales]
	);

	//Prueba efecto final 1
	~crearNodulo.value(\moduloFxFinalPrueba1,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletPrueba1],
		~dac[deviceName][\lets][\outletPrueba1]
	);

	// Prueba efecto final 2
	~crearNodulo.value(\moduloFxFinalPrueba2,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletPrueba2],
		~dac[deviceName][\lets][\outletPrueba2]
	);

	// Convergencia
	~crearNodulo.value(\moduloConvergencia,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][rackInlet],
		~dac[deviceName][\lets][\outletConvergencia]
	);



	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

	~dac[deviceName].add(

		\modulos -> Dictionary.with(*[
			// Master
			outModule -> Synth(outModule,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoSalida],
				addAction:\addToTail
			),

			//Mezcla Efectos Convergencia
			\moduloMezclaFxFinales -> Synth(\moduloMezclaFxFinales,
				[\gate,1,\wet,1],
				target:~grupos[rackName][fxGroup],
				addAction:\addToTail
			),

			//Prueba efecto final 1
			\moduloFxFinalPrueba1 -> Synth(\moduloFxFinalPrueba1,
				[\gate,1,\wet,1],
				target:~grupos[rackName][fxGroup],
				addAction:\addToHead
			),

			//Prueba Efecto Final 2
			\moduloFxFinalPrueba2 -> Synth(\moduloFxFinalPrueba2,
				[\gate,1,\wet,1],
				target:~grupos[rackName][fxGroup],
				addAction:\addToHead
			),

			//Convergencia
			\moduloConvergencia -> Synth(\moduloConvergencia,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoEntrada],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
	Require("../EfectosCentrales/FX_Centrales.scd");

};
)
);

