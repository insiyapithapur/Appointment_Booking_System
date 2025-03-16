SELECT * FROM roles;
SELECT * FROM  USERS;
SELECT * FROM user_details;
SELECT * FROM  DOCTORS;
SELECT * FROM SCHEDULES;

SELECT * FROM  PATIENTS;
SELECT * FROM appointments_status;
SELECT * FROM  APPOINTMENTS; 
SELECT * FROM  MEDICAL_RECORDS;

UPDATE MEDICAL_RECORDS
SET appointment_id = 1
WHERE record_id = 1;

SELECT * FROM medical_records WHERE appointment_id = 1;
INSERT INTO users (
    username,
    password_hash,
    role_id,
    is_login
) VALUES (
    'ADMIN_INSIYA',
    'ROOT',
    1,
    1
);

INSERT INTO appointments_status (status_name) VALUES ('Cancelled');

INSERT INTO appointments (patient_id, schedule_id, appointment_date, apt_time, token_no, reason, status_id)
VALUES 
(1, 1, TO_DATE('2025-03-15', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-15 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 'Routine Checkup', 1);

INSERT INTO appointments (patient_id, schedule_id, appointment_date, apt_time, token_no, reason, status_id)
VALUES 
(1, 2, TO_DATE('2025-03-16', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-16 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 'Fever and Cold', 1);
--(1, 2, TO_DATE('2025-03-17', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-17 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 'Follow-up Consultation', 1),
--(4, 3, TO_DATE('2025-03-18', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-18 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'Back Pain', 1),
--(5, 2, TO_DATE('2025-03-19', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 'General Health Checkup', 1);

COMMIT;



SELECT * FROM users WHERE user_id = 1;
COMMIT;
drop table roles;
drop table USERS;
drop table user_details;
drop table DOCTORS;
drop table PATIENTS;
drop table SCHEDULES;
drop table APPOINTMENTS; 
drop table MEDICAL_RECORDS;
drop table appointments_status;