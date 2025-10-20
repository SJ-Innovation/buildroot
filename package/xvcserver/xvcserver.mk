################################################################################
#
# xvcserver
#
################################################################################

XVCSERVER_VERSION = c90b9f06a4b3fa709e1b22a6090800867ed9d5fa
XVCSERVER_SITE = https://github.com/Xilinx/XilinxVirtualCable.git
XVCSERVER_SITE_METHOD = git
XVCSERVER_LICENSE = MIT
XVCSERVER_LICENSE_FILES = LICENSE

define XVCSERVER_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -Wall -O2 \
		-o $(@D)/xvcserver $(@D)/jtag/zynq7000/XAPP1251/src/xvcServer.c \
		$(TARGET_LDFLAGS)

	$(TARGET_CC) $(TARGET_CFLAGS) -Wall -O2 \
		-o $(@D)/find_uio_by_name package/xvcserver/find_uio_by_name.c
endef

define XVCSERVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xvcserver \
		$(TARGET_DIR)/usr/bin/xvcserver

	$(INSTALL) -D -m 0755 $(@D)/find_uio_by_name \
		$(TARGET_DIR)/usr/bin/find_uio_by_name
endef

define XVCSERVER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/xvcserver/S99xvcserverd \
		$(TARGET_DIR)/etc/init.d/S99xvcserverd

	$(INSTALL) -D -m 0644 package/xvcserver/xvcserverd.defaults \
		$(TARGET_DIR)/etc/default/xvcserverd
endef

$(eval $(generic-package))
