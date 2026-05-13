// ===== chapter5.ink =====
// Глава V. Крест в воде
// Версия: 1.0 | Платформа: Урсула (Ink runtime)
// Зависимости: main.ink, characters.ink, mechanics.ink, locations.ink, endings.ink

-> V_01_river_morning

=== V_01_river_morning
// SCENE V_01. Берег реки / утро
{ apply_scene("riverbank", "ambient_water", "river_flow", "egor", "surprised_map") }

-> say(egor, surprised_map, "Не люблю я это место.")
-> say(varvara, braid_book, "Вы сами сказали, что надо показать.")
-> say(egor, surprised_map, "Сказал. А люблю — не говорил.")
-> set_sprite(alexey, half_smile)
-> say(alexey, half_smile, "Здесь нашли крест?")
-> say(egor, surprised_map, "Не здесь. Чуть ниже. Вода тогда ушла. Мальчишки полезли за железом, а вытащили не железо.")

// CHOICE V_A. Как расспрашивать Егора Фомича?
* [Осторожно, через память.]
    ~ involvement += 1
    ~ trust_varvara += 1
    ~ collect_clue("clue_river_cross")
    ~ diary_add("Река", "Осторожный расспрос. Даты — для бумаги. Память — для людей.")
    -> say(alexey, half_smile, "Не спешите. Как вам рассказывали, так и скажите. Даже если даты не помните.")
    -> say(egor, surprised_map, "Даты — это для бумаги. А я помню, как дед молчал, когда про это говорили. Значит, не рыбацкая байка была.")
    -> V_02_workshop

* [Жёстко, ради точности.]
    ~ authenticity += 1
    ~ trust_varvara -= 1
    ~ collect_clue("clue_river_cross")
    ~ diary_add("Река", "Нужны детали. Профессиональная дурь. Спросить по-человечески не учили?")
    -> say(alexey, half_smile, "Мне нужны детали: кто нашёл, когда, куда дели крест.")
    -> say(egor, surprised_map, "Нужны ему. Тут всем всё нужно. А спросить по-человечески не учили?")
    -> set_sprite(varvara, headscarf)
    -> say(varvara, headscarf, "Алексей.")
    -> set_sprite(alexey, half_smile)
    -> say(alexey, half_smile, "Извините. Профессиональная дурь.")
    -> V_02_workshop

* [Сразу искать эффектный сюжет.]
    ~ compromise += 1
    ~ collect_clue("clue_river_cross")
    ~ diary_add("Река", "Если крест прятали — центральная линия. Страх стал сюжетом.")
    -> say(alexey, half_smile, "Если крест действительно прятали, это может стать центральной линией.")
    -> say(egor, surprised_map, "Линией у вас будет. А у нас это страх был.")
    -> V_02_workshop

=== V_02_workshop
// SCENE V_02. Временная мастерская / новые находки
{ apply_scene("workshop", "silence_tension", "paper_rustle", "andrey", "suit_half_straight") }

-> say(andrey, suit_half_straight, "Вот теперь у нас появилась история.")
-> set_sprite(varvara, braid_book)
-> say(varvara, braid_book, "Она и раньше была.")
-> say(andrey, suit_half_straight, "Была россыпь. Теперь — нерв. Учительница, книги, крест, река, церковь. Это можно собрать.")
-> set_sprite(alexey, half_smile)
-> say(alexey, half_smile, "Собрать — да. Сжать до плаката — нет.")
-> say(andrey, suit_half_straight, "Ты заранее слышишь худшее. Я предлагаю шанс. Объект не под охраной так, как должен. Деньги сами не придут. Люди не будут читать двадцать страниц оговорок.")
-> say(varvara, braid_book, "А если они услышат только то, что вы решили за них?")
-> say(andrey, suit_half_straight, "Они услышат то, что позволит начать работы.")
-> say(alexey, half_smile, "Какие именно работы?")
-> say(andrey, suit_half_straight, "Визуальное восстановление, маршрут, выставка, сильная легенда. Не ложь. Композиция.")
-> say(varvara, braid_book, "Когда чужую жизнь режут до удобной композиции, это и есть ложь. Просто с хорошим шрифтом.")
-> say(andrey, suit_half_straight, "Варвара, я понимаю вашу боль. Но боль не оплачивает реставраторов.")
-> say(varvara, braid_book, "Зато оплаченная фальшь отлично хоронит боль.")
-> say(andrey, suit_half_straight, "Лёш, скажи ей. Ты же понимаешь. Мы можем сделать идеально чистый проект. Белая церковь, найденная тетрадь, крест из воды, учительница как символ памяти. Это сработает.")
-> say(alexey, half_smile, "Слишком хорошо сработает.")
-> say(andrey, suit_half_straight, "И что в этом плохого?")
-> say(alexey, half_smile, "Если история слишком гладкая, по ней уже никто не спотыкается. А здесь надо споткнуться.")
-> alexey_thought("Андрей не злодей. Он предлагает выжить. Но я впервые вижу, как моя старая травма надевает его лицо.")
-> V_03_preparation

=== V_03_preparation
// SCENE V_03. Подготовка к центральному выбору
{ apply_scene("workshop", current_music, current_sfx, "alexey", "half_smile") }
<> [🗺️ Подготовка к главному выбору]
{ show_memory_map_ui() }

-> say(andrey, suit_half_straight, "Я завтра встречаюсь с фондом. Мне нужен ответ сегодня. Не философия. Решение.")
-> set_sprite(varvara, headscarf)
-> say(varvara, headscarf, "Алексей, вы сейчас выбираете не между мной и Андреем Михайловичем.")
-> set_sprite(alexey, half_smile)
-> say(alexey, half_smile, "А между чем?")
-> say(varvara, headscarf, "Между тремя способами отнять у места голос. Первый — накрыть его красивой легендой. Второй — унести всё в архив и оставить здесь тишину. Третий — самый трудный. Дать ему говорить неровно, с паузами, с трещинами. Так, как говорят живые.")
-> say(andrey, suit_half_straight, "Красиво. Но фонд не финансирует паузы и трещины.")
-> say(alexey, half_smile, "Значит, надо научить его видеть, за что он платит.")
-> say(andrey, suit_half_straight, "Или не играть в героизм и сделать то, что реально сработает.")
-> say(varvara, headscarf, "Не в храме выбираете, Алексей. Себя выбираете.")

* [Принять решение] -> choice_core_start