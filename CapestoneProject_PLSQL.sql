SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION get_available_slots(
    p_doctor_id IN NUMBER,
    p_start_date IN DATE,
    p_end_date IN DATE
) RETURN SYS_REFCURSOR
AS
    v_result_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor with the result set
    DBMS_OUTPUT.PUT_LINE('p_start_date '||p_start_date);
    DBMS_OUTPUT.PUT_LINE('p_end_date '||p_end_date);
    OPEN v_result_cursor FOR
        WITH date_range AS (
            -- Generate all dates in the specified range
            SELECT p_start_date + LEVEL - 1 AS calendar_date
            FROM dual
            CONNECT BY LEVEL <= (p_end_date - p_start_date + 1)
        ),
        schedule_info AS (
            -- Get schedule information for each date
            SELECT 
                dr.calendar_date,
                s.schedule_id,
                s.max_tokens,
                TO_CHAR(dr.calendar_date, 'D') AS day_of_week_num
            FROM 
                date_range dr
            JOIN 
                schedules s ON s.day_of_week = TO_NUMBER(TO_CHAR(dr.calendar_date, 'D')) - 1
            WHERE 
                s.doctor_id = p_doctor_id
                AND s.is_available = 1
        ),
        appointment_counts AS (
            -- Count appointments for each date and schedule, excluding cancelled ones
            SELECT 
                TRUNC(a.appointment_date) AS appt_date,
                a.schedule_id,
                COUNT(*) AS booked_count
            FROM 
                appointments a
            JOIN 
                schedules s ON a.schedule_id = s.schedule_id
            WHERE 
                s.doctor_id = p_doctor_id
                AND TRUNC(a.appointment_date) BETWEEN p_start_date AND p_end_date
                -- Exclude cancelled appointments
                AND a.status_id != 3  -- Assuming 3 is the status ID for 'Cancelled'
            GROUP BY 
                TRUNC(a.appointment_date), a.schedule_id
        )
        -- Final result with available slots calculation
        SELECT 
            si.calendar_date AS appointment_date,
            si.schedule_id,
            si.max_tokens AS total_slots,
            NVL(ac.booked_count, 0) AS booked_slots,
            si.max_tokens - NVL(ac.booked_count, 0) AS available_slots
        FROM 
            schedule_info si
        LEFT JOIN 
            appointment_counts ac ON si.calendar_date = ac.appt_date AND si.schedule_id = ac.schedule_id
        ORDER BY 
            si.calendar_date;
    
    RETURN v_result_cursor;
END;
/

-- Example usage:
DECLARE
    v_cursor SYS_REFCURSOR;
    v_date DATE;
    v_schedule_id NUMBER;
    v_total_slots NUMBER;
    v_booked_slots NUMBER;
    v_available_slots NUMBER;
BEGIN
    -- Get available slots for doctor_id 1 for the next 30 days
    v_cursor := get_available_slots(82, TRUNC(SYSDATE), TRUNC(SYSDATE) + 30);
    
    DBMS_OUTPUT.PUT_LINE('Date       | Schedule ID | Total | Booked | Available');
    DBMS_OUTPUT.PUT_LINE('-----------|-------------|-------|--------|----------');
    
    LOOP
        FETCH v_cursor INTO v_date, v_schedule_id, v_total_slots, v_booked_slots, v_available_slots;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(
            TO_CHAR(v_date, 'YYYY-MM-DD') || ' | ' ||
            LPAD(v_schedule_id, 11) || ' | ' ||
            LPAD(v_total_slots, 5) || ' | ' ||
            LPAD(v_booked_slots, 6) || ' | ' ||
            LPAD(v_available_slots, 10)
        );
    END LOOP;
    
    CLOSE v_cursor;
END;
/

