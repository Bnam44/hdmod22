#include <unordered_map>
#include <string>
#include <cstring>
#include "HeroIcon.h"
typedef struct {
    int index;
    int heroid;
    const char* name;
    unsigned char* data;
    size_t size;
} HeroData;

//https://tomeko.net/online_tools/file_to_hex.php
HeroData heroArray[] = {
    {0, 105, "Toro", _Toro_data, sizeof(_Toro_data)},
    {1, 106, "Krixi", _Krixi_data, sizeof(_Krixi_data)},
    {2, 107, "Zephys", _Zephys_data, sizeof(_Zephys_data)},
    {3, 108, "Gildur", _Gildur_data, sizeof(_Gildur_data)},
    {4, 109, "Veera", _Veera_data, sizeof(_Veera_data)},
    {5, 110, "Kahlii", _Kahlii_data, sizeof(_Kahlii_data)},
    {6, 111, "Violet", _Violet_data, sizeof(_Violet_data)},
    {7, 112, "Yorn", _Yorn_data, sizeof(_Yorn_data)},
    {8, 113, "Chaugnar", _Chaugnar_data, sizeof(_Chaugnar_data)},
    {9, 114, "Omega", _Omega_data, sizeof(_Omega_data)},
    {10, 115, "Jinna", _Jinna_data, sizeof(_Jinna_data)},
    {11, 116, "Butterfly", _Butterfly_data, sizeof(_Butterfly_data)},
    {12, 117, "Ormarr", _Ormarr_data, sizeof(_Ormarr_data)},
    {13, 118, "Alice", _Alice_data, sizeof(_Alice_data)},
    {14, 119, "Mganga", _Mganga_data, sizeof(_Mganga_data)},
    {15, 120, "Mina", _Mina_data, sizeof(_Mina_data)},
    {16, 121, "Marja", _Marja_data, sizeof(_Marja_data)},
    {17, 123, "Maloch", _Maloch_data, sizeof(_Maloch_data)},
    {18, 124, "Ignis", _Ignis_data, sizeof(_Ignis_data)},
    {19, 126, "Arduin", _Arduin_data, sizeof(_Arduin_data)},
    {20, 127, "Azzen'ka", _Azenka_data, sizeof(_Azenka_data)},
    {21, 128, "Lữ Bố", _Lubu_data, sizeof(_Lubu_data)},
    {22, 129, "Triệu Vân", _TrieuVan_data, sizeof(_TrieuVan_data)},
    {23, 130, "Airi", _Airi_data, sizeof(_Airi_data)},
    {24, 131, "Murad", _Murad_data, sizeof(_Murad_data)},
    {25, 132, "Hayate", _Hayate_data, sizeof(_Hayate_data)},
    {26, 133, "Valhein", _Valhein_data, sizeof(_Valhein_data)},
    {27, 134, "Skud", _Skud_data, sizeof(_Skud_data)},
    {28, 135, "Thane", _Thane_data, sizeof(_Thane_data)},
    {29, 136, "Ilumia", _Ilumia_data, sizeof(_Ilumia_data)},
    {30, 137, "Paine", _Paine_data, sizeof(_Paine_data)},
    {31, 139, "Kil'Groth", _KilGroth_data, sizeof(_KilGroth_data)},
    {32, 140, "SuperMan", _Superman_data, sizeof(_Superman_data)},
    {33, 141, "Lauriel", _Lauriel_data, sizeof(_Lauriel_data)},
    {34, 142, "Natalya", _Natalya_data, sizeof(_Natalya_data)},
    {35, 144, "Taara", _Taara_data, sizeof(_Taara_data)},
    {36, 146, "Zill", _Zill_data, sizeof(_Zill_data)},
    {37, 148, "Preyta", _Preyta_data, sizeof(_Preyta_data)},
    {38, 149, "Xeniel", _Xeniel_data, sizeof(_Xeniel_data)},
    {39, 150, "Nakroth", _Nakroth_data, sizeof(_Nakroth_data)},
    {40, 152, "Điêu Thuyền", _DieuThuyen_data, sizeof(_DieuThuyen_data)},
    {41, 153, "Kaine", _Kaine_data, sizeof(_Kaine_data)},
    {42, 154, "Yena", _Yena_data, sizeof(_Yena_data)},
    {43, 156, "Aleister", _Aleister_data, sizeof(_Aleister_data)},
    {44, 157, "Raz", _Raz_data, sizeof(_Raz_data)},
    {45, 159, "Dolia", _Dolia_data, sizeof(_Dolia_data)},
    {46, 162, "Kriknak", _Kriknak_data, sizeof(_Kriknak_data)},
    {47, 163, "Ryoma", _Ryoma_data, sizeof(_Ryoma_data)},
    {48, 166, "Athur", _Athur_data, sizeof(_Athur_data)},
    {49, 167, "Ngộ không", _Wukong_data, sizeof(_Wukong_data)},
    {50, 168, "Lumburr", _Lumbur_data, sizeof(_Lumbur_data)},
    {51, 169, "Slimz", _Slim_data, sizeof(_Slim_data)},
    {52, 170, "Moren", _Moren_data, sizeof(_Moren_data)},
    {53, 171, "Cresh", _Cresh_data, sizeof(_Cresh_data)},
    {54, 173, "Fennik", _Fennik_data, sizeof(_Fennik_data)},
    {55, 174, "Stuart", _Joker_data, sizeof(_Joker_data)},
    {56, 175, "Grakk", _Grakk_data, sizeof(_Grakk_data)},
    {57, 177, "Lindis", _Lindis_data, sizeof(_Lindis_data)},
    {58, 180, "Max", _Max_data, sizeof(_Max_data)},
    {59, 184, "Helen", _Helen_data, sizeof(_Helen_data)},
    {60, 186, "Teemee", _Teme_data, sizeof(_Teme_data)},
    {61, 187, "Arum", _Arum_data, sizeof(_Arum_data)},
    {62, 189, "Krizzix", _Krizzix_data, sizeof(_Krizzix_data)},
    {63, 190, "Tulen", _Tulen_data, sizeof(_Tulen_data)},
    {64, 191, "Rouie", _Rouie_data, sizeof(_Rouie_data)},
    {65, 192, "Celica", _Celica_data, sizeof(_Celica_data)},
    {66, 193, "Amily", _Amily_data, sizeof(_Amily_data)},
    {67, 194, "Wiro", _Wiro_data, sizeof(_Wiro_data)},
    {68, 195, "Enzo", _Enzo_data, sizeof(_Enzo_data)},
    {69, 196, "Elsu", _Elsu_data, sizeof(_Elsu_data)},
    {70, 199, "Eland'orr", _Elendor_data, sizeof(_Elendor_data)},
    {71, 206, "Charlotte", _Charlotte_data, sizeof(_Charlotte_data)},
    {72, 501, "Tel'Annas", _Telannas_data, sizeof(_Telannas_data)},
    {73, 502, "Astrid", _Astrid_data, sizeof(_Astrid_data)},
    {74, 503, "Zuka", _Zuka_data, sizeof(_Zuka_data)},
    {75, 504, "Wonder Woman", _WonderWoman_data, sizeof(_WonderWoman_data)},
    {76, 505, "Baldum", _Baldum_data, sizeof(_Baldum_data)},
    {77, 506, "Omen", _Omen_data, sizeof(_Omen_data)},
    {78, 507, "The Flash", _Flash_data, sizeof(_Flash_data)},
    {79, 508, "Wisp", _Wish_data, sizeof(_Wish_data)},
    {80, 509, "Y'bneth", _Ybnet_data, sizeof(_Ybnet_data)},
    {81, 510, "Liliana", _Liliana_data, sizeof(_Liliana_data)},
    {82, 511, "Ata", _Ata_data, sizeof(_Ata_data)},
    {83, 512, "Rourke", _Rourke_data, sizeof(_Rourke_data)},
    {84, 513, "Zata", _Zata_data, sizeof(_Zata_data)},
    {85, 514, "Roxie", _Roxie_data, sizeof(_Roxie_data)},
    {86, 515, "Richter", _Richter_data, sizeof(_Richter_data)},
    {87, 518, "Quillen", _Quilen_data, sizeof(_Quilen_data)},
    {88, 519, "Annette", _Annette_data, sizeof(_Annette_data)},
    {89, 520, "Veres", _Veres_data, sizeof(_Veres_data)},
    {90, 521, "Florentino", _Florentino_data, sizeof(_Florentino_data)},
    {91, 522, "Errol", _Errol_data, sizeof(_Errol_data)},
    {92, 523, "D'Arcy", _DArcy_data, sizeof(_DArcy_data)},
    {93, 524, "Capheny", _Capheny_data, sizeof(_Capheny_data)},
    {94, 525, "Zip", _Zip_data, sizeof(_Zip_data)},
    {95, 526, "Ishar", _Isha_data, sizeof(_Isha_data)},
    {96, 527, "Sephera", _Sephera_data, sizeof(_Sephera_data)},
    {97, 528, "Qi", _Qi_data, sizeof(_Qi_data)},
    {98, 529, "Volkath", _Volkath_data, sizeof(_Volkath_data)},
    {99, 530, "Dirak", _Dirak_data, sizeof(_Dirak_data)},
    {100, 531, "Keera", _Kerra_data, sizeof(_Kerra_data)},
    {101, 532, "Thorne", _Thorn_data, sizeof(_Thorn_data)},
    {102, 533, "Laville", _Lavie_data, sizeof(_Lavie_data)},
    {103, 534, "Dextra", _Dextra_data, sizeof(_Dextra_data)},
    {104, 535, "Sinestrea", _Sinestria_data, sizeof(_Sinestria_data)},
    {105, 536, "Aoi", _Aoi_data, sizeof(_Aoi_data)},
    {106, 537, "Allain", _Allain_data, sizeof(_Allain_data)},
    {107, 538, "Iggy", _Iggy_data, sizeof(_Iggy_data)},
    {108, 539, "Lorion", _Lorion_data, sizeof(_Lorion_data)},
    {109, 540, "Bright", _Bright_data, sizeof(_Bright_data)},
    {110, 541, "Bonnie", _Bonnie_data, sizeof(_Bonnie_data)},
    {111, 542, "Tachi", _Tachi_data, sizeof(_Tachi_data)},
    {112, 543, "Aya", _Aya_data, sizeof(_Aya_data)},
    {113, 544, "Yan", _Yan_data, sizeof(_Yan_data)},
    {114, 545, "Yue", _Yue_data, sizeof(_Yue_data)},
    {115, 546, "Terri", _Terri_data, sizeof(_Terri_data)},
    {116, 548, "Bijan", _Bijan_data, sizeof(_Bijan_data)},
    {117, 567, "Erin", _Erin_data, sizeof(_Erin_data)},
    {118, 568, "Ming", _Ming_data, sizeof(_Ming_data)},
    {119, 597, "Biron", _Biron_data, sizeof(_Biron_data)},
    {120, 598, "Bolt Baron", _BoltBaron_data, sizeof(_BoltBaron_data)},
    {121, 808, "Rối Athur", _Athur_data, sizeof(_Athur_data)},
    {122, 809, "Rối Tel'Annas",_Telannas_data, sizeof(_Telannas_data)},
    {123, 9001, "bocpha", bocpha, sizeof(bocpha)},
    {124, 9002, "camtru", camtru, sizeof(camtru) },
    {125, 9003, "capcuu", capcuu, sizeof(capcuu) },
    {126, 9004, "gamthet", gamthet, sizeof(gamthet) },
    {127, 9005, "ngatngu", ngatngu, sizeof(ngatngu) },
    {128, 9006, "suynhuoc", suynhuoc, sizeof(suynhuoc) },
    {129, 9007, "thanhtay", thanhtay, sizeof(thanhtay) },
    {130, 9008, "tocbien", tocbien, sizeof(tocbien) },
    {131, 9009, "tochanh", tochanh, sizeof(tochanh) },
    {132, 9010, "trungtri", trungtri, sizeof(trungtri) },
    {133, 599, "Billow", _Billow_data, sizeof(_Billow_data) },
    {134, 563, "Heino", _Heino_data, sizeof(_Heino_data) },
   // {135, 600, "Remahe", _Remahe_data, sizeof(_Remahe_data) },

};
HeroData findHeroById(int id) {
    std::string idStr = std::to_string(id); 
    char* name = new char[idStr.length() + 1];
    strcpy(name, idStr.c_str());
    for (const auto& hero : heroArray) {
        if (hero.heroid == id) {
            return hero;
        }
    }
     return { -1, -1, name , nullptr, 0 };
}

HeroData findHeroByName(const char* name) {
    for (size_t i = 120; i < sizeof(heroArray) / sizeof(heroArray[0]); ++i) {
        const auto& hero = heroArray[i];
        if (strcmp(hero.name, name) == 0) {
            return hero;
        }
    }
    return { -1,-1, "Unknown Hero", nullptr, 0 };
}
