# --------------------------------------------------
# Use "# depends: " for dependencies
# Use "# provides:this" for provisions
# --------------------------------------------------

# depends: D25S13A6GV00LF, Conn
provides class GalvoHead25 extends D25S13A6GV00LF
    (data, overrides) ->
        super data, overrides `based-on` do
            allow-duplicate-labels: yes
            labels:
                # send
                1: 'clk-'
                14: 'clk+'
                2: 'sync-'
                15: 'sync+'
                3: 'x-'     # small mirror
                16: 'x+'
                4: 'y-'     # big mirror
                17: 'y+'
                5: 'z-'     # focus axis
                18: 'z+'

                # receive
                6: 'y_stat-'
                19: 'y_stat+'
                7: 'z_stat-'
                20: 'z_stat+'
                8: 'x_stat-'
                21: 'x_stat+'

                # power
                9: '+15v'
                22: '+15v'
                10: '+15v'
                23: 'pgnd' # Power GND
                11: 'pgnd'
                24: 'pgnd'
                12: '-15v'
                25: '-15v'
                13: '-15v'
                "S": 'sgnd'

provides class SystemHead25 extends GalvoHead25
    @rev_SystemHead25 = 3
    (data, overrides) ->
        super data, overrides `based-on` do
            allow-duplicate-labels: yes
            labels:
                # name      JPT Laser Pins
                11: 'red'
                24: 'pwm'
                12: 'en'
                25: 'pctl'
                13: 'gnd'
            connected-to:
                "JPT Laser.Dsub25":
                    'red': 21
                    'pwm': 17
                    'en': 7
                    'pctl': 8
                    'gnd': 9


SystemHead25_to_Separation_Adapter:
    input: "SystemHead25"
    outputs:
        * "Galvo Head":
            type: "Dsub_15 (Female)"
            pinouts: "GalvoHead15"
        * "JPT Laser":
            type: "Dsub_9 (Male)"
            pinouts:      # Connect to:
                1: "gnd"  # JPT.9
                2: "en"   # JPT.7
                3: "red"  # JPT.21
                4: "pwm"  # JPT.17
                5: "pctl" # JPT.8

cmos-to-ttl = (config) -> (value) ->
    iface: "in gnd out vcc"
    # see https://i.stack.imgur.com/HaxWn.png from https://electronics.stackexchange.com/a/353221/20285
    bom:
        IRLML5203: "m"
        R1206:
            "330ohm": "i"     # input
            "10K"   : "p l"   # pull-up & load simulator
        BC817: "b"            # bjt
    netlist:
        vcc: "p.1 m.s"
        out: "m.d"
        1: "p.2 m.g b.c"
        gnd: "b.e"
        2: "i.1 b.b"
        in: "i.2"
        3: "m.d l.1"
        4: "l.2 gnd"

galvo-head25 = (config) -> (value) ->
    iface: []
    schemas:
        driver: AM26C31x_circuit({variant: "D"})
        receiver: AM26LS32Ax_circuit({package: "soic"})
        cmos2ttl: cmos-to-ttl()
        parasitic: parasitic()
    bom:
        SystemHead25: "c1"
        driver: "d"
        receiver: "r"
        #IfaceInput: "conn"
        CAP_thd:
            "100uF": "c2"
        Jumper_1206: "j1"
        cmos2ttl: "c3 c4 c7"
        parasitic: "c5"
        Conn:
            "1x12 2.54mm":
                "conn":
                    1: "gnd"
                    2: "vcc"
                    3: "clk"
                    4: "sync"
                    5: "y"
                    6: "x"
                    7: "y_stat"
                    8: "x_stat"
                    9: "pwm"
                    10: "en"
                    11: "pctl"
                    12: "red"
    netlist:
        gnd: "d.gnd r.gnd"
        # Interface side
        # --------------
        # driver output connections
        1: 'c1.clk- d.1z'
        2: 'c1.clk+ d.1y'
        3: 'c1.sync- d.2z'
        4: 'c1.sync+ d.2y'
        5: 'c1.x- d.3y'
        6: 'c1.x+ d.3z'
        7: 'c1.y- d.4z'
        8: 'c1.y+ d.4y'
        # status input connections
        9: 'c1.y_stat+ r.1a'
        10: 'c1.y_stat- r.1b'
        11: 'c1.x_stat+ r.2b'
        12: 'c1.x_stat- r.2a'

        # MCU side
        # ---------
        13: "conn.gnd gnd"
        vcc: "conn.vcc r.vcc d.vcc"
        # driver
        14: "conn.clk d.1a"
        15: "conn.sync d.2a"
        16: "conn.x d.3a"
        17: "conn.y d.4a"
        # receiver
        18: "conn.y_stat r.1y"
        19: "conn.x_stat r.2y"

        # Power
        # -----
        20: "vcc c2.a" # 5V
        21: "gnd c2.c"

        # Laser Head
        # ----------
        26: "gnd c1.gnd c3.gnd c4.gnd c7.gnd c5.c"
        28: "vcc c3.vcc c4.vcc c7.vcc c5.a"
        23: "conn.pwm c3.in", 27: "c3.out c1.pwm"
        24: "conn.en c4.in", 29: "c4.out c1.en"
        25: "conn.pctl c1.pctl"
        # red beam
        # (automatically turned off while laser is produced)
        32: "conn.red c7.in", 35: "c7.out c1.red"

        # Helpers
        22: "j1.1 gnd"

    #disable-drc: "unused"
    no-connect:
        'c1.z+ c1.z- c1.z_stat+ c1.z_stat- c1.+15v c1.-15v c1.pgnd c1.S'
        'r.3a r.3b r3.y r.4a r.4b r.4c'
        'd.g, d.n_g, r.3y, r.4y, r.g, r.n_g'


if __main__
    standard new Schema {
        name: 'my-circuit'
        data: galvo-head25!!
        bom: {
            # helper materials
            RefCross: '__a __b __a2 __b2'   # underline prefixes excluded from BOM
            Bolt: "3mm": "__c __d"
        }
    }

