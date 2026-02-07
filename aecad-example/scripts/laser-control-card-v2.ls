# --------------------------------------------------
# TODO:
# 1. Add parasitic capacitors near every IC
# 2. Long input line -> noise?
# --------------------------------------------------

Galvo_Control_Card_Next =
    * "Dsub_15 Female":
        * "Galvo Control"
    * "Dsub_9 Female":
        * "RS-232"
        * "Lazer control"
    * "PCB/Screw, 2x1":
        * "Power input"
        * "Trigger input"
        * "Master alarm output"
    * "Pin header":
        * "Debugger port"
    * "1x8 Header"
        * "Logic Analyzer Port"

opto-input-circuit = (config) ->
    # Based on: https://electronics.stackexchange.com/q/80597/20285

    alternative-config =
        1:
            desc: "Two way input with transient voltage protection"
            opto: "LTV_814S_TA1"
            reverse_protection: "SMBJ12A": "Bidirectional"
        2:
            desc: "Reverse polarity protection without transient voltage protection"
            opto: "TLP181"
            reverse_protection: "any diode"

    (value) ->
        iface: "in+ in- vcc gnd out"
        bom:
            R1206:
                "1K, 1/4W": "R1"
                "330 ohm": "R2"
                "4.7K": "R3"
            LTV_814S_TA1: "opto"
            SMBJ12A:
                "Unidirectional": "D1" # Reverse voltage protection
            LED1206:
                "red": "led"

        netlist:
            "in+": "R1.1"
            "in-": "D1.a opto.ca"

            1: "D1.c R1.2 led.a"
            2: "R2.2 opto.a"

            "vcc": "R3.1"
            "out": "R3.2 opto.co"

            "gnd": "opto.e"

            # Led connection
            3: "led.c R2.1"


opto-output-circuit = (config) ->
    # Driven by transistor
    (value) ->
        iface: <[ in gnd 3v3 c e ]>
        schemas:
            oc_output: oc-output({R: "1K", Q: "BC817"})
        bom:
            oc_output: "c1"
            LTV_814S_TA1: "opto"
            LED1206: "green": "l"
            R1206:
                "330 ohm": "R1"
                "120 ohm": "R2"
            D1206:
                "SD1206S040S2R0": "d_in"
            SMBJ12A:
                "Unidirectional": "d_rev"

        netlist:
            "in": "c1.in"
            "gnd": "c1.gnd"
            1: "c1.out opto.ca l.c"
            2: "l.a R1.1"
            "3v3": "R1.2 R2.2"
            3: "R2.1 opto.a"
            "c": "d_in.a"
            4: "d_in.c opto.co d_rev.c"
            "e": "opto.e d_rev.a"

rs232-driver = (config) ->
    # Description
    # -----------
    # din*: CMOS side, data input, connected to tx*
    # dout*: CMOS side, data output, connected to rx*
    # rx, tx: RS232 side
    (value) ->
        iface: <[ vcc gnd din1 dout1 din2 dout2 tx1 tx2 rx1 rx2 ]>
        bom:
            TSSOP_16:
                "MAX3232":
                    "m":
                        1: 'C1+' # 1 — Positive lead of C1 capacitor
                        2: 'V+'  # 2 O Positive charge pump output for storage capacitor only
                        3: 'C1-' # 3 — Negative lead of C1 capacitor
                        4: 'C2+' # 4 — Positive lead of C2 capacitor
                        5: 'C2-' # 5 — Negative lead of C2 capacitor
                        6: 'V-'  # 6 O Negative charge pump output for storage capacitor only
                        7: 'DOUT2' # 7 O RS232 line data output (to remote RS232 system)
                        14: 'DOUT1' #14 O RS232 line data output (to remote RS232 system)
                        8: 'RIN2' #8 I RS232 line data input (from remote RS232 system)
                        13: 'RIN1' #13 I RS232 line data input (from remote RS232 system)
                        9: 'ROUT2' #9 O Logic data output (to UART)
                        12: 'ROUT1' #12 O Logic data output (to UART)
                        10: 'DIN2' #10 I Logic data input (from UART)
                        11: 'DIN1' #11 I Logic data input (from UART)
                        15: 'GND' #15 — Ground
                        16: 'VCC'
            C1206: # See Max3232 datasheet, Table 9-1
                "0.1 uF": "c1 c2 c3 c4 c_bypass"
            R1206:
                # Current limiting resistors
                # See: Figure 1 at https://www.analog.com/en/design-notes/new-development-rs232-interface.html
                # See: https://labprojectsbd.com/2021/02/18/max232-guideline/
                "300ohm": "r1 r2 r3 r4"

            'DO214AC':
                "SMBJ26CA-TKS (Bidirectional)": "t1 t2 t3 t4"

        netlist:
            "vcc": "m.VCC"
            "gnd": "m.GND"
            "din1": "m.DIN1"
            "din2": "m.DIN2"
            "dout1": "m.ROUT1"
            "dout2": "m.ROUT2"
            "_tx1": "m.DOUT1 r1.1"
            "_tx2": "m.DOUT2 r2.1"
            "_rx1": "m.RIN1 r3.1"
            "_rx2": "m.RIN2 r4.1"
            "tx1": "r1.2"
            "tx2": "r2.2"
            "rx1": "r3.2"
            "rx2": "r4.2"

            # Capacitors
            1: "c1.a m.C1+"
            2: "c1.c m.C1-"
            3: "c3.a m.V+"
            4: "c3.c gnd"
            5: "c2.a m.C2+"
            6: "c2.c m.C2-"
            7: "c4.c m.V-"
            8: "c4.a gnd"

            9: "c_bypass.a vcc"
            10: "c_bypass.c gnd"

            # ESD Protection
            # See: RS-232 protection, https://www.bourns.com/docs/technical-documents/technical-library/chip-diodes/publications/bourns_tvs_diode_short_form.pdf
            11: "gnd t1.a t2.a t3.a t4.a"
            12: "t1.c _tx1"
            13: "t2.c _tx2"
            14: "t3.c _rx1"
            15: "t4.c _rx2"

