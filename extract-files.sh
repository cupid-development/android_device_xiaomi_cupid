#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/camera/cupid_enhance_motiontuning.xml|vendor/etc/camera/cupid_motiontuning.xml)
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        vendor/etc/camera/pureShot_parameter.xml|vendor/etc/camera/pureView_parameter.xml)
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
        vendor/lib64/hw/audio.primary.taro-cupid.so)
            "${PATCHELF_0_17_2}" --set-soname "audio.primary.taro-cupid.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod.default.so)
            "${PATCHELF_0_17_2}" --set-soname "fingerprint.goodix_fod.default.so" "${2}"
            ;;
        vendor/lib64/libcamximageformatutils.so)
            "${PATCHELF_0_17_2}" --replace-needed "vendor.qti.hardware.display.config-V2-ndk_platform.so" "vendor.qti.hardware.display.config-V2-ndk.so" "${2}"
            ;;
        vendor/lib64/libkaraokepal.so)
            "${PATCHELF_0_17_2}" --replace-needed "audio.primary.taro.so" "audio.primary.taro-cupid.so" "${2}"
            ;;
        vendor/lib64/libSnpeCpu.so)
            "${PATCHELF_0_17_2}" --set-soname "libSnpeCpu.so" "${2}"
            ;;
        vendor/lib64/libSnpeGpu.so)
            "${PATCHELF_0_17_2}" --set-soname "libSnpeGpu.so" "${2}"
            ;;
        vendor/lib64/libSnpeHtpV69Stub.so)
            "${PATCHELF_0_17_2}" --set-soname "libSnpeHtpV69Stub.so" "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=cupid
export DEVICE_COMMON=sm8450-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
