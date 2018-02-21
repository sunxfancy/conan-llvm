from conans import ConanFile, CMake
from conans.tools import download, unzip
import os, platform

class LlvmConan(ConanFile):
    name = 'llvm'
    version = '5.0.1'
    url = 'https://github.com/sunxfancy/conan-llvm.git'
    license = 'BSD'
    settings = 'os', 'compiler', 'build_type', 'arch'
    exports = '*'
    options = {'shared': [True, False]}
    default_options = 'shared=True', "gtest:shared=False"

    folderName = 'llvm-release_50'
    requires = 'gtest/1.8.0@lasote/stable'
    build_policy = "missing"
    generators = "cmake"

    def extractFromUrl(self, url):
        self.output.info('download {}'.format(url))
        filename = os.path.basename(url)
        download(url, filename)
        unzip(filename)
        os.unlink(filename)
        
    def source(self):
        url = 'https://github.com/llvm-mirror/llvm/archive/release_50.zip'
        self.extractFromUrl(url)

    def build(self):
        cmake = CMake(self)
        installDir = os.path.join(self.source_folder, 'install')
        sharedLibs = 'ON' if self.options.shared else 'OFF'
        self.output.info('Configuring CMake...')
        if not os.path.exists('build'):
            os.mkdir('build')
        cmake.configure(['-Wno-dev',
                        '-DCMAKE_INSTALL_PREFIX={}'.format(installDir),
                        '-DLIBCXX_INCLUDE_TESTS=OFF',
                        '-DLIBCXX_INCLUDE_DOCS=OFF',
                        '-DLLVM_INCLUDE_TOOLS=ON',
                        '-DLLVM_INCLUDE_TESTS=OFF',
                        '-DLLVM_INCLUDE_EXAMPLES=OFF',
                        '-DLLVM_INCLUDE_GO_TESTS=OFF',
                        '-DLLVM_BUILD_TOOLS=ON',
                        '-DLLVM_BUILD_TESTS=OFF',
                        '-DLLVM_TARGETS_TO_BUILD=X86',
                        '-DBUILD_SHARED_LIBS={}'.format(sharedLibs)],
                        build_folder='./build', source_folder=self.source_folder)

        self.output.info('Building...')
        cmake.build()
        self.output.info('Installing...')
        cmake.install()

    def conan_info(self):
        self.info.settings.build_type = 'Release'

    def package(self):
        self.copy('*', dst='', src='install')
