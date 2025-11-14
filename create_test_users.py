# SAMPLE: script to generate test users via Supabase Admin (requires service_role key)
# Warning: run on server with SUPABASE_SERVICE_ROLE_KEY; do not run in browser.
import requests, os, json
SUPABASE_URL = os.environ.get('SUPABASE_URL')
SERVICE_KEY = os.environ.get('SUPABASE_SERVICE_ROLE_KEY')  # keep secret
if not SUPABASE_URL or not SERVICE_KEY:
    print('Set SUPABASE_URL and SERVICE_ROLE_KEY env vars')
    exit(1)
headers = {
    'apikey': SERVICE_KEY,
    'Authorization': f'Bearer {SERVICE_KEY}',
    'Content-Type': 'application/json'
}
# Example create user (uses admin endpoint)
def create_user(email, password, full_name, role='student'):
    url = f'{SUPABASE_URL}/auth/v1/admin/users'
    payload = {
        'email': email,
        'password': password,
        'user_metadata': {'full_name': full_name, 'role': role}
    }
    r = requests.post(url, headers=headers, data=json.dumps(payload))
    return r.json()
# Create 10 test users
for i in range(1,11):
    em = f'test{i}@example.com'
    print(create_user(em, 'Password123!', f'Test User {i}', 'student'))
