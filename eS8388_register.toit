import serial show Registers

// Datasheet: http://www.everest-semi.com/pdf/ES8388%20DS.pdf

abstract class Es8388Register:
    // Fields
    registers_/Registers
    address_/int
    default-value_/int := 0b0
    friendly-name_/string := ""

    // Constructors
    constructor registers/Registers address/int friendly-name/string default-value/int:
      registers_ = registers
      address_ = address
      friendly-name_ = friendly-name
      default-value_ = default-value
    
    constructor registers/Registers address/int:
      registers_ = registers
      this.address_ = address
    
    // Getters
    address -> int:
      return address_
    
    default-value -> int:
      return default-value_

    friendly-name -> string:
      return friendly-name_

    // Methods
    read -> int:
      return registers_.read-u8 address_
    
    write value/int -> none:
      registers_.write-u8 address_ value
    
    enable-bit-at-offset offset/int -> none:
      assert: 0 <= offset <= 7
      write (1 << offset)
    
    disable-bit-at-offset offset/int -> none:
      assert: 0 <= offset <= 7
      write ~(1 << offset)
    
    read-value-from-bit-range offset/int length/int -> int:
      assert: 0 <= offset <= 7
      assert: 0 < length <= offset + 1
      return (read >> offset) & ((1 << length) - 1)
    
    write-value-to-bit-range offset/int length/int value/int -> none:
      assert: 0 <= offset <= 7
      assert: 0 < length <= offset + 1
      assert: 0 <= value <= (1 << length) - 1
    
      current-value := read
      write (current-value & ~((current-value >> offset) & ((1 << length) - 1) << offset) | (value << offset)) 

class ChipControl1 extends Es8388Register:
  constructor registers/Registers:
    super registers 0 "Chip Control 1" 0b0000_0110

class ChipControl2 extends Es8388Register:
  constructor registers/Registers:
    super registers 1 "Chip Control 2" 0b0101_1100

class ChipPowerManagement extends Es8388Register:
  constructor registers/Registers:
    super registers 2 "Chip Power Management" 0b1100_0011

class AdcPowerManagement extends Es8388Register:
  constructor registers/Registers:
    super registers 3 "ADC Power Management" 0b1111_1100

class DacPowerManagement extends Es8388Register:
  constructor registers/Registers:
    super registers 4 "DAC Power Management" 0b1100_0000

class MasterModeControl extends Es8388Register:
  constructor registers/Registers:
    super registers 8 "Master Mode Control" 0b1000_0000

class AdcControl1 extends Es8388Register:
  constructor registers/Registers:
    super registers 9 "ADC Control 1" 0b0000_0000

class AdcControl2 extends Es8388Register:
  constructor registers/Registers:
    super registers 10 "ADC Control 2" 0b0000_0000

class AdcControl3 extends Es8388Register:
  constructor registers/Registers:
    super registers 11 "ADC Control 3" 0b0000_0010

class AdcControl4 extends Es8388Register:
  constructor registers/Registers:
    super registers 12 "ADC Control 4" 0b0000_0000

class AdcControl5 extends Es8388Register:
  constructor registers/Registers:
    super registers 13 "ADC Control 5" 0b0000_0110

class AdcControl8 extends Es8388Register:
  constructor registers/Registers:
    super registers 16 "ADC Control 8" 0b1100_0000

class AdcControl9 extends Es8388Register:
  constructor registers/Registers:
    super registers 17 "ADC Control 9" 0b1100_0000

class DacControl1 extends Es8388Register:
  constructor registers/Registers:
    super registers 23 "DAC Control 1" 0b0000_0000

class DacControl2 extends Es8388Register:
  constructor registers/Registers:
    super registers 24 "DAC Control 2" 0b0000_0000

class DacControl3 extends Es8388Register:
  constructor registers/Registers:
    super registers 25 "DAC Control 3" 0b0010_0010

class DacControl4 extends Es8388Register:
  constructor registers/Registers:
    super registers 26 "DAC Control 4" 0b1100_0000

class DacControl5 extends Es8388Register:
  constructor registers/Registers:
    super registers 27 "DAC Control 5" 0b1100_0000

class DacControl16 extends Es8388Register:
  constructor registers/Registers:
    super registers 38 "DAC Control 16" 0b0000_0000

class DacControl17 extends Es8388Register:
  constructor registers/Registers:
    super registers 39 "DAC Control 17" 0b0011_1000

class DacControl20 extends Es8388Register:
  constructor registers/Registers:
    super registers 42 "DAC Control 20" 0b0011_1000

class DacControl21 extends Es8388Register:
  constructor registers/Registers:
    super registers 43 "DAC Control 21" 0b0000_0000

class DacControl23 extends Es8388Register:
  constructor registers/Registers:
    super registers 45 "DAC Control 23" 0b0000_0000

class DacControl30 extends Es8388Register:
  constructor registers/Registers:
    super registers 52 "DAC Control 30" 0b1010_1010
