provides class LM2596_Module extends DoublePinArray
    @rev_LM2596_Module = 3
    (data, overrides) ->
        pin-count = 4
        interval = 17.6mm
        distance = 39.8mm
        pad =
            height: 3mm
            width: 3mm

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
                height: 21.082mm
                width: 43.18mm

            labels:
                1: 'in+'
                2: 'in-'
                3: 'out-'
                4: 'out+'

            dimple:
                x: 24mm
                y: 2mm

            interconnected-pins:
                <[ 2 3 ]>
                ...


if __main__
    new LM2596_Module
