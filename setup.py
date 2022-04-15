from setuptools import setup, find_packages, Distribution
from requests import get as rget
from bs4 import BeautifulSoup
import logging , sys
# init logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
sh = logging.StreamHandler(stream=sys.stdout) 
format = logging.Formatter("%(message)s")#("%(asctime)s - %(message)s") 
sh.setFormatter(format)
logger.addHandler(sh)

#
def get_install_requires(filename):
    with open(filename,'r') as f:
        lines = f.readlines()
    return [x.strip() for x in lines]


# 
url = 'https://github.com/GoodManWEN/py-fnvhash-c'
release = f'{url}/releases/latest'
headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36",
    "Connection": "keep-alive",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
    "Accept-Language": "zh-CN,zh;q=0.8"
}

html = BeautifulSoup(rget(url , headers).text ,'lxml')
description = html.find('meta' ,{'name':'description'}).get('content')
for kw in (' - GitHub', ' - GoodManWEN'):
    if ' - GitHub' in description:
        description = description[:description.index(' - GitHub')]
logger.info(f"description: {description}")

#
with open('tagname','r',encoding='utf-8') as f:
    version = f.read()
if ':' in version:
    version = version[:version.index(':')].strip()
version = version.strip()
logger.info(f"version: {version}")


#
with open('README.md','r',encoding='utf-8') as f:
    long_description_lines = f.readlines()

long_description_lines_copy = long_description_lines[:]
long_description_lines_copy.insert(0,'r"""\n')
long_description_lines_copy.append('"""\n')

# update __init__ docs
with open('fnvhash_c/__init__.py','r',encoding='utf-8') as f:
    init_content = f.readlines()

for line in init_content:
    if line == "__version__ = ''\n":
        long_description_lines_copy.append(f"__version__ = '{version}'\n")
    else:
        long_description_lines_copy.append(line)

with open('fnvhash_c/__init__.py','w',encoding='utf-8') as f:
    f.writelines(long_description_lines_copy)
    
import os
for files in os.walk(os.path.join(os.path.abspath('.') , 'fnvhash_c')):
    files = files[2];break
files = list(filter(lambda x:os.path.splitext(x)[1] in ['.so','.pyd'] , files))

class BinaryDistribution(Distribution):
    def has_ext_modules(foo):
        return True

setup(
    version=version,
    description=description,
    packages = find_packages(),
    package_data={
        'fnvhash_c': files,
    },
    distclass=BinaryDistribution,
    install_requires = get_install_requires('requirements.txt'),
    keywords=["fnvhash-c" , "fnvhash" , "hash" , "fnv"],
)
