#! requires SOT223

provides class LM1117 extends SOT223
    @rev_LM1117 = 1
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                # Pin_id: Label
                1: 'gnd'
                2: 'vout'
                3: 'vin'
                4: 'vout'
            allow-duplicate-labels: yes
            interconnected-pins: <[ vout ]>

lm1117-std = (config) ->
    (value) ->
        iface: "c1.gnd c1.vout c1.vin"
        bom:
            LM1117:
                "#{value}": "c1"
            C1206:
                "10uF": "c2"
                "100uF": "c3"

        netlist:
            vin: "c2.a c1.vin"
            vout: "c3.a c1.vout"
            gnd: "c1.gnd c2.c c3.c"

if __main__
    standard new Schema data: lm1117-std!("5V")