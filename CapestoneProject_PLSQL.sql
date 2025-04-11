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