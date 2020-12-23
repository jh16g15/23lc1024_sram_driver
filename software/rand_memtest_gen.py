# random memtest 

import random
import sys


# This test writes random values to SRAM addresses, and then reads them back again
#  
#

# TESTS_TO_GENERATE = 256
OUTFILE_NAME = "rand_test_cmds.txt"


ADDR_LIMIT_LOW = 0
ADDR_LIMIT_HIGH = 131072    # 17 bit address
ADDR_INC = 4                # 4 bytes per address

RAND_MAX = 4294967295

NUMBER_OF_TESTS = ADDR_LIMIT_HIGH /4

print ("Number of Tests: " + str(NUMBER_OF_TESTS))

with open(OUTFILE_NAME, "w", encoding='utf-8') as f_out:

    
    

    # write to all the addresses
    random.seed(0)
    for addr in range(ADDR_LIMIT_LOW, ADDR_LIMIT_HIGH, ADDR_INC): 
        hex_addr = f'{addr:08x}'  # string format into 0-padded 8 char hex
        
        data = (random.randint(0, RAND_MAX)) # choose random data word
        hex_data = f'{data:08x}' # string format into 0-padded 8 char hex

        f_out.writelines(hex_addr + " W " + hex_data + "\n")

    # read back from all the addresses
    random.seed(0)
    for addr in range(ADDR_LIMIT_LOW, ADDR_LIMIT_HIGH, ADDR_INC):
        hex_addr = f'{addr:08x}'  # string format into 0-padded 8 char hex
        
        data = (random.randint(0, RAND_MAX)) # choose random data word
        hex_data = f'{data:08x}' # string format into 0-padded 8 char hex

        f_out.writelines(hex_addr + " R " + hex_data + "\n")

