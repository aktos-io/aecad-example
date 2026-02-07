#! requires PinArray


# --------------------------------------------------
# all lib* scripts will be included automatically.
#
# This script will also be treated as a library file.
# --------------------------------------------------
add-class class Jumper_1206 extends SMD1206
    @rev_Jumper_1206 = 1
    (data, overrides) ->
        super data, overrides `based-on` do
            allow-duplicate-labels: yes
            labels:
                1: 1
                2: 1
            interconnected-pins: "1"

add-class class TestBoundary extends PinArray
    # Creates two pads that can be connected via
    # a drop of solder
    # Parameter string:
    # {height}x{width}mm <- sets the pad width and height
    # or
    # {height}mm <- sets the pad width = height/2
    @rev_TestBoundary = 1
    (data, overrides) ->
        pad =
            width: 0.2mm
            height: 0.5mm

        if data.value?.match /([\d]+)x?([\d]*)mm/
            pad.height = +(that.1)
            pad.width = +(that.2 or pad.height/2)

        super data, overrides `based-on` do
            pad: pad
            cols:
                count: 2
                interval: pad.width + 0.1mm
            rows:
                count: 1
            dir: 'x'
            labels:
                1: 1
                2: 1
            allow-duplicate-labels: yes
            is-virtual: yes # do not include into BOM list
            interconnected-pins: "1"

if __main__
    sch = standard new Schema {
        data:
            iface: []
            bom:
                #Jumper_1206_WRONG_DESIGN: "c1 c2 c3"
                Jumper_1206: "c1 c2"
                TestBoundary:
                    "8mm": "c3"
            netlist:
                1: "c1.1 c2.1 c3.1"
        }

    console.log "connection list:", sch.connectionList
    console.log "connection states:", sch._connection_states

