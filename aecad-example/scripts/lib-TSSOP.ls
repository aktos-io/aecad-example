# depends: DoublePinArray

provides class TSSOP_20 extends DoublePinArray
    @rev_TSSOP_20 = 1
    (data, overrides) ->
        pin-count = overrides?pin-count or 20

        if pin-count % 2 isnt 0
            throw new Error "#{@@@name}: Pin-count should be multiple of 2. (current: #{pin-count})"

        # Dimensions taken from TI/AM26C31 datasheet
        # ------------------------------------------
        pad = data?.pad or pad =
            width: 1.5mm
            height: 0.45mm

        interval = 0.65mm
        distance = 5.8mm

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
                width: 4.40mm - 0.3
                height: (pin-count/2 * interval) + pad.height

provides class TSSOP_38 extends TSSOP_20
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 38

provides class TSSOP_16 extends TSSOP_20
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 16

if __main__
    standard new Schema do
        data:
            bom:
                TSSOP_20: "c1"
                TSSOP_38: "c2"
                TSSOP_16: "c3"
            no-connect:
                "c3.1,c3.2,c3.3,c3.4,c3.5,c3.6,c3.7,c3.8,c3.9,c3.10,c3.11,c3.12,c3.13,c3.14,c3.15,c3.16,
                ,c1.1,c1.2,c1.3,c1.4,c1.5,c1.6,c1.7,c1.8,c1.9,c1.10,c1.11,c1.12,c1.13,c1.14,c1.15,c1.16,c1.17,c1.18,c1.19,c1.20,c2.1,c2.2,c2.3,c2.4,c2.5,c2.6,c2.7,c2.8,c2.9,c2.10,c2.11,c2.12,c2.13,c2.14,c2.15,c2.16,c2.17,c2.18,c2.19,c2.20,c2.21,c2.22,c2.23,c2.24,c2.25,c2.26,c2.27,c2.28,c2.29,c2.30,c2.31,c2.32,c2.33,c2.34,c2.35,c2.36,c2.37,c2.38"
