// ===== mechanics.ink =====
// Реализация механик: скрытые оси, доверие, карта памяти, дневник, исследование, маршрутизация концовок
// Версия: 2.0 | Платформа: Урсула (Ink runtime)
// Исправления:
// - Удалена функция adjust_stat с динамическими именами переменных (не поддерживается Ink)
// - apply_axis теперь использует switch-синтаксис для прямого изменения VAR
// - Исправлена конкатенация строк в check_point (убран префикс локации)
// - make_core_choice переименован из function в обычный knot (функции не могут делать -> к узлам контента)
// - Добавлен clamp() для безопасного ограничения значений [0; 6]
// - Синхронизированы имена переменных с main.ink (loc_points_found, visited_points)

// =============================================================================
// 🛠️ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// =============================================================================

// Безопасное ограничение значения диапазоном [min, max]
=== function clamp(val, min, max) ===
    { val < min: ~ return min }
    { val > max: ~ return max }
    ~ return val

// =============================================================================
// 📊 УПРАВЛЕНИЕ СКРЫТЫМИ ОСЯМИ (0–6)
// =============================================================================

// Применить изменение к переменной и обновить её значение
// Исправлено: вместо динамического имени используется switch
=== function apply_axis(axis, delta) ===
    { axis:
        - "authenticity": ~ authenticity = clamp(authenticity + delta, 0, 6)
        - "compromise": ~ compromise = clamp(compromise + delta, 0, 6)
        - "involvement": ~ involvement = clamp(involvement + delta, 0, 6)
        - "trust_varvara": ~ trust_varvara = clamp(trust_varvara + delta, 0, 6)
    }
    <> [📈 {axis}: {delta >= 0 ? "+"}{delta}]
    ->>

// Получить текущий уровень оси текстом (для отладки или скрытых проверок)
=== function get_axis_level(value) ===
    { value:
        - 0, 1: "Низкий"
        - 2, 3: "Средний"
        - 4, 5: "Высокий"
        - 6: "Максимальный"
        - *: "Неизвестно"
    }

// =============================================================================
// 🤝 СИСТЕМА ДОВЕРИЯ (ВАРВАРА)
// =============================================================================

// Проверка порога доверия для разблокировки сцен/реплик
=== function trust_check(min_val) ===
    ~ return trust_varvara >= min_val

// Уровень отношений для скрытой логики диалогов
=== function varvara_relationship_state() ===
    { trust_varvara:
        - 0, 1: "distant"   // Настороженность, формальность
        - 2, 3: "cautious"  // Профессиональное уважение, проверка на прочность
        - 4, 5: "warm"      // Личная близость, готовность делиться болью
        - 6: "bond"         // Глубокое доверие, партнёрство и любовь
        - *: "unknown"
    }

// Функция-обёртка для изменения доверия с логированием в дневник
=== function change_trust(amount, context_label) ===
    ~ temp old_val = trust_varvara
    ~ trust_varvara = clamp(trust_varvara + amount, 0, 6)
    { trust_varvara != old_val:
        { amount > 0: <> [💚 Доверие Варвары выросло] | <> [💔 Доверие Варвары снизилось] }
        ~ diary_add(context_label, "Уровень доверия с Варварой: {get_axis_level(trust_varvara)}")
    }
    ->>

// =============================================================================
// 🔍 КАРТА ПАМЯТИ И УЛИКИ
// =============================================================================

// Добавление находки в коллекцию
=== function collect_clue(clue_id) ===
    { LIST_CONTAINS(collected_clues, clue_id):
        <> [🔍 {clue_id} уже в коллекции]
        ~ return false
    - else:
        ~ collected_clues += clue_id
        ~ clues_count = LIST_COUNT(collected_clues)
        <> [✨ Найдено: {clue_id}]
        ~ diary_add("Находка", "В коллекцию добавлено: {clue_id}")
        ~ return true
    }

// Проверка наличия конкретной улики
=== function has_clue(clue_id) ===
    ~ return LIST_CONTAINS(collected_clues, clue_id)

// Проверка достаточности свидетельств для усиленной аргументации
=== function memory_map_complete() ===
    ~ return clues_count >= 7

// Отображение карты памяти (вызывается перед центральным выбором)
// Исправлено: убран несуществующий индекс i, используется прямой вывод элемента списка
=== function show_memory_map_ui() ===
    <> [🗺️ КАРТА ПАМЯТИ — собрано {clues_count} из 10 свидетельств]
    { clues_count == 0:
        <> Пока ничего не найдено. Осмотрите локации внимательнее.
    - else:
        { collected_clues:
            <> • {collected_clues} {LIST_COUNT(collected_clues) >= 7: [⚡ Ключевое]}
            <-
        }
    }
    { clues_count >= 7:
        <> [⚡ Доступна полная аргументация в финальном выборе]
    }
    * [Закрыть карту] ->>

// =============================================================================
// 📖 ДНЕВНИК АЛЕКСЕЯ
// =============================================================================

// Добавить запись с меткой и текстом
=== function diary_add(label, text) ===
    ~ diary_entries += "[{label}] {text}"
    // Вывод в консоль/экран только в отладке или при явном вызове
    // { debug_mode == true: <> [📓 {label}: {text}] }
    ->>

