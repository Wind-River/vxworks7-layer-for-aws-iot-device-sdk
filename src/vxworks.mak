# Copyright (c) 2019 Wind River Systems, Inc.
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

.PHONY: default

include common.mak

ADDED_LIBS += -lunix -lnet -lHASH -lOPENSSL
ADDED_CFLAGS += -isystem${VSB_DIR}/usr/h/published/UTILS

CMAKE_OPT += -DIOT_BUILD_TESTS:BOOL=OFF
CMAKE_OPT += -DBUILD_SHARED_LIBS:BOOL=OFF

include defs.packages.mk
include defs.crossbuild.mk
include rules.packages.mk

default: $(AUTO_INCLUDE_VSB_CONFIG_QUOTE) $(__AUTO_INCLUDE_LIST_UFILE) | $(TOOL_OPTIONS_FILES_ALL)

$(PKG_NAME).configure : $(CONFIGURE_DEPENDS) $(PKG_NAME).patch
	@$(call echo_action,Configuring,$(PKG_NAME))
	if [ -n "$(VXWORKS_ENV_SH)" ] && \
	    [ -f $(VXWORKS_ENV_SH) ]; then \
	        sed -ie 's/--as-needed//' $(VXWORKS_ENV_SH); \
	fi ; \
	$(call pkg_configure,$(PKG_NAME))
	@$(MAKE_STAMP)

$(PKG_NAME).build : $(PKG_NAME).configure
	@$(call echo_action,Building,$(PKG_NAME))
	if [ -n "$(VXWORKS_ENV_SH)" ] && \
	   [ -f $(VXWORKS_ENV_SH) ]; then \
	       . ./$(VXWORKS_ENV_SH); \
	fi ; \
	$(call pkg_build,$(PKG_NAME))
	@$(MAKE_STAMP)

$(PKG_NAME).install : $(PKG_NAME).build
	@$(call echo_action,Installing,$(PKG_NAME))
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/platform/source/posix/libiotplatform.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/third_party/tinycbor/libtinycbor.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/lib/source/serializer/libiotserializer.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/lib/source/shadow/libawsiotshadow.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/lib/source/mqtt/libiotmqtt.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/lib/source/defender/libawsiotdefender.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/lib/source/common/libiotcommon.a $(VSB_DIR)/usr/lib/common
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/bin/aws_iot_demo_shadow.vxe $(VSB_DIR)/usr/root/llvm/bin
	cp $(VSBL_SRC_DIR)/$(PKG_BUILD_DIR)/bin/iot_demo_mqtt.vxe $(VSB_DIR)/usr/root/llvm/bin
	@$(MAKE_STAMP)
