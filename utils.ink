// ===== utils.ink =====
// Вспомогательные функции, управление атмосферой, UI-заглушки, отладка и валидация
// Версия: 1.0 | Платформа: Урсула (Ink 1.1+)
// Примечание: Не дублирует логику из mechanics.ink/locations.ink. Содержит только инфраструктурный слой.

// =============================================================================
// 🔧 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// =============================================================================

// Ограничение значения диапазоном [min, max] (безопасный clamp)
=== function clamp(val, min, max) ===
    { val < min: ~ return min }
    { val > max: ~ return max }
    ~ return val

// Проверка, находится ли переменная в допустимых пределах
=== function is_var_in_range(val, min, max) ===
    ~ return val >= min and val <= max

// =============================================================================
// 🎨 УПРАВЛЕНИЕ АТМОСФЕРОЙ И ТЕГАМИ УРСУЛЫ
// Возвращает поток в вызывающую сцену (->>)
// =============================================================================

// Смена фона, музыки и SFX
=== function set_atmosphere(bg, music, sfx) ===
    ~ current_bg = bg
    ~ current_music = music
    ~ current_sfx = sfx
    <> #BG:{bg} #MUSIC:{music} #SFX:{sfx}
    ~ return value

// Показать персонажа с нужным состоянием спрайта
=== function show_char(char_id, state) ===
    ~ temp sprite = get_sprite_id(char_id, state)
    <> #CHAR:{char_id} #SPRITE:{sprite}
    ~ return value

// Скрыть всех персонажей (очистка сцены)
=== function clear_scene_chars() ===
    <> #CHAR:none #SPRITE:none
    ~ return value

// Быстрая смена локации без пересоздания сцены (для плавных переходов)
=== function transition_to(loc_id, music, sfx) ===
    ~ set_atmosphere(get_bg_id(loc_id), music, sfx)
    ~ return value

// =============================================================================
// 🛠️ СИСТЕМНЫЕ ЗАГЛУШКИ (ИНТЕГРАЦИЯ С УРСУЛОЙ)
// =============================================================================

=== save_game_stub ===
    <> [💾 Сохранение...]
    // Урсула автоматически сериализует все VAR и LIST в этот момент
    <> [✅ Прогресс сохранён]
    ~ return value

=== load_game_stub ===
    <> [💾 Загрузка...]
    // Урсула восстанавливает состояние переменных из последнего сейва
    <> [✅ Игра загружена]
    ~ return value

=== settings_stub ===
    <> [⚙️ Настройки]
    <> • Скорость текста: Стандартная | Быстрая | Мгновенная
    <> • Громкость музыки: 80%
    <> • Громкость SFX: 70%
    <> • Режим окна: Полный экран
    * [Сохранить настройки]
        ~ return value
    * [Отмена] 
    ~ return value

=== quick_menu ===
    <> [⏸️ Пауза]
    * [Продолжить]
        ~ return value
    * [Сохранить] ~ save_game_stub() -> quick_menu
    * [Загрузить] ~ load_game_stub() -> quick_menu
    * [Настройки] -> settings_stub
    * [В главное меню] -> return_to_menu
    * [Отладка (Dev)] ~ debug_print_state() -> quick_menu    
    ~ return value

=== return_to_menu ===
    <> [⚠️ Выход в главное меню приведёт к потере несохранённого прогресса.]
    * [Подтвердить] -> intro
    * [Отмена]
    ~ return value

// =============================================================================
// 🐛 ОТЛАДКА И ТЕСТИРОВАНИЕ
// =============================================================================

=== debug_print_state ===
    <> [🔧 STATE DUMP]
    <> Доверие: {trust_varvara} | Подлинность: {authenticity} | Компромисс: {compromise} | Вовлечённость: {involvement}
    <> Улики: {clues_count}/10 | Голос: {miropiya_voice} | Травма: {past_wound_open}
    <> Дневник: {LIST_COUNT(diary_entries)} записей | Точки: {LIST_COUNT(visited_points)} осмотрено
    ~ return value

=== debug_force_route(route) ===
    { route:
        - "substitution": ~ compromise=6; trust_varvara=1; authenticity=1; involvement=1; clues_count=4; past_wound_open=false
        - "archive": ~ authenticity=6; trust_varvara=3; compromise=1; involvement=2; clues_count=7; past_wound_open=true
        - "memory": ~ involvement=6; trust_varvara=5; authenticity=4; compromise=1; clues_count=10; past_wound_open=true; miropiya_voice=3
    }
    <> [🔧 Принудительная маршрутизация: {route}]
    { route == "substitution": -> ending_substitution_start }
    { route == "archive": -> ending_archive_start }
    { route == "memory": -> ending_memory_start }

=== debug_reset_full ===
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
    ~ current_bg = "bg_road_old_house"
    ~ current_music = "piano_lonely"
    ~ current_sfx = "car_engine"
    <> [🔄 Полный сброс состояния]
    -> intro

=== debug_test_ui ===
    <> [🧪 Тест интерфейса]
    * [Открыть дневник] -> view_diary_ui
    * [Открыть карту памяти] -> view_memory_map_ui
    * [Назад]
        ~ return value

=== view_diary_ui ===
    <> [📖 ДНЕВНИК АЛЕКСЕЯ]
    { LIST_COUNT(diary_entries) == 0:
        <> Пока записей нет.
    - else:
        { diary_entries:
            <> • {diary_entries}
        }
    }
    * [Закрыть]
        ~ return value

=== view_memory_map_ui ===
    <> [🗺️ КАРТА ПАМЯТИ ({clues_count}/10)]
    { LIST_COUNT(collected_clues) == 0:
        <> Собрано 0 свидетельств.
    - else:
        { collected_clues:
            <> • {collected_clues} {collected_clues == clue_river_cross or collected_clues == clue_miropiya_notebook: [✨]}
        }
    }
    { clues_count >= 7: <> [⚡ Полная аргументация доступна в финале] }
    * [Закрыть]
        ~ return value

// =============================================================================
// ✅ ВАЛИДАЦИЯ И СИНХРОНИЗАЦИЯ СОСТОЯНИЯ
// Вызывается перед сохранением или в начале новой главы
// =============================================================================

=== function validate_and_sync() ===
    // Синхронизация счётчика улик с реальным размером списка
    { LIST_COUNT(collected_clues) != clues_count:
        ~ clues_count = LIST_COUNT(collected_clues)
    }
    
    // Принудительный clamp осей
    ~ trust_varvara = clamp(trust_varvara, 0, 6)
    ~ authenticity = clamp(authenticity, 0, 6)
    ~ compromise = clamp(compromise, 0, 6)
    ~ involvement = clamp(involvement, 0, 6)
    
    // Проверка флагов
    { past_wound_open != true && past_wound_open != false: ~ past_wound_open = false }
    { miropiya_voice < 0: ~ miropiya_voice = 0 }
    { miropiya_voice > 3: ~ miropiya_voice = 3 }
    
    ~ return true

// =============================================================================
// 📦 ГОТОВНОСТЬ К СБОРКЕ
// =============================================================================
// Данный модуль не содержит игровой логики, а обеспечивает:
// 1. Безопасное управление тегами платформы Урсула (#BG, #MUSIC, #CHAR, #SPRITE)
// 2. Стабильные заглушки для сохранений/настроек (интегрируются через API движка)
// 3. Быструю отладку маршрутов без прохождения всей игры
// 4. Автоматическую синхронизацию переменных перед сохранением
// 5. Чистый возврат в сцену через ->> после вызова утилит