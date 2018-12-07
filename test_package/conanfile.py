from conans import ConanFile, CMake
import os

############### CONFIGURE THESE VALUES ##################
default_user = "sunxfancy"
default_channel = "ci"
#########################################################

channel = os.getenv("CONAN_CHANNEL", default_channel)
username = os.getenv("CONAN_USERNAME", default_user)

class TestLlvmConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    requires = "llvm/7.0.0@%s/%s" % (username, channel)
    generators = "cmake"

    def build(self):
        cmake = CMake(self)
        self.output.info("Running CMake")
        cmake.configure()
        self.output.info("Building the llvm test project")
        cmake.build()

    def imports(self):
        self.copy(pattern="*.dll", dst="bin", src="bin")
        self.copy(pattern="*.dylib", dst="bin", src="lib")
        self.copy(pattern="*.so*", dst="bin", src="lib")
        self.copy(pattern="*", dst="bin", src="bin")
        
    def test(self):
        pass
