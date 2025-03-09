(
SynthDef(\bombo,{
	|out = 0, freq = 40, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.6,0],[0.01,0.2,0.8],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([freq*128,freq*1.5,freq],[0.02,0.4],[-15,-4]));
	sig = SinOsc.ar(freq*enf);
	sig = sig + LFTri.ar(freq,SinOsc.ar((freq),0,pi),0.2,0);
	//sig = sig + PinkNoise.ar(0.04*enf);
	//sig = HPF.ar(sig,50)+LPF.ar(sig,1100,0.7);
	sig  = sig * env *amp;
	Out.ar(~dac[\drumsKickDVC][\lets][\busKickInstance],sig)
}).add;


SynthDef(\hihat,{
	|out = 0, freq = 400, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.01,0.7,0],[0.01,0.01,0.3],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([150,18000],[0.1],[-2]));
	sig = PinkNoise.ar(0.4,0.5)*env;
	sig = HPF.ar(sig,enf);
	Out.ar(~dac[\drumsHhDVC][\lets][\busHhInstance],sig*amp)
}).add;

SynthDef(\snare,{
	|out = 0, freq = 400, amp = 1|
	var sig, env, envFilter, envNoise, envFreq;

	env = EnvGen.kr(Env([0,0.8,0.1,0],[0.04,0.4],[0,-1]),doneAction:2);
	envNoise = EnvGen.kr(Env([amp*2,0.1,0.0],[0.07,0.4],[-2,-3]));
	envFreq = EnvGen.kr(Env([freq*10,freq,freq*0.25],[0.04,0.8],[-1]));
	envFilter = EnvGen.kr(Env([900,18],[0.4],[-2]));

	sig = BrownNoise.ar(LFNoise2.kr(freq,envNoise))+LFTri.ar(envFreq);
	sig = HPF.ar(sig,envFilter);
	Out.ar(~dac[\drumsSnareDVC][\lets][\busSnareInstance],sig*amp)
}).add;

SynthDef(\tomb,{
	|out = 0, freq = 400, amp = 1|
	var sig, env, envFilter, envNoise, envFreq;

	env = EnvGen.kr(Env([0,0.007,0.9,0],[0.01,0.4],[-1,-4]),doneAction:2);
	envNoise = EnvGen.kr(Env([0.4,0],[0.5],[-5]));
	envFreq = EnvGen.kr(Env([freq*4,freq*0.25,freq*0.0625],[0.021,0.4],[-10,-4]));
	envFilter = EnvGen.kr(Env([freq*5,freq*0.125],[0.01],[-10]));
	sig = PinkNoise.ar(envNoise)+LFTri.ar(envFreq);
	sig = HPF.ar(sig,envFilter);
	Out.ar(~dac[\drumsTombDVC][\lets][\busTombInstance],sig*amp)
}).add;

SynthDef(\pads,{
	|out = 0, freq = 50, amp = 0.4|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.7,0],[0.37,5,12],[0,1]),doneAction:2);
	sig = LFTri.ar(freq*0.5,0,0.4);
	6.do({
		sig = sig + PanX.ar( 2,LFSaw.ar(freq+Rand(-1,1),0,0.08),SinOsc.kr(LFNoise1.kr(0.02,9,5),0,1,0),LFNoise1.kr(0.1,pi,pi*0.5)) ;
	});
	sig  = sig * env *amp;
	Out.ar(~dac[\padsPinkDVC][\lets][\busPinkInstance],sig)
}).add;

SynthDef(\pluggedInstrument,{
	|out = 0, freq = 50, amp = 0.7, sustain=0.1|
	var sig, env, enf;
	sig = In.ar(3,1);


	//sig = LinPan2.ar(sig,SinOsc.kr(0.6,0,1));
	Out.ar(~dac[\externalMicroFreakDVC][\lets][\busMicroFreakInstance],sig)
}).add;

)



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
(

)
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

(
SynthDef(\pluggedInstrument,{
	|out = 0, freq = 50, amp = 0.7, sustain=0.1|
	var sig, env, enf;
	sig = In.ar(3,1);


	//sig = LinPan2.ar(sig,SinOsc.kr(0.6,0,1));
	Out.ar(~dac[\externalMicroFreakDVC][\lets][\busMicroFreakInstance],sig)
}).add;
)
(

)

