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

# TEST_ADDR_LIMIT = 131072 / 2 # test first half of addresses (read+write = 97% BRAM)
TEST_ADDR_LIMIT = 131072 / 4  # test first quarter (read+write = half addresses = 50% BRAM)

# only test bottom bank
NUMBER_OF_TESTS = TEST_ADDR_LIMIT * 2 /ADDR_INC

print ("Number of Tests: " + str(NUMBER_OF_TESTS))

with open(OUTFILE_NAME, "w", encoding='utf-8') as f_out:

    # write to all the addresses
    random.seed(0)
    for addr in range(ADDR_LIMIT_LOW, int(TEST_ADDR_LIMIT), ADDR_INC): 
        hex_addr = f'{addr:08x}'  # string format into 0-padded 8 char hex
        
        data = (random.randint(0, RAND_MAX)) # choose random data word
        hex_data = f'{data:08x}' # string format into 0-padded 8 char hex

        f_out.writelines(hex_addr + " W " + hex_data + "\n")

    # read back from all the addresses
    random.seed(0)
    for addr in range(ADDR_LIMIT_LOW, int(TEST_ADDR_LIMIT), ADDR_INC):
        hex_addr = f'{addr:08x}'  # string format into 0-padded 8 char hex
        
        data = (random.randint(0, RAND_MAX)) # choose random data word
        hex_data = f'{data:08x}' # string format into 0-padded 8 char hex

        f_out.writelines(hex_addr + " R " + hex_data + "\n")

