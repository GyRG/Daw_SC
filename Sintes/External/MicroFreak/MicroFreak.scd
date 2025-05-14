(//Salida de efectos de Secciòn de external
s.waitForBoot({
	var rackName = \SYNTHS;
	var sectionName = \External;

	var nextRackName = \SYNTHS, nextModuleName = \External, nextDeviceName = \externalFx, nextBusName = \busMicroFreakMain;

	var instrumentName = \externalMicroFreak;
	var deviceName = \externalMicroFreakDVC;
	var mainSynthGroup = \External;
	var rackOutlet = \busExternalMain, rackInlet = \busMicroFreakInstance;

	var outModule = \microFreakExternal;

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
			var input,sig;
			input = in;
			sig = input;

			//sig = sig + LinPan2.ar(DelayN.ar(sig,120/80,LFNoise1.kr(0.0001,0.01,1),1),LFNoise2.kr(0.02,0.2,1));
			sig = Pan2.ar(FreeVerb.ar(sig,0.4,0.9),SinOsc.kr(1000)) + Pan2.ar(FreeVerb.ar(sig,0.4,0.9),SinOsc.kr(1000,pi));
			sig = sig/2;

			//input = CrossoverDistortion.ar(in, amp: 0.9, smooth: 0.1, mul: 0.2, add: 0);
			//input = input + BPF.ar(in,100,1)+ HPF.ar(in,1500);
			//input = Compander.ar(input,0,0.4,0.6);

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


