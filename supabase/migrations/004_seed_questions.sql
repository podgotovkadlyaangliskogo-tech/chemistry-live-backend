-- Chemistry Live: Seed Data - "Каучук и резина"
-- 004_seed_questions.sql
-- Exactly 20 scientifically accurate Russian questions on rubber chemistry:
-- 10 Easy (1000 pts / 20 sec)
-- 5 Medium (1500 pts / 30 sec)
-- 5 Ultra Hard (2000 pts / 45 sec)

DO $$
DECLARE
    v_quiz_id UUID := 'a0000000-0000-0000-0000-000000000001';
    v_q_id UUID;
BEGIN
    -- 1. Insert or update the Quiz
    INSERT INTO public.quizzes (id, title, description, is_published)
    VALUES (
        v_quiz_id,
        'Каучук и резина',
        'Интерактивная химическая викторина о структуре диеновых полимеров, процессах вулканизации, стереорегулярности и свойствах эластомеров.',
        true
    )
    ON CONFLICT (id) DO UPDATE 
    SET title = EXCLUDED.title,
        description = EXCLUDED.description,
        is_published = EXCLUDED.is_published;

    -- Clean existing questions for this seed quiz to allow idempotency
    DELETE FROM public.questions WHERE quiz_id = v_quiz_id;

    -- =========================================================================
    -- 10 EASY QUESTIONS (1000 points, 20 seconds)
    -- =========================================================================

    -- Q1 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой природный источник служит основным сырьем для получения натурального каучука?',
        'Натуральный каучук выделяют коагуляцией органическими кислотами из млечного сока (латекса) каучуконосных деревьев, преимущественно бразильской гевеи (Hevea brasiliensis).',
        'easy', 1000, 20, 1
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Млечный сок бразильской гевеи (латекс)', true, 'red', 0),
        (v_q_id, 'Смола сибирского кедра', false, 'blue', 1),
        (v_q_id, 'Сок сахарного клена', false, 'yellow', 2),
        (v_q_id, 'Тяжелые фракции сырой нефти', false, 'green', 3);

    -- Q2 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой химический мономер является структурной основой натурального каучука?',
        'Натуральный каучук представляет собой регулярный высокомолекулярный полимер цис-1,4-полиизопрен, мономером которого служит 2-метилбутадиен-1,3 (изопрен).',
        'easy', 1000, 20, 2
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Хлоропрен (2-хлорбутадиен-1,3)', false, 'red', 0),
        (v_q_id, 'Изопрен (2-метилбутадиен-1,3)', true, 'blue', 1),
        (v_q_id, 'Этилен (этен)', false, 'yellow', 2),
        (v_q_id, 'Стирол (винилбензол)', false, 'green', 3);

    -- Q3 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Как называется процесс превращения сырого каучука в прочную эластичную резину при нагревании с серой?',
        'Вулканизация — физико-химический процесс сшивания полимерных цепей каучука поперечными ковалентными связями (сульфидными мостиками) в трехмерную пространственную сетку.',
        'easy', 1000, 20, 3
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Поликонденсация', false, 'red', 0),
        (v_q_id, 'Пиролиз', false, 'blue', 1),
        (v_q_id, 'Вулканизация', true, 'yellow', 2),
        (v_q_id, 'Крекинг', false, 'green', 3);

    -- Q4 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Кто в 1839 году открыл технологию серной вулканизации каучука?',
        'Американский изобретатель Чарльз Гудьир (Charles Goodyear) в 1839 году экспериментально обнаружил, что нагревание каучука с порошком серы устраняет его липкость и термопластичность.',
        'easy', 1000, 20, 4
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Дмитрий Менделеев', false, 'red', 0),
        (v_q_id, 'Майкл Фарадей', false, 'blue', 1),
        (v_q_id, 'Альфред Нобель', false, 'yellow', 2),
        (v_q_id, 'Чарльз Гудьир', true, 'green', 3);

    -- Q5 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какое вещество традиционно служит главным вулканизующим агентом в классическом производстве резины?',
        'Элементная сера (S8) является классическим сшивающим реагентом, раскрывающим диеновые кратные связи макромолекул с формированием сульфидных мостиков.',
        'easy', 1000, 20, 5
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Сера', true, 'red', 0),
        (v_q_id, 'Белый фосфор', false, 'blue', 1),
        (v_q_id, 'Хлорная известь', false, 'yellow', 2),
        (v_q_id, 'Азотная кислота', false, 'green', 3);

    -- Q6 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой выдающийся ученый впервые в мире разработал промышленный синтез бутадиенового каучука из этилового спирта?',
        'В 1928–1932 гг. советский химик-академик Сергей Васильевич Лебедев создал метод синтеза бутадиена-1,3 из этилового спирта в одну стадию и запустил первое в мире промышленное производство СКБ.',
        'easy', 1000, 20, 6
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Александр Бутлеров', false, 'red', 0),
        (v_q_id, 'Сергей Лебедев', true, 'blue', 1),
        (v_q_id, 'Владимир Марковников', false, 'yellow', 2),
        (v_q_id, 'Николай Зелинский', false, 'green', 3);

    -- Q7 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'К какому классу высокомолекулярных соединений по механическим характеристикам относятся каучуки?',
        'Эластомеры — высокомолекулярные полимеры, способные к многократным и обратимым высокоэластическим деформациям в широком диапазоне эксплуатационных температур.',
        'easy', 1000, 20, 7
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Термопласты', false, 'red', 0),
        (v_q_id, 'Синтетические волокна', false, 'blue', 1),
        (v_q_id, 'Эластомеры', true, 'yellow', 2),
        (v_q_id, 'Реактопласты жесткого типа', false, 'green', 3);

    -- Q8 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой твердый диэлектрический материал образуется при предельной вулканизации каучука серой (более 30% серы)?',
        'При максимальном насыщении каучука серой (30-40% по массе) формируется густосетчатый твердый полимер эбонит, утрачивающий эластичность и обладающий высокими электроизоляционными свойствами.',
        'easy', 1000, 20, 8
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Полистирол', false, 'red', 0),
        (v_q_id, 'Капрон', false, 'blue', 1),
        (v_q_id, 'Оргстекло (плексиглас)', false, 'yellow', 2),
        (v_q_id, 'Эбонит', true, 'green', 3);

    -- Q9 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Что происходит с сырым (невулканизованным) натуральным каучуком при нагревании выше 40-50 °C?',
        'Невулканизованный каучук не имеет химической сетки, поэтому при повышенной температуре макромолекулы необратимо скользят относительно друг друга: каучук размягчается и становится липким.',
        'easy', 1000, 20, 9
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Размягчается, течет и становится клейким', true, 'red', 0),
        (v_q_id, 'Самопроизвольно кристаллизуется в алмаз', false, 'blue', 1),
        (v_q_id, 'Мгновенно вспыхивает без кислорода', false, 'yellow', 2),
        (v_q_id, 'Становится хрупким как фарфор', false, 'green', 3);

    -- Q10 (Easy)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Как называется природный транс-изомер полиизопрена, обладающий твердостью и низкой эластичностью?',
        'Гуттаперча — природный транс-1,4-полиизопрен. Линейные транс-цепи легко упаковываются в кристаллическую решетку, поэтому она малоэластична и жестка при стандартных условиях.',
        'easy', 1000, 20, 10
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Бакелит', false, 'red', 0),
        (v_q_id, 'Гуттаперча', true, 'blue', 1),
        (v_q_id, 'Тефлон', false, 'yellow', 2),
        (v_q_id, 'Неопрен', false, 'green', 3);

    -- =========================================================================
    -- 5 MEDIUM QUESTIONS (1500 points, 30 seconds)
    -- =========================================================================

    -- Q11 (Medium)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какова точная стереохимическая пространственная конфигурация звеньев в натуральном каучуке?',
        'Именно регулярная цис-1,4-конфигурация двойных связей цепи обуславливает рыхлую упаковку звеньев и свободное конформационное сворачивание клубка, наделяя полимер уникальной высокоэластичностью.',
        'medium', 1500, 30, 11
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Цис-1,4-конфигурация', true, 'red', 0),
        (v_q_id, 'Транс-1,4-конфигурация', false, 'blue', 1),
        (v_q_id, '1,2-синдиотактическая конфигурация', false, 'yellow', 2),
        (v_q_id, '3,4-изотактическая конфигурация', false, 'green', 3);

    -- Q12 (Medium)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой мономер используется для получения неопрена (хлоропренового каучука), устойчивого к огню и маслам?',
        'Хлоропреновый каучук синтезируют из 2-хлорбутадиена-1,3. Атом хлора уменьшает горючесть полимера и делает его исключительно стойким к неполярным углеводородным топливам и маслам.',
        'medium', 1500, 30, 12
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Винилхлорид (хлорэтен)', false, 'red', 0),
        (v_q_id, '1,2-дихлорэтан', false, 'blue', 1),
        (v_q_id, '2-хлорбутадиен-1,3 (хлоропрен)', true, 'yellow', 2),
        (v_q_id, 'Тетрахлорэтилен', false, 'green', 3);

    -- Q13 (Medium)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какую функцию выполняют оксид цинка (ZnO) и стеариновая кислота в процессе промышленной серной вулканизации?',
        'ZnO в комбинации со стеариновой кислотой образует растворимые стеараты цинка, служащие химическими активаторами ускорителей вулканизации и ускоряющие сшивку серными мостиками.',
        'medium', 1500, 30, 13
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Ингибитор старения цепи', false, 'red', 0),
        (v_q_id, 'Красящий белый пигмент', false, 'blue', 1),
        (v_q_id, 'Инертный наполнитель каркаса', false, 'yellow', 2),
        (v_q_id, 'Активатор вулканизации', true, 'green', 3);

    -- Q14 (Medium)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой синтетический каучук обладает рекордно низкой газопроницаемостью и незаменим для герметизирующих слоев автомобильных шин?',
        'Бутилкаучук — сополимер изобутилена с малой долей изопрена (1-3%). Высокая плотность упаковки боковых метальных групп обеспечивает минимальную диффузию газов (в 8-10 раз ниже натурального каучука).',
        'medium', 1500, 30, 14
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Бутилкаучук (сополимер изобутилена и изопрена)', true, 'red', 0),
        (v_q_id, 'Бутадиен-стирольный каучук (СКС)', false, 'blue', 1),
        (v_q_id, 'Бутадиен-нитрильный каучук (СКН)', false, 'yellow', 2),
        (v_q_id, 'Полиизобутилен невулканизуемый', false, 'green', 3);

    -- Q15 (Medium)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какова химическая природа поперечных связей, образующихся между макромолекулами при классической серной вулканизации?',
        'При серной вулканизации цепи связываются ковалентными связями C-S_x-C (где x=1..8) — моно-, ди- и полисульфидными мостиками, объединяющими полимер в единую трехмерную макросетку.',
        'medium', 1500, 30, 15
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Водородные связи карбоксильных групп', false, 'red', 0),
        (v_q_id, 'Ковалентные сульфидные и полисульфидные мостики (-S_x-)', true, 'blue', 1),
        (v_q_id, 'Металлические координационные кластеры', false, 'yellow', 2),
        (v_q_id, 'Электростатические ван-дер-ваальсовы ассоциаты', false, 'green', 3);

    -- =========================================================================
    -- 5 ULTRA HARD QUESTIONS (2000 points, 45 seconds)
    -- =========================================================================

    -- Q16 (Ultra Hard)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какой тип катализаторов позволил впервые осуществить стереоспецифический синтез изопренового каучука СКИ-3 с содержанием цис-1,4-звеньев свыше 98%?',
        'Катализаторы координационно-ионной полимеризации Циглера — Натта (на основе галогенидов переходных металлов TiCl4 и алюминийорганики AlR3) обеспечили стереоселективную координацию изопрена и синтез полного аналога природного каучука.',
        'ultra_hard', 2000, 45, 16
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Оксидно-хромовые катализаторы Филлипса', false, 'red', 0),
        (v_q_id, 'Пероксидные радикальные инициаторы', false, 'blue', 1),
        (v_q_id, 'Координационные катализаторы Циглера — Натта (TiCl4 + AlR3)', true, 'yellow', 2),
        (v_q_id, 'Рутениевые катализаторы метатезиса Граббса', false, 'green', 3);

    -- Q17 (Ultra Hard)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'В чем заключается термодинамическая природа эффекта Джоуля — Гофмейстера (энтропийной упругости) эластомеров?',
        'Упругость каучука обусловлена изменением конформационной энтропии. При растяжении цепи ориентируются вдоль оси, их энтропия падает (dS < 0). Возврат в исходное состояние обусловлен стремлением системы к максимуму энтропии (клубок), сопровождаясь выделением тепла при быстром растяжении.',
        'ultra_hard', 2000, 45, 17
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Падение конформационной энтропии клубка при растяжении и стремление к максимуму беспорядка', true, 'red', 0),
        (v_q_id, 'Рост потенциальной энтальпии отталкивания ядер углерода', false, 'blue', 1),
        (v_q_id, 'Эндотермический фазовый переход первого рода в жидкость', false, 'yellow', 2),
        (v_q_id, 'Обратимая диссоциация ковалентных C-C связей скелета', false, 'green', 3);

    -- Q18 (Ultra Hard)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какова стехиометрия и химическая сущность одностадийной каталитической реакции Лебедева получения 1,3-бутадиена из этанола?',
        'Реакция Лебедева: 2 CH3-CH2-OH -> CH2=CH-CH=CH2 + 2 H2O + H2. Процесс протекает при 370-400 °C на бифункциональном катализаторе, объединяющем дегидрирующие (ZnO) и дегидратирующие (Al2O3) центры.',
        'ultra_hard', 2000, 45, 18
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Окисление этанола до уксусного альдегида с последующим кротоновым гидрированием без катализатора', false, 'red', 0),
        (v_q_id, 'Каталитический пиролиз этанола до ацетилена и этилена с дальнейшим циклированием', false, 'blue', 1),
        (v_q_id, 'Диспропорционирование диэтилового эфира в присутствии концентрированной серной кислоты', false, 'yellow', 2),
        (v_q_id, 'Совмещенное каталитическое дегидрирование и дегидратация этанола: 2 C2H5OH -> C4H6 + 2 H2O + H2', true, 'green', 3);

    -- Q19 (Ultra Hard)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Каков механизм озонного старения и растрескивания деформированных диеновых резин в атмосфере?',
        'Озон электрофильно присоединяется по остаточным кратным C=C связям диенов с образованием нестабильного 1,2,3-триоксолана (молозонида), распадающегося по механизму Криге на цвиттер-ион и карбонильное звено, разрушая несущую цепь полимера.',
        'ultra_hard', 2000, 45, 19
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Окисление сульфидных мостиков в сульфоны без разрыва скелета', false, 'red', 0),
        (v_q_id, 'Электрофильное 1,3-диполярное присоединение O3 по C=C связям с деструкцией цепи по механизму Криге', true, 'blue', 1),
        (v_q_id, 'Фотохимический отрыв атомов водорода с образованием гидропероксидов без разрушения сетки', false, 'yellow', 2),
        (v_q_id, 'Ионизация адсорбированной влаги с образованием свободных радикалов гидроксила', false, 'green', 3);

    -- Q20 (Ultra Hard)
    v_q_id := gen_random_uuid();
    INSERT INTO public.questions (id, quiz_id, text, explanation, difficulty, points, time_limit_seconds, order_index)
    VALUES (
        v_q_id, v_quiz_id,
        'Какие химические реагенты применяют для вулканизации насыщенных эластомеров (силиконовых и этилен-пропиленовых СКЭП), лишенных диеновых C=C связей?',
        'Так как в скелете насыщенных полимеров отсутствуют реакционноспособные двойные связи, их сшивают органическими пероксидами (например, дикумилпероксидом), которые генерируют радикалы, отрывают атомы H от C-H связей и образуют C-C поперечные сшивки.',
        'ultra_hard', 2000, 45, 20
    );
    INSERT INTO public.answer_options (question_id, text, is_correct, color, order_index) VALUES
        (v_q_id, 'Элементная сера с меркаптобензтиазолом', false, 'red', 0),
        (v_q_id, 'Диоксид титана и гидроксид калия', false, 'blue', 1),
        (v_q_id, 'Органические пероксиды (дикумилпероксид, перекись бензоила)', true, 'yellow', 2),
        (v_q_id, 'Хлорид сурьмы(V) и фосфорноватистая кислота', false, 'green', 3);

END $$;
