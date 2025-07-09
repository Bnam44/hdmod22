#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>

#import "imgui/imgui.h"
#import "imgui/imgui_impl_metal.h"
#import "imgui/Il2cpp.h"
#import "imgui/Fonts.h"
#include "imgui/Fonts.hpp"
#import "imgui/stb_image.h"
#import "imgui/Cbeios.h"


#import "LoadView/CaptainHook.h"
#import "LoadView/ImGuiDrawView.h"
#import "LoadView/Includes.h"
#import "LoadView/MonoString.h"
#include "LoadView/dbdef.h"
//ndjnd
//Auto Patch
#include "Hook/patch.h"
#include "Hook/Hook.h"

//Auto Update
#import "5Toubun/NakanoIchika.h"
#import "5Toubun/NakanoNino.h"
#import "5Toubun/NakanoMiku.h"
#import "5Toubun/NakanoYotsuba.h"
#import "5Toubun/NakanoItsuki.h"
#import "5Toubun/dobby.h"
#import "5Toubun/il2cpp.h"
#import "Security/oxorany_include.h"

#import "stb_image.h"
#import "Image/AutoBocPha.h"
#import "Image/autobangsuong.h"
#import "Image/AutoCapCuu.h"
#import "Image/AutoHoiMau.h"
#import "Image/AutoTrungTri.h"
#import "Image/imagepoong.h"
#import "Image/Herolib.h"
#import "imgui/img.h"
#import "fonts.h"

//ESP
#import "unlockskin.h"
#include "Unity/Quaternion.h"
#include "Unity/Vector2.h"
#import "Unity/Vector3.h"
#include "Unity/VInt3.h"
#include "Unity/EspManager.h"

//Block Host
#import "Antihook/NemG.h"

#define iPhonePlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale
using namespace IL2Cpp;
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
- (void)activehack;
@end

@implementation ImGuiDrawView


NSUserDefaults *saveSetting = [NSUserDefaults standardUserDefaults];


static bool MenDeal = true;
static int tab = 1;
static bool ShowBoTroz = false;
static bool ShowRank = false;

static bool ShowBoTroz_active = false;
static bool ShowRank_active = false;

uint64_t get_actorHpoff;
uint64_t set_actorHpoff;
uint64_t lobbyupdateoffset;

uint64_t GetCameraOffset;
uint64_t UpdateCameraOffset;
uint64_t HighrateCameraOffset;
	
uint64_t SetVisibleOffset;
	
uint64_t ShowHeroInfoOffset;
uint64_t ShowSkillStateInfoOffset;
uint64_t ShowHeroHpInfoOffset;


uint64_t GetPlayerOffset;
uint64_t CheckRoleNameOffset;
uint64_t RemoveSpaceOffset;
uint64_t OpenWaterUIDOffset;

uint64_t UpdateNameCDOffset;
uint64_t UnpackOffset;
uint64_t OnClickSelectOffset;
uint64_t IsCanUseSkinOffset;
uint64_t GetHeroSkinIdOffset;
uint64_t IsHaveHeroSkinOffset;
	
uint64_t IsHostProfileOffset;
uint64_t IsOpenOffset;
	
uint64_t PersonalBtnIdOffset;
uint64_t UpdateLogicOffset;
uint64_t GetUseSkillDirectionOffset;
uint64_t UpdateFrameLaterOffset;
	
uint64_t InitTeamHeroListOffset;
uint64_t TeamLaderGradeMaxOffset;
	
uint64_t IsCanSellOffset;
uint64_t SendInBattleMsgOffset;
uint64_t IsFinishGameOffset;

uint64_t OnEnterOffset;
uint64_t EndGameOffset;
uint64_t DisconnectOffset;
uint64_t Reconnectoffset;

uint64_t IsSuperKingOffset;
uint64_t ShowRankDetailExOffset;

uint64_t UpdateLogicESPOffset;
uint64_t DestroyActorOffset;
uint64_t DestroyActor2Offset;

uint64_t ShowBoTroOffset;
uint64_t ShowKhungRankOffset;

ImFont* FontThemes;
ImFont* xFontPongs;


struct Texture {
    id<MTLTexture> texture; 
    float height;
    float width;
    int heroID;
};
id<MTLTexture> LoadImageFromMemory(id<MTLDevice> device, unsigned char* image_data, size_t image_size) {
    CFDataRef imageData = CFDataCreate(kCFAllocatorDefault, image_data, image_size);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageData);
    CGImageRef cgImage = CGImageCreateWithPNGDataProvider(dataProvider, NULL, false, kCGRenderingIntentDefault);
    CFRelease(imageData);
    CGDataProviderRelease(dataProvider);
    if (!cgImage) {
        return nil;
    }
    NSError *error = nil;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    NSDictionary *options = @{MTKTextureLoaderOptionSRGB : @(NO)};
    id<MTLTexture> texture = [textureLoader newTextureWithCGImage:cgImage options:options error:&error];

    if (error) {
        CGImageRelease(cgImage);
        return nil;
    }
    CGImageRelease(cgImage);
    return texture;
}
vector<Texture> textures;

void AddTexturesFromImageData(id<MTLDevice> device) {
    for (const auto& heroData : heroArray) {
        Texture tex;
        tex.texture = LoadImageFromMemory(device, heroData.data, heroData.size);
        if(tex.texture == nil) continue;
        tex.width = tex.texture.width;
        tex.height = tex.texture.height;
        textures.push_back(tex);
    }
}


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();
    // Ảnh ============
    AddTexturesFromImageData(_device);
    id<MTLTexture> texture = nil;
    CFDataRef imageData = CFDataCreate(kCFAllocatorDefault, _Airi_data, sizeof(_Airi_data));
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageData);
    CGImageRef cgImage = CGImageCreateWithPNGDataProvider (dataProvider, NULL, false, kCGRenderingIntentDefault);
    CFRelease(imageData);
    CGDataProviderRelease(dataProvider);
    NSError *error = nil;
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:self.device];
    NSDictionary *options = @{MTKTextureLoaderOptionSRGB : @(NO)};
    texture = [textureLoader newTextureWithCGImage:cgImage options:options error:&error];

    if (error) {
    NSLog(@"Failed to load texture: %@", error.localizedDescription);
    }
    //======================

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    // Stil referansını al
    ImGuiStyle& style = ImGui::GetStyle();

    ImFontConfig config;
    config.FontDataOwnedByAtlas = false;
    
    io.Fonts->Clear();

    ImFontConfig font_cfg;
    font_cfg.FontDataOwnedByAtlas = false;

    ImGui::StyleColorsDark();

    ImFont* font = io.Fonts->AddFontFromMemoryCompressedTTF((void*)zzz_compressed_data, zzz_compressed_size, 60.0f, NULL, io.Fonts->GetGlyphRangesVietnamese());

    static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_FA, 0 };
    ImFontConfig icons_config;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    icons_config.FontDataOwnedByAtlas = false;

    io.Fonts->AddFontFromMemoryTTF((void*)fontAwesome, sizeof(fontAwesome), 60, &icons_config, icons_ranges);


    FontThemes = io.Fonts->AddFontFromMemoryTTF(TtftoHex_Craftedby_Devx, sizeof(TtftoHex_Craftedby_Devx), 16.0f);

    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

+ (BOOL)isMenuShowing {
    return MenDeal;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}


class Camera {
	public:
        static Camera *get_main() {
        Camera *(*get_main_) () = (Camera *(*)()) GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "get_main", 0);
        
        return get_main_();
    }

    Vector3 WorldToViewportPoint(Vector3 position) 
    {
    Vector3 (*WorldToViewportPoint_)(Camera* camera, Vector3 position) = (Vector3 (*)(Camera*, Vector3)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Camera"), oxorany("WorldToViewportPoint"), 2);
    return WorldToViewportPoint_(this, position);
    }
    
    Vector3 WorldToScreenPoint(Vector3 position) {
        Vector3 (*WorldToScreenPoint_)(Camera *camera, Vector3 position) = (Vector3 (*)(Camera *, Vector3)) GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToScreenPoint", 1);
        
        return WorldToScreenPoint_(this, position);
    }

    Vector3 WorldToScreen(Vector3 position) {
        Vector3 (*WorldToViewportPoint_)(Camera* camera, Vector3 position, int eye) = (Vector3 (*)(Camera*, Vector3, int)) GetMethodOffset("UnityEngine.CoreModule.dll", "UnityEngine", "Camera", "WorldToViewportPoint", 1);
        
        return WorldToViewportPoint_(this, position, 2);
}

   float get_fieldOfView(){
        float (*get_fieldOfView_)(Camera *camera) = (float (*)(Camera *))GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"),oxorany("UnityEngine"),oxorany("Camera"),oxorany("get_fieldOfView"), 0);
        return get_fieldOfView_(this);
    }
    
    void set_fieldOfView(float value){
        void (*set_fieldOfView_)(Camera *camera,float value) = (void (*)(Camera *,float))GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"),oxorany("UnityEngine"),oxorany("Camera"),oxorany("set_fieldOfView"), 1);
        return set_fieldOfView_(this,value);
    }

};


