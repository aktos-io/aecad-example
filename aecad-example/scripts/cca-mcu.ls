# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------

# depends: DoublePinArray
provides class Cca_MCU extends DoublePinArray
    @rev_Cca_MCU = 4
    (data, overrides) ->
        pin-count = 80
        pitch = 2.54mm
        pad =
            width: 4mm
            height: 1.5mm
        one-side-dist = pitch + pad.width - 1mm
        two-side-dist = 68.35mm

        cca-mcu-port1 =
            1: 'PC15'
            2: 'PC14'
            3: 'PC13'
            4: 'PE6'
            5: 'PE5'
            6: 'PE4'
            7: 'PE3'
            8: 'PE2'
            9: 'PE1'
            10: 'PE0'
            11: 'PB9'
            12: 'PB8'
            13: 'PB7'
            14: 'PB6'
            15: 'PB5'
            16: 'PB4'
            17: 'PB3'
            18: 'PD7'
            19: 'PD6'
            20: 'PD5'
            21: 'PD4'
            22: 'PD3'
            23: 'PD2'
            24: 'PD1'
            25: 'PD0'
            26: 'PC12'
            27: 'PC11'
            28: 'PC10'
            29: 'VCC'
            30: 'GND'
            31: 'PA12'
            32: 'PA11'
            33: 'PA10'
            34: 'PA9'
            35: 'PA8'
            36: 'PC9'
            37: 'PC8'
            38: 'PC7'
            39: 'PC6'
            40: 'PD15'
            41: 'NRST'
            42: 'PC0'
            43: 'PC1'
            44: 'PC2'
            45: 'PC3'
            46: 'PA0'
            47: 'PA1'
            48: 'PA2'
            49: 'PA3'
            50: 'PA4'
            51: 'PA5'
            52: 'PA6'
            53: 'PA7'
            54: 'PC4'
            55: 'PC5'
            56: 'PB0'
            57: 'PB1'
            58: 'PB2'
            59: 'PE7'
            60: 'PE8'
            61: 'PE9'
            62: 'PE10'
            63: 'PE11'
            64: 'PE12'
            65: 'PE13'
            66: 'PE14'
            67: 'PE15'
            68: 'PB10'
            69: 'PB11'
            70: 'PB12'
            71: 'PB13'
            72: 'PB14'
            73: 'PB15'
            74: 'PD8'
            75: 'PD9'
            76: 'PD10'
            77: 'PD11'
            78: 'PD12'
            79: 'PD13'
            80: 'PD14'


        super data, overrides `based-on` do
            distance: two-side-dist
            left:
                start: 41
                pad: pad
                cols:
                    count: 2
                    interval: one-side-dist
                rows:
                    count: pin-count/4
                    interval: pitch
                mirror: yes
            right:
                dir: 'x'
                pad: pad
                rows:
                    count: pin-count/4
                    interval: pitch
                cols:
                    count: 2
                    interval: one-side-dist
                labels: data.labels

            border:
                width: 2*one-side-dist + two-side-dist
                height: 60

            labels: cca-mcu-port1
            dimple:
                x: 70mm
                y: -2mm
                dia: 1mm


provides class Cca_MCU_Debug extends PinArray
    (data, overrides) ->
        pin-count = 6
        pitch = 2.54mm
        pad =
            width: 4mm
            height: 1.5mm

        cca-mcu-port2 =
            1: 'PA15'
            2: 'VDD_OK'
            3: 'SWCLK'
            4: 'GND'
            5: 'SWDIO'
            6: 'NRST'

        super data, overrides `based-on` do
            pad: pad
            cols:
                count: 1
                interval: pitch
            rows:
                count: pin-count
                interval: pitch
            dir: 'x'
            labels: data.labels or cca-mcu-port2
            border:
                width: pad.width * 1.2
                height: pitch * pin-count

if __main__
    standard new Schema {
        data:
            iface: []
            bom:
                Cca_MCU: "c1"
                Cca_MCU_Debug: "c2"
            disable-drc: "unused"
        }