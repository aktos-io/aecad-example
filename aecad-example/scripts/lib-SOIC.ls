# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------

# depends: DoublePinArray
provides class SOIC16 extends DoublePinArray
    @rev_SOIC16 = 5
    (data, overrides) ->
        pin-count = overrides?pin-count or 16
        interval = 1.27mm
        distance = overrides?distance or 5.40mm
        pad =
            height: 0.60mm
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
                height: (pin-count/2) * interval
                width: distance - pad.width * 1.2

            dimple:
                x: 2.7mm
                y: 0.1mm



provides class SOIC14 extends SOIC16
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 14

provides class SOIC20_DW extends SOIC16
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 20
            distance: 9.3mm

if __main__
    new SOIC16
    new SOIC14
    new SOIC20_DW