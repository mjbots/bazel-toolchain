# Copyright 2020 The Bazel Authors.
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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def bazel_toolchain_dependencies():
    # Load rules_cc if the user has not defined them.
    if not native.existing_rule("rules_cc"):
        http_archive(
            name = "rules_cc",
            sha256 = "b6f34b3261ec02f85dbc5a8bdc9414ce548e1f5f67e000d7069571799cb88b25",
            strip_prefix = "rules_cc-726dd8157557f1456b3656e26ab21a1646653405",
            urls = ["https://github.com/bazelbuild/rules_cc/archive/726dd8157557f1456b3656e26ab21a1646653405.tar.gz"],
        )
    if not native.existing_rule("org_llvm_libcxx"):
        http_archive(
            name = "org_llvm_libcxx",
            urls = [
                "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/libcxx-10.0.0.src.tar.xz",
            ],
            sha256 = "270f8a3f176f1981b0f6ab8aa556720988872ec2b48ed3b605d0ced8d09156c7",
            strip_prefix = "libcxx-10.0.0.src",
            build_file = Label("//toolchain/internal:libcxx.BUILD"),
        )
    if not native.existing_rule("org_llvm_libcxxabi"):
        http_archive(
            name = "org_llvm_libcxxabi",
            urls = [
                "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/libcxxabi-10.0.0.src.tar.xz",
            ],
            sha256 = "e71bac75a88c9dde455ad3f2a2b449bf745eafd41d2d8432253b2964e0ca14e1",
            strip_prefix = "libcxxabi-10.0.0.src",
            build_file = Label("//toolchain/internal:libcxxabi.BUILD"),
        )
