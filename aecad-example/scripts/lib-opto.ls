# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------
# depends: DoublePinArray

provides class LTV_814S_TA1 extends DoublePinArray
    @rev_LTV_814S_TA1 = 1
    (data, overrides) ->

        # Dimensions taken from TI/AM26C31 datasheet
        # ------------------------------------------
        pad = data?.pad or pad =
            width: 1.3mm
            height: 1.5mm

        interval = 2.54mm
        distance = 9mm
        pin-count = 4

        super data, overrides `based-on` do
            name: 'r_'
            dir: '-x'
            distance: distance
            left:
                pad: pad
                rows:
                    count: pin-count/2
                    interval: interval
            right:
                start: pin-count/2 + 1
                pad: pad
                dir: '-y'
                rows:
                    count: pin-count/2
                    interval: interval
            border:
                height: (4.6 - interval) + (pin-count/2 - 1) * interval
                width: distance - 2mm

            dimple:
                x: 2.1mm
                y: 0.5mm

            labels:
                1: "a"
                2: "ca"
                3: "e"
                4: "co"


if __main__
    standard new Schema do
        data:
            bom:
                LTV_814S_TA1: "c1"
            no-connect:
                "c1.a, c1.ca, c1.e, c1.co"