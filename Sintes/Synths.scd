(//Fábrica de módulos
s.waitForBoot({
	var rackName = \SYNTHS;

	var nextRackName = \FX, nextModuleName = \FxCentrales, nextDeviceName = \finalDAC, nextBusName = \busMezclaSintes;

	var deviceName = \SynthsDAC;
	var mainSynthGroup = \Sintes;
	var grupoEntrada = [\Percs,\Modulars,\Bass], grupoSalida = \MezclaSynths;
	var rackOutlet = \outletSynths, rackInlet = [\busPercs,\busPads,\busBajos,\busModulares,\busSamplers];

	var outModule = \moduloMezclaSynths;

	// Liberar Grupos
	if(~grupos[rackName][\instanciada] == false,
		{
			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~grupos.add(rackName -> IdentityDictionary.new);

			//Grupo para todos los tipos de instrumentos
			~grupos[rackName].add(mainSynthGroup -> Group.before(~grupos[nextRackName][nextModuleName]));

			//Este grupo es para la mezcla de las salidas de cada tipo o sección de instrumentos
			~grupos[rackName].add(grupoSalida -> Group.tail(~grupos[rackName][mainSynthGroup]));

			//Para cada grupo que contendrá los módulos que entreguen señal al módulo general de los synths
			grupoEntrada.do({|x,i|
				~grupos[rackName].add(grupoEntrada[i] -> Group.head(~grupos[rackName][mainSynthGroup]));
			});
		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~grupos[rackName].add(\instanciateda -> true);


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
			\inletMezcla -> Array.fill(rackInlet.size,{
				arg i;
				~dac[deviceName][\buses][rackInlet[i]]
			})
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
				target:~grupos[rackName][grupoSalida],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
};
)
);