class Component {
public:
    static void* get_transform(void* instance) {
        static void* (*_) (void*) = (void* (*)(void*)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Component"), oxorany("get_transform"), 0);
        return (_ != nullptr && instance != nullptr) ? _(instance) : nullptr;
    }
};

class Screen {
public:
    static void SetResolution(int width, int height, bool fullscreen) {
        void (*_) (int, int, bool) = (void (*)(int, int, bool)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Screen"), oxorany("SetResolution"), 3);
        if (_ != nullptr) {
            _(width, height, fullscreen);
        }
    }
};


class Transform {
public:
    static Vector3 get_position(void* player) {
        static Vector3 (*_) (void*) = (Vector3 (*)(void*)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Transform"), oxorany("get_position"), 0);
        void* transform = Component::get_transform(player);
        return (_ != nullptr && transform != nullptr) ? _(transform) : Vector3();
    }
    static void set_position(void* player, Vector3 position) {
        static void (*_) (void*, Vector3) = (void (*)(void*, Vector3)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Transform"), oxorany("set_position"), 1);
        void* transform = Component::get_transform(player);
        _(transform, position);
    }
    static Quaternion get_rotation(void* player) {
        static Quaternion (*_) (void*) = (Quaternion (*)(void*)) GetMethodOffset(oxorany("UnityEngine.CoreModule.dll"), oxorany("UnityEngine"), oxorany("Transform"), oxorany("get_rotation"), 0);
        void* transform = Component::get_transform(player);
        return (_ != nullptr && transform != nullptr) ? _(transform) : Quaternion();
    }
};

VInt3 LActorRoot_get_location(void *instance) {
    VInt3 (*_LActorRoot_get_location)(void *instance) = (VInt3 (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot") , oxorany("get_location"), 0);
return _LActorRoot_get_location(instance);
}

VInt3 LActorRoot_get_forward(void *instance) {
VInt3 (*_LActorRoot_get_forward)(void *instance) = (VInt3 (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot") , oxorany("get_forward"), 0);
    return _LActorRoot_get_forward(instance);
}

class CActorInfo {
    public:
        string *ActorName() {
            return *(string **)((uintptr_t)this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("CActorInfo"), oxorany("ActorName")));
        }
};

class ActorConfig {
public:
    int ConfigID() {
        return *(int *) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("ActorConfig"), oxorany("ConfigID"))); //public Int32 ConfigID; // 0x10
    }
};
class ValueLinkerComponent {
public:
    int get_actorHp() {
        int (*get_actorHp_)(ValueLinkerComponent * objLinkerWrapper) = (int (*)(ValueLinkerComponent *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("get_actorHp"), 0); //ValueLinkerComponent - get_actorHp
        return get_actorHp_(this);
    }

    int get_actorHpTotal() {
        int (*get_actorHpTotal_)(ValueLinkerComponent * objLinkerWrapper) =
        (int (*)(ValueLinkerComponent *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("get_actorHpTotal"), 0); //ValueLinkerComponent - get_actorHpTotal
        return get_actorHpTotal_(this);
    }
    int Level() {
            return *(int *) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("<actorSoulLevel>k__BackingField")));
            }

};

class VActorMovementComponent {
public:
    int get_maxSpeed() {
        int (*get_maxSpeed_)(VActorMovementComponent * component) = (int (*)(VActorMovementComponent *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("VActorMovementComponent"), oxorany("get_maxSpeed"), 0);
        return get_maxSpeed_(this);
    }
};

class HudComponent3D { // autott
    public:
            
        int Hud() { // Kiểu loại Hud
            return *(int *) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("HudComponent3D"), oxorany("HudType")));
       }
        
        int Hudh() { // độ cao Hud
            return *(int *) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("HudComponent3D"), oxorany("hudHeight")));
       }
   };   

class ActorLinker {
public:
    ValueLinkerComponent *ValueComponent() {
        return *(ValueLinkerComponent **)((uintptr_t)this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("ValueComponent"))); //public ValueLinkerComponent ValueComponent; // 0x18
    }
    ActorConfig *ObjLinker() {
        return *(ActorConfig **) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("ObjLinker"))); //public ActorConfig ObjLinker; // 0x9C
    }
    VActorMovementComponent* MovementComponent() {
            return *(VActorMovementComponent**)((uintptr_t)this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("MovementComponent"))); 
        }
    Vector3 get_position() {
        Vector3 (*get_position_)(ActorLinker * linker) = (Vector3(*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_position"), 0); //ActorLinker - get_position
        return get_position_(this);
    }
    Quaternion get_rotation() {
        Quaternion (*get_rotation_)(ActorLinker *linker) = (Quaternion (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_rotation"), 0); //ActorLinker - get_rotation
        return get_rotation_(this);
    }
    bool IsHostCamp() {
        bool (*IsHostCamp_)(ActorLinker *linker) = (bool (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("IsHostCamp"), 0); //ActorLinker - IsHostCamp
        return IsHostCamp_(this);
    }
    bool IsHostPlayer() {
        bool (*IsHostPlayer_)(ActorLinker *linker) = (bool (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("IsHostPlayer"), 0); //ActorLinker - IsHostPlayer
        return IsHostPlayer_(this);
    }
    bool isMoving() {
        return *(bool *) ((uintptr_t) this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("isMoving"))); //	public bool isMoving; // 0x2F2
    }
    Vector3 get_logicMoveForward() {
        Vector3 (*get_logicMoveForward_)(ActorLinker *linker) = (Vector3 (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_logicMoveForward"), 0); //ActorLinker - get_logicMoveForward
        return get_logicMoveForward_(this);
    }
    bool get_bVisible() {
        bool (*get_bVisible_)(ActorLinker *linker) = (bool (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_bVisible"), 0); //ActorLinker - get_bVisible
        return get_bVisible_(this);
    }
    int get_playerId() {
        int (*get_playerId_)(ActorLinker *linker) = (int (*)(ActorLinker *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_playerId"), 0);
        return get_playerId_(this);
    }
     uintptr_t AsHero() {
            uintptr_t (*AsHero_)(ActorLinker *linker) = (uintptr_t (*)(ActorLinker *)) (GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("AsHero"), 0));
            return AsHero_(this);
        }

    HudComponent3D *HudControl() {
            return *(HudComponent3D **)((uintptr_t)this + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("HudControl")));
        } // autott
};

class ActorManager {
public:
    List<ActorLinker *> *GetAllHeros() {
        List<ActorLinker *> *(*_GetAllHeros)(ActorManager *actorManager) = (List<ActorLinker *> *(*)(ActorManager *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorManager"), oxorany("GetAllHeros"), 0); //ActorManager - GetAllHeros
        return _GetAllHeros(this);
    }

    List<ActorLinker *> *GetAllMonsters() {
       List<ActorLinker *> *(*_GetAllMonsters)(ActorManager *actorManager) = (List<ActorLinker *> *(*)(ActorManager *))(GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany ("ActorManager"), oxorany("GetAllMonsters"), 0));
        return _GetAllMonsters(this); // autott
     } 

};

class KyriosFramework {
public:
    static ActorManager *get_actorManager() {
        auto get_actorManager_ = (ActorManager *(*)()) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios"), oxorany("KyriosFramework"), oxorany("get_actorManager"), 0); //KyriosFramework - get_actorManager
        return get_actorManager_();
    }
};

class LAcComponent {
public:
    uint32_t get_ACInstanceID() {
        return *(uint32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("acInstanceID"))); // 0x20
    }

    uint32_t get_PlayerID() {
        return *(uint32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("playerID"))); // 0x24
    }

    uint32_t get_ChessID() {
        return *(uint32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("chessID"))); // 0x28
    }

    uint32_t get_StarLevel() {
        return *(uint32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("starLevel"))); // 0x2c
    }

    uint32_t get_Hurt() {
        return *(uint32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("hurt"))); // 0x30
    }

    int32_t get_ACFetterSign() {
        return *(int32_t*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("acFetterSign"))); // 0x34
    }

    std::vector<uint32_t> get_DropActionList() {
        return *(std::vector<uint32_t>*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("dropActionList"))); // 0x48
    }

    std::vector<uint32_t> get_EquipList() {
        return *(std::vector<uint32_t>*)((uintptr_t)this + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LAcComponent"), oxorany("equipList"))); // 0x4c
    }
};

ImDrawList* getDrawList(){
    ImDrawList *drawList;
    drawList = ImGui::GetBackgroundDrawList();
    return drawList;
};
static int slot1;
static int slot2;
static int slot3;

int aimType = 0;
int drawType = 2;
int HeroTypeID = 0;

void DrawAimbotTab() {

    const char* aimWhenOptions[] = {"Aim Theo Tỉ Lệ % Máu", "Aim Theo Tỉ Lệ Máu Thấp", "Aim Theo Địch Ở Gần Nhất", "Aim Theo Địch Gần Tia Nhất"};

    ImGui::Combo("Tuỳ Chọn Aim :)", &aimType, aimWhenOptions, IM_ARRAYSIZE(aimWhenOptions));

    const char* drawOptions[] = {"Không", "Luôn Bật", "Khi Xem"};
    ImGui::Combo("Vẽ Vật Thể", &drawType, drawOptions, IM_ARRAYSIZE(drawOptions));

}

void DoLeckID() {
    const char* HeroWhenOptions[] = {"Elsu", 
    "Gildur","Grakk","Raz",
    "Enzo","Yue"};
    ImGui::PushItemWidth(80);
    ImGui::Combo("##Dolechtiong", &HeroTypeID, HeroWhenOptions, IM_ARRAYSIZE(HeroWhenOptions));
    ImGui::PopItemWidth();

static bool Elsu_active = false;
static bool Gildur_active = false;
static bool Grakk_active = false;
static bool Raz_active = false;
static bool Enzo_active = false;
static bool Yue_active = false;


//====== Hero Elsu 196 ============
if (HeroTypeID == 0) {
    if (Elsu_active == NO) {
        Radius = 25;
        DoLechAim = 0.43;
        // SizeIDHero = 196;
    }
    Elsu_active = YES;
}
else {
    if (Elsu_active == YES) {
    }
    Elsu_active = NO;
}

//====== Hero Gildur 108 ============
if (HeroTypeID == 1) {
    if (Gildur_active == NO) {
        Radius = 15;
        DoLechAim = 0.90;
        // SizeIDHero = 108;
    }
    Gildur_active = YES;
}
else {
    if (Gildur_active == YES) {
    }
    Gildur_active = NO;
}

//====== Hero Grakk 175 ============
if (HeroTypeID == 2) {
    if (Grakk_active == NO) {
        Radius = 15;
        DoLechAim = 0.60;
        // SizeIDHero = 175;
    }
    Grakk_active = YES;
}
else {
    if (Grakk_active == YES) {
    }
    Grakk_active = NO;
}

//====== Hero Raz 157 ============
if (HeroTypeID == 3) {
    if (Raz_active == NO) {
        Radius = 15;
        DoLechAim = 0.50;
        // SizeIDHero = 157;
    }
    Raz_active = YES;
}
else {
    if (Raz_active == YES) {
    }
    Raz_active = NO;
}

//====== Hero Enzo 195 ============
if (HeroTypeID == 4) {
    if (Enzo_active == NO) {
        Radius = 10;
        DoLechAim = 0.54;
        // SizeIDHero = 195;
    }
    Enzo_active = YES;
}
else {
    if (Enzo_active == YES) {
    }
    Enzo_active = NO;
}

//====== Hero Yue 545 ============
if (HeroTypeID == 5) {
    if (Yue_active == NO) {
        Radius = 15;
        DoLechAim = 0.75;
        // SizeIDHero = 545;
    }
    Yue_active = YES;
}
else {
    if (Yue_active == YES) {
    }
    Yue_active = NO;
}
} 


float Radius = 0;
float DoLechAim = 0;
int skillSlot;
float LazeThemes = 0;
float LazeElsu[4] = { 0.0f,1.0f,1.0f,1.0f };
float ColorCrosshair[4] = { 1.0f,0.0f,0.0f,1.0f };
bool AimSkill = false;
static int AllHero = 1;
static int SizeIDHero;

struct EntityInfo {
    Vector3 myPos;
    Vector3 enemyPos;
    Vector3 moveForward;
    int ConfigID;
    bool isMoving;
    int currentSpeed;
    float Ranger;
    int Hud;
    int Hudh;
    int Level; 
    ActorLinker *Entity;
};

EntityInfo EnemyTarget;

Vector3 RotateVectorByQuaternion(Quaternion q) {
    Vector3 v(0.0f, 0.0f, 1.0f);
    float w = q.w, x = q.x, y = q.y, z = q.z;

    Vector3 u(x, y, z);
    Vector3 cross1 = Vector3::Cross(u, v);
    Vector3 cross2 = Vector3::Cross(u, cross1);
    Vector3 result = v + 2.0f * cross1 * w + 2.0f * cross2;

    return result;
}

float SquaredDistance(Vector3 v, Vector3 o) {
    return (v.x - o.x) * (v.x - o.x) + (v.y - o.y) * (v.y - o.y) + (v.z - o.z) * (v.z - o.z);
}

Vector3 calculateSkillDirection(Vector3 myPosi, Vector3 enemyPosi, bool isMoving, Vector3 moveForward, int currentSpeed) {
    if (isMoving) {
        float distance = Vector3::Distance(myPosi, enemyPosi);
        float bulletTime = distance / (Radius / DoLechAim); 

        enemyPosi += Vector3::Normalized(moveForward) * (currentSpeed / 1000.0f) * bulletTime;
    }

    Vector3 direction = enemyPosi - myPosi;
    direction.Normalize();
    return direction;
}

Vector2 drawPos;
bool isCharging;

Vector3 (*_GetUseSkillDirection)(void *instance, bool isTouchUse);
Vector3 GetUseSkillDirection(void *instance, bool isTouchUse){
    if (instance != NULL && AimSkill &&/* EnemyTarget.ConfigID == SizeIDHero */  EnemyTarget.ConfigID != 0) {
        
        
    if(aimSkill1 == 1) slot1 = 1;
    if(aimSkill1 == 0) slot1 = -1;
    
    if(aimSkill2 == 1) slot2 = 2;
    if(aimSkill2 == 0) slot2 = -1;
    
    if(aimSkill3 == 1) slot3 = 3;
    if(aimSkill3 == 0) slot3 = -1;
    
    
        if (EnemyTarget.myPos != Vector3::zero() && EnemyTarget.enemyPos != Vector3::zero() &&  skillSlot == slot1 || skillSlot == slot2 || skillSlot == slot3) {
            return calculateSkillDirection(EnemyTarget.myPos, 
            EnemyTarget.enemyPos,
             EnemyTarget.isMoving, 
             EnemyTarget.moveForward,
             EnemyTarget.currentSpeed);
        }
    }
    return _GetUseSkillDirection(instance, isTouchUse);
}

uintptr_t m_isCharging, m_currentSkillSlotType;

bool (*_UpdateLogic)(void *instance, int delta);
bool UpdateLogic(void *instance, int delta){
	if (instance != NULL) 
  {
		isCharging = *(bool *)((uintptr_t)instance + m_isCharging);
		skillSlot = *(int *)((uintptr_t)instance + m_currentSkillSlotType);
	}
	return _UpdateLogic(instance, delta);
}

void Aimbot(ImDrawList *draw)
 {
    if (AimSkill)
	{
		Quaternion rotation;
		float minDistance = std::numeric_limits<float>::infinity();
		float minDirection = std::numeric_limits<float>::infinity();
		float minHealth = std::numeric_limits<float>::infinity();
		float minHealth2 = std::numeric_limits<float>::infinity();
		float minHealthPercent = std::numeric_limits<float>::infinity();
		ActorLinker *Entity = nullptr;
		
		ActorManager *get_actorManager = KyriosFramework::get_actorManager();
		if (get_actorManager == nullptr) return;

		List<ActorLinker *> *GetAllHeros = get_actorManager->GetAllHeros();
		if (GetAllHeros == nullptr) return;

		ActorLinker **actorLinkers = (ActorLinker **) GetAllHeros->getItems();

		for (int i = 0; i < GetAllHeros->getSize(); i++)
		{
			ActorLinker *actorLinker = actorLinkers[(i *2) + 1];
			if (actorLinker == nullptr) continue;
		
			if (actorLinker->IsHostPlayer()) {
				rotation = actorLinker->get_rotation();
				EnemyTarget.myPos = actorLinker->get_position();
				EnemyTarget.ConfigID = actorLinker->ObjLinker()->ConfigID();
			}

			if (actorLinker->IsHostCamp() || !actorLinker->get_bVisible() || actorLinker->ValueComponent()->get_actorHp() < 1) continue;
		
			Vector3 EnemyPos = actorLinker->get_position();
			float Health = actorLinker->ValueComponent()->get_actorHp();
			float MaxHealth = actorLinker->ValueComponent()->get_actorHpTotal();
			int HealthPercent = (int)std::round((float)Health / MaxHealth * 100);
			float Distance = Vector3::Distance(EnemyTarget.myPos, EnemyPos);
            float Direction = SquaredDistance(
                RotateVectorByQuaternion(rotation), 
                calculateSkillDirection(
                    EnemyTarget.myPos, 
                    EnemyPos, 
                    actorLinker->isMoving(), 
                    actorLinker->get_logicMoveForward(),
                    actorLinker->MovementComponent()->get_maxSpeed() 
                )
            );			
			if (Distance < Radius)
			{
				if (aimType == 0)
				{
					if (HealthPercent < minHealthPercent)
					{
						Entity = actorLinker;
						minHealthPercent = HealthPercent;
					}
				
					if (HealthPercent == minHealthPercent && Health < minHealth2)
					{
						Entity = actorLinker;
						minHealth2 = Health;
						minHealthPercent = HealthPercent;
					}
				}
			
				if (aimType == 1 && Health < minHealth)
				{
					Entity = actorLinker;
					minHealth = Health;
				}
				
				if (aimType == 2 && Distance < minDistance)
				{
					Entity = actorLinker;
					minDistance = Distance;
				}
			
				if (aimType == 3 && Direction < minDirection && isCharging)
				{
					Entity = actorLinker;
					minDirection = Direction;
				}
			}
		}
		if (Entity == nullptr) {
            EnemyTarget.enemyPos = Vector3::zero();
            EnemyTarget.moveForward = Vector3::zero();
            EnemyTarget.ConfigID = 0;
            EnemyTarget.isMoving = false;
        }
		if (Entity != NULL)
		{
			float nDistance = Vector3::Distance(EnemyTarget.myPos, Entity->get_position());
			if (nDistance > Radius || Entity->ValueComponent()->get_actorHp() < 1)
			{
				EnemyTarget.enemyPos = Vector3::zero();
				EnemyTarget.moveForward = Vector3::zero();
				minDistance = std::numeric_limits<float>::infinity();
				minDirection = std::numeric_limits<float>::infinity();
				minHealth = std::numeric_limits<float>::infinity();
				minHealth2 = std::numeric_limits<float>::infinity();
				minHealthPercent = std::numeric_limits<float>::infinity();
				Entity = nullptr;
			}
					
			else
			{
				EnemyTarget.enemyPos =  Entity->get_position();
				EnemyTarget.moveForward = Entity->get_logicMoveForward();
				EnemyTarget.isMoving = Entity->isMoving();
                EnemyTarget.currentSpeed = Entity->MovementComponent()->get_maxSpeed();
			}
		}
		
		if (Entity != NULL && aimType == 3 && !isCharging)
		{
			EnemyTarget.enemyPos = Vector3::zero();
			EnemyTarget.moveForward = Vector3::zero();
			minDirection = std::numeric_limits<float>::infinity();
			Entity = nullptr;
		}
		
		if ((Entity != NULL || EnemyTarget.enemyPos != Vector3::zero()) && get_actorManager == nullptr)
		{
			EnemyTarget.enemyPos = Vector3::zero();
			EnemyTarget.moveForward = Vector3::zero();
			minDistance = std::numeric_limits<float>::infinity();
			minDirection = std::numeric_limits<float>::infinity();
			minHealth = std::numeric_limits<float>::infinity();
			minHealth2 = std::numeric_limits<float>::infinity();
			minHealthPercent = std::numeric_limits<float>::infinity();
			Entity = nullptr;

		}
        
		if (drawType != 0 && /*EnemyTarget.ConfigID == SizeIDHero */EnemyTarget.ConfigID != 0) {
                if (EnemyTarget.myPos != Vector3::zero() && EnemyTarget.enemyPos != Vector3::zero()) {
                    Vector3 futureEnemyPos = EnemyTarget.enemyPos;
                    if (EnemyTarget.isMoving) {
                        float distance = Vector3::Distance(EnemyTarget.myPos, EnemyTarget.enemyPos);
                        float bulletTime = distance / (Radius / DoLechAim); // Giữ nguyên logic tính bulletTime của bạn
                        futureEnemyPos += Vector3::Normalized(EnemyTarget.moveForward) * (EnemyTarget.currentSpeed / 1000.0f) * bulletTime;
                    }
                    Vector3 EnemySC = Camera::get_main()->WorldToScreen(futureEnemyPos);
                    Vector2 RootVec2 = Vector2(EnemySC.x, EnemySC.y);


                    if (EnemySC.z > 0) {
                        
                        RootVec2 = Vector2(EnemySC.x*kWidth,kHeight -EnemySC.y*kHeight);
                        ImVec2 imRootVec2 = ImVec2(RootVec2.x, RootVec2.y);
                        ImVec2 startLine = ImVec2(kWidth / 2 + 10, kHeight / 2);
                        float sizelaze = 6.0f;
                    if (drawType == 1) {
                        //Đường Kẻ
                        draw->AddLine(startLine, imRootVec2, ImColor(0, 0, 0, 128), LazeThemes + 2);
                        draw->AddLine(startLine, imRootVec2, ImColor(LazeElsu[0], LazeElsu[1], LazeElsu[2], LazeElsu[3]), LazeThemes);
                        // Tâm
                        // Circle
                        draw->AddCircle(imRootVec2, sizelaze, ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 100, 1.0f);
                       // Left line
                        draw->AddLine(ImVec2(imRootVec2.x - sizelaze, imRootVec2.y), ImVec2(imRootVec2.x - sizelaze / 2, imRootVec2.y), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                       // Right line
                        draw->AddLine(ImVec2(imRootVec2.x + sizelaze / 2, imRootVec2.y), ImVec2(imRootVec2.x + sizelaze, imRootVec2.y), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                       // Top line
                        draw->AddLine(ImVec2(imRootVec2.x, imRootVec2.y - sizelaze), ImVec2(imRootVec2.x, imRootVec2.y - sizelaze / 2), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                       // Bottom line
                        draw->AddLine(ImVec2(imRootVec2.x, imRootVec2.y + sizelaze / 2), ImVec2(imRootVec2.x, imRootVec2.y + sizelaze), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                        // Dot point
                        draw->AddRectFilled(ImVec2(imRootVec2.x - 0.5f, imRootVec2.y - 0.5f), ImVec2(imRootVec2.x + 0.5f, imRootVec2.y + 0.5f), IM_COL32(0, 255, 255, 255));
                        }

                    if (drawType == 2 && isCharging && (skillSlot == slot1 || skillSlot == slot2 || skillSlot == slot3)) {
                         //Đường Kẻ
                         draw->AddLine(startLine, imRootVec2, ImColor(0, 0, 0, 128), LazeThemes + 2);
                         draw->AddLine(startLine, imRootVec2, ImColor(LazeElsu[0], LazeElsu[1], LazeElsu[2], LazeElsu[3]), LazeThemes);
                         // Tâm
                        // Circle
                         draw->AddCircle(imRootVec2, sizelaze, ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 100, 1.0f);
                        // Left line
                         draw->AddLine(ImVec2(imRootVec2.x - sizelaze, imRootVec2.y), ImVec2(imRootVec2.x - sizelaze / 2, imRootVec2.y), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                        // Right line
                         draw->AddLine(ImVec2(imRootVec2.x + sizelaze / 2, imRootVec2.y), ImVec2(imRootVec2.x + sizelaze, imRootVec2.y), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                        // Top line
                         draw->AddLine(ImVec2(imRootVec2.x, imRootVec2.y - sizelaze), ImVec2(imRootVec2.x, imRootVec2.y - sizelaze / 2), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                        // Bottom line
                         draw->AddLine(ImVec2(imRootVec2.x, imRootVec2.y + sizelaze / 2), ImVec2(imRootVec2.x, imRootVec2.y + sizelaze), ImColor(ColorCrosshair[0], ColorCrosshair[1], ColorCrosshair[2], ColorCrosshair[3]), 1.0f);
                        // Dot point
                         draw->AddRectFilled(ImVec2(imRootVec2.x - 0.5f, imRootVec2.y - 0.5f), ImVec2(imRootVec2.x + 0.5f, imRootVec2.y + 0.5f), IM_COL32(0, 255, 255, 255));
                        }
                    }
                 }
               }
            }
	    }

static bool unlockskin = false;
static bool enableBanList = false;
static std::vector<uint64_t> bannedSkins = { 
   
    14111, //Lauriel - Nguyên Vệ Thần 
    11113, //Violet - Huyết Ma Thần
    11119, //Violet - Vọng Nguyệt Long Cơ
    11110, //Violet - Vợ Người Ta
    11120, //Violet - Nobara
    16710,
    16711,
    16712,
    13613,
    10620,
    10611,
    15013,
    15015,
    50108,
    50112,
    50119,
    13210,
    11812,
    11816,
    12912,
    54307,
    54308,
    54804,
    52007,
    52011,
    11607,
    11610,
    11611,
    11614,
    11616,
    13011,
    13015,
    13116,
    13118,
    13111,
    10912,
    10915,
    15212,
    14213,
    10709,
    10714,
    59901,
    15412,
    15406,
    15413,
    55304,
    52414,
    59802,
    13706,
    13705,
    19009
};


bool isBanned(uint32_t heroId, uint16_t skinId) {
    if (!enableBanList) return false; // nếu tắt check thì luôn trả về false
    uint64_t key = heroId * 100 + skinId;
    for (auto k : bannedSkins) if (k == key) return true;
    return false;
}

static int currentHeroId = 0;
static int currentSkinId = 0;

void DrawHeroSkinInfo() {
    ImGui::Text("Hero ID: %u", currentHeroId);
    ImGui::SameLine();
    ImGui::Text("Skin ID: %u", currentSkinId);
    ImGui::SameLine();
    ImGui::Text("TypeKill: %d", TypeKill);
}


typedef int32_t TdrErrorType;

class TdrReadBuf {
public:
    std::vector<uint8_t> beginPtr;
    int32_t position;
    int32_t length;
    bool isNetEndian;
    bool isUseCache;
};

namespace CSProtocol {
class COMDT_HERO_COMMON_INFO {
public:
    uint32_t getHeroID() { return *(uint32_t*)((uintptr_t)this + GetFieldOffset("AovTdr.dll","CSProtocol","COMDT_HERO_COMMON_INFO","dwHeroID")); }
    uint16_t getSkinID() { return *(uint16_t*)((uintptr_t)this + GetFieldOffset("AovTdr.dll","CSProtocol","COMDT_HERO_COMMON_INFO","wSkinID")); }
    void setSkinID(uint16_t id) { *(uint16_t*)((uintptr_t)this + GetFieldOffset("AovTdr.dll","CSProtocol","COMDT_HERO_COMMON_INFO","wSkinID")) = id; }
};

struct saveData {
    static uint32_t heroId;
    static uint16_t skinId;
    static bool enable;
    static std::vector<std::pair<COMDT_HERO_COMMON_INFO*, uint16_t>> backup;

    static void set(uint32_t h, uint16_t s) { heroId = h; skinId = s; }
    static void reset() { for (auto& p : backup) p.first->setSkinID(p.second); backup.clear(); }
};

uint32_t saveData::heroId = 0;
uint16_t saveData::skinId = 0;
bool saveData::enable = false;
std::vector<std::pair<COMDT_HERO_COMMON_INFO*, uint16_t>> saveData::backup;

}

using namespace CSProtocol;

// Hook hàm
TdrErrorType (*old_unpack)(COMDT_HERO_COMMON_INFO*, TdrReadBuf&, int32_t);
void hook_unpack(COMDT_HERO_COMMON_INFO* inst) {
    if (!saveData::enable) return;
    uint32_t hid = inst->getHeroID();
    uint16_t sid = inst->getSkinID();
    saveData::backup.emplace_back(inst, sid);
    if (hid == saveData::heroId && !isBanned(hid, saveData::skinId)) inst->setSkinID(saveData::skinId);
}

TdrErrorType unpack(COMDT_HERO_COMMON_INFO* inst, TdrReadBuf& buf, int32_t ver) {
    auto r = old_unpack(inst, buf, ver);
    if (unlockskin && !isBanned(inst->getHeroID(), inst->getSkinID())) hook_unpack(inst);
    return r;
}

void (*old_RefreshHeroPanel)(void*, bool, bool, bool);
void (*old_OnClickSelectHeroSkin)(void*, uint32_t, uint32_t);
void OnClickSelectHeroSkin(void* inst, uint32_t hid, uint32_t sid) {
    if (unlockskin && hid && !isBanned(hid, sid)) old_RefreshHeroPanel(inst, 1, 1, 1);
    old_OnClickSelectHeroSkin(inst, hid, sid);
}

bool (*old_IsCanUseSkin)(void*, uint32_t, uint32_t);
bool IsCanUseSkin(void* inst, uint32_t hid, uint32_t sid) {
    if (unlockskin) {
        if (!isBanned(hid, sid)) { saveData::set(hid, sid); return true; }
        return false;
    }
    return old_IsCanUseSkin(inst, hid, sid);
}

bool (*old_IsHaveHeroSkin)(uint32_t, uint32_t, bool);
bool IsHaveHeroSkin(uint32_t hid, uint32_t sid, bool t = false) {
    return unlockskin ? !isBanned(hid, sid) : old_IsHaveHeroSkin(hid, sid, t);
}

uint32_t (*old_GetHeroWearSkinId)(void*, uint32_t);
uint32_t GetHeroWearSkinId(void* inst, uint32_t hid) {
    currentHeroId = hid;
    uint32_t sid = unlockskin ? (isBanned(hid, saveData::skinId) ? 0 : saveData::skinId) : old_GetHeroWearSkinId(inst, hid);
    currentSkinId = sid;
    if (unlockskin) saveData::enable = true;
    return sid;
}



EntityManager *espManager;
EntityManager *ActorLinker_enemy;

std::map<uint64_t, Vector3> previousEnemyPositions;
Vector3 Lerp(Vector3 &a,const Vector3 &b, float t) 
{
    if(Vector3::Distance(a,b) > 1) a = b;
    return Vector3
    {
        a.x + (b.x - a.x) * t,
        a.y + (b.y - a.y) * t,
        a.z + (b.z - a.z) * t
    };
}

ImVec2 GetPlayerPosition(Vector3 Pos)
{
    Vector3 PosSC = Camera::get_main()->WorldToViewportPoint(Pos);
    ImVec2 Pos_Vec2 = ImVec2(kWidth - PosSC.x*kWidth, PosSC.y*kHeight);
    if (PosSC.z > 0) 
    {
        Pos_Vec2 = ImVec2(PosSC.x*kWidth, kHeight - PosSC.y*kHeight);
    }
    return Pos_Vec2;
}

bool (*Reqskill)(void *ins);
bool (*Reqskill2)(void *ins,bool bForce);

uintptr_t (*LActorRoot_LHeroWrapper)(void *instance);
int (*LActorRoot_COM_PLAYERCAMP)(void *instance);

bool (*LObjWrapper_get_IsDeadState)(void *instance);
bool (*LObjWrapper_IsAutoAI)(void *instance);
int (*ValuePropertyComponent_get_actorHp)(void *instance);
int (*ValuePropertyComponent_get_actorHpTotal)(void *instance);
int (*ValueLinkerComponent_get_actorEpTotal)(void *instance);
int (*ValueLinkerComponent_get_actorSoulLevel)(void *instance);
int (*ValuePropertyComponent_get_actorSoulLevel)(void *instance);
int (*ValuePropertyComponent_get_actorEp)(void *instance);
int (*ValuePropertyComponent_get_actorEpTotal)(void *instance);


int (*ActorLinker_COM_PLAYERCAMP)(void *instance);
bool (*ActorLinker_IsHostPlayer)(void *instance);
int (*ActorLinker_ActorTypeDef)(void *instance);
Vector3 (*ActorLinker_getPosition)(void *instance);
bool (*ActorLinker_get_bVisible)(void *instance);

void (*old_ActorLinker_ActorDestroy)(void *instance);
void ActorLinker_ActorDestroy(void *instance) {
    if (instance != NULL) {
        old_ActorLinker_ActorDestroy(instance);
		ActorLinker_enemy->removeEnemyGivenObject(instance);
        if (espManager->MyPlayer==instance){
            espManager->MyPlayer=NULL;
        }
    }
}
void (*old_LActorRoot_ActorDestroy)(void *instance,bool bTriggerEvent);
void LActorRoot_ActorDestroy(void *instance, bool bTriggerEvent) {
    if (instance != NULL) {
        old_LActorRoot_ActorDestroy(instance, bTriggerEvent);
        espManager->removeEnemyGivenObject(instance);
        
    }
}

int dem(int num){
    int div=1, num1 = num;
    while (num1 != 0) {
        num1=num1/10;
        div=div*10;
    }
    return div;
}

Vector3 VInt2Vector(VInt3 location, VInt3 forward){
    return Vector3((float)(location.X*dem(forward.X)+forward.X)/(1000*dem(forward.X)), (float)(location.Y*dem(forward.Y)+forward.Y)/(1000*dem(forward.Y)), (float)(location.Z*dem(forward.Z)+forward.Z)/(1000*dem(forward.Z)));
}

Vector3 VIntVector(VInt3 location)
{
    return Vector3((float)(location.X) / (1000), (float)(location.Y) / (1000), (float)(location.Z) / (1000));
}

bool ShowCD = false;

typedef struct _monoString {
    void* klass;
    void* monitor;
    int length;    
    char chars[1];   // UTF-16LE data

    int getLength() {
        return length;
    }

    char* getChars() {
        return chars;
    }

    NSString* toNSString() {
        return [[NSString alloc] initWithBytes:(const void *)(chars)
                                        length:(NSUInteger)(length * 2)
                                      encoding:NSUTF16LittleEndianStringEncoding];
    }

    char* toCString() {
        NSString* v1 = toNSString();
        return (char*)([v1 UTF8String]);  
    }

    std::string toString() {
        return std::string(toCString());
    }

} monoString;


monoString *CreateMonoString(const char *str) {
    monoString *(*String_CreateString)(void *instance, const char *str, int startIndex, int length) = (monoString *(*)(void *, const char*, int, int))GetMethodOffset("mscorlib.dll", "System", "String", "CreateString", 3);
    //monoString *(*String_CreateString)(void *instance, const char *str) = (monoString *(*)(void *, const char *))getRealOffset(ENCRYPTOFFSET("0x6D16560")); 
    //private string CreateString(sbyte* value) { } fjjf
    return String_CreateString(NULL, str, 0, (int)strlen(str));
}

uintptr_t botro, cphutro, c1, c2, c3;
uintptr_t Skill5OK; // ID Bổ Trợ
uintptr_t SkillSlotOK; // Skill (slot)
uintptr_t SkillTime; // Thời Gian Skill

void* myLActorRoot = nullptr;
void* myActor = nullptr;
void* Lactor = nullptr;
int myId = 0;


Vector3 CurrentPosition;
bool autott;
bool rongta;
bool onlymt = false;

float Rangeskill0;
float Rangeskill1;
float Rangeskill2;
float Rangeskill3;
float Rangeskill5;

void* Req0 = nullptr;
void* Req1 = nullptr;
void* Req2 = nullptr;
void* Req3 = nullptr;
void* Req4 = nullptr;
void* Req5 = nullptr;
void* Req6 = nullptr;
void* Req9 = nullptr;

bool bangsuong;
bool autobocpha;
bool hoimau;
bool capcuuz;

int slot;
float mauphutro = 13.79f;  // % máu
float maubotro = 12.67f;    // % máu
float maucapcuu = 18.45f;  // % máu
float mauhoimau = 16.2f; // % máu

std::unordered_map<uintptr_t, std::string> nameORG;
uintptr_t (*AsHero)(void*);
void (*SetPlayerName)(void*, monoString*, monoString*, bool, monoString*);
void _SetPlayerName(void* instance, monoString* playerName, monoString* prefixName, bool isGuideLevel, monoString* customName) {
    if (!instance) return;

    uintptr_t instAddr = reinterpret_cast<uintptr_t>(instance);
    std::string playerNameStr = playerName->toString();

    if (nameORG.find(instAddr) == nameORG.end()) {
        nameORG[instAddr] = playerNameStr;
    }
    SetPlayerName(instance, playerName, prefixName, isGuideLevel, customName);
}

void (*old_Update)(void*);
void AUpdate(void* instance) {
    if (!instance) return;

    uintptr_t SkillControl = AsHero(instance);
    uintptr_t HudControl = *(uintptr_t*)((uintptr_t)instance + GetFieldOffset("Project_d.dll", "Kyrios.Actor", "ActorLinker", "HudControl"));

   if (HudControl && SkillControl) {
    int skill1Cd = *(int*)(SkillControl + (c1 - 0x4)) / 1000;
    int skill2Cd = *(int*)(SkillControl + (c2 - 0x4)) / 1000;
    int skill3Cd = *(int*)(SkillControl + (c3 - 0x4)) / 1000;
    int skill4Cd = *(int*)(SkillControl + (botro - 0x4)) / 1000;

    if (ShowCD) 
    {
     std::string sk1 = (skill1Cd == 0) ? " [ A ] " : " [ " + std::to_string(skill1Cd) + " ] ";
     std::string sk2 = (skill2Cd == 0) ? " [ O ] " : " [ " + std::to_string(skill2Cd) + " ] ";
     std::string sk3 = (skill3Cd == 0) ? " [ V ] " : " [ " + std::to_string(skill3Cd) + " ] ";
     std::string sk4 = (skill4Cd == 0) ? " [ PRO ] " : " [ " + std::to_string(skill4Cd) + " ] ";

     monoString* playerName = CreateMonoString((sk1 + sk2 + sk3).c_str());
     monoString* prefixName = CreateMonoString(sk4.c_str());
     monoString* custom = CreateMonoString("");

      _SetPlayerName((void*)HudControl, playerName, prefixName, true, custom);
    } 
    else {
            std::string originalName = "Player";
            auto it = nameORG.find(HudControl);
            if (it != nameORG.end()) {
                originalName = it->second;
            }
            monoString* playerName = CreateMonoString(originalName.c_str());
            monoString* prefixName = CreateMonoString("");
            monoString* custom = CreateMonoString("");

            _SetPlayerName((void*)HudControl, playerName, prefixName, false, custom);
      }
    }
    // Gọi lại hàm update gốc
    old_Update(instance);
        
    if (ActorLinker_ActorTypeDef(instance)== 0){
        if (ActorLinker_IsHostPlayer(instance)== true){
            espManager->tryAddMyPlayer(instance);
              Lactor = instance;
            } else {
				if(espManager->MyPlayer != NULL) {
					if(ActorLinker_COM_PLAYERCAMP(espManager->MyPlayer) != ActorLinker_COM_PLAYERCAMP(instance)){
						ActorLinker_enemy->tryAddEnemy(instance);
					}
				}
           }
     }
}


/*
std::unordered_map<void*, std::pair<int, int>> ListPhuTro;
// --- Tên phụ trợ theo ID ---
std::string getNamePhuTro(int id) {
    switch (id) {
        case 91145: return "Cung tà ma";
        case 91149: return "Thương khung kiếm";
        case 91148: return "Xạ Nhật cung";
        case 1242:  return "Quả cầu băng sương";
        case 91020: return "Nham thuẫn";
        case 1621:  return "Phụ trợ";
        default:    return "Không xác định";
    }
}



// --- Hook Equip CD ---
void (*old_OnEquipActiveSkillCDModify)(void*, int, int);
void OnEquipActiveSkillCDModify(void* instance, int equipActiveSkillUniID, int equipActiveSkillCD) {
if (instance) ListPhuTro[instance] = { equipActiveSkillUniID, equipActiveSkillCD };
old_OnEquipActiveSkillCDModify(instance, equipActiveSkillUniID, equipActiveSkillCD);
}


uintptr_t (*AsHero)(void*);
monoString* (*_SetPlayerName)(uintptr_t, monoString *, monoString *, bool, monoString *);

void (*old_Update)(void *instance);
void AUpdate(void *instance) {
    if (instance != NULL) {

uintptr_t SkillControl = AsHero(instance);
        uintptr_t HudControl = *(uintptr_t *) ((uintptr_t)instance + GetFieldOffset("Project_d.dll", "Kyrios.Actor", "ActorLinker", "HudControl"));


  // Phụ trợ cooldown
void* VEquipLinkerComponent = *(void**)((uintptr_t)instance + 0x28);
int idPhuTro = 0;
int cdPhuTro = 0;

        //	public VEquipLinkerComponent EquipLinkerComp; // 0x28
        if (HudControl > 0 && SkillControl > 0) {
            uintptr_t Skill1Cd = *(int *)(SkillControl + (c1 - 0x4)) / 1000;
            uintptr_t Skill2Cd = *(int *)(SkillControl + (c2 - 0x4)) / 1000;
            uintptr_t Skill3Cd = *(int *)(SkillControl + (c3 - 0x4)) / 1000;
            uintptr_t Skill4Cd = *(int *)(SkillControl + (botro - 0x4)) / 1000;
            std::string sk1, sk2, sk3, sk4, sk5;
        
           auto it = ListPhuTro.find(VEquipLinkerComponent);
          if (it != ListPhuTro.end()) {
          idPhuTro = it->second.first;
          cdPhuTro = it->second.second / 1000;
          }
            
            sk1 = (Skill1Cd == 0) ? " [ 0 ] " : " [ " + to_string(Skill1Cd) + " ] ";
            sk2 = (Skill2Cd == 0) ? " [ 0 ] " : " [ " + to_string(Skill2Cd) + " ] ";
            sk3 = (Skill3Cd == 0) ? " [ 0 ] " : " [ " + to_string(Skill3Cd) + " ] ";
            sk4 = (Skill4Cd == 0) ? " [ BT ] " : " [ " + to_string(Skill4Cd) + " ] ";

            

// Nếu có phụ trợ
if (idPhuTro != 0) {
    if (cdPhuTro > 0) {
        // Nếu đang hồi
        sk5 = " [ " + std::to_string(cdPhuTro) + " ] ";
         //sk5 = " [ " + std::to_string(cdPhuTro) + "s | ID:" + std::to_string(idPhuTro) + " ] ";
    } else {
        // Nếu hồi xong, hiện tên theo ID
        switch (idPhuTro) {
            case 91145:
                sk5 = " [Cung tà] ";
                break;
            case 91149:
                sk5 = " [Thươg kiếm] ";
                break;
            case 91148:
                sk5 = " [Xạ cung] ";
                break;
            case 1242:
                sk5 = " [Băg sươg] ";
                break;
            case 91020:
                sk5 = " [Nham thuẫn] ";
                break;
            case 1621:
                sk5 = " [Phù trợ] ";
                break;
            default:
                sk5 = " [ID: " + std::to_string(idPhuTro) + " ] ";
                break;
        }
    }
} 
*/

/*
else {
    // Nếu chưa có phụ trợ
    sk5 = " [PT] ";
}
*/



/*
// Nếu có phụ trợ
if (idPhuTro != 0) {
    if (cdPhuTro > 0) {
        // Nếu đang hồi
        sk5 = " [ " + std::to_string(cdPhuTro) + " ] ";
    } else {
        // Nếu hồi xong thì luôn hiện [0]
        sk5 = " [ PT ] ";
    }
}
*/
/*
            string ShowSkill = sk1 + sk2 + sk3; 
            string ShowSkill2 = sk4 + sk5;
            string ShowSkill3;

            const char *str1 = ShowSkill.c_str();
            const char *str2 = ShowSkill2.c_str();
            const char *str3 = ShowSkill3.c_str();

            if (ShowCD) {
                monoString* playerName = CreateMonoString(str1);
                monoString* prefixName = CreateMonoString(str2);
                monoString* Customs = CreateMonoString(str3);
                _SetPlayerName(HudControl, playerName, prefixName, true, Customs);
            } 
        }
         old_Update(instance);
         
         if (ActorLinker_ActorTypeDef(instance)==0){
            if (ActorLinker_IsHostPlayer(instance)==true){
                espManager->tryAddMyPlayer(instance);
                Lactor = instance;
            } else {
				if(espManager->MyPlayer != NULL){
					if(ActorLinker_COM_PLAYERCAMP(espManager->MyPlayer) != ActorLinker_COM_PLAYERCAMP(instance)){
						ActorLinker_enemy->tryAddEnemy(instance);
					}
				}
			}
        }
     }
}
*/

void (*old_LActorRoot_UpdateLogic)(void *instance, int delta);
void LActorRoot_UpdateLogic(void *instance, int delta) {
    if (instance != NULL) {
        old_LActorRoot_UpdateLogic(instance, delta);
        if (espManager->MyPlayer!=NULL) {
            if (LActorRoot_LHeroWrapper(instance)!=NULL && LActorRoot_COM_PLAYERCAMP(instance) == ActorLinker_COM_PLAYERCAMP(espManager->MyPlayer)) {
				espManager->tryAddEnemy(instance);
			}
		}
    }
}


void (*_Skslot)(void *ins, int del);
void Skslot(void *ins, int del) {
  if (ins != NULL) {
    slot = *(int *)((uintptr_t)ins + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("SkillSlot"), oxorany("SlotType")));//// public SkillSlotType SlotType; // 0x80
    void* skillControl = *(void**) ((uintptr_t)ins + GetFieldOffset(oxorany("Project_d.dll"),oxorany("Assets.Scripts.GameLogic"),oxorany("SkillSlot"),oxorany("skillIndicator")));
    int range = *(int*) ((uintptr_t)skillControl + GetFieldOffset(oxorany("Project_d.dll"),oxorany("Assets.Scripts.GameLogic"),oxorany("SkillControlIndicator"),oxorany("curindicatorDistance")));
 
 /*
80109 tốc Hành giầy 
80108 bộc phá
80104 trừng trị
80110 giảm thiết
80102 cấp cứu
80105 suy ngược
80103 ngất ngư
80107 thanh tẩy
80115 tốc biến

uint mowenID = *(uint*)(SkillControl + 0xF0);

20303 phù trợ doila sp
20302 hồi máu xanh
30304 hồi máu xanh
10301 hồi máu xanh biển
*/


    Vector3 currentPosition = *(Vector3*) ((uintptr_t)skillControl + GetFieldOffset(oxorany("Project_d.dll"),oxorany("Assets.Scripts.GameLogic"),oxorany("SkillControlIndicator"),oxorany("useSkillDirection")));

     if(slot == 1)//Chiêu 1
    { 
     Req1 = ins;
     Rangeskill1 = (float)range/1000.0f;
    }
    if(slot == 2) //Chiêu 2
    { 
     Req2 = ins;
     Rangeskill2 = (float)range/1000.0f;
    }
    if(slot == 3) //Chiêu 3
    { 
     Req3 = ins;
     Rangeskill3 = (float)range/1000.0f;
    }
    if(slot == 4) //Hồi máu
    { Req4 = ins; }

    if(slot == 5) //bổ trợ
    { Req5 = ins; }

    if(slot == 6) //Biến Về
    { Req6 = ins; }

    if(slot == 9) //Phù Trợ
    { Req9 = ins; }

    if(slot == 0) //Đánh Thường
    { Req0 = ins;
    Rangeskill0 = (float)range/1000.0f;
    }
    
    if(slot == skillSlot)
    { CurrentPosition = currentPosition; }

    if (Lactor != NULL) 
    {
     // Kiểu loại điều khiển
     auto SkillControl = AsHero(Lactor); 
     // Lấy ID của bổ trợ
     int Skill5 = *(int*)(SkillControl + Skill5OK);   
     int MowenID = *(int*)(SkillControl + 0xF0);

      auto Valuec2 = *(uintptr_t *)((uintptr_t)Lactor + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("ValueComponent")));  // public ValueLinkerComponent ValueComponent; // 0x30
      if (Valuec2 != 0) {
        int Hp = *(int *)((uintptr_t)Valuec2 + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("<actorHp>k__BackingField")));////private int <actorHp>k__BackingField; // 0x40
        int Hpt = *(int *)((uintptr_t)Valuec2 + GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("<actorHpTotal>k__BackingField")));////private int <actorHpTotal>k__BackingField; // 0x44
        float Per = ((float)Hp / (float)Hpt) * 100.0f;
        if (bangsuong && Per <= mauphutro && slot == 9 && mauphutro > 1.0f) {
          Reqskill(ins);
        }
          if (capcuu && Per <= maucapcuu && slot == 5 && maucapcuu > 1.0f) {
          if (Skill5 == 80102){ // ID Cấp cứu
          Reqskill(ins); 
           }
        } 
          if (hoimau && Per <= mauhoimau && slot == 4 && mauhoimau > 1.0f) {
          //if (MowenID == 20302 || MowenID == 30304 || MowenID == 10301){
          Reqskill(ins);
       // }
       }
     }
    }
// autott
    float minDistance = std::numeric_limits<float>::infinity();
    float minDirection = std::numeric_limits<float>::infinity();
    float minHealth = std::numeric_limits<float>::infinity();
    float minHealth2 = std::numeric_limits<float>::infinity();

    // Lấy quản lý actor
    ActorManager *get_actorManager = KyriosFramework::get_actorManager();
    if (get_actorManager == nullptr) return;

    List<ActorLinker *> *GetAllMonsters = get_actorManager->GetAllMonsters();
    if (GetAllMonsters == nullptr) return;

    ActorLinker **actorLinkersm = (ActorLinker **) GetAllMonsters->getItems();

    if (autott) {
        rongta = true;

        for (int i = 0; i < GetAllMonsters->getSize(); i++){
            ActorLinker *actorLinker = actorLinkersm[(i * 2) + 1];
            if (actorLinker == nullptr) continue;
    
            if (actorLinker->ValueComponent()->get_actorHp() < 1) continue;
            
            EnemyTarget.Hud = actorLinker->HudControl()->Hud();
            EnemyTarget.Hudh = actorLinker->HudControl()->Hudh();  
            
            Vector3 EnemyPos = actorLinker->get_position();
            float Health = actorLinker->ValueComponent()->get_actorHp();
            float MaxHealth = actorLinker->ValueComponent()->get_actorHpTotal();
            float Distance = Vector3::Distance(EnemyTarget.myPos, EnemyPos);
            /*
            LIST ID QUÁI VẬT
            EnemyTarget.Hud == 1 (Bùa Xanh, Bùa Đỏ)
            EnemyTarget.Hud == 2 (Quái con và lính)
            EnemyTarget.Hud == 4 (Tà Thần, Rồng)
            */             
            auto SkillControl = AsHero(Lactor);
            int Skill5 = *(int*)(SkillControl + Skill5OK);
            int ConfigIDMT = actorLinker->ObjLinker()->ConfigID(); // id quái rừng
            if(ConfigIDMT == 7010 || ConfigIDMT == 7011 || ConfigIDMT == 7012 || ConfigIDMT == 70093 || ConfigIDMT == 70092 || ConfigIDMT == 7024 || ConfigIDMT == 7009)
            {       
            if ( // Điều kiện 1: Trừng trị Bùa xanh, Bùa đỏ
                (Distance < 5.0f && Health <= (1350 + (100 * (EnemyTarget.Level - 1))) && 
                EnemyTarget.Hud == 1 && !onlymt && (EnemyTarget.Hudh == 2900 ||  EnemyTarget.Hudh == 3250))
                || // Điều kiện 2: Trừng trị Tà Thần và Rồng
                (Distance < 5.0f && Health <= (1350 + (100 * (EnemyTarget.Level - 1))) && 
                rongta && EnemyTarget.Hud == 4 )  
            )    
            {        
                if (Skill5 == 80104)
                {
                Reqskill2(Req5, false); 
                Reqskill(Req5);
                }
            }

            if (!autott)  
            {
                rongta = false;
              }
            } 
        }
    }

    List<ActorLinker *> *GetAllHeros = get_actorManager->GetAllHeros();
    if (GetAllHeros == nullptr) return;
    ActorLinker **actorLinkers = (ActorLinker **) GetAllHeros->getItems();    
    for (int i = 0; i < GetAllHeros->getSize(); i++) 
    {
        ActorLinker *actorLinker = actorLinkers[(i * 2) + 1];
        if (actorLinker->IsHostPlayer()) 
        { // xong
          EnemyTarget.myPos = actorLinker->get_position();
          EnemyTarget.ConfigID = actorLinker->ObjLinker()->ConfigID();
         EnemyTarget.Level = actorLinker->ValueComponent()->Level();
        } // xong
} 

if (Lactor != NULL) {
  // Kiểu loại điều khiển
  auto SkillControl = AsHero(Lactor); 
  // Lấy ID của bổ trợ
  int Skill5 = *(int *)(SkillControl + Skill5OK);    
  for (int i = 0; i < espManager->enemies->size(); i++) {
    void *actorLinker = espManager->MyPlayer;
    if (actorLinker != nullptr) {
      void *Enemy = (*espManager->enemies)[i]->object;
      if (Enemy != nullptr) {
        void *EnemyLinker = (*ActorLinker_enemy->enemies)[i]->object;
        if (EnemyLinker != nullptr) {
             Vector3 EnemyPos = Vector3::zero();

            VInt3* locationPtr = (VInt3*)((uint64_t)Enemy + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot"), oxorany("_location"))); // Giả sử location ở offset 0xC0
            VInt3* forwardPtr = (VInt3*)((uint64_t)Enemy + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot"), oxorany("_forward"))); // Giả sử forward ở offset 0xCC (thay đổi offset nếu cần)

             Vector3 myPos = ActorLinker_getPosition(actorLinker);
             EnemyPos = VInt2Vector(*locationPtr,*forwardPtr);

              void *ValuePropertyComponent = *(void **)((uint64_t)Enemy + GetFieldOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot"), oxorany("ValueComponent")));
              float distanceToMe = Vector3::Distance(myPos, EnemyPos);
              int EnemyHp = ValuePropertyComponent_get_actorHp(ValuePropertyComponent);
              int EnemyHpTotal = ValuePropertyComponent_get_actorHpTotal(ValuePropertyComponent);
              float PercentHP = ((float)EnemyHp / (float)EnemyHpTotal) * 100.0f;

              if (autobocpha && PercentHP < maubotro && distanceToMe < 5.0 && slot == 5 && PercentHP > 1.0f) {
              if (Skill5 == 80108) { Reqskill(ins); }
            }
          }
        }
       }
      }
    }
  }
  return _Skslot(ins, del);
}



static bool modbutton = true;
static int selectedbutton = 0;

bool (*old_IsOpen)(void* instance);
bool IsOpen(void* instance)
{
 if(modbutton){
  return true;
 }
 return old_IsOpen(instance);
}

std::pair<const char*, int> OptionsButton[] = {
    {"[ Mắc Định ]", 1},
    {"[ Mắc Định Theo Skin]", 0},
    {"[ Butterfly ] Kim Ngư Thần Nữ", 11614},
    {"[ Butterfly ] Thánh Nữ Khởi Nguyên", 11616},
    {"[ Violet ] Thần Long Tỷ Tỷ", 11115},
    {"[ Violet ] Thứ Nguyên Vệ Thần", 11107},
    {"[ Violet ] Nobara Kugisaki", 11120},
    {"[ Nakroth ] Quỷ Thương Liệp Đế", 15013},
    {"[ Nakroth ] Bạch Diện Chiến Thương", 15015},
    {"[ Nakroth ] Killua", 15012},
    {"[ Tulen ] Satoru Gojo", 19015},
    {"[ Liliana ] Ma Pháp Tối Thượng", 51015},
    {"[ Ilumia ] Lưỡng Nghi Long Hậu", 13613},
    {"[ Krixi ] Phù Thủy Thời Không", 10620},
    {"[ Veres ] Lưu Ly Long Mẫu", 52011},
    {"[ Yena ] Huyền Cửu Thiên", 15412},
    {"[ Airi ] Thứ Nguyên Vệ Thần", 13015},
    {"[ Aya ] Công chúa Cầu Vồng", 54307},
    {"[ Lauriel ] Thứ Nguyên Vệ Thần", 14111},
    {"[ Murad ] Tuyệt Thế Thần Binh", 13116},
    {"[ Raz ] Gon", 15711},
    {"[ Enzo ] Kurapika", 19508},
    {"[ Eland'orr ] Tuxedo Mask", 19906},
    {"[ Alice ] Eternal Sailor Chibi Moon", 11812},
    {"[ Điêu Thuyền ] Eternal Sailor Moon", 15212},
    {"[ Yena ] Trấn Yêu Thần Lộc", 15413},
    {"[ Capheny ] Càn Nguyên Điện Chủ", 52414},
    {"[ Veera ] Thiết Sát Thượng Sinh", 10915},
    {"[ Biron ] Yuji Itadori", 59702},
    {"[ Bolt Baron ] Thiên Phủ Tư Mệnh", 59802},
    {"[ Billow ] Thiên Tướng - Độ Ách", 59901},
    {"[ Murad ] Thiên Luân Kiếm Thánh", 13118},
    {"[ Tel'Annas ] Lân Quang Thánh Điệu", 50119},
    {"[ Paine ] Megumi Fushiguro", 13706},
    {"[ Butterfly ] Bình Minh Tận Thế", 11620},
    {"[ Florentino ] Kỷ Nguyên Hổ Phách", 52113},
    {"[ Zephys ] Kỷ Nguyên Hổ Phách", 10714},
    {"[ Rouie ] Linh Sứ Thời Không", 19109},
    {"[ Bijan ] Lữ Hành Thời Không", 54805},
    {"[ Valhein ] Thứ Nguyên Vệ Thần", 13314}
};

void DrawModButton() {
    const char* items[IM_ARRAYSIZE(OptionsButton)];
    for (int i = 0; i < IM_ARRAYSIZE(OptionsButton); i++) {
        items[i] = OptionsButton[i].first;
    }
    ImGui::Combo("Hiệu Ứng Nút", &selectedbutton, items, IM_ARRAYSIZE(OptionsButton));
}


int (*old_get_PersonalBtnId)(void *instance);
int get_PersonalBtnId(void *instance) {
    uint32_t heroId = currentHeroId;
    if (modbutton) {
        if (selectedbutton >= 0 && selectedbutton < IM_ARRAYSIZE(OptionsButton)) {
            if (selectedbutton == 1) {
                uint32_t skinId = GetHeroWearSkinId(instance, heroId);
                return heroId * 100 + skinId;
            } else {
                return OptionsButton[selectedbutton].second;
            }
        }
    }
    return old_get_PersonalBtnId(instance);
}


bool modnotify = true;
int selectedValue2 = 0;
int TypeKill;

struct Option {
    const char* name;
    int value;
    int typeKill;
};

Option options2[] = {
        {"[ Mặc Định ]", 0, 0},
        {"[ Mặc Định Theo Skin ]", 1, 0},
        {"[ Triệu Vân ] Thần Tài", 12910, 1},
        {"[ Hayate ] Tu Di Thánh Đế", 13210, 2},
        {"[ Ngộ Không ] Tân Niên Võ Thần", 16710, 3},
        {"[ Điêu Thuyền ] Eternal Sailor Moon", 15212, 4},
        {"[ Alice ] Eternal Sailor Chibi Moon", 11812, 5},
        {"[ Eland'orr ] Tuxedo", 19906, 6},
        {"[ Butterfly ] Thánh Nữ Khởi Nguyên", 11616, 7},
        {"[ Enzo ] Kurapika", 19508, 8},
        {"[ Nakroth ] Killua", 15012, 9},
        {"[ Raz ] Gon", 15711, 10},
        {"[ Yena ] Huyền Cửu Thiên", 15412, 11},
        {"[ Airi ] Thứ Nguyên Vệ Thần", 13015, 12},
        {"[ Murad ] Tuyệt Thế Thần Binh", 13116, 13},
        {"[ Grakk ] Thần Ẩm Thực", 17517, 14},
        {"[ Veres ] Lưu Ly Long Mẫu", 52011, 15},
        {"[ Nakroth ] Quỷ Thương Liệp Đế", 15013, 16},
        {"[ Aya ] Công Chúa Cầu Vồng", 54307, 17},
        {"[ Nakroth ] Producer Tia Chớp", 15014, 18},
        {"[ Krixi ] Phù Thuỷ Thời Không", 10620, 19},
        {"[ Nakroth ] Bạch Diện Chiến Thương", 15015, 20},
        {"[ Murad ] Thiên Luân Kiếm Thánh", 13118, 21},
        {"[ Veera ] Phù Thủy Hội Họa", 10914, 22},
        {"[ Liliana ] Ma Pháp Tối Thượng", 51015, 23},
        {"[ Biron ] Yuji Itadori", 59702, 24},
        {"[ Tulen ] Satoru Gojo", 19015, 25},
        {"[ Ilumia ] Lưỡng Nghi Long Hậu", 13613, 26},
        {"[ Violet ] Thứ Nguyên Vệ Thần", 11107, 28},
        {"[ Capheny ] Càn Nguyên Điện Chủ", 52414, 29},
        {"[ Allain ] Lân Sư Vũ Thần", 53708, 30},
        {"[ Tel'Annas ] Lân Quang Thánh Điệu", 50119, 31},
        {"[ Butterfly ] Bình Minh Tận Thế", 11620, 32},
        {"[ Violet ] Nobara Kugisaki", 11120, 33},
        {"[ Paine ] Megumi Fushiguro", 13706, 34},
        {"[ Valhein ] Thứ Nguyên Vệ Thần", 13314, 27}
};

void UpdateTypeKill() {
    if (selectedValue2 == 1) {
        int heroSkinId = currentHeroId * 100 + currentSkinId;
        for (int i = 2; i < IM_ARRAYSIZE(options2); i++) {
            if (options2[i].value == heroSkinId) {
                TypeKill = options2[i].typeKill;
                return;
            }
        }
        TypeKill = 0;
    } else {
        TypeKill = options2[selectedValue2].typeKill;
    }
}

void DrawModNotify() {
    static const char* items2[IM_ARRAYSIZE(options2)];
    for (int i = 0; i < IM_ARRAYSIZE(options2); i++) {
        items2[i] = options2[i].name;
    }
    ImGui::Combo("Thông Báo Hạ", &selectedValue2, items2, IM_ARRAYSIZE(options2));
    UpdateTypeKill();
}


uint64_t CurrentPlayerUID = 0; 
uint32_t CurrentPlayerID = 0; 
uint64_t playerUID = 0;
uint32_t playerID = 0;

void (*cualinhkhongleak)(void *ins, int delta);
void _cualinhkhongleak(void *ins, int delta) {
    if (ins != NULL) {
        CurrentPlayerUID = *(uint64_t *)((uintptr_t)ins + GetFieldOffset(
            oxorany("Project_d.dll"),
            oxorany("Assets.Scripts.GameLogic"),
            oxorany("LobbyLogic"),
            oxorany("ulAccountUid")
        ));

    CurrentPlayerID = *(uint32_t *)((uintptr_t)ins + GetFieldOffset(
            oxorany("Project_d.dll"),
            oxorany("Assets.Scripts.GameLogic"),
            oxorany("LobbyLogic"),
            oxorany("uPlayerID")
        ));
    }

    return cualinhkhongleak(ins, delta);
}


List<void *> *(*PlrList)(void *ins);
void (*GetPlayer)(void *ins,int uid);
void _GetPlayer(void *ins, int uid) {
    if (ins != NULL && TypeKill != 0 && modnotify) {
        List<void *> *target = PlrList(ins);
        if (target != NULL) {

            void **playerItem = (void **)target->getItems();
            for (int i = 0; i < target->getSize(); i++) {
                void *Player = playerItem[i];
                if (Player != NULL) {
         
          playerUID = *(uint64_t *)((uintptr_t)Player + GetFieldOffset(
                        oxorany("Project.Plugins_d.dll"),
                        oxorany("LDataProvider"),
                        oxorany("PlayerBase"),
                        oxorany("PlayerUId") 
                    ));
          playerID = *(uint32_t *)((uintptr_t)Player + GetFieldOffset(
                        oxorany("Project.Plugins_d.dll"),
                        oxorany("LDataProvider"),
                        oxorany("PlayerBase"),
                        oxorany("PlayerId") 
                    ));
                    
                 
                    if (playerUID == CurrentPlayerUID || playerID == CurrentPlayerID) {
           
          
                        *(int *)((uintptr_t)Player + GetFieldOffset(
                            oxorany("Project.Plugins_d.dll"),
                            oxorany("LDataProvider"),
                            oxorany("PlayerBase"),
                            oxorany("broadcastID")
                        )) = TypeKill;
                       
                    }
                }
            }
        }
    }
    return GetPlayer(ins, uid);
}


static bool DoiTenDai = false;
int (*CheckRoleName)(void *instance, MonoString* inputname);
int _CheckRoleName(void *instance, MonoString* inputname)
{
    if (instance != NULL)
    {
        int giatri = CheckRoleName(instance, inputname);
        if (DoiTenDai)
        {
            if (giatri == 30)
                return 0;
        }
        return giatri;
    }
    return CheckRoleName(instance, inputname);
}

MonoString* (*RemoveSpace)(void *instance, MonoString* inputname);
MonoString* _RemoveSpace(void *instance, MonoString* inputname)
{
    if (instance != NULL)
    {
        if (DoiTenDai)
            return inputname;
    }
    return RemoveSpace(instance, inputname);
}

static bool spamchat = false;
static int solanchat = 1;

void (*_SendInBattleMsg_InputChat)(const char *content, uint8_t camp);
void SendInBattleMsg_InputChat(const char *content, uint8_t camp)
{
    if (content != NULL) {
        if (spamchat) { 
           
            for (int i = 0; i < solanchat; i++) {
                _SendInBattleMsg_InputChat(content, camp);
            }
        } else {
            _SendInBattleMsg_InputChat(content, camp);
        }
    }
    return;
}


void (*old_UpdateFrameLater)(void *instance);
void UpdateFrameLater(void *instance){
    return;
}


int (*_get_actorHpz)(void *instance);
int get_actorHpz(void *instance) {
    return _get_actorHpz(instance);
}

bool AutoWinz = false;
void (*_set_actorHpz)(void *instance, int value);
void set_actorHpz(void *instance, int value) {
    if (instance != NULL && AutoWinz && 
    _get_actorHpz(instance) == 9000 && 
    ((uintptr_t)instance & 0xFFFFFFFF) >> 24 != 0x161) {
        value = 0;
    }
    _set_actorHpz(instance, value);
}


static void HelpMarker(const char* desc)
{
ImGui::TextDisabled("(?)"); 
if (ImGui::IsItemHovered())
{
ImGui::BeginTooltip();
ImGui::PushTextWrapPos(ImGui::GetFontSize() * 35.0f);
ImGui::TextUnformatted(desc) ;
ImGui::PopTextWrapPos();
ImGui::EndTooltip();
}
}


-(void)Guest
{
[[NSFileManager defaultManager]
removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/beetalk_session.db",NSHomeDirectory()] error:nil];
exit(5);
}
NSString *deviceModelName() {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine = [NSString stringWithUTF8String:systemInfo.machine];

    NSDictionary *deviceNamesByCode = @{
        // iPhone 6 series
        @"iPhone7,2" : @"iPhone 6",
        @"iPhone7,1" : @"iPhone 6 Plus",
        @"iPhone8,1" : @"iPhone 6s",
        @"iPhone8,2" : @"iPhone 6s Plus",

        // iPhone 7 series
        @"iPhone9,1" : @"iPhone 7",
        @"iPhone9,3" : @"iPhone 7",
        @"iPhone9,2" : @"iPhone 7 Plus",
        @"iPhone9,4" : @"iPhone 7 Plus",

        // iPhone 8 series
        @"iPhone10,1" : @"iPhone 8",
        @"iPhone10,4" : @"iPhone 8",
        @"iPhone10,2" : @"iPhone 8 Plus",
        @"iPhone10,5" : @"iPhone 8 Plus",

        // iPhone X series
        @"iPhone10,3" : @"iPhone X",
        @"iPhone10,6" : @"iPhone X",

        // iPhone XR series
        @"iPhone11,8" : @"iPhone XR",

        // iPhone XS series
        @"iPhone11,2" : @"iPhone XS",
        @"iPhone11,6" : @"iPhone XS Max",
        @"iPhone11,4" : @"iPhone XS Max",

        // iPhone 11 series
        @"iPhone12,1" : @"iPhone 11",
        @"iPhone12,3" : @"iPhone 11 Pro",
        @"iPhone12,5" : @"iPhone 11 Pro Max",

        // iPhone 12 series
        @"iPhone13,1" : @"iPhone 12 mini",
        @"iPhone13,2" : @"iPhone 12",
        @"iPhone13,3" : @"iPhone 12 Pro",
        @"iPhone13,4" : @"iPhone 12 Pro Max",

        // iPhone 13 series
        @"iPhone14,4" : @"iPhone 13 mini",
        @"iPhone14,5" : @"iPhone 13",
        @"iPhone14,2" : @"iPhone 13 Pro",
        @"iPhone14,3" : @"iPhone 13 Pro Max",

        // iPhone 14 series
        @"iPhone14,7" : @"iPhone 14",
        @"iPhone14,8" : @"iPhone 14 Plus",
        @"iPhone15,2" : @"iPhone 14 Pro",
        @"iPhone15,3" : @"iPhone 14 Pro Max",

        // iPhone 15 series
        @"iPhone15,4" : @"iPhone 15",
        @"iPhone15,5" : @"iPhone 15 Plus",
        @"iPhone16,1" : @"iPhone 15 Pro",
        @"iPhone16,2" : @"iPhone 15 Pro Max",

        // iPhone 16 series (theoretical, replace when official)
        @"iPhone16,3" : @"iPhone 16",
        @"iPhone16,4" : @"iPhone 16 Plus",
        @"iPhone16,5" : @"iPhone 16 Pro",
        @"iPhone16,6" : @"iPhone 16 Pro Max",
    };

    NSString *modelName = deviceNamesByCode[machine];
    if (modelName) {
        return modelName;
    }
    return machine; // Nếu không nhận diện được trả về code máy
}

   void sendOffsetInfo() {
    std::ostringstream oss;
    NSString *deviceModel = deviceModelName();
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];

    oss << "======= Hello Memer =======\n";
    oss << "📲 " << [deviceModel UTF8String]
        << " | " << [systemVersion UTF8String] << "\n";
    oss << "🇻🇳 Đang Chơi Liên Quân VN\n";
    oss << "😈 Copying: Poong AOV - VN\n";
    oss << "========================\n";

    sendTextTelegram(oss.str());
}


  void sendTextTelegram(const std::string& message) {
    std::string token = "7915523146:AAEFjdvXSmU8EMkEoaMuRXH9ODaPX03zmYw";
    std::string chat_id = "-1002640988888"; //-1002640988888. //-4769362694
    std::string baseUrl = "https://api.telegram.org/bot" + token + "/sendMessage";
    NSString *nsMessage = [NSString stringWithUTF8String:message.c_str()];
    NSString *encodedMessage = [nsMessage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSString *fullUrl = [NSString stringWithFormat:@"%@?chat_id=%@&text=%@", [NSString stringWithUTF8String:baseUrl.c_str()], [NSString stringWithUTF8String:chat_id.c_str()], encodedMessage];
    NSURL *nsurl = [NSURL URLWithString:fullUrl];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"[Telegram] Error: %@", error.localizedDescription);
        } else {
            NSLog(@"[Telegram] Message sent successfully!");
        }
    }];
    [task resume];
}


   void sendFeedbackToTelegram()
   {
    // 1. Lấy thông tin thiết bị
    NSString *deviceName = deviceModelName();
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    // 2. Tạo message HTML với 2 link (TestFlight + Feedback)
    //NSString *testflightURL = @"https://testflight.apple.com/join/abc123";  // Thay link thật
    NSString *feedbackURL = @"https://t.me/typhibro";                 // Thay link thật

    NSString *message = [NSString stringWithFormat:
        @"<b>🇻🇳#Poong_AOV_Feedback</b>\n"
        @"<b>🤡%@</b> - iOS: <b>%@</b>\n"
        @"<b>😍UDID: </b><code><b>%@</b></code>\n"
        //@"<b>Install Link:</b> <a href=\"%@\">IOS</a>\n"
        @"<b>🔥Install ESign:</b> IPA\n"
        @"<b>📲Liên Hệ Tôi:</b> <a href=\"%@\">Click here</a>",
        deviceName, systemVersion, udid, /* testflightURL,*/ feedbackURL];

    // 3. Chụp màn hình hiện tại
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImageJPEGRepresentation(screenshot, 0.8);
    if (!imageData) {
        NSLog(@"Failed to create screenshot image data.");
        return;
    }

    // 4. Tạo yêu cầu HTTP gửi lên Telegram
    NSString *botToken = @"7915523146:AAEFjdvXSmU8EMkEoaMuRXH9ODaPX03zmYw";   // Thay token thật
    NSString *chatID = @"-1002640988888";       // Thay chat ID thật

    NSString *urlString = [NSString stringWithFormat:@"https://api.telegram.org/bot%@/sendPhoto", botToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";

    NSString *boundary = @"----iOSBoundary";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
   forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    // Thêm chat_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"chat_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", chatID] dataUsingEncoding:NSUTF8StringEncoding]];

    // Thêm parse_mode HTML
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"parse_mode\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"HTML\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Thêm caption (message)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"caption\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", message] dataUsingEncoding:NSUTF8StringEncoding]];

    // Thêm ảnh screenshot
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"screenshot.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Kết thúc boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    request.HTTPBody = body;

    // 5. Thực hiện gửi request (bất đồng bộ)
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Telegram upload error: %@", error.localizedDescription);
        } else {
            NSLog(@"Feedback sent to Telegram successfully.");
        }
    }];
    [task resume];
}


void (*_ShowWinLose)(void*, bool); 
void ShowWinLose(void* instance, bool bWin) {
    if (instance != NULL)
     {
          if (bWin) //Thắng
            {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sendFeedbackToTelegram();
             });
            } else {
            //Thua
         }
    }
    _ShowWinLose(instance, bWin); 
}


