// ===== chapter1.ink =====
// Глава I. Первая встреча с Варварой, осмотр двора, формирование начального доверия.
// Версия: 2.0 | Платформа: Урсула (Ink runtime)
// Исправления:
// - Синхронизированы имена переменных с main.ink/mechanics.ink (loc_points_found вместо LOC_POINTS_FOUND)
// - Добавлены пробелы в тегах #BG, #CHAR для корректного парсинга Урсолой
// - Убраны лишние переносы строк в ID спрайтов
// - Проверена логика вызова check_point() и apply_scene()

-> I_01_churchyard_meeting

=== I_01_churchyard_meeting
{ apply_scene("churchyard", "strings_tension", "wind_wood", "andrey", "suit_half_straight") }

-> say(andrey, suit_half_straight, "Сейчас познакомлю тебя с местными. Главное — спокойно. Здесь люди хорошие, но память у них с зубами.")
-> say(alexey, half_smile, "Хорошее качество для памяти.")
-> say(andrey, suit_half_straight, "Для памяти — да. Для презентации — не всегда.")

{ apply_scene("churchyard", current_music, current_sfx, "varvara", "braid_book") }
-> say(varvara, braid_book, "Презентация ещё не началась, а вы уже решили, что мешает?")
-> set_sprite(andrey, suit_half_straight)
-> say(andrey, suit_half_straight, "Варвара Белова. Наш главный человек по местной части.")
-> set_sprite(varvara, braid_book)
-> say(varvara, braid_book, "Не главный. Просто я помню, где что лежит. А ещё помню, кто уже обещал «сделать красиво».")
-> set_sprite(alexey, hands_smile)
-> say(alexey, hands_smile, "Алексей Воронцов. Я не обещаю красиво.")
-> set_sprite(varvara, braid_book)
-> say(varvara, braid_book, "Это уже лучше. А что обещаете?")

// CHOICE I_A. Первая реакция на Варвару
* [«Обещаю не называть гипотезу фактом.»]
    ~ apply_axis("authenticity", 1)
    <> [📈 Подлинность: +1]
    -> say(alexey, half_smile, "Обещаю не называть гипотезу фактом.")
    -> say(varvara, braid_book, "Тогда пройдёмся. Начнём с того, что здесь слишком много людей называли фактом собственное удобство.")
    -> I_02_explore_churchyard

* [«Пока ничего. Мне нужно обследование, а не знакомство с ожиданиями.»]
    ~ apply_axis("compromise", 1)
    <> [📈 Компромисс: +1]
    -> say(alexey, half_smile, "Пока ничего. Мне нужно обследование, а не знакомство с ожиданиями.")
    -> say(varvara, headscarf, "Ожидания здесь тоже часть обследования. Но можете начать с дерева, если с людьми сложнее.")
    -> I_02_explore_churchyard

* [«Обещаю сказать, если не знаю. И спросить, если место знает больше меня.»]
    ~ apply_axis("trust_varvara", 1)
    ~ apply_axis("involvement", 1)
    <> [💚 Доверие: +1 | 📈 Вовлечённость: +1]
    -> say(alexey, hands_smile, "Обещаю сказать, если не знаю. И спросить, если место знает больше меня.")
    -> say(varvara, braid_book, "Редкая формулировка для приезжего специалиста. Ладно. Попробуем.")
    -> I_02_explore_churchyard

=== I_02_explore_churchyard
// Механика: Point-and-Click осмотр двора. Требуется 3 точки для продолжения.
{ apply_scene("churchyard", current_music, current_sfx, "alexey", "half_smile") }
<> [🔍 Церковный двор: осмотрено {loc_points_found}/3 точек]

* [Осмотреть главный фасад]
    { check_point("facade_hidden") }
    -> say(varvara, braid_book, "Вы тоже это видите?")
    -> say(alexey, half_smile, "Пока только подозреваю.")
    -> say(varvara, braid_book, "Хорошо. Подозрение честнее уверенности, когда уверенность ещё не заработали.")
    -> I_02_explore_churchyard

* [Подойти к колокольне]
    { check_point("belltower_clock") }
    -> say(alexey, hands_smile, "Часы нарисованные?")
    -> say(varvara, braid_book, "Ложные циферблаты. Детям раньше нравилось. Они спорили, почему время не идёт.")
    -> say(alexey, half_smile, "Показывают шесть семнадцать.")
    -> say(varvara, braid_book, "Я думала, это случайность.")
    -> say(alexey, half_smile, "Может быть. А может, год постройки научился притворяться временем.")
    -> I_02_explore_churchyard

* [Пройтись по ступеням]
    { check_point("steps_worn") }
    ~ involvement = clamp(involvement + 1, 0, 6)
    -> alexey_thought("Ступень была протёрта не красиво, а честно. Тысячи подошв сделали с деревом то, чего не умеет ни один проектировщик: доказали необходимость входа.")
    -> I_02_explore_churchyard

* [Спросить о старой липе]
    { check_point("linden_tree") }
    { apply_scene("churchyard", current_music, current_sfx, "egor", "surprised_map") }
    -> say(egor, surprised_map, "Липу не трогайте.")
    -> say(alexey, half_smile, "Мы и не собирались.")
    -> say(egor, surprised_map, "Все сначала не собираются. Потом им вид портит.")
    -> set_sprite(varvara, braid_book)
    -> say(varvara, braid_book, "Егор Фомич, это Алексей. Он будет смотреть церковь.")
    -> say(egor, surprised_map, "Церковь пусть смотрит на него. Ей виднее.")
    -> I_02_explore_churchyard

* [Осмотреть крест у стены]
    { check_point("wall_cross") }
    ~ authenticity = clamp(authenticity + 1, 0, 6)
    -> say(alexey, hands_smile, "Этот крест откуда?")
    -> say(varvara, braid_book, "Нашли рядом во время работ. Не единственный. Здесь вещи иногда возвращаются не туда, откуда ушли, а туда, где их наконец замечают.")
    -> I_02_explore_churchyard

* [Закончить осмотр двора]
    { loc_points_found < 3:
        <> [⚠️ Нужно осмотреть минимум 3 точки, прежде чем продолжить.]
        -> I_02_explore_churchyard
    - else:
        <> [✅ Осмотр завершён. Переходим к входу.]
        -> I_03_conclusion
    }

=== I_03_conclusion
{ apply_scene("churchyard", current_music, current_sfx, "andrey", "suit_half_straight") }
-> say(andrey, suit_half_straight, "Красиво говорите, Варвара. Это можно использовать.")
-> set_sprite(varvara, braid_book)
-> say(varvara, braid_book, "Нельзя.")
-> say(andrey, suit_half_straight, "Почему?")
-> say(varvara, braid_book, "Потому что я не слоган сказала.")
-> set_sprite(alexey, half_smile)
-> say(alexey, half_smile, "Андрей, давай сначала обследуем.")
-> say(andrey, suit_half_straight, "Обследуйте. Но держите в голове: нам нужна история. Без истории никто не даст денег на доски.")
-> set_sprite(varvara, braid_book)
-> say(varvara, braid_book, "История здесь есть. Вопрос в том, выдержите ли вы её без косметики.")
-> alexey_thought("Она сказала это Андрею. Попала почему-то в меня.")

<> [📓 Дневник: «Первый осмотр. Колокольня, ложные часы, следы закрытых проёмов. Варвара не доверяет. И, вероятно, правильно делает».]
~ diary_add("Глава I", "Первый осмотр. Колокольня, ложные часы, следы закрытых проёмов. Варвара не доверяет. И, вероятно, правильно делает.")

* [Перейти к колокольне и подклету] -> II_01_start