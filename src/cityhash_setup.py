from distutils.core import setup , Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext
CXXFLAGS = []
INCLUDE_DIRS = ['include']
CMDCLASS = {}
EXT_MODULES = []
EXT_MODULES.append(
    Extension("cityhash", ["city.cc", "cityhash.pyx"],
              language="c++",
              extra_compile_args=CXXFLAGS,
              include_dirs=INCLUDE_DIRS)
)
CMDCLASS['build_ext'] = build_ext
setup(
    cmdclass=CMDCLASS,
    ext_modules = cythonize(
        EXT_MODULES
    )
)