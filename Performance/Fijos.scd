
s.waitForBoot({
    if(~freak.value != nil || ~lfo_control.value != nil,{ ~freak.free; ~lfo_control.free; });


~lfo_control = SynthDef(\controlFx,{
    var control;

    control = SinOsc.kr(0.1,0,10);

    Out.kr(~lfo_rate,control);
        }).play;
s.sync;

~freak = Synth(\pluggedInstrument,
    target: ~groups[\SYNTHS][\External][\externalMicroFreak][\externalMicroFreakDVC],
    addAction: 'addToHead'
);

})