(
	~lfo_control = SynthDef(\controlFx,{
	var control;

	control = SinOsc.kr(0.1,0,10);

	Out.kr(~lfo_rate,control);
		}).play;

);

(
~snr= Pdef(\snareBeat,
	Pbind(
		\instrument, \snare,
		\dur, Pseq([5],inf),
		\amp, Pseq(0!4+[1.2]+0!3,inf),
		\freq, Pseq([10],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsSnare][\drumsSnareDVC]
));



~hihat= Pdef(\hihatBeat,
	Pbind(
		\instrument, \hihat,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq(1!1,inf),
		\amp, Pseq(4!1+[0.4],inf),
		\freq, Pseq([50,10],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsHh][\drumsHhDVC]
));


~tomb= Pdef(\tombBeat,
	Pbind(
		\instrument, \tomb,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq(0.2!1,inf),
		\amp, Pseq(0.2!1+[0.4],inf),
		\freq, Pseq([400,200,600,300,150],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsTomb][\drumsTombDVC]
));



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, Pseq([8],inf),
		\amp,Pseq([0.3],inf),
		\freq, Pseq([8],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsKick][\drumsKickDVC]
));

~pads = Pdef(\chords,
	Pbind(
		\instrument, \pads,
		\dur, Pseq([3,4]*3, inf),
		\amp,Pseq([0.5,0.7,0.6]*0.3,inf),
		\freq, Ptuple(
			[
				Pseq([65,67].midicps, inf),
				Pseq([69,69].midicps, inf),
				Pseq([73,72].midicps, inf),
				Pseq([79,77].midicps, inf)
		], inf),
		\group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
));

)

~bass = Pdef(\bajeo,
	Pbind(
		\instrument, \bass,
		\dur, Prand([3.75,2.25], inf),
		\sustain, 4,
		\amp,Pwrand([0.4,0.2,0.7],[65,30,5].reciprocal,inf),
		\freq, Prand([40,41,44,47,48,52].midicps, inf),
		\group, ~groups[\SYNTHS][\Bass][\bassElectric][\bassElectricDVC]
));

(

)

(
~pads = Pdef(\chords,
	Pbind(
		\instrument, \pads,
		\dur, Pseq([3]*7, inf),
		\amp,Pseq([0.5,0.7,0.6]*0.3,inf),
		\freq, Ptuple(
			[
				Pseq([70,70,69,72,71].midicps*0.5, inf),
				Pseq([70,70,69,72,71].midicps, inf),
				Pseq([74,76,72,76,75].midicps, inf),
				Pseq([81,79,79,84,81].midicps, inf)
		], inf),
		\group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
));
)

(
~pads = Pdef(\chords,
	Pbind(
		\instrument, \pads,
		\dur, Pseq([7], inf),
		\amp,Pseq([0.5,0.7,0.6]*0.1,inf),
		\freq, Ptuple(
			[
				Pseq([72].midicps*0.5, inf),
				Pseq([75].midicps, inf),
				Pseq([80].midicps, inf),
				Pseq([84].midicps, inf)
		], inf),
		\group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
));
)


~monos = Pdef(\melodia,
	Pbind(
		\instrument, \sweet,
		\dur, Pwrand([Pseq([1.25],1),Pseq([0.5],3),Pseq([1.5],2)],[10,8,10].reciprocal,inf),
		\amp, 0.7,
		\freq, Prand([Prand([40,41,44,47,48,52].midicps, 9),Prand(2*[40,41,44,47,48].midicps, 1)], inf)

));

(
~clock_1 = {TempoClock(128/80)}.value;
~bombos.play(~clock_1);
~pads.play(~clock_1);
~hihat.play(~clock_1);
~snr.play(~clock_1);
~tomb.play(~clock_1);
)
(
~freak = Synth(\pluggedInstrument,
	target: ~groups[\SYNTHS][\External][\externalMicroFreak][\externalMicroFreakDVC],
	addAction: 'addToHead'
);
)

69.midicps