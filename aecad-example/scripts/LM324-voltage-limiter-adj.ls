
LM324-voltage-limiter-adj = (config) ->
    # based on:
    # https://electronics.stackexchange.com/a/135501/20285
    (value) ->
        iface: "in out vcc gnd a"
        # vcc >= 8V
        bom:
            LM324_SOIC: "op"
            Trimpot_Bourns_3006P: "gain limit"
            Conn:
                "1x4 2.54mm": "i"
            R1206:
                "4.7k": "r1"
            DO214AC:
                "d"
            lm1117-std:
                "5v": "vref"
            TestBoundary: "t1 t2 t3"
        schemas:
            lm1117-std: lm1117-std!

        netlist:
            vcc: "op.vcc"
            gnd: "op.vee"
            # gain stage
            in: "op.in1+"
            1: "op.out1 gain.1"
            2: "op.in1- gain.2"
            3: "gnd gain.3"
            # interface
            7: "i.4 out"
            6: "i.3 in"
            4: "i.2 vcc"
            5: "i.1 gnd"
            # limiter
            10: "r1.1 op.out1"
            11: "r1.2 op.in2- d.a"
            12: "d.c op.out2"
            13: "op.in2+ limit.2"
            14: "limit.3 gnd"
            vref: "limit.1 vref.vout"
            15: "vref.vin vcc"
            16: "vref.gnd gnd"
            # buffer
            20: "op.in3+ d.a"
            out: "op.in3- op.out3"

            # ground unused pads
            50: "gnd t1.1 t2.1 op.in4- op.in4+"
            "a": "op.out4 t3.1"

if __main__
    standard new Schema do
        data: LM324-voltage-limiter-adj!!
