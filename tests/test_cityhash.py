import os , sys
sys.path.append(os.getcwd())
import pytest
import fnvhash_c
import time
import sys
import random
from utils import rand_char_generator
try:
    import cityhash
except:
    import fnvhash_c as cityhash

WINFLAG = 'win' in sys.platform

@pytest.mark.asyncio
async def test_same():
    if WINFLAG:
        return True
    test_time = 1000000
    res_lst = []
    for _ in range(test_time):
        st = time.time()
        strr = str(random.randint(1000000000,9999999999))
        assert fnvhash_c.CityHash32(strr) == cityhash.CityHash32(strr)
        assert fnvhash_c.CityHash64(strr) == cityhash.CityHash64(strr)
        assert fnvhash_c.CityHash128(strr) == cityhash.CityHash128(strr)
        res_lst.append(time.time() - st)
    takes_time = sum(res_lst) * 1000000 / len(res_lst) / 6
    print("\nCityHash:")
    print(f"Run {test_time} loops for each hash takes {round(takes_time,4)}ns in average.")
