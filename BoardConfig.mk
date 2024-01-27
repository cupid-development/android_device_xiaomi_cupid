#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from xiaomi sm8450-common
include device/xiaomi/sm8450-common/BoardConfigCommon.mk

# Inherit from the proprietary version
include vendor/xiaomi/cupid/BoardConfigVendor.mk

DEVICE_PATH := device/xiaomi/cupid

# Kernel
device_second_stage_modules := \
	qcom_pm8008-regulator.ko \
	fts_touch_spi.ko \
	aw8697-haptic.ko

device_vendor_dlkm_exclusive_modules := \
	cs35l41_dlkm.ko

BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD += $(device_second_stage_modules)
BOARD_VENDOR_KERNEL_MODULES_LOAD += $(device_second_stage_modules) $(device_vendor_dlkm_exclusive_modules)

BOOT_KERNEL_MODULES += $(device_second_stage_modules)

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/properties/system.prop

# Screen density
TARGET_SCREEN_DENSITY := 440
