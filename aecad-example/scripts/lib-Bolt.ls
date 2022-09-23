provides class Bolt extends Footprint
    create: (data) ->
        bolts =
            # drill: outer
            "3mm": 6.2mm

        drill = parse-int(@value or "3mm")
        dia = bolts["#{drill}mm"]
            or throw new Error "No such Bolt defined: #{@value}"

        new Pad {
            parent: this
            drill,
            dia
        }

if __main__
    new Bolt do
        value: "3mm"
