(
s.waitForBoot({
	if(~freak.value != nil || ~guitar.value != nil || ~lfo_control.value != nil,{ ~freak.free; ~guitar.free; ~lfo_control.free; });


SynthDef(\pluggedInstrumentXLR,{
        |out = 0, freq = 50, amp = 0.7, sustain=0.1|
        var sig, env, enf;
        sig = In.ar(2,1);


        //sig = LinPan2.ar(sig,SinOsc.kr(0.6,0,1));
        Out.ar(~dac[\externalMicroFreakDVC][\lets][\busMicroFreakInstance],sig*3)
    }).add;

	SynthDef(\pluggedInstrumentTRS,{
        |out = 0, freq = 50, amp = 0.7, sustain=0.1|
        var sig, env, enf;
        sig = In.ar(3,1);


        //sig = LinPan2.ar(sig,SinOsc.kr(0.6,0,1));
        Out.ar(~dac[\externalGuitarDVC][\lets][\busGuitarInstance],sig)
    }).add;


	SynthDef(\toySynth,{|freq=800,amp=0.5, bending = 0, gate, out 0,vibamp=0|
	var sig=0, env, vib;

	vib = LFSaw.kr(7).bipolar(vibamp);
	vib = vib.midiratio;
	freq = freq*bending.midiratio;
	14.do({|i|

		sig =  sig + LFTri.ar(freq+rrand(-8,8)*vib,(rrand(-1,1)),0.5);
		sig =  sig + VarSaw.ar(freq/2*vib,i*(rrand(0,pi)),exprand(0.1,0.9),0.5) + Dust2.ar(0.7,0.2*amp);
	});

	sig = Pan2.ar(sig,LFNoise1.kr(5,1,0),1);

	env = EnvGen.kr(Env.new([0,0.8,0.58,0.2,0],[0.01,0.4,3,0.24],[-5,-2,-4,3],1),gate,doneAction:2);

	sig = sig * amp *env;
	Out.ar(~dac[\demiurgesToyDVC][\lets][\busToyInstance],sig);
}).add;


s.sync;

~lfo_control = SynthDef(\controlFx,{
    var control;

    control = SinOsc.kr(0.1,0,10);

    Out.kr(~lfo_rate,control);
        }).play;
s.sync;

~freak = Synth(\pluggedInstrumentXLR,
    target: ~groups[\SYNTHS][\External][\externalMicroFreak][\externalMicroFreakDVC],
    addAction: 'addToHead'
);

s.sync;

~guitar = Synth(\pluggedInstrumentTRS,
	target: ~groups[\SYNTHS][\External][\externalGuitar][\externalGuitarDVC],
	addAction: 'addToHead'

);

s.sync;

})

)