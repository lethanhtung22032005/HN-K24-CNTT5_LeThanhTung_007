create database de007;
use de007;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE CHECK (date_of_birth < CURDATE())
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    rating DECIMAL(2,1) DEFAULT 5.0 CHECK (rating BETWEEN 0.0 AND 5.0)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    rating DECIMAL(2,1) DEFAULT 5.0 CHECK (rating BETWEEN 0.0 AND 5.0)
);
 
 CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_time DATETIME NOT NULL,
    fee DECIMAL(10,2) CHECK (fee > 0),
    status ENUM('Booked','Completed','Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    appointment_id INT,
    symptoms VARCHAR(255) NOT NULL,
    diagnosis VARCHAR(255) NOT NULL,
    prescription TEXT,
    record_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE visit_log (
    log_id INT PRIMARY KEY,
    record_id INT,
    doctor_id INT,
    log_time DATETIME NOT NULL,
    note TEXT,
    FOREIGN KEY (record_id) REFERENCES medical_records(record_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

INSERT INTO patients VALUES
(1,'Nguyen Thi Lan','0901234567','Female','1999-03-12'),
(2,'Tran Van Minh','0902345678','Male','1996-11-25'),
(3,'Le Hoai Phuong','0913456789','Female','2001-07-08'),
(4,'Pham Duc Anh','0984567890','Male','1998-01-19'),
(5,'Hoang Ngoc Mai','0975678901','Female','2000-09-30');

INSERT INTO doctors VALUES
(1,'BS. Nguyen Van Hai','Noi','0931112223',4.8),
(2,'BS. Tran Thu Ha','Nhi','0932223334',5.0),
(3,'BS. Le Quoc Tuan','Ngoai','0933334445',4.6),
(4,'BS. Pham Minh Chau','Da lieu','0934445556',4.9),
(5,'BS. Hoang Gia Bao','Tim mach','0935556667',4.7);

INSERT INTO appointments VALUES
(7001,1,1,'2024-05-20 08:00',200000,'Booked'),
(7002,2,2,'2024-05-20 09:30',250000,'Completed'),
(7003,3,3,'2024-05-20 10:15',300000,'Booked'),
(7004,4,5,'2024-05-21 07:00',350000,'Completed'),
(7005,5,4,'2024-05-21 08:45',220000,'Cancelled');

INSERT INTO medical_records VALUES
(8001,7002,'Sốt cao, ho','Viêm họng','Paracetamol + siro ho','2024-05-20 10:00'),
(8002,7004,'Đau ngực nhẹ','Theo dõi tim mạch','Vitamin + tái khám','2024-05-21 08:00'),
(8003,7001,'Đau bụng','Rối loạn tiêu hóa','Men tiêu hóa','2024-05-20 09:00'),
(8004,7003,'Đau vai gáy','Căng cơ','Giảm đau + nghỉ ngơi','2024-05-20 11:00'),
(8005,7005,'Ngứa da','Dị ứng','Thuốc bôi ngoài da','2024-05-21 09:00');

INSERT INTO visit_log VALUES
(1,8003,1,'2024-05-20 09:05','Đã khám lần đầu'),
(2,8001,2,'2024-05-20 10:05','Hoàn tất khám'),
(3,8004,3,'2024-05-20 11:10','Tư vấn vật lý trị liệu'),
(4,8002,5,'2024-05-21 08:10','Hướng dẫn tái khám'),
(5,8005,4,'2024-05-21 09:05','Bệnh nhân hủy hẹn');

UPDATE appointments a
JOIN patients p ON a.patient_id = p.patient_id
SET a.fee = a.fee * 1.1
WHERE a.status = 'Completed'
  AND YEAR(p.date_of_birth) < 2000;

DELETE FROM visit_log
WHERE log_time < '2024-05-20';

SELECT full_name, specialty, rating
FROM doctors
WHERE rating > 4.7 OR specialty = 'Nhi';

SELECT full_name, phone_number
FROM patients
WHERE date_of_birth BETWEEN '1998-01-01' AND '2001-12-31'
  AND phone_number LIKE '090%';

SELECT appointment_id, appointment_time, fee
FROM appointments
ORDER BY fee DESC
LIMIT 2 OFFSET 2;

SELECT p.full_name AS patient_name,
       d.full_name AS doctor_name,
       d.specialty,
       a.fee,
       a.appointment_time
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

SELECT d.full_name, SUM(a.fee) AS total_fee
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE a.status = 'Completed'
GROUP BY d.doctor_id, d.full_name
HAVING total_fee > 500000;

SELECT doctor_id, full_name, rating
FROM doctors
WHERE rating = (SELECT MAX(rating) FROM doctors);
