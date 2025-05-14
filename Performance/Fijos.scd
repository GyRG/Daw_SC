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