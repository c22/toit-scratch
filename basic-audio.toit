import i2c
import i2s
import gpio
import . ES8388_driver

// I2C Pins

SCL ::= gpio.Pin 23
SDA ::= gpio.Pin 18

/*

I2S Pins

+----------+------+---------------------+------------------------------------------------+
| GPIO Pin | Type | Function Definition |                  Description                   |
+----------+------+---------------------+------------------------------------------------+
| IO0      | I    | I2S MCLK            | Master clock                                   |
| IO5      | I/O  | I2S SCLK            | Serial data bit clock                          |
| IO25     | I/O  | I2S LRCK            | Serial data left and right channel frame clock |
| IO26     | O    | I2S DSDIN           | DAC serial data input                          |
| IO35     | I    | I2S ASDOUT          | ADC serial data output                         |
+----------+------+---------------------+------------------------------------------------+

LRCK is referred to as word select (WS) in the I2S protocol definition

*/

SCLK ::= gpio.Pin 5
LRCK ::= gpio.Pin 25
DSDIN ::= gpio.Pin 26
ASDOUT ::= gpio.Pin 35

main:
    // Initialize codec

    i2c_bus := i2c.Bus --scl=SCL --sda=SDA --frequency=100_000
    device := i2c_bus.device ES8388.I2C_ADDRESS
    codec := ES8388 device
    codec.on

    // Initialize I2S bus

    i2s_bus := i2s.Bus --sck=SCLK --ws=LRCK --tx=DSDIN --rx=ASDOUT --sample_rate=44100 --bits_per_sample=16 --buffer_size=32
    n := 255

    n.repeat:
        bytes := i2s_bus.read
        print "Writing $(bytes.size) bytes"
        print "$bytes"
        i2s_bus.write bytes
