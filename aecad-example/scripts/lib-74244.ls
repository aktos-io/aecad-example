# depends: SOIC20_DW
# depends: TSSOP_20

provides class SN74HCT244DWR extends SOIC20_DW
    @rev_SN74HCT244DWR = 1
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                1: "1oe'"
                2: "1a1"
                3: "2y4"
                4: "1a2"
                5: "2y3"
                6: "1a3"
                7: "2y2"
                8: "1a4"
                9: "2y1"
                10: "gnd"
                11: "2a1"
                12: "1y4"
                13: "2a2"
                14: "1y3"
                15: "2a3"
                16: "1y2"
                17: "2a4"
                18: "1y1"
                19: "2oe'"
                20: "vcc"



provides class _74LCX244 extends TSSOP_20
    @rev__74LCX244 = 2
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                1: "oe1'"
                2: "i0"
                3: "q4"
                4: "i1"
                5: "q5"
                6: "i2"
                7: "q6"
                8: "i3"
                9: "q7"
                10: "gnd"
                11: "i7"
                12: "q3"
                13: "i6"
                14: "q2"
                15: "i5"
                16: "q1"
                17: "i4"
                18: "q0"
                19: "oe2'"
                20: "vcc"
if __main__
    standard new Schema do
        data:
            bom:
                SN74HCT244DWR: "c1"
                _74LCX244: "c2"
            no-connect:
                "c1.1oe', c1.1a1, c1.2y4, c1.1a2, c1.2y3, c1.1a3, c1.2y2, c1.1a4, c1.2y1, c1.gnd, c1.2a1, c1.1y4, c1.2a2, c1.1y3, c1.2a3, c1.1y2, c1.2a4, c1.1y1, c1.2oe', c1.vcc"
                "c2.oe1', c2.i0, c2.q4, c2.i1, c2.q5, c2.i2, c2.q6, c2.i3, c2.q7, c2.gnd, c2.i7, c2.q3, c2.i6, c2.q2, c2.i5, c2.q1, c2.i4, c2.q0, c2.oe2', c2.vcc"