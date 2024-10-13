(//Fábrica de módulos
s.waitForBoot({
	var rackName = \FX;

	var nextRackName = \DAC, nextModuleName = \Convergencia, nextDeviceName = \finalDAC, nextBusName = \busMezclaFxCentrales;

	var deviceName = \fxDAC;
	var inGroup = [\DelayCentral,\ReverbCentral,\SidechainCentral], outGroup = \MezclaFxCentrales;
	var fxGroup = \FxCentrales;
	var rackOutlet = \outletFXCentrales, rackInlet = [\busDelayIn,\busReverbIn,\busSidechainIn];

	var outModule = \moduloMasterCentralFX;
	var num_output_channels = 2;

	// Liberar groups
	if(~groups[rackName][\instanciada] == false,
		{

			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~groups.add(rackName -> IdentityDictionary.new);


			// //Grupo por efectos generales
			~groups[rackName].add(fxGroup -> Group.before(~groups[nextRackName][nextModuleName]));

			//Este grupo será únicamente para mezclar las salidas de los efectos
			~groups[rackName].add(outGroup -> Group.tail(~groups[rackName][fxGroup]));

			// //Grupo por efectos por tipo de instrumento
			inGroup.do({|x,i|
				~groups[rackName].add(inGroup[i] -> Group.head(~groups[rackName][fxGroup]));

			});

		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~groups[rackName].add(\instanciateda -> true);


	~dac.add(deviceName -> IdentityDictionary.new);

	//Crear Buses
	~dac[deviceName].add(
		\buses -> IdentityDictionary.with(*[
			//Buses entrada del módulo
			rackInlet[0] -> Bus.audio(s,num_output_channels),
			rackInlet[1] -> Bus.audio(s,num_output_channels),
			rackInlet[2] -> Bus.audio(s,num_output_channels),

			//Buses provinientes de cada efecto para la mezcla
			\busDelayOut -> Bus.audio(s,num_output_channels),
			\busReverbOut -> Bus.audio(s,num_output_channels),
			\busSidechainOut -> Bus.audio(s,num_output_channels)
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
	~createDevice.value(outModule,
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
	~createDevice.value(\moduloDelay,
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
	~createDevice.value(\moduloReverb,
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
	~createDevice.value(\moduloSidechain,
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
				target:~groups[rackName][outGroup],
				addAction:\addToTail
			),

			//Delay
			\moduloDelay -> Synth(\moduloDelay,
				[\gate,1,\wet,1],
				target:~groups[rackName][inGroup[0]],
				addAction:\addToTail
			),

			//Reverb
			\moduloReverb -> Synth(\moduloReverb,
				[\gate,1,\wet,1],
				target:~groups[rackName][inGroup[1]],
				addAction:\addToHead
			),

			//Sidechain
			\moduloSidechain -> Synth(\moduloSidechain,
				[\gate,1,\wet,1],
				target:~groups[rackName][inGroup[2]],
				addAction:\addToHead
			)
		]);
	);

	s.sync;
	Require("../Sintes/Synths.scd");
};
)
);

