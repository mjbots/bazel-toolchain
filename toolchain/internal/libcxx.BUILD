# -*- python -*-

# Copyright 2019 Josh Pieper, jjp@pobox.com.
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

filegroup(
    name = "raw_headers",
    srcs = glob(["include/**"]),
)

cc_library(
    name = "headers",
    hdrs = [":raw_headers"],
)

cc_library(
    name = "libcxx",
    hdrs = glob(["include/**"]),
    srcs = glob([
        "src/*.cpp",
        "src/include/*.h",
        "filesystem/*.cpp",
        "filesystem/*.h",
    ]) + select({
        "@bazel_tools//src/conditions:windows": [
            "src/support/win32/locale_win32.cpp",
            "src/support/win32/support.cpp",
            "src/support/win32/thread_win32.cpp",
        ],
        "//conditions:default": [],
    }),
    textual_hdrs = glob([
        "src/support/runtime/**",
    ]),
    copts = [
        "-Iexternal/org_llvm_libcxx/src/include",
        "-Iexternal/org_llvm_libcxx/src",
        "-D_LIBCPP_BUILDING_LIBRARY",
        "-D_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER",
        "-DLIBCXX_CXX_ABI=vcruntime",
        "-DNDEBUG",
        "-fvisibility-inlines-hidden",
    ],
    includes = ["include"],
    deps = [
        ":headers",
    ],
)
