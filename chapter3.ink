// ===== chapter3.ink =====
// Глава III. Школа и тетради
// Версия: 2.0 | Платформа: Урсула (Ink runtime)
// Исправления:
// - Исправлена логика бесконечного инкремента miropiya_voice при возврате в меню архива
// - Убраны кавычки вокруг ID улик в collect_clue() (теперь передаются элементы списка, а не строки)
// - Синхронизированы вызовы apply_scene() и say() с исправленными функциями из characters.ink
// - Добавлен флаг ch3_bonus_applied для предотвращения дублирования бонуса

VAR ch3_docs_found = 0
VAR ch3_bonus_applied = false

-> III_01_start

=== III_01_start
// SCENE III_01. Сельская библиотека / день
{ apply_scene("library", "theme_varvara", "paper_rustle", "varvara", "braid_book") }
~ ch3_docs_found = 0
~ ch3_bonus_applied = false

-> say(varvara, braid_book, "Здесь не музей. Сразу предупреждаю. Тут мыши, плохие коробки и прекрасная привычка подписывать всё карандашом.")
-> say(alexey, half_smile, "Иногда карандаш честнее печати.")
-> say(varvara, braid_book, "Только не говорите это при Андрее Михайловиче. Он попробует продать карандаш как символ народной памяти.")
-> say(alexey, half_smile, "Вы его не любите?")
-> say(varvara, braid_book, "Я не люблю, когда люди заранее знают, какой должна быть чужая боль.")
-> say(alexey, half_smile, "Сильная формулировка.")
-> say(varvara, braid_book, "Не сильная. Наболевшая.")

<> [📜 Архив: изучите минимум 2 документа, чтобы продолжить.]
-> III_01_archive_loop

=== III_01_archive_loop
// Механика: последовательный выбор документов. Требуется 2 из 3.
// Исправлено: бонус начисляется только один раз при достижении 3 документов
{ ch3_docs_found == 3 && ch3_bonus_applied == false:
    ~ miropiya_voice += 1
    ~ ch3_bonus_applied = true
}

<> [📜 Архив: изучено {ch3_docs_found} документа(-ов)]

