# depends: DoublePinArray

provides class SO8 extends DoublePinArray
    (data, overrides) ->
        pad =
            width: 1.2mm
            height: 0.8mm
        pad-count = 8
        interval = 1.27mm

        super data, overrides `based-on` do
            distance: 5.5mm
            left:
                pad: pad
                rows:
                    count: pad-count/2
                    interval: interval
            right:
                start: pad-count/2 + 1
                dir: '-y'
                pad: pad
                rows:
                    count: pad-count/2
                    interval: interval
            border:
                width: 3.95mm
                height: 5.1mm
