-- Chemistry Live: Database Schema Migration
-- 001_initial_schema.sql

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Profiles Table (hosts, teachers, players)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'host', 'teacher', 'user')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 2. Quizzes Table
CREATE TABLE IF NOT EXISTS public.quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    is_published BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 3. Questions Table
CREATE TABLE IF NOT EXISTS public.questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    explanation TEXT,
    difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'ultra_hard')),
    points INTEGER NOT NULL DEFAULT 1000,
    time_limit_seconds INTEGER NOT NULL DEFAULT 20,
    order_index INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 4. Answer Options Table
CREATE TABLE IF NOT EXISTS public.answer_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    color TEXT NOT NULL CHECK (color IN ('red', 'blue', 'yellow', 'green')),
    order_index INTEGER NOT NULL DEFAULT 0
);

-- 5. Game Sessions Table
CREATE TABLE IF NOT EXISTS public.game_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    host_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    pin_code VARCHAR(6) NOT NULL,
    status TEXT NOT NULL DEFAULT 'lobby' CHECK (status IN ('lobby', 'question_active', 'question_review', 'leaderboard', 'game_over', 'cancelled')),
    current_question_id UUID REFERENCES public.questions(id) ON DELETE SET NULL,
    current_question_index INTEGER NOT NULL DEFAULT 0,
    question_start_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 6. Players Table
CREATE TABLE IF NOT EXISTS public.players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.game_sessions(id) ON DELETE CASCADE,
    nickname VARCHAR(50) NOT NULL,
    score INTEGER NOT NULL DEFAULT 0,
    streak INTEGER NOT NULL DEFAULT 0,
    is_connected BOOLEAN NOT NULL DEFAULT true,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    last_active_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT unique_session_player_nickname UNIQUE (session_id, nickname)
);

-- 7. Player Answers Table
CREATE TABLE IF NOT EXISTS public.player_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.game_sessions(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    selected_option_id UUID REFERENCES public.answer_options(id) ON DELETE SET NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    response_time_ms INTEGER NOT NULL DEFAULT 0,
    points_awarded INTEGER NOT NULL DEFAULT 0,
    streak_at_answer INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT unique_session_player_question UNIQUE (session_id, player_id, question_id)
);

-- 8. Game Results Table
CREATE TABLE IF NOT EXISTS public.game_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.game_sessions(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
    final_score INTEGER NOT NULL DEFAULT 0,
    final_rank INTEGER NOT NULL DEFAULT 1,
    correct_answers_count INTEGER NOT NULL DEFAULT 0,
    total_questions INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT unique_session_player_result UNIQUE (session_id, player_id)
);

-- Indexes for high-concurrency game performance
CREATE INDEX IF NOT EXISTS idx_quizzes_author ON public.quizzes(author_id);
CREATE INDEX IF NOT EXISTS idx_questions_quiz ON public.questions(quiz_id, order_index);
CREATE INDEX IF NOT EXISTS idx_answer_options_question ON public.answer_options(question_id, order_index);
CREATE INDEX IF NOT EXISTS idx_game_sessions_pin ON public.game_sessions(pin_code);
CREATE INDEX IF NOT EXISTS idx_game_sessions_status ON public.game_sessions(status);
CREATE INDEX IF NOT EXISTS idx_players_session ON public.players(session_id, score DESC);
CREATE INDEX IF NOT EXISTS idx_player_answers_session_question ON public.player_answers(session_id, question_id);
CREATE INDEX IF NOT EXISTS idx_player_answers_player ON public.player_answers(player_id);
CREATE INDEX IF NOT EXISTS idx_game_results_session ON public.game_results(session_id, final_rank ASC);

-- Automatic updated_at trigger function
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
DROP TRIGGER IF EXISTS set_profiles_updated_at ON public.profiles;
CREATE TRIGGER set_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_quizzes_updated_at ON public.quizzes;
CREATE TRIGGER set_quizzes_updated_at
    BEFORE UPDATE ON public.quizzes
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_game_sessions_updated_at ON public.game_sessions;
CREATE TRIGGER set_game_sessions_updated_at
    BEFORE UPDATE ON public.game_sessions
    FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
