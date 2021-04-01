from .fnvlib import *

class BloomFilter:

    def __init__(self , capability:int = 65536):
        '''
        capability:int = 65536 by default
            means 131072 result posibility for each hashfunc,
            needs 16384 chars to represent ,
            total 65536 chars of full token.
        '''
        self._capability = capability
        self._token : bytes = b'\xFF' * capability

    def hit(self , char:bytes) -> bool:
        return hit(self._token , char)

    def update(self, char:bytes) -> None:
        update(self._token , char)
    
    def refresh(self) -> None:
        self._token = b'\xFF' * self._capability

    @property
    def token(self) -> bytes:
        return self._token
