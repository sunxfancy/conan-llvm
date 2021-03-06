[![Build Status](https://travis-ci.org/sunxfancy/conan-llvm.svg?branch=v3.8)](https://travis-ci.org/sunxfancy/conan-llvm)
[![Build status](https://ci.appveyor.com/api/projects/status/jtwfr4ymwc6173qq/branch/v3.8?svg=true)](https://ci.appveyor.com/project/sunxfancy/conan-llvm/branch/v3.8)

## conan-llvm
[Conan.io](https://conan.io) package for LLVM.

Thanks for [lasote](https://github.com/lasote) for providing example on building this package. 
Thanks for [lucteo](https://github.com/lucteo) for creating the framework of this conan library.

## Build packages

    $ pip install conan_package_tools
    $ python build.py
    
## Upload packages to server

    $ conan upload llvm/3.8.1@sunxfancy/stable --all
    
## Reuse the packages

### Basic setup

    $ conan install llvm/3.8.1@sunxfancy/stable
    
### Project setup

If you handle multiple dependencies in your project is better to add a *conanfile.txt*
    
    [requires]
    llvm/3.8.1@sunxfancy/stable

    [generators]
    txt
    cmake

Complete the installation of requirements for your project running:</small></span>

    conan install . 

Project setup installs the library (and all his dependencies) and generates the files *conanbuildinfo.txt*.
