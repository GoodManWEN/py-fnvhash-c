.. _bloomfilter:

************
Bloom Filter
************

Built Inside Filter
===================
A simple bloom filter built inside , which uses a slightly different parameter than the default value to keep result diverse. Ultra fast to use for state less authentication.

Usage
-----

.. code-block:: python

    import fnvhash_c
    
    # Create a manager who take cares of blacklist
    manager = fnvahsh_c.BloomFilter()
    
    random_char_generator = lambda : f"{random.randint(1000000000,9999999999)}+salt".encode()
    
    # To verify if the string is in the blacklist , the method accepts a bytes
    print(manager.hit(random_char_generator())) # -> False
    
    # Put a bytes into blacklist
    nogo = random_char_generator()
    manager.update(nogo)
    print(manager.hit(nogo)) # -> True

Further explanation
-------

According to the principle of Bloom Filter, we can only ensure that the bytes that is already in the blacklist is hit 100%, but we cannot ensure that the bytes that is not in the blacklist not hit at all.

To ensure the diversity of the hash results, the parameters of the fnvhash function used in Bloom Filter are slightly different than defaults, which does not show up in normal use if no special attention is paid to it.

To reduce runtime calculations, the load capacity (65536 bytes by default, who performs idely when the number of items in blacklists is less than 100k) has been compiled into the plugin as a constant. If you want to change the default values, you need to re-compile them yourself from the source file.

You can check out [this link](https://hur.st/bloomfilter/) for further descreption of Bloom Filter, and use the online tool to calculate how large the capacity you should set to achieve the best efficiency in your own use case.
    
