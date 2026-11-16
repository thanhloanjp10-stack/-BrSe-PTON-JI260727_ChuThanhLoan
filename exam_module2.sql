-- tao csdl va tao bang
DROP DATABASE IF EXISTS exam_module2;
CREATE DATABASE IF NOT EXISTS exam_module2;
USE exam_module2;
-- tao 5 bang
-- bang 1: fooball_teams
CREATE TABLE football_teams(
team_id INT PRIMARY KEY AUTO_INCREMENT,
team_name VARCHAR(100) NOT NULL,
team_code VARCHAR(20) NOT NULL UNIQUE,
home_area VARCHAR(100) NOT NULL,
founded_date DATE NOT NULL
);
-- bang 2:players
CREATE TABLE players (
player_id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(100) NOT NULL,
preferred_position VARCHAR(30) CHECK ( preferred_position IN ('Thu mon','Hau ve','Tien ve','Tien dao')),
phone_number VARCHAR(15) NOT NULL UNIQUE,
skill_rating DECIMAL(3.1) DEFAULT 5.0 CHECK ( skill_rating >= 0.0 AND skill_rating <=10.0)
);
 -- bang 3:maches (tran dau)
CREATE TABLE matches (
match_id INT PRIMARY KEY AUTO_INCREMENT,
team_id INT,
opponent_name VARCHAR(100) NOT NULL ,
venue VARCHAR(150) NOT NULL,
match_time DATETIME NOT NULL,
pitch_fee DECIMAL(10,2) CHECK (pitch_fee >=0),
status VARCHAR(30) CHECK ( status IN ('Scheduled','Completed','Cancelled')),
FOREIGN KEY ( team_id) REFERENCES football_teams(team_id)
);
-- bang 4: match_registrations 
CREATE TABLE match_registrations (
registration_id INT PRIMARY KEY AUTO_INCREMENT,
match_id INT,
player_id INT,
attendance_status VARCHAR(30) CHECK ( attendance_status IN('Registered','Played','Absent')),
goals INT DEFAULT 0 CHECK ( goals >=0),
registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (match_id) REFERENCES matches( match_id),
FOREIGN KEY (player_id) REFERENCES players (player_id),
UNIQUE ( match_id,player_id)
);

