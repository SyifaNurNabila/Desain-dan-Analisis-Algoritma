CREATE DATABASE healthy_family;
USE healthy_family;

-- Error handling procedure for database connection
DELIMITER //
CREATE PROCEDURE check_database_connection()
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
        @sqlstate = RETURNED_SQLSTATE,
        @errno = MYSQL_ERRNO,
        @text = MESSAGE_TEXT;
        
        INSERT INTO error_logs (error_code, error_message, error_timestamp)
        VALUES (@errno, @text, NOW());
        
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Database connection failed. Please check connection settings.';
    END;
END //
DELIMITER ;

-- Create tables
CREATE TABLE users (
    users_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    birth DATE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT
);

CREATE TABLE children (
    child_id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT NOT NULL,
    child_name VARCHAR(100) NOT NULL,
    birth DATE,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT,
    FOREIGN KEY (users_id) REFERENCES users(users_id)
);

CREATE TABLE meals (
    meal_id INT PRIMARY KEY AUTO_INCREMENT,
    meal_name VARCHAR(100) NOT NULL,
    description TEXT,
    calories INT,
    is_child_friendly BOOLEAN,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT
);

CREATE TABLE meal_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT NOT NULL,
    meal_id INT NOT NULL,
    planned_date DATE NOT NULL,
    meal_type ENUM('breakfast','lunch','dinner','snack') NOT NULL,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT,
    FOREIGN KEY (users_id) REFERENCES users(users_id),
    FOREIGN KEY (meal_id) REFERENCES meals(meal_id)
);

CREATE TABLE goals (
    goal_id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    target_date DATE,
    is_completed BOOLEAN DEFAULT FALSE,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT,
    FOREIGN KEY (users_id) REFERENCES users(users_id)
);

CREATE TABLE activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    calories_burned INT,
    date DATE NOT NULL,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT,
    FOREIGN KEY (users_id) REFERENCES users(users_id)
);

CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    users_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    is_work BOOLEAN,
    is_family BOOLEAN,
    is_personal BOOLEAN,
    action_type VARCHAR(20),
    change_timestamp TIMESTAMP,
    details TEXT,
    users_id_auditor INT,
    FOREIGN KEY (users_id) REFERENCES users(users_id)
);

-- Create error logs table
CREATE TABLE error_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    error_code INT,
    error_message TEXT,
    error_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create roles
-- CREATE ROLE 'admin_role', 'user_role', 'viewer_role';

-- Grant privileges for admin role
GRANT ALL PRIVILEGES ON healthy_family.* TO 'admin_role';

-- Grant privileges for user role
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.users TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.children TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.meals TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.meal_plans TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.goals TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.activities TO 'user_role';
GRANT SELECT, INSERT, UPDATE, DELETE ON healthy_family.schedules TO 'user_role';

-- Grant privileges for viewer role
GRANT SELECT ON healthy_family.* TO 'viewer_role';

-- Create views
CREATE VIEW family_overview AS
SELECT 
    u.full_name as parent_name,
    COUNT(c.child_id) as number_of_children,
    COUNT(g.goal_id) as active_goals,
    COUNT(mp.plan_id) as meal_plans
FROM users u
LEFT JOIN children c ON u.users_id = c.users_id
LEFT JOIN goals g ON u.users_id = g.users_id AND g.is_completed = FALSE
LEFT JOIN meal_plans mp ON u.users_id = mp.users_id
GROUP BY u.users_id;

CREATE VIEW weekly_activities AS
SELECT 
    u.full_name,
    a.activity_type,
    SUM(a.duration) as total_duration,
    SUM(a.calories_burned) as total_calories
FROM users u
JOIN activities a ON u.users_id = a.users_id
WHERE a.date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY u.users_id, a.activity_type;

-- Triggers
DELIMITER //

CREATE TRIGGER after_child_insert
AFTER INSERT ON children
FOR EACH ROW
BEGIN
    DECLARE total_children INT;
    
    -- Menghitung total anak untuk pengguna yang bersangkutan
    SELECT COUNT(*) INTO total_children
    FROM children
    WHERE users_id = NEW.users_id;
    
    -- Memperbarui total anak pada tabel users
    UPDATE users
    SET details = CONCAT('Total children: ', total_children)
    WHERE users_id = NEW.users_id;
END //

CREATE TRIGGER after_child_delete
AFTER DELETE ON children
FOR EACH ROW
BEGIN
    DECLARE total_children INT;
    
    -- Menghitung total anak untuk pengguna yang bersangkutan
    SELECT COUNT(*) INTO total_children
    FROM children
    WHERE users_id = OLD.users_id;
    
    -- Memperbarui total anak pada tabel users
    UPDATE users
    SET details = CONCAT('Total children: ', total_children)
    WHERE users_id = OLD.users_id;
END //

-- contoh cursor untuk menghitung statistik aktivitas bulanan
CREATE PROCEDURE calculate_monthly_activity_stats(IN user_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE activity_date DATE;
    DECLARE activity_calories INT;
    DECLARE total_calories INT DEFAULT 0;
    
    DECLARE activity_cursor CURSOR FOR
        SELECT date, calories_burned
        FROM activities
        WHERE users_id = user_id
        AND MONTH(date) = MONTH(CURRENT_DATE);
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN activity_cursor;
    
    read_loop: LOOP
        FETCH activity_cursor INTO activity_date, activity_calories;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET total_calories = total_calories + IFNULL(activity_calories, 0);
    END LOOP;
    
    CLOSE activity_cursor;
    
    -- Store or return the results
    INSERT INTO activity_statistics (users_id, month, total_calories)
    VALUES (user_id, MONTH(CURRENT_DATE), total_calories);
END //

DELIMITER ;

-- Error handling for data insertion
DELIMITER //

CREATE PROCEDURE insert_meal_plan(
    IN p_users_id INT,
    IN p_meal_id INT,
    IN p_planned_date DATE,
    IN p_meal_type VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        INSERT INTO error_logs (error_code, error_message)
        VALUES (MYSQL_ERRNO, 'Error inserting meal plan');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to insert meal plan. Please try again.';
    END;
    
    START TRANSACTION;
        -- Validate user exists
        IF NOT EXISTS (SELECT 1 FROM users WHERE users_id = p_users_id) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid user ID';
        END IF;
        
        -- Validate meal exists
        IF NOT EXISTS (SELECT 1 FROM meals WHERE meal_id = p_meal_id) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid meal ID';
        END IF;
        
        -- Insert meal plan
        INSERT INTO meal_plans (users_id, meal_id, planned_date, meal_type)
        VALUES (p_users_id, p_meal_id, p_planned_date, p_meal_type);
    COMMIT;
END //

DELIMITER ;-