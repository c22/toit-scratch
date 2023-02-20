import gpio
import i2c
import serial

// Datasheet: http://www.everest-semi.com/pdf/ES8388%20DS.pdf

class ES8388:
    static I2C_ADDRESS ::= 0x10

    // Defaults to 0b0000_0110
    static REG_CHIP_CONTROL_1 ::= 0
    // Defaults to 0b0101_1100
    static REG_CHIP_CONTROL_2 ::= 1
    // Defaults to 0b1100_0011
    static REG_CHIP_POWER_MANAGEMENT ::= 2
    // Defaults to 0b1111_1100
    static REG_ADC_POWER_MANAGEMENT ::= 3
    // Defaults to 0b1100_0000
    static REG_DAC_POWER_MANAGEMENT ::= 4
    // Defaults to 0b1000_0000
    static REG_MASTER_MODE_CONTROL ::= 8
    // Defaults to 0b0000_0000
    static REG_ADC_CONTROL_1 ::= 9
    // Defaults to 0b0000_0000
    static REG_ADC_CONTROL_2 ::= 10
    // Defaults to 0b0000_0010
    static REG_ADC_CONTROL_3 ::= 11
    // Defaults to 0b0000_0000
    static REG_ADC_CONTROL_4 ::= 12
    // Defaults to 0b0000_0110
    static REG_ADC_CONTROL_5 ::= 13
    // Defaults to 0b1100_0000
    static REG_ADC_CONTROL_8 ::= 16
    // Defaults to 0b1100_0000
    static REG_ADC_CONTROL_9 ::= 17
    // Defaults to 0b0000_0000
    static REG_DAC_CONTROL_1 ::= 23
    // Defaults to 0b0000_0000
    static REG_DAC_CONTROL_2 ::= 24
    // Defaults to 0b0010_0010
    static REG_DAC_CONTROL_3 ::= 25
    // Defaults to 0b1100_0000
    static REG_DAC_CONTROL_4 ::= 26
    // Defaults to 0b1100_0000
    static REG_DAC_CONTROL_5 ::= 27
    // Defaults to 0b0000_0000
    static REG_DAC_CONTROL_16 ::= 38
    // Defaults to 0b0011_1000
    static REG_DAC_CONTROL_17 ::= 39
    // Defaults to 0b0011_1000
    static REG_DAC_CONTROL_20 ::= 42
    // Defaults to 0b0000_0000
    static REG_DAC_CONTROL_21 ::= 43
    // Defaults to 0b0000_0000
    static REG_DAC_CONTROL_23 ::= 45

    registers_/serial.Registers
    
    constructor device/serial.Device:
        registers_ = device.registers

    on:
        print "Initalizing ES8388 codec..."
        reg/int := ?

        // Brute force initialization that does almost exactly the same thing as:
        // https://github.com/thaaraak/es8388/blob/master/src/es8388.cpp

        print "Writing 0x$(%02X 0x04) to register $REG_DAC_CONTROL_3"
        registers_.write_u8 REG_DAC_CONTROL_3 0x04

        print "Writing 0x$(%02X 0x50) to register $REG_CHIP_CONTROL_2"
        registers_.write_u8 REG_CHIP_CONTROL_2 0x50

        print "Writing 0x$(%02X 0x00) to register $REG_CHIP_POWER_MANAGEMENT"
        registers_.write_u8 REG_CHIP_POWER_MANAGEMENT 0x00

        print "Writing 0x$(%02X 0x00) to register $REG_MASTER_MODE_CONTROL"
        registers_.write_u8 REG_MASTER_MODE_CONTROL 0x00

        print "Writing 0x$(%02X 0xC0) to register $REG_DAC_POWER_MANAGEMENT"
        registers_.write_u8 REG_DAC_POWER_MANAGEMENT 0xC0

        print "Writing 0x$(%02X 0x12) to register $REG_CHIP_CONTROL_1"
        registers_.write_u8 REG_CHIP_CONTROL_1 0x12

        print "Writing 0x$(%02X 0x18) to register $REG_DAC_CONTROL_1"
        registers_.write_u8 REG_DAC_CONTROL_1 0x18

        print "Writing 0x$(%02X 0x02) to register $REG_DAC_CONTROL_2"
        registers_.write_u8 REG_DAC_CONTROL_2 0x02

        print "Writing 0x$(%02X 0x00) to register $REG_DAC_CONTROL_16"
        registers_.write_u8 REG_DAC_CONTROL_16 0x00

        print "Writing 0x$(%02X 0x90) to register $REG_DAC_CONTROL_17"
        registers_.write_u8 REG_DAC_CONTROL_17 0x90

        print "Writing 0x$(%02X 0x90) to register $REG_DAC_CONTROL_20"
        registers_.write_u8 REG_DAC_CONTROL_20 0x90

        print "Writing 0x$(%02X 0x80) to register $REG_DAC_CONTROL_21"
        registers_.write_u8 REG_DAC_CONTROL_21 0x80

        print "Writing 0x$(%02X 0x00) to register $REG_DAC_CONTROL_23"
        registers_.write_u8 REG_DAC_CONTROL_23 0x00

        // ADC/DAC volume is controlled by a function in the reference code, here we manually set volume to MAX

        print "Writing 0x$(%02X 0x00) to register $REG_ADC_CONTROL_8"
        registers_.write_u8 REG_ADC_CONTROL_8 0x00
        print "Writing 0x$(%02X 0x00) to register $REG_ADC_CONTROL_9"
        registers_.write_u8 REG_ADC_CONTROL_9 0x00
        print "Writing 0x$(%02X 0x00) to register $REG_DAC_CONTROL_4"
        registers_.write_u8 REG_DAC_CONTROL_4 0x00
        print "Writing 0x$(%02X 0x00) to register $REG_DAC_CONTROL_5"
        registers_.write_u8 REG_DAC_CONTROL_5 0x00
        
        // Outputs are controlled by a function in the reference code, here we manually enable all outputs
        print "Writing 0x$(%02X 0x3F) to register $REG_DAC_POWER_MANAGEMENT"
        registers_.write_u8 REG_DAC_POWER_MANAGEMENT 0x3F

        print "Writing 0x$(%02X 0xFF) to register $REG_ADC_POWER_MANAGEMENT"
        registers_.write_u8 REG_ADC_POWER_MANAGEMENT 0xFF

        print "Writing 0x$(%02X 0x11) to register $REG_ADC_CONTROL_1"
        registers_.write_u8 REG_ADC_CONTROL_1 0x11

        // Inputs are controlled by a function in the reference code, here we manually enable LINPUT1 and RINPUT1 (0x00) or LINPUT2 and RINPUT2 (0x50)
        print "Writing 0x$(%02X 0x00) to register $REG_ADC_CONTROL_2"
        registers_.write_u8 REG_ADC_CONTROL_2 0x00

        print "Writing 0x$(%02X 0x02) to register $REG_ADC_CONTROL_3"
        registers_.write_u8 REG_ADC_CONTROL_3 0x02

        print "Writing 0x$(%02X 0x0d) to register $REG_ADC_CONTROL_4"
        registers_.write_u8 REG_ADC_CONTROL_4 0x0d

        print "Writing 0x$(%02X 0x02) to register $REG_ADC_CONTROL_5"
        registers_.write_u8 REG_ADC_CONTROL_5 0x02

        // ALC for Microphone

        // TODO: ADC/DAC volume (probably not relevant as we already set everything to MAX volume)

        print "Writing 0x$(%02X 0x09) to register $REG_ADC_POWER_MANAGEMENT"
        registers_.write_u8 REG_ADC_POWER_MANAGEMENT 0x09

    off:

main:
    SCL ::= gpio.Pin 23
    SDA ::= gpio.Pin 18

    bus := i2c.Bus --scl=SCL --sda=SDA

    assert: bus.test ES8388.I2C_ADDRESS

    device := bus.device ES8388.I2C_ADDRESS

    codec := ES8388 device

    codec.on
