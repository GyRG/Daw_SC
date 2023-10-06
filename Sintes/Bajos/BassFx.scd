(//Fábrica de módulos
s.waitForBoot({
	var rackName = \SYNTHS;
	var sectionName = \BASS;

	var nextRackName = \SYNTHS, nextModuleName = \Sintes, nextDeviceName = \SynthsDAC, nextBusName = \busMezclaFxCentrales;

	var deviceName = \bassFx;
	var mainSynthGroup = \Bajos;
	var rackOutlet = \busBajos, rackInlet = [\busBajos];

	var outModule = \moduloMezclaSynths;

	// Liberar Grupos
	if(~grupos[rackName][sectionName][\instanciada] == false,
		{
			// El grupo de la seccion de instrumentos se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			// ~grupos[rackName][sectionName].add(sectionName -> IdentityDictionary.new);

			//Grupo para todas las secciones de instrumentos
			// ~grupos[rackName][sectionName].add(mainSynthGroup -> Group.tail(~grupos[nextRackName][nextModuleName]));


		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~grupos[rackName][sectionName].add(\instanciateda -> true);


	~dac.add(deviceName -> IdentityDictionary.new);

	//Crear Buses
	~dac[deviceName].add(
		\buses -> IdentityDictionary.with(*
			//Buses entrada al módulo de mezcla de sintes
			Array.fill(rackInlet.size,{arg i; rackInlet[i] -> Bus.audio(s,2)})
		);
	);



	~dac[deviceName].add(
		\lets -> IdentityDictionary.with(*[
			//Mapeo de buses para lets del modulo de mezcla
			rackOutlet -> [
				~dac[nextDeviceName][\buses][nextBusName]
			],
			\inletMezcla ->
			Array.fill(rackInlet.size,{arg i; ~dac[deviceName][\buses][rackInlet[i]]})
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


	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

	~dac[deviceName].add(

		\modulos -> Dictionary.with(*[
			//Mezcla
			outModule -> Synth(outModule,
				[\gate,1,\wet,1],
				target:~grupos[rackName][mainSynthGroup],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
};
)
);

