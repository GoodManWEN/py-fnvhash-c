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
