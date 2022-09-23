# Description: Quadruple TIA-422 driver
# depends: SOIC16
# Value: "{{variant}}" or "{{package}}"

# Stub resistors should be placed near the last receiver
# https://electronics.stackexchange.com/q/474756/20285

provides class AM26C31x extends Footprint
    @rev_AM26C31x = 2
    create: (data) ->
        variants =
            "16pin":
                J: "CDIP"
                N: "PDIP"
                NS: "SO"
                W: "CFP"
                D: "SOIC"
                DB: "SSOP"
                PW: "TSSOP"
            "20pin":
                FK: "LCCC"

        labels =
            "16pin":
                1: "1a" # input
                2: "1y" # output
                3: "1z" # inverted output
                4: "g"  # active high enable
                5: "2z"
                6: "2y"
                7: "2a"
                8: "gnd"
                9: "3a"
                10: "3y"
                11: "3z"
                12: "n_g" # active low enable
                13: "4z"
                14: "4y"
                15: "4a"
                16: "vcc"

        footprint = variants["16pin"][@value]
            or variants["20pin"][@value]

        parent = data.parent or this

        switch footprint
        | "SOIC" =>
            x = new SOIC16 {
                parent,
                labels: labels["16pin"]
            }
            @iface = x.iface

        |_ =>
            throw new Error "Unimplemented
                variant (#{@value}) in #{@@@name}"


AM26C31x_circuit = (config) ->
    # config:
    #   variant: AM26C31x variant
    (value) ->
        iface: "c1.1a,c1.1y,c1.1z,c1.2z,
            c1.2y,c1.2a,c1.3a,c1.3y,c1.3z,
            c1.4z,c1.4y,c1.4a c1.vcc c1.gnd,
            c1.g c1.n_g"

        netlist:
            "vcc": "c1.vcc c2.a"
            "gnd": "c1.gnd c2.c c1.g c1.n_g"

        bom:
            AM26C31x:
                "#{config.variant}": "c1"
            C1206:
                "100nF": "c2"

if __main__
    example =
        iface: "+5v gnd A1 B1"
        schemas:
            AM26C31D_std: AM26C31x_circuit({variant: "D"})
        bom:
            AM26C31D_std: "c1"
        netlist:
            "+5v": "c1.vcc"
            "gnd": "c1.gnd"
            "A1": "c1.1y"
            "B1": "c1.1z"
        no-connect: "c1.1a,c1.g,c1.2z,c1.2y,c1.2a,c1.3a,c1.3y,c1.3z,c1.n_g,c1.4z,c1.4y,c1.4a"

    standard new Schema do
        data: example
