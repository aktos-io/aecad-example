# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------
# depends: SOIC14
LM324_PINOUT =
    1: "out1"
    2: "in1-"
    3: "in1+"
    4: "vcc"
    5: "in2+"
    6: "in2-"
    7: "out2"
    8: "out3"
    9: "in3-"
    10: "in3+"
    11: "vee"
    12: "in4+"
    13: "in4-"
    14: "out4"


provides class LM324_SOIC extends SOIC14
    @rev_LM324_SOIC = 2
    (data, overrides) ->
        super data, overrides `based-on` do
            labels: LM324_PINOUT

lm324-amplifier = (config) ->
    (value) ->
        iface: "vcc gnd in out"
        bom:
            LM324_SOIC: "c1"
            Trimpot_Bourns_3006P: "r"
            Conn:
                "1x4 2.54mm smd": "i1"
        netlist:
            vcc: "c1.vcc"
            gnd: "c1.vee"
            in: "c1.in1+"
            out: "c1.out1"
            1: "c1.out1 r.1"
            2: "c1.in1- r.2"
            3: "gnd r.3"
            # interface
            7: "i1.4 out"
            6: "i1.3 in"
            4: "i1.2 vcc"
            5: "i1.1 gnd"
        no-connect:
            "c1.in2+, c1.in2-, c1.out2, c1.out3, c1.in3-, c1.in3+, c1.in4+, c1.in4-, c1.out4"

if __main__
    standard new Schema do
        data: lm324-amplifier!!
        bom:
            RefCross: '__a __b'
