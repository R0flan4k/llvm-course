from conan import ConanFile
from conan.tools.cmake import cmake_layout


class MinesConan(ConanFile):
    name = "mines"
    version = "0.1.0"
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeToolchain", "CMakeDeps"

    def layout(self):
        cmake_layout(self)

    def requirements(self):
        self.requires("sdl/2.32.10")