
//bool AimSkill;


//int Radius = 0;
//bool AutoTrung;
//int skillSlot;
bool aimSkill1;
bool aimSkill2;
bool aimSkill3;

float SetFieldOfView = 0;
static bool OnCamera = false;
static bool lockcam = false;
static bool AutoWinInGame = false;
static bool isPlayerName = false; 
static bool HackMap = false; 

//Aimbot
/*
bool (*_IsSmartUse)(void *instance);
bool (*_get_IsUseCameraMoveWithIndicator)(void *instance);

bool IsSmartUse(void *instance){
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    if(AutoTrung && aim){
        return true;
    }
    
    return _IsSmartUse(instance);
}


bool get_IsUseCameraMoveWithIndicator(void *instance){
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    
    if(AutoTrung && aim){
        return true;
    }
    
    return _get_IsUseCameraMoveWithIndicator(instance);
}
void (*old_IsDistanceLowerEqualAsAttacker)(void *instance, int targetActor, int radius);
void IsDistanceLowerEqualAsAttacker(void *instance, int targetActor, int radius) {
    
    bool aim = false;
    
    if(skillSlot == 1 && aimSkill1){
        aim = true;
    }
    
    if(skillSlot == 2 && aimSkill2){
        aim = true;
    }
    
    if(skillSlot == 3 && aimSkill3){
        aim = true;
    }
    
    
    if (instance != NULL && AimSkill && aim) {
        radius = Radius * 1000;
    }
    old_IsDistanceLowerEqualAsAttacker(instance, targetActor, radius);
}
    
bool (*_IsUseSkillJoystick)(void *instance, int slot);
bool IsUseSkillJoystick(void *instance, int slot){
    skillSlot = slot;
    return _IsUseSkillJoystick(instance, slot);
}
*/

static bool ShowUlti = false;
bool (*_ShowHeroInfo)(void *instance);
bool ShowHeroInfo(void *instance) {
    if (instance != nullptr && ShowUlti) {
        return true; 
    }
    return _ShowHeroInfo(instance);
}
void (*_ShowSkillStateInfo)(void *instance, bool bShow);
void ShowSkillStateInfo(void *instance, bool bShow) {
    if (instance != nullptr && ShowUlti) {
      bShow = true; 
    }
    _ShowSkillStateInfo(instance, bShow);
}
void (*_ShowHeroHpInfo)(void *instance, bool bShow);
void ShowHeroHpInfo(void *instance, bool bShow) {
  if (instance && ShowUlti) {
    bShow = true;
  }
  return _ShowHeroHpInfo(instance, bShow);
}


//Hiện Lịch Sử Đấu
//public bool get_IsHostProfile() { }
static bool ShowLsd = false; 
bool (*_IsHostProfile)(void *instance);
bool IsHostProfile(void *instance) {
    if (ShowLsd){
    return true;
}
return _IsHostProfile(instance);
}



//cam xa gần
float(*cam)(void* instance);
float _cam(void* instance){
if(instance != NULL && OnCamera)
{
return SetFieldOfView;
}
return cam(instance);
}


/*
void (*highrate)(void *instance);
void _highrate(void *instance)
{
    highrate(instance);
}



void (*Update)(void *instance);
void _Update(void *instance)
{
    if(instance!=NULL){
        _highrate(instance);
    }
    if(lockcam){
        return;
    }
    return Update(instance);
}
*/

/*
void (*OnCameraHeightChanged)(void *instance);
float (*cam)(void *instance, int *type);
float _cam(void *instance, int *type) {
    if (instance != NULL) {
        static float CameraHeightRateValue = cam(instance, type);
        if (OnCamera && SetFieldOfView > 0) {
            return SetFieldOfView + CameraHeightRateValue;
        }
        return CameraHeightRateValue;
    }
    return cam(instance, type);
}

static float CacheHeight;
void (*Update)(void *instance);
void _Update(void *instance) {
    if (instance != NULL) {
        if (OnCamera && SetFieldOfView > 0) {
            if (CacheHeight != SetFieldOfView) {
                OnCameraHeightChanged(instance);
                CacheHeight = SetFieldOfView;
            }
        }
    }
    if(lockcam) {
        return;
    }
    Update(instance);
}
*/

/*
float (*get_currentZoomRate)(void *instance);
void (*Set_fieldOfView)(void *instance, float amount);
void (*old_Moba_CameraUpdate)(void *instance);
void Moba_CameraUpdate(void *instance) {
    static float currentZoomRate;
    if (instance != NULL && OnCamera) {
        currentZoomRate = get_currentZoomRate(instance);
        if (SetFieldOfView != 0) {
            Set_fieldOfView(instance, SetFieldOfView);
        }else{
            Set_fieldOfView(instance, currentZoomRate);
        }
    }else if (currentZoomRate > 0){
        Set_fieldOfView(instance, currentZoomRate);
        currentZoomRate = 0;
    }
   // if(lockcam){
        return;
    //}
    return old_Moba_CameraUpdate(instance);
}
*/




/*
static bool FakerPing = false;
int (*old_getSmoothPing)(void *instance, int pingVal, int prePingVal);
int getSmoothPing(void *instance, int pingVal, int prePingVal){
if(instance !=NULL && FakerPing)
{
   return 10;//10ms
}
   return old_getSmoothPing(instance, pingVal, prePingVal);
}
*/
//Show Ten Cam Chon
static bool ShowLockName = false;
void (*_InitTeamHeroList)(void* instance, void *listScript, int camp, bool isLeftList, const bool isMidPos );
void InitTeamHeroList(void* instance, void *listScript, int camp, bool isLeftList, const bool isMidPos = false) {
	if (instance != NULL && ShowLockName) { 
		isLeftList = true;
	}
	return _InitTeamHeroList(instance, listScript, camp, isLeftList, isMidPos);
}