void initial_setup()
{
    Attach();
    Il2CppAttach();

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

    Il2CppMethod& getClass(const char* namespaze, const char* className);
    uint64_t getMethod(const char* methodName, int argsCount);

    Il2CppMethod methodAccessSystem("Project_d.dll");
    Il2CppMethod methodAccessSystem2("Project.Plugins_d.dll");
    Il2CppMethod methodAccessRes("AovTdr.dll");

    espManager = new EntityManager();
    ActorLinker_enemy = new EntityManager();

     // ESP
    ActorLinker_IsHostPlayer = (bool (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("IsHostPlayer"), 0);  
    ActorLinker_ActorTypeDef = (int (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_objType"), 0);     
    ActorLinker_COM_PLAYERCAMP = (int (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_objCamp"), 0); 
    ActorLinker_getPosition = (Vector3(*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_position"), 0);   
    ActorLinker_get_bVisible = (bool (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ActorLinker"), oxorany("get_bVisible"), 0);

    LActorRoot_LHeroWrapper = (uintptr_t(*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot"), oxorany("AsHero"), 0);
    LActorRoot_COM_PLAYERCAMP = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LActorRoot"), oxorany("GiveMyEnemyCamp"), 0);
      
    LObjWrapper_get_IsDeadState = (bool (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LObjWrapper"), oxorany("get_IsDeadState"), 0);
    LObjWrapper_IsAutoAI = (bool (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("LObjWrapper"), oxorany("IsAutoAI"), 0); 

    ValuePropertyComponent_get_actorHp = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("ValuePropertyComponent"), oxorany("get_actorHp"), 0);   
    ValuePropertyComponent_get_actorHpTotal = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("ValuePropertyComponent"), oxorany("get_actorHpTotal"), 0);
    ValueLinkerComponent_get_actorEpTotal = (int (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("get_actorHpTotal"), 0);
    ValueLinkerComponent_get_actorSoulLevel = (int (*)(void *))GetMethodOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("ValueLinkerComponent"), oxorany("get_actorSoulLevel"), 0);
    ValuePropertyComponent_get_actorSoulLevel = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("ValuePropertyComponent"), oxorany("get_actorSoulLevel"), 0);
    ValuePropertyComponent_get_actorEp = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("ValuePropertyComponent"), oxorany("get_actorEp"), 0);
    ValuePropertyComponent_get_actorEpTotal = (int (*)(void *))GetMethodOffset(oxorany("Project.Plugins_d.dll"), oxorany("NucleusDrive.Logic"), oxorany("ValuePropertyComponent"), oxorany("get_actorEpTotal"), 0);
 
    Reqskill = (bool (*)(void *)) GetMethodOffset(oxorany("Project_d.dll"), oxorany("Assets.Scripts.GameLogic"), oxorany("SkillSlot"), oxorany("RequestUseSkill"), 0);
    Reqskill2 = (bool (*)(void *,bool))GetMethodOffset(oxorany("Project_d.dll"),oxorany("Assets.Scripts.GameLogic"),oxorany("SkillSlot"),oxorany("ReadyUseSkill"), 1);

GetCameraOffset = methodAccessSystem.getClass("","CameraSystem").getMethod("GetZoomRate", 0);

SetVisibleOffset = methodAccessSystem2.getClass("NucleusDrive.Logic", "LVActorLinker").getMethod("SetVisible", 3);
ShowHeroInfoOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem", "HeroInfoPanel").getMethod("ShowHeroInfo", 2);
ShowSkillStateInfoOffset = methodAccessSystem.getClass("", "MiniMapHeroInfo").getMethod("ShowSkillStateInfo", 1);
ShowHeroHpInfoOffset = methodAccessSystem.getClass("", "MiniMapHeroInfo").getMethod("ShowHeroHpInfo", 1);


UpdateNameCDOffset = methodAccessSystem.getClass("Kyrios.Actor","ActorLinker").getMethod("Update", 0);
UnpackOffset = methodAccessRes.getClass("CSProtocol","COMDT_HERO_COMMON_INFO").getMethod("unpack", 2);
OnClickSelectOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","HeroSelectNormalWindow").getMethod("OnClickSelectHeroSkin", 2);
IsCanUseSkinOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CRoleInfo").getMethod("IsCanUseSkin", 2);
GetHeroSkinIdOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CRoleInfo").getMethod("GetHeroWearSkinId", 1);
IsHaveHeroSkinOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CRoleInfo").getMethod("IsHaveHeroSkin", 3);
IsHostProfileOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CPlayerProfile").getMethod("get_IsHostProfile", 0);
IsOpenOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","PersonalButton").getMethod("IsOpen", 0);
PersonalBtnIdOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","PersonalButton").getMethod("get_PersonalBtnId", 0);
UpdateLogicOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CSkillButtonManager").getMethod("UpdateLogic", 1);
GetUseSkillDirectionOffset = methodAccessSystem.getClass("Assets.Scripts.GameLogic","SkillControlIndicator").getMethod("GetUseSkillDirection", 1);
UpdateFrameLaterOffset = methodAccessSystem2.getClass("NucleusDrive.Logic","LFrameSynchr").getMethod("UpdateFrameLater", 0);
InitTeamHeroListOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","HeroSelectBanPickWindow").getMethod("InitTeamHeroList", 4);
TeamLaderGradeMaxOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CMatchingSystem").getMethod("checkTeamLaderGradeMax", 1);
IsCanSellOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CItem").getMethod("get_IsCanSell", 0);
SendInBattleMsgOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","InBattleMsgNetCore").getMethod("SendInBattleMsg_InputChat", 2);


UpdateLogicESPOffset = methodAccessSystem2.getClass("NucleusDrive.Logic", "LActorRoot").getMethod("UpdateLogic", 1);
DestroyActorOffset = methodAccessSystem.getClass("Kyrios.Actor", "ActorLinker").getMethod("DestroyActor", 0);
DestroyActor2Offset = methodAccessSystem2.getClass("NucleusDrive.Logic", "LActorRoot").getMethod("DestroyActor", 1);


ShowKhungRankOffset = Il2CppMethod("Project_d.dll").getClass("Assets.Scripts.GameSystem", "PVPLoadingView").getMethod("OnEnter", 0) + 0x1018;
ShowBoTroOffset = Il2CppMethod("Project_d.dll").getClass("Assets.Scripts.GameSystem", "UIBattleStatView/HeroItem").getMethod("updateTalentSkillCD", 1) + 0x228;


GetPlayerOffset = methodAccessSystem2.getClass("NucleusDrive.Logic.GameKernal", "GamePlayerCenter").getMethod("GetPlayer", 1);
   lobbyupdateoffset = methodAccessSystem.getClass("Assets.Scripts.GameLogic","LobbyLogic").getMethod("UpdateLogic", 1);
   //Doi ten Dai
  CheckRoleNameOffset = methodAccessSystem.getClass("","Utility").getMethod("CheckRoleName", 1);
    RemoveSpaceOffset = methodAccessSystem.getClass("Assets.Scripts.UI","CUIUtility").getMethod("RemoveSpace", 1);
    OpenWaterUIDOffset = methodAccessSystem.getClass("Assets.Scripts.GameSystem","CLobbySystem").getMethod("OpenWaterMark", 0);
    get_actorHpoff = methodAccessSystem2.getClass("NucleusDrive.Logic","ValuePropertyComponent").getMethod("get_actorHp", 0);
    set_actorHpoff = methodAccessSystem2.getClass("NucleusDrive.Logic","ValuePropertyComponent").getMethod("set_actorHp", 1);


HOOK(OpenWaterUIDOffset,OpenWaterMark, _OpenWaterMark);
HOOK(lobbyupdateoffset, _cualinhkhongleak, cualinhkhongleak);
HOOK(GetPlayerOffset,_GetPlayer, GetPlayer);


    botro = GetFieldOffset("Project_d.dll", "Kyrios.Actor", "HeroWrapperData", "m_skillSlot3Unlock");
    cphutro = GetFieldOffset("Project_d.dll", "Kyrios.Actor", "HeroWrapperData", "heroWrapSkillData_5");
    c1 = GetFieldOffset("Project_d.dll", "Kyrios.Actor", "HeroWrapperData", "heroWrapSkillData_2");
    c2 = GetFieldOffset("Project_d.dll", "Kyrios.Actor", "HeroWrapperData", "heroWrapSkillData_3");
    c3 = GetFieldOffset("Project_d.dll", "Kyrios.Actor", "HeroWrapperData", "heroWrapSkillData_4");
    Skill5OK = GetFieldOffset(oxorany("Project_d.dll"), oxorany("Kyrios.Actor"), oxorany("HeroWrapperData"), oxorany("m_commonSkillID")); // ID bổ trợ
    
    m_isCharging = (uintptr_t)GetFieldOffset("Project_d.dll","Assets.Scripts.GameSystem","CSkillButtonManager","m_isCharging");
	m_currentSkillSlotType = (uintptr_t)GetFieldOffset("Project_d.dll","Assets.Scripts.GameSystem","CSkillButtonManager" , "m_currentSkillSlotType");
    AsHero = (uintptr_t (*) (void *)) GetMethodOffset("Project_d.dll","Kyrios.Actor","ActorLinker" ,"AsHero", 0);
  
    old_RefreshHeroPanel = (void (*)(void*, bool, bool, bool)) GetMethodOffset("Project_d.dll","Assets.Scripts.GameSystem", "HeroSelectNormalWindow","RefreshHeroPanel", 3);
    PlrList = (List<void *> *(*)(void *))GetMethodOffset("Project.Plugins_d.dll","NucleusDrive.Logic.GameKernal","GamePlayerCenter","GetAllPlayers", 0);



dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

   HOOK(GetCameraOffset, _cam, cam);

   HOOK(SetVisibleOffset,LActorRoot_Visible, _LActorRoot_Visible);

   HOOK(ShowHeroInfoOffset,ShowHeroInfo, _ShowHeroInfo);	
HOOK(ShowSkillStateInfoOffset,ShowSkillStateInfo, _ShowSkillStateInfo);
   HOOK(ShowHeroHpInfoOffset,ShowHeroHpInfo, _ShowHeroHpInfo);
  
    //Hiện Lịch Sử Đấu
	HOOK(IsHostProfileOffset,IsHostProfile, _IsHostProfile);

  });

//==========================================

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    //Unlock Nút
	HOOK(IsOpenOffset,IsOpen, old_IsOpen);
	HOOK(PersonalBtnIdOffset,get_PersonalBtnId, old_get_PersonalBtnId);
    //Aim Skill
	HOOK(UpdateLogicOffset,UpdateLogic, _UpdateLogic);
	HOOK(GetUseSkillDirectionOffset,GetUseSkillDirection, _GetUseSkillDirection);
	
	  //Show CD Name
   HOOK(UpdateNameCDOffset,AUpdate, old_Update);

     });
     
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      HOOK(RemoveSpaceOffset,_RemoveSpace,RemoveSpace);
      HOOK(CheckRoleNameOffset,_CheckRoleName, CheckRoleName);
      
HOOK(UpdateFrameLaterOffset,UpdateFrameLater, old_UpdateFrameLater);

HOOK(IsCanSellOffset,get_IsCanSell, _get_IsCanSell);
   
HOOK(SendInBattleMsgOffset,SendInBattleMsg_InputChat, _SendInBattleMsg_InputChat);
      
     });



//==========================================

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
    //Unlock Skin
   HOOK(UnpackOffset,unpack, old_unpack);
   HOOK(OnClickSelectOffset,OnClickSelectHeroSkin, old_OnClickSelectHeroSkin);
   HOOK(IsCanUseSkinOffset,IsCanUseSkin, old_IsCanUseSkin);
   HOOK(GetHeroSkinIdOffset,GetHeroWearSkinId, old_GetHeroWearSkinId);
   HOOK(IsHaveHeroSkinOffset,IsHaveHeroSkin, old_IsHaveHeroSkin); 
     });
//==========================================
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   
   //Show Avatar && Hiện Tên Cấm Chọn
     HOOK(InitTeamHeroListOffset, InitTeamHeroList, _InitTeamHeroList);
     HOOK(TeamLaderGradeMaxOffset,checkTeamLaderGradeMax, _checkTeamLaderGradeMax);

    HOOK(get_actorHpoff, get_actorHpz, _get_actorHpz);
    HOOK(set_actorHpoff, set_actorHpz, _set_actorHpz);

HOOK(Il2CppMethod("Project_d.dll").getClass("Assets.Scripts.GameLogic","HudComponent3D").getMethod("SetPlayerName", 4),_SetPlayerName, SetPlayerName);
    
HOOK(Il2CppMethod(oxorany("Project_d.dll")).getClass(oxorany("Assets.Scripts.GameLogic"), oxorany("SkillSlot")).getMethod(oxorany("LateUpdate"), 1), Skslot, _Skslot);
     });


//==========================================

     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	
    
    // H O O K  ESP
// 	public void UpdateLogic(int delta) { }
    HOOK(UpdateLogicESPOffset, LActorRoot_UpdateLogic, old_LActorRoot_UpdateLogic);//esp
// 	public void DestroyActor() { }
    HOOK(DestroyActorOffset, ActorLinker_ActorDestroy, old_ActorLinker_ActorDestroy);//esp
//	public void DestroyActor(bool bTriggerEvent) { }
    HOOK(DestroyActor2Offset, LActorRoot_ActorDestroy, old_LActorRoot_ActorDestroy);//esp
    
    HOOK(Il2CppMethod("Project_d.dll").getClass("Assets.Scripts.GameLogic","BattleLogic").getMethod("ShowWinLose", 1), ShowWinLose, _ShowWinLose);
     });
     
 //==========================================

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
       Hook1110("Frameworks/UnityFramework.framework/UnityFramework", ShowKhungRankOffset, "1F2003D5"); // rank
       Hook1110("Frameworks/UnityFramework.framework/UnityFramework", ShowBoTroOffset, "1F2003D5"); // btro
});
});
 });
}

    
- (void)viewDidLoad{
   
   /*
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [FTIndicator showToastMessage:@"Copying : Ngô Phong 🙈"];  
   });
    */

    [super viewDidLoad];
    initial_setup();
    sendOffsetInfo();
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;

    if ([saveSetting objectForKey:@"HackMap"] != nil) { 
        HackMap = [saveSetting boolForKey:@"HackMap"];
        ShowUlti = [saveSetting boolForKey:@"ShowUlti"];
        ShowCD = [saveSetting boolForKey:@"ShowCD"];
        StreamerMode = [saveSetting boolForKey:@"StreamerMode"];
       
        unlockskin = [saveSetting boolForKey:@"unlockskin"];
        enableBanList = [saveSetting integerForKey:@"enableBanList"];
        selectedbutton = [saveSetting integerForKey:@"selectedbutton"];
        selectedValue2 = [saveSetting integerForKey:@"selectedValue2"];
        HeroTypeID = [saveSetting integerForKey:@"HeroTypeID"];

        OnCamera = [saveSetting boolForKey:@"OnCamera"];

        AimSkill = [saveSetting boolForKey:@"AimSkill"];
        aimSkill1 = [saveSetting boolForKey:@"aimSkill1"];
        aimSkill2 = [saveSetting boolForKey:@"aimSkill2"];
        aimSkill3 = [saveSetting boolForKey:@"aimSkill3"];
        aimType = [saveSetting integerForKey:@"aimType"];
        drawType = [saveSetting integerForKey:@"drawType"];
        LazeThemes = (int)[saveSetting integerForKey:@"LazeThemes"];
        LazeElsu[0] = [saveSetting floatForKey:@"LazeElsuR"];
        LazeElsu[1] = [saveSetting floatForKey:@"LazeElsuG"];
        LazeElsu[2] = [saveSetting floatForKey:@"LazeElsuB"];
        LazeElsu[3] = [saveSetting floatForKey:@"LazeElsuA"];
        ColorCrosshair[0] = [saveSetting floatForKey:@"ColorCrosshairR"];
        ColorCrosshair[1] = [saveSetting floatForKey:@"ColorCrosshairG"];
        ColorCrosshair[2] = [saveSetting floatForKey:@"ColorCrosshairB"];
        ColorCrosshair[3] = [saveSetting floatForKey:@"ColorCrosshairA"];

        ShowLsd = [saveSetting boolForKey:@"ShowLsd"];
        ShowLockName = [saveSetting boolForKey:@"ShowLockName"];
        ShowAvatar = [saveSetting boolForKey:@"ShowAvatar"];
        spamchat = [saveSetting boolForKey:@"spamchat"];
        solanchat = [saveSetting integerForKey:@"solanchat"];
        ShowBoTroz = [saveSetting boolForKey:@"ShowBoTroz"];
        ShowRank = [saveSetting boolForKey:@"ShowRank"];

        Bantuido = [saveSetting boolForKey:@"Bantuido"];
        //Unlock120fps = [saveSetting boolForKey:@"Unlock120fps"];

        autott = [saveSetting boolForKey:@"autott"];
        onlymt = [saveSetting boolForKey:@"onlymt"];
        autobocpha = [saveSetting boolForKey:@"autobocpha"];
        bangsuong = [saveSetting boolForKey:@"bangsuong"];
        capcuuz = [saveSetting boolForKey:@"capcuuz"];
        hoimau = [saveSetting boolForKey:@"hoimau"];

        maubotro = [saveSetting floatForKey:@"maubotro"];
        mauphutro = [saveSetting floatForKey:@"mauphutro"];
        mauhoimau = [saveSetting floatForKey:@"mauhoimau"];
        maucapcuu = [saveSetting floatForKey:@"maucapcuu"];

        SetFieldOfView = [saveSetting floatForKey:@"SetFieldOfView"];
    }
}

