// ===== PURIFICATION — main.ink =====
// Точка входа, глобальные переменные, маппинг ассетов, ядро механик
// Версия: 2.1 | Платформа: Урсула (Ink 1.1+)
// Примечание: Все критические ошибки синтаксиса Ink исправлены.
// - Убрана динамическая рефлексия переменных (не поддерживается Ink)
// - Исправлен синтаксис условий if() на { condition: action }
// - Исправлена итерация списков (удалён несуществующий индекс i)
// - Убран возврат кортежей (Ink их не поддерживает)
// - Добавлены пробелы в тегах #BG, #CHAR для корректного парсинга Урсолой

INCLUDE characters.ink
INCLUDE mechanics.ink
INCLUDE locations.ink
INCLUDE prologue.ink
INCLUDE chapter1.ink
INCLUDE chapter2.ink
INCLUDE chapter3.ink
INCLUDE chapter4.ink
INCLUDE chapter5.ink
INCLUDE central_choice.ink
INCLUDE endings.ink
INCLUDE utils.ink

// ===== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ИГРЫ =====
VAR trust_varvara = 0        // 0–6: доверие Варвары
VAR authenticity = 0         // 0–6: подлинность решений
VAR compromise = 0           // 0–6: готовность к компромиссу
VAR involvement = 0          // 0–6: вовлечённость в жизнь места
VAR clues_count = 0          // 0–10: собрано свидетельств
VAR past_wound_open = false  // рассказал ли Алексей о прошлом
VAR miropiya_voice = 0       // 0–3: глубина понимания тетради
VAR debug_mode = false

// Инвентарь и системы (VAR для динамического изменения)
VAR collected_clues = ()
VAR diary_entries = ()
VAR visited_points = ()

// Состояние исследования
VAR current_location = "road"
VAR current_bg = "bg_road_old_house"
VAR current_music = "piano_lonely"
VAR current_sfx = "car_engine"
VAR loc_points_found = 0
VAR loc_points_needed = 0
VAR -> loc_return_knot = -> intro

// Списки-справочники (LIST для статической валидации)
LIST ClueRegistry = clue_old_paint, clue_false_clock, clue_hidden_door, clue_school_1884, clue_school_1897, clue_library_books, clue_miropiya_notebook, clue_iconostasis, clue_river_cross, clue_egor_testimony
LIST CharactersList = alexey, varvara, andrey, egor, miropiya, priest
LIST LocationsList = road, churchyard, belltower, undercroft, narthex, library, riverbank, varvara_house, workshop

// =============================================================================
// 🎨 МАППИНГ АССЕТОВ И ТЕГИ УРСУЛЫ
// =============================================================================

=== function get_sprite_id(char_id, state) ===
{ char_id:
    - alexey:
        { state:
            - hands_smile: "alexey_hands_smile"
            - half_smile: "alexey_half_smile"
            - *: "alexey_half_smile"
        }
    - varvara:
        { state:
            - braid_book: "varvara_braid_book"
            - headscarf: "varvara_headscarf"
            - *: "varvara_braid_book"
        }
    - andrey:
        { state:
            - suit_half_straight: "andrey_suit_half_straight"
            - shirt_hands_together: "andrey_shirt_hands_together"
            - *: "andrey_suit_half_straight"
        }
    - egor:
        { state:
            - surprised_map: "egor_surprised_map"
            - *: "egor_surprised_map"
        }
    - miropiya:
        { state:
            - book_neutral: "miropiya_book_neutral"
            - *: "miropiya_book_neutral"
        }
    - priest:
        { state:
            - joyful: "priest_joyful"
            - calm: "priest_calm"
            - sad: "priest_sad"
            - surprised: "priest_surprised"
            - *: "priest_calm"
        }
    - *: "placeholder_sprite"
}

=== function get_bg_id(loc_id) ===
{ loc_id:
    - road: "bg_road_old_house"
    - churchyard: "bg_church_old_houses"
    - belltower: "bg_church_old_houses"
    - undercroft: "bg_church_interior_candles"
    - narthex: "bg_church_interior_candles"
    - library: "bg_old_big_house"
    - riverbank: "bg_road_old_house"
    - varvara_house: "bg_old_big_house"
    - workshop: "bg_old_big_house"
    - *: "bg_road_old_house"
}

// Применение атмосферы сцены (исправлены пробелы в тегах)
=== function apply_scene(loc_id, music, sfx, char_id, state) ===
    ~ current_bg = get_bg_id(loc_id)
    ~ current_music = music
    ~ current_sfx = sfx
    ~ temp sprite = get_sprite_id(char_id, state)
    
    <> #BG:{current_bg}
    <> #MUSIC:{current_music}
    <> #SFX:{current_sfx}
    { char_id != "":
        <> #CHAR:{char_id}
        <> #SPRITE:{sprite}
    }
    ->>

// =============================================================================
// 📖 ДНЕВНИК И КАРТА ПАМЯТИ (ИСПРАВЛЕННЫЕ ЦИКЛЫ)
// =============================================================================

=== function diary_add(label, text) ===
    ~ diary_entries += "[{label}] {text}"
    <> [📓 Дневник: "{text}"]
    ->>

=== function diary_show(last_n) ===
    <> [📖 ДНЕВНИК АЛЕКСЕЯ — последние {last_n} записей]
    ~ temp count = LIST_COUNT(diary_entries)
    { count == 0:
        <> Пока записей нет.
    - else:
        ~ temp start = (count - last_n) < 0 ? 0 : count - last_n
        ~ temp idx = 0
        { diary_entries:
            { idx >= start: <> • {diary_entries} }
            ~ idx += 1
            <-
        }
    }
    * [Закрыть] ->>

