.. module:: fnvhash-c

.. _moduleinterface:

****************
Module Interface
****************

.. function:: fnv1_32(data: bytes, hval_init: int)

    Returns the 32 bit FNV-1 hash value for the given data.

    .. note::

        ``data`` accepts bytes object only.
        
        ``hval_init`` sets the initial value of the loop algorithm,
            should input a integer which is above zero.

.. function:: fnv1a_32(data: bytes, hval_init: int)

    Returns the 32 bit FNV-1a hash value for the given data.

    .. note::

        ``data`` accepts bytes object only.
        
        ``hval_init`` sets the initial value of the loop algorithm,
            should input a integer which is above zero.

.. function:: fnv1_64(data: bytes, hval_init: int)

    Returns the 64 bit FNV-1 hash value for the given data.

    .. note::

        ``data`` accepts bytes object only.
        
        ``hval_init`` sets the initial value of the loop algorithm,
            should input a integer which is above zero.

.. function:: fnv1a_64(data: bytes, hval_init: int)

    Returns the 64 bit FNV-1a hash value for the given data.

    .. note::

        ``data`` accepts bytes object only.
        
        ``hval_init`` sets the initial value of the loop algorithm,
            should input a integer which is above zero.

.. function:: CityHash32(str)

    Returns the 32 bit CityHash value for the given data.

    .. note::

        Accepts str object only.

.. function:: CityHash64(str)

    Returns the 64 bit CityHash value for the given data.

    .. note::

        Accepts str object only.

.. function:: CityHash128(str)

    Returns the 128 bit CityHash value for the given data.

    .. note::

        Accepts str object only.
