from conans import ConanFile, CMake
from conans.tools import download, unzip
import os, platform

class LlvmConan(ConanFile):
    name = 'llvm'
    version = '4.0.1'
    url = 'https://github.com/sunxfancy/conan-llvm.git'
    license = 'BSD'
    settings = 'os', 'compiler', 'build_type', 'arch'
    exports = '*'
    options = {
        'shared': [True, False],
        'enable_rtti': [True, False],
        'build_tools': [True, False],
        'enable_pic': [True, False],
        'enable_threads': [True, False]
    }
    default_options = (
        'shared=True', 
        'enable_rtti=True',
        'build_tools=True',
        'enable_pic=True',
        'enable_threads=True',
        'gtest:shared=False'
    )
        
    folderName = 'llvm-release_40'
    requires = 'gtest/1.8.0@sunxfancy/stable'
    build_policy = "missing"
    generators = "cmake"

    def extractFromUrl(self, url):
        self.output.info('download {}'.format(url))
        filename = os.path.basename(url)
        download(url, filename)
        unzip(filename)
        os.unlink(filename)
        
    def source(self):
        url = 'https://github.com/llvm-mirror/llvm/archive/release_40.zip'
        self.extractFromUrl(url)

    def build(self):
        cmake = CMake(self)
        self.output.info('Configuring CMake...')
        if not os.path.exists('build'):
            os.mkdir('build')

        options = {
            'LIBCXX_INCLUDE_TESTS': False,
            'LIBCXX_INCLUDE_DOCS': False,
            'LLVM_INCLUDE_TOOLS': self.options.build_tools,
            'LLVM_INCLUDE_TESTS': False,
            'LLVM_INCLUDE_EXAMPLES': False,
            'LLVM_INCLUDE_GO_TESTS': False,
            'LLVM_BUILD_TOOLS': self.options.build_tools,
            'LLVM_ENABLE_PIC': self.options.enable_pic,
            'LLVM_ENABLE_RTTI': self.options.enable_rtti,
            'LLVM_ENABLE_THREADS': self.options.enable_threads,
            'LLVM_BUILD_TESTS': False,
            'LLVM_TARGETS_TO_BUILD': 'X86',
            'BUILD_SHARED_LIBS': self.options.shared
        }
        cmake.configure(['-Wno-dev'], defs=options,
                        build_folder='./build', source_folder=self.source_folder)

        self.output.info('Building...')
        cmake.build()
        self.output.info('Installing...')
        cmake.install()

    def conan_info(self):
        self.info.settings.build_type = 'Release'

