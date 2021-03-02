# distutils: language=c++
import cython
from libc.string cimport strlen

'''
Author: WEN(https://github.com/GoodManWEN/py-fnvhash-c)

A simple cython implementation of fnvhash, to give you an alternative choice 
when you need a high speed hash in python, with code structure referenced to
https://github.com/znerol/py-fnvhash
'''

cdef unsigned int FNV_32_PRIME = 16777619
cdef unsigned int FNV_32_MOD = 4294967295
cdef unsigned int FNV1_32_INIT = 2166136261
cdef unsigned int FNV1_32A_INIT = FNV1_32_INIT

cdef unsigned long long FNV_64_PRIME = 1099511628211
cdef unsigned long long FNV_64_MOD = 18446744073709551615
cdef unsigned long long FNV1_64_INIT = 14695981039346656037
cdef unsigned long long FNV1_64A_INIT = FNV1_64_INIT

cdef unsigned int fnv_32(char * data, unsigned int hval_init, unsigned int fnv_prime, unsigned int fnv_size):
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned int hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = (hval * fnv_prime) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned int fnva_32(char * data, unsigned int hval_init, unsigned int fnv_prime, unsigned int fnv_size):
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned int hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime) & fnv_size
    return hval

cdef unsigned long long fnv_64(char * data, unsigned long long hval_init, unsigned long long fnv_prime, unsigned long long fnv_size):
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned long long hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = (hval * fnv_prime) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned long long fnva_64(char * data, unsigned long long hval_init, unsigned long long fnv_prime, unsigned long long fnv_size):
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned long long hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime) & fnv_size
    return hval

def fnv1_32(char * data , unsigned int hval_init=FNV1_32_INIT):
    """
    Returns the 32 bit FNV-1 hash value for the given data.
    """
    return fnv_32(data, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD)

def fnv1a_32(char * data , unsigned int hval_init=FNV1_32A_INIT):
    """
    Returns the 32 bit FNV-1a hash value for the given data.
    """
    return fnva_32(data, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD)

def fnv1_64(char * data , unsigned long long hval_init=FNV1_64_INIT):
    """
    Returns the 64 bit FNV-1 hash value for the given data.
    """
    return fnv_64(data, hval_init, FNV_64_PRIME, FNV_64_MOD)

def fnv1a_64(char * data , unsigned long long hval_init=FNV1_64A_INIT):
    """
    Returns the 64 bit FNV-1a hash value for the given data.
    """
    return fnva_64(data, hval_init, FNV_64_PRIME, FNV_64_MOD)