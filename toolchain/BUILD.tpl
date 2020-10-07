# Copyright 2018 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package(default_visibility = ["//visibility:public"])

load("@rules_cc//cc:defs.bzl", "cc_toolchain_suite")

exports_files(["Makevars"])

# Some targets may need to directly depend on these files.
exports_files(glob(["bin/*", "lib/*"]))

filegroup(
    name = "empty",
    srcs = [],
)

filegroup(
    name = "cc_wrapper",
    srcs = ["bin/cc_wrapper.sh"],
)

filegroup(
    name = "sysroot_components",
    srcs = [%{sysroot_label}],
)

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|clang": ":cc-clang-linux",
        "darwin|clang": ":cc-clang-darwin",
        "x64_windows|clang": "cc-clang-windows",
        "k8": ":cc-clang-linux",
        "darwin": ":cc-clang-darwin",
        "x64_windows": "cc-clang-windows",
    },
)

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

cc_toolchain_config(
    name = "local_linux",
    cpu = "k8",
)

cc_toolchain_config(
    name = "local_darwin",
    cpu = "darwin",
)

cc_toolchain_config(
    name = "local_windows",
    cpu = "x64_windows",
)

toolchain(
    name = "cc-toolchain-darwin",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:osx",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:osx",
    ],
    toolchain = ":cc-clang-darwin",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-linux",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    toolchain = ":cc-clang-linux",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-windows",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-clang-windows",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "conditional_cc_toolchain")

conditional_cc_toolchain("cc-clang-linux", "linux", %{absolute_paths})
conditional_cc_toolchain("cc-clang-darwin", "darwin", %{absolute_paths})
conditional_cc_toolchain("cc-clang-windows", "windows", %{absolute_paths})

## LLVM toolchain files
# Needed when not using absolute paths.

filegroup(
    name = "clang",
    srcs = glob([
        "bin/clang",
        "bin/clang.exe",
        "bin/clang++",
        "bin/clang++.exe",
        "bin/clang-cpp",
        "bin/clang-cpp.exe",
    ]),
)

filegroup(
    name = "ld",
    srcs = glob([
        "bin/ld.lld",
        "bin/ld.lld.exe",
        "bin/ld",
        "bin/ld.exe",
        "bin/ld.gold",  # Dummy file on non-linux.
    ]),
)

filegroup(
    name = "include",
    srcs = glob([
        "include/c++/**",
        "lib/clang/%{llvm_version}/include/**",
    ]),
)

filegroup(
    name = "lib",
    srcs = glob(
        [
            "lib/lib*.a",
            "lib/clang/%{llvm_version}/lib/**/*.a",
        ],
        exclude = [
            "lib/libLLVM*.a",
            "lib/libclang*.a",
            "lib/liblld*.a",
        ],
    ),
)

filegroup(
    name = "compiler_components",
    srcs = [
        ":clang",
        ":include",
        ":sysroot_components",
    ],
)

filegroup(
    name = "ar",
    srcs = glob(["bin/llvm-ar", "bin/llvm-ar.exe"]),
)

filegroup(
    name = "as",
    srcs = glob([
        "bin/clang",
        "bin/clang.exe",
        "bin/llvm-as",
        "bin/llvm-as.exe",
    ]),
)

filegroup(
    name = "nm",
    srcs = glob(["bin/llvm-nm", "bin/llvm-nm.exe"]),
)

filegroup(
    name = "objcopy",
    srcs = glob(["bin/llvm-objcopy", "bin/llvm-objcopy.exe"]),
)

filegroup(
    name = "objdump",
    srcs = glob(["bin/llvm-objdump", "bin/llvm-objdump.exe"]),
)

filegroup(
    name = "profdata",
    srcs = glob(["bin/llvm-profdata", "bin/llvm-profdata.exe"]),
)

filegroup(
    name = "dwp",
    srcs = glob(["bin/llvm-dwp", "bin/llvm-dwp.exe"]),
)

filegroup(
    name = "ranlib",
    srcs = glob(["bin/llvm-ranlib", "bin/llvm-ranlib.exe"]),
)

filegroup(
    name = "readelf",
    srcs = glob(["bin/llvm-readelf", "bin/llvm-readelf.exe"]),
)

filegroup(
    name = "binutils_components",
    srcs = glob(["bin/*"]),
)

filegroup(
    name = "linker_components",
    srcs = [
        ":clang",
        ":ld",
        ":ar",
        ":lib",
        ":sysroot_components",
    ],
)

filegroup(
    name = "all_components",
    srcs = [
        ":binutils_components",
        ":compiler_components",
        ":linker_components",
    ],
)
