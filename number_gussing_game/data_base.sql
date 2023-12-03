DROP DATABASE IF EXISTS number_guessing;

CREATE DATABASE number_guessing;

\c number_guessing

CREATE TABLE users(
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(22) UNIQUE,
    best_game_guesses INT,
    games_number INT default 0
);