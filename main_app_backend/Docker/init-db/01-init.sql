-- Инициализация базы данных для корпоративного портала

-- Создание расширений
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Создание таблицы пользователей в стиле GORM
CREATE TABLE IF NOT EXISTS user_secs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted_at TIMESTAMP WITH TIME ZONE,
    nickname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Создание индекса для soft delete
CREATE INDEX IF NOT EXISTS idx_user_secs_deleted_at ON user_secs(deleted_at);

-- Вставка тестовых данных пользователей
-- Пароли захешированы с помощью bcrypt (пароль: "password123")
INSERT INTO user_secs (created_at, updated_at, deleted_at, nickname, email, password) VALUES
    (NOW(), NOW(), NULL, 'admin', 'admin@portal.ru', '$2a$14$W0TDk7fQIJv4DdUwhP3HNuCJKXLeQBTUHurGy2Ci9tUNqzS4RcZ/C'),
    (NOW(), NOW(), NULL, 'employee1', 'emp1@portal.ru', '$2a$14$W0TDk7fQIJv4DdUwhP3HNuCJKXLeQBTUHurGy2Ci9tUNqzS4RcZ/C'),
    (NOW(), NOW(), NULL, 'employee2', 'emp2@portal.ru', '$2a$14$W0TDk7fQIJv4DdUwhP3HNuCJKXLeQBTUHurGy2Ci9tUNqzS4RcZ/C'),
    (NOW(), NOW(), NULL, 'manager', 'manager@portal.ru', '$2a$14$W0TDk7fQIJv4DdUwhP3HNuCJKXLeQBTUHurGy2Ci9tUNqzS4RcZ/C')
ON CONFLICT (email) DO NOTHING;

-- Комментарий для справки
-- Тестовые учетные записи:
-- admin@portal.ru / password123
-- emp1@portal.ru / password123  
-- emp2@portal.ru / password123
-- manager@portal.ru / password123
