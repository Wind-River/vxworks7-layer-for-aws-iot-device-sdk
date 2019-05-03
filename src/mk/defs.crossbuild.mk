# Makefile fragment for defs.crossbuild.mk
#
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

# --host and --build intentionally left to autodetect
CONFIGURE_DEPENDS = $(VXWORKS_ENV_SH) $(AUTO_INCLUDE_VSB_CONFIG_QUOTE) $(__AUTO_INCLUDE_LIST_UFILE) | $(TOOL_OPTIONS_FILES_ALL)

CONFIGURE_OPT = \
	--build=x86_64-pc-linux-gnu \
        --host=$(C_ARCH)-wrs-vxworks \
	--prefix= \
	--bindir=/$(TOOL_SPECIFIC_DIR)/bin \
	--libdir=/$(TOOL_COMMON_DIR) \
	--includedir=/include


MAKE_INSTALL_OPT = install DESTDIR=$(ROOT_DIR)
CMAKE_TOOLCHAIN_FILE = -DCMAKE_TOOLCHAIN_FILE=$(VSB_DIR)/buildspecs/cmake/rtp.cmake

