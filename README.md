# DailyFlow — Daily Task Management & Productivity Platform

**DailyFlow** is a complete, fully functional, production-grade daily task management and productivity website built with React, TypeScript, Tailwind CSS, Lucide Icons, and a local-first persistent architecture using Dexie IndexedDB (with an optional Supabase PostgreSQL sync layer).

---

## 🌟 Key Features

### 1. Date-Centric Task Architecture (Zero UTC Offset Shift)
- **Local Date Isolation**: Every task record stores its calendar date strictly as `YYYY-MM-DD` using local browser calendar time rather than UTC strings. This completely prevents timezone bugs where tasks jump to yesterday or tomorrow.
- **Independent Task States**: Checking a task on one date strictly alters that specific occurrence or task record. Navigating to yesterday, today, or tomorrow preserves each date's independent pending and completed state.
- **Recurrence Engine**: Supports **Daily**, **Weekdays (Mon-Fri)**, **Weekly**, and **Monthly** recurring tasks with independent occurrence tracking. Completing a recurring task today never accidentally completes tomorrow's task!

### 2. Modern Productivity Dashboard
- **Personalized Greeting**: Dynamic greeting ("Good morning", "Good afternoon", "Good evening") based on current local hour.
- **Progress Tracking**: Real-time progress bar, percentage completion, and live counters for total, completed, and pending tasks.
- **Interactive Celebration**: Subtle pentatonic completion bell sound (synthesized via Web Audio API with zero external media files) and confetti bursts when finishing tasks.
- **Grouped Task View**: Clear separation between Pending and Completed tasks, with collapsible completed section.

### 3. Comprehensive Task Management
- **Fields**: Title (required with validation), description/notes, scheduled date, due time, priority (High, Medium, Low), category (Work, Study, Health, Personal, Other), and recurrence rule.
- **Quick-Add Bar**: Inline dashboard input allowing instant task creation with Enter key.
- **Detailed Modal**: Complete modal dialog with autofocus, keyboard submit (`Enter`), and `Escape` to close.
- **Filters & Search**: Instant full-text search across titles and descriptions; status filters (All, Pending, Completed); priority and category filters; sorting by due time, priority, creation date, or alphabetical.
- **Safe Deletion with Undo**: Deleting a task triggers a confirmation modal followed by an instant **Undo** toast notification.

### 4. 7-Day Weekly View & Monthly Calendar
- **Weekly Horizon**: Visual 7-day card layout (Monday through Sunday) displaying day name, day number, task counts, and visual progress meters.
- **One-Click Navigation**: Click any day in the weekly bar or monthly calendar modal to view that date's tasks.
- **Week Traversal**: Previous-week, next-week, and "This Week" return buttons.

### 5. Productivity Analytics & Streak Tracking
- **Streak Calculation**: Continuous streak of consecutive productive days strictly ending on today or yesterday. **Never counts future dates**.
- **Metrics**: Today's completion rate, weekly completion rate, overall historical completion rate, and best productivity day.
- **Visual Activity Chart**: Interactive 7-day bar chart showing total scheduled tasks vs completed tasks per day.

### 6. Daily Notes & Reflections
- Date-specific daily reflections and standup notes saved persistently per calendar day in IndexedDB.

### 7. Data Persistence & Cloud Sync
- **Local-First Persistent Storage**: Powered by **IndexedDB (Dexie.js)**. Tasks and notes persist across tab reloads, browser restarts, and offline sessions.
- **Optional Supabase Cloud Sync**: Pre-configured schema (`supabase-schema.sql`) with PostgreSQL Row Level Security (RLS) policies for user accounts and cloud synchronization.
- **Backup & Restore**: Export all tasks to structured JSON or CSV spreadsheets. Import previous backups with validation.

### 8. Accessibility & Responsiveness
- Tested and responsive across mobile phones (360px, 390px), tablets (768px), laptops (1024px), and wide monitors (1440px+).
- Touch-friendly 44×44px interactive targets for checkboxes and action buttons.
- Bottom navigation bar on mobile viewports; top desktop navigation bar.
- Working Light and Dark mode with persistence in `localStorage` and system theme detection.
- Keyboard shortcuts: `N` for new task, `T` for today, `Escape` to close dialogs.

---

## 📁 Project Structure

