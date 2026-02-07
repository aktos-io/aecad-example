provides class Trimpot_3296 extends PinArray
    @rev_Trimpot_3296 = 1
    (data, overrides) ->
        #https://cdn.ozdisan.com/ETicaret_Dosya/383377_1398866.pdf
        interval = 2.50mm
        dia = 1.5mm
        drill = 0.6mm
        super data, overrides `based-on` do
            pad: {drill, dia}
            rows:
                count: 3
                interval: interval
            border:
                height: 9.5mm
                width: 4.8mm


if __main__
    new Trimpot_3296