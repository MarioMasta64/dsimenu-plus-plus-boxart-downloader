#Made By Larsenv
#https://github.com/Larsenv/

import binascii
import sys

if len(sys.argv) != 5:
    print("Usage: readbytes.py <start offset> <end offset> <input> <output>")
    sys.exit(1)

def main():
    with open(sys.argv[3], "rb") as source_file:
        read = source_file.read()

    with open(sys.argv[4], "wb") as dest_file:
        dest_file.write(read[int(sys.argv[1], 16):int(sys.argv[2], 16)])

main()