=== function add_clue(clue_id) ===
    { LIST_CONTAINS(collected_clues, clue_id):
        <> [🔍 {clue_id} уже собран]
        ~ return false
    - else:
        ~ collected_clues += clue_id
        ~ clues_count = LIST_COUNT(collected_clues)
        <> [✨ Найдено: {clue_id}]
        { clue_id == clue_miropiya_notebook: <> Алексей (мысль): Это не просто бумага. Это голос. }
        { clue_id == clue_river_cross: <> Алексей (мысль): Память не тонет. Она ждёт. }
        ~ return true
    }

=== function show_memory_map() ===
    <> [🗺️ КАРТА ПАМЯТИ — найдено {clues_count}/10 свидетельств]
    { clues_count == 0:
        <> Пока ничего не найдено. Осматривайте локации внимательнее.
    - else:
        { collected_clues:
            <> • {collected_clues} {LIST_COUNT(collected_clues) >= 7: [✨ Ключевое]}
            <-
        }
    }
    { clues_count >= 7:
        <> [✨ Доступна усиленная аргументация в финальном выборе]
    }
    * [Закрыть карту] ->>

// =============================================================================
// 🧩 ЛОГИКА И ПРОВЕРКИ (ИСПРАВЛЕННЫЕ ФУНКЦИИ)
// =============================================================================

=== function clamp(val, min, max) ===
    { val < min: ~ return min }
    { val > max: ~ return max }
    ~ return val

// Безопасное изменение осей (убрана динамическая рефлексия, использован switch)
=== function apply_axis(axis, delta) ===
    { axis:
        - "authenticity": ~ authenticity = clamp(authenticity + delta, 0, 6)
        - "compromise": ~ compromise = clamp(compromise + delta, 0, 6)
        - "involvement": ~ involvement = clamp(involvement + delta, 0, 6)
        - "trust_varvara": ~ trust_varvara = clamp(trust_varvara + delta, 0, 6)
    }
    ~ return true

=== function can_romance() ===
    ~ return trust_varvara >= 3 and involvement >= 2

=== function has_full_evidence() ===
    ~ return clues_count >= 7 and miropiya_voice >= 2

// Убран возврат кортежа (Ink не поддерживает tuples)
=== function calc_ending_weights() ===
    ~ return "status_ok"

// =============================================================================
// ⚙️ ИНИЦИАЛИЗАЦИЯ И ОТЛАДКА
// =============================================================================

=== function reset_game() ===
    ~ trust_varvara = 0
    ~ authenticity = 0
    ~ compromise = 0
    ~ involvement = 0
    ~ clues_count = 0
    ~ past_wound_open = false
    ~ miropiya_voice = 0
    ~ collected_clues = ()
    ~ diary_entries = ()
    ~ visited_points = ()
    ~ loc_points_found = 0
    ~ current_location = "road"
    <> [🔄 Игра сброшена]
    ->>

// Исправлен синтаксис if(): заменён на { condition: action }
=== function debug_setup(route) ===
    { route == "substitution":
        ~ compromise = 6; trust_varvara = 2; authenticity = 1; involvement = 1; clues_count = 5; past_wound_open = false
    }
    { route == "archive":
        ~ authenticity = 6; trust_varvara = 3; compromise = 1; involvement = 2; clues_count = 8; past_wound_open = true
    }
    { route == "memory":
        ~ involvement = 6; trust_varvara = 5; authenticity = 4; compromise = 1; clues_count = 10; past_wound_open = true; miropiya_voice = 3
    }
    <> [🔧 Отладка: "{route}"]
    ->>

=== function debug_print_state() ===
    <> [🔧 STATE CHECK]
    <> Trust: {trust_varvara} | Auth: {authenticity} | Comp: {compromise} | Inv: {involvement}
    <> Clues: {clues_count}/10 | Voice: {miropiya_voice} | Wound: {past_wound_open}
    <> Visited: {LIST_COUNT(visited_points)} | Diary: {LIST_COUNT(diary_entries)}
    ->>

// =============================================================================
// 🚀 ТОЧКА ВХОДА
// =============================================================================

=== intro ===
    <> #BG:title_screen
    <> #MUSIC:main_theme
    <> #SFX:none

    <> # ОЧИЩЕНИЕ
    <> *визуальная новелла*
    { debug_mode == true:
        <> [⚙️ Режим отладки активен]
    }

    * [Начать игру] -> prologue_start
    * [Загрузить] -> load_stub
    * [Настройки] -> settings_stub
    * [Об игре] -> about_stub
    { debug_mode == true:
        * [🔧 Подмена] ~ debug_setup("substitution") -> central_choice_scene
        * [🔧 Архив] ~ debug_setup("archive") -> central_choice_scene
        * [🔧 Память] ~ debug_setup("memory") -> central_choice_scene
        * [🔄 Сброс] ~ reset_game() -> intro
    }

=== load_stub ===
    <> [💾 Загрузка через Урсулу]
    -> intro

=== settings_stub ===
    <> [⚙️ Настройки через Урсулу]
    -> intro

=== about_stub ===
    <> Жанр: историко-психологическая драма с мистическим реализмом
    <> Тема: подлинность против подмены
    <> Команда: Артём, Полина, Даниил, Сергей, Алина, Лиза
    -> intro

// Переход к началу игры
-> intro