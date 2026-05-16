// ============================================================
// ОЧИЩЕНИЕ — characters.ink
// Общие константы персонажей и базовые состояния
// ============================================================

// ------------------------------------------------------------
// Имена персонажей
// ------------------------------------------------------------

CONST CH_NARRATOR = ""
CONST CH_ALEXEY = "Алексей"
CONST CH_VARVARA = "Варвара"
CONST CH_ANDREY = "Андрей"
CONST CH_EGOR = "Егор Фомич"
CONST CH_MIROPIYA = "Голос Миропии"
CONST CH_FUND = "Представитель фонда"
CONST CH_MUSEUM = "Специалист музея"
CONST CH_ANNA = "Анна Петровна"
CONST CH_LENA = "Лена"
CONST CH_HOST = "Ведущий открытия"

// ------------------------------------------------------------
// ID персонажей / спрайтов
// Можно использовать в примитивной обвязке движка
// ------------------------------------------------------------

CONST ID_ALEXEY = "alexey"
CONST ID_VARVARA = "varvara"
CONST ID_ANDREY = "andrey"
CONST ID_EGOR = "egor"
CONST ID_MIROPIYA = "miropiya"
CONST ID_FUND = "fund"
CONST ID_MUSEUM = "museum"
CONST ID_ANNA = "anna"
CONST ID_LENA = "lena"
CONST ID_HOST = "host"

// ------------------------------------------------------------
// Базовые эмоции / состояния
// ------------------------------------------------------------

CONST EMO_NEUTRAL = "neutral"
CONST EMO_SOFT = "soft"
CONST EMO_COLD = "cold"
CONST EMO_TENSE = "tense"
CONST EMO_SERIOUS = "serious"
CONST EMO_SAD = "sad"
CONST EMO_HURT = "hurt"
CONST EMO_THINKING = "thinking"
CONST EMO_TIRED = "tired"
CONST EMO_CALM = "calm"

// ------------------------------------------------------------
// Текущие состояния персонажей
// Если Ursula читает переменные для показа спрайтов — пригодится
// ------------------------------------------------------------

VAR current_speaker = CH_NARRATOR
VAR current_character_id = ""
VAR current_emotion = EMO_NEUTRAL

VAR alexey_emotion = EMO_NEUTRAL
VAR varvara_emotion = EMO_NEUTRAL
VAR andrey_emotion = EMO_NEUTRAL
VAR egor_emotion = EMO_NEUTRAL
VAR miropiya_emotion = EMO_NEUTRAL
VAR fund_emotion = EMO_NEUTRAL
VAR museum_emotion = EMO_NEUTRAL
VAR anna_emotion = EMO_NEUTRAL
VAR lena_emotion = EMO_NEUTRAL
VAR host_emotion = EMO_NEUTRAL

// ------------------------------------------------------------
// Видимость персонажей
// ------------------------------------------------------------

VAR alexey_visible = false
VAR varvara_visible = false
VAR andrey_visible = false
VAR egor_visible = false
VAR miropiya_visible = false
VAR fund_visible = false
VAR museum_visible = false
VAR anna_visible = false
VAR lena_visible = false
VAR host_visible = false

// ------------------------------------------------------------
// Позиции на экране
// ------------------------------------------------------------

CONST POS_LEFT = "left"
CONST POS_CENTER = "center"
CONST POS_RIGHT = "right"

VAR alexey_pos = POS_CENTER
VAR varvara_pos = POS_CENTER
VAR andrey_pos = POS_CENTER
VAR egor_pos = POS_CENTER
VAR miropiya_pos = POS_CENTER
VAR fund_pos = POS_CENTER
VAR museum_pos = POS_CENTER
VAR anna_pos = POS_CENTER
VAR lena_pos = POS_CENTER
VAR host_pos = POS_CENTER

// ------------------------------------------------------------
// Подсказка по использованию в main.ink
// ------------------------------------------------------------
//
// Пример реплики через константу:
//
// {CH_ALEXEY}: Я посмотрю, что можно сделать.
//
// Пример ручной смены состояния перед сценой:
//
// ~ current_speaker = CH_VARVARA
// ~ current_character_id = ID_VARVARA
// ~ current_emotion = EMO_SERIOUS
// ~ varvara_visible = true