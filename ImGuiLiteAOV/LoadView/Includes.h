#include <MetalKit/MetalKit.h>
#include <Metal/Metal.h>
#include <iostream>
#include <UIKit/UIKit.h>
#include <vector>
#import "pthread.h"
#include <array>
//#include "../Fonts.hpp"


#import "ImGuiDrawView.h"
#import "LoadView.h"
#import "FTIndicator.h"
#import "FTToastIndicator.h"
#import "FTNotificationIndicator.h"
#import "../imgui/imgui.h"
#import "../imgui/imgui_internal.h"
#import "../imgui/imgui_impl_metal.h"

#include <libgen.h>
#include <sys/sysctl.h>
#include <sys/stat.h>
#include <mach-o/dyld.h>
#include <mach-o/fat.h>
#include <mach-o/loader.h>
#include <mach/vm_page_size.h>
#include <unistd.h>
#include <array>
#include <deque>
#include <map>
#include <unordered_map>
#include <vector>
#include <algorithm>
#include <limits>
#include <fstream>
#include <sstream>
#include <sys/utsname.h>


#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

extern MenuInteraction* menuTouchView;
extern UIButton* InvisibleMenuButton;
extern UIButton* VisibleMenuButton;
extern UITextField* hideRecordTextfield;
extern UIView* hideRecordView;
extern bool StreamerMode;