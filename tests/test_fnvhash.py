import os , sys
sys.path.append(os.getcwd())
import pytest
import fnvhash_c
import time
from utils import rand_char_generator
from fnvhash import fnv1_32 , fnv1a_32 , fnv1_64 , fnv1a_64

@pytest.mark.asyncio
async def test_same():
    hash_store = []
    test_time = 500000
    for _ in range(test_time):
        hash_store.append(rand_char_generator())
    
    rtrue = 0
    for char in hash_store:
        if fnv1_32(char) == fnvhash_c.fnv1_32(char) and \
           fnv1a_32(char) == fnvhash_c.fnv1a_32(char) and \
           fnv1_64(char) == fnvhash_c.fnv1_64(char) and \
           fnv1a_64(char) == fnvhash_c.fnv1a_64(char):
           rtrue += 1
    assert rtrue == test_time

@pytest.mark.asyncio
async def test_time():
    print("\nExecute time test")
    test_time = 500000
    char = rand_char_generator()
    
    res_c = []
    st_time = time.time()
    for _ in range(test_time):
        fnvhash_c.fnv1_32(char)
    res_c.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnvhash_c.fnv1a_32(char)
    res_c.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnvhash_c.fnv1_64(char)
    res_c.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnvhash_c.fnv1a_64(char)
    res_c.append(time.time() - st_time)
    
    res_py = []
    st_time = time.time()
    for _ in range(test_time):
        fnv1_32(char)
    res_py.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnv1a_32(char)
    res_py.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnv1_64(char)
    res_py.append(time.time() - st_time)
    
    st_time = time.time()
    for _ in range(test_time):
        fnv1a_64(char)
    res_py.append(time.time() - st_time)
    
    assert sum(res_c) * 30 <= sum(res_py)
    for name , c , py in zip(('fnv1_32' , 'fnv1a_32' , 'fnv1_64' , 'fnv1a_64') , res_c , res_py):
        assert c * 20 <= py
        print(f"Runtime compare {name}: {round(c*1000,4)}ns / {round(py,4)}us")
