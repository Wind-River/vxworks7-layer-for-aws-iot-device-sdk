# Copyright (c) 2019, Wind River Systems, Inc.
#
# MIT License
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

.PHONY: all

include common.mak

PKG_EXTRA_SRC = common.mak mk/defs.packages.mk mk/defs.crossbuild.mk mk/rules.packages.mk

CMAKE_MODULE_DIR = buildspecs/cmake

default : install_cmake_toolchain_files

install_cmake_toolchain_files :
	@if [ "$$BUILDSTAGE" = "PREBUILD" ]; then \
		echo "Installing CMake toolchain files into VSB"; \
		mkdir -p $(VSB_DIR)/$(CMAKE_MODULE_DIR)/Platform; \
		mkdir -p $(VSB_DIR)/$(CMAKE_MODULE_DIR)/Compiler; \
		cp ./$(CMAKE_MODULE_DIR)/*.cmake $(VSB_DIR)/$(CMAKE_MODULE_DIR); \
		cp ./$(CMAKE_MODULE_DIR)/Platform/*.cmake $(VSB_DIR)/$(CMAKE_MODULE_DIR)/Platform; \
		cp ./$(CMAKE_MODULE_DIR)/Compiler/*.cmake $(VSB_DIR)/$(CMAKE_MODULE_DIR)/Compiler; \
	fi

include mk/defs.packages.mk
include mk/defs.crossbuild.mk
include mk/rules.packages.mk
