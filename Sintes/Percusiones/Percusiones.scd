// Percusiones

//

// s.freeAll
//
// ServerTree.removeAll;
// s.newBusAllocators;
//
//
// ~cajaResonanciaBus= Bus.audio(s, 2);
// (
// ~makeNodes = {
// 	s.bind({
// 		~efectosPercusiones = Group.new;
// 		~cajaResonancia = Synth(\cajaResonancia, [\in, ~cajaResonanciaBus], ~efectosPercusiones,'addToHead');
// 	});
// };)


	ServerTree.add(~makeNodes);
	ServerTree.run;


(
SynthDef(\bombo,{
	|out = 0, freq = 50, amp = 0.7|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.01,0],[0.1,0.23,1],[0,-3,-5]),doneAction:2);
	enf = EnvGen.ar(Env([4,0.01,1/64],[0.1,0.1,0.5],[-2,-5]));
	sig = SinOsc.ar(freq*enf)!2;
	sig = sig + LFTri.ar(freq*2,SinOsc.ar(10,0,pi),0.2,0);
	sig = HPF.ar(sig,50)+LPF.ar(sig,1100,0.7);
	sig  = sig * env *amp;
	Out.ar(~busBomboWShPre,sig)
}).add;
)

(
SynthDef(\hh,{
	|out = 0, freq = 50000, amp = 0.7|
	var sig, env, enf;
	enf = EnvGen.ar(Env([1,2,1],[0.001,0.208],[-6,-2]));
	sig = LFNoise1.ar(freq*enf,0.1)!2;
	env = EnvGen.kr(Env([0,1,0.2,0],[0.01,exprand(0.01,0.2),2.75],[3,-3,-5]),doneAction:2);
	sig = LinPan2.ar(sig,LFPar.kr(100,0,2,0));
	sig  = sig * env *amp;
	Out.ar(out,sig)
}).play;
)

(
SynthDef(\pad,{

	|out = 0, freq=400,amp=0.2|
	var sig=0, env, enf;
	6.do({
		sig = sig+SinOsc.ar(freq+rrand(-2,2),0,0.1);
	});
	sig = sig + VarSaw.ar(freq/2,0,LFNoise0.kr(5,0.01,0.5),0.5)+LFNoise2.ar(2,1,0.5);
	sig = PanB.ar(sig,SinOsc.kr(SinOsc.kr(100,0,0.5,1),0,0.5pi,0),LFNoise1.kr(0.3,0.2*pi,0));
	env = EnvGen.kr(Env([0,1,0.4,0],[0.2,0.3,4],[7,-5,-3]),doneAction:2);
	sig = sig *env * amp;
	Out.ar(out,sig);
}).add;
)

(
SynthDef(\tarola, {
	|out = 0,amp=0.6, freq=70, crtlRuido=0.1, atk=0.01, rel=5,gate=0|
	var cuero, ruido, sig, env, envf, envr;
	env = EnvGen.kr(Env.new([0,1,0.4,0],[0.05,0.4,0.3],[-2,-4,-5]),doneAction:2);
	envf = EnvGen.kr(Env.new([1,8,0.25,0.0625],[0.003, 0.03,0.02],[-1,-9,-5]));
	envr = EnvGen.kr(Env.new([0,1,0.08,0.01,0],[0.01, 0.05,0.1],[-1,-3,-5]));
	ruido = PinkNoise.ar(0.5)*envr;
	cuero = SinOsc.ar(freq*envf);
	sig = cuero*0.9 + ruido*0.7;
	sig = sig * amp * env;
	Out.ar(out, sig);
}).play;

(
SynthDef(\pluckedBass,{
	|out = 0, freq = 50, amp = 0.7|
	var sig, env, enf;
	enf = EnvGen.ar(Env([1,2,1],[0.001,0.0208],[-20,0]));
	sig = VarSaw.ar(freq,0,0.7) + SinOsc.ar(freq*enf)!2;
	sig = sig + LFTri.ar(freq*2,SinOsc.ar(100,0,pi),0.2,0);
	sig = HPF.ar(sig,1000)+LPF.ar(sig,200,0.7);
	env = EnvGen.kr(Env([0,1,0.3,0],[0.001,0.7,1],[0,-3,-5]),doneAction:2);
	sig  = sig * env *amp;
	Out.ar(out,sig)
}).add;
)
)

(
//shaper
~tf = Env([-0.8,0,0.8],[1,1],[8,-8]).asSignal(1025);
~tf = ~tf.asWavetableNoWrap;
~tfBuf = Buffer.loadCollection(s,~tf);
)


(
~tf = Env([-1,1],[1],[0]).asSignal(1025);
~tf = ~tf + (
	Signal.sineFill(
		2049,
		(0!3) ++ [0,0,0,1,1,1].scramble,
		{rrand(0,2pi)}!50
	);
);
~tf = ~tf.normalize;
~tf.plot;
~tfBuf.loadCollection(~tf.asWavetableNoWrap);
)

