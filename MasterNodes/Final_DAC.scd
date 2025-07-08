(//Final DAC
s.waitForBoot({
	var rackName = \DAC;
	var deviceName = \finalDAC;
	var inGroup = \Convergencia, outGroup = \Master;
	var fxGroup = \FxFinales;
	var rackOutlet = \outletMaster, rackInlet = \inletConvergencia;
	var outModule = \moduloMaster;
	var num_output_channels = 2;


	// Liberar groups
	if(~groups[rackName][\instanciada] == false,
		{

			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~groups.add(rackName -> IdentityDictionary.new);

			//Grupo Master
			~groups[rackName].add(outGroup -> Group.tail(s.defaultGroup));

			//Grupo efectos convergencia
			~groups[rackName].add(fxGroup -> Group.before(~groups[rackName][outGroup]));

			//Grupo convergencia
			~groups[rackName].add(inGroup -> Group.before(~groups[rackName][fxGroup]));


		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~groups[rackName].add(\instanciateda-> true);


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
	~createDevice.value(outModule,
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
	~createDevice.value(\moduloMezclaFxFinales,
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
	~createDevice.value(\moduloFxFinalPrueba1,
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
	~createDevice.value(\moduloFxFinalPrueba2,
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
	~createDevice.value(\moduloConvergencia,
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
				target:~groups[rackName][outGroup],
				addAction:\addToTail
			),

			//Mezcla Efectos Convergencia
			\moduloMezclaFxFinales -> Synth(\moduloMezclaFxFinales,
				[\gate,1,\wet,1],
				target:~groups[rackName][fxGroup],
				addAction:\addToTail
			),

			//Prueba efecto final 1
			\moduloFxFinalPrueba1 -> Synth(\moduloFxFinalPrueba1,
				[\gate,1,\wet,1],
				target:~groups[rackName][fxGroup],
				addAction:\addToHead
			),

			//Prueba Efecto Final 2
			\moduloFxFinalPrueba2 -> Synth(\moduloFxFinalPrueba2,
				[\gate,1,\wet,1],
				target:~groups[rackName][fxGroup],
				addAction:\addToHead
			),

			//Convergencia
			\moduloConvergencia -> Synth(\moduloConvergencia,
				[\gate,1,\wet,1],
				target:~groups[rackName][inGroup],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
	Require("../EfectosCentrales/FX_Centrales.scd");

};
)
);

