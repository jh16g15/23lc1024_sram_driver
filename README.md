# 23lc1024_sram_driver
SPI Driver for 23LC1024 1Mbit Serial SRAM chip, for Artix-7. Implementation for Digilent BASYS-3 board (Artix-7 35T).

This is a HDL controller to interface with a Microchip 8-pin Serial SPI SRAM (23LCxxxx) in SQI Quad mode.

After reset, the RSTIO command is sent to the SRAM to move it into SPI Extended mode. This is followed by the EQIO command to move the SRAM chip into Quad mode, using 4 biderectional pins to transfer commmands and data.

After this initial setup, the SRAM controller can then take commands through a standard ready-valid handshake of commands and responses. At this time, only 32-bit data transfers are supported.

An example Master for this interface is provided: axis_cmd_driver. It is designed to run test commands generated using cmd_mem_gen.py, which converts commands in a simple text based format into hex to be loaded into a VHDL memory.

This controller has been tested at speeds up to 22MHz with a 23LC1024 before errors appear, however this does require some static timing failures to be waived (especially with CS# Hold times, which is fine as it changes infrequently).

