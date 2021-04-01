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
# cdef extern from * nogil:
#     ctypedef unsigned long int u32
#     ctypedef unsigned long long int u64

cdef unsigned long int FNV_32_PRIME = 16777619
cdef unsigned long int FNV_32_MOD = 4294967295
cdef unsigned long int FNV1_32_INIT = 2166136261
cdef unsigned long int FNV1_32A_INIT = FNV1_32_INIT

cdef unsigned long long int FNV_64_PRIME = 1099511628211
cdef unsigned long long int FNV_64_MOD = 18446744073709551615
cdef unsigned long long int FNV1_64_INIT = 14695981039346656037
cdef unsigned long long int FNV1_64A_INIT = FNV1_64_INIT

# In efficiency concern , if you'd like to modify the default capability , modify source code and rebuild it .
cdef unsigned long int L1 = 131072
cdef unsigned long int L2 = L1 - 1
cdef unsigned long int L3 = L1 >> 1
cdef unsigned long int L4 = L1 >> 3

cdef unsigned long int fnv_32(const char * data, unsigned long int lenth, unsigned long int hval_init, unsigned long int fnv_prime, unsigned long int fnv_size , unsigned long int _bias = 0)  nogil:
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned long int i
    cdef unsigned char ubyte
    cdef unsigned long int hval = hval_init
    for i in range(lenth):
        ubyte = data[i]
        hval = (hval * fnv_prime + _bias) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned long int fnva_32(const char * data, unsigned long int lenth, unsigned long int hval_init, unsigned long int fnv_prime, unsigned long int fnv_size , unsigned long int _bias = 0)  nogil:
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned long int i
    cdef unsigned char ubyte
    cdef unsigned long int hval = hval_init
    for i in range(lenth):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime + _bias) & fnv_size
    return hval

cdef unsigned long long int fnv_64(const char * data, unsigned long int lenth, unsigned long long int hval_init, unsigned long long int fnv_prime, unsigned long long int fnv_size , unsigned long long int _bias = 0)  nogil:
    """
    Core FNV hash algorithm used in FNV0 and FNV1.
    """
    cdef unsigned long int i
    cdef unsigned char ubyte
    cdef unsigned long long int hval = hval_init
    for i in range(lenth):
        ubyte = data[i]
        hval = (hval * fnv_prime + _bias) & fnv_size
        hval = hval ^ ubyte
    return hval

cdef unsigned long long int fnva_64(const char * data, unsigned long int lenth, unsigned long long int hval_init, unsigned long long int fnv_prime, unsigned long long int fnv_size , unsigned long long int _bias = 0):
    """
    Alternative FNV hash algorithm used in FNV-1a.
    """
    cdef unsigned long int i
    cdef unsigned char ubyte
    cdef unsigned long long int hval = hval_init
    for i in range(lenth):
        ubyte = data[i]
        hval = hval ^ ubyte
        hval = (hval * fnv_prime + _bias) & fnv_size
    return hval

cdef bint check_activat(char * checker , unsigned long int start_p , unsigned long int token):
    cdef unsigned long int fix = token >> 3 
    cdef unsigned char bias = 1 << (7 - (token & 7))
    cdef unsigned char target = (checker[start_p + fix] ^ 0b11111111)
    if bias == 1:
        return True
    elif (target & bias) == bias:
        return True
    else:
        return False

cdef void update_char(char * checker , unsigned long int start_p , unsigned long int token):
    cdef unsigned long int fix = token >> 3 
    cdef unsigned char bias = (1 << (7 - (token & 7))) ^ 0b11111111
    cdef unsigned char target = checker[start_p + fix] & bias
    checker[start_p + fix] = target

cdef unsigned long long int reverse_adder(const char *p , unsigned long int size):
    cdef unsigned long int i = 0;
    cdef unsigned long long int result = 0;
    for i in range(size):
        result += (<unsigned long long int>p[i]) << ((size - 1 - i) * 8)
    return result


from cpython.buffer cimport PyObject_CheckBuffer
from cpython.buffer cimport PyBUF_SIMPLE
from cpython.buffer cimport Py_buffer
from cpython.buffer cimport PyObject_GetBuffer
from cpython.buffer cimport PyBuffer_Release

from cpython.unicode cimport PyUnicode_Check
from cpython.unicode cimport PyUnicode_AsUTF8String

from cpython.bytes cimport PyBytes_Check 
from cpython.bytes cimport PyBytes_GET_SIZE 
from cpython.bytes cimport PyBytes_AS_STRING 


cpdef fnv1_32(data , unsigned long int hval_init=FNV1_32_INIT):
    """
    Returns the 32 bit FNV-1 hash value for the given data.
    """
    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long int result = 0;
    
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        result = fnv_32(<const char*>buf.buf, buf.len, hval_init, FNV_32_PRIME, FNV_32_MOD)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        result = fnv_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), hval_init, FNV_32_PRIME, FNV_32_MOD)
    else:
        raise AttributeError("Input type error, expect string or bytes")
    return result

