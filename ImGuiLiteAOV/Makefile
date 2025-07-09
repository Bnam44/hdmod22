
#export THEOS=/home/codespace/theos
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
IGNORE_WARNINGS = 1
TARGET = iphone:clang:latest:latest:13.0
include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = AWSCognito

AWSCognito_FRAMEWORKS = UIKit SafariServices Accelerate Foundation QuartzCore CoreGraphics AudioToolbox CoreText Metal MobileCoreServices Security SystemConfiguration IOKit CoreTelephony CoreImage CFNetwork AdSupport AVFoundation

AWSCognito_CCFLAGS = -fno-rtti -fvisibility=hidden -DNDEBUG -std=c++11
AWSCognito_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value  -DHAVE_INTTYPES_H -DHAVE_PKCRYPT -DHAVE_STDINT_H -DHAVE_WZAES -DHAVE_ZLIB 
AWSCognito_LDFLAGS += -framework SystemConfiguration -framework Foundation -lresolv -lz -liconv lib/libdaubuoi.a lib/libmonostring.a 

ifeq ($(IGNORE_WARNINGS),1)
  AWSCognito_CFLAGS += -w
  AWSCognito_CCFLAGS += -w
  AWSCognito_LDFLAGS += -w
endif

AWSCognito_FILES = ImGuiDrawView.mm imgui/Cbeios.m $(wildcard LoadView/*.mm) $(wildcard LoadView/*.m) $(wildcard imgui/*.cpp) $(wildcard imgui/*.mm) $(wildcard Antihook/*.m) $(wildcard Antihook/*.c)

#include $(THEOS_MAKE_PATH)/framework.mk
#LIBRARIES += substrate mobilesubstrate

include $(THEOS_MAKE_PATH)/framework.mk