-- bang 5: team_logs 
CREATE TABLE team_logs(
log_id INT PRIMARY KEY AUTO_INCREMENT,
registration_id INT,
player_id INT,
log_time DATETIME NOT NULL,
note TEXT NOT NULL,
FOREIGN KEY (registration_id ) REFERENCES match_registrations (registration_id),
FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- PHẦN 2. DML – INSERT, UPDATE, DELETE (25 ĐIỂM)
-- cau 1: insert into cho cac bang
INSERT INTO football_teams ( team_id,team_name,team_code,home_area,founded_date) VALUES
(1,'Sai Gon Strikers','SGS','Quan 1','2018-03-10'),
(2,'Thunder FC','TFC','TP Thu DUc','2021-06-15'),
(3,'Brothers United','BRU','Binh Thanh','2016-09-20'),
(4,'Weekend Warriors','WKW','Quan 7','2022-01-08'),
(5,'Office Eleven','O11','Go Vap','2019-11-30');
select*from football_teams;
 
INSERT INTO players (player_id,full_name,preferred_position,phone_number,skill_rating) VALUES
(1,'Nguyen Minh Khang','Tien dao','901112233',8.2),
(2,'Tran Hoang Nam','Tien ve','902223344',7.5),
(3,'Le Quoc Huy','Hau ve','903334455',7.8),
(4,'Pham Gia Bao','Thu mon','904445566',8.2),
(5,'Vo Thanh Cong','Tien ve','905556677',7.0);
select*from players;

INSERT INTO matches ( match_id,team_id,opponent_name,venue,match_time,pitch_fee,status) VALUES
(7001,1,'Black Cats','San Tao Dan','2026-05-20 18:00',1200000,'Scheduled'),
(7002,3,'Blue Sharks','San Gia Dinh','2026-05-21 19:30',1500000,'Completed'),
(7003,2,'Binh Minh FC','San Linh Trung','2026-05-22 18:30',1000000,'Completed'),
(7004,5,'Red Bulls','San Ky Hoa','2026-05-23 20:00',1300000,'Cancelled'),
(7005,4,'Young Boys','San Hoang Van Thu','2026-05-24 17:30',1100000,'Scheduled');
select*from matches;

INSERT INTO match_registrations ( registration_id,match_id,player_id,attendance_status,goals,registered_at) VALUES
(8001,7002,1,'Played',2,'2026-05-19 09:00'),
(8002,7002,3,'Played',0,'2026-05-19 09:15'),
(8003,7001,2,'Registered',0,'2026-05-18 20:00'),
(8004,7003,5,'Played',1,'2026-05-20 08:30'),
(8005,7004,4,'Absent',0,'2026-05-21 10:00');
select*from match_registrations;

INSERT INTO team_logs (log_id,registration_id,player_id,log_time,note) VALUES
(1,8003,2,'2026-05-18 20:05','Xac nhan tham gia tran'),
(2,8001,1,'2026-05-19 09:05','Dang ky da chinh'),
(3,8002,3,'2026-05-19 09:20','Xac nhan tham gia '),
(4,8004,5,'2026-05-20 08:35','Da co mat tai san'),
(5,8005,4,'2026-05-23 20:05','Vang mat khong bao truoc');
select*from team_logs;

-- Câu 2 – UPDATE & DELETE (10 điểm)
-- 1. Tăng pitch_fee thêm 100.000 đồng cho các trận đồng thời thỏa mãn:
--   - Trạng thái là Completed
UPDATE matches 
SET pitch_fee = pitch_fee +100000
WHERE status = 'Completed';

-- 2. Xóa các bản ghi trong team_logs có log_time trước ngày 20/05/2026.
DELETE FROM team_logs
WHERE log_time < '2026-05-20';

-- PHẦN 3. TRUY VẤN CƠ BẢN (15 ĐIỂM)
-- Câu 1 – 5 điểm: Liệt kê full_name, preferred_position và skill_rating 
-- của các cầu thủ có điểm kỹ năng lớn hơn 7.8 hoặc có vị trí sở trường là Tiền vệ.
SELECT full_name,preferred_position,skill_rating
FROM players
WHERE skill_rating > 7.8 OR preferred_position = 'Tien ve';

-- Câu 2 – 5 điểm: Liệt kê opponent_name, venue và match_time của các trận:
-- - Diễn ra từ ngày 2026-05-20 đến hết ngày 2026-05-22.
-- - Tên đội đối thủ bắt đầu bằng chữ B.
SELECT opponent_name,venue,match_time
FROM matches
WHERE match_time BETWEEN '2026-05-20' AND '2026-05-22'
AND opponent_name LIKE 'B%';

-- Câu 3 – 5 điểm: Liệt kê registration_id, goals và registered_at:
-- - Sắp xếp goals giảm dần.
-- - Nếu số bàn thắng bằng nhau, sắp xếp registration_id tăng dần.
-- - Mỗi trang có 2 bản ghi.
-- - Chỉ hiển thị trang thứ hai.
SELECT registration_id,goals,registered_at
FROM match_registrations
ORDER BY goals DESC ,registration_id ASC;
---
-- PHẦN 4. TRUY VẤN NÂNG CAO (15 ĐIỂM)
-- Câu 1 – 5 điểm: Kết hợp các bảng liên quan để liệt kê:
-- - Tên đội bóng.
-- - Tên đội đối thủ.
-- - Họ tên cầu thủ.
-- - Vị trí sở trường.
-- - Số bàn thắng.
-- - Thời gian thi đấu.
SELECT 
ft.team_name,
m.opponent_name,
p.full_name,
p.preferred_position,
mr.goals,
m.match_time
FROM match_registrations AS mr
JOIN matches AS m ON mr.match_id = m.match_id
JOIN football_teams AS ft ON m.team_id = ft.team_id
JOIN players AS p ON mr.player_id = p.player_id;

-- Câu 2 – 5 điểm: Liệt kê họ tên cầu thủ và tổng số bàn thắng 
-- trong các đăng ký có attendance_status = 'Played'. 
-- Chỉ hiển thị những cầu thủ có tổng số bàn thắng lớn hơn 1.
SELECT 
p.full_name,
SUM(mr.goals) AS total_goals
FROM players AS p
JOIN match_registrations AS mr ON p.player_id = mr.player_id
WHERE mr.attendance_status = 'Played'
GROUP BY p.player_id, p.full_name
HAVING SUM(mr.goals) > 1;

-- Câu 3 – 5 điểm: Liệt kê player_id, full_name và skill_rating của cầu thủ 
-- có điểm kỹ năng cao nhất. Nếu nhiều cầu thủ đồng hạng cao nhất, phải hiển thị tất cả.
SELECT player_id,full_name,skill_rating
FROM players 
WHERE skill_rating = ( SELECT MAX(skill_rating) FROM players );

-- ---
-- PHẦN 5. INDEX & VIEW (10 ĐIỂM)
-- Câu 1 – 5 điểm: Tạo chỉ mục kết hợp trên bảng match_registrations, gồm:
-- - attendance_status
-- - goals
-- Chỉ mục dùng để hỗ trợ truy vấn lọc theo trạng thái tham gia và thống kê bàn thắng.
CREATE INDEX idx_status_goals
ON match_registrations ( attendance_status,goals);

-- Câu 2 – 5 điểm: Tạo một view hiển thị:
-- - player_id
-- - full_name
-- - Tổng số trận đã đăng ký
-- - Tổng số bàn thắng
-- Yêu cầu:
-- - Không tính các đăng ký có attendance_status = 'Absent'.
-- - Cầu thủ chưa có đăng ký hợp lệ vẫn phải xuất hiện.
-- - Các giá trị tổng của cầu thủ chưa có đăng ký bằng 0.
CREATE VIEW v_player_registrations AS 
SELECT 
p.player_id,
p.full_name,
COUNT(mr.registration_id) AS total_registered_maches 
FROM players AS p
LEFT JOIN match_registrations AS mr ON p.player_id = mr.player_id
GROUP BY p.player_id, p.full_name ;

-- ---
-- PHẦN 6. TRIGGER (10 ĐIỂM)
-- Câu 1 – 5 điểm
-- Viết trigger chạy sau khi cập nhật bảng match_registrations.
-- Khi attendance_status thực sự chuyển từ một giá trị khác sang Played, hệ thống tự động thêm một bản ghi vào team_logs với:
-- - registration_id: mã đăng ký vừa cập nhật.
-- - player_id: cầu thủ của đăng ký.
-- - note: Player confirmed as played.
-- - log_time: thời gian hiện tại của hệ thống.
-- Không ghi nhật ký nếu bản ghi đã có trạng thái Played và chỉ cập nhật một cột khác.
DELIMITER $$
CREATE TRIGGER tg_after_update_registration
AFTER UPDATE ON match_registrations
FOR EACH ROW 
BEGIN 
IF OLD.attendance_status <> 'Played' AND NEW.attendance_status = 'Played' THEN
  INSERT INTO team_logs(registration_id,player_id,log_time,note)
  VALUES (NEW.registration_id,NEW.player_id,NOW(),'Played comfirmed as played');
END IF ;
END $$
DELIMITER $$

-- Câu 2 – 5 điểm
-- Viết trigger chạy sau khi thêm mới vào match_registrations.
-- Nếu bản ghi mới có attendance_status = 'Played':
-- - Tăng skill_rating của cầu thủ tương ứng thêm 0.1.
-- - Đảm bảo skill_rating không vượt quá 10.0.
DROP TRIGGER tg_after_insert_registration;
DELIMITER $$
CREATE TRIGGER tg_after_insert_registration
AFTER INSERT ON match_registrations
FOR EACH ROW 
BEGIN 
IF NEW.attendance_status = 'Played' THEN
  UPDATE players
  SET skill_rating = LEAST(skill_rating + 0.1 ,10.0)
  WHERE player_id = NEw.player_id;
END IF;
END $$
DELIMITER $$

-- PHẦN 7. STORED PROCEDURE (10 ĐIỂM)
-- Câu 1 – 5 điểm
-- Viết stored procedure nhận vào mã cầu thủ và trả về thông báo dựa trên tổng số bàn thắng
--  trong các đăng ký có attendance_status = 'Played':
-- - Tổng bàn thắng lớn hơn 3: Top scorer.
-- - Tổng bàn thắng bằng 3: Target met.
-- - Tổng bàn thắng nhỏ hơn 3: Keep training.
-- - Nếu cầu thủ chưa thi đấu hoặc chưa ghi bàn, tổng số bàn thắng được xem là 0.
DELIMITER $$
CREATE PROCEDURE sp_check_player_goals (
IN p_player_id INT,
OUT p_message VARCHAR(50)
)
BEGIN 
DECLARE v_total_goals INT DEFAULT 0;




IF v_total_goals > 3 THEN 
SET p_message = 'Top scorer ';
ELSEIF v_total_goals = 3 THEN
SET p_message = 'Target met';
ELSE
SET p_message = 'Keep training';
END IF;
END $$
DELIMITER $$

