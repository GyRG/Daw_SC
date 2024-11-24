(//Salida de efectos de Secciòn de bajos
s.waitForBoot({
	var rackName = \SYNTHS;
	var sectionName = \Drums;

	var nextRackName = \SYNTHS, nextModuleName = \Drums, nextDeviceName = \drumsFx, nextBusName = \busDrumsMain;

	var instrumentName = \drumsKick;
	var deviceName = \drumsKickDVC;
	var mainSynthGroup = \Drums;
	var rackOutlet = \busDrumsMain, rackInlet = \busKickInstance;

	var outModule = \kickDrums;

	// Liberar groups
	if(~groups[rackName][sectionName][instrumentName][\instanciada] == false,
		{
			// El grupo de la seccion de instrumentos se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses

			//Grupo para todas las secciones de instrumentos
			~groups[rackName][sectionName][instrumentName].add(deviceName -> Group.head(~groups[nextRackName][sectionName][mainSynthGroup]))


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
			var buff_num;
			buff_num = Buffer.alloc(s, 1024, 1, { |buf| buf.chebyMsg([1,0,1,1,0,1])});
			input =  HPF.ar(in,80,1.2)+LPF.ar(in,1200,0.8);
			// input = Shaper.ar(buff_num,input,0.5);

			input = Compander.ar(input,0.0,0.5);
		},
		nil,
		2,
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


