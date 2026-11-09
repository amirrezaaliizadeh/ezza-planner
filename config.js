// eZZa planner — settings for the cloud backend (Supabase).
// Leave both values empty to run in local mode: the app works, and data stays on each person's device.
// To turn on sign-in and sync: create a Supabase project, run supabase/schema.sql, then paste the
// Project URL and the "anon" public key here (Supabase → Project Settings → API).
// The anon key is meant to be public. Never paste the "service_role" key here.
window.EZZA_CONFIG = {
  SUPABASE_URL: '',
  SUPABASE_ANON_KEY: ''
};
