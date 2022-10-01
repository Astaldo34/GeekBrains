/*
 * Возможные выборки, представления и треггеры к БД lms
 */

USE lms;

-- Выборки

SELECT CONCAT(u.fistname, ' ', u.lastname, ' ', u.middlename) AS fullname, al.learning_id AS course_name, al.status AS status FROM users u
JOIN active_learning al ON u.id = al.user_id
UNION 
SELECT CONCAT(u.fistname, ' ', u.lastname, ' ', u.middlename) AS fullname, cl.learning_id AS course_name, 'complete' AS status FROM users u
JOIN completed_learning cl ON u.id = cl.user_id
ORDER BY fullname;

SELECT CONCAT(u.fistname, ' ', u.lastname, ' ', u.middlename) AS fullname, COUNT(*) AS all_course FROM users u
JOIN
(SELECT al.id, user_id FROM active_learning al
UNION
SELECT cl.id, user_id FROM completed_learning cl) AS all_c ON u.id = all_c.user_id
GROUP BY fullname
ORDER BY all_course DESC;

-- Представления

DROP VIEW c_test IF EXISTS;

CREATE VIEW c_test AS
SELECT CONCAT(u.fistname, ' ', u.lastname, ' ', u.middlename) AS fullname, (SELECT name FROM tests WHERE ct.test_id = id) AS test_name,
ct.complete_date AS c_date, ct.percent, ct.status AS status FROM users u
JOIN completed_test ct ON u.id = ct.user_id
ORDER BY fullname;

SELECT * FROM c_test;


DROP VIEW a_tasks IF EXISTS;

CREATE VIEW a_tasks AS
SELECT CONCAT(u.fistname, ' ', u.lastname, ' ', u.middlename) AS fullname, (SELECT name FROM library WHERE tu.task_id = id) AS task_name,
(SELECT link FROM library WHERE tu.task_id = id) AS link FROM users u
JOIN task_user tu ON u.id = tu.user_id
ORDER BY fullname;

SELECT * FROM a_tasks;


-- Триггер

DELIMITER //

CREATE TRIGGER from_active_in_complete_after_update AFTER UPDATE ON active_learning
FOR EACH ROW
BEGIN
	IF NEW.status = 'complete' THEN
		INSERT IGNORE completed_learning (user_id, learning_id, complete_date) VALUES (NEW.user_id, NEW.learning_id, NEW.last_date);
		DELETE FROM active_learning WHERE id = NEW.id;
	END IF;
END//

DELIMITER ;