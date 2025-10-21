-- ===========================
-- Patient Health Record and Medical History Tracker
-- ===========================

-- Create patient management tables
CREATE TABLE Patients (
    patient_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    date_of_birth TEXT,
    contact TEXT
);

CREATE TABLE Doctors (
    doctor_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    specialization TEXT
);

CREATE TABLE Appointments (
    appointment_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    doctor_id INTEGER,
    appointment_date TEXT,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY(doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Diagnoses (
    diagnosis_id INTEGER PRIMARY KEY,
    appointment_id INTEGER,
    diagnosis TEXT,
    FOREIGN KEY(appointment_id) REFERENCES Appointments(appointment_id)
);

CREATE TABLE Medications (
    medication_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    medication_name TEXT,
    dosage TEXT,
    FOREIGN KEY(patient_id) REFERENCES Patients(patient_id)
);

-- Insert mock data using transaction
BEGIN TRANSACTION;

INSERT INTO Patients (name, date_of_birth, contact) VALUES
('John Doe', '1980-05-20', '555-1234'),
('Jane Smith', '1990-08-12', '555-5678');

INSERT INTO Doctors (name, specialization) VALUES
('Dr. Adams', 'Cardiology'),
('Dr. Baker', 'Neurology');

INSERT INTO Appointments (patient_id, doctor_id, appointment_date) VALUES
(1, 1, '2025-03-10'),
(2, 2, '2025-03-11');

INSERT INTO Diagnoses (appointment_id, diagnosis) VALUES
(1, 'Hypertension'),
(2, 'Migraine');

INSERT INTO Medications (patient_id, medication_name, dosage) VALUES
(1, 'Lisinopril', '10mg daily'),
(2, 'Ibuprofen', '200mg as needed');

COMMIT;
-- Transaction ensures all related medical records are added together safely

-- Example Queries

-- 1. Get all appointments for a patient
SELECT Patients.name, Doctors.name AS doctor, Appointments.appointment_date
FROM Appointments
JOIN Patients ON Appointments.patient_id = Patients.patient_id
JOIN Doctors ON Appointments.doctor_id = Doctors.doctor_id
WHERE Patients.name = 'John Doe';

-- 2. List medications for each patient
SELECT Patients.name, Medications.medication_name, Medications.dosage
FROM Medications
JOIN Patients ON Medications.patient_id = Patients.patient_id;

-- 3. Find patients diagnosed with a specific disease
SELECT Patients.name, Diagnoses.diagnosis
FROM Diagnoses
JOIN Appointments ON Diagnoses.appointment_id = Appointments.appointment_id
JOIN Patients ON Appointments.patient_id = Patients.patient_id
WHERE Diagnoses.diagnosis = 'Hypertension';
