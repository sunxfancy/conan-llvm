#!/usr/bin/python
from conan.packager import ConanMultiPackager
import platform, os

if __name__ == "__main__":
    # mingw_configurations = [("4.9", "x86_64", "seh", "posix"),
    #                         ("4.9", "x86_64", "sjlj", "posix"),
    #                         ("4.9", "x86", "sjlj", "posix"),
    #                         ("4.9", "x86", "dwarf2", "posix")]
    # builder = ConanMultiPackager(username='sunxfancy', mingw_configurations=mingw_configurations)
    builder = ConanMultiPackager(username='sunxfancy', args="--build missing")

    builder.add_common_builds()

    # Keep only Release builds
    filtered_builds = []
    for settings, options, env_vars, build_requires, reference in builder.items:
        if settings["build_type"] == "Release":
            filtered_builds.append([settings, options, env_vars, build_requires])
    builder.builds = filtered_builds

    builder.run()
