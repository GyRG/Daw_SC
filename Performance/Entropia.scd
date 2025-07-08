(
s.waitForBoot({
	if(~freak.value != nil || ~lfo_control.value != nil,{ ~freak.free; ~lfo_control.free; });
SynthDef(\bombo,{
	|out = 0, freq = 40, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.8,0],[0.01,0.9,0.4],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([freq*256,freq*1.5,freq],[0.01,0.02],[-70,-20]));
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

SynthDef(\ride,{
	|out = 0, freq = 400, amp = 0.2, dur=0.1|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.4,0.1,0],[0.003,0.1,dur*2],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([1500,7000],[0.1],[-1]));
	sig = Saw.ar(freq*4,amp)+Saw.ar(freq*7,amp);
		sig = sig + WhiteNoise.ar(amp*LFNoise2.ar(12000),0.1)*env;
	sig = HPF.ar(sig,enf);
	Out.ar(~dac[\drumsCrashDVC][\lets][\busCrashInstance],sig*amp)
}).add;

SynthDef(\crash,{
	|out = 0, freq = 400, amp = 0.2, dur=0.1|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.8,0.2,0],[0.001,0.05,amp],[-4,-3]),doneAction:2);
	enf = EnvGen.kr(Env([10000,20],[0.004],[-50]));

		sig = Pulse.ar(freq*7,SinOsc.ar(freq*4,pi,0.2),amp*0.5)-Pulse.ar(freq*4,SinOsc.ar(freq*7,0,0.1),amp*0.5);

	sig = sig + WhiteNoise.ar(amp*Saw.ar(XLine.kr(200,8000,0.04)))*env;
	sig = HPF.ar(sig,enf);
	Out.ar(~dac[\drumsCrashDVC][\lets][\busCrashInstance],sig*amp)
}).add;

SynthDef(\snare,{
	|out = 0, freq = 400, amp = 1|
	var sig, env, envFilter, envNoise, envFreq;

	env = EnvGen.kr(Env([0,0.8,0.1,0],[0.04,0.04],[0,-1]),doneAction:2);
	envNoise = EnvGen.kr(Env([amp*2,0.1,0.0],[0.07,0.4],[-2,-3]));
	envFreq = EnvGen.kr(Env([freq*10,freq,freq*0.25],[0.04,0.8],[-1]));
	envFilter = EnvGen.kr(Env([900,18],[0.4],[-2]));

	sig = BrownNoise.ar(LFNoise2.kr(freq,envNoise))+LFTri.ar(envFreq);
	sig = HPF.ar(sig,envFilter);
	Out.ar(~dac[\drumsSnareDVC][\lets][\busSnareInstance],sig*amp)
}).add;

SynthDef(\tomb,{
	|out = 0, freq = 400, amp = 1,dur=0.1|
	var sig, env, envFilter, envNoise, envFreq;

	env = EnvGen.kr(Env([0,0.007,0.9,0],[0.001,dur],[-1,-2]),doneAction:2);
	envNoise = EnvGen.kr(Env([0.4,0],[0.05],[-5]));
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

s.sync;

~snr= Pdef(\snareBeat,
	Pbind(
		\instrument, \snare,
		\dur, Pseq([4],inf),
		\amp, Pseq(0!4+[1.2]+0!3,inf),
		\freq, Pseq([16],inf),
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


~ride = Pdef(\rideBeat,
	Pbind(
		\instrument, \ride,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq([2,2,3,2,2,3,2]/8,inf),
		\amp, Pseq([0.5],inf),
			\freq, Pgauss(69.midicps,0.2,inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsRide][\drumsRideDVC]
));

~crash = Pdef(\crashBeat,
	Pbind(
		\instrument, \crash,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq([7,4,3,3,4,7],inf),
		\amp, Pseq([0.7],inf),
			\freq, Pseq([70],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsCrash][\drumsCrashDVC]
));


~tomb= Pdef(\tombBeat,
	Pbind(
		\instrument, \tomb,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pseq(0.2!1,inf),
		\amp, Pseq(0.3!2+[0.1],inf),
		\freq, Pseq([400,200,600,300,150],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsTomb][\drumsTombDVC]
));



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, Pseq([4],inf),
		\amp,Pseq([0.4],inf),
		\freq, Pseq([8],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsKick][\drumsKickDVC]
));

~pads = Pdef(\chords,
	Pbind(
		\instrument, \pads,
		\dur, Pseq([3,4]*3, inf),
		\amp,Pseq([0.5,0.7,0.6]*0.5,inf),
		\freq, Ptuple(
			[
				Pseq([63,62].midicps, inf),
				Pseq([70,70].midicps, inf),
				Pseq([72,72].midicps, inf),
				Pseq([77,79].midicps, inf)
		], inf),
		\group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
));


~lfo_control = SynthDef(\controlFx,{
	var control;

	control = SinOsc.kr(0.1,0,10);

	Out.kr(~lfo_rate,control);
		}).play;


~freak = Synth(\pluggedInstrument,
	target: ~groups[\SYNTHS][\External][\externalMicroFreak][\externalMicroFreakDVC],
	addAction: 'addToHead'
);
}
)
)