* [Открыть запись об открытии школы (1884)]
    { LIST_CONTAINS(collected_clues, clue_school_1884) == false:
        ~ collect_clue(clue_school_1884)
        ~ ch3_docs_found += 1
        -> say(varvara, braid_book, "Представляете? Храм, изба, дети, буквы. Не каменная история. Дышащая.")
        -> say(alexey, half_smile, "И неудобная для красивой схемы.")
        -> say(varvara, braid_book, "Зато удобная для правды.")
        -> III_01_archive_loop
    - else:
        <> [📄 Документ уже изучен]
        -> III_01_archive_loop

* [Открыть сведения о здании школы (1897)]
    { LIST_CONTAINS(collected_clues, clue_school_1897) == false:
        ~ collect_clue(clue_school_1897)
        ~ ch3_docs_found += 1
        -> say(alexey, half_smile, "В 1897 построили отдельное деревянное здание.")
        -> say(varvara, braid_book, "Место, где дети впервые писали свои имена. Для кого-то это была вся революция в жизни.")
        -> say(alexey, half_smile, "Без громких лозунгов.")
        -> say(varvara, braid_book, "Самые важные вещи часто происходят без лозунгов. Поэтому их потом легче стереть.")
        -> III_01_archive_loop
    - else:
        <> [📄 Документ уже изучен]
        -> III_01_archive_loop

* [Открыть список книг XVII–XVIII веков]
    { LIST_CONTAINS(collected_clues, clue_library_books) == false:
        ~ collect_clue(clue_library_books)
        ~ ch3_docs_found += 1
        -> say(alexey, half_smile, "Здесь были старые книги. Семнадцатый, восемнадцатый век.")
        -> say(varvara, braid_book, "Я когда нашла эту строку, три минуты просто сидела. Не потому что редкость. Потому что кто-то их берег. Передавал. Открывал руками. А потом всё это стало строкой в списке.")
        -> III_01_archive_loop
    - else:
        <> [📄 Документ уже изучен]
        -> III_01_archive_loop

* [Закончить работу с архивом]
    { ch3_docs_found < 2:
        <> [⚠️ Нужно изучить минимум 2 документа.]
        -> III_01_archive_loop
    - else:
        <> [✅ Архивная работа завершена.]
        -> III_02_start
    }

=== III_02_start
// SCENE III_02. Спор о документе и любви
{ apply_scene("library", current_music, current_sfx, "alexey", "half_smile") }

-> say(alexey, half_smile, "Документ хотя бы не врёт от нежности.")
-> say(varvara, braid_book, "Врёт. Ещё как. Молчанием врёт. В документ не попадает, как ребёнок боялся отвечать у доски. Как учительница несла дрова. Как библиотечную книгу прятали под юбкой. Документ оставляет скелет. А вы потом называете скелет человеком.")
-> say(alexey, half_smile, "А любовь к месту легко дорисовывает лицо там, где его уже нет.")
-> say(varvara, braid_book, "Да. Поэтому нужны оба. Вы — чтобы не выдумать лишнего. Мы — чтобы вы не приняли отсутствие чернил за отсутствие жизни.")
-> say(alexey, half_smile, "Вы всегда так разговариваете?")
-> say(varvara, braid_book, "Только когда мне страшно.")
-> say(alexey, half_smile, "Вам страшно?")
-> say(varvara, braid_book, "Конечно. Приедут умные люди, всё измерят, всё упакуют, всё заберут. И скажут: теперь ваша память сохранена. Только жить ей будет негде.")

// CHOICE III_A. Ответ Варваре
* [«Я не заберу».]
    ~ apply_axis("trust_varvara", 1)
    -> say(alexey, half_smile, "Я не хочу ничего забирать.")
    -> say(varvara, braid_book, "Хотеть мало. Надо ещё выдержать, когда вам предложат забрать красиво.")
    -> III_03_start

* [«Без структуры всё развалится».]
    ~ apply_axis("authenticity", 1)
    -> say(alexey, half_smile, "Без структуры это тоже погибнет. Память не держится на одних чувствах.")
    -> say(varvara, braid_book, "Я знаю. Просто чувства первыми слышат, что что-то умирает.")
    -> III_03_start

* [«Деньги без истории не придут».]
    ~ apply_axis("compromise", 1)
    -> say(alexey, half_smile, "Если мы не соберём историю в понятную форму, денег не будет вообще.")
    -> say(varvara, braid_book, "Понятная форма — не проблема. Проблема, когда ради понятности место лишают характера.")
    -> III_03_start

=== III_03_start
// SCENE III_03. Дом Варвары / вечер
{ apply_scene("varvara_house", "kitchen_warm", "kettle_boil", "varvara", "headscarf") }

-> say(varvara, headscarf, "Не смотрите на бардак. Это не бардак, это слои.")
-> say(alexey, half_smile, "Удобное слово. Можно оправдать всё.")
-> say(varvara, headscarf, "Вы просто завидуете. У вас в папках всё слишком ровно.")
-> say(alexey, half_smile, "Ровность иногда спасает.")
-> say(varvara, headscarf, "Иногда убивает. Смотря что вы ровняете.")

// CHOICE III_B. Помочь или уйти?
* [Остаться и разобрать коробки.]
    ~ apply_axis("trust_varvara", 1)
    ~ apply_axis("involvement", 1)
    -> say(alexey, half_smile, "Давайте сюда одну коробку. Только без надежды, что я подпишу ваши «слои» как научный термин.")
    -> say(varvara, headscarf, "Поздно. Я уже вижу, что вы улыбнулись.")
    -> say(alexey, half_smile, "Это дефект освещения.")
    -> say(varvara, headscarf, "Конечно.")
    -> III_03_conclusion

* [Уйти к отчёту.]
    ~ apply_axis("authenticity", 1)
    -> say(alexey, half_smile, "Мне надо привести записи в порядок, пока не начал путать факты с вашей кухней.")
    -> say(varvara, headscarf, "Идите. Только помните: иногда порядок — это способ ничего не почувствовать.")
    -> III_03_conclusion

* [Остаться, но держать дистанцию.]
    ~ apply_axis("authenticity", 1)
    -> say(alexey, half_smile, "Я помогу, если мы сразу разделим: документы, фотографии, устные рассказы.")
    -> say(varvara, headscarf, "Хорошо. А куда положим то, что болит?")
    -> say(alexey, half_smile, "Пока отдельно.")
    -> say(varvara, headscarf, "Профессиональный ответ. Не самый живой, но честный.")
    -> III_03_conclusion

=== III_03_conclusion
// Закрытие главы, фиксация в дневнике, переход к Главе IV
{ apply_scene("varvara_house", current_music, current_sfx, "alexey", "half_smile") }

-> alexey_thought("Школа — не приложение к храму, а его продолжение. Варвара говорит так, будто защищает живого. Я всё ещё не уверен, что она ошибается.")
~ diary_add("Глава III", "Школа — не приложение к храму, а его продолжение. Варвара говорит так, будто защищает живого. Я всё ещё не уверен, что она ошибается.")

* [Перейти к находке тетради Миропии.] -> chapter4_start