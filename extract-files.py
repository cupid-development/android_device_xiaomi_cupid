#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/xiaomi/sm8450-common',
    'hardware/qcom-caf/sm8450',
    'hardware/xiaomi',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/xiaomi/sm8450-common',
]

blob_fixups: blob_fixups_user_type = {
    (
        'vendor/etc/camera/cupid_enhance_motiontuning.xml',
        'vendor/etc/camera/cupid_motiontuning.xml',
    ): blob_fixup().regex_replace('xml=version', 'xml version'),
    (
        'vendor/etc/camera/pureShot_parameter.xml',
        'vendor/etc/camera/pureView_parameter.xml',
    ): blob_fixup().regex_replace(r'=([0-9]+)>', r'="\1">'),
    'vendor/lib64/hw/com.qti.chi.override.so': blob_fixup().add_needed(
        'libprocessgroup_shim.so'
    ),
    'vendor/lib64/hw/fingerprint.goodix_fod.default.so': blob_fixup().binary_regex_replace(
        b'/sys/class/touch/touch_dev/fod_press_status',
        b'/sys/class/touch/touch_dev/fod_finger_state',
    ),
    (
        'vendor/lib64/libTrueSight.so',
        'vendor/lib64/libmorpho_ubwc.so',
    ): blob_fixup()
    .clear_symbol_version('AHardwareBuffer_allocate')
    .clear_symbol_version('AHardwareBuffer_describe')
    .clear_symbol_version('AHardwareBuffer_isSupported')
    .clear_symbol_version('AHardwareBuffer_lock')
    .clear_symbol_version('AHardwareBuffer_lockPlanes')
    .clear_symbol_version('AHardwareBuffer_release')
    .clear_symbol_version('AHardwareBuffer_unlock'),
    'vendor/lib64/libcamxcommonutils.so': blob_fixup().add_needed(
        'libprocessgroup_shim.so'
    ),
    'vendor/lib64/libcamximageformatutils.so': blob_fixup().replace_needed(
        'vendor.qti.hardware.display.config-V2-ndk_platform.so',
        'vendor.qti.hardware.display.config-V2-ndk.so',
    ),
    'vendor/lib64/libmialgo_pureShot.so': blob_fixup()
    .clear_symbol_version('remote_handle64_close')
    .clear_symbol_version('remote_handle64_invoke')
    .clear_symbol_version('remote_handle64_open')
    .clear_symbol_version('remote_register_buf_attr'),
    'vendor/lib64/libmialgoengine.so': blob_fixup().add_needed(
        'libprocessgroup_shim.so'
    ),
}

module = ExtractUtilsModule(
    'cupid',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    check_elf=True,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module, 'sm8450-common', module.vendor
    )
    utils.run()
