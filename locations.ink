// ===== locations.ink =====
// Регистр локаций, метаданных (фон/звук), интерактивных точек и логика наград
// Версия: 1.0 | Платформа: Урсула (Ink runtime)
// Зависимости: main.ink, mechanics.ink, characters.ink
// Примечание: Содержит только данные и хелперы. Движок исследования находится в mechanics.ink.

// Список доступных локаций для валидации и UI
LIST locations = road, churchyard, belltower, undercroft, narthex, library, riverbank, varvara_house, workshop

// =============================================================================
// 🎨 МЕТАДАННЫЕ ЛОКАЦИЙ (Фон, Музыка, Звук)
// Возвращают строковые ID ассетов для парсинга движком Урсула
// =============================================================================

=== function get_loc_bg(loc_id) ===
{ loc_id:
    - road: ~ return "bg_road_old_house"
    - churchyard: ~ return "bg_church_old_houses"
    - belltower: ~ return "bg_church_old_houses"
    - undercroft: ~ return "bg_church_interior_candles"
    - narthex: ~ return "bg_church_interior_candles"
    - library: ~ return "bg_old_big_house"
    - riverbank: ~ return "bg_road_old_house"
    - varvara_house: ~ return "bg_old_big_house"
    - workshop: ~ return "bg_old_big_house"
    - *: ~ return "bg_road_old_house"
}

=== function get_loc_music(loc_id) ===
{ loc_id:
    - road: ~ return "piano_lonely"
    - churchyard: ~ return "strings_tension"
    - belltower: ~ return "ambient_wind"
    - undercroft: ~ return "silence_tension"
    - narthex: ~ return "strings_tension"
    - library: ~ return "theme_varvara"
    - riverbank: ~ return "ambient_water"
    - varvara_house: ~ return "kitchen_warm"
    - workshop: ~ return "silence_tension"
    - *: ~ return "piano_lonely"
}

=== function get_loc_sfx(loc_id) ===
{ loc_id:
    - road: ~ return "car_engine"
    - churchyard: ~ return "wind_wood"
    - belltower: ~ return "wood_creak"
    - undercroft: ~ return "water_drip"
    - narthex: ~ return "paper_rustle"
    - library: ~ return "paper_rustle"
    - riverbank: ~ return "river_flow"
    - varvara_house: ~ return "kettle_boil"
    - workshop: ~ return "paper_rustle"
    - *: ~ return "none"
}

// =============================================================================
// 🔍 РЕЕСТР ИНТЕРАКТИВНЫХ ТОЧЕК И НАГРАД
// Каждая точка привязана к улике и изменению скрытых осей.
// Функция напрямую модифицирует глобальные переменные из main.ink
// =============================================================================

=== function apply_point_reward(point_id) ===
{ point_id:
    // Глава I: Церковный двор
    - "facade_hidden":
        ~ collected_clues += clue_hidden_door
        ~ authenticity = clamp(authenticity + 1, 0, 6)
        ~ diary_add("Осмотр", "След старого проёма. Обшивка скрывает прежнюю логику входа.")

    - "belltower_clock":
        ~ collected_clues += clue_false_clock
        ~ clues_count += 1

    - "steps_worn":
        ~ involvement = clamp(involvement + 1, 0, 6)
        ~ diary_add("Осмотр", "Ступень протёрта честно. Тысячи подошв доказали необходимость входа.")

    - "linden_tree":
        ~ involvement = clamp(involvement + 1, 0, 6)
        <> Егор Фомич наблюдает из-за угла. Липа — его личная граница.

    - "wall_cross":
        ~ authenticity = clamp(authenticity + 1, 0, 6)
        ~ collected_clues += clue_river_cross_hint // Промежуточный маркер для Главы V

    // Глава II: Притвор / Подклет
    - "paint_blue":
        ~ collected_clues += clue_old_paint
        ~ clues_count += 1
        ~ diary_add("Осмотр", "Синяя краска под поздним слоем. Церковь меняла облик не один раз.")

    - "door_trace":
        ~ collected_clues += clue_hidden_door
        ~ clues_count += 1
        ~ diary_add("Осмотр", "След двери. Здание заставили вести себя иначе.")

    - "wood_fragment":
        ~ collected_clues += clue_iconostasis
        ~ miropiya_voice = clamp(miropiya_voice + 1, 0, 3)
        ~ diary_add("Осмотр", "Фрагмент дерева. Лёгкий, но пальцы стали осторожными. Чужая рука из прошлого.")

    // Глава III: Библиотека
    - "archive_school84":
        ~ collected_clues += clue_school_1884
        ~ clues_count += 1
        ~ diary_add("Архив", "1884. Школа в наёмной избе. Храм, изба, дети, буквы.")

    - "archive_school97":
        ~ collected_clues += clue_school_1897
        ~ clues_count += 1
        ~ diary_add("Архив", "1897. Отдельное здание школы. Революция без лозунгов.")

    - "library_books":
        ~ collected_clues += clue_library_books
        ~ clues_count += 1
        ~ miropiya_voice = clamp(miropiya_voice + 1, 0, 3)
        ~ diary_add("Архив", "Книги XVII–XVIII веков. Их берегли. Передавали. Открывали руками.")

    // Глава IV-V: Река и Мастерская
    - "river_cross":
        ~ collected_clues += clue_river_cross
        ~ clues_count += 1
        ~ involvement = clamp(involvement + 1, 0, 6)
        ~ diary_add("Река", "Крест в воде. Память не исчезает, а меняет место хранения.")

    - "river_egor":
        ~ collected_clues += clue_egor_testimony
        ~ clues_count += 1
        ~ trust_varvara = clamp(trust_varvara + 1, 0, 6)
        ~ involvement = clamp(involvement + 1, 0, 6)

    - "workshop_notes":
        ~ compromise = clamp(compromise + 1, 0, 6)
        <> Рабочие черновики Андрея. Аккуратно, но без души.

    - "workshop_prep":
        ~ authenticity = clamp(authenticity + 1, 0, 6)
        <> Планшеты, бирки, проектор. Подготовка к презентации.

    - *: <> Ничего интересного для текущего осмотра.
}

// =============================================================================
// 🗺️ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ИНТЕРФЕЙСА И ОТЛАДКИ
// =============================================================================

// Получить список доступных точек для текущей локации (для UI-подсказок)
=== function get_available_points(loc_id) ===
{ loc_id:
    - churchyard: ~ return LIST(facade_hidden, belltower_clock, steps_worn, linden_tree, wall_cross)
    - narthex: ~ return LIST(paint_blue, door_trace, wood_fragment)
    - library: ~ return LIST(archive_school84, archive_school97, library_books)
    - riverbank: ~ return LIST(river_cross, river_egor)
    - workshop: ~ return LIST(workshop_notes, workshop_prep)
    - *: ~ return LIST()
}

// Проверить, осмотрена ли точка (безопасная обёртка)
=== function is_point_visited(point_id) ===
    ~ return LIST_CONTAINS(visited_points, point_id)

// Сбросить состояние локаций и точек осмотра (для отладки/новой игры)
=== function reset_locations() ===
    ~ visited_points = ()
    ~ clues_count = 0
    ~ collected_clues = ()
    <> [🔄 Состояние локаций и улик сброшено]
    ~ return value

// Синхронизация счётчика улик с размером списка (защита от рассинхрона)
=== function sync_clue_count() ===
    { clues_count != LIST_COUNT(collected_clues):
        ~ clues_count = LIST_COUNT(collected_clues)
    }
    ~ return true