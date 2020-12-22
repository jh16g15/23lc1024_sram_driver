# cmd_mem_gen.py

# This script takes in a text file with the following format:

#  Address  R/W   Data
# 0x00000000 W 0xDABEEEFE
# 0x00000000 R 
 
# And converts it into a .hex file for use in a VHDL/Verilog memory

# This can then be read out by a "traffic generator" sort of thing thta

# default to 32-bit addresses and data (pad if necessary)

import sys
import argparse

# argument parsing
# https://docs.python.org/3/howto/argparse.html
# https://docs.python.org/3/library/argparse.html#module-argparse
# useful options:
#   help=""                 Sets the "-h" help message
#   type=int                Sets the type of the argument
#   action="store_true"     Makes the argument into a flag
#   action="count"          Adds 1 for every occurence (eg -v -v)
#   choices=[8,32,64]       List of allowable values
#   default=0               Sets the default value 


parser = argparse.ArgumentParser(description="Creates a .hex memory file from a list of commands in a text file")

parser.add_argument("--address_width",  "-aw",  type=int,   default=32,         help="Set the Address Width (in bits)")
parser.add_argument("--data_width",     "-dw",  type=int,   default=32,         help="Set the Data Width (in bits)")
parser.add_argument("--script_file",    "-i",   type=str,   default="cmds.txt", help="Input txt file")
parser.add_argument("--hex_file",       "-o",   type=str,   default="cmds.hex", help="output hex file")
args = parser.parse_args()

print(f"Running cmd_mem_gen.py...")
print(f"Address Width : {args.address_width}")
print(f"Data Width    : {args.data_width}")
print(f"Script File   : {args.script_file}")
print(f"Hex File      : {args.hex_file}")

with open(args.script_file, "r", encoding='utf-8') as f_in:
    with open(args.hex_file, "w", encoding='utf-8') as f_out:
        for line in f_in:
            # print(f"Line: {line}")
            if line[0] != "#":  # ignore comments
                # remove leading/trailing whitespace, remove underscore separaters and then split into substrings
                cmd = line.strip(" ").replace("_", "").upper().split()
                if len(cmd) != 0:   # ignore empty lines
                    # hex format
                    #  
                    # 4-bit R/W (only 1st bit used) 32-bit address 32-bit Data
                
                    cmd_hex = []
                    
                    # Command Type
                    if cmd[1] == "R":
                        print("=========== READ =============")
                        cmd_hex.append("0")
                    elif cmd[1] == "W":
                        print("=========== WRITE ============")
                        cmd_hex.append("1")
                    else:
                        raise ValueError(f"Unrecognised cmd type {cmd[1]}")
                    print(f"with type:{cmd_hex}")
                    
                    # Address
                    print(f"raw_addr: {cmd[0]}")
                    addr = cmd[0].replace("0X", "") # remove 0x prefix if present
                    cmd_hex.append(addr)
                    print(f"with addr:{cmd_hex}")

                    # Data (if present)
                    

                    if len(cmd) == 3:
                        print(f"raw_data: {cmd[2]}")
                        data = cmd[2].replace("0X", "") # remove 0x prefix if present
                    else:
                        data = "00000000"
                    cmd_hex.append(data)
                    
                    print(f"with data:{cmd_hex}")
                    # Join all together and send to output file
                    cmd_hex.append("\n")
                    empty_string=""
                    f_out.writelines(empty_string.join(cmd_hex))
                    