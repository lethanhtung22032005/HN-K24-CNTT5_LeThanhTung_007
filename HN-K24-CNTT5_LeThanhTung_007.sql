create database de007;
use de007;

-- patients, doctors, appointments, medical_records, visit_log

create table Patients (
	patient_id int auto_increment primary key,
	full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR (15) NOT NULL UNIQUE,
    gender VARCHAR (50) NOT NULL,
    date_of_birth datetime
);


create table doctors(
	doctor_id int auto_increment primary key,
    full_name VARCHAR (50) NOT NULL,
    specialty VARCHAR (50) NOT NULL,
    phone_number VARCHAR (15) NOT NULL UNIQUE,
    rating decimal (5,2) 
);
create table appointments(
	appointment_id int auto_increment primary key,
    appointment_time timestamp not null,
    fee varchar (255) check (fee >= 0),
    status enum ('Booked', 'Completed', 'Cancelled'),
    patient_id int not null,
    doctor_id int not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

create table medical_records(
	log_id int auto_increment primary key,
    record_id int not null,
    doctor_id int not null,
    log_time timestamp not null,
    note text not null
);

create table visit_log(
	record_id int auto_increment primary key,
    appointment_id int not null,
    symptoms VARCHAR (255) NOT NULL,
    diagnosis VARCHAR (255) NOT NULL,
    prescription TEXT NOT NULL,
    record_date datetime default NOW(),
    foreign key (appointment_id) references appointments(appointment_id)
);

insert into patients (full_name, phone_number, gender, date_of_birth ) values
('Nguyen Thi Lan',	'901234567',	'Female',	'1999-12-3'),
('Tran Van Minh',	'902345678',	'Male',	'1996-11-25'),
('Le Hoai Phuong',	'913456789',	'Female',	'2001-7-8'),
('Pham Duc Anh',	'984567890',	'Male',	'1998-1-19'),
('Hoang Ngoc Mai',	'975678901',	'Female',	'2000-9-30');

insert into doctors (full_name,specialty,phone_number,rating) values
('BS. Nguyen Van Hai',	'Noi',	'931112223',	4.8),
('BS. Tran Thu Ha',	'Nhi',	'932223334',	5),
('BS. Le Quoc Tuan',	'Ngoai',	'933334445',	4.6),
('BS. Pham Minh Chau',	'Da lieu',	'934445556',	4.9),
('BS. Hoang Gia Bao',	'Tim mach',	'935556667',	4.7);

insert into appointments (patient_id,doctor_id,appointment_time,fee,status) values
(1,	1,	'2024-5-20-8:00',	'200000',	'Booked'),
(2,	2,	'2024-5-20-9:30',	'250000',	'Completed'),
(3,	3,	'2024'-5-20-10:15',	'300000',	'Booked'),
(4,	5,	'2024-5-21-7:00',	'350000',	'Completed'),
(5,	4,	'2024-5-21-8:45',	'220000',	'Cancelled');
