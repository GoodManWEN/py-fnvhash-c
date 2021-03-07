.. _cityhash:

********
CityHash
********

Explanation
===========
CityHash is a relatively newer hash function raised by Google, which is similar in speed to traditional hash algorithms such as fnvhash/ murmur etc. , but with a lower probability of collision

The code included is implemented in C++ by `escherba/python-cityhash <https://github.com/escherba/python-cityhash>`_ , but because the repo has not been maintained for a long time, while most of the pypi projects that can use the CityHash algorithm only support installation on linux, we integrated them into this project for better compatibility.

Usage
=====

.. code-block:: python

    from fnvhash_c import CityHash32 , CityHash64 , CityHash128
    
    # Note that due to implementation differences, cityhash accepts a str object, which is
    # different from fnvhash who accept a bytes.
    string = "hello world"
    
    print(CityHash64(string))
    
