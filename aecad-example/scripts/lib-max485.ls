# depends: SO8,DIP8

provides class Max485_DIP8 extends DIP8
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                1: "ro"
                2: "N_re"
                3: "de"
                4: "di"
                5: "gnd"
                6: "A"
                7: "B"
                8: "vcc"

provides class Max485_SO8 extends SO8
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                1: "ro"
                2: "N_re"
                3: "de"
                4: "di"
                5: "gnd"
                6: "A"
                7: "B"
                8: "vcc"

if __main__
    new Max485_SO8
