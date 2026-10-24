-- DailyFlow Database Schema for Supabase PostgreSQL
-- Enable uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tasks Table
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT DEFAULT '',
    scheduled_date DATE NOT NULL,
    due_time TIME,
    priority VARCHAR(10) NOT NULL CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    category VARCHAR(20) NOT NULL CHECK (category IN ('Work', 'Study', 'Health', 'Personal', 'Other')) DEFAULT 'Personal',
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    recurrence_rule VARCHAR(20) NOT NULL CHECK (recurrence_rule IN ('none', 'daily', 'weekly', 'weekdays', 'monthly')) DEFAULT 'none',
    recurrence_parent_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE
);

-- Indexes for lightning fast queries
CREATE INDEX IF NOT EXISTS idx_tasks_user_date ON public.tasks(user_id, scheduled_date);
CREATE INDEX IF NOT EXISTS idx_tasks_date ON public.tasks(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_tasks_completion ON public.tasks(user_id, scheduled_date, is_completed);

-- 2. Daily Notes Table
CREATE TABLE IF NOT EXISTS public.daily_notes (
    id TEXT PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    content TEXT DEFAULT '',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_user_date UNIQUE (user_id, date)
);

CREATE INDEX IF NOT EXISTS idx_notes_user_date ON public.daily_notes(user_id, date);

-- 3. Row Level Security (RLS) Policies
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_notes ENABLE ROW LEVEL SECURITY;

-- Tasks RLS: Users can only select, insert, update, delete their own tasks
CREATE POLICY "Users can view own tasks" 
ON public.tasks FOR SELECT 
USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can create own tasks" 
ON public.tasks FOR INSERT 
WITH CHECK (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can update own tasks" 
ON public.tasks FOR UPDATE 
USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can delete own tasks" 
ON public.tasks FOR DELETE 
USING (auth.uid() = user_id OR user_id IS NULL);

-- Daily Notes RLS
CREATE POLICY "Users can view own notes" 
ON public.daily_notes FOR SELECT 
USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can create/update own notes" 
ON public.daily_notes FOR ALL 
USING (auth.uid() = user_id OR user_id IS NULL);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tasks_modtime
BEFORE UPDATE ON public.tasks
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE TRIGGER update_daily_notes_modtime
BEFORE UPDATE ON public.daily_notes
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