-- Package Specification
CREATE OR REPLACE PACKAGE dashboard_analytics AS
    -- Patients analytics procedure
    PROCEDURE get_patient_analytics(
        p_active_count OUT NUMBER,
        p_inactive_count OUT NUMBER,
        p_new_this_week OUT NUMBER,
        p_total_count OUT NUMBER
    );
    
    -- Doctor analytics procedure
    PROCEDURE get_doctor_analytics(
        p_active_count OUT NUMBER,
        p_total_count OUT NUMBER
    );
    
    -- Today's active doctor information procedure
    PROCEDURE get_today_active_doctors(
        p_result OUT SYS_REFCURSOR
    );
    
    -- Today's appointment analytics procedure
    PROCEDURE get_today_appointment_analytics(
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    );
    
    -- Overall appointment analytics procedure
    PROCEDURE get_overall_appointment_analytics(
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    );
END dashboard_analytics;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY dashboard_analytics AS
    -- Patients analytics procedure implementation
    PROCEDURE get_patient_analytics(
        p_active_count OUT NUMBER,
        p_inactive_count OUT NUMBER,
        p_new_this_week OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total patient count
        SELECT COUNT(*) INTO p_total_count
        FROM patients;
        
        -- Get active patients count (patients with appointments in the last 3 months)
        SELECT COUNT(DISTINCT p.patient_id) INTO p_active_count
        FROM patients p
        JOIN appointments a ON p.patient_id = a.patient_id
        WHERE a.appointment_date >= SYSDATE - 90;
        
        -- Calculate inactive patients (total - active)
        p_inactive_count := p_total_count - p_active_count;
        
        -- Get new patients this week
        SELECT COUNT(*) INTO p_new_this_week
        FROM patients
        WHERE created_at >= TRUNC(SYSDATE, 'IW') 
          AND created_at < TRUNC(SYSDATE, 'IW') + 7;
    END get_patient_analytics;
    
    -- Doctor analytics procedure implementation
    PROCEDURE get_doctor_analytics(
        p_active_count OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total doctors count
        SELECT COUNT(*) INTO p_total_count
        FROM doctors;
        
        -- Get active doctors count
        SELECT COUNT(*) INTO p_active_count
        FROM doctors
        WHERE is_active = 1;
    END get_doctor_analytics;
    
    -- Today's active doctor information procedure implementation
    PROCEDURE get_today_active_doctors(
        p_result OUT SYS_REFCURSOR
    ) IS
    BEGIN
        -- Open cursor for all active doctors with their pending appointments count for today
        OPEN p_result FOR
            SELECT 
                ud.first_name || ' ' || ud.last_name AS doctor_name,
                d.specialization,
                COUNT(a.appointment_id) AS pending_appointments
            FROM 
                doctors d
                JOIN user_details ud ON d.user_id = ud.user_id
                LEFT JOIN schedules s ON d.doctor_id = s.doctor_id 
                LEFT JOIN appointments a ON s.schedule_id = a.schedule_id
                    AND TRUNC(a.appointment_date) = TRUNC(SYSDATE)
                    AND a.status_id = (SELECT status_id FROM appointments_status WHERE status_name = 'Pending')
            WHERE 
                d.is_active = 1
            GROUP BY 
                ud.first_name || ' ' || ud.last_name,
                d.specialization
            ORDER BY 
                pending_appointments DESC;
    END get_today_active_doctors;
    
    -- Today's appointment analytics procedure implementation
    PROCEDURE get_today_appointment_analytics(
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total appointments for today
        SELECT COUNT(*) INTO p_total_count
        FROM appointments
        WHERE TRUNC(appointment_date) = TRUNC(SYSDATE);
        
        -- Get pending appointments count
        SELECT COUNT(*) INTO p_pending_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND s.status_name = 'Pending';
        
        -- Get completed appointments count
        SELECT COUNT(*) INTO p_completed_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND s.status_name = 'Completed';
        
        -- Get cancelled appointments count
        SELECT COUNT(*) INTO p_cancelled_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND s.status_name = 'Cancelled';
    END get_today_appointment_analytics;
    
    -- Overall appointment analytics procedure implementation
    PROCEDURE get_overall_appointment_analytics(
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total appointments
        SELECT COUNT(*) INTO p_total_count
        FROM appointments;
        
        -- Get pending appointments count
        SELECT COUNT(*) INTO p_pending_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE s.status_name = 'Pending';
        
        -- Get completed appointments count
        SELECT COUNT(*) INTO p_completed_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE s.status_name = 'Completed';
        
        -- Get cancelled appointments count
        SELECT COUNT(*) INTO p_cancelled_count
        FROM appointments a
        JOIN appointments_status s ON a.status_id = s.status_id
        WHERE s.status_name = 'Cancelled';
    END get_overall_appointment_analytics;
END dashboard_analytics;
/

-- Test Patient Analytics
DECLARE
    v_active_count NUMBER;
    v_inactive_count NUMBER;
    v_new_this_week NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    dashboard_analytics.get_patient_analytics(
        p_active_count => v_active_count,
        p_inactive_count => v_inactive_count,
        p_new_this_week => v_new_this_week,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Patient Analytics:');
    DBMS_OUTPUT.PUT_LINE('Active Patients: ' || v_active_count);
    DBMS_OUTPUT.PUT_LINE('Inactive Patients: ' || v_inactive_count);
    DBMS_OUTPUT.PUT_LINE('New Patients This Week: ' || v_new_this_week);
    DBMS_OUTPUT.PUT_LINE('Total Patients: ' || v_total_count);
END;
/

-- Test Doctor Analytics
DECLARE
    v_active_count NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    dashboard_analytics.get_doctor_analytics(
        p_active_count => v_active_count,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Doctor Analytics:');
    DBMS_OUTPUT.PUT_LINE('Active Doctors: ' || v_active_count);
    DBMS_OUTPUT.PUT_LINE('Total Doctors: ' || v_total_count);
END;
/

-- Test Today's Active Doctors
DECLARE
    v_cursor SYS_REFCURSOR;
    v_doctor_name VARCHAR2(100);
    v_specialization VARCHAR2(100);
    v_pending_appointments NUMBER;
BEGIN
    -- Call the package procedure
    dashboard_analytics.get_today_active_doctors(
        p_result => v_cursor
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Today''s Active Doctors:');
    LOOP
        FETCH v_cursor INTO v_doctor_name, v_specialization, v_pending_appointments;
        EXIT WHEN v_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Doctor: ' || v_doctor_name || 
                             ', Specialization: ' || v_specialization || 
                             ', Pending Appointments: ' || v_pending_appointments);
    END LOOP;
    
    CLOSE v_cursor;
END;
/

-- Test Today's Appointment Analytics
DECLARE
    v_pending_count NUMBER;
    v_completed_count NUMBER;
    v_cancelled_count NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    dashboard_analytics.get_today_appointment_analytics(
        p_pending_count => v_pending_count,
        p_completed_count => v_completed_count,
        p_cancelled_count => v_cancelled_count,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Today''s Appointment Analytics:');
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_total_count);
END;
/

-- Test Overall Appointment Analytics
DECLARE
    v_pending_count NUMBER;
    v_completed_count NUMBER;
    v_cancelled_count NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    dashboard_analytics.get_overall_appointment_analytics(
        p_pending_count => v_pending_count,
        p_completed_count => v_completed_count,
        p_cancelled_count => v_cancelled_count,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Overall Appointment Analytics:');
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_total_count);
END;
/

-- Doctor Dashboard Analytics Package Specification
CREATE OR REPLACE PACKAGE doctor_dashboard_analytics AS
    -- Doctor's patient analytics procedure
    PROCEDURE get_doctor_patient_analytics(
        p_doctor_id IN NUMBER,
        p_total_patients OUT NUMBER,
        p_new_patients_this_month OUT NUMBER,
        p_today_patients OUT NUMBER
    );
    
    -- Doctor's appointment analytics procedure
    PROCEDURE get_doctor_today_appointment_analytics(
        p_doctor_id IN NUMBER,
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    );
    
    -- Doctor's overall appointment analytics procedure
    PROCEDURE get_doctor_overall_appointment_analytics(
        p_doctor_id IN NUMBER,
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    );
END doctor_dashboard_analytics;
/

-- Doctor Dashboard Analytics Package Body
CREATE OR REPLACE PACKAGE BODY doctor_dashboard_analytics AS
    -- Doctor's patient analytics procedure implementation
    PROCEDURE get_doctor_patient_analytics(
        p_doctor_id IN NUMBER,
        p_total_patients OUT NUMBER,
        p_new_patients_this_month OUT NUMBER,
        p_today_patients OUT NUMBER
    ) IS
    BEGIN
        -- Get total unique patients the doctor has handled till now
        SELECT COUNT(DISTINCT p.patient_id) INTO p_total_patients
        FROM patients p
        JOIN appointments a ON p.patient_id = a.patient_id
        JOIN schedules s ON a.schedule_id = s.schedule_id
        WHERE s.doctor_id = p_doctor_id;
        
        -- Get new patients this month
        SELECT COUNT(DISTINCT p.patient_id) INTO p_new_patients_this_month
        FROM patients p
        JOIN appointments a ON p.patient_id = a.patient_id
        JOIN schedules s ON a.schedule_id = s.schedule_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.created_at, 'MM') = TRUNC(SYSDATE, 'MM')
        AND NOT EXISTS (
            SELECT 1 
            FROM appointments a2
            JOIN schedules s2 ON a2.schedule_id = s2.schedule_id
            WHERE a2.patient_id = p.patient_id
            AND s2.doctor_id = p_doctor_id
            AND a2.created_at < TRUNC(SYSDATE, 'MM')
        );
        
        -- Get today's patients with appointments for this doctor
        SELECT COUNT(DISTINCT p.patient_id) INTO p_today_patients
        FROM patients p
        JOIN appointments a ON p.patient_id = a.patient_id
        JOIN schedules s ON a.schedule_id = s.schedule_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.appointment_date) = TRUNC(SYSDATE);
    END get_doctor_patient_analytics;
    
    -- Doctor's today appointment analytics procedure implementation
    PROCEDURE get_doctor_today_appointment_analytics(
        p_doctor_id IN NUMBER,
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total appointments for today for this doctor
        SELECT COUNT(*) INTO p_total_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.appointment_date) = TRUNC(SYSDATE);
        
        -- Get pending appointments count
        SELECT COUNT(*) INTO p_pending_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND ast.status_name = 'Pending';
        
        -- Get completed appointments count
        SELECT COUNT(*) INTO p_completed_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND ast.status_name = 'Completed';
        
        -- Get cancelled appointments count
        SELECT COUNT(*) INTO p_cancelled_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND TRUNC(a.appointment_date) = TRUNC(SYSDATE)
        AND ast.status_name = 'Cancelled';
    END get_doctor_today_appointment_analytics;
    
    -- Doctor's overall appointment analytics procedure implementation
    PROCEDURE get_doctor_overall_appointment_analytics(
        p_doctor_id IN NUMBER,
        p_pending_count OUT NUMBER,
        p_completed_count OUT NUMBER,
        p_cancelled_count OUT NUMBER,
        p_total_count OUT NUMBER
    ) IS
    BEGIN
        -- Get total appointments for this doctor
        SELECT COUNT(*) INTO p_total_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        WHERE s.doctor_id = p_doctor_id;
        
        -- Get pending appointments count
        SELECT COUNT(*) INTO p_pending_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND ast.status_name = 'Pending';
        
        -- Get completed appointments count
        SELECT COUNT(*) INTO p_completed_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND ast.status_name = 'Completed';
        
        -- Get cancelled appointments count
        SELECT COUNT(*) INTO p_cancelled_count
        FROM appointments a
        JOIN schedules s ON a.schedule_id = s.schedule_id
        JOIN appointments_status ast ON a.status_id = ast.status_id
        WHERE s.doctor_id = p_doctor_id
        AND ast.status_name = 'Cancelled';
    END get_doctor_overall_appointment_analytics;
END doctor_dashboard_analytics;
/

-- Test Doctor Patient Analytics
DECLARE
    v_doctor_id NUMBER := 1; -- Replace with actual doctor_id
    v_total_patients NUMBER;
    v_new_patients_this_month NUMBER;
    v_today_patients NUMBER;
BEGIN
    -- Call the package procedure
    doctor_dashboard_analytics.get_doctor_patient_analytics(
        p_doctor_id => v_doctor_id,
        p_total_patients => v_total_patients,
        p_new_patients_this_month => v_new_patients_this_month,
        p_today_patients => v_today_patients
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Doctor Patient Analytics for Doctor ID: ' || v_doctor_id);
    DBMS_OUTPUT.PUT_LINE('Total Patients Handled: ' || v_total_patients);
    DBMS_OUTPUT.PUT_LINE('New Patients This Month: ' || v_new_patients_this_month);
    DBMS_OUTPUT.PUT_LINE('Patients with Appointments Today: ' || v_today_patients);
END;
/

-- Test Doctor Today's Appointment Analytics
DECLARE
    v_doctor_id NUMBER := 1; -- Replace with actual doctor_id
    v_pending_count NUMBER;
    v_completed_count NUMBER;
    v_cancelled_count NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    doctor_dashboard_analytics.get_doctor_today_appointment_analytics(
        p_doctor_id => v_doctor_id,
        p_pending_count => v_pending_count,
        p_completed_count => v_completed_count,
        p_cancelled_count => v_cancelled_count,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Today''s Appointment Analytics for Doctor ID: ' || v_doctor_id);
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_total_count);
END;
/

-- Test Doctor Overall Appointment Analytics
DECLARE
    v_doctor_id NUMBER := 1; -- Replace with actual doctor_id
    v_pending_count NUMBER;
    v_completed_count NUMBER;
    v_cancelled_count NUMBER;
    v_total_count NUMBER;
BEGIN
    -- Call the package procedure
    doctor_dashboard_analytics.get_doctor_overall_appointment_analytics(
        p_doctor_id => v_doctor_id,
        p_pending_count => v_pending_count,
        p_completed_count => v_completed_count,
        p_cancelled_count => v_cancelled_count,
        p_total_count => v_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Overall Appointment Analytics for Doctor ID: ' || v_doctor_id);
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_total_count);
END;
/

-- Combined Doctor Dashboard Analytics (All in one block)
CREATE OR REPLACE PROCEDURE get_doctor_dashboard_analytics(
    p_doctor_id IN NUMBER
) AS
    -- Patient analytics variables
    v_total_patients NUMBER;
    v_new_patients_this_month NUMBER;
    v_today_patients NUMBER;
    
    -- Today's appointment analytics variables
    v_today_pending_count NUMBER;
    v_today_completed_count NUMBER;
    v_today_cancelled_count NUMBER;
    v_today_total_count NUMBER;
    
    -- Overall appointment analytics variables
    v_overall_pending_count NUMBER;
    v_overall_completed_count NUMBER;
    v_overall_cancelled_count NUMBER;
    v_overall_total_count NUMBER;
    
    -- Doctor information variables
    v_doctor_name VARCHAR2(100);
    v_specialization VARCHAR2(100);
BEGIN
    -- Get doctor information
    SELECT ud.first_name || ' ' || ud.last_name, d.specialization
    INTO v_doctor_name, v_specialization
    FROM doctors d
    JOIN user_details ud ON d.user_id = ud.user_id
    WHERE d.doctor_id = p_doctor_id;
    
    -- Get patient analytics
    doctor_dashboard_analytics.get_doctor_patient_analytics(
        p_doctor_id => p_doctor_id,
        p_total_patients => v_total_patients,
        p_new_patients_this_month => v_new_patients_this_month,
        p_today_patients => v_today_patients
    );
    
    -- Get today's appointment analytics
    doctor_dashboard_analytics.get_doctor_today_appointment_analytics(
        p_doctor_id => p_doctor_id,
        p_pending_count => v_today_pending_count,
        p_completed_count => v_today_completed_count,
        p_cancelled_count => v_today_cancelled_count,
        p_total_count => v_today_total_count
    );
    
    -- Get overall appointment analytics
    doctor_dashboard_analytics.get_doctor_overall_appointment_analytics(
        p_doctor_id => p_doctor_id,
        p_pending_count => v_overall_pending_count,
        p_completed_count => v_overall_completed_count,
        p_cancelled_count => v_overall_cancelled_count,
        p_total_count => v_overall_total_count
    );
    
    -- Display the results
    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('Dashboard Analytics for Doctor: ' || v_doctor_name);
    DBMS_OUTPUT.PUT_LINE('Specialization: ' || v_specialization);
    DBMS_OUTPUT.PUT_LINE('=================================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('PATIENT ANALYTICS');
    DBMS_OUTPUT.PUT_LINE('-----------------');
    DBMS_OUTPUT.PUT_LINE('Total Patients Handled: ' || v_total_patients);
    DBMS_OUTPUT.PUT_LINE('New Patients This Month: ' || v_new_patients_this_month);
    DBMS_OUTPUT.PUT_LINE('Patients with Appointments Today: ' || v_today_patients);
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('TODAY''S APPOINTMENT ANALYTICS');
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_today_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_today_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_today_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_today_total_count);
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('OVERALL APPOINTMENT ANALYTICS');
    DBMS_OUTPUT.PUT_LINE('----------------------------');
    DBMS_OUTPUT.PUT_LINE('Pending Appointments: ' || v_overall_pending_count);
    DBMS_OUTPUT.PUT_LINE('Completed Appointments: ' || v_overall_completed_count);
    DBMS_OUTPUT.PUT_LINE('Cancelled Appointments: ' || v_overall_cancelled_count);
    DBMS_OUTPUT.PUT_LINE('Total Appointments: ' || v_overall_total_count);
    DBMS_OUTPUT.PUT_LINE('=================================================');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Doctor with ID ' || p_doctor_id || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END get_doctor_dashboard_analytics;
/

-- Test the combined doctor dashboard analytics procedure
EXECUTE get_doctor_dashboard_analytics(1); -- Replace with actual doctor_id

Commit;