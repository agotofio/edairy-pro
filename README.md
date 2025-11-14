# eDiary — Enterprise-ready Electronic Diary (Supabase)

Этот пакет содержит:
- `schema.sql` — миграции / структура базы данных (Postgres) для Supabase.
- `frontend/` — статические HTML/JS файлы, пример интеграции с Supabase JS SDK.
- `README` — инструкции по развертыванию.
- `.github/workflows/deploy.yml` — пример CI для публикации фронтенда.

## Быстрый старт (Supabase)

1. Создай проект на https://app.supabase.com
2. В разделе SQL Editor выполни `schema.sql`.
3. В Settings → API получи `SUPABASE_URL` и `SUPABASE_ANON_KEY`.
4. Помести их в `frontend/config.example.js` (создай `config.js` при развёртывании).
5. Разверни фронтенд (GitHub Pages / Vercel / Netlify).

## Запуск локально (только фронтенд)
- Можно просто открыть `frontend/index.html` в браузере (некоторый функционал требует HTTPS, тогда используйте Vercel/Netlify).

## Замечания по безопасности
- Для операций админа используйте server-side ключ (service_role) и храните его в безопасном месте.
- Настройте Row Level Security (RLS) и политики — в README есть примеры.

## Дальше
Я могу:
- сгенерировать тестовые данные (100 пользователей, тестовые оценки),
- подготовить GitHub Actions и автоматический deploy на Vercel,
- настроить RLS политики конкретно под ваш рабочий процесс.