#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

bool isJailbroken() {
    // Kiểm tra file /bin/bash
    struct stat s;
    return (stat("/bin/bash", &s) == 0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}


#pragma mark - MTKViewDelegate


- (void)drawInMTKView:(MTKView*)view
{

   //ApplyThemeColors();
    hideRecordTextfield.secureTextEntry = StreamerMode;
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
   if (iPhonePlus) {
        io.DisplayFramebufferScale = ImVec2(2.60, 2.60);
    } else {
        io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
     }
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ? : 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    
        // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_texture = nil;
    if (bg_texture == nil) {
        NSString* base64String = autobocphaz; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_texture = LoadTextureFromBase64(self.device, base64_std_string);
    }
     
 // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_texture2 = nil;
    if (bg_texture2 == nil) 
{
        NSString* base64String = autobangsuongz; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_texture2 = LoadTextureFromBase64(self.device, base64_std_string);
    }

    // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_texture3 = nil;
    if (bg_texture3 == nil) 
{
        NSString* base64String = AutoCapCuuz; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_texture3 = LoadTextureFromBase64(self.device, base64_std_string);

}
           // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_texture4 = nil;
    if (bg_texture4 == nil) 
{
        NSString* base64String = trungtriz; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_texture4 = LoadTextureFromBase64(self.device, base64_std_string);
    }

        // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_texture5 = nil;
    if (bg_texture5 == nil) 
{
        NSString* base64String = AutoHoiMauz; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_texture5 = LoadTextureFromBase64(self.device, base64_std_string);
    }

     // Tải texture từ Base64 trong Logo.h
    static id<MTLTexture> bg_conhopong = nil;
    if (bg_conhopong == nil) 
{
        NSString* base64String = ConHoPong; // Sử dụng macro từ Logo.h
        std::string base64_std_string([base64String UTF8String]);
        bg_conhopong = LoadTextureFromBase64(self.device, base64_std_string);
    }

        if (MenDeal == true) 
        {
            [self.view setUserInteractionEnabled:YES];
            [self.view.superview setUserInteractionEnabled:YES];
            [menuTouchView setUserInteractionEnabled:YES];
        } 
        else if (MenDeal == false) 
        {
            [self.view setUserInteractionEnabled:NO];
            [self.view.superview setUserInteractionEnabled:NO];
            [menuTouchView setUserInteractionEnabled:NO];
        }

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            ImFont* font = ImGui::GetFont();
            font->Scale = 16.f / font->FontSize;
            
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 500) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 335) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(500, 335), ImGuiCond_FirstUseEver);
            
            if (MenDeal == true)
            {                
            std::string namedv = [[UIDevice currentDevice] name].UTF8String;
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE,dd/MM/yyyy | HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:now];

            UIDevice *device = [UIDevice currentDevice];
            device.batteryMonitoringEnabled = YES;
            
            float batteryLevel = device.batteryLevel * 100;
            NSString *chargingStatus = @"";
            if (device.batteryState == UIDeviceBatteryStateCharging) {
                chargingStatus = @"-  Đang Sạc";
            } else if (device.batteryState == UIDeviceBatteryStateFull) {
                chargingStatus = @"-  Đầy Pin";
            } else {
                chargingStatus = @"-  Đã Ngắt Sạc";
            }

              char appName[256] = {0}; // Tên App
              char bundleID[256] = {0}; // BundleID
              char appVersion[256] = {0}; // Version
              char deviceModel[256] = {0}; // Thông tin máy
              Cbeios *appInfo = [[Cbeios alloc] init];
              [appInfo ThanhThanh:appName bundleID:bundleID appVersion:appVersion deviceModel:deviceModel];


              char* Gnam = (char*) [[NSString stringWithFormat:nssoxorany("Arena of Valor / By : Poong"), appVersion] cStringUsingEncoding:NSUTF8StringEncoding];
              ImGui::Begin(Gnam, &MenDeal, ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoTitleBar);


