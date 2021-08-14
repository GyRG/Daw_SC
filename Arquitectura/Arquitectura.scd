(//Arquitectura
s.newAllocators;
s.boot;
s.waitForBoot({
	s.scope(50);
	s.plotTree;
//Grupo Master
~grupoMaster = Group.tail(s.defaultGroup);

//Grupo efectos convergencia
~grupoFxFinales= Group.before(~grupoMaster);

//Grupo convergencia
~grupoConvergencia = Group.before(~grupoFxFinales);

//Grupo por efectos generales
~grupoFxCentrales = Group.before(~grupoConvergencia);

//Grupo por efectos por tipo de instrumento
	//Efectos para cualquier instrumento por salida directa
	~grupoDelayCentral = Group.tail(~grupoFxCentrales);
	~grupoReverbCentral = Group.tail(~grupoFxCentrales);
	~grupoSideChainCentral = Group.tail(~grupoFxCentrales);
	//Este grupo será únicamente para mezclar las salidas de los efectos
	~grupoMezclaFxCentrales = Group.tail(~grupoFxCentrales);

//Grupo para todos los tipos de instrumentos
~grupoSintes= Group.before(~grupoFxCentrales);

	// Grupo por percusiones
	~grupoPercs = Group.tail(~grupoSintes);
		//Grupo por percusión
		~grupoBombo = Group.tail(~grupoPercs);
			~grupoFxBombo = Group.tail(~grupoBombo);
		~grupoTarola = Group.tail(~grupoPercs);
			~grupoFxTarola = Group.tail(~grupoTarola);
		~grupoHihat = Group.tail(~grupoPercs);
			~grupoFxHihat = Group.tail(~grupoHihat);
		// Mezcla de todas las percusiones
		~grupoPercsPre = Group.tail(~grupoPercs);
		//Efectos para todas las percusiones
		~grupoFxPercs = Group.tail(~grupoPercs);

	// Grupo por pads
	~grupoPads = Group.tail(~grupoSintes);
		// Grupo por percusión
		~grupoAmbiental = Group.tail(~grupoPads);
			~grupoFxAmbiental = Group.tail(~grupoAmbiental);
		~grupoRetrowave = Group.tail(~grupoPads);
			~grupoFxRetrowave = Group.tail(~grupoRetrowave);
		~grupoChords = Group.tail(~grupoPads);
			~grupoFxChords = Group.tail(~grupoChords);
		//Grupo Mezcla Pads
		~grupoPadsPre = Group.tail(~grupoPads);
		//Grupo para todos los pads
		~grupoFxPads = Group.tail(~grupoPads);


	// Grupo por modulares
	~grupoModulares = Group.tail(~grupoSintes);
		// Grupo por modular
		~grupoMelodicoMono = Group.tail(~grupoModulares);
			~grupoFxMelodicoMono = Group.tail(~grupoMelodicoMono);
		~grupoEnvolventeVariable = Group.tail(~grupoModulares);
			~grupoFxEnvolventeVariable = Group.tail(~grupoEnvolventeVariable);
		// Grupo Mezcla Modulares
		~grupoModularesPre = Group.tail(~grupoModulares);
		// Efectos para todos los modulares
		~grupoFxModulares = Group.tail(~grupoModulares);

	// Grupo por bajos
	~grupoBajos = Group.tail(~grupoSintes);
		// Grupo por cada bajo
		~grupoDistorsionado = Group.tail(~grupoBajos);
			~grupoFxDistorsionado = Group.tail(~grupoDistorsionado);
		~grupoOscuro = Group.tail(~grupoBajos);
			~grupoFxOscuro = Group.tail(~grupoOscuro);
		~grupoPlucked = Group.tail(~grupoBajos);
			~grupoFxPlucked = Group.tail(~grupoPlucked);
		~grupoElectrico = Group.tail(~grupoBajos);
			~grupoFxElectrico = Group.tail(~grupoElectrico);
		//Mezcla de todos los bajos
		~grupoBajosPre = Group.tail(~grupoBajos);
		// Grupo de efectos para todo el conjuinto de bajos
		~grupoFxBajos = Group.tail(~grupoBajos);

	// Grupo por percusión de altura definida
	~grupoSamples= Group.tail(~grupoSintes);
		// Grupo por cada percusión de altura definida
		~grupoMartillo = Group.tail(~grupoSamples);
			~grupoFxMartillo = Group.tail(~grupoMartillo);
		~grupoLitos = Group.tail(~grupoSamples);
			~grupoFxLitos = Group.tail(~grupoLitos);
		//Grupo Mezcla Percusión altura definida
		~grupoSamplesPre = Group.tail(~grupoSamples);
		// Efectos para todas las percusiones de altura definida
		~grupoFxSamples = Group.tail(~grupoSamples);

	//Grupo inputs de audio
	~grupoAudioExt = Group.tail(~grupoSintes);
		// Grupo por cada entrada de audio
		~grupoGuitarra = Group.tail(~grupoAudioExt);
			~grupoFxGuitarra = 	Group.tail(~grupoGuitarra);
		~grupoMicrofono = Group.tail(~grupoAudioExt);
			~grupoFxMicrofono = Group.tail(~grupoMicrofono);
		//Mezcla de todas las entradas de audio
		~grupoAudioExtPre = Group.tail(~grupoAudioExt);
		// Grupo de efectos para las dos entradas de audio
		~grupoFxAudioExt = Group.tail(~grupoAudioExt);

 //Grupo para módulo de mezcla de todo el conjunto de sintes
~grupoMezclaSintes = Group.tail(~grupoSintes);
}
)
)

