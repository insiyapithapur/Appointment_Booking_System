package com.training.project.dao.Imp;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.ParameterMode;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.procedure.ProcedureCall;
import org.hibernate.query.Query;
import com.training.project.dao.GenericDao;
import com.training.project.model.Patient;

public class PatientDaoImp implements GenericDao<Patient, Integer> {
	private Session session;
	
	public PatientDaoImp(){
		super();
	}

	public PatientDaoImp(Session session) {
		super();
		this.session = session;
	}

	@Override
	public Patient findById(Integer id) {
		Patient patient = session.get(Patient.class, id);
	    System.out.println("Patient id: " + patient);
		return patient;
	}

	@Override
	public List<Patient> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Patient patient) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(patient);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(Patient entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Patient entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public long count() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean exists(Integer id) {
		return false;
	}
	public Patient findByUserId(Integer userId) {
	    Transaction tx = null;
	    Patient patient = null;
	    
	    try {
	        tx = session.beginTransaction();
	        
	        // Using HQL (Hibernate Query Language) to find patient by userId
	        String hql = "FROM Patient p WHERE p.user.userId = :userId";
	        patient = session.createQuery(hql, Patient.class)
	                       .setParameter("userId", userId)
	                       .uniqueResult();
	                       
	        tx.commit();
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	    }
	    
	    return patient;
	}
	
	public List<Patient> getAllPatients() {
        List<Patient> patients = null;
        try {
            Query<Patient> query = session.createQuery("FROM Patient", Patient.class);
            patients = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    			//get patients with user detailes
    
    public List<Object[]> getPatientDetails() {
        Transaction transaction = null;
        List<Object[]> patientDetails = null;
        try {
            transaction = session.beginTransaction();
            
            String hql = "SELECT p.bloodGrp, ud.firstName, ud.lastName, u.username, " +
                         "ud.email, ud.gender, ud.phoneNumber " +
                         "FROM Patient p " +
                         "JOIN p.user u " +
                         "JOIN UserDetail ud ON u.userId = ud.user.userId";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            patientDetails = query.getResultList();
            
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        return patientDetails;
    }

    public Object[] getPatientById(int patientId) {
        Transaction transaction = null;
        Object[] patientDetails = null;
        try {
            transaction = session.beginTransaction();
            
            String hql = "SELECT p.bloodGrp, ud.firstName, ud.lastName, u.username, " +
                         "ud.email, ud.gender, ud.phoneNumber " +
                         "FROM Patient p " +
                         "JOIN p.user u " +
                         "JOIN UserDetail ud ON u.userId = ud.user.userId " +
                         "WHERE p.patientId = :patientId";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setParameter("patientId", patientId);
            
            patientDetails = query.uniqueResult();
            
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        return patientDetails;
    }
    
    /**
     * Get the count of active appointments for a specific schedule and date
     * 
     * @param scheduleId The schedule ID
     * @param appointmentDate The appointment date
     * @return The number of non-cancelled appointments
     */
    public int getActiveAppointmentCount(int scheduleId, LocalDate appointmentDate) {
        int count = 0;
        
        try {
            // Get the status ID for "Cancelled" appointments
            Integer cancelledStatusId = 3;
            System.out.println("scheduleId "+scheduleId);
            System.out.println("appointmentDate "+appointmentDate);
            
            String countQuery;
            System.out.println("in if");
			// Exclude appointments with cancelled status
			countQuery = "SELECT COUNT(*) FROM appointments a " +
			            "WHERE a.schedule_id = :scheduleId " +
			            "AND TRUNC(a.appointment_date) = :appointmentDate " +
			            "AND (a.status_id != :cancelledStatusId)";
            
            Query query = session.createNativeQuery(countQuery)
                    .setParameter("scheduleId", scheduleId)
                    .setParameter("appointmentDate", java.sql.Date.valueOf(appointmentDate));
            
            if (cancelledStatusId != null) {
                query.setParameter("cancelledStatusId", cancelledStatusId);
            }
            
            Number result = (Number) query.uniqueResult();
            System.out.println("result "+result);
            count = (result != null) ? result.intValue() : 0;
            
        } catch (Exception e) {
            System.out.println("Error counting active appointments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return count;
    }
    
    /**
     * Get Admin's patient analytics
     * @return
     */
    public List<Map<String, Object>> getPatientAnalytics() {
//        Session session = sessionFactory.getCurrentSession();
        
        ProcedureCall call = session.createStoredProcedureCall("dashboard_analytics.get_patient_analytics");
        
        // Register the OUT parameters
        call.registerParameter("p_active_count", Integer.class, ParameterMode.OUT);
        call.registerParameter("p_inactive_count", Integer.class, ParameterMode.OUT);
        call.registerParameter("p_new_this_week", Integer.class, ParameterMode.OUT);
        call.registerParameter("p_total_count", Integer.class, ParameterMode.OUT);
        
        // Execute the procedure
        call.execute();
        
        // Extract the results into a Map
        Map<String, Object> analyticsMap = new HashMap<>();
        analyticsMap.put("activeCount", ((Number) call.getOutputParameterValue("p_active_count")).intValue());
        analyticsMap.put("inactiveCount", ((Number) call.getOutputParameterValue("p_inactive_count")).intValue());
        analyticsMap.put("newThisWeek", ((Number) call.getOutputParameterValue("p_new_this_week")).intValue());
        analyticsMap.put("totalCount", ((Number) call.getOutputParameterValue("p_total_count")).intValue());
        
        // Add to list
        List<Map<String, Object>> result = new ArrayList<>();
        result.add(analyticsMap);
        result.forEach(System.out::println);
        return result;
    }
    
    /**
     * Get doctor's patient analytics
     * @param doctorId The ID of the doctor
     * @return List containing a map with the patient analytics data
     */
    public List<Map<String, Object>> getDoctorPatientAnalytics(int doctorId) {
        ProcedureCall call = session.createStoredProcedureCall("doctor_dashboard_analytics.get_doctor_patient_analytics");

        // Register IN parameter
        call.registerParameter("p_doctor_id", Integer.class, ParameterMode.IN);
        call.setParameter("p_doctor_id", doctorId);

        // Register OUT parameters
        call.registerParameter("p_total_patients", Integer.class, ParameterMode.OUT);
        call.registerParameter("p_new_patients_this_month", Integer.class, ParameterMode.OUT);
        call.registerParameter("p_today_patients", Integer.class, ParameterMode.OUT);

        // Execute the procedure
        call.execute();

        // Extract the results into a Map
        Map<String, Object> analyticsMap = new HashMap<>();
        analyticsMap.put("totalPatients", ((Number) call.getOutputParameterValue("p_total_patients")).intValue());
        analyticsMap.put("newPatientsThisMonth", ((Number) call.getOutputParameterValue("p_new_patients_this_month")).intValue());
        analyticsMap.put("todayPatients", ((Number) call.getOutputParameterValue("p_today_patients")).intValue());

        // Add to list
        List<Map<String, Object>> result = new ArrayList<>();
        result.add(analyticsMap);
        result.forEach(System.out::println);
        return result;
    }
}