const ImVec2 pos = ImGui::GetWindowPos();
             ImU32 colorRect = IM_COL32(77, 77, 77, 50);   // Rectangle color (RGB: 82, 100, 0
ImGui::GetWindowDrawList()->AddRectFilled(
    ImVec2(pos.x + 5,pos.y +5), 
    ImVec2(pos.x + 495, pos.y + 35), 
    colorRect
);

ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 3);  // Giảm khoảng cách dòng    
ImGui::SetCursorPosX(ImGui::GetCursorPosX() + 27);  // Giảm khoảng cách dòng

ImGui::PushFont(FontThemes);
float windowWidth = ImGui::GetWindowSize().x;
float textWidth = ImGui::CalcTextSize(Gnam).x;
ImGui::SetCursorPosX((windowWidth - textWidth) * 0.5f);
ImGui::Text("%s", Gnam);
ImGui::PopFont();

ImDrawList* draw = ImGui::GetWindowDrawList();

// Lấy thời gian hiện tại tính bằng giây
float time = ImGui::GetTime();
int currentDot = static_cast<int>(floor(time)) % 3;  // Xác định vị trí chấm phát sáng (0, 1, hoặc 2)

// Màu tối cho trạng thái chưa phát sáng
ImColor darkColors[3] = { ImColor(100, 30, 30), ImColor(100, 70, 30), ImColor(30, 100, 30) }; // Màu tối mờ

