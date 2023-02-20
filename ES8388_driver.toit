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
    static REG_ADC_CONTROL_2 ::= 10

    // Defaults to 0b0000_0000
    static REG_ADC_CONTROL_4 ::= 12

    // Defaults to 0b0010_0010
    static REG_DAC_CONTROL3 ::= 25

    registers_/serial.Registers
    
    constructor device/serial.Device:
        registers_ = device.registers

    on:
        reg/int := ?
        // Set PdnAna (entire analog power down) off
        // Set PdnIbiasgen (ibiasgen power down) off
        reg = registers_.read_u8 REG_CHIP_CONTROL_2
        reg &= ~0b0000_1100
        registers_.write_u8 REG_CHIP_CONTROL_2 reg

        // Set all chip power management states to 0 (power up/normal)
        registers_.write_u8 REG_CHIP_POWER_MANAGEMENT 0x0

        /*
         Set PdnAINL (left analog input power down) off
         Set PdnAINR (right analog input power down) off
         Set PdnADCL (left ADC power down) off
         Set PdnADCR (right ADC power down) off
         Set PdnADCBiasgen (Biasgen power down) off
        */
        reg = registers_.read_u8 REG_ADC_POWER_MANAGEMENT
        reg &= ~0b1111_0100
        registers_.write_u8 REG_ADC_POWER_MANAGEMENT reg

        /*
         Set PdnDACL (left DAC power down) off
         Set PdnDACR (right DAC power down) off
         Set LOUT1 (left output 1) on
         Set ROUT1 (right output 1) on
         Set LOUT2 (left output 2) on
         Set ROUT2 (right output 2) on
        */
        reg = registers_.read_u8 REG_DAC_POWER_MANAGEMENT
        reg &= ~0b1111_1100
        reg |= 0b0011_1100
        registers_.write_u8 REG_DAC_POWER_MANAGEMENT reg

        // Set slave serial port mode
        reg = registers_.read_u8 REG_MASTER_MODE_CONTROL
        reg &= ~0b1000_0000
        print "Writing 0x$(%02x reg) to register $REG_MASTER_MODE_CONTROL"
        registers_.write_u8 REG_MASTER_MODE_CONTROL reg

        // Set ADCWL (ADC word length) to 16-bits
        reg = registers_.read_u8 REG_ADC_CONTROL_4
        reg &= ~0b0001_1100
        reg |= 0b0000_1100
        registers_.write_u8 REG_ADC_CONTROL_4 reg

    off:

main:
    SCL ::= gpio.Pin 23
    SDA ::= gpio.Pin 18

    bus := i2c.Bus --scl=SCL --sda=SDA

    assert: bus.test ES8388.I2C_ADDRESS

    device := bus.device ES8388.I2C_ADDRESS

    codec := ES8388 device

    codec.on
