# Description: Quadruple Differential Line Receivers
# depends: SOIC16, TSSOP_16
# Value: "{{variant}}" or "{{package}}"
provides class AM26LS32Ax extends Footprint
    @rev_AM26LS32Ax = 3
    create: (data) ->
        # Value
        # -----------
        # There are multiple packages available for
        # the same code, so package type should be
        # passed on initialization
        #
        # @value: one of "soic, pdip, so, tssop, cdip, lccc"

        switch @value
        | <[ soic pdip so tssop cdip ]> =>
            pin-count = 16

            Package = switch @value
            | \soic => SOIC16
            | \tssop => TSSOP_16
            |_ => ...

            labels =
                1: "1b" # RS422 diff input (inverting)
                2: "1a" # RS422 diff input (noninverting)
                3: "1y" # logic level output
                4: "g"  # active high enable
                5: "2y"
                6: "2a"
                7: "2b"
                8: "gnd"
                9: "3b"
                10: "3a"
                11: "3y"
                12: "n_g" # active low enable
                13: "4y"
                14: "4a"
                15: "4b"
                16: "vcc"

        | <[ lccc ]> =>
            pin-count = 20
            ...
        |_ => ...

        x = new Package {parent: (data.parent or this), labels}
        @iface = x.iface

AM26LS32Ax_circuit = (config) -> # provides this
    # config:
    #   package: AM26LS32Ax package
    #   TODO: tip: false
    (value) ->
        iface: "
            c1.1a, c1.1b, c1.1y,
            c1.2a, c1.2b, c1.2y,
            c1.3a, c1.3b, c1.3y,
            c1.4a, c1.4b, c1.4y,
            c1.vcc, c1.gnd"
        netlist:
            "vcc": "c1.vcc c2.a"
            "gnd": "c1.gnd c2.c  c1.g c1.n_g"
            # stub resistors
            1: "c1.1a r1.1"
            2: "c1.1b r1.2"
            3: "c1.2a r2.1"
            4: "c1.2b r2.2"
            5: "c1.3a r3.1"
            6: "c1.3b r3.2"
            7: "c1.4a r4.1"
            8: "c1.4b r4.2"
        bom:
            AM26LS32Ax:
                "#{config.package}": "c1"
            C1206:
                "100nF": "c2"
            R1206:
                "120ohm": "r1 r2 r3 r4" # terminal resistors

if __main__
    example =
        iface: "+3v3 gnd A1 B1"
        schemas:
            AM26LS32AC_std: AM26LS32Ax_circuit({package: "soic"})
        bom:
            AM26LS32AC_std: "c1"
        netlist:
            "+3v3": "c1.vcc"
            "gnd": "c1.gnd"
            "A1": "c1.1a"
            "B1": "c1.1b"
        no-connect: "c1.1y, c1.2a, c1.2b, c1.2y, c1.3a, c1.3b, c1.3y, c1.4a, c1.4b, c1.4y, c1.g, c1.n_g"

    standard new Schema do
        #data: AM26LS32Ax_circuit({package: 'soic'})()
        data: example
