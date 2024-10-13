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
	Out.ar(30,sig)
}).add;



~bombos = Pdef(\pulso,
	Pbind(
		\instrument, \bombo,
		\dur, 0.3,
		\amp,1,
		\freq, 80
));

~bombos.play;
)
