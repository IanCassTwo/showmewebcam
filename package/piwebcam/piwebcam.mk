################################################################################
#
# piwebcam
#
################################################################################

PIWEBCAM_VERSION = e9a733fe5c4a7fcb48e963e8d994bc33d24d814e
PIWEBCAM_SITE = git://github.com/peterbay/uvc-gadget.git
PIWEBCAM_LICENSE = GPL-2.0+
PIWEBCAM_LICENSE_FILES = LICENSE
PIWEBCAM_DEST_DIR = /opt/uvc-webcam
PIWEBCAM_SITE_METHOD = git
PIWEBCAM_INIT_SYSTEMD_TARGET = basic.target.wants

define PIWEBCAM_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D)
endef

define PIWEBCAM_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(PIWEBCAM_DEST_DIR)
	$(INSTALL) -D -m 0755 $(@D)/uvc-gadget $(TARGET_DIR)$(PIWEBCAM_DEST_DIR)
	$(INSTALL) -D -m 0755 $(PIWEBCAM_PKGDIR)/multi-gadget.sh $(TARGET_DIR)$(PIWEBCAM_DEST_DIR)
	$(INSTALL) -D -m 0755 $(PIWEBCAM_PKGDIR)/start-webcam.sh $(TARGET_DIR)$(PIWEBCAM_DEST_DIR)
	$(INSTALL) -D -m 0644 $(PIWEBCAM_PKGDIR)/video_formats.txt $(TARGET_DIR)/etc/video_formats.txt
endef

define PIWEBCAM_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/$(PIWEBCAM_INIT_SYSTEMD_TARGET)
	$(INSTALL) -D -m 644 $(PIWEBCAM_PKGDIR)/uvc-webcam.service $(TARGET_DIR)/usr/lib/systemd/system/uvc-webcam.service
	$(INSTALL) -D -m 644 $(PIWEBCAM_PKGDIR)/usb-gadget-config.service $(TARGET_DIR)/usr/lib/systemd/system/usb-gadget-config.service
	ln -sf /usr/lib/systemd/system/uvc-webcam.service $(TARGET_DIR)/etc/systemd/system/$(PIWEBCAM_INIT_SYSTEMD_TARGET)
	ln -sf /usr/lib/systemd/system/usb-gadget-config.service $(TARGET_DIR)/etc/systemd/system/$(PIWEBCAM_INIT_SYSTEMD_TARGET)
endef

$(eval $(generic-package))
