# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------

# depends: DoublePinArray
provides class SOIC16 extends Footprint
    @rev_SOIC16 = 4
    create: (data) ->
        pin-count = data?.pin-count or 16
        interval = 1.27mm
        distance = 5.40mm
        pad =
            height: 0.60mm
            width: 1.55mm
        parent = data.parent or this
        @iface = data.labels or [1 to pin-count]
        new DoublePinArray {
            parent,
            distance,
            left:
                dir: '-x'
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
            labels: data.labels
        }
        @make-border do
            border:
                width: distance - pad.width - pad.height
                height: interval * (pin-count / 2)

        @make-border do
            border:
                dia: 0.5mm
                centered: no
                offset-x:~ -> 1.5 * pad.width
                offset-y:~ -> pad.height / 2



provides class SOIC14 extends SOIC16
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 14

if __main__
    new SOIC16
    new SOIC14