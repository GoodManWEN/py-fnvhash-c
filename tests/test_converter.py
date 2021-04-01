import os , sys
sys.path.append(os.getcwd())
import pytest
import fnvhash_c
import time

@pytest.mark.asyncio
async def test_convert():
    assert fnvhash_c.convert_char_into_int(b'123\x00a') == fnvhash_c.convert_char_into_int('123\x00a') == 211295600737
    try:
        fnvhash_c.convert_char_into_int('123456789')
    except Exception as e:
        assert isinstance(e , AttributeError)

    assert fnvhash_c.convert_int_into_char(825373440) == b'123\x00'

    assert fnvhash_c.convert_char_into_int(b'\x84\x8d1}') == 2223845757
    assert fnvhash_c.convert_int_into_char(2223845757) == b'\x84\x8d1}'