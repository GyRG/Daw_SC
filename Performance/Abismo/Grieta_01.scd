(
s.waitForBoot({

    SynthDef(\bombo,{
        |out = 0, freq = 40, amp = 0.2|
        var sig, env, enf;
        env = EnvGen.kr(Env([0,1,0.4,0],[0.007,0.4,0.2],[-2,-3]),doneAction:2);
        enf = EnvGen.ar(Env([freq*1024,freq,freq/2],[0.3,0.5],[-77,-21]));
        sig = SinOsc.ar(freq*enf);
        sig = sig + LFTri.ar(freq,SinOsc.ar((freq),0,pi),0.7,0);
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
        env = EnvGen.kr(Env([0,0.4,0.1,0],[0.001,0.1,dur*4],[-2,-3]),doneAction:2);
		enf = EnvGen.kr(Env([1800,3000],[Rand(0.01,5)],[-2]));
		sig = Saw.ar(freq*4,amp)+LFSaw.ar(freq*7,SinOsc.ar(0.1,0,pi,pi),amp);
		sig = sig + WhiteNoise.ar(amp*LFNoise2.ar(Rand(10000,15000)),0.1)*env;
        sig = HPF.ar(sig,enf);
        Out.ar(~dac[\drumsRideDVC][\lets][\busRideInstance],sig*amp)
    }).add;

    SynthDef(\crash,{
        |out = 0, freq = 400, amp = 0.2, dur=1|
        var sig, env, envAtk, envDec, envSus;
        env = EnvGen.kr(Env([0,0.8,0.6,0],[0.1,0.8],[0,0]),timeScale:dur,doneAction:2);

		envAtk = EnvGen.kr(Env([0,0.7,0],[0.001,0.2],[-10,-2]),doneAction:0);
		envDec = EnvGen.kr(Env([0,0.7,0],[0.02,0.2],[-10,-2]),doneAction:0);
		envSus = EnvGen.kr(Env([0,0.7,0],[0.01,5],[-1,-6]),doneAction:0);

		sig = WhiteNoise.ar(SinOsc.ar(freq*4,0,envAtk));
		sig = sig + WhiteNoise.ar(SinOsc.ar(freq*16,0,envDec)) + SinGrain.ar(Dust.kr(800),0.7,freq*8,envDec*env);
		sig = sig + PinkNoise.ar(SinOscFB.ar(LFNoise2.ar(100,freq*4,freq*2),Saw.kr(100,0.2,0.8),envSus,0)) + SinGrain.ar(Dust.kr(700),0.04,freq*4,envSus*env);
		sig = BPF.ar(sig,1800) + BPF.ar(sig,4800) + BPF.ar(sig,6000) - LPF.ar(sig,800);
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

        env = EnvGen.kr(Env([0,0.8,0.1,0],[0.01,0.4,dur+4],[-40,0,2]),timeScale:dur,doneAction:2);
        envNoise = EnvGen.kr(Env([0.8,0.01],[0.3],[-5]));
        envFreq = EnvGen.ar(Env([freq*128,freq*0.75,freq*0.1],[0.01,0.08],[-10,-40]));
        envFilter = EnvGen.ar(Env([freq*2,10],[0.6],[-1]));
		sig = PinkNoise.ar(envNoise*0.4) + BrownNoise.ar(envNoise*0.5);
		sig = sig + SinOsc.ar(envFreq);
        sig = LPF.ar(sig,envFilter);
        Out.ar(~dac[\drumsTombDVC][\lets][\busTombInstance],sig*amp)
    }).add;

    SynthDef(\pads,{
        |out = 0, freq = 50, amp = 0.4|
        var sig, env, enf;
        env = EnvGen.kr(Env([0,1,0.7,0],[0.37,5,12],[0,1]),doneAction:2);
        sig = LFTri.ar(freq*0.5,0,0.4);
        20.do({
            sig = sig + PanX.ar(2,LFSaw.ar(freq+Rand(-5,5),0,0.08),SinOsc.kr(LFNoise1.kr(0.02,9,5),0,1,0),LFNoise1.kr(0.01,pi,pi*0.5),1.2) ;
        });
        sig  = sig * env *amp;
        Out.ar(~dac[\padsPinkDVC][\lets][\busPinkInstance],sig)
    }).add;

	SynthDef(\electricBass,{
        |out = 0, freq = 50, amp = 0.4, dur = 2, legato = 4|
        var sig, env, envLpf;
		env = EnvGen.kr(Env([0,1,0.7,0.3,0],[Rand(0.005,0.04),dur,legato,0.01],[-1,2,0]),doneAction:2);
		envLpf = EnvGen.kr(Env([1024,2048,128],[1,4],[0,-5]),doneAction:0);

		sig = LFTri.ar(0.5*freq,LFTri.ar(0.4,Rand(-pi,pi),pi),0.6);
		(1..15).do({|n,i|
			var panWidth = 0.7;

			if( n%2==0,{
				sig = sig + LinPan2.ar(LFSaw.ar(freq*n, 0, 0.1/n,0),1+panWidth/n);
			},{
				sig = sig + LinPan2.ar(LFSaw.ar(freq*n, LFNoise0.kr(0.7,2pi,pi), 0.1/n,0),1-panWidth/n);

			});
        });

		sig = LPF1.ar(sig, envLpf);
		sig = BPF.ar(sig,128,0.1,0.2)+BPF.ar(sig,256,0.2,0.7) + BPF.ar(sig,512,0.4,0.3) +BPF.ar(sig,1024,0.7,0.6);
        sig  = sig * env *amp;
        Out.ar(~dac[\bassElectricDVC][\lets][\busElectricInstance],sig)
    }).add;


    s.sync;

    ~snr= Pdef(\snareBeat,
        Pbind(
            \instrument, \snare,
            \dur, Pseq([4]/5,inf),
			\amp, Pseq((0.8!1) ++ (0.6!4),inf),
            \freq, Pseq([16],inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsSnare][\drumsSnareDVC]
    ));



    ~hihat= Pdef(\hihatBeat,
        Pbind(
            \instrument, \hihat,
            //\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
            \dur, Pseq(1/4!1,inf),
			\amp, Pseq((4!1)++(2!4),inf),
            \freq, Pseq([50,10],inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsHh][\drumsHhDVC]
    ));


    ~ride = Pdef(\rideBeat,
        Pbind(
            \instrument, \ride,

			\dur, Pseq([
				Pseq([0.5,0.5,0.25],4),
				Pseq(0.5!1,3)
			]/2,inf),

            \amp, Pseq([0.7]*0.5,inf),
			\freq, Pgauss(Pwrand([68,69,65].midicps,[80,0,0].normalizeSum ,inf),2,inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsRide][\drumsRideDVC]
    ));

    ~crash = Pdef(\crashBeat,
        Pbind(
            \instrument, \crash,
            //\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
            \dur, Pseq([6],inf),
            \amp, Pseq([0.3],inf),
                \freq, Pseq([70],inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsCrash][\drumsCrashDVC]
    ));


    ~tomb= Pdef(\tombBeat,
        Pbind(
            \instrument, \tomb,
            //\dur, Pwrand([Pseq([0.75],2),Pseq([0.125],3),Pseq([0.25],1)],[10,8,4].reciprocal,inf),
            \dur, Pseq(1/4!1,inf),
			\amp, Pseq((0.6!1) ++ (0.2!2) ++ (0.6!1) ++ (0.1!1),inf),
			\freq, Pseq([420],inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsTomb][\drumsTombDVC]
    ));



    ~bombos = Pdef(\pulso,
        Pbind(
            \instrument, \bombo,
            \dur, Pseq([4],inf),
            \amp,Pseq([0.3],inf),
            \freq, Pseq([7],inf),
            \group, ~groups[\SYNTHS][\Drums][\drumsKick][\drumsKickDVC]
    ));

    ~padSeq = Pdef(\chordProg,
        Pbind(

            \instrument, \pads,
            \dur, Pseq([4], inf),
            \amp,Pseq([0.5,0.7]*0,inf),
            \freq, Ptuple(
                [
					Pseq(
						[
							Pseq([60,62].midicps,1),
							Pseq([56,55].midicps,1)
					],inf),
					Pseq(
						[
							Pseq([70,70].midicps,1),
							Pseq([70,68].midicps,1)
					],inf),
					Pseq(
						[
							Pseq([72,74].midicps,1),
							Pseq([72,75].midicps,1)
					],inf),
					Pseq(
						[
							Pseq([77,79].midicps,1),
							Pseq([79,77].midicps,1)
					],inf)
				],
				inf),
            \group, ~groups[\SYNTHS][\Pads][\padsPink][\padsPinkDVC]
    ));

	~bassLine = Pdef(\bassLine,
        Pbind(

            \instrument, \electricBass,
            \dur, Pseq([1.5,4,4.5], inf),
            \amp,Pseq([0.5,0.7,0.7,0.4,0.6]*3,inf),
			\freq, Pseq([48,44,41,46].midicps,inf),
            \group, ~groups[\SYNTHS][\Bass][\bassElectric][\bassElectricDVC]
    ));

~sequencia = [~snr,~hihat,~ride,~crash,~tomb,~bombos,~padSeq,~bassLine];
});
    )
    