//Show Avatar
static bool ShowAvatar = false;
int (*_checkTeamLaderGradeMax)(void *instance);
int checkTeamLaderGradeMax(void *instance){
    if (instance != NULL && ShowAvatar) { 
        return 0;
    }
   return _checkTeamLaderGradeMax(instance); 
}

static bool HideUid = true;
void (*_OpenWaterMark)(void *instance);
void OpenWaterMark(void *instance){
   if(HideUid)
    {
        return;
    }
     _OpenWaterMark(instance);
}

static bool SkinHide = false;
 bool (*_IsSkinAvailable)(void *instance);
 bool IsSkinAvailable(void *instance) {
    if(SkinHide) 
    {
         return true;
    }
    return _IsSkinAvailable(instance);
}

static bool Bantuido = false;
bool (*_get_IsCanSell)(void *instance);
bool get_IsCanSell(void *instance){
    if(instance != NULL && Bantuido){
        return true;
    }
  return _get_IsCanSell(instance);
}

/*
static bool Unlock120fps = false;
 const bool (*_get_Supported60FPSMode)(void *instance);
 const bool get_Supported60FPSMode(void *instance) {
    if (Unlock120fps) { 
        return true;
    } 
    return _get_Supported60FPSMode(instance);
}

const bool (*_get_Supported90FPSMode)(void *instance);
const bool get_Supported90FPSMode(void *instance) {
    if(Unlock120fps){
         return true;
    }
    return _get_Supported90FPSMode(instance);
}
 const bool (*_get_Supported120FPSMode)(void *instance);
 const bool get_Supported120FPSMode(void *instance) {
 if (Unlock120fps) { 
        return true;
    } 
    return _get_Supported120FPSMode(instance);
}
*/


 /*
static bool UnChatBand = true;
bool (*old_IsChatBanLimit)(void *instance);
bool IsChatBanLimit(void *instance){
if(instance !=NULL && UnChatBand)
{
    return false;
}
return old_IsChatBanLimit(instance);
}
*/
/*
static bool UnTanThu = false;
 bool (*old_IsCompleteFirst55Warm)(void *instance);
 bool IsCompleteFirst55Warm(void *instance){
if(UnTanThu)
{
    return true;
}
  return old_IsCompleteFirst55Warm(instance);
}
*/

//auto win
/*
void (*Autowin)(void *player, int hpPercent, int epPercent);
void _Autowin(void *player, int hpPercent, int epPercent) {
    if (player != NULL && AutoWinInGame) {
        hpPercent = -999999;
        epPercent = -999999;
    }
    Autowin(player, hpPercent, epPercent);
}
*/


/*
// ẩn tên 
void (*old_SetPlayerName)(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel);
void SetPlayerName(void *instance, MonoString *playerName, void *prefixName, bool *isGuideLevel) {
    if (instance != NULL && isPlayerName) {
        playerName->setMonoString(ENCRYPTHEX("CTDOTECH"));
    }
    old_SetPlayerName(instance, playerName, prefixName, isGuideLevel);
}
*/
//hack map
void (*_LActorRoot_Visible)(void *instance, int camp, bool bVisible, const bool forceSync);
void LActorRoot_Visible(void *instance, int camp, bool bVisible, const bool forceSync = false) {
    if (instance != nullptr && HackMap) {
        if(camp == 1 || camp == 2 || camp == 110 || camp == 255) {
            bVisible = true;
        }
    } 
 return _LActorRoot_Visible(instance, camp, bVisible, forceSync);
}

/*
void(*loggoc)(void *instance);
void _loggoc(void *instance) {
    if(loggoc) {
        exit(0);
        loggoc(instance);
    }
}
*/

/*
static bool sskin0sd = false;
void (*old_StartSkillCD) (void *player, int overrideCDValue, int ratio);
      void StartSkillCD (void *player, int overrideCDValue, int ratio){
        if(player !=NULL && sskin0sd)
        {
          overrideCDValue = 100;
          ratio = 100;
        }
    return old_StartSkillCD(player, overrideCDValue, ratio);
     }

static bool BuffBang = false;
int (*old_GetGoldCoinInBattle) (void *instance);
      int GetGoldCoinInBattle (void *instance){
        if(instance != NULL && BuffBang)
        {
          return 10000;
        }
        return old_GetGoldCoinInBattle(instance);
     }



     static bool OneHit = false;
int (*old_SetDamage2ZeroOperatorIfNeed) (void *instance, void* hurt, int hp );
     int SetDamage2ZeroOperatorIfNeed (void *instance ,void* hurt, int hp){
       // static const auto IsHostPlayerzz = (bool (*)(void *)) Method_Project_d_dll_Kyrios_VHostLogic_IsHostPlayer_1;
        if(instance !=NULL  && OneHit)
        {
          hp = 99999;
        }
        return old_SetDamage2ZeroOperatorIfNeed(instance, hurt, hp);
     }

 static bool AutoPlayer = false;
bool (*old_IsAutoAI)(void *instance);
bool IsAutoAI(void *instance) {
    if (AutoPlayer) 
	{
        return true;
    }
    return old_IsAutoAI(instance);
}

static bool Fullmana = false;
void (*_get_actorEp) (void *instance);
void get_actorEp (void *instance){
  if(Fullmana)
 {
          return;
      }
        return _get_actorEp (instance);
 }


     static bool MienNhiem = false;
     bool (*old_NoDamageImpl) (void *instance);
      bool NoDamageImpl (void *instance){
        if(instance != NULL && MienNhiem)
        {
          return true;
        }
        return old_NoDamageImpl (instance);
     }
*/

