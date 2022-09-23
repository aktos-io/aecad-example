# depends: PinArray

dia-ratio = 2.1    # a practical value
drill-map =
    # pitch, drill
    * 2.54mm, 0.9mm
    * 3.81mm, 1.2mm

provides class Conn extends Footprint
    @rev_Conn = 1
    create: (data) ->
        try
            # Value syntax
            value-regex = //
                ([0-9]+)x([0-9]+)   # {row_count}x{column_count}
                \s+                 # split with space
                ([0-9]\.[0-9]+)mm   # Pitch: float number + 'mm' postfix
                \s*(.*)             # Extra arguments
                //

            if data.value?.match value-regex
                rows = Number that.1
                columns = Number that.2
                pitch = Number that.3
                args = that.4
                if args?.match /smd/
                    pad =
                        width: pitch * 1.1
                        height: pitch / 2.5
                else
                    drill = [..1 for drill-map when ..0 is pitch].0
                    unless drill? => ...
                    pad =
                        drill: drill
                        dia: drill * dia-ratio
            else
                ...
        catch
            throw new Error \
                "No available #{@@@name} for: #{@value} #{e}"

        x = new PinArray do
            parent: this
            pad: pad
            cols:
                count: rows
                interval: pitch
            rows:
                count: columns
                interval: pitch
            dir: 'x'
            labels: data.labels
        @iface = x.iface


provides class Phoenix_MC extends Conn
    (data, overrides) ->
        # From FreeCAD-Assembly3-Library/models/phoenix
        value-regex = /^MC-1.5_([0-9]+)-G-([0-9\.]+).*/

        value = if data.value.match value-regex
            pin-count = that.1
            pitch = that.2
            "1x#{pin-count} #{pitch}mm"

        super data, overrides `based-on` {value}

provides class DG142V_5_08_XXP extends Footprint
    (data, overrides) ->
        super data, overrides `based-on` {
            +allow-duplicate-labels
        }

    create: (data) ->
        value-regex = /^([0-9]+)\s[tT]erminal(s)?/

        columns = if data.value.match value-regex
            that.1
        else if data.pin-count
            that
        else
            10

        labels = {}
        for i in [0 to columns]
            label = data.labels?[i+1] or i+1
            labels[2*i + 1] = label
            labels[2*i + 2] = label

        x = new PinArray do
            parent: this
            pad:
                drill: 1.3mm
                dia: 1.3mm * 2
            cols:
                count: 2
                interval: 7.62mm
            rows:
                count: columns
                interval: 5.08mm
            dir: 'x'
            labels: labels
            allow-duplicate-labels: data.allow-duplicate-labels

        @iface = x.iface


if __main__
    standard new Schema {
        data:
            iface: []
            bom:
                Conn:
                    "1x2 2.54mm": "c1"
                    "2x4 2.54mm": "c2"
                    "1x8 2.54mm smd": "c3"
                Phoenix_MC:
                    "MC-1.5_2-G-3.81": "c4"
                DG142V_5_08_XXP:
                    "6 terminals":
                        "c5":
                            1: "a"
                            2: "b"
                            3: "c"
                            4: "d"
                            5: "e"
                            6: "f"
            disable-drc: "unused"
        }

