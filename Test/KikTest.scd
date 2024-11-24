(

SynthDef(\bombo,{
	|out = 0, freq = 40, amp = 0.2|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.1,0],[0.01,0.23,0.1],[-2,-3]),doneAction:2);
	enf = EnvGen.ar(Env([150,0.001,1/512],[0.008,0.8,1.7],[-6,1]));
	sig = SinOsc.ar(freq*enf)!2;
	sig = sig + LFTri.ar(freq*2,SinOsc.ar(10,0,pi),0.2,0);
	sig = HPF.ar(sig,50)+LPF.ar(sig,1100,0.7);
	sig  = sig * env *amp;
	Out.ar(~dac[\drumsKickDVC][\lets][\busKickInstance],sig)
}).add;



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, 0.5,
		\amp,1,
		\freq, 40
));

~bombos.play;
)

(

SynthDef(\bass,{
	|out = 0, freq = 50, amp = 0.7|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,0.8,0.3,0],[0.001,0.05,0.3],[-1,1]),doneAction:2);
	sig = SinOsc.ar(freq);
	2.do({|i|

		sig = sig + LFTri.ar(freq + Rand(2,-2),SinOsc.kr(10,0,pi*2*i/27));
	});
	//sig = Pan2.ar(sig,LFNoise0.kr(1,1,0.5));
	sig  = sig * env *amp;
	Out.ar(~dac[\bassElectricDVC][\lets][\busElectricoInstance],sig!2)
}).add;



~bass = Pdef(\bajeo,
	Pbind(
		\instrument, \bass,
		\dur, Prand([0.125], inf),
		\amp,Pwrand([0.1,0.2,0.7]*1.5,[65,30,5].reciprocal,inf),
		\freq, Prand([40,41,44,47,48,52].midicps, inf)
));

~bass.play;
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
		\freq, Ptuple([Prand(2*[40,41,44,47,48,52].midicps, inf),Pseq(0.5*[40,41,44,47,48].midicps, inf), inf], inf)
));

~pads.stop;
)


