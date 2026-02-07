provides class MP1584_Module extends DoublePinArray
    @rev_MP1584_Module = 1
    (data, overrides) ->
        pin-count = 4
        interval = (13.208mm + 8.128mm) / 2
        distance = 18.542mm
        pad =
            height: 2mm + 2.54mm
            width: 2mm

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
                height: 16.764mm
                width: 22.098mm

            labels:
                1: 'in-'
                2: 'in+'
                3: 'out+'
                4: 'out-'

            dimple:
                x: 14mm
                y: 13mm

if __main__
    new MP1584_Module