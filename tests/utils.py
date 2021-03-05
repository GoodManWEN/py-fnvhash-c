import random

def rand_char_generator():
    char = f"{str(random.randint(1000000000,9999999999))}salt"
    char = f"{chr(random.randint(1,127))}{char}{chr(random.randint(0xFF00,0xFFEF))}{chr(random.randint(0x4E00,0x9FA5))}".encode()
    return char
