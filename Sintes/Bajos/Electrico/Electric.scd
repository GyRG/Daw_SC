(//Salida de efectos de Secciòn de bajos
s.waitForBoot({
	var rackName = \SYNTHS;
	var sectionName = \Bass;

	var nextRackName = \SYNTHS, nextModuleName = \Bass, nextDeviceName = \bassFx, nextBusName = \busBassMain;

	var instrumentName = \bassElectric;
	var deviceName = \bassElectricDVC;
	var mainSynthGroup = \Bass;
	var rackOutlet = \busBassMain, rackInlet = \busElectricoInstance;

	var outModule = \electricBass;

	// Liberar groups
	if(~groups[rackName][sectionName][instrumentName][\instanciada] == false,
		{
			// El grupo de la seccion de instrumentos se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			// ~groups[rackName][sectionName].add(sectionName -> IdentityDictionary.new);


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
			//Array.fill(rackInlet.size,{arg i; ~dac[deviceName][\buses][rackInlet[i]]})
		]);
	);


	//Definición de los nodulos del procesamiento final
	// Mezcla Fx
	~createDevice.value(outModule,
		{|in, env|
			var input;

			input =  HPF.ar(in,150)+LPF.ar(in,1800,0.8);

			input = input * 0.5;
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


