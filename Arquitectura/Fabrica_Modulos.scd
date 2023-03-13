(//Fábrica de módulos
s.waitForBoot({
	// Esta función genera una fábrica de efectos
	// Al ejecutarla hay que introducir los argumentos nombre, función, lags y número de canales
	~crearNodulo = { |name, func, lags, numChannels = 2, inlets = 0, outlets = 0 |
		SynthDef(name, { |gate = 1, wet = 1,amp=1|
			var in=0, sound, env, lfo;
			inlets.size.do({|i|
				in = in + In.ar(inlets[i],numChannels)*(1/inlets.size.sqrt);
			});
			// in = In.ar(inlet, numChannels);
			env = Linen.kr(gate, 2, 1, 2, 2);
			//Se llama a la función wrap para empaquetar las caracteristicas distintivas del efecto
			// de la misma manera, se hace uso de in y env como prependArgs simplemente para no convertirlos
			// en instancias de Control
			sound = SynthDef.wrap(func, lags, [in, env]);
			name.postln;
			inlets.size.postln;
			outlets.size.postln;
			inlets.postln;
			outlets.postln;
			postln("");
			outlets.size.do({|i|
				XOut.ar(outlets[i], wet * env, sound*amp);
			});
		}, [0, 0, 0.1] ).add;
	};
s.sync;
};
)
)
