#! requires PinArray

# Example: See SOT223

# Usage
# --------------------
# data:
#   dimple: {x, y}: creates the dimple circle
add-class class DoublePinArray extends Footprint
    create: (data) ->
        overwrites =
            parent: data.parent or this
            labels: data.labels

        left = new PinArray data.left <<< overwrites
        right = new PinArray data.right <<< overwrites

        iface = {}
        for num, label of left.iface
            iface[num] = label
        for num, label of right.iface
            iface[num] = label
        @iface = iface

        right.position = left.position.add [data.distance |> mm2px, 0]
        @make-border data

        if data.dimple
            @make-border do
                border:
                    dia: data.dimple.dia or 0.5mm
                    centered: no
                    offset-x:~ -> data.dimple.x
                    offset-y:~ -> data.dimple.y



