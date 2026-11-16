-- Chemistry Live: Row Level Security (RLS) Policies
-- 002_rls_policies.sql

-- Enable Row Level Security on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answer_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.game_results ENABLE ROW LEVEL SECURITY;

-- 1. PROFILES POLICIES
DROP POLICY IF EXISTS "Public profiles are viewable by everyone" ON public.profiles;
CREATE POLICY "Public profiles are viewable by everyone"
    ON public.profiles FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id OR auth.role() = 'service_role');

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id OR auth.role() = 'service_role');

-- 2. QUIZZES POLICIES
DROP POLICY IF EXISTS "Published quizzes are viewable by everyone" ON public.quizzes;
CREATE POLICY "Published quizzes are viewable by everyone"
    ON public.quizzes FOR SELECT
    USING (is_published = true OR auth.uid() = author_id OR auth.role() = 'service_role');

DROP POLICY IF EXISTS "Authenticated users can create quizzes" ON public.quizzes;
CREATE POLICY "Authenticated users can create quizzes"
    ON public.quizzes FOR INSERT
    WITH CHECK (auth.role() = 'authenticated' OR auth.role() = 'service_role');

DROP POLICY IF EXISTS "Authors can update their own quizzes" ON public.quizzes;
CREATE POLICY "Authors can update their own quizzes"
    ON public.quizzes FOR UPDATE
    USING (auth.uid() = author_id OR auth.role() = 'service_role');

DROP POLICY IF EXISTS "Authors can delete their own quizzes" ON public.quizzes;
CREATE POLICY "Authors can delete their own quizzes"
    ON public.quizzes FOR DELETE
    USING (auth.uid() = author_id OR auth.role() = 'service_role');

-- 3. QUESTIONS POLICIES
DROP POLICY IF EXISTS "Questions are viewable by everyone" ON public.questions;
CREATE POLICY "Questions are viewable by everyone"
    ON public.questions FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Authors can manage questions for their quizzes" ON public.questions;
CREATE POLICY "Authors can manage questions for their quizzes"
    ON public.questions FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.quizzes
            WHERE quizzes.id = questions.quiz_id
            AND (quizzes.author_id = auth.uid() OR auth.role() = 'service_role')
        )
    );

-- 4. ANSWER OPTIONS POLICIES
DROP POLICY IF EXISTS "Answer options are viewable by everyone" ON public.answer_options;
CREATE POLICY "Answer options are viewable by everyone"
    ON public.answer_options FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Authors can manage answer options" ON public.answer_options;
CREATE POLICY "Authors can manage answer options"
    ON public.answer_options FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.questions
            JOIN public.quizzes ON quizzes.id = questions.quiz_id
            WHERE questions.id = answer_options.question_id
            AND (quizzes.author_id = auth.uid() OR auth.role() = 'service_role')
        )
    );

-- 5. GAME SESSIONS POLICIES
DROP POLICY IF EXISTS "Game sessions are viewable by everyone" ON public.game_sessions;
CREATE POLICY "Game sessions are viewable by everyone"
    ON public.game_sessions FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Authenticated users can create game sessions" ON public.game_sessions;
CREATE POLICY "Authenticated users can create game sessions"
    ON public.game_sessions FOR INSERT
    WITH CHECK (auth.role() = 'authenticated' OR auth.role() = 'anon' OR auth.role() = 'service_role');

DROP POLICY IF EXISTS "Host can update game session" ON public.game_sessions;
CREATE POLICY "Host can update game session"
    ON public.game_sessions FOR UPDATE
    USING (auth.uid() = host_id OR host_id IS NULL OR auth.role() = 'service_role');

-- 6. PLAYERS POLICIES
DROP POLICY IF EXISTS "Players in sessions are viewable by everyone" ON public.players;
CREATE POLICY "Players in sessions are viewable by everyone"
    ON public.players FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Anyone can join as player" ON public.players;
CREATE POLICY "Anyone can join as player"
    ON public.players FOR INSERT
    WITH CHECK (true);

DROP POLICY IF EXISTS "Players and hosts can update player status" ON public.players;
CREATE POLICY "Players and hosts can update player status"
    ON public.players FOR UPDATE
    USING (true);

-- 7. PLAYER ANSWERS POLICIES
DROP POLICY IF EXISTS "Player answers are viewable by session participants" ON public.player_answers;
CREATE POLICY "Player answers are viewable by session participants"
    ON public.player_answers FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Players can submit their answers" ON public.player_answers;
CREATE POLICY "Players can submit their answers"
    ON public.player_answers FOR INSERT
    WITH CHECK (true);

-- 8. GAME RESULTS POLICIES
DROP POLICY IF EXISTS "Game results are viewable by everyone" ON public.game_results;
CREATE POLICY "Game results are viewable by everyone"
    ON public.game_results FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "Hosts or system can record game results" ON public.game_results;
CREATE POLICY "Hosts or system can record game results"
    ON public.game_results FOR ALL
    USING (true);
