import os , sys
sys.path.append(os.getcwd())
import pytest
from fnvhash-c import *

@pytest.mark.asyncio
async def test_import():
    ...