// Màu phát sáng kiểu neon cho từng chấm
ImColor glowColors[3] = { ImColor(255, 50, 50, 200), ImColor(255, 220, 100, 200), ImColor(130, 255, 130, 200) }; // Màu phát sáng đậm, hơi trong suốt

// Vẽ các chấm, kiểm tra xem có phải chấm đang phát sáng không
draw->AddCircleFilled(ImVec2(pos.x + 20, pos.y + 20), 8, currentDot == 0 ? glowColors[0] : darkColors[0], 360);
draw->AddCircleFilled(ImVec2(pos.x + 41, pos.y + 20), 8, currentDot == 1 ? glowColors[1] : darkColors[1], 360);
draw->AddCircleFilled(ImVec2(pos.x + 62, pos.y + 20), 8, currentDot == 2 ? glowColors[2] : darkColors[2], 360);

//Close menu
		ImGui::SetCursorPos({445, -2});
                 //ImGui::SetWindowFontScale(1.25f);
        // Đẩy các màu tạm thời cho nút
ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0, 0, 0, 0));           // Nền nút trong suốt
ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0, 0, 0, 0));    // Nền nút khi di chuột cũng trong suốt
ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0, 0, 0, 0));     // Nền nút khi nhấn cũng trong suốt
// Đẩy thuộc tính để loại bỏ viền
ImGui::PushStyleVar(ImGuiStyleVar_FrameBorderSize, 0.0f);             // Kích thước viền bằng 0

