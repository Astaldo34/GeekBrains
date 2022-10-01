/*
 * Проект базы данных системы дистанционного обучения. Где будут пользователи, курсы, тесты, задачи.
 * База данных СДО (LMS) позволяет учитывать все назначения пользователей и хранит историю прохождения.
 */

-- создание БД
DROP DATABASE IF EXISTS lms;

CREATE DATABASE IF NOT EXISTS lms;

USE lms;

-- создаем таблицы
CREATE TABLE IF NOT EXISTS users(
  id SERIAL PRIMARY KEY,
  fistname VARCHAR(50) NOT NULL,
  lastname VARCHAR(50) NOT NULL,
  middlename VARCHAR(50),
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash CHAR(65) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users AUTO_INCREMENT = 1;

INSERT IGNORE users (fistname, lastname, middlename, email) VALUES ('Леонид', 'Гурьянов', 'Андреевич', 'leon_gur@gmail.com'),
('Артём', 'Милохин', 'Митрофанович', 'artem_mmm@gmail.com'),
('Дмитрий', 'Лесновский', 'Юрьевич', 'domoooon@mail.ru'),
('Александр', 'Шпак', 'Дмитриевич', 'alex456@gmail.com'),
('Руслан', 'Кремов', 'Иванович', 'rus_krem@rambler.com'),
('Пётр', 'Гурьев', 'Федотович', 'fedya_p@gmail.com'),
('Евгения', 'Светлая', 'Вячеславочна', 'murka_ligth@gmail.com'),
('Екатерина', 'Задорная', 'Андреева', 'lisi4ka@gmail.com');


CREATE TABLE IF NOT EXISTS profiles(
	user_id BIGINT UNSIGNED PRIMARY KEY,
	gender ENUM('f', 'm', 'x') NOT NULL,
	birthday DATE NOT NULL,
	hire_date DATE NOT NULL,
	city VARCHAR(130),
	FOREIGN KEY (user_id) REFERENCES users (id)
);

INSERT IGNORE profiles (user_id, gender, birthday, hire_date, city) VALUES ('1', 'm', '1980-09-01', '2020-09-01', 'Voljsk'),
('2', 'm', '1980-09-01', '2019-02-23', 'Lipeck'),
('3', 'm', '1980-09-01', '2018-05-03', 'Tagil'),
('4', 'm', '1980-09-01', '2019-02-24', 'Ekaterenburg'),
('5', 'm', '1980-09-01', '2020-09-01', 'Ribnoe'),
('6', 'x', '1980-09-01', '2019-08-19', 'Ribnoe'),
('7', 'f', '1980-09-01', '2021-03-08', 'Moscow'),
('8', 'f', '1980-09-01', '2022-03-08', 'Moscow');


CREATE TABLE IF NOT EXISTS learning(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	time_dir TINYINT UNSIGNED NOT NULL
);

INSERT IGNORE learning (name, time_dir) VALUES ('Welcome', '60'),
('Стандарты компании', '30'),
('Excel', '40'),
('Корпоративные средства коммуникации', '40'),
('Тайм менеджмент', '60'),
('Как составить презентацию', '20'),
('Лидерство', '60'),
('Как управлять командой', '30'),
('Профайлинг', '90');


CREATE TABLE IF NOT EXISTS active_learning(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	learning_id BIGINT UNSIGNED NOT NULL,
	start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	last_date DATETIME DEFAULT NULL,
	status ENUM('active', 'in_process', 'complete') NOT NULL DEFAULT 'active',
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (learning_id) REFERENCES learning (id)
);

INSERT IGNORE active_learning (user_id, learning_id, start_date, last_date, status) VALUES 
('1', '7', '2021-09-05 12:39:12', '2022-01-01 0:01:12', 'in_process'),
('5', '7', '2021-12-25', '2021-12-29', 'in_process'),
('5', '8', '2021-12-25', NULL, 'active'),
('5', '9', '2022-01-12', NULL, 'active'),
('4', '7', '2022-01-12', NULL, 'active'),
('6', '7', '2022-01-12', NULL, 'active'),
('7', '3', '2021-03-10', '2021-03-11', 'in_process'),
('8', '3', '2022-03-10', '2021-03-12', 'in_process');


CREATE TABLE IF NOT EXISTS completed_learning(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	learning_id BIGINT UNSIGNED NOT NULL,
	complete_date DATETIME NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (learning_id) REFERENCES learning (id)
);

INSERT IGNORE completed_learning (user_id, learning_id, complete_date) VALUES 
('1', '1', '2020-09-02'),
('1', '2', '2020-09-03'),
('1', '3', '2020-09-03'),
('1', '4', '2020-09-04'),
('2', '1', '2019-02-23'),
('2', '2', '2019-02-24'),
('3', '1', '2018-05-03'),
('3', '2', '2018-05-04'),
('3', '4', '2018-05-06'),
('4', '1', '2019-02-24'),
('5', '1', '2020-09-01'),
('5', '2', '2020-09-01'),
('5', '5', '2020-09-14'),
('6', '1', '2019-08-19'),
('7', '1', '2021-03-08'),
('8', '1', '2022-03-08'),
('8', '6', '2022-04-12');


CREATE TABLE IF NOT EXISTS tests(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	pass_perc TINYINT UNSIGNED NOT NULL DEFAULT '70',
	time_dir TINYINT UNSIGNED NOT NULL
);

INSERT IGNORE tests (name, pass_perc, time_dir) VALUES ('Welcome', DEFAULT, '30'),
('Стандарты компании', DEFAULT, '30'),
('Excel', '80', '20'),
('Корпоративные средства коммуникации', '80', '20'),
('Тайм менеджмент', '80', '40'),
('Как составить презентацию', '75', '10'),
('Лидерство', '80', '30'),
('Как управлять командой', '80', '30'),
('Профайлинг', '80', '30');


CREATE TABLE IF NOT EXISTS active_test(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	test_id BIGINT UNSIGNED NOT NULL,
	start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	last_date DATETIME DEFAULT NULL,
	status ENUM('active', 'in_process', 'pass', 'fail') NOT NULL DEFAULT 'active',
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (test_id) REFERENCES tests (id)
);

INSERT IGNORE active_test (user_id, test_id, start_date, last_date, status) VALUES 
('5', '5', '2020-09-15', NULL, 'active'),
('8', '6', '2022-04-13', NULL, 'active');


CREATE TABLE IF NOT EXISTS completed_test(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	test_id BIGINT UNSIGNED NOT NULL,
	complete_date DATETIME NOT NULL,
	percent TINYINT UNSIGNED NOT NULL,
	status ENUM('pass', 'fail') NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (test_id) REFERENCES tests (id)
);

INSERT IGNORE completed_test (user_id, test_id, complete_date, percent, status) VALUES 
('1', '1', '2020-09-03', '85', 'pass'),
('1', '2', '2020-09-04', '83', 'pass'),
('1', '3', '2020-09-04', '87', 'pass'),
('1', '4', '2020-09-05', '78', 'fail'),
('1', '4', '2020-09-06', '89', 'pass'),
('2', '1', '2019-02-24', '80', 'pass'),
('2', '2', '2019-02-25', '75', 'pass'),
('3', '1', '2018-05-13', '72', 'pass'),
('3', '2', '2018-05-14', '76', 'pass'),
('3', '4', '2018-05-25', '81', 'pass'),
('4', '1', '2019-02-25', '82', 'pass'),
('5', '1', '2020-09-02', '98', 'pass'),
('5', '2', '2020-09-03', '97', 'pass'),
('6', '1', '2019-08-19', '43', 'fail'),
('6', '1', '2019-08-19', '70', 'pass'),
('7', '1', '2021-03-10', '89', 'pass'),
('8', '1', '2022-03-11', '92', 'pass');


CREATE TABLE IF NOT EXISTS library(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	link VARCHAR(255) NOT NULL
);

INSERT IGNORE library (name, link) VALUES
('История компании', '//10.0.50.190/video/history.mp4'),
('Заводы компании', '//10.0.50.190/video/factories.mp4'),
('Для руководителей', '//10.0.50.190/video/ruk/for_ruk.mov'),
('CRM для новичков', '//10.0.50.190/video/srm/intro_srm.mp4');

CREATE TABLE IF NOT EXISTS task_user(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	task_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users (id),
	FOREIGN KEY (task_id) REFERENCES library (id)
);

INSERT IGNORE task_user (user_id, task_id) VALUES
('8', '1'),
('2', '2'),
('3', '2'),
('5', '3'),
('7', '4'),
('8', '4');
