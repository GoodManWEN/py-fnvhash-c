# distutils: language=c++
import cython
from libc.string cimport strlen
from libc.string cimport memset
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

# In efficiency concern , if you'd like to modify the default capability , modify source code and rebuild it .
cdef unsigned int L1 = 8192
cdef unsigned int L2 = L1 - 1
cdef unsigned int L3 = L1 >> 1
cdef unsigned int L4 = L1 >> 3

cdef unsigned int fnv_32(char * data, unsigned int hval_init, unsigned int fnv_prime, unsigned int fnv_size , unsigned int _bias = 0)  nogil:
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned int hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = (hval * fnv_prime + _bias) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned int fnva_32(char * data, unsigned int hval_init, unsigned int fnv_prime, unsigned int fnv_size , unsigned int _bias = 0)  nogil:
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned int hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime + _bias) & fnv_size
    return hval

cdef unsigned long long fnv_64(char * data, unsigned long long hval_init, unsigned long long fnv_prime, unsigned long long fnv_size , unsigned long long _bias = 0)  nogil:
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned long long hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = (hval * fnv_prime + _bias) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned long long fnva_64(char * data, unsigned long long hval_init, unsigned long long fnv_prime, unsigned long long fnv_size , unsigned long long _bias = 0) nogil:
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned int i
    cdef unsigned char ubyte
    cdef unsigned long long hval = hval_init
    for i in range(strlen(data)):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime + _bias) & fnv_size
    return hval

cdef bint check_activat(char * checker , unsigned int start_p , unsigned int token):
    cdef unsigned int fix = token >> 3 
    cdef unsigned char bias = 1 << (7 - (token & 7))
    cdef unsigned char target = (checker[start_p + fix] ^ 0b11111111)
    if bias == 1:
        return True
    elif (target & bias) == bias:
        return True
    else:
        return False

cdef void update_char(char * checker , unsigned int start_p , unsigned int token):
    cdef unsigned int fix = token >> 3 
    cdef unsigned char bias = (1 << (7 - (token & 7))) ^ 0b11111111
    cdef unsigned char target = checker[start_p + fix] & bias
    if target == 0:
        target = 1
    checker[start_p + fix] = target

def fnv1_32(char * data , unsigned int hval_init=FNV1_32_INIT):
    """
    Returns the 32 bit FNV-1 hash value for the given data.
    """
    return fnv_32(data, hval_init, FNV_32_PRIME, FNV_32_MOD)

def fnv1a_32(char * data , unsigned int hval_init=FNV1_32A_INIT):
    """
    Returns the 32 bit FNV-1a hash value for the given data.
    """
    return fnva_32(data, hval_init, FNV_32_PRIME, FNV_32_MOD)

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

def hit(char * checker , char * data):
    '''
    Check out if the input string hits the bloom filter checer.
    If returns True , means that hit occur , thre's chance data in blacklist.
    '''
    cdef unsigned int length_c = strlen(checker)
    if length_c != L3:
        return True
    cdef unsigned int star
    cdef bint a , b , c , d
    star = fnv_32(data, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
    a = check_activat(checker , 0 , star)
    star = fnva_32(data, FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
    b = check_activat(checker , L4 * 1 , star)
    star = fnv_64(data, FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
    c = check_activat(checker , L4 * 2 , star)
    star = fnva_64(data, FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
    d = check_activat(checker , L4 * 3 , star)
    if a and b and c and d:
        return True
    return False

def update(char * checker , char * data , ):
    '''
    Basic Bloom Filter update function.
    '''
    cdef unsigned int length_c = strlen(checker)
    if length_c != L3:
        raise ValueError(f'Not allow checker less than {L3}')
    a = fnv_32(data, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
    b = fnva_32(data, FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
    c = fnv_64(data, FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
    d = fnva_64(data, FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
    update_char(checker , 0 , a)
    update_char(checker , L4*1 , b)
    update_char(checker , L4*2 , c)
    update_char(checker , L4*3 , d)
    return checker