```
work todo/
├── public/
│   ├── favicon.svg             # DailyFlow SVG icon
│   └── manifest.json           # PWA web app manifest
├── src/
│   ├── types/
│   │   └── index.ts            # Task, Category, Priority, Recurrence, and Stats types
│   ├── db/
│   │   ├── database.ts         # Dexie IndexedDB schema & recurrence synchronizer
│   │   ├── seed.ts             # Thoughtful initial seed data for today, yesterday, tomorrow
│   │   └── supabase.ts         # Supabase client detection & cloud sync layer
│   ├── utils/
│   │   ├── dateUtils.ts        # Local date formatting, calendar math & streak calculation
│   │   ├── sound.ts            # Web Audio API audio synthesis for completion bells
│   │   └── exportImport.ts     # JSON and CSV export/import with validation
│   ├── context/
│   │   ├── ThemeContext.tsx    # Light/Dark mode provider with system preference detection
│   │   └── ToastContext.tsx    # Accessible toast notifications with Undo action
│   ├── components/
│   │   ├── Header.tsx          # Top bar, nav tabs, theme toggle, sound switch, backup menu
│   │   ├── GreetingBanner.tsx  # Dynamic greeting, date, progress meter, quick stats
│   │   ├── DateNavigator.tsx   # Prev/Next day, jump to Today, mini-calendar button
│   │   ├── WeeklyView.tsx      # 7-day calendar view with completion indicators
│   │   ├── TaskQuickAdd.tsx    # Inline dashboard quick input with category/priority chips
│   │   ├── TaskFilters.tsx     # Status tabs, search, priority & category filters, sorting
│   │   ├── TaskItem.tsx        # Task card with 44px checkbox, badges, edit & delete buttons
│   │   ├── TaskList.tsx        # Grouped pending & completed tasks with empty states
│   │   ├── TaskModal.tsx       # Full create/edit modal with keyboard shortcuts
│   │   ├── DeleteConfirmModal.tsx # Safe delete confirmation modal
│   │   ├── MiniCalendarModal.tsx  # Month grid picker to jump to any date
│   │   ├── AnalyticsView.tsx   # Streak, completion rates, weekly visual chart, best day
│   │   ├── DailyNotesView.tsx  # Date-specific reflection journal
│   │   ├── MobileNav.tsx       # Bottom navigation bar for mobile devices
│   │   └── ErrorBoundary.tsx   # React error boundary for runtime resilience
│   ├── App.tsx                 # Core application state, IndexedDB hooks, keyboard handlers
│   ├── main.tsx                # React DOM mounting
│   ├── index.css               # Tailwind CSS directives & animations
│   └── vite-env.d.ts           # Vite client environment types
├── supabase-schema.sql         # Supabase PostgreSQL schema with RLS policies
├── .env.example                # Example environment variables for cloud sync
├── tailwind.config.js          # Tailwind CSS theme and color tokens
├── vite.config.ts              # Vite server & bundler configuration
├── tsconfig.json               # TypeScript compiler configuration
└── package.json                # Project dependencies and scripts
```

---

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ (tested on Node v24.16.0)
- npm 9+

### 1. Install Dependencies
```bash
npm install
```

### 2. Run the Development Server
```bash
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your web browser.

### 3. Run Automated Tests
```bash
npm run test
```
Runs 19 automated unit and integration tests covering date math, streak rules, recurrence matching, and user flows.

### 4. Build for Production
```bash
npm run build
```
Generates an optimized production bundle in the `dist/` directory.

---

## 🗄️ Database Setup & Supabase Configuration

### Local Storage (Default — Zero Setup Needed)
DailyFlow works immediately out-of-the-box using browser **IndexedDB (Dexie)**. Data is fully persistent across page refreshes and browser restarts without requiring any account or API key.

### Optional Supabase Cloud Sync
To enable remote PostgreSQL storage:
1. Create a project at [supabase.com](https://supabase.com).
2. Open the **SQL Editor** in your Supabase dashboard and run the SQL code from [`supabase-schema.sql`](./supabase-schema.sql).
3. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
4. Fill in your project URL and Anon Key:
   ```env
   VITE_SUPABASE_URL=https://your-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-public-key
   ```
5. Restart the development server (`npm run dev`).

---

## ⌨️ Keyboard Shortcuts
- **`N`**: Open New Task modal (when not inside an input field)
- **`T`**: Quickly jump to Today
- **`Enter`**: Submit task in quick-add input or modal
- **`Escape`**: Close any active modal or dialog

---

## 🧪 Verification & Test Results
- **TypeScript**: Full strict mode compilation passes (`tsc && vite build`) with zero type errors.
- **Automated Tests**: 19 tests in 3 test suites passed:
  - `src/utils/dateUtils.test.ts`: Local calendar date formatting, midday parsing, streak calculation, best productivity day.
  - `src/db/database.test.ts`: Recurrence rule matching (daily, weekdays, weekly, monthly).
  - `src/test/integrationFlow.test.ts`: E2E integration test verifying 3 tasks added, progress recalculation, persistence across reloads, date switching between yesterday/today/tomorrow, independent completion states, edit/delete, and weekly statistics matching.
- **Server Health**: Vite dev server active and responding with `HTTP/1.1 200 OK` on `http://localhost:3000/`.
