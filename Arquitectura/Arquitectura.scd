(//Arquitectura
~grupos = nil;
s.freeAll;
s.newAllocators;
s.boot;
// s.scope(50);
// s.plotTree;
s.waitForBoot({
		~grupos = IdentityDictionary.with(*[
			\DAC -> IdentityDictionary.new,
			\FX -> IdentityDictionary.new,
			\SYNTHS -> IdentityDictionary.with(*[
				\PERCS -> IdentityDictionary.new,
				\PADS -> IdentityDictionary.new,
				\MODULAR -> IdentityDictionary.new,
				\BASS -> IdentityDictionary.new,
				\SAMPLER -> IdentityDictionary.new,
				\EXT -> IdentityDictionary.new
			])
		]);

	~dac = IdentityDictionary.new;
	~grupos[\DAC].add(\instanciada-> false);
	~grupos[\FX].add(\instanciada-> false);
	~grupos[\SYNTHS].add(\instanciada-> false);
	/*

	//Grupo Master
	~grupos[\DAC].add(\Master -> Group.tail(s.defaultGroup));

	//Grupo efectos convergencia
	~grupos[\DAC].add(\FxFinales -> Group.before(~grupos[\DAC][\Master]));

	//Grupo convergencia
	~grupos[\DAC].add(\Convergencia -> Group.before(~grupos[\DAC][\FxFinales]));*/
	//
	// //Grupo por efectos generales
	// ~grupos[\FX].add(\FxCentrales -> Group.before(~grupos[\DAC][\Convergencia]));
	//
	// //Grupo por efectos por tipo de instrumento
	// //Efectos para cualquier instrumento por salida directa
	// ~grupos[\FX].add(\DelayCentral -> Group.tail(~grupos[\FX][\FxCentrales]));
	// ~grupos[\FX].add(\ReverbCentral -> Group.tail(~grupos[\FX][\FxCentrales]));
	// ~grupos[\FX].add(\SideChainCentral -> Group.tail(~grupos[\FX][\FxCentrales]));
	// //Este grupo será únicamente para mezclar las salidas de los efectos
	// ~grupos[\FX].add(\MezclaFxCentrales -> Group.tail(~grupos[\FX][\FxCentrales]));
	//
	// //Grupo para todos los tipos de instrumentos
	// ~grupos[\SYNTHS].add(\Sintes -> Group.before(~grupos[\FX][\FxCentrales]));
	//
	// // Grupo por percusiones
	// ~grupos[\SYNTHS][\PERCS].add(\Percs -> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// //Grupo por percusión
	// ~grupos[\SYNTHS][\PERCS].add(\Bombo -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	// ~grupos[\SYNTHS][\PERCS].add(\FxBombo -> Group.tail(~grupos[\SYNTHS][\PERCS][\Bombo]));
	// ~grupos[\SYNTHS][\PERCS].add(\Tarola -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	// ~grupos[\SYNTHS][\PERCS].add(\FxTarola -> Group.tail(~grupos[\SYNTHS][\PERCS][\Tarola]));
	// ~grupos[\SYNTHS][\PERCS].add(\Hihat -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	// ~grupos[\SYNTHS][\PERCS].add(\FxHihat -> Group.tail(~grupos[\SYNTHS][\PERCS][\Hihat]));
	// ~grupos[\SYNTHS][\PERCS].add(\Ride -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	// ~grupos[\SYNTHS][\PERCS].add(\FxRide-> Group.tail(~grupos[\SYNTHS][\PERCS][\Ride]));
	// // Mezcla de todas las percusiones
	// ~grupos[\SYNTHS][\PERCS].add(\PercsPre -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	// //Efectos para todas las percusiones
	// ~grupos[\SYNTHS][\PERCS].add(\FxPercs -> Group.tail(~grupos[\SYNTHS][\PERCS][\Percs]));
	//
	// // Grupo por pads
	// ~grupos[\SYNTHS][\PADS].add(\Pads -> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// // Grupo por percusión
	// ~grupos[\SYNTHS][\PADS].add(\Ambiental -> Group.tail(~grupos[\SYNTHS][\PADS][\Pads]));
	// ~grupos[\SYNTHS][\PADS].add(\FxAmbiental -> Group.tail(~grupos[\SYNTHS][\PADS][\Ambiental]));
	// ~grupos[\SYNTHS][\PADS].add(\Retrowave -> Group.tail(~grupos[\SYNTHS][\PADS][\Pads]));
	// ~grupos[\SYNTHS][\PADS].add(\FxRetrowave -> Group.tail(~grupos[\SYNTHS][\PADS][\Retrowave]));
	// ~grupos[\SYNTHS][\PADS].add(\Strings -> Group.tail(~grupos[\SYNTHS][\PADS][\Pads]));
	// ~grupos[\SYNTHS][\PADS].add(\FxStrings -> Group.tail(~grupos[\SYNTHS][\PADS][\Strings]));
	// //Grupo Mezcla Pads
	// ~grupos[\SYNTHS][\PADS].add(\PadsPre -> Group.tail(~grupos[\SYNTHS][\PADS][\Pads]));
	// //Grupo para todos los pads
	// ~grupos[\SYNTHS][\PADS].add(\FxPads -> Group.tail(~grupos[\SYNTHS][\PADS][\Pads]));
	//
	//
	// // Grupo por modulares
	// ~grupos[\SYNTHS][\MODULAR].add(\Modulares -> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// // Grupo por modular<
	// ~grupos[\SYNTHS][\MODULAR].add(\Mono -> Group.tail(~grupos[\SYNTHS][\MODULAR][\Modulares]));
	// ~grupos[\SYNTHS][\MODULAR].add(\FxMono -> Group.tail(~grupos[\SYNTHS][\MODULAR][\Mono]));
	// ~grupos[\SYNTHS][\MODULAR].add(\envVar -> Group.tail(~grupos[\SYNTHS][\MODULAR][\Modulares]));
	// ~grupos[\SYNTHS][\MODULAR].add(\fxEnvVar -> Group.tail(~grupos[\SYNTHS][\MODULAR][\envVar]));
	// // Grupo Mezcla Modulares
	// ~grupos.add(\modularesPre -> Group.tail(~grupos[\SYNTHS][\MODULAR][\Modulares]));
	// // Efectos para todos los modulares
	// ~grupos[\SYNTHS][\MODULAR].add (\fxModulares ->Group.tail(~grupos[\SYNTHS][\MODULAR][\Modulares]));
	//
	// // Grupo por bajos
	// ~grupos[\SYNTHS][\BASS].add(\Bajos -> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// // Grupo por cada bajo
	// ~grupos[\SYNTHS][\BASS].add(\growl -> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	// ~grupos[\SYNTHS][\BASS].add(\fxGrowl -> Group.tail(~grupos[\SYNTHS][\BASS][\growl]));
	// ~grupos[\SYNTHS][\BASS].add(\oscuro -> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	// ~grupos[\SYNTHS][\BASS].add(\fxOscuro -> Group.tail(~grupos[\SYNTHS][\BASS][\oscuro]));
	// ~grupos[\SYNTHS][\BASS].add(\pluck -> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	// ~grupos[\SYNTHS][\BASS].add(\fxPluck -> Group.tail(~grupos[\SYNTHS][\BASS][\pluck]));
	// ~grupos[\SYNTHS][\BASS].add(\electrico-> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	// ~grupos[\SYNTHS][\BASS].add(\fxElectrico -> Group.tail(~grupos[\SYNTHS][\BASS][\electrico]));
	// //Mezcla de todos los bajos
	// ~grupos[\SYNTHS][\BASS].add(\bajosPre -> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	// // Grupo de efectos para todo el conjuinto de bajos
	// ~grupos[\SYNTHS][\BASS].add(\fxBajos -> Group.tail(~grupos[\SYNTHS][\BASS][\Bajos]));
	//
	// // Grupo por percusión de altura definida
	// ~grupos[\SYNTHS][\SAMPLER].add(\samplers-> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// // Grupo por cada percusión de altura definida
	// ~grupos[\SYNTHS][\SAMPLER].add(\martillo -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\samplers]));
	// ~grupos[\SYNTHS][\SAMPLER].add(\fxMartillo -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\martillo]));
	// ~grupos[\SYNTHS][\SAMPLER].add(\litos -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\samplers]));
	// ~grupos[\SYNTHS][\SAMPLER].add(\fxLitos -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\litos]));
	// //Grupo Mezcla Percusión altura definida
	// ~grupos[\SYNTHS][\SAMPLER].add(\samplersPre -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\samplers]));
	// // Efectos para todas las percusiones de altura definida
	// ~grupos[\SYNTHS][\SAMPLERS].add(\fxSamplers -> Group.tail(~grupos[\SYNTHS][\SAMPLER][\samplers]));
	//
	// //Grupo inputs de audio
	// ~grupos[\SYNTHS][\EXT].add(\audioExt -> Group.tail(~grupos[\SYNTHS][\Sintes]));
	// // Grupo por cada entrada de audio
	// ~grupos[\SYNTHS][\EXT].add(\guitarra -> Group.tail(~grupos[\SYNTHS][\EXT][\audioExt]));
	// ~grupos[\SYNTHS][\EXT].add(\fxGuitarra -> Group.tail(~grupos[\SYNTHS][\EXT][\guitarra]));
	// ~grupos[\SYNTHS][\EXT].add (\microfono -> Group.tail(~grupos[\SYNTHS][\EXT][\audioExt]));
	// ~grupos[\SYNTHS][\EXT].add(\fxMicrofono -> Group.tail(~grupos[\SYNTHS][\EXT][\microfono]));
	// //Mezcla de todas las entradas de audio
	// ~grupos[\SYNTHS][\EXT].add(\audioExtPre -> Group.tail(~grupos[\SYNTHS][\EXT][\audioExt]));
	// // Grupo de efectos para las dos entradas de audio
	// ~grupos[\SYNTHS][\EXT].add(\fxAudioExt -> Group.tail(~grupos[\SYNTHS][\EXT][\audioExt]));
	//
	// //Grupo para módulo de mezcla de todo el conjunto de sintes
	// ~grupoMezclaSintes -> Group.tail(~grupos[\SYNTHS][\Sintes]);

	Require("Fabrica_Modulos.scd");
	// s.sync;
	Require("../MasterNodes/Final_DAC");


	// s.sync;
	// Require("../EfectosCentrales/EfectosCentrales.scd");

	// Require("../Sintes/Sintes.scd");

}
)
)
