import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[03][unit:dB]", -70, +5))
  with{
    envelop   = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;  
};

oscill(o) = hgroup("[01] OSC %avo", os.oscsin(frq): *(vol)<: *(sqrt(1-pan)), *(sqrt(pan)))
  with{
    avo = o+(001);
    oscgroup(x)  = vgroup("[02] f1", x);
    frq = oscgroup(vslider("[01] FREQ [style:knob] [unit:Hz]", 440,100,20000,1)); 
    pan = oscgroup(vslider("[02] PAN [style:knob]", 0.5,0,1,0.01)); 
    vol = oscgroup(vslider("[03] VOL [style:knob]", 0.0,0.0,1.0,0.01));
};

stereo = hgroup("[127] STEREO OUT", *(vol), *(vol) : vmeter, vmeter)
  with{
    vol = vslider("[01] VOL", 0,-70,0,+6.1) : ba.db2linear : si.smoo;
};
  
process = hgroup("OSCILLATORS BANK", par(i, 12, oscill(i)) :> stereo);
