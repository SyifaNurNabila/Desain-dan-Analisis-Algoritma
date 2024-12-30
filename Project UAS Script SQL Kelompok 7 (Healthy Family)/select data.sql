USE healthy_family;

-- 1. Select dasar dari family_overview
SELECT * FROM family_overview;

-- 2. Select family_overview dengan pengurutan berdasarkan jumlah anak
SELECT 
    parent_name as nama_orangtua,
    number_of_children as jumlah_anak,
    active_goals as tujuan_aktif,
    meal_plans as rencana_makan
FROM family_overview
ORDER BY number_of_children DESC;

-- 3. Select family_overview untuk keluarga dengan anak > 1
SELECT 
    parent_name as nama_orangtua,
    number_of_children as jumlah_anak,
    active_goals as tujuan_aktif,
    meal_plans as rencana_makan
FROM family_overview
WHERE number_of_children > 1;

-- 4. Select family_overview dengan total semua aktivitas
SELECT 
    SUM(number_of_children) as total_anak,
    SUM(active_goals) as total_tujuan_aktif,
    SUM(meal_plans) as total_rencana_makan
FROM family_overview;

-- 5. Select dasar dari weekly_activities
SELECT * FROM weekly_activities;

-- 6. Select weekly_activities dengan pengurutan berdasarkan kalori terbanyak
SELECT 
    full_name as nama_lengkap,
    activity_type as jenis_aktivitas,
    total_duration as total_durasi,
    total_calories as total_kalori
FROM weekly_activities
ORDER BY total_calories DESC;

-- 7. Select weekly_activities untuk aktivitas tertentu
SELECT 
    full_name as nama_lengkap,
    total_duration as total_durasi,
    total_calories as total_kalori
FROM weekly_activities
WHERE activity_type = 'Lari';

-- 8. Select weekly_activities dengan total per orang
SELECT 
    full_name as nama_lengkap,
    SUM(total_duration) as total_durasi_semua_aktivitas,
    SUM(total_calories) as total_kalori_terbakar
FROM weekly_activities
GROUP BY full_name;

-- 9. Menggabungkan informasi dari kedua view
SELECT 
    fo.parent_name as nama_orangtua,
    fo.number_of_children as jumlah_anak,
    wa.activity_type as jenis_aktivitas,
    wa.total_calories as kalori_terbakar
FROM family_overview fo
LEFT JOIN weekly_activities wa ON fo.parent_name = wa.full_name
ORDER BY fo.number_of_children DESC, wa.total_calories DESC;

-- 10. Mencari rata-rata aktivitas per keluarga
SELECT 
    wa.full_name as nama_lengkap,
    COUNT(DISTINCT wa.activity_type) as jumlah_jenis_aktivitas,
    AVG(wa.total_duration) as rata_rata_durasi,
    AVG(wa.total_calories) as rata_rata_kalori
FROM weekly_activities wa
GROUP BY wa.full_name;