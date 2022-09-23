provides class DIP8 extends Footprint
    @rev_DIP8 = 1
    create: (data) ->
        inch = 2.54mm
        pin =
            drill: 0.6mm
            dia: 1.9mm
            count: 8

        new DoublePinArray do
            parent: this
            name: 'c_'
            distance: 3*inch
            left:
                pad: pin
                rows:
                    count: pin.count/2
                    interval: 1*inch
            right:
                start: pin.count/2 + 1
                dir: '-y'
                pad: pin
                rows:
                    count: pin.count/2
                    interval: 1*inch

            labels: data?labels or {}

        @make-border do
            border:
                width: 4 * inch
                height: pin.count/2 * inch

        /* skipping as the multiple border
            feature is not correctly implemented yet
        @make-border do
            border:
                dia: 1mm
                offset-y: -4mm
        */

#new DIP8