LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

SQLITE_PATH := external/sqlite

LOCAL_MODULE := su

LOCAL_SRC_FILES := \
	su.c \
	daemon.c \
	pts.c \
	activity.c \
	db.c \
	utils.c \
	../../../$(SQLITE_PATH)/dist/sqlite3.c

LOCAL_C_INCLUDES := \
	$(SQLITE_PATH)/dist

LOCAL_STATIC_LIBRARIES := \
	libc \
	libcutils \
	liblog

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng debug
LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_CFLAGS := -DSQLITE_OMIT_LOAD_EXTENSION
LOCAL_CFLAGS += -DSUPERUSER_EMBEDDED
LOCAL_CFLAGS += -DREQUESTOR=\"com.evervolv.toolbox\"
LOCAL_CFLAGS += -DREQUESTOR_PREFIX=\"com.evervolv.toolbox.superuser\"
LOCAL_CFLAGS += -Werror

LOCAL_INIT_RC := superuser.rc

include $(BUILD_EXECUTABLE)

SU_SYMLINKS := $(addprefix $(TARGET_OUT)/bin/,su)
$(SU_SYMLINKS): $(LOCAL_MODULE)
$(SU_SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> /system/xbin/su"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf ../xbin/su $@

ALL_DEFAULT_INSTALLED_MODULES += $(SU_SYMLINKS)

# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SU_SYMLINKS)
