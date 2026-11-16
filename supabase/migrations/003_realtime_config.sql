-- Chemistry Live: Supabase Realtime Publication Configuration
-- 003_realtime_config.sql

-- Ensure full replica identity for realtime row streaming and change tracking
ALTER TABLE public.game_sessions REPLICA IDENTITY FULL;
ALTER TABLE public.players REPLICA IDENTITY FULL;
ALTER TABLE public.player_answers REPLICA IDENTITY FULL;

-- Add tables to the supabase_realtime publication
-- First check if publication exists, or alter it
DO $$
BEGIN
    -- Check if supabase_realtime publication exists
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime'
    ) THEN
        CREATE PUBLICATION supabase_realtime;
    END IF;
END $$;

-- Add game tables to realtime stream
ALTER PUBLICATION supabase_realtime ADD TABLE public.game_sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.players;
ALTER PUBLICATION supabase_realtime ADD TABLE public.player_answers;
