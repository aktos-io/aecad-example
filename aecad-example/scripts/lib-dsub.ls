#! reaquires DoublePinArray

add-class class D__S13A6GV00LF extends Footprint
    create: (data) ->
        pad =
            drill: 0.9mm
            dia: 1.9mm
        interval = 2.74mm
        distance = data.distance or (1.27mm * 2)

        A =
            9: 30.81mm
            15: 39.14mm
            25: 53.03mm

        B =
            9: 24.99mm
            15: 33.32mm
            25: 47.04mm

        D =
            9: 16.21mm
            15: 24.54mm
            25: 38.25mm

        p = pin-count = data.pin-count or 15
        @iface = data.labels or [1 to pin-count]

        body =
            height: A[p]
            width: 14.65mm

        # create Anchor pads
        anchor =
            drill: 3.10mm
            dia: 5mm
            pin: 'S'

        @iface-add anchor.pin, anchor.pin

        a = 1 + (pin-count - 1)/2
        b = (pin-count - 1)/2

        parent = data.parent or this

        new DoublePinArray do
            parent: parent
            name: 'c_'
            distance: distance
            left:
                pad: pad
                rows:
                    count: a
                    interval: interval
                cols:
                    count: 1
            right:
                pad: pad
                start: a + 1
                rows:
                    count: b
                    interval: interval

            labels: data.labels
            allow-duplicate-labels: yes

        middle = interval * b/2
        middle-vertical = distance/2
        new Pad ({parent} <<< anchor)
            ..pos-x += distance/2
            ..pos-y += middle - B[p]/2

        new Pad ({parent} <<< anchor)
            ..pos-x += distance/2
            ..pos-y += middle + B[p]/2

        # body
        @make-border border:
            centered: no
            width: body.width
            height: body.height
            offset-y: middle - body.height/2
            offset-x: + middle-vertical - (body.width - 11.67mm)

        # socket part
        @make-border border:
            width: 6.17mm
            height: D[p]
            offset-x: body.width - 4.2mm

add-class class D09S13A6GV00LF extends D__S13A6GV00LF
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 9

add-class class D15S13A6GV00LF extends D__S13A6GV00LF
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 15

add-class class D25S13A6GV00LF extends D__S13A6GV00LF
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 25

provides class Dsub_9_Vertical extends D__S13A6GV00LF
    # Possible models:
    # * L-KLS1-221C-09-F-L
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 9
            distance: 2.840mm

provides class Dsub_15_Vertical extends Dsub_9_Vertical
    # Possible models:
    # * DS1034-15FUNSISS
    (data, overrides) ->
        super data, overrides `based-on` do
            pin-count: 15


if __main__
    standard new Schema do
        name: "example"
        data:
            bom:
                D09S13A6GV00LF: "c1"
                D15S13A6GV00LF: "c2"
                D25S13A6GV00LF: "c3"
                Dsub_9_Vertical: "c4"
                Dsub_15_Vertical: "c5"
            disable-drc: "unused"
