.. _quickstart:

***********
Quick Start
***********

Install fnvhash-c
=================

Supports python3.5 or later.

- Install from PyPI:

.. code-block:: 

    pip instal fnvhash-c

Basic Usage
===========

Use ``fnvhash_c.fnv1{a?}_(32|64)`` to call a hash function , which accepts a bytes type object.

Since depreciated, we only implemented the 32-bit and 64-bit versions of fnv1 and fnv1a, and did not implement fnv0.

.. code-block:: python

    import fnvhash_c
    
    print(fnvhash_c.fnv1_32(b'Hello world!'))
    print(fnvhash_c.fnv1a_32(b'Hello world!'))
    print(fnvhash_c.fnv1_64(b'Hello world!'))
    print(fnvhash_c.fnv1a_64(b'Hello world!'))

