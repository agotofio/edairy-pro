import { supabase } from './supabase-init.js';

// Simple wrappers for auth flows
export async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data;
}

export async function signUp(email, password, full_name, role='student') {
  const { data, error } = await supabase.auth.signUp({ email, password, options: { data: { full_name, role } } });
  if (error) throw error;
  // Note: after signUp, use admin to insert into users table or use function to sync auth users -> users table
  return data;
}

export function signOut() {
  return supabase.auth.signOut();
}

export function onAuthStateChange(cb) {
  return supabase.auth.onAuthStateChange(cb);
}
