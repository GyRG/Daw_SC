(//Arquitectura
~groups = nil;
s.freeAll;
s.newAllocators;
s.boot;
// s.scope(50);
// s.plotTree;
s.waitForBoot({
		~groups = IdentityDictionary.with(*[
			\DAC -> IdentityDictionary.new,
			\FX -> IdentityDictionary.new,
			\SYNTHS -> IdentityDictionary.new
		]);

	~dac = IdentityDictionary.new;
	~groups[\DAC].add(\instanciada-> false);
	~groups[\FX].add(\instanciada-> false);
	~groups[\SYNTHS].add(\instanciada-> false);
	/*

	//Grupo Master
	~groups[\DAC].add(\Master -> Group.tail(s.defaultGroup));

	//Grupo efectos convergencia
	~groups[\DAC].add(\FxFinales -> Group.before(~groups[\DAC][\Master]));

	//Grupo convergencia
	~groups[\DAC].add(\Convergencia -> Group.before(~groups[\DAC][\FxFinales]));*/
	//
	// //Grupo por efectos generales
	// ~groups[\FX].add(\FxCentrales -> Group.before(~groups[\DAC][\Convergencia]));
	//
	// //Grupo por efectos por tipo de instrumento
	// //Efectos para cualquier instrumento por salida directa
	// ~groups[\FX].add(\DelayCentral -> Group.tail(~groups[\FX][\FxCentrales]));
	// ~groups[\FX].add(\ReverbCentral -> Group.tail(~groups[\FX][\FxCentrales]));
	// ~groups[\FX].add(\SideChainCentral -> Group.tail(~groups[\FX][\FxCentrales]));
	// //Este grupo será únicamente para mezclar las salidas de los efectos
	// ~groups[\FX].add(\MezclaFxCentrales -> Group.tail(~groups[\FX][\FxCentrales]));
	//
	// //Grupo para todos los tipos de instrumentos
	// ~groups[\SYNTHS].add(\Sintes -> Group.before(~groups[\FX][\FxCentrales]));
	//
	// // Grupo por percusiones
	// ~groups[\SYNTHS][\PERCS].add(\Percs -> Group.tail(~groups[\SYNTHS][\Sintes]));
	// //Grupo por percusión
	// ~groups[\SYNTHS][\PERCS].add(\Bombo -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	// ~groups[\SYNTHS][\PERCS].add(\FxBombo -> Group.tail(~groups[\SYNTHS][\PERCS][\Bombo]));
	// ~groups[\SYNTHS][\PERCS].add(\Tarola -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	// ~groups[\SYNTHS][\PERCS].add(\FxTarola -> Group.tail(~groups[\SYNTHS][\PERCS][\Tarola]));
	// ~groups[\SYNTHS][\PERCS].add(\Hihat -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	// ~groups[\SYNTHS][\PERCS].add(\FxHihat -> Group.tail(~groups[\SYNTHS][\PERCS][\Hihat]));
	// ~groups[\SYNTHS][\PERCS].add(\Ride -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	// ~groups[\SYNTHS][\PERCS].add(\FxRide-> Group.tail(~groups[\SYNTHS][\PERCS][\Ride]));
	// // Mezcla de todas las percusiones
	// ~groups[\SYNTHS][\PERCS].add(\PercsPre -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	// //Efectos para todas las percusiones
	// ~groups[\SYNTHS][\PERCS].add(\FxPercs -> Group.tail(~groups[\SYNTHS][\PERCS][\Percs]));
	//
	// // Grupo por pads
	// ~groups[\SYNTHS][\PADS].add(\Pads -> Group.tail(~groups[\SYNTHS][\Sintes]));
	// // Grupo por percusión
	// ~groups[\SYNTHS][\PADS].add(\Ambiental -> Group.tail(~groups[\SYNTHS][\PADS][\Pads]));
	// ~groups[\SYNTHS][\PADS].add(\FxAmbiental -> Group.tail(~groups[\SYNTHS][\PADS][\Ambiental]));
	// ~groups[\SYNTHS][\PADS].add(\Retrowave -> Group.tail(~groups[\SYNTHS][\PADS][\Pads]));
	// ~groups[\SYNTHS][\PADS].add(\FxRetrowave -> Group.tail(~groups[\SYNTHS][\PADS][\Retrowave]));
	// ~groups[\SYNTHS][\PADS].add(\Strings -> Group.tail(~groups[\SYNTHS][\PADS][\Pads]));
	// ~groups[\SYNTHS][\PADS].add(\FxStrings -> Group.tail(~groups[\SYNTHS][\PADS][\Strings]));
	// //Grupo Mezcla Pads
	// ~groups[\SYNTHS][\PADS].add(\PadsPre -> Group.tail(~groups[\SYNTHS][\PADS][\Pads]));
	// //Grupo para todos los pads
	// ~groups[\SYNTHS][\PADS].add(\FxPads -> Group.tail(~groups[\SYNTHS][\PADS][\Pads]));
	//
	//
	// // Grupo por modulares
	// ~groups[\SYNTHS][\MODULAR].add(\Modulares -> Group.tail(~groups[\SYNTHS][\Sintes]));
	// // Grupo por modular<
	// ~groups[\SYNTHS][\MODULAR].add(\Mono -> Group.tail(~groups[\SYNTHS][\MODULAR][\Modulares]));
	// ~groups[\SYNTHS][\MODULAR].add(\FxMono -> Group.tail(~groups[\SYNTHS][\MODULAR][\Mono]));
	// ~groups[\SYNTHS][\MODULAR].add(\envVar -> Group.tail(~groups[\SYNTHS][\MODULAR][\Modulares]));
	// ~groups[\SYNTHS][\MODULAR].add(\fxEnvVar -> Group.tail(~groups[\SYNTHS][\MODULAR][\envVar]));
	// // Grupo Mezcla Modulares
	// ~groups.add(\modularesPre -> Group.tail(~groups[\SYNTHS][\MODULAR][\Modulares]));
	// // Efectos para todos los modulares
	// ~groups[\SYNTHS][\MODULAR].add (\fxModulares ->Group.tail(~groups[\SYNTHS][\MODULAR][\Modulares]));
	//
	// // Grupo por bajos
	// ~groups[\SYNTHS][\BASS].add(\Bajos -> Group.tail(~groups[\SYNTHS][\Sintes]));
	// // Grupo por cada bajo
	// ~groups[\SYNTHS][\BASS].add(\growl -> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	// ~groups[\SYNTHS][\BASS].add(\fxGrowl -> Group.tail(~groups[\SYNTHS][\BASS][\growl]));
	// ~groups[\SYNTHS][\BASS].add(\oscuro -> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	// ~groups[\SYNTHS][\BASS].add(\fxOscuro -> Group.tail(~groups[\SYNTHS][\BASS][\oscuro]));
	// ~groups[\SYNTHS][\BASS].add(\pluck -> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	// ~groups[\SYNTHS][\BASS].add(\fxPluck -> Group.tail(~groups[\SYNTHS][\BASS][\pluck]));
	// ~groups[\SYNTHS][\BASS].add(\electrico-> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	// ~groups[\SYNTHS][\BASS].add(\fxElectrico -> Group.tail(~groups[\SYNTHS][\BASS][\electrico]));
	// //Mezcla de todos los bajos
	// ~groups[\SYNTHS][\BASS].add(\bajosPre -> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	// // Grupo de efectos para todo el conjuinto de bajos
	// ~groups[\SYNTHS][\BASS].add(\fxBajos -> Group.tail(~groups[\SYNTHS][\BASS][\Bajos]));
	//
	// // Grupo por percusión de altura definida
	// ~groups[\SYNTHS][\SAMPLER].add(\samplers-> Group.tail(~groups[\SYNTHS][\Sintes]));
	// // Grupo por cada percusión de altura definida
	// ~groups[\SYNTHS][\SAMPLER].add(\martillo -> Group.tail(~groups[\SYNTHS][\SAMPLER][\samplers]));
	// ~groups[\SYNTHS][\SAMPLER].add(\fxMartillo -> Group.tail(~groups[\SYNTHS][\SAMPLER][\martillo]));
	// ~groups[\SYNTHS][\SAMPLER].add(\litos -> Group.tail(~groups[\SYNTHS][\SAMPLER][\samplers]));
	// ~groups[\SYNTHS][\SAMPLER].add(\fxLitos -> Group.tail(~groups[\SYNTHS][\SAMPLER][\litos]));
	// //Grupo Mezcla Percusión altura definida
	// ~groups[\SYNTHS][\SAMPLER].add(\samplersPre -> Group.tail(~groups[\SYNTHS][\SAMPLER][\samplers]));
	// // Efectos para todas las percusiones de altura definida
	// ~groups[\SYNTHS][\SAMPLERS].add(\fxSamplers -> Group.tail(~groups[\SYNTHS][\SAMPLER][\samplers]));
	//
	// //Grupo inputs de audio
	// ~groups[\SYNTHS][\EXT].add(\audioExt -> Group.tail(~groups[\SYNTHS][\Sintes]));
	// // Grupo por cada entrada de audio
	// ~groups[\SYNTHS][\EXT].add(\guitarra -> Group.tail(~groups[\SYNTHS][\EXT][\audioExt]));
	// ~groups[\SYNTHS][\EXT].add(\fxGuitarra -> Group.tail(~groups[\SYNTHS][\EXT][\guitarra]));
	// ~groups[\SYNTHS][\EXT].add (\microfono -> Group.tail(~groups[\SYNTHS][\EXT][\audioExt]));
	// ~groups[\SYNTHS][\EXT].add(\fxMicrofono -> Group.tail(~groups[\SYNTHS][\EXT][\microfono]));
	// //Mezcla de todas las entradas de audio
	// ~groups[\SYNTHS][\EXT].add(\audioExtPre -> Group.tail(~groups[\SYNTHS][\EXT][\audioExt]));
	// // Grupo de efectos para las dos entradas de audio
	// ~groups[\SYNTHS][\EXT].add(\fxAudioExt -> Group.tail(~groups[\SYNTHS][\EXT][\audioExt]));
	//
	// //Grupo para módulo de mezcla de todo el conjunto de sintes
	// ~grupoMezclaSintes -> Group.tail(~groups[\SYNTHS][\Sintes]);

	Require("Fabrica_Modulos.scd");
	// s.sync;
	Require("../MasterNodes/Final_DAC");


	// s.sync;
	// Require("../EfectosCentrales/EfectosCentrales.scd");

	// Require("../Sintes/Sintes.scd");

}
)
)
