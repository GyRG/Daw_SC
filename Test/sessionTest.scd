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
	Out.ar(~dac[\drumsKickDVC][\lets][\busKickInstance],sig)
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

SynthDef(\hihat,{
	|out = 0, freq = 400, amp = 0.2,gate=0|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.01,0.7,0],[0.01,0.01,0.13],[-2,-3]),doneAction:2);
	enf = EnvGen.kr(Env([150,18000],[0.1],[-2]));
	sig = PinkNoise.ar(0.4,0.5)*env;
	sig = HPF.ar(sig,enf);

	Out.ar(~dac[\drumsHhDVC][\lets][\busHhInstance],sig)
}).add;

~hihat= Pdef(\hihatBeat,
	Pbind(
		\instrument, \hihat,
		//\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
		\dur, Pwrand([Pseq(0.125!4,1),Prand(0.0625!3,1)],[5,10].reciprocal,inf),
		\legato, 0.01,
		\amp, 1,
		\freq, Pseq([50,100],inf),
		\group, ~groups[\SYNTHS][\Drums][\drumsHh][\drumsHhDVC]
));

)
~hihat.play;

(
SynthDef(\pluggedInstrument,{
	|out = 0, freq = 50, amp = 0.7, sustain=0.1|
	var sig, env, enf;
	sig = In.ar(3,1);


	//sig = LinPan2.ar(sig,SinOsc.kr(0.6,0,1));
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
~bass.stop;
~monos.stop;
~pads.stop;
