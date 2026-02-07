# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------

Prototype_Interface =
    * "Dsub_25":
        * "SystemHead25"
    * "Dsub_9":
        * "RS-232"
    * "PCB/Screw, 2x1":
        * "Power input"
        * "Trigger input"
        * "Master alarm output"
    * "Usb Type-A Female":
        * "Debugger port"
    * "1x8 Header"
        * "Logic Analyzer Port"


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

"""
Opto output circuit:
    Diagram: Optocoupler-circuit.png
    R15: 1K, 0.125W (power: 0.29W, resistor should be 0.250W min)
    R21: 330 ohm
    Opto: TLP181
    R22: 5.6K


"""

laser-control-card = -> ->
    iface: []
    schemas:
        driver: AM26C31x_circuit do
            variant: "D"
        receiver: AM26LS32Ax_circuit do
            package: "soic"
        smps_5v: lm2576-smps do
            vout: "5V"
        smps_3v3: lm2576-smps do
            vout: "3.3V"
    bom:
        Dsub_15_Vertical:
            '':
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
                    # nc
                    7: 'nc'
                    15: 'nc'
                    8: 'nc'

        Dsub_9_Vertical:
            '':
                "enc": # encoder input
                    8: 'a+'
                    4: 'a-'
                    7: 'b+'
                    3: 'b-'
                    5: 'gnd'    # Should be same as `l.5` pin
                    9: "5V"     # Should be NC in `l.9`
                    #no connection
                    1: 'nc'
                    2: 'nc'
                    6: 'nc'

                "l": # laser control
                    1: 'red'
                    2: 'pwm'
                    3: 'en'
                    4: 'pctl'
                    5: 'gnd'
                    #no connection
                    6: "nc"
                    7: "nc"
                    8: "nc"
                    9: "nc"
        D09S13A6GV00LF:
            '':
                debug:
                    1: "nrst"
                    2: "swdio"
                    3: "gnd"
                    4: "swclk"
                    6: "nc"
                    7: "nc"
                    8: "nc"
                    5: "eng"    # engineering mode enable
                    9: "gnd"

        DG142V_5_08_XXP:
                "8 terminals":
                    "gn": ["gnd" for [1 to 8]]
                "4 terminals":
                    "dout": ["q#{..}" for [1 to 4]]
                    "din": ["i#{..}" for [1 to 4]]
                "2 terminals":
                    "rs485": <[ A B ]>
                    "a_ref": <[ in gnd ]>

        Phoenix_MC:
            "MC-1.5_2-G-3.81":
                "p_in": <[ vin gnd ]>
            "MC-1.5_3-G-3.81":
                "c1 c2": <[ 24v 5v gnd ]> # Power lines
                "pres": <[ 24v in gnd ]> # Presence Sensor

        Conn:
            "2x20 2.54mm": "j1 j2"

        Cca_MCU: "c3"
        Cca_MCU_Debug: "c4"
        driver: "d"
        receiver: "r"
        smps_5v: "p5"
        smps_3v3: "p3"

    cables:
        "j1": "j2"
        "c1": "c2"

    netlist:
        # Connector Box
        gnd: """c2.gnd enc.gnd
            pres.gnd l.gnd gn.gnd
            """
        2: "pres.24v c2.24v"
        "5v": "c2.5v enc.5V"
        200: "p_in.vin c1.24v"
        201: "p_in.gnd gnd"


        # Cable pinout
        44: "j1.1 j1.2 j1.39 j1.40 gnd "
        4: "j1.3 enc.b+"
        5: "j1.4 enc.b-"
        6: "j1.5 enc.a+"
        7: "j1.6 enc.a-"
        9: "j1.7 l.red"
        10: "j1.8 l.pwm" # fire
        11: "j1.9 l.en"
        12: "j1.10 dout.q1"
        13: "j1.11 dout.q2"
        14: "j1.12 dout.q3"
        15: "j1.13 dout.q4"
        16: "j1.14 din.i1"
        17: "j1.15 din.i2"
        18: "j1.16 din.i3"
        19: "j1.17 din.i4"
        20: "j1.19 pres.in"
        21: "j1.18 rs485.A"
        22: "j1.22 rs485.B"
        23: "j1.21 g.clk-"
        24: "j1.24 g.clk+"
        25: "j1.23 g.sync-"
        26: "j1.26 g.sync+"
        27: "j1.25 g.x-"
        28: "j1.28 g.x+"
        29: "j1.27 g.y-"
        30: "j1.30 g.y+"
        31: "j1.29 g.y_stat-"
        32: "j1.32 g.y_stat+"
        33: "j1.31 g.x_stat-"
        34: "j1.34 g.x_stat+"
        # j1.33
        # j1.35
        # j1.36
        # j1.37
        # j1.38

        # laser power control
        8:
            1: "a_ref.in l.pctl"
            2: "a_ref.gnd gnd"

        101: # debug port
            1: "c4.SWCLK debug.swclk"
            2: "c4.GND debug.gnd gnd"
            3: "c4.SWDIO debug.swdio"
            4: "c4.NRST  debug.nrst"

        # Control Card
        # -------------------------------
        100:
            20: "r.vcc d.vcc 5v"
            0: "gnd d.gnd r.gnd"

            # Interface side
            # --------------
            # driver output connections
            1: 'g.clk- d.1z'
            2: 'g.clk+ d.1y'
            3: 'g.sync- d.2z'
            4: 'g.sync+ d.2y'
            5: 'g.x- d.3y'
            6: 'g.x+ d.3z'
            7: 'g.y- d.4z'
            8: 'g.y+ d.4y'
            # status input connections
            9: 'g.y_stat+ r.1a'
            10: 'g.y_stat- r.1b'
            11: 'g.x_stat+ r.2b'
            12: 'g.x_stat- r.2a'

        102: # MCU

            # galvo outputs
            1: "c3.PE14 d.1a" # clk
            2: "c3.PE12 d.2a" # sync
            3: "c3.PE10 d.3a" # x
            4: "c3.PE8 d.4a" # y
            #?: r.1y # y_stat
            #?: r.2y # x_stat


            # encoder inputs
            5: "c3.PE9 r.3y"
            6: "c3.PE11 r.4y"

            # Unimplemented (yet) pins
            # -------------------
            # PA2 # USART2_TX
            # PA3 # USART2_RX
            # PD12 -> Trigger input
            # c3.PD13 - Laser EN_RED output
            # c3.PD14 - Laser shot output
            # c3.PA4 - LASER_POWER_OUT (Analog)
            # c3.PC0 - MASTER_ERROR_OUT


        103: # Encoder
            # Differential line receiver inputs
            1: "enc.a+ r.3b"
            2: "enc.a- r.3a"
            3: "enc.b+ r.4b"
            4: "enc.b- r.4a"

        # SMPS connections
        104: "p5.gnd, p3.gnd gnd"
        105: "p5.vfs, p3.vfs"
        106: "5v p5.vout"
        "3v3": "p3.vout"
        108: "p_in.vin p5.vff"

        # MCU power
        109: "c3.GND gnd"
        110: "c3.VCC 3v3"

        /*
        laser:
            # Laser Unit
            # ----------
            26: "gnd c1.gnd c3.gnd c4.gnd c7.gnd c5.c"
            28: "vcc c3.vcc c4.vcc c7.vcc c5.a"
            23: "conn.pwm c3.in", 27: "c3.out c1.pwm"
            24: "conn.en c4.in", 29: "c4.out c1.en"
            25: "conn.pctl c1.pctl"
            # red beam
            # (automatically turned off while laser is produced)
            32: "conn.red c7.in", 35: "c7.out c1.red"
        */

    debug: yes
    no-connect:
        """
        g.nc, g.S, enc.nc, enc.S, l.nc, l.S, debug.eng, debug.nc, debug.S, j1.33, j1.35, j1.36, j1.37, j1.38, j2.33, j2.35, j2.36, j2.37, j2.38, c3.PC15, c3.PC14, c3.PC13, c3.PE6, c3.PE5, c3.PE4, c3.PE3, c3.PE2, c3.PE1, c3.PE0, c3.PB9, c3.PB8, c3.PB7, c3.PB6, c3.PB5, c3.PB4, c3.PB3, c3.PD7, c3.PD6, c3.PD5, c3.PD4, c3.PD3, c3.PD2, c3.PD1, c3.PD0, c3.PC12, c3.PC11, c3.PC10,  c3.PA12, c3.PA11, c3.PA10, c3.PA9, c3.PA8, c3.PC9, c3.PC8, c3.PC7, c3.PC6, c3.PD15, c3.NRST, c3.PC0, c3.PC1, c3.PC2, c3.PC3, c3.PA0, c3.PA1, c3.PA2, c3.PA3, c3.PA4, c3.PA5, c3.PA6, c3.PA7, c3.PC4, c3.PC5, c3.PB0, c3.PB1, c3.PB2, c3.PE7, , c3.PE13, c3.PE15, c3.PB10, c3.PB11, c3.PB12, c3.PB13, c3.PB14, c3.PB15, c3.PD8, c3.PD9, c3.PD10, c3.PD13, c3.PD11, c3.PD12, c3.PD14, c4.PA15, c4.VDD_OK
        """
        # TMP
        " r.1y, r.2y"

        # KNOWN UNUSED PINS
        # -------------------
        # Pin-20 is not used for IDE cables
        "j1.20 j2.20"
        # These pins are connected within the source circuit
        "d.g, d.n_g, r.g, r.n_g"




if __main__
    sch = standard new Schema {
        debug: yes
        name: 'laser-control-card'
        data: laser-control-card!!
        bom: {
            # helper materials
            RefCross: ["__r#{..}" for [1 to 6]]
            Bolt: "3mm": ["__b#{..}" for [1 to 8]]
        }
    }

    #sch.components-by-name.gn.upgrade!


