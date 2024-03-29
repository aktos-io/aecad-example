/* data format:

circular pad:
    dia: 1.5mm
    drill: 0.6mm

rectangular pad:
    width: 3.1mm
    height: 1.5mm

*/


add-class class PinArray extends Footprint
    create: (data) ->
        #console.log "Creating from scratch PinArray"
        start = data.start or 1
        unless data.cols
            data.cols = {count: 1}
        unless data.rows
            data.rows = {count: 1}

        iface = {}
        for cindex to data.cols.count - 1
            for rindex to data.rows.count - 1
                pin-num = start + switch (data.dir or 'x')
                    | 'x' =>
                        cindex + rindex * data.cols.count
                    | '-x' =>
                        data.cols.count - 1 - cindex + rindex * data.cols.count
                    | 'y' =>
                        rindex + cindex * data.rows.count
                    | '-y' =>
                        data.rows.count - 1 - rindex + cindex * data.rows.count

                iface[pin-num] = if data.labels
                    if pin-num of data.labels
                        data.labels[pin-num]
                    else
                        console.error "PinArray labels:", data.labels
                        throw new Error "PinArray: Undeclared label for iface: #{pin-num}
                            (labels: #{JSON.stringify data.labels})"
                else
                    pin-num

                p = new Pad data.pad <<< do
                    pin: pin-num
                    label: iface[pin-num]
                    parent: this

                p.position.y += (data.rows.interval or 0 |> mm2px) * rindex
                p.position.x += (data.cols.interval or 0 |> mm2px) * cindex

        @iface = iface

        if data.mirror
            # useful for female headers
            @mirror!

        border = if data.border is "default"
            width: @mbounds.width + 0.4mm
            height: @mbounds.height + 0.4mm
        else
            data.border


        @make-border {border}
