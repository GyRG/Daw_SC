(

SynthDef(\bombo,{
	|out = 0, freq = 40, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.6,0],[0.05,0.2,2],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([freq*64,freq*2,freq],[0.02,0.08],[-8,-5]));
	sig = SinOsc.ar(freq*enf);
	sig = sig + LFTri.ar(freq,SinOsc.ar((freq),0,pi),0.2,0);
	//sig = sig + PinkNoise.ar(0.04*enf);
	//sig = HPF.ar(sig,50)+LPF.ar(sig,1100,0.7);
	sig  = sig * env *amp;
	Out.ar(~dac[\drumsKickDVC][\lets][\busKickInstance],sig!2)
}).add;



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq([1],inf),
		\amp,Pseq([0,1,0.5,0.75],inf),
		\freq, Pseq([5,10],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsKick][\drumsKickDVC]
));

)

(

SynthDef(\bass,{
	|out = 0, freq = 50, amp = 0.7, sustain=0.1|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.7,0.2,0.1,0],[0.02,0.4,sustain,1],[0,0,0,-1]),doneAction:2);

	enf = EnvGen.kr(Env.adsr(0.01,0.01,0.01,0.01),env);
	sig = LFTri.ar(freq+freq*enf,0,LFTri.kr(freq*2,0.5,0.5));
	12.do({|i|

		sig = sig + LFTri.ar(freq*enf+freq+Rand(-2,2),i*Rand(pi,-pi));
	});
	//sig = Pan2.ar(sig,LFNoise0.kr(1,1,0.5));
	//sig = sig * SawDPW.kr(5,0,1.01,1);
	//sig = sig * LFTri.ar(1,0,1.01,1);

	sig  = sig * env *amp;
	Out.ar(~dac[\bassElectricDVC][\lets][\busElectricoInstance],sig)
}).add;



~bass = Pdef(\bajeo,
	Pbind(
		\instrument, \bass,
		\dur, Prand([3.75,2.25], inf),
		\sustain, 4,
		\amp,Pwrand([0.4,0.2,0.7],[65,30,5].reciprocal,inf),
		\freq, Prand([40,41,44,47,48,52].midicps, inf),
		\group, ~groups[\SYNTHS][\Bass][\bassElectric][\bassElectricDVC]
));


)
)

(

SynthDef(\pads,{
	|out = 0, freq = 50, amp = 0.4|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.7,0],[0.37,5,3],[0,1]),doneAction:2);
	sig = SinOsc.ar(freq,0.4);
	20.do({
		sig = sig + PanX.ar( 2,  SinOscFB.ar(freq+Rand(-2,2),1,0.4),LFNoise2.kr(7,1,0.5)) ;
	});
	sig  = sig * env *amp;
	Out.ar(~dac[\padsPinkDVC][\lets][\busPinkInstance],sig)
}).add;



~pads = Pdef(\chords,
	Pbind(
		\instrument, \pads,
		\dur, Pseq([3]*2, inf),
		\amp,Pwrand([0.5,0.7,0.6]*0.8,[65,30,5].reciprocal,inf),
		\freq, Ptuple([Prand(2*[40,41,44,47,48,52].midicps, inf),Pseq(0.5*[40,41,44,47,48].midicps, inf), inf], inf),
		\group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
));


)


(

SynthDef(\sweet,{
	|out = 0, freq = 40, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0.01,0.8,0.6,0.1,0],[0.3,2,0.5,0.1],[0,0,0]),timeScale:2,doneAction:2);
	sig = LFTri.ar(freq+SinOsc.kr(1,0,freq*0.0021,freq)*XLine.kr(1.001,1,0.001));
	sig = sig + LFTri.ar(freq*SinOsc.ar(freq*0.666,0,0.04,1),XLine.kr(0,LFNoise1.kr(0.5,2pi,pi)));
	sig = sig + LFTri.ar(freq,SinOsc.ar(100,0,pi),0.2,0);
	sig = HPF.ar(sig,400)+LPF.ar(sig,10500);
	sig  = sig * env *amp;
	Out.ar(~dac[\monosSweetDVC][\lets][\busSweetInstance],sig!2)
}).add;



~monos = Pdef(\melodia,
	Pbind(
		\instrument, \sweet,
		\dur, Pwrand([Pseq([1.25],1),Pseq([0.5],3),Pseq([1.5],2)],[10,8,10].reciprocal,inf),
		\amp, 0.7,
		\freq, Prand([Prand([40,41,44,47,48,52].midicps, 9),Prand(2*[40,41,44,47,48].midicps, 1)], inf)

));

)


(
SynthDef(\pluggedInstrument,{
	|out = 0, freq = 50, amp = 0.7, sustain=0.1|
	var sig, env, enf;
	sig = In.ar(3,1);

	Out.ar(~dac[\externalMicroFreakDVC][\lets][\busMicroFreakInstance],sig)
}).add;

)

~freak.free;

(
~freak = Synth(\pluggedInstrument,
	target: ~groups[\SYNTHS][\External][\externalMicroFreak][\externalMicroFreakDVC],
	addAction: 'addToHead'
);
)


~clock = TempoClock(90.0/60.0).permanent_(true);
~bombos.play;
~bass.play;
~monos.play;
~pads.play;
