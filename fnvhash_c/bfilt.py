from .fnvlib import *

class BloomFilter:

    def __init__(self , capability:int = 4096):
        '''
        capability:int = 4096 by default
            means 8192 result posibility for each hashfunc,
            needs 1024 chars to represent ,
            total 4096 chars of full token.
        '''
        self._capability = capability
        self._token : bytes = b'\xFE' * capability

    def hit(self , char:bytes) -> bool:
        return hit(self._token , char)

    def update(self, char:bytes) -> None:
        update(self._token , char)
    
    def refresh(self) -> None:
        self._token = b'\xFE' * self._capability

    @property
    def token(self) -> bytes:
        return self._token
