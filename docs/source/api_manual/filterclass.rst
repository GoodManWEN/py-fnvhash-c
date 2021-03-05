.. _filterclass:

******************
BloomFilter Object
******************

.. data:: token
    
    Check out the token byte string.

.. method:: __init__(self , capability:int = 4096):

    Sets the initial value of the blacklist load capacity.
    Needs to recompile your self if changed, to keep c-plugin works fine.

.. method:: hit(self , char:bytes) -> bool:

    Check if a byte string is in the blacklist.

.. method:: update(self , char:bytes) -> None:

    Put a byte string  into the blacklist.
    
.. method:: refresh(self) -> None:

    Reset the blacklist to empty.
