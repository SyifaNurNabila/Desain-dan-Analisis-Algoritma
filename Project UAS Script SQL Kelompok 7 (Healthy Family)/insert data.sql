USE healthy_family;

-- Masukkan data pengguna
INSERT INTO users (username, password, email, full_name, birth, is_admin) VALUES
('budi_santoso', 'password123_hash', 'budi@email.com', 'Budi Santoso', '1985-03-15', true),
('siti_rahayu', 'password456_hash', 'siti@email.com', 'Siti Rahayu', '1990-07-22', false),
('ahmad_wijaya', 'password789_hash', 'ahmad@email.com', 'Ahmad Wijaya', '1988-11-30', false),
('dewi_susanti', 'password101_hash', 'dewi@email.com', 'Dewi Susanti', '1992-04-18', false),
('rudi_hermawan', 'password102_hash', 'rudi@email.com', 'Rudi Hermawan', '1987-09-25', false);

-- Masukkan data anak
INSERT INTO children (users_id, child_name, birth) VALUES
(1, 'Andi Santoso', '2015-06-12'),
('1', 'Putri Santoso', '2018-08-23'),
(2, 'Dimas Rahaju', '2017-03-15'),
(3, 'Fajar Wijaya', '2016-11-07'),
(3, 'Nina Wijaya', '2019-02-14'),
(4, 'Rizki Susanti', '2018-05-20');

-- Masukkan data makanan
INSERT INTO meals (meal_name, description, calories, is_child_friendly) VALUES
('Nasi Goreng Sayur', 'Nasi goreng dengan campuran sayuran dan telur', 350, true),
('Bubur Ayam', 'Bubur dengan ayam suwir, telur dan sayuran', 300, true),
('Gado-gado', 'Sayuran segar dengan bumbu kacang', 280, true),
('Sup Ikan', 'Sup ikan dengan sayuran dan tahu', 250, true),
('Nasi Tim', 'Nasi tim dengan ayam, wortel dan bayam', 300, true),
('Mie Goreng Sehat', 'Mie goreng dengan banyak sayuran', 320, true);

-- Masukkan rencana makan
INSERT INTO meal_plans (users_id, meal_id, planned_date, meal_type) VALUES
(1, 1, '2024-12-25', 'lunch'),
(1, 2, '2024-12-25', 'breakfast'),
(2, 3, '2024-12-25', 'dinner'),
(3, 4, '2024-12-25', 'lunch'),
(4, 5, '2024-12-25', 'breakfast'),
(2, 6, '2024-12-25', 'lunch');

-- Masukkan tujuan
INSERT INTO goals (users_id, title, description, target_date, is_completed) VALUES
(1, 'Olahraga Keluarga', 'Olahraga bersama 3 kali seminggu', '2025-01-31', false),
(2, 'Makan Sehat', 'Memasak lebih banyak makanan di rumah', '2025-02-28', false),
(3, 'Jadwal Tidur Teratur', 'Membuat rutinitas tidur yang konsisten', '2025-01-15', false),
(4, 'Kurangi Waktu Layar', 'Batasi waktu layar keluarga menjadi 2 jam per hari', '2025-01-31', false),
(1, 'Belajar Berenang', 'Mendaftarkan anak-anak ke kelas renang', '2025-03-31', false);

-- Masukkan aktivitas
INSERT INTO activities (users_id, activity_type, duration, calories_burned, date) VALUES
(1, 'Jalan Pagi', 30, 150, '2024-12-25'),
(1, 'Berenang', 45, 300, '2024-12-24'),
(2, 'Bersepeda', 60, 400, '2024-12-25'),
(3, 'Lari', 30, 250, '2024-12-25'),
(4, 'Senam', 45, 180, '2024-12-25'),
(2, 'Menari', 30, 200, '2024-12-24');

-- Masukkan jadwal
INSERT INTO schedules (users_id, title, description, date, start_time, end_time, is_work, is_family, is_personal) VALUES
(1, 'Makan Malam Keluarga', 'Waktu makan malam bersama mingguan', '2024-12-25', '2024-12-25 18:00:00', '2024-12-25 19:30:00', false, true, false),
(2, 'Rapat Kerja', 'Rapat tim mingguan', '2024-12-25', '2024-12-25 10:00:00', '2024-12-25 11:00:00', true, false, false),
(3, 'Latihan Futsal Anak', 'Latihan futsal mingguan', '2024-12-25', '2024-12-25 16:00:00', '2024-12-25 17:30:00', false, true, false),
(4, 'Waktu Gym', 'Olahraga pribadi', '2024-12-25', '2024-12-25 07:00:00', '2024-12-25 08:00:00', false, false, true),
(1, 'Malam Permainan Keluarga', 'Bermain board game bersama', '2024-12-25', '2024-12-25 19:30:00', '2024-12-25 21:00:00', false, true, false);