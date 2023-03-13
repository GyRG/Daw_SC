(//Fábrica de módulos
s.waitForBoot({
	var rackName = \FX;

	var nextRackName = \DAC, nextModuleName = \Convergencia, nextDeviceName = \finalDAC, nextBusName = \busMezclaFxCentrales;

	var deviceName = \fxDAC;
	var grupoEntrada = [\DelayCentral,\ReverbCentral,\SidechainCentral], grupoSalida = \MezclaFxCentrales;
	var fxGroup = \FxCentrales;
	var rackOutlet = \outletFXCentrales, rackInlet = [\busDelayIn,\busReverbIn,\busSidechainIn];

	var outModule = \moduloMasterCentralFX;

	// Liberar Grupos
	if(~grupos[rackName][\instanciada] == false,
		{

			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~grupos.add(rackName -> IdentityDictionary.new);


			// //Grupo por efectos generales
			~grupos[rackName].add(fxGroup -> Group.before(~grupos[nextRackName][nextModuleName]));

			//Este grupo será únicamente para mezclar las salidas de los efectos
			~grupos[rackName].add(grupoSalida -> Group.tail(~grupos[rackName][fxGroup]));

			// //Grupo por efectos por tipo de instrumento
			~grupos[rackName].add(grupoEntrada[0] -> Group.tail(~grupos[rackName][fxGroup]));
			~grupos[rackName].add(grupoEntrada[1] -> Group.tail(~grupos[rackName][fxGroup]));
			~grupos[rackName].add(grupoEntrada[2] -> Group.tail(~grupos[rackName][fxGroup]));


		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~grupos[rackName].add(\instanciateda -> true);


	~dac.add(deviceName -> IdentityDictionary.new);

	//Crear Buses
	~dac[deviceName].add(
		\buses -> IdentityDictionary.with(*[
			//Buses entrada del módulo
			rackInlet[0] -> Bus.audio(s,2),
			rackInlet[1] -> Bus.audio(s,2),
			rackInlet[2] -> Bus.audio(s,2),

			//Buses provinientes de cada efecto para la mezcla
			\busDelayOut -> Bus.audio(s,2),
			\busReverbOut -> Bus.audio(s,2),
			\busSidechainOut -> Bus.audio(s,2)
		]);
	);



	~dac[deviceName].add(
		\lets -> IdentityDictionary.with(*[
			//Mapeo de buses para lets del modulo de mezcla
			rackOutlet -> [
				~dac[nextDeviceName][\buses][nextBusName]
			],
			\inletMezcla -> [
				~dac[deviceName][\buses][\busDelayOut],
				~dac[deviceName][\buses][\busReverbOut],
				~dac[deviceName][\buses][\busSidechainOut]
			],

			// Lets de cada efecto

			//Delay
			\outletDelay-> [
				~dac[deviceName][\buses][\busDelayOut]
			],
			\inletDelay -> [
				~dac[deviceName][\buses][rackInlet[0]]
			],
			// Reverb
			\outletReverb-> [
				~dac[deviceName][\buses][\busReverbOut]
			],
			\inletReverb -> [
				~dac[deviceName][\buses][rackInlet[1]]
			],
			// Sidechain
			\outletSidechain -> [
				~dac[deviceName][\buses][\busSidechainOut]
			],
			\inletSidechain  -> [
				~dac[deviceName][\buses][rackInlet[2]]
			]
		]);
	);


	//Definición de los nodulos del procesamiento final
	// Mezcla Fx
	~crearNodulo.value(outModule,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletMezcla],
		~dac[deviceName][\lets][rackOutlet]
	);


	//Delay
	~crearNodulo.value(\moduloDelay,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletDelay],
		~dac[deviceName][\lets][\outletDelay]
	);
	//Reverb
	~crearNodulo.value(\moduloReverb,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletReverb],
		~dac[deviceName][\lets][\outletReverb]
	);
	//Delay
	~crearNodulo.value(\moduloSidechain,
		{|in, env|
			var input;
			input = in;
			input;
		},
		nil,
		2,
		~dac[deviceName][\lets][\inletSidechain],
		~dac[deviceName][\lets][\outletSidechain]
	);

	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

	~dac[deviceName].add(

		\modulos -> Dictionary.with(*[
			//Mezcla
			outModule -> Synth(outModule,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoSalida],
				addAction:\addToTail
			),

			//Delay
			\moduloDelay -> Synth(\moduloDelay,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoEntrada[0]],
				addAction:\addToTail
			),

			//Reverb
			\moduloReverb -> Synth(\moduloReverb,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoEntrada[1]],
				addAction:\addToHead
			),

			//Sidechain
			\moduloSidechain -> Synth(\moduloSidechain,
				[\gate,1,\wet,1],
				target:~grupos[rackName][grupoEntrada[2]],
				addAction:\addToHead
			)
		]);
	);

	s.sync;
	Require("../Sintes/Synths.scd");
};
)
);

