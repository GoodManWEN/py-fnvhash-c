from .fnvlib import *

class BloomFilter:

    def __init__(self , capability:int = 8192):
        '''
        capability:int = 8192 by default
            means 8192 result posibility for each hashfunc,
            needs 1024 chars to represent ,
            total 4096 chars of full token.
        '''
        self._token = b'0xFE' * capability

    def hit(self , char):
        return hit(self._token , char)

    def update(self, char):
        update(self._token , char)

    @property
    def token(self):
        return self._token