// Vẽ nút
if (ImGui::Button(ICON_FA_POWER_OFF"", ImVec2(50, 50))) {
    MenDeal = false;
}
ImGui::PopStyleVar(); 
// Khôi phục màu sắc ban đầu
ImGui::PopStyleColor(3);


            ImDrawList *draw_list = ImGui::GetWindowDrawList();
         
           ImGui::SetCursorPos({5, 40});
           ImGui::BeginChild("##LuxH7", ImVec2(120, -1), true , ImGuiWindowFlags_NoScrollbar);
     
           ImVec2 iconThanhNgang = ImVec2(100, 70);
           ImVec2 cursorPosNgang = ImGui::GetCursorScreenPos(); 
           draw->AddImage((void*)CFBridgingRetain(bg_conhopong), cursorPosNgang, ImVec2(cursorPosNgang.x + iconThanhNgang.x, cursorPosNgang.y + iconThanhNgang.y)); 
           ImGui::SetCursorScreenPos(ImVec2(cursorPosNgang.x + iconThanhNgang.x + 5, cursorPosNgang.y)); // Adjust the position of the checkbox 
         
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           ImGui::Spacing();
           
           const float BUTTON_WIDTH = 103.0f;
           const float BUTTON_HEIGHT = 30.0f;

          if (ImGui::Button(ICON_FA_HOME" Home", ImVec2(BUTTON_WIDTH ,BUTTON_HEIGHT)))
          tab = 1;
      
          if (ImGui::Button(ICON_FA_GAMEPAD" Extra", ImVec2(BUTTON_WIDTH ,BUTTON_HEIGHT))) 
          tab = 2;

        //  if (ImGui::Button(ICON_FA_EYE" ESP", ImVec2(BUTTON_WIDTH ,BUTTON_HEIGHT))) 
         // tab = 6;
      
          if (ImGui::Button(ICON_FA_FOLDER_OPEN" Skins", ImVec2(BUTTON_WIDTH ,BUTTON_HEIGHT))) 
          tab = 3;
        
         if (ImGui::Button(ICON_FA_CROSSHAIRS" Aimbot", ImVec2(BUTTON_WIDTH ,BUTTON_HEIGHT))) 
          tab = 4;

          if (ImGui::Button(ICON_FA_CROWN" Auto", ImVec2(BUTTON_WIDTH, BUTTON_HEIGHT)))
          tab = 5;
           
      
          ImGui::EndChild();
  
          ImGui::SameLine();

         ImGui::SetCursorPos({133, 40});
       
         ImGui::BeginChild("##Khungmenu", ImVec2(-1, 235), true);
          switch (tab) {
          case 1: {
          ImGui::BeginGroup();
          ImGui::Checkbox("Đèn Pin Map", &HackMap);
          ImGui::Checkbox("Bật Camera", &OnCamera);
          ImGui::EndGroup();

          ImGui::SameLine();

          ImGui::BeginGroup();
          ImGui::Checkbox("Show Hero/HP", &ShowUlti);
          ImGui::Checkbox("Ẩn Live", &StreamerMode);
          ImGui::EndGroup();

          ImGui::SameLine();
           
          ImGui::BeginGroup();
          ImGui::Checkbox("Show CD", &ShowCD);
          //ImGui::Checkbox("Ẩn Live", &StreamerMode);
          ImGui::EndGroup();
          

                ///ImGui::SameLine();
                
                ImGui::PushItemWidth(340);
                ImGui::SliderFloat("##Camera", &SetFieldOfView, 0.0f, 10.0f,"Độ Cao Camera : %.3f",2);
                ImGui::PopItemWidth();

                	ImGui::Spacing(); 
                    ImGui::Separator();
				
				if (ImGui::Button("Telegram!")) {
                        // Mở đường link (trên iOS hoặc macOS, dùng hệ thống gọi mở URL)
                        NSString *urlString = @"https://t.me/khongcojdau";
                        NSURL *url = [NSURL URLWithString:urlString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                }

                  ImGui::SameLine();

               if (ImGui::Button("Zalo Nhóm")) {
                        // Mở đường link (trên iOS hoặc macOS, dùng hệ thống gọi mở URL)
                        NSString *urlString = @"https://zalo.me/g/lgwcoh497";
                        NSURL *url = [NSURL URLWithString:urlString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                 }

                ImGui::SameLine();

                if (ImGui::Button("Zalo Của Tôi")) {
                        
                        NSString *urlString = @"Http://zalo.me/0766382293";
                        NSURL *url = [NSURL URLWithString:urlString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                 } 
                ImGui::Separator();
                ImGui::Spacing();

          ImGui::Text("Tên App:");
          ImGui::SameLine();
          ImGui::TextColored(ImColor(255, 255, 0), "%s", appName); 

          ImGui::SameLine();

          ImGui::Text("Version:");
          ImGui::SameLine();
          ImGui::TextColored(ImColor(0, 255, 0), "%s", appVersion); 


                        ImGui::Text("Thiết Bị:");
                        ImGui::SameLine();
                        ImGui::TextColored(ImColor(255, 0, 255), "%s", deviceModel);
                       
                       /*
                        ImGui::SameLine();
                        ImGui::TextColored(ImVec4(1.0f, 1.0f, 1.0f, 1.0f), "Trạng Thái:");
                        ImGui::SameLine();
                        if (isJailbroken()) {
                        ImGui::TextColored(ImVec4(1.0f, 0.0f, 0.0f, 1.0f), "Đã Jailbreak !");
                        }
                         else {
                         ImGui::TextColored(ImVec4(0.0f, 1.0f, 0.0f, 1.0f), "Chưa Jailbreak !");
                        }
                        */
                         
                        ImGui::Text("BundleID:");
                        ImGui::SameLine();
                        ImGui::TextColored(ImColor(225, 225, 0), "%s", bundleID); 
                        
                        ImGui::TextColored(ImColor(255, 255, 255), "Thời Gian:");
                        ImGui::SameLine();
                        ImGui::TextColored(ImColor(0, 255, 255), "%s", [dateString UTF8String]);


                ImColor white(255, 255, 255);
                ImGui::TextColored(white, "Thời Hạn Pin:");

                ImColor yellow(255, 255, 0);
                ImGui::SameLine();
                ImGui::TextColored(yellow, "%.0f%%", batteryLevel);

                ImColor green(0, 255, 0);
                ImColor red(255, 0, 0);

                ImColor statusTextColor;
                if (device.batteryState == UIDeviceBatteryStateCharging) {
                    statusTextColor = green;
                } else {
                    statusTextColor = red;
                }
                ImGui::SameLine();
                ImGui::TextColored(statusTextColor, "%s", [chargingStatus UTF8String]);

          }
            break;		        	                                           
            case 2: {   

                ImGui::BeginGroup();
                ImGui::Checkbox("Hiện Lịch Sử Đấu", &ShowLsd);
                ImGui::Checkbox("Hiện Cấm Chọn", &ShowLockName);
                ImGui::Checkbox("Hiện Avatar", &ShowAvatar);
                ImGui::Checkbox("Hiện Khung Rank", &ShowRank);
                ImGui::Checkbox("Hiện Bổ Trợ", &ShowBoTroz);
                ImGui::Checkbox("Bán All Balo", &Bantuido);

                ImGui::EndGroup();

                //ImGui::SameLine();

                //ImGui::BeginGroup();
                //ImGui::EndGroup();

                ImGui::Separator();
                ImGui::Checkbox("Huỷ Trận Đấu", &AutoWinz);
                ImGui::SameLine();
                HelpMarker("Chức Năng Huỷ Trận Rủi Ro \nKhoá Nhiều Năm Bật Phút Thứ 3 Trận Đấu !");
                ImGui::SameLine();

                ImGui::Checkbox("Đổi Tên Dài", &DoiTenDai);
                ImGui::SameLine();
                HelpMarker("Mở Lên Khi Muốn Đổi Tên Dài \nSau Khi Ghi Xong Tên Cần \nTắt Chức Năng Này Để Có Thể \nĐổi Tên Thành Công");

                ImGui::Checkbox("Spam Chat", &spamchat);
                ImGui::SameLine();
                ImGui::PushItemWidth(200);
                ImGui::SliderInt("##chatband", &solanchat , 1 , 100,"Số Lần Chat : %.1d");
                ImGui::PopItemWidth();
                       }
            break;
            case 3: {
           
              ImGui::Checkbox("Mở Khoá Tất Cả Skin", &unlockskin);
              ImGui::SameLine();
              ImGui::Checkbox("Bỏ Skin Ẩn", &enableBanList);
              ImGui::PushItemWidth(260);
              DrawModButton();
              DrawModNotify();
              ImGui::PopItemWidth();
              DrawHeroSkinInfo();
            
            }
            break;
            
            case 4: {
            
                ImGui::Checkbox("Bật Aimbot", &AimSkill);
                      ImGui::SameLine();
                      HelpMarker("Aim Các Loại Tướng Tuỳ Chọn Ở Dưới");
                      
                      ImGui::Checkbox("Aim Skill 1", &aimSkill1);
                      ImGui::SameLine();
                        ImGui::Checkbox("Aim Skill 2", &aimSkill2);
                        ImGui::SameLine();
                        ImGui::Checkbox("Aim Skill 3", &aimSkill3);
                        DrawAimbotTab();
                        DoLeckID();
                        //ImGui::SameLine();
                     
                        ImGui::SliderFloat("##LinAimbot", &Radius, 0.0f, 100.0f, "Khoảng Cách : %.3f Mét",2);
                        ImGui::SliderFloat("##DoLech", &DoLechAim,0.0f, 10.0f, "Độ Lệch : %.3f",2);
                        //ImGui::ColorEdit4("Màu Tâm",ColorCrosshair);
//ImGui::ColorEdit4("Đường Kẻ",LazeElsu);
                       //ImGui::SliderFloat("##Laze", &LazeThemes, 0, 4, "Đường Kẻ Đậm Màu : %.1f",2);
            }
            break;
            
            case 5: {

                    
                    ImVec2 iconSize4 = ImVec2(25, 25); // Adjust the size of the icon 
                    ImVec2 cursorPos4 = ImGui::GetCursorScreenPos(); 
                    draw->AddImage((void*)CFBridgingRetain(bg_texture4), cursorPos4, ImVec2(cursorPos4.x + iconSize4.x, cursorPos4.y + iconSize4.y)); 
                    ImGui::SetCursorScreenPos(ImVec2(cursorPos4.x + iconSize4.x + 5, cursorPos4.y)); // Adjust the position of the checkbox 
                       ImGui::Checkbox("Auto Trừng Trị", &autott);
                       ImGui::SameLine();
                       HelpMarker("[Bùa Xanh, Bùa Đỏ]\n[Rồng, Tà Thần]");
                     
                      
                       ImGui::SameLine();
                       ImGui::Checkbox("Mục Tiêu", &onlymt);
                       ImGui::SameLine();
                       HelpMarker("[Rồng, Tà Thần]");



                    ImVec2 iconSize = ImVec2(25, 25); // Adjust the size of the icon 
                    ImVec2 cursorPos = ImGui::GetCursorScreenPos(); 
                    draw->AddImage((void*)CFBridgingRetain(bg_texture), cursorPos, ImVec2(cursorPos.x + iconSize.x, cursorPos.y + iconSize.y)); 
                    ImGui::SetCursorScreenPos(ImVec2(cursorPos.x + iconSize.x + 5, cursorPos.y)); // Adjust the position of the checkbox 
                       //ImGui::SameLine();
                       ImGui::Checkbox("Auto Bộc Phá", &autobocpha);
                       ImGui::SameLine();
                       ImGui::PushItemWidth(200);
                       ImGui::SliderFloat("##lol", &maubotro , 0.0f , 100.0f,"Địch Dưới %.2f%% Máu");
                       ImGui::PopItemWidth();

                    ImVec2 iconSize2 = ImVec2(25, 25); // Adjust the size of the icon 
                    ImVec2 cursorPos2 = ImGui::GetCursorScreenPos(); 
                    draw->AddImage((void*)CFBridgingRetain(bg_texture2), cursorPos2, ImVec2(cursorPos2.x + iconSize2.x, cursorPos2.y + iconSize2.y)); 
                    ImGui::SetCursorScreenPos(ImVec2(cursorPos2.x + iconSize2.x + 5, cursorPos2.y)); // Adjust the position of the checkbox 
                       ImGui::Checkbox("Auto Băng Sương", &bangsuong);
                       ImGui::SameLine();
                       ImGui::PushItemWidth(177);
                       ImGui::SliderFloat("##cxd", &mauphutro , 0.0f , 100.0f,"Địch Dưới %.2f%% Máu");
                       ImGui::PopItemWidth();
                       
                    ImVec2 iconSize3 = ImVec2(25, 25); // Adjust the size of the icon 
                    ImVec2 cursorPos3 = ImGui::GetCursorScreenPos(); 
                    draw_list->AddImage((void*)CFBridgingRetain(bg_texture3), cursorPos3, ImVec2(cursorPos3.x + iconSize3.x, cursorPos3.y + iconSize3.y)); 
                    ImGui::SetCursorScreenPos(ImVec2(cursorPos3.x + iconSize3.x + 5, cursorPos3.y)); // Adjust the position of the checkbox 
                       //ImGui::SameLine();
                       ImGui::Checkbox("Auto Cấp Cứu", &capcuuz);
                       ImGui::SameLine();
                       ImGui::PushItemWidth(197);
                       ImGui::SliderFloat("##bcc", &maucapcuu , 0.0f , 100.0f,"Địch Dưới %.2f%% Máu");
                       ImGui::PopItemWidth();

                    ImVec2 iconSize5 = ImVec2(25, 25); //Size Icon
                    ImVec2 cursorPos5 = ImGui::GetCursorScreenPos(); 
                    draw_list->AddImage((void*)CFBridgingRetain(bg_texture5), cursorPos5, ImVec2(cursorPos5.x + iconSize5.x, cursorPos5.y + iconSize5.y)); 
                    ImGui::SetCursorScreenPos(ImVec2(cursorPos5.x + iconSize5.x + 5, cursorPos5.y)); // Adjust the position of the checkbox 
                       ImGui::Checkbox("Auto Hồi Máu", &hoimau);
                       ImGui::SameLine();
                       ImGui::PushItemWidth(199);
                       ImGui::SliderFloat("##bccm", &mauhoimau , 0.0f , 100.0f,"Địch Dưới %.2f%% Máu");
                       ImGui::PopItemWidth();
                   }
                }
                 ImGui::EndChild();
                  
                 

                  ImGui::SetCursorPos({133,281});
                  ImGui::BeginChild("##SaveSetting", ImVec2(-1, 45), true);

                  ImGui::Spacing();

                  if (ImGui::Button(oxorany(ICON_FA_SAVE" Lưu"))) 
          { 
             [saveSetting setBool:HackMap forKey:@"HackMap"];
                        [saveSetting setBool:ShowUlti forKey:@"ShowUlti"];
                        [saveSetting setBool:ShowCD forKey:@"ShowCD"];
                        [saveSetting setBool:StreamerMode forKey:@"StreamerMode"];

                        [saveSetting setBool:unlockskin forKey:@"unlockskin"];
                        [saveSetting setBool:enableBanList forKey:@"enableBanList"];
                        [saveSetting setInteger:selectedbutton forKey:@"selectedbutton"];
                        [saveSetting setInteger:selectedValue2 forKey:@"selectedValue2"];

                        [saveSetting setInteger:HeroTypeID forKey:@"HeroTypeID"];

                        [saveSetting setBool:OnCamera forKey:@"OnCamera"];

                         [saveSetting setBool:AimSkill forKey:@"AimSkill"];
                         [saveSetting setBool:aimSkill1 forKey:@"aimSkill1"];
                         [saveSetting setBool:aimSkill2 forKey:@"aimSkill2"];
                         [saveSetting setBool:aimSkill3 forKey:@"aimSkill3"];
                         [saveSetting setInteger:aimType forKey:@"aimType"];
                         [saveSetting setInteger:drawType forKey:@"drawType"];
                         [saveSetting setInteger:LazeThemes forKey:@"LazeThemes"];
                         [saveSetting setFloat:LazeElsu[0] forKey:@"LazeElsuR"];
                         [saveSetting setFloat:LazeElsu[1] forKey:@"LazeElsuG"];
                         [saveSetting setFloat:LazeElsu[2] forKey:@"LazeElsuB"];
                         [saveSetting setFloat:LazeElsu[3] forKey:@"LazeElsuA"];
                         [saveSetting synchronize];
                          [saveSetting setFloat:ColorCrosshair[0] forKey:@"ColorCrosshairR"];
                          [saveSetting setFloat:ColorCrosshair[1] forKey:@"ColorCrosshairG"];
                          [saveSetting setFloat:ColorCrosshair[2] forKey:@"ColorCrosshairB"];
                          [saveSetting setFloat:ColorCrosshair[3] forKey:@"ColorCrosshairA"];
                          [saveSetting synchronize];

                         [saveSetting setBool:ShowLsd forKey:@"ShowLsd"];
                         [saveSetting setBool:ShowLockName forKey:@"ShowLockName"];
                         [saveSetting setBool:ShowAvatar forKey:@"ShowAvatar"];

                         [saveSetting setBool:spamchat forKey:@"spamchat"];
                         [saveSetting setInteger:solanchat forKey:@"solanchat"];

                         [saveSetting setBool:ShowBoTroz forKey:@"ShowBoTroz"];
                         [saveSetting setBool:ShowRank forKey:@"ShowRank"];

                        [saveSetting setBool:Bantuido forKey:@"Bantuido"];
                        //[saveSetting setBool:Unlock120fps forKey:@"Unlock120fps"];

                         [saveSetting setBool:autott forKey:@"autott"];
                         [saveSetting setBool:onlymt forKey:@"onlymt"];
                         [saveSetting setBool:autobocpha forKey:@"autobocpha"];
                         [saveSetting setBool:bangsuong forKey:@"bangsuong"];
                         [saveSetting setBool:capcuuz forKey:@"capcuuz"];
                         [saveSetting setBool:hoimau forKey:@"hoimau"];
                         
                        [saveSetting setFloat:maubotro forKey:@"maubotro"];
                        [saveSetting setFloat:mauphutro forKey:@"mauphutro"];
                        [saveSetting setFloat:mauhoimau forKey:@"mauhoimau"];
                        [saveSetting setFloat:maucapcuu forKey:@"maucapcuu"];
                        [saveSetting setFloat:SetFieldOfView forKey:@"SetFieldOfView"];
          }
          ImGui::SameLine();
          if (ImGui::Button(oxorany(ICON_FA_CLOUD_UPLOAD_ALT" Sử Dụng")))
         {
            HackMap = [saveSetting boolForKey:@"HackMap"];
                        ShowUlti = [saveSetting boolForKey:@"ShowUlti"];
                        ShowCD = [saveSetting boolForKey:@"ShowCD"];
                        StreamerMode = [saveSetting boolForKey:@"StreamerMode"];
                        
                        unlockskin = [saveSetting boolForKey:@"unlockskin"];
                        enableBanList = [saveSetting boolForKey:@"enableBanList"];
                        selectedbutton = [saveSetting integerForKey:@"selectedbutton"];
                        selectedValue2 = [saveSetting integerForKey:@"selectedValue2"];

                        HeroTypeID = [saveSetting integerForKey:@"HeroTypeID"];

                        OnCamera = [saveSetting boolForKey:@"OnCamera"];

                        AimSkill = [saveSetting boolForKey:@"AimSkill"];
                        aimSkill1 = [saveSetting boolForKey:@"aimSkill1"];
                        aimSkill2 = [saveSetting boolForKey:@"aimSkill2"];
                        aimSkill3 = [saveSetting boolForKey:@"aimSkill3"];
                        aimType = [saveSetting integerForKey:@"aimType"];
                        drawType = [saveSetting integerForKey:@"drawType"];
                        LazeThemes = (int)[saveSetting integerForKey:@"LazeThemes"];
                        
                        LazeElsu[0] = [saveSetting floatForKey:@"LazeElsuR"];
                        LazeElsu[1] = [saveSetting floatForKey:@"LazeElsuG"];
                        LazeElsu[2] = [saveSetting floatForKey:@"LazeElsuB"];
                        LazeElsu[3] = [saveSetting floatForKey:@"LazeElsuA"];

                        ColorCrosshair[0] = [saveSetting floatForKey:@"ColorCrosshairR"];
                        ColorCrosshair[1] = [saveSetting floatForKey:@"ColorCrosshairG"];
                        ColorCrosshair[2] = [saveSetting floatForKey:@"ColorCrosshairB"];
                        ColorCrosshair[3] = [saveSetting floatForKey:@"ColorCrosshairA"];

                        ShowLsd = [saveSetting boolForKey:@"ShowLsd"];
                        ShowLockName = [saveSetting boolForKey:@"ShowLockName"];
                        ShowAvatar = [saveSetting boolForKey:@"ShowAvatar"];
                        spamchat = [saveSetting boolForKey:@"spamchat"];
                        solanchat = [saveSetting integerForKey:@"solanchat"];
                        ShowBoTroz = [saveSetting boolForKey:@"ShowBoTroz"];
                        ShowRank = [saveSetting boolForKey:@"ShowRank"];

                        Bantuido = [saveSetting boolForKey:@"Bantuido"];
                        //Unlock120fps = [saveSetting boolForKey:@"Unlock120fps"];

                        autott = [saveSetting boolForKey:@"autott"];
                        onlymt = [saveSetting boolForKey:@"onlymt"];
                        autobocpha = [saveSetting boolForKey:@"autobocpha"];
                        bangsuong = [saveSetting boolForKey:@"bangsuong"];
                        capcuuz = [saveSetting boolForKey:@"capcuuz"];
                        hoimau = [saveSetting boolForKey:@"hoimau"];

                        maubotro = [saveSetting floatForKey:@"maubotro"];
                        mauphutro = [saveSetting floatForKey:@"mauphutro"];
                        mauhoimau = [saveSetting floatForKey:@"mauhoimau"];
                        maucapcuu = [saveSetting floatForKey:@"maucapcuu"];

                        SetFieldOfView = [saveSetting floatForKey:@"SetFieldOfView"];
         }
                    ImGui::SameLine();
                if (ImGui::Button(oxorany(ICON_FA_PEN" Đặt Lại"))) {
                        HackMap = false;
                        ShowUlti = false;
                        ShowCD = false;
                        StreamerMode = false;
                        unlockskin = false;
                        enableBanList = false;
                        selectedbutton = 0;
                        selectedValue2 = 0;
                        HeroTypeID = 0;
                        OnCamera = false;
                        AimSkill = false;
                        aimSkill1 = false;
                        aimSkill2 = false;
                        aimSkill3 = false;
                        aimType = 0;
                        drawType = 2;
                        LazeThemes = 0;

                        // Reset về mặc định
                        ColorCrosshair[0] = 1.0f;
                        ColorCrosshair[1] = 0.0f;
                        ColorCrosshair[2] = 0.0f;
                        ColorCrosshair[3] = 1.0f;
                    
                          // Reset về mặc định
                         LazeElsu[0] = 0.0f;
                         LazeElsu[1] = 1.0f;
                         LazeElsu[2] = 1.0f;
                         LazeElsu[3] = 1.0f;

                        ShowLsd = false;
                        ShowLockName = false;
                        ShowAvatar = false;
                        spamchat = false;
                        solanchat = 1;
                        ShowBoTroz = false;
                        ShowRank = false;
                        Bantuido = false;
                       // Unlock120fps = false;
                        autott = false;
                        onlymt = false;
                        autobocpha = false;
                        bangsuong = false;
                        capcuuz = false;
                        hoimau = false;
                         mauphutro = 13.79f; 
                         maubotro = 12.67f;  
                         mauhoimau = 16.2f; 
                         maucapcuu = 18.45f;
                        SetFieldOfView = 0.0f; 
                        }
                 ImGui::SameLine();
                if (ImGui::Button(ICON_FA_TRASH " Xoá Account"))
					ImGui::OpenPopup("Delete Account?");
				if (ImGui::BeginPopupModal("Delete Account?", NULL, ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoCollapse))
				{
					ImGui::Text("Xoá Tài Khoản Bị Khoá..?");
					

					if (ImGui::Button("Xoá", ImVec2(120, 0)))
					{
						ImGui::CloseCurrentPopup();
                        [self Guest];
					}
					ImGui::SetItemDefaultFocus();
					ImGui::SameLine();
					if (ImGui::Button("Cancel", ImVec2(120, 0))) { ImGui::CloseCurrentPopup(); }
					ImGui::EndPopup();
				}
                 ImGui::EndChild();
                  ImGui::End(); 
            }
  
            ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
            Aimbot(draw_list);
            //DrawMap(draw_list);
            //DrawESP(draw_list);

 

 if(ShowRank){ if(ShowRank_active == NO){
 ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework", ShowKhungRankOffset , "1F2003D5");
 } ShowRank_active = YES;
    } else { if(ShowRank_active == YES){
  DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework", ShowKhungRankOffset , "1F2003D5");
  } ShowRank_active = NO;
}

if(ShowBoTroz){ if(ShowBoTroz_active == NO){
  ActiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework", ShowBoTroOffset , "1F2003D5");
  } ShowBoTroz_active = YES;
    } else { if(ShowBoTroz_active == YES){
 DeactiveCodePatch("Frameworks/UnityFramework.framework/UnityFramework", ShowBoTroOffset , "1F2003D5");
  } ShowBoTroz_active = NO;
 }

            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
          
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{ }


@end