led-resistor = (config) ->
    /* Example:

        led-resistor:
            "green, 5v": "led1"

    */
    (value) ->
        color = value.match /\b([a-zA-Z]+)\b/ ?.1
        voltage = value.match /\b([1-9]+)[vV]\b/ ?.1
        v-forward = 2V
        resistor = (voltage - v-forward) / 15mA |> Math.ceil

        iface: "+ -"
        bom:
            LED1206:
                "#{color}": "led"
            R1206:
                "#{resistor} Kohm": "r"

        netlist:
            "+": "r.1"
            1: "r.2 led.a"
            "-": "led.c"


laser-control-card2 = -> ->
    /* TODO:

    x 1. Dijital çıkışlar için ters bağlantı koruması koy.
    2. I/O'lara ESD ekle
    3. Kalibrasyon potunu ileri kaydır (kapak için)
    x 4. Lazer kontrol çıkışlarına pull-down ekle

    */
    iface: []
    schemas: # subcircuits
        driver: AM26C31x_circuit do
            variant: "D"
        opto_input: opto-input-circuit!
        opto_out: opto-output-circuit!
        rs232_driver: rs232-driver!
        parasitic: parasitic
        power-input-protection: power-input-protection!
        led-resistor: led-resistor!
    bom:
        Dsub_15_Vertical:
            'Female':
                "g": # galvo head
                    1: 'clk-'
                    9: 'clk+'
                    2: 'sync-'
                    10: 'sync+'
                    3: 'x-'
                    11: 'x+'
                    4: 'y-'
                    12: 'y+'
                    5: 'y_stat-'
                    13: 'y_stat+'
                    6: 'x_stat-'
                    14: 'x_stat+'
                    # no connection
                    7: 'nc'
                    15: 'nc'
                    8: 'nc'

        Dsub_9_Vertical:
            'Female':
                "sp": # Serial Port (RS-232)
                    1: 'nc'
                    2: 'tx'   # to: Omron.RX(3)
                    3: 'rx'   # to: Omron.TX(2)
                    4: 'nc'
                    5: 'gnd'  # to: Omron.Gnd(9)
                    6: 'tx2'
                    7: 'rx2'
                    8: 'nc'
                    9: 'gnd'

                "l": # laser control, default: output
                    1: 'red'    # JPT.21, Red beam
                    2: 'pwm'    # JPT.17, Laser shot
                    3: 'en'     # JPT.7,  Enable
                    4: 'pctl'   # JPT.8,  0-4V analog
                    5: 'gnd'    # JPT.9,  Gnd
                    6: "ready"  # JPT.19, System ready, INPUT
                    7: "reset"  # JPT.20, Error reset
                    8: "alarm"  # JPT.16, Alarm Status, INPUT
                    9: "nc"

        Conn:
            '1x4 2.54mm':
                debug:
                    1: "nrst"
                    2: "swdio"
                    3: "gnd"
                    4: "swclk"

        DG142V_5_08_XXP:
            "4 terminals":
                "dout": <[ q1c q1e q0c q0e ]>
                "din": <[ i0+ i0- i1+ i1- ]>
            "2 terminals":
                "p_in": <[ gnd vin ]>

        Cca_MCU: "c3"
        Cca_MCU_Debug: "c4"
        driver: "d"
        LM2596_Module:
            "5V": "p5"
            "3.3V": "p3"
            "5.8V": "p4"
        opto_input: "i0 i1"
        opto_out: "q0 q1"
        rs232_driver: "d2"
        _74LCX244: "d3"
        LM324_SOIC: "c1"
        Trimpot_3296:
            "RKT-3296W-103-R": "r"
        parasitic: [
            "c5", # opamp supply filter
            ]
        C1206:
            "10nF": "c6" # Analog output filter
            "100nF": "c7" # NRST parasitic filter
        R1206:
            "10K": "r1" # opamp analog input pull down
            "4.7K": "r2 r3 r4" # Laser control output pull down
        power-input-protection: 'p1'
        led-resistor:
            "green, 24v": "pin_led"
        Jumper_1206:
            "0 ohm": "j1 j2"
        TestBoundary:
            "1.2mm": "t1 t2 t3"


    netlist:
        # SMPS connections
        108: "p_in.vin p1.vff"
        gnd: "p_in.gnd p1.gnd"
        "vfs": "p1.vfs"

        104: "gnd p5.in-, p3.in- p4.in- p5.out- p3.out- p4.out-"
        105: "vfs p5.in+, p3.in+, p4.in+"
        "5v": "p5.out+ t1.1"
        "3v3": "p3.out+ t2.1"
        "5v8": "p4.out+ t3.1"

        150:
            # Input power indicator LED
            1: "vfs pin_led.+"
            2: "gnd pin_led.-"


        # Galvo driver
        # -------------------------------
        100:
            0: "d.gnd gnd"
            20: "d.vcc 5v"

            # Interface side
            # --------------
            # driver output connections
            1: 'g.clk- d.1z'
            2: 'g.clk+ d.1y'
            3: 'g.sync- d.2z'
            4: 'g.sync+ d.2y'
            5: 'g.x- d.3y' # x output is inverted for a smoother route
            6: 'g.x+ d.3z'
            7: 'g.y- d.4z'
            8: 'g.y+ d.4y'

        102: # MCU
            # ----------------------
            # debug port
            31: "c4.SWCLK debug.swclk"
            32: "c4.GND debug.gnd gnd"
            33: "c4.SWDIO debug.swdio"
            34: "c4.NRST c3.NRST debug.nrst"
            35: "debug.nrst c7.a"
            36: "gnd c7.c"

            # galvo driver connection
            1: "c3.PE14 d.1a" # clk
            2: "c3.PE12 d.2a" # sync
            3: "c3.PE10 d.3a" # x
            4: "c3.PE8 d.4a" # y

            # USART2
            5: "c3.PA2 d2.din1"  # USART2_TX
            6: "c3.PA3 d2.dout1" # USART2_RX

            # Auxilary serial port, UART5
            55: "c3.PC12 d2.din2"  # UART5_TX
            56: "c3.PD2 d2.dout2" # UART5_RX

            # Laser unit
            # ----------------------------------------
            # MCU side          Socket side
            # ---------         ---------------
            7: "c3.PB5 d3.i1 r2.1", 17: "d3.q1 l.en"        # EN_RED (Enable+Red Light output)
            8: "c3.PB7 d3.i2 r3.1", 18: "d3.q2 l.pwm"       # LASER_SHOT (output)
            9: "c3.PC13 d3.i3 r4.1", 19: "d3.q3 l.reset"    # LASER_RESET (output)
            199: "gnd r2.2 r3.2 r4.2"
            10: "d3.q4 c3.PB3", 20: "d3.i4 l.alarm"    # LASER_ALARM
            11: "d3.q6 c3.PB9 ", 21: "d3.i6 l.ready"   # LASER_READY
            # LASER_POWER_OUT
            12: "c3.PA4 c1.in2+", 22: "c1.out2 l.pctl"  # LASER_POWER_OUT (Analog)
            13: "l.red l.en"
            14: "l.gnd gnd"
            # ------------------------------------------

            # MASTER_ERROR_OUT
            43: "c3.PC10 q0.in"
            44: "q0.c dout.q0c"
            45: "q0.e dout.q0e"
            # AUXILARY_OUTPUT1
            49: "c3.PD1 q1.in"
            50: "q1.c dout.q1c"
            51: "q1.e dout.q1e"

            # TRIGGER_INPUT
            40: "i0.out c3.PD5 "
            41: "i0.in+ din.i0+"
            42: "i0.in- din.i0-"
            # AUXILARY_INPUT1
            46: "i1.out c3.PD3"
            47: "i1.in+ din.i1+"
            48: "i1.in- din.i1-"

        103: # Laser unit driver
            1: "d3.oe1' d3.oe2' gnd"

        # Digital input output drivers
        130: "q0.3v3 q1.3v3 i0.vcc i1.vcc 3v3 j1.1"
        131: "q0.gnd q1.gnd i0.gnd i1.gnd gnd"

        # MCU power
        109: "c3.GND gnd"
        110: "c3.VCC 3v3"

        # RS-232 Driver connections
        120:
            1: "d2.vcc 3v3"
            2: "d2.gnd gnd"
            3: "d2.tx1 sp.tx"
            4: "d2.rx1 sp.rx"
            13: "d2.tx2 sp.tx2"
            14: "d2.rx2 sp.rx2"
            5: "sp.gnd gnd"

        # CMOS-TTL converter connections
        125:
            1: "d3.gnd gnd"
            2: "d3.vcc 3v3"
            # Properly terminate the unused channels
            3: "d3.i0, d3.i7, d3.i5, gnd"

        # Analog amplifier
        127:
            9: "5v8 c1.vcc c5.a j2.1"
            10: "gnd c1.vee"
            1: "c1.out2 r.1"
            2: "c1.in2- r.2"
            3: "gnd r.3 c5.c"
            # Properly terminate the unused channels
            # See: https://e2e.ti.com/blogs_/archives/b/thesignal/posts/the-unused-op-amp-what-to-do
            4: "c1.in1+, c1.in3+, c1.in4+ 5v8"
            5: "c1.in1- c1.out1"
            6: "c1.in3- c1.out3"
            7: "c1.in4- c1.out4"
            # Analog input filter
            11: "c1.in2+ c6.a"
            12: "gnd c6.c"
            # Analog input pull down
            13: "gnd r1.1"
            14: "c1.in2+ r1.2"

    no-connect:
        # KNOWN UNUSED PINS
        # -------------------
        # These pins are connected within the source circuit
        "d.g, d.n_g"
        # Galvo connector
        "g.y_stat-, g.x_stat-, g.nc, g.y_stat+, g.x_stat+, g.S,"
        # Serial port connector
        "sp.nc, sp.S,"
        # Laser unit connector
        "l.nc, l.S,"
        # Unused MCU pins are configured as outputs
        "c3.PC15, c3.PC14,  c3.PB8, c3.PB6, c3.PB4, c3.PD7, c3.PD6, c3.PD4, c3.PD0,, c3.PC11, , c3.PA12, c3.PA11, c3.PA8, c3.PC9, c3.PC8, c3.PC7, c3.PC6, c3.PC2, c3.PC3, c3.PA0, c3.PA1, c3.PA5, c3.PA6, c3.PA7, c3.PC4, c3.PC5, c3.PB0, c3.PB1, c3.PB2,  c3.PB10, c3.PB11, c3.PB12, c3.PB13, c3.PB14, c3.PB15, c3.PD8, c4.PA15, "
        # Pins used by DMA, do not use for any purpose:
        "c3.PE0, c3.PE1, c3.PE2, c3.PE3, c3.PE4, c3.PE5, c3.PE6, c3.PE7, c3.PE9, c3.PE11, c3.PE13, c3.PE15"
        "c4.VDD_OK,"
        "c3.PA10, c3.PA9"
        "c3.PD15, c3.PD10, c3.PD11, c3.PD13, c3.PD14"
        "c3.PC0, c3.PC1"
        " c3.PD9, c3.PD12"
        # Unused TTL-CMOS converter outputs
        " d3.q5, d3.q7, d3.q0"


if __main__
    sch = standard new Schema {
        name: 'laser-control-card2'
        data: laser-control-card2!!
        bom: {
            # helper components
            RefCross: ["__r#{..}" for [1 to 4]]
            Bolt: "3mm": ["__b#{..}" for [1 to 8]]
        }
    }

    # Dizgi notları
    /**************

    1. Test probuyla (1K prob) tüm çıkışları test et.
    2. Tüm girişleri test et
    3. RS-232 girişini elektriksel olarak test et
        1. RS-232'yi kesinlikle PLC ile test etme (haberleşmeyi kesebilir)
    4. İşlemci modülü düzgün çalışmıyorsa harici olarak bağla



    */

    /* Update many traces' width
    for sch.scope.getTraces()
        if ..thickness < 0.40
            pcb.selection.add {aeobj: ..}
            ..thickness = 0.40
    */

    /* Debug the connection list
    conn-list-txt = []
    for id, net of sch.connection-list
        conn-list-txt.push "#{id}: #{net.filter((-> not it.is-via)).map (.uname) .join(',')}"
    console.log conn-list-txt.join '\n\n'
    */





