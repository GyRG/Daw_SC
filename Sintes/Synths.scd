(//Synths
s.waitForBoot({
	var rackName = \SYNTHS;

	var nextRackName = \FX, nextModuleName = \FxCentrales, nextDeviceName = \finalDAC, nextBusName = \busMezclaSintes;

	var deviceName = \SynthsDAC;
	var mainSynthGroup = \SynthsGroup;
	var inGroup = [\Percs,\Modulars,\Bass], outGroup = \MezclaSynths;
	var rackOutlet = \outletSynths, rackInlet = [\busPercs,\busPads,\busBajosSynth,\busModulares,\busSamplers];

	var outModule = \moduloMezclaSynths;

	// Liberar groups
	if(~groups[rackName][\instanciada] == false,
		{
			// El grupo del rack se vacía cuando el generador
			// se vuelve a ejecutar para evitar creación de nuevos buses
			~groups.add(rackName -> IdentityDictionary.new);

			//Grupo para todos los tipos de instrumentos
			~groups[rackName].add(mainSynthGroup -> Group.before(~groups[nextRackName][nextModuleName]));

			//Este grupo es para la mezcla de las salidas de cada tipo o sección de instrumentos
			~groups[rackName].add(outGroup -> Group.tail(~groups[rackName][mainSynthGroup]));

			//Para cada grupo que contendrá los módulos que entreguen señal al módulo general de los synths
			inGroup.do({|sectionName|
				~groups[rackName].add(sectionName -> IdentityDictionary.new);
				//("value : "+sectionName).postln;
				//~groups[rackName][sectionName].add(sectionName+"Group" -> Group.head(~groups[rackName][mainSynthGroup]));
					~groups[rackName][sectionName].add(\instanciada -> false);
			});

			//Declarar el atributo instanciada = false para cada secciòn
			inGroup.do({|x,i|
				~groups[rackName][inGroup[i]].add(\instanciada -> false);
			});
		}, {
			s.newBusAllocators;
			~dac[deviceName][\modulos].do({|n| n.free});
	});


	~groups[rackName].add(\instanciada -> true);


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


	// Instanciación de los módulos
	s.sync;//Le da tiempo al servidor para instanciar el synthDef en un synth

	~dac[deviceName].add(

		\modulos -> Dictionary.with(*[
			//Mezcla
			outModule -> Synth(outModule,
				[\gate,1,\wet,1],
				target:~groups[rackName][outGroup],
				addAction:\addToTail
			)
		]);
	);

	s.sync;
	Require("./Bajos/BassFx.scd")
};
)
);

