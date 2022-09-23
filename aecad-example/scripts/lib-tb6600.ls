
add-class class TB6600 extends PinArray
    @rev_TB6600 = 3
    (data) ->
        pin-count = 12
        super data, defaults =
            name: 's_'
            pad:
                dia: 2.54mm
                drill: 1mm
            cols:
                count: 1
            rows:
                count: pin-count
                interval: 5.08mm
            dir: 'x'
            labels:
                1: "vcc"    # 9-40V
                2: "gnd"
                3: "b+"     # coil B
                4: "b-"
                5: "a+"     # coil A
                6: "a-"
                7: "pul+"   # pulse
                8: "pul-"
                9: "dir+"   # direction
                10: "dir-"
                11: "ien+"  # inverse enable
                12: "ien-"
            mirror: yes
            border:"default"

add-class class TB6600_10 extends PinArray
    # 10 pin version of the original one.
    # en+ and en- pins are removed.
    @rev_TB6600_10 = 2
    (data) ->
        pin-count = 10
        super data, defaults =
            name: 's_'
            pad:
                dia: 2.54mm
                drill: 1mm
            cols:
                count: 1
            rows:
                count: pin-count
                interval: 5.08mm
            dir: 'x'
            labels:
                1: "vcc"    # 9-40V
                2: "gnd"
                3: "b+"     # coil B
                4: "b-"
                5: "a+"     # coil A
                6: "a-"
                7: "pul+"   # pulse
                8: "pul-"
                9: "dir+"   # direction
                10: "dir-"
            mirror: yes
            border: "default"


#new TB6600_10