// Показать последние N записей
// Исправлено: убран несуществующий индекс i, используется счетчик idx
=== function diary_show(last_n) ===
    <> [📖 ДНЕВНИК АЛЕКСЕЯ — последние {last_n} записей]
    ~ temp count = LIST_COUNT(diary_entries)
    { count == 0:
        <> Записей пока нет.
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

// Записать профессиональную или личную рефлексию (автоматически определяет тип)
=== function diary_reflect(text, is_personal) ===
    ~ diary_add(is_personal ? "Личное" : "Проф. заметка", text)
    ->>

// =============================================================================
// 🚶 ИССЛЕДОВАНИЕ ЛОКАЦИЙ (POINT-AND-CLICK ТРЕКИНГ)
// =============================================================================

// Примечание: Переменные loc_points_found, loc_points_needed, loc_return_knot, visited_points
// объявлены в main.ink. Здесь они используются.

// Инициализация цикла осмотра
=== function start_exploration(loc, points_needed, -> return_knot) ===
    ~ current_location = loc // Для справки
    ~ loc_points_needed = points_needed
    ~ loc_points_found = 0
    ~ loc_return_knot = return_knot
    -> explore_loop

// Внутренний цикл осмотра
=== explore_loop ===
    { loc_points_found >= loc_points_needed:
        <> [✅ Осмотр завершён. Достаточно данных для продолжения.]
        -> loc_return_knot
    - else:
        <> [🔍 {current_location}: осмотрено {loc_points_found}/{loc_points_needed} точек]
        // Сцены вызывают check_point() вручную или через выборы
        -> _explore_wait

=== _explore_wait ===
    * [Продолжить осмотр] -> loc_return_knot
    * [Покинуть локацию] -> return

// Отметить точку как осмотренную. Возвращает true, если точка новая.
// Исправлено: убрана конкатенация строк key = loc + "_" + point_id. 
// point_id глобально уникален в проекте.
=== function check_point(point_id) ===
    { LIST_CONTAINS(visited_points, point_id):
        <> [🔍 Эта точка уже осмотрена]
        ~ return false
    - else:
        ~ visited_points += point_id
        ~ loc_points_found += 1
        <> [✨ Точка осмотрена: {point_id}]
        ~ apply_point_reward(point_id) // Вызывает функцию из locations.ink
        -> explore_loop
        ~ return true
    }

// =============================================================================
// 🔀 ЦЕНТРАЛЬНЫЙ ВЫБОР И МАРШРУТИЗАЦИЯ КОНЦОВОК
// =============================================================================

// Исправлено: это больше не function, а обычный knot, так как он делает переходы ->
=== make_core_choice(route) ===
    { route:
        - "substitution":
            ~ compromise = clamp(compromise + 3, 0, 6)
            <> [⚖️ Выбран путь: Подмена]
            ~ diary_add("Главный выбор", "Я решил опереться на ясную концепцию. Место выживет, но ценой упрощения.")
            -> ending_substitution_start
        - "archive":
            ~ authenticity = clamp(authenticity + 3, 0, 6)
            <> [⚖️ Выбран путь: Архив]
            ~ diary_add("Главный выбор", "Я не имею права искажать факты. Пусть всё будет строго, даже если это заморозит место.")
            -> ending_archive_start
        - "memory":
            ~ involvement = clamp(involvement + 3, 0, 6)
            ~ trust_varvara = clamp(trust_varvara + 1, 0, 6)
            <> [⚖️ Выбран путь: Память]
            ~ diary_add("Главный выбор", "Я останусь с правдой. Неровной, сложной, живой. Как просила Миропия.")
            -> ending_memory_start
    }

// Расчёт "веса" концовки (внутренняя логика для проверки полноты варианта)
// Исправлено: Ink не поддерживает возврат кортежей {a, b, c}. 
// Функция удалена или заменена на заглушку, так как логика распределена по условиям в endings.ink
=== function calculate_ending_quality(route) ===
    ~ return "unused" 

// Проверка готовности к финальному разветвлению
=== function is_ready_for_final_choice() ===
    { clues_count < 3:
        <> [⚠️ У вас слишком мало свидетельств. Решение будет принято на интуиции, а не на фактах.]
        ~ return "low_evidence"
    - else:
        ~ return "ready"
    }

// =============================================================================
// 🛠️ ОТЛАДКА И УТИЛИТЫ
// =============================================================================

// Быстрый сброс механик (не трогает прогресс сцен)
=== function reset_mechanics() ===
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
    <> [🔄 Механики сброшены]
    ->>

// Показать текущее состояние переменных (для отладки)
=== function debug_print_state() ===
    <> [🔧 STATE CHECK]
    <> Trust: {trust_varvara} | Auth: {authenticity} | Comp: {compromise} | Inv: {involvement}
    <> Clues: {clues_count}/10 | Voice: {miropiya_voice} | Wound: {past_wound_open}
    <> Visited: {LIST_COUNT(visited_points)} | Diary: {LIST_COUNT(diary_entries)}
    ->>

// Валидатор перед сохранением (проверяет целостность данных)
=== function validate_save_state() ===
    { clues_count != LIST_COUNT(collected_clues):
        ~ clues_count = LIST_COUNT(collected_clues)
        <> [🔧 Счётчик улик синхронизирован]
    }
    { trust_varvara > 6 or trust_varvara < 0:
        ~ trust_varvara = clamp(trust_varvara, 0, 6)
    }
    { authenticity > 6 or authenticity < 0:
        ~ authenticity = clamp(authenticity, 0, 6)
    }
    { compromise > 6 or compromise < 0:
        ~ compromise = clamp(compromise, 0, 6)
    }
    { involvement > 6 or involvement < 0:
        ~ involvement = clamp(involvement, 0, 6)
    }
    ~ return true