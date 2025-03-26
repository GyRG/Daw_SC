(//Salida de efectos de Secciòn de bajos
s.waitForBoot({
	var rackName = \SYNTHS;
	var sectionName = \Drums;

	var nextRackName = \SYNTHS, nextModuleName = \Drums, nextDeviceName = \drumsFx, nextBusName = \busKickMain;

	var instrumentName = \drumsKick;
	var deviceName = \drumsKickDVC;
	var mainSynthGroup = \Drums;
	var rackOutlet = \busKickMain, rackInlet = \busKickInstance;

	var outModule = \kickDrums;

	// Liberar groups
	if(~groups[rackName][sectionName][instrumentName][\instanciada] == false,
		{
			// El grupo de la seccion de instrumentos se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses

			//Grupo para todas las secciones de instrumentos
			~groups[rackName][sectionName][instrumentName].add(deviceName -> ParGroup.head(~groups[nextRackName][sectionName][mainSynthGroup]))


		}, {
			//s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
			~dac[deviceName][\buses].do({|n| n.free});

	});


	~groups[rackName][sectionName][instrumentName].add(\instanciada -> true);


	~dac.add(deviceName -> IdentityDictionary.new);

	//Crear Buses
	~dac[deviceName].add(
		\buses -> IdentityDictionary.with(*[

			//Buses entrada al módulo de mezcla de sintes
			rackInlet -> Bus.audio(s,2)
		]);
	);



	~dac[deviceName].add(
		\lets -> IdentityDictionary.with(*[
			//Mapeo de buses para lets del modulo de mezcla
			rackOutlet -> [
				~dac[nextDeviceName][\buses][nextBusName]
			],
			rackInlet -> [~dac[deviceName][\buses][rackInlet]],
			//\inletMezcla ->
		]);
	);


	//Definición de los nodulos del procesamiento final
	// Mezcla Fx
	~createDevice.value(outModule,
		{|in, env|
			var input;
			input = in;
			input = CrossoverDistortion.ar(input, amp: 0.2, smooth: 1, mul: 1, add: 0);
			input = Compander.ar(in,0,0.7,0.1,1,0.4,0.4);
			input = BPF.ar(in,140,4,1)+BPF.ar(in,150,1)+LPF.ar(in,600,0.07);
			input!2;
		},
		nil,
		1,
		~dac[deviceName][\lets][rackInlet],
		~dac[deviceName][\lets][rackOutlet]
	);


	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

	~dac[deviceName].add(

		\modulos -> Dictionary.with(*[
			//Mezcla
			outModule -> Synth(outModule,
				[\gate,1,\wet,1],
				target:~groups[rackName][sectionName][instrumentName][deviceName],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
};
)
);

 