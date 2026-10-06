ifneq ($(AUDIO_USE_STUB_HAL), true)
ifeq ($(TARGET_USES_QCOM_MM_AUDIO), true)

LOCAL_PATH := $(call my-dir)
PAL_BASE_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libarpal_headers
LOCAL_EXPORT_C_INCLUDE_DIRS := \
    $(LOCAL_PATH)/inc \
    $(LOCAL_PATH)/stream/inc \
    $(LOCAL_PATH)/device/inc \
    $(LOCAL_PATH)/session/inc \
    $(LOCAL_PATH)/resource_manager/inc \
    $(LOCAL_PATH)/context_manager/inc \
    $(LOCAL_PATH)/utils/inc \
    $(LOCAL_PATH)/plugins/codecs

LOCAL_VENDOR_MODULE := true

include $(BUILD_HEADER_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE        := libar-pal
LOCAL_MODULE_OWNER  := qti
LOCAL_MODULE_TAGS   := optional
LOCAL_VENDOR_MODULE := true

LOCAL_CFLAGS        := -D_ANDROID_
LOCAL_CFLAGS        += -Wno-macro-redefined
LOCAL_CFLAGS        += -Wall -Werror -Wno-unused-variable -Wno-unused-parameter
LOCAL_CFLAGS        += -DCONFIG_GSL
LOCAL_CFLAGS        += -D_GNU_SOURCE
LOCAL_CFLAGS        += -DADSP_SLEEP_MONITOR
LOCAL_CFLAGS        += -DPAL_SP_TEMP_PATH=\"/data/vendor/audio/audio.cal\"
LOCAL_CFLAGS        += -DACD_SM_FILEPATH=\"/vendor/etc/models/acd/\"
ifeq ($(call is-board-platform-in-list,kalama pineapple), true)
LOCAL_CFLAGS        += -DSOC_PERIPHERAL_PROT
endif
LOCAL_CPPFLAGS      += -fexceptions -frtti

ifneq ($(TARGET_BOARD_PLATFORM), anorak)
LOCAL_CFLAGS        += -DA2DP_SINK_SUPPORTED
endif

ifeq ($(TARGET_BOARD_PLATFORM), volcano)
LOCAL_CFLAGS        += -DWSA_V883X_ADDR
endif

LOCAL_CFLAGS += -DAW_BACK_END_NAME=\"MI2S-LPAIF_WSA-RX-PRIMARY\"
LOCAL_CFLAGS += -DAW_PCM_NAME_LIST=\"PCM100,PCM101,PCM102,PCM103,PCM104,COMPRESS105,VOICEMMODE1p,VOICEMMODE2p,VOICEMMODE1c,VOICEMMODE2c,PCM110,PCM111,PCM112,PCM113,PCM114,PCM115,PCM116,PCM117,PCM118,PCM119,PCM120,PCM121,PCM122,PCM123,PCM124,PCM125,PCM126\"
LOCAL_CFLAGS        += -DAUDIO_FEATURE_STATS_UNSUPPORTED
LOCAL_CFLAGS        += -DPAL_MEMLOG_UNSUPPORTED

LOCAL_C_INCLUDES := \
    $(TOP)/system/media/audio_route/include \
    $(TOP)/system/media/audio/include

ifneq ($(TARGET_KERNEL_VERSION), 3.18)
ifneq ($(TARGET_KERNEL_VERSION), 4.14)
ifneq ($(TARGET_KERNEL_VERSION), 4.19)
ifneq ($(TARGET_KERNEL_VERSION), 4.4)
ifneq ($(TARGET_KERNEL_VERSION), 4.9)
ifneq ($(TARGET_KERNEL_VERSION), 5.4)
LOCAL_CFLAGS        += -DADSP_SLEEP_MONITOR
endif
endif
endif
endif
endif
endif

# Kernel UAPI headers (misc/adsp_sleepmon.h) come from the device's sanitized
# header library; the ALSA and compress headers from bionic.
LOCAL_HEADER_LIBRARIES += qti_kernel_headers

LOCAL_EXPORT_C_INCLUDE_DIRS   := $(LOCAL_PATH)/inc

LOCAL_SRC_FILES := \
    Pal.cpp \
    stream/src/Stream.cpp \
    stream/src/StreamCompress.cpp \
    stream/src/StreamPCM.cpp \
    stream/src/StreamACDB.cpp \
    stream/src/StreamInCall.cpp \
    stream/src/StreamNonTunnel.cpp \
    stream/src/StreamSoundTrigger.cpp \
    stream/src/StreamACD.cpp \
    stream/src/StreamCommon.cpp \
    stream/src/StreamContextProxy.cpp \
    stream/src/StreamCommonProxy.cpp \
    stream/src/StreamUltraSound.cpp \
    stream/src/StreamSensorPCMData.cpp\
    stream/src/StreamHaptics.cpp \
    device/src/Headphone.cpp \
    device/src/USBAudio.cpp \
    device/src/Device.cpp \
    device/src/Speaker.cpp \
    device/src/Bluetooth.cpp \
    device/src/SpeakerMic.cpp \
    device/src/HeadsetMic.cpp \
    device/src/HdmiIn.cpp \
    device/src/HandsetMic.cpp \
    device/src/Handset.cpp \
    device/src/HandsetVaMic.cpp \
    device/src/DisplayPort.cpp \
    device/src/HeadsetVaMic.cpp \
    device/src/RTProxy.cpp \
    device/src/SpeakerProtection.cpp \
    device/src/FMDevice.cpp \
    device/src/ExtEC.cpp \
    device/src/HapticsDev.cpp \
    device/src/UltrasoundDevice.cpp \
    device/src/ECRefDevice.cpp \
    device/src/DummyDev.cpp \
    device/src/HapticsDevProtection.cpp \
    session/src/Session.cpp \
    session/src/PayloadBuilder.cpp \
    session/src/SessionAlsaPcm.cpp \
    session/src/SessionAgm.cpp \
    session/src/SessionAlsaUtils.cpp \
    session/src/SessionAlsaCompress.cpp \
    session/src/SessionAlsaVoice.cpp \
    session/src/SoundTriggerEngine.cpp \
    session/src/SoundTriggerEngineCapi.cpp \
    session/src/SoundTriggerEngineGsl.cpp \
    session/src/ContextDetectionEngine.cpp \
    context_manager/src/ContextManager.cpp \
    session/src/ACDEngine.cpp \
    resource_manager/src/ResourceManager.cpp \
    resource_manager/src/SndCardMonitor.cpp \
    utils/src/SoundTriggerPlatformInfo.cpp \
    utils/src/ACDPlatformInfo.cpp \
    utils/src/VoiceUIPlatformInfo.cpp \
    utils/src/PalRingBuffer.cpp \
    utils/src/SignalHandler.cpp \
    utils/src/AudioHapticsInterface.cpp \
    utils/src/MetadataParser.cpp


LOCAL_C_INCLUDES += $(LOCAL_PATH)/awinic_ar/inc
LOCAL_SRC_FILES += \
    awinic_ar/src/aw_ar_cali.c \
    awinic_ar/src/aw_ar_dsp.cpp \
    awinic_ar/src/aw_ar_kmsg.c \
    awinic_ar/src/aw_ar_monitor.c \
    awinic_ar/src/aw_ar_cali_exe.c

# The memory logger, feature statistics and library-based voice UI headers
# are closed and their features are compiled out (PAL_MEMLOG_UNSUPPORTED,
# AUDIO_FEATURE_STATS_UNSUPPORTED); capi_v2.h is in session/inc.
LOCAL_HEADER_LIBRARIES += \
    libarpal_headers \
    libspf-headers \
    libagm_headers \
    libacdb_headers \
    libarosal_headers \
    libvui_dmgr_headers \
    libar-gsl_headers

LOCAL_SHARED_LIBRARIES := \
    libar-gsl\
    liblog\
    libexpat\
    liblx-osal\
    libaudioroute\
    libcutils \
    libutilscallstack \
    libagmclient \
    libvui_intf \
    libhidlbase

ifeq ($(call is-board-platform-in-list,kalama pineapple), true)
LOCAL_SHARED_LIBRARIES += libPeripheralStateUtils
LOCAL_HEADER_LIBRARIES += peripheralstate_headers \
    vendor_common_inc\
    mink_headers
endif

# Use flag based selection to use QTI vs open source tinycompress project

ifeq ($(TARGET_USES_QTI_TINYCOMPRESS),true)
LOCAL_SHARED_LIBRARIES += libqti-tinyalsa libqti-tinycompress
else
LOCAL_C_INCLUDES       += $(TOP)/external/tinycompress/include
LOCAL_SHARED_LIBRARIES += libtinyalsa libtinycompress
endif

# As the stock FP6 build: control-flow integrity and the integer overflow
# sanitizer.
LOCAL_SANITIZE := cfi integer_overflow

include $(BUILD_SHARED_LIBRARY)

#-------------------------------------------
#            Build CHARGER_LISTENER LIB
#-------------------------------------------
include $(CLEAR_VARS)

LOCAL_MODULE := libaudiochargerlistener
LOCAL_MODULE_OWNER := qti
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES:= utils/src/ChargerListener.cpp

LOCAL_CFLAGS += -Wall -Werror -Wno-unused-function -Wno-unused-variable

LOCAL_SHARED_LIBRARIES += libcutils liblog

LOCAL_C_INCLUDES := $(LOCAL_PATH)/utils/inc

include $(BUILD_SHARED_LIBRARY)

#-------------------------------------------
#   Awinic aw882xx calibration exec
#-------------------------------------------
include $(CLEAR_VARS)
LOCAL_USE_VNDK := true
LOCAL_VENDOR_MODULE := true
LOCAL_NOSANITIZE := cfi
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/awinic_ar/inc

LOCAL_SHARED_LIBRARIES += libtinyalsa liblog libcutils
LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-macro-redefined

LOCAL_SRC_FILES  := /awinic_ar/src/aw_ar_cali.c \
                    /awinic_ar/src/aw_ar_cali_exe.c \
                    /awinic_ar/src/aw_ar_dsp.cpp \
                    /awinic_ar/src/aw_ar_kmsg.c

LOCAL_CFLAGS += -DAW_BACK_END_NAME=\"MI2S-LPAIF_WSA-RX-PRIMARY\"

# -------------------------------------------------------------
# The AW_PCM_NAME_LIST field is platform-dependent.
# Refer to the name value supporting the playback attribute in all pcm-device fields
# in the card-defs.xml file
# -------------------------------------------------------------
LOCAL_CFLAGS += -DAW_PCM_NAME_LIST=\"PCM100,PCM101,PCM102,PCM103,PCM104,COMPRESS105,VOICEMMODE1p,VOICEMMODE2p,VOICEMMODE1c,VOICEMMODE2c,PCM110,PCM111,PCM112,PCM113,PCM114,PCM115,PCM116,PCM117,PCM118,PCM119,PCM120,PCM121,PCM122,PCM123,PCM124,PCM125,PCM126\"

LOCAL_MODULE               := aw882xx_cali
LOCAL_MODULE_OWNER         := awinic
LOCAL_MODULE_TAGS          := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_USE_VNDK := true

LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-macro-redefined

LOCAL_SRC_FILES  := test/PalUsecaseTest.c \
                    test/PalTest_main.c

LOCAL_MODULE               := PalTest
LOCAL_MODULE_OWNER         := qti
LOCAL_MODULE_TAGS          := optional

LOCAL_HEADER_LIBRARIES := \
    libarpal_headers

LOCAL_SHARED_LIBRARIES := \
                          libpalclient
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

# Not built: the Bluetooth codec and voice UI plugins. Nothing loads them
# on this device, and the voice UI plugins need closed headers.
include $(PAL_BASE_PATH)/ipc/HwBinders/Android.mk

endif #TARGET_USES_QCOM_MM_AUDIO
endif #AUDIO_USE_STUB_HAL
