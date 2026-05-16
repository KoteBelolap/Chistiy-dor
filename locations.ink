// ============================================================
// ОЧИЩЕНИЕ — locations.ink
// Локации, фоны, музыка и звуки
// ============================================================

// ------------------------------------------------------------
// ID локаций
// ------------------------------------------------------------

CONST LOC_ROAD = "road"
CONST LOC_CHURCH_YARD = "church_yard"
CONST LOC_BELL_TOWER = "bell_tower"
CONST LOC_UNDERCROFT = "undercroft"
CONST LOC_LIBRARY = "library"
CONST LOC_RIVER = "river"
CONST LOC_VARVARA_HOUSE = "varvara_house"
CONST LOC_WORKSHOP = "workshop"
CONST LOC_CHURCH_NIGHT = "church_night"
CONST LOC_BUS_STOP = "bus_stop"
CONST LOC_ARCHIVE = "archive"

// ------------------------------------------------------------
// Названия локаций
// ------------------------------------------------------------

CONST NAME_ROAD = "Дорога в Чистый Дор"
CONST NAME_CHURCH_YARD = "Двор Никольской церкви"
CONST NAME_BELL_TOWER = "Колокольня"
CONST NAME_UNDERCROFT = "Подклет"
CONST NAME_LIBRARY = "Сельская библиотека"
CONST NAME_RIVER = "Берег реки"
CONST NAME_VARVARA_HOUSE = "Дом Варвары"
CONST NAME_WORKSHOP = "Временная мастерская"
CONST NAME_CHURCH_NIGHT = "Никольская церковь (ночь)"
CONST NAME_BUS_STOP = "Автобусная остановка"
CONST NAME_ARCHIVE = "Читальный зал архива"

// ------------------------------------------------------------
// Текущая локация
// ------------------------------------------------------------

VAR current_location = LOC_ROAD
VAR current_location_name = NAME_ROAD

// ------------------------------------------------------------
// Фоны (BG)
// ------------------------------------------------------------

VAR bg_road = "road_wet_evening"
VAR bg_church_yard = "church_yard_day"
VAR bg_bell_tower = "bell_tower_interior"
VAR bg_undercroft = "undercroft_dark"
VAR bg_library = "library_day"
VAR bg_river = "river_morning"
VAR bg_varvara_house = "varvara_house_kitchen"
VAR bg_workshop = "workshop_night"
VAR bg_church_night = "church_night_lantern"
VAR bg_bus_stop = "bus_stop_dawn"
VAR bg_archive = "archive_hall"

// ------------------------------------------------------------
// Музыка (MUSIC)
// ------------------------------------------------------------

VAR music_road = "piano_low_melody"
VAR music_church_yard = "strings_soft"
VAR music_bell_tower = "silence"
VAR music_undercroft = "silence"
VAR music_library = "warm_tense"
VAR music_river = "river_night"
VAR music_varvara_house = "kitchen_rain"
VAR music_workshop = "tension"
VAR music_church_night = "silence"
VAR music_archive = "cold_calm"

// ------------------------------------------------------------
// Звуки (SFX)
// ------------------------------------------------------------

VAR sfx_road = "tires_water_drops"
VAR sfx_church_yard = "wind_grass"
VAR sfx_bell_tower = "wood_creak_wind"
VAR sfx_undercroft = "drip_breathing"
VAR sfx_library = "paper_rustle"
VAR sfx_river = "water_wind"
VAR sfx_varvara_house = "kettle_rain_roof"
VAR sfx_workshop = "camera_click"
VAR sfx_church_night = "wood_floor"
VAR sfx_bus_stop = "morning_silence"

// ------------------------------------------------------------
// Флаги посещения локаций
// ------------------------------------------------------------

VAR visited_road = false
VAR visited_church_yard = false
VAR visited_bell_tower = false
VAR visited_undercroft = false
VAR visited_library = false
VAR visited_river = false
VAR visited_varvara_house = false
VAR visited_workshop = false
VAR visited_church_night = false
VAR visited_bus_stop = false
VAR visited_archive = false

// ------------------------------------------------------------
// Функция смены локации
// ------------------------------------------------------------

=== change_location(new_loc) ===

~ current_location = new_loc

{
    - new_loc == LOC_ROAD:
        ~ current_location_name = NAME_ROAD
        // BG: {bg_road}
        // MUSIC: {music_road}
        // SFX: {sfx_road}
    
    - new_loc == LOC_CHURCH_YARD:
        ~ current_location_name = NAME_CHURCH_YARD
        // BG: {bg_church_yard}
        // MUSIC: {music_church_yard}
        // SFX: {sfx_church_yard}
    
    - new_loc == LOC_BELL_TOWER:
        ~ current_location_name = NAME_BELL_TOWER
        // BG: {bg_bell_tower}
        // MUSIC: {music_bell_tower}
        // SFX: {sfx_bell_tower}
    
    - new_loc == LOC_UNDERCROFT:
        ~ current_location_name = NAME_UNDERCROFT
        // BG: {bg_undercroft}
        // MUSIC: {music_undercroft}
        // SFX: {sfx_undercroft}
    
    - new_loc == LOC_LIBRARY:
        ~ current_location_name = NAME_LIBRARY
        // BG: {bg_library}
        // MUSIC: {music_library}
        // SFX: {sfx_library}
    
    - new_loc == LOC_RIVER:
        ~ current_location_name = NAME_RIVER
        // BG: {bg_river}
        // MUSIC: {music_river}
        // SFX: {sfx_river}
    
    - new_loc == LOC_VARVARA_HOUSE:
        ~ current_location_name = NAME_VARVARA_HOUSE
        // BG: {bg_varvara_house}
        // MUSIC: {music_varvara_house}
        // SFX: {sfx_varvara_house}
    
    - new_loc == LOC_WORKSHOP:
        ~ current_location_name = NAME_WORKSHOP
        // BG: {bg_workshop}
        // MUSIC: {music_workshop}
        // SFX: {sfx_workshop}
    
    - new_loc == LOC_CHURCH_NIGHT:
        ~ current_location_name = NAME_CHURCH_NIGHT
        // BG: {bg_church_night}
        // MUSIC: {music_church_night}
        // SFX: {sfx_church_night}
    
    - new_loc == LOC_BUS_STOP:
        ~ current_location_name = NAME_BUS_STOP
        // BG: {bg_bus_stop}
        // SFX: {sfx_bus_stop}
    
    - new_loc == LOC_ARCHIVE:
        ~ current_location_name = NAME_ARCHIVE
        // BG: {bg_archive}
        // MUSIC: {music_archive}
}

// Отмечаем посещение
{
    - new_loc == LOC_ROAD: ~ visited_road = true
    - new_loc == LOC_CHURCH_YARD: ~ visited_church_yard = true
    - new_loc == LOC_BELL_TOWER: ~ visited_bell_tower = true
    - new_loc == LOC_UNDERCROFT: ~ visited_undercroft = true
    - new_loc == LOC_LIBRARY: ~ visited_library = true
    - new_loc == LOC_RIVER: ~ visited_river = true
    - new_loc == LOC_VARVARA_HOUSE: ~ visited_varvara_house = true
    - new_loc == LOC_WORKSHOP: ~ visited_workshop = true
    - new_loc == LOC_CHURCH_NIGHT: ~ visited_church_night = true
    - new_loc == LOC_BUS_STOP: ~ visited_bus_stop = true
    - new_loc == LOC_ARCHIVE: ~ visited_archive = true
}

->->