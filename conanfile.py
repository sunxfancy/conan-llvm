from conans import ConanFile, CMake
from conans.tools import download, unzip, untargz
import os, platform

class LlvmConan(ConanFile):
    name = 'llvm'
    version = '3.8.1'
    url = 'https://github.com/sunxfancy/conan-llvm.git'
    license = 'BSD'
    settings = 'os', 'compiler', 'build_type', 'arch'
    exports = '*'
    options = {'shared': [True, False]}
    default_options = 'shared=True'

    archiveName = 'llvm-3.8.1.src.tar.xz'
    folderName = 'llvm-3.8.1.src'

    def extractFromUrl(self, url):
        self.output.info('download {}'.format(url))
        filename = os.path.basename(url)
        download(url, filename)
        untargz(filename)
        os.unlink(filename)
        
    def source(self):
        url = 'http://llvm.org/releases/'+self.version+'/'+self.archiveName
        self.extractFromUrl(url)

    def build(self):
        cmake = CMake(self)
        srcDir = os.path.join(self.source_folder, self.folderName)
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
                        build_folder='./build', source_folder=srcDir)

        self.output.info('Building...')
        cmake.build()
        self.output.info('Installing...')
        cmake.install()

    def conan_info(self):
        self.info.settings.build_type = 'Release'

    def package(self):
        self.copy('*', dst='', src='install')
