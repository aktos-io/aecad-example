# depends: D15S13A6GV00LF


provides class GalvoHead15 extends D15S13A6GV00LF
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                1: 'clk-'
                9: 'clk+'
                2: 'sync-'
                10: 'sync+'
                3: 'x-'
                11: 'x+'
                4: 'y-'
                12: 'y+'
                # nc
                5: 'nc'
                13: 'nc'
                6: 'nc'
                14: 'nc'
                7: 'nc'
                15: 'nc'
                8: 'nc'

provides class GalvoHead15_v2 extends GalvoHead15
    (data, overrides) ->
        super data, overrides `based-on` do
            labels:
                5: 'y_stat-'
                13: 'y_stat+'
                6: 'x_stat-'
                14: 'x_stat+'

galvo-head = (config) -> (value) -> # provides:this
    iface: []
    bom:
        GalvoHead15_v2: "c1"
        Max485_SO8: "clk sync x y"
        Conn:
            "1x6 2.54mm": "conn1"
        SMD1206:
            "120ohm": "s1 s2 s3 s4" # stub resistors
    netlist:
        "3.3v": """clk.vcc sync.vcc x.vcc y.vcc
            clk.de sync.de x.de y.de
            clk.N_re sync.N_re x.N_re y.N_re
            conn1.6
            """
        "gnd": """clk.gnd sync.gnd x.gnd y.gnd
            conn1.1
            """
        1: 'c1.clk- clk.A s1.1'
        2: 'c1.clk+ clk.B s1.2'
        3: 'c1.sync- sync.A s2.1'
        4: 'c1.sync+ sync.B s2.2'
        5: 'c1.x- x.A s3.1'
        6: 'c1.x+ x.B s3.2'
        7: 'c1.y- y.A s4.1'
        8: 'c1.y+ y.B s4.2'
        9: 'clk.di conn1.2'
        10: 'sync.di conn1.3'
        11: 'x.di conn1.4'
        12: 'y.di conn1.5'
    no-connect:
        "clk.ro sync.ro x.ro y.ro"
        "c1.S c1.nc"
        "c1.y_stat-, c1.x_stat-, c1.y_stat+, c1.x_stat+"

if __main__
    standard new Schema do
        data: galvo-head!!
        bom:
            # helper materials
            RefCross: '__a __b'   # underline prefixes excluded from BOM
            Bolt: "3mm": "__c __d"