(
~tf = Signal.newClear(1025).waveFill({
	|x, old, i|
	sin(x)
}, -pi/2, pi/2);

~tf = ~tf.waveFill({
	|x,old,i|
	old * ((cos(x*0.08)/4)+0.3);
}, 0,50pi).normalize;
~tf;
~tfBuf.loadCollection(~tf.asWavetableNoWrap);
)

s.freeAll;
(

~grupoEfectosPercusiones.free;
~grupoMezclaPercusiones.free;

~grupoTarola;

~busMezclaPercusiones.free;
~busCajaTarola.free;

s.newBusAllocators;

~busCajaTarola = Bus.audio(s,1);
~busMezclaPercusiones = Bus.audio(s,1);

~grupoTarola = Group.new(~grupoEfectosPercusiones,\addAfter);
~grupoEfectosPercusiones = Group.new;
~grupoMezclaPercusiones = Group.new;

~cajaTarola = Synth(\caja, [\in, ~busCajaTarola], ~grupoEfectosPercusiones,\addToHead);
~mezclaPercusiones = Synth(\mezclaPercusiones,[\in, ~busMezclaPercusiones], ~grupoMezclaPercusiones, \addToTail);


y = Synth(\bombo,[\out,~busBomboWShPre]);

x = Synth(\tarola,[\out,~busTarola],~grupoTarola);

// ~efectosPercusiones.freeAll;
SynthDef(\caja,{
	|in,out=0|
	var sig;
	sig = In.ar(in,2);
	sig = Splay.ar(sig);
	sig = BPF.ar(sig,5200,0.8)+ sig;
	sig = sig + LPF.ar(sig,7500,0.8);
	sig = sig + HPF.ar(sig, 900,0.4);
	// sig = Shaper.ar(~tfBuf,sig);
	sig = sig+FreeVerb.ar(sig,0.2,0.7,0,0.9);
	Out.ar(out,sig);
}).add;

SynthDef(\mezclaPercusiones,{
	|busBombo, busTarola, busHh, out|
	var bombo, tarola, hH, sig;
	bombo = In.ar(busBombo,2);
	tarola = In.ar(busTarola,2);
	hH = In.ar(busHh,2);
	sig = bombo + tarola + hH;
	sig = \amp.ir(0.2) * sig;
	Out.ar(out,sig);
}).add;

)

(

~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, 0.75,
		\freq, 80
));
)


(

~baseLine1 = Pdef(\baseLine1,
	Pbind(

		\instrument, \pluckedBass,
		\dur, Pseq([2,3,0.2,1.25,0.3],inf),
		\freq,Pseq([50,25,100,75]*1.1,inf),
		\amp, Pseq([0.5,0.3,0.6],inf)
));


~hihats = Pdef(\hihats,
	Pbind(

		\instrument, \hh,
		\dur,Pwrand([0.5,1,0.0525,0.75]*3,[0.01,0.09,0.5,0.05].normalizeSum,inf),
		\freq,Prand([Pwhite(1000,3000,2),4000,9000,10000,\n]*0.55,inf),
		\amp, Pbrown(0.2,0.4,0.001,inf)
));
~pads = Pdef(\pads,Pbind(\instrument, \pad,

	\dur,Pseq([2,3,2],inf),
		\freq,Ptuple(
			[
				Pseq([55,52,50,57,50,52,56,\n].midicps,inf),
				Pseq([65,60,\n,62,67,64,60,64].midicps,inf),
				Pseq([69,67,64,70,68,\n,69,71].midicps,inf)
		]
			,inf)
	));
~tarolas = Pdef(\tarolas,
	Pbind(
		\group, ~grupoTarola,
		\instrument, \tarola,
		\dur, Pseq(
			[
				Pseq([0.25,0.25,0.125,0.625,0.625],3),
				Pseq([0.125,0.125,0.25,0.125,0.25],4),

				// Pgeom(0.125.exp,0.5,5),
				// Pgeom(0.06125.exp,1.5,4),
				// Pstutter(5,Pseq([0.125,0.25,0.333],1))
			],
			inf),
		\freq, Pwhite(10,260,inf),
		\amp, Prand([Pseq([0.7,0.5,0.1,0.3,0.5,0.1,0.01],3),Pbrown(0.01,0.8,0.5,1)],inf),
		\out,~cajaBus
));
)


// Array.geom(100,0.999,-0.1.exp);

(
t = TempoClock.default;
t.tempo_(1);

~tarolas.play(t, quant:1);
~bombos.play(t, quant:1);
~baseLine1.play(t,quant:1);
~hihats.play(t, quant:1);
~pads.play(t, quant:1);
)

~bombos.stop;
~hihats.stop;
~pads.stop;
~tarolas.stop;

s.boot


s.options.numIn = 4


t.tempo_(1.2)