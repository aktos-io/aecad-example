# --------------------------------------------------
# Use "# depends: foo" for dependencies
# Use "foo = # provides:this" for manual provisions
# --------------------------------------------------



damla-plast-pano =
    bom:
        "15V güç kaynağı": "p1, p2"
        "5V güç kaynağı": "p5v"
        "24V güç kaynağı": "p24v"
        "PLC": "plc"
        "PT100 modülü": "c2"
        "Galvo kontrol kartı": "cc"
        "Galvo kontrol klemens kartı": "c4"
        "Omron-RS232 kablosu": "c5"

    terminals:
        "220V giriş": "3 pin, -> 5 noktaya gidecek"
        "+-15V (Galvo güç)": "3 pin"
        "Lazer 220V çıkış": "3 pin"
        "PT-100": "3 pin"
        "Trigger input": "2 pin"

    cables:
        "Galvo kontrol + galvo güç"
        "Lazer kontrol"
        "Trigger input"
        "Ethernet"
        "Pt-100"
        "220V giriş"
        "Lazer 220V besleme (çıkış)"

    iface:
        "Power_in.L": "x1.1"
        "Power_in.N": "x1.2"
        "Power_in.GND": "x1.3"


    netlist:
        "5v+": "p5v.+ cc.5v_+"
        "5v-": "p5v.- cc.5v_gnd"
        "24v+": "p24v.+ plc.+"
        "24v-": "p24v.- plc.-"

        "2": "x1.1 ps.1 laser.1"
        "blue": "x1.2 x2.2"
        "yellow": "x1.3"

        "red": "ps.2"
        "1": "laser.2 x2.1"

        "15v+": "x3.1"
        "0v": "x3.2"
        "15v-": "x3.3"
        "out2": "x3.4"
        "out1": "x3.5"
        "pt100-3": "x3.6"
        "pt100-2": "x3.7"
        "pt100-1": "x3.8"
        "trg2": "x3.9 cc.i0_+"      # Trigger device.Vcc
        "trg1": "x3.10 cc.i0_-"     # Trigger device.Vout

        "3": "plc.in_comm 24v-"

        "in1": "cc.q0_- plc.in_0"
        "in2": "cc.q0_+ plc.+"

        "TS101.1_loopB(1)": "pt100-1"
        "TS101.1_loopB(2)": "pt100-2"
        "TS101.1_loopA": "pt100-"

        "c5.OMRON": "plc.COMM(1)"
        "c5.RS232": "cc.RS232"




