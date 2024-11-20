CREATE DATABASE health;
USE health;

-- Import data form "https://www.kaggle.com/datasets/ohinhaque/ocd-patient-dataset-demographics-and-clinical-data/?select=ocd_patient_dataset.csv"

SELECT * FROM health.ocd_patient_dataset;

-- 1. Đếm và chia tỷ lệ Nam-Nữ mắc OCD & Tính điểm trung bình ám ảnh theo giới tính (Avg obs score)
WITH data as (
	SELECT
	Gender,
	COUNT(`Patient ID`) as patient_count,
	ROUND(avg(`Y-BOCS Score (Obsessions)`),2) AS avg_obs_score
	FROM health.ocd_patient_dataset
	GROUP BY 1
	ORDER BY 2
)
SELECT
	SUM(case when Gender = 'Female' then patient_count else 0 end) AS count_female,
	SUM(case when Gender = 'Male' then patient_count else 0 end) AS count_male,

	ROUND(SUM(case when Gender = 'Female' then patient_count else 0 end)/
	(SUM(case when Gender = 'Female' then patient_count else 0 end)+SUM(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 AS pct_female,

    ROUND(SUM(case when Gender = 'Male' then patient_count else 0 end)/
	(SUM(case when Gender = 'Female' then patient_count else 0 end)+SUM(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 AS pct_male
FROM data;

-- 2. Đếm số lượng bệnh nhân theo sắc tộc và điểm trung bình ám ảnh
SELECT
	Ethnicity,
	count(`Patient ID`) as patient_count,
	avg(`Y-BOCS Score (Obsessions)`) as obs_score
FROM health.ocd_patient_dataset
GROUP BY 1
ORDER BY 2;

-- 3. Số lượng người được chẩn đoán mắc OCD hàng tháng
-- Sửa `OCD Diagnosis Date` thành kiểu dữ liệu ngày;
SELECT
	DATE_FORMAT(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') AS month, -- `OCD Diagnosis Date`
	COUNT(`Patient ID`) patient_count
FROM health.ocd_patient_dataset
GROUP BY 1
ORDER BY 1;

-- 4. Loại ám ảnh nào phổ biến nhất & tính điểm trung bình tương ứng
SELECT
	`Obsession Type`,
	COUNT(`Patient ID`) as patient_count,
	ROUND(avg(`Y-BOCS Score (Obsessions)`),2) as obs_score
from health.ocd_patient_dataset
GROUP BY 1
ORDER BY 2;

-- 5. Loại cưỡng chế nào phổ biến nhất & tính điểm trung bình tương ứng
SELECT
	`Compulsion Type`,
	COUNT(`Patient ID`) AS patient_count,
	ROUND(avg(`Y-BOCS Score (Obsessions)`),2) AS obs_score
FROM health.ocd_patient_dataset
GROUP BY 1
ORDER BY 2
;