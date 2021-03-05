import os , sys
sys.path.append(os.getcwd())
import pytest
from fnvhash_c import *
from utils import rand_char_generator

@pytest.mark.asyncio
async def test_blank():
    center = BloomFilter()
    test_time = 1000000
       
    # empty flt fapability
    rtrue = 0
    rfalse = 0
    for _ in range(test_time):
        if center.hit(rand_char_generator()):
            rtrue += 1
        else:
            rfalse += 1
    assert rtrue <= (0.05 * test_time)
    print('passed!')
    
def assert_check(center , pre_update , red_line):
    hash_store = []
    for _ in range(pre_update):
        rchar = rand_char_generator()
        hash_store.append(rchar)
        center.update(rchar)
        
    test_time = 1000000
    rtrue = 0
    rfalse = 0
    for _ in range(test_time):
        if center.hit(rand_char_generator()):
            rtrue += 1
        else:
            rfalse += 1
    assert rtrue <= (red_line * test_time)
    
    print(f"capability: {pre_update}, test time: {test_time}, hit: {rtrue}, miss: {rfalse}, hitrate: {round(rtrue * 100 / test_time,2)}")
    rtrue = 0
    rfalse = 0
    for char in hash_store:
        if center.hit(char):
            rtrue += 1
        else:
            rfalse += 1
    assert rtrue == len(hash_store)
    
    
@pytest.mark.asyncio
async def test_flt():
    print('\nBloom Filter test:')
    center = BloomFilter()
    assert_check(center , 2000 , 0.05)
    center.refresh()
    assert_check(center , 10000 , 0.45)
    center.refresh()
    assert_check(center , 20000 , 0.9)
    center.refresh()
    assert_check(center , 30000 , 0.95)
    center.refresh()
