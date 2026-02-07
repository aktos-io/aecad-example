# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------


provides class Cap_Aluminum_SMD extends PinArray
    @rev_Cap_Aluminum_SMD = 2
    (data, overrides) ->
        /*

        See: https://web.archive.org/web/20131102032848/http://industrial.panasonic.com/www-data/pdf/ABA0000/ABA0000PE251.pdf

        [Table of Board Land Size vs. Capacitor Size]
        Size/Dimension  a   b   c
        --------------  --- --- ---
        A (φ3)          0.6 2.2 1.5
        B (φ4)          1.0 2.5 1.6
        C (φ5)          1.5 2.8 1.6
        D (φ6.3)        1.8 3.2 1.6
        E (φ8 6.2L)    2.2 4.0 1.6
        F (φ8  10.2L)  3.1 4.0 2.0
        G (φ10  10.2L) 4.6 4.1 2.0
        H (φ12.5)       4.0 5.7 2.0
        J (φ16)         6.0 6.5 2.5
        K (φ18)         6.0 7.5 2.5
        */

        types =
            # Type name
            "D":
                a: 1.8mm
                b: 3.2mm
                c: 1.6mm
                dia: 6.3mm
            "E":
                a: 2.2mm
                b: 4.0mm
                c: 1.6mm
                dia: 8mm
            "F":
                a: 3.1mm
                b: 4.0mm
                c: 2.0mm
                dia: 8mm
            "H":
                a: 4mm
                b: 5.7mm
                c: 2mm
                dia: 12.5mm

        value-regex = //
            (\b[A-K]\b) # type
            //

        if data?value?.match value-regex
            type = that.1

        a = types[type].a
        b = types[type].b
        c = types[type].c
        margin = 0.5mm

        super data, overrides `based-on` do
            pad:
                width: b
                height: c
            cols:
                count: 2
                interval: a + b
            border:
                width: a + 2 * b + margin
                height: types[type].dia

            labels:
                1: "a"
                2: "c"

if __main__
    new Cap_Aluminum_SMD({value: "D"})
    new Cap_Aluminum_SMD({value: "H, "})