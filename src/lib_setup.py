from distutils.core import setup , Extension
from Cython.Build import cythonize

extensions = [
    Extension(
        "fnvlib",
        sources=['lib.pyx'],
    )
]

setup(
    ext_modules = cythonize(
        extensions
    )
)

# CLI referrence: 
# python cython_plugin_cdi_setup.py build_ext --inplace
# cython cython_plugin_cdi.pyx -a