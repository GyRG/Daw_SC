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
	Out.ar(42,sig)
}).add;



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, 0.1,
		\amp,1,
		\freq, 40
));

~bombos.stop;
)

(

SynthDef(\bass,{
	|out = 0, freq = 50, amp = 0.7|
	var sig, env, enf;
	env = EnvGen.kr(Env([0,1,0.5,0],[0.01,0.04,0.5],[-2,1,0]),doneAction:2);
	sig = SinOsc.ar(freq)!2;
	7.do({|x = 0.4|
		x = x-0.001;
		sig = sig + LFTri.ar(freq * x ,SinOsc.kr(freq,0,0.3),0.4);
	});
	sig  = sig * env *amp;
	Out.ar(~dac[\bassElectricDVC][\lets][\busElectricoInstance],sig)
}).add;



~bass = Pdef(\bajeo,
	Pbind(
		\instrument, \bass,
		\dur, Pseq([0.125], inf),
		\amp,Pwrand([0.1,0.2,0.7],[65,30,5].reciprocal,inf),
		\freq, Prand([40,41,44,47,48,52].midicps, inf)
));

~bass.stop;
)
)