cpdef fnv1a_32(data , unsigned long int hval_init=FNV1_32A_INIT):
    """
    Returns the 32 bit FNV-1a hash value for the given data.
    """
    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long int result = 0;
    
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        result = fnva_32(<const char*>buf.buf, buf.len, hval_init, FNV_32_PRIME, FNV_32_MOD)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        result = fnva_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), hval_init, FNV_32_PRIME, FNV_32_MOD)
    else:
        raise AttributeError("Input type error, expect string or bytes")
    return result

cpdef fnv1_64(data , unsigned long long int hval_init=FNV1_64_INIT):
    """
    Returns the 64 bit FNV-1 hash value for the given data.
    """
    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long long int result = 0;
    
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        result = fnv_64(<const char*>buf.buf, buf.len, hval_init, FNV_64_PRIME, FNV_64_MOD)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        result = fnv_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), hval_init, FNV_64_PRIME, FNV_64_MOD)
    else:
        raise AttributeError("Input type error, expect string or bytes")
    return result

cpdef fnv1a_64(data , unsigned long long int hval_init=FNV1_64A_INIT):
    """
    Returns the 64 bit FNV-1a hash value for the given data.
    """
    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long long int result = 0;
    
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        result = fnva_64(<const char*>buf.buf, buf.len, hval_init, FNV_64_PRIME, FNV_64_MOD)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        result = fnva_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), hval_init, FNV_64_PRIME, FNV_64_MOD)
    else:
        raise AttributeError("Input type error, expect string or bytes")
    return result

cpdef hit(char * checker, data):
    
    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long int star
    cdef bint a , b , c , d

    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        star = fnv_32(<const char*>buf.buf, buf.len, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
        a = check_activat(checker , 0 , star)
        star = fnva_32(<const char*>buf.buf, buf.len, FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
        b = check_activat(checker , L4 * 1 , star)
        star = fnv_64(<const char*>buf.buf, buf.len, FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
        c = check_activat(checker , L4 * 2 , star)
        star = fnva_64(<const char*>buf.buf, buf.len, FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
        d = check_activat(checker , L4 * 3 , star)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        star = fnv_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
        a = check_activat(checker , 0 , star)
        star = fnva_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
        b = check_activat(checker , L4 * 1 , star)
        star = fnv_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
        c = check_activat(checker , L4 * 2 , star)
        star = fnva_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
        d = check_activat(checker , L4 * 3 , star)
    else:
        raise AttributeError("Input type error, expect string or bytes")

    if a and b and c and d:
        return True
    return False

cpdef update(char * checker, data):

    cdef Py_buffer buf;
    cdef object obj;
    cdef long int a;
    cdef long int b;
    cdef long int c;
    cdef long int d;
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        a = fnv_32(<const char*>buf.buf, buf.len, FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
        b = fnva_32(<const char*>buf.buf, buf.len, FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
        c = fnv_64(<const char*>buf.buf, buf.len, FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
        d = fnva_64(<const char*>buf.buf, buf.len, FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        a = fnv_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_32_INIT, FNV_32_PRIME, FNV_32_MOD , 0x32) & L2
        b = fnva_32(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_32A_INIT, FNV_32_PRIME, FNV_32_MOD , 0x48) & L2
        c = fnv_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_64_INIT, FNV_64_PRIME, FNV_64_MOD , 0x96) & L2
        d = fnva_64(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data), FNV1_64A_INIT, FNV_64_PRIME, FNV_64_MOD , 0xA2) & L2
    else:
        raise AttributeError("Input type error, expect string or bytes")
    
    update_char(checker , 0 , a)
    update_char(checker , L4*1 , b)
    update_char(checker , L4*2 , c)
    update_char(checker , L4*3 , d)
    return checker[:L3]

cpdef convret_char_into_int(data):

    cdef Py_buffer buf;
    cdef object obj;
    cdef unsigned long long int result = 0;
    
    if PyUnicode_Check(data):
        obj = PyUnicode_AsUTF8String(data)
        PyObject_GetBuffer(obj, &buf, PyBUF_SIMPLE)
        if buf.len > 8:
            raise AttributeError("Input string too long")
        result = reverse_adder(<const char*>buf.buf, buf.len)
        PyBuffer_Release(&buf)
    elif PyBytes_Check(data):
        if PyBytes_GET_SIZE(data) > 8:
            raise AttributeError("Input string too long")
        result = reverse_adder(<const char*>PyBytes_AS_STRING(data), PyBytes_GET_SIZE(data))
    else:
        raise AttributeError("Input type error, expect string or bytes")
    return result

cpdef convret_int_into_char(unsigned long long int target):
    
    if target >= (1<<32):
        raise AttributeError("Too large target")
    if target <= 0:
        return b'\x00\x00\x00\x00'

    cdef char result[4];
    result[0] = <unsigned char> ((target & 0xFF000000) >> 24)
    result[1] = <unsigned char> ((target & 0x00FF0000) >> 16)
    result[2] = <unsigned char> ((target & 0x0000FF00) >> 8)
    result[3] = <unsigned char>  (target & 0x000000FF)
    return  result[:4]