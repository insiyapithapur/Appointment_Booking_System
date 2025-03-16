package com.training.project.dao.Imp;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.Appointment;
import com.training.project.model.AppointmentsStatus;
import com.training.project.model.MedicalRecord;

public class AppointmentDaoImp implements GenericDao<Appointment, Integer> {
	private Session session;
	
	public AppointmentDaoImp(){
		super();
	}

	public AppointmentDaoImp(Session session) {
		super();
		this.session = session;
	}
	
	@Override
	public Appointment findById(Integer id) {
		Appointment appointment = session.get(Appointment.class, id);
	    System.out.println("Doctor id: " + appointment);
		return appointment;
	}

	@Override
	public List<Appointment> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Appointment entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean update(Appointment entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Appointment entity) {
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
		// TODO Auto-generated method stub
		return false;
	}
	
	public List<Appointment> findByScheduleIds(List<Integer> scheduleIds) {
        Query<Appointment> query = session.createQuery(
            "FROM Appointment WHERE schedule.id IN (:scheduleIds)", Appointment.class);
        query.setParameter("scheduleIds", scheduleIds);
        return query.list();
    }
	
	public List<Appointment> findByPatientId(Integer patientId) {
	    List<Appointment> appointments = new ArrayList<>();
	    Transaction tx = null;    
	    try {
	        tx = session.beginTransaction();
	        
	        String hql = "FROM Appointment a WHERE a.patient.patientId = :patientId";
	        appointments = session.createQuery(hql, Appointment.class)
	                            .setParameter("patientId", patientId)
	                            .list();
	        
	        tx.commit();
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	    }
	    
	    return appointments;
	}
	
	public boolean updateAppointmentStatus(int appointmentId, Integer newStatusId) {
	    Transaction tx = null;
	    try {
	        tx = session.beginTransaction();
	        
	        // Fetch the appointment by ID
	        Appointment appointment = session.get(Appointment.class, appointmentId);
	        if (appointment == null) {
	            throw new IllegalArgumentException("Appointment not found with ID: " + appointmentId);
	        }

	        // Fetch the new status from the AppointmentStatus table
	        AppointmentsStatus newStatus = session.get(AppointmentsStatus.class, newStatusId);
	        
	        if (newStatus == null) {
	            throw new IllegalArgumentException("Invalid status ID: " + newStatusId);
	        }

	        // Update appointment status
	        appointment.setStatus(newStatus);
	        session.update(appointment);
	        
	        tx.commit();
	        return true;
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public List<Appointment> getAllAppointments() {
        Transaction transaction = null;
        List<Appointment> appointments = null;
        try{
            transaction = session.beginTransaction();
            
            // Fetching required fields using HQL
            appointments = session.createQuery(
                "SELECT a FROM Appointment a " +
                "JOIN FETCH a.patient p " +
                "JOIN FETCH a.schedule s " +
                "JOIN FETCH a.status",
                Appointment.class
            ).getResultList();

            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return appointments;
    }
	
	/*public List<Appointment> findUpcomingAppointmentsForUser(int dooctorId, LocalDate fromDate) {
	    try {
	        // Fetch role of the user
	        String roleQuery = "SELECT u.role.roleName FROM User u WHERE u.userId = :userId";
	        Query<String> queryRole = session.createQuery(roleQuery, String.class);
	        queryRole.setParameter("userId", userId);
	        String roleName = queryRole.uniqueResult();

	        if (roleName == null) {
	            throw new IllegalArgumentException("User not found with userId: " + userId);
	        }

	        String hql;
	        if (roleName.equalsIgnoreCase("Patient")) {
	            // Query for patient: Fetch all upcoming appointments
	            hql = "FROM Appointment a WHERE a.patient.user.userId = :userId "
	                + "AND a.appointmentDate >= :fromDate ORDER BY a.appointmentDate ASC";
	        } else if (roleName.equalsIgnoreCase("Doctor")) {
	            // Query for doctor: Fetch appointments only for the specific date
	            hql = "SELECT a FROM Appointment a JOIN a.schedule s "
	                + "WHERE s.doctor.user.userId = :userId "
	                + "AND a.appointmentDate >= :fromDate ORDER BY a.appointmentDate ASC";
	        } else {
	            throw new IllegalArgumentException("User role " + roleName + " is not supported for appointment retrieval");
	        }

	        Query<Appointment> query = session.createQuery(hql, Appointment.class);
	        query.setParameter("userId", userId);
	        query.setParameter("fromDate", fromDate);

	        return query.list();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return List.of();
	    }
	}*/
	
	public List<String> findUpcomingAppointmentsForUser(int doctorId, LocalDate fromDate) {
	    List<String> appointmentDetails = new ArrayList<>();
	    try {
	        // First check if the user is a doctor
	        Query<String> roleQuery = session.createQuery(
	                "SELECT u.role.roleName FROM User u " +
	                "JOIN Doctor d ON d.user.id = u.id " +
	                "WHERE d.doctorId = :doctorId", String.class);
	        roleQuery.setParameter("doctorId", doctorId);
	        String role = roleQuery.uniqueResult();
	        
	        if (role == null || !role.equals("Doctor")) {
	            return appointmentDetails; // Return empty list if not a doctor
	        }
	        
	        // HQL query to get upcoming appointments for the doctor with required details
	        // Added appointment ID as the first column in the result
	        Query<Object[]> query = session.createQuery(
	                "SELECT a.appointmentId, " + // Added appointment ID
	                "CONCAT(ud.firstName, ' ', ud.lastName), " + // Patient Name
	                "a.appointmentDate, " + // Appointment Date
	                "a.tokenNo, " + // Token Number
	                "a.reason, " + // Reason
	                "aps.statusName, " + // Status
	                "ud.phoneNumber " + // Contact No
	                "FROM Appointment a " +
	                "JOIN a.schedule s " +
	                "JOIN s.doctor d " +
	                "JOIN a.patient p " +
	                "JOIN p.user pu " +
	                "JOIN UserDetail ud ON ud.user.id = pu.id " + // Changed this join
	                "JOIN a.status aps " +
	                "WHERE d.doctorId = :doctorId " +
	                "AND a.appointmentDate >= :fromDate " +
	                "ORDER BY a.appointmentDate ASC, a.tokenNo ASC",
	                Object[].class);
	        
	        query.setParameter("doctorId", doctorId);
	        query.setParameter("fromDate", fromDate);
	        
	        List<Object[]> results = query.getResultList();
	        System.out.println("results " + results);
	        
	        // Format the results
	        for (Object[] row : results) {
	            Integer appointmentId = (Integer) row[0]; // Get appointment ID
	            String patientName = (String) row[1];
	            LocalDate appointmentDate = (LocalDate) row[2];
	            Integer tokenNo = (Integer) row[3];
	            String reason = (String) row[4];
	            String status = (String) row[5];
	            String contactNo = (String) row[6];
	            
	            String formattedAppointment = String.format(
	                    "ID: %d | Patient: %s | Date: %s | Token: %d | Reason: %s | Status: %s | Contact: %s",
	                    appointmentId,
	                    patientName,
	                    appointmentDate,
	                    tokenNo,
	                    reason != null ? reason : "N/A",
	                    status,
	                    contactNo
	            );
	            
	            appointmentDetails.add(formattedAppointment);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }
	    
	    System.out.println("appointmentDetails " + appointmentDetails);
	    return appointmentDetails;
	}
	
	public List<Object[]> findUpcomingAppointmentsForPatient(int patientId, LocalDate fromDate) {
	    String hql = "SELECT new list(d.user.name as doctorName, " +
	                 "a.appointmentDate, " +
	                 "a.tokenNo, " +
	                 "a.reason, " +
	                 "st.statusName) " +  // Using st for status
	                 "FROM Appointment a " +
	                 "JOIN a.patient p " +
	                 "JOIN a.schedule s " +
	                 "JOIN s.doctor d " +
	                 "JOIN d.user u " +
	                 "JOIN a.status st " +  // Using st for status
	                 "WHERE p.id = :patientId " +
	                 "AND a.appointmentDate >= :fromDate " +
	                 "ORDER BY a.appointmentDate ASC";
	    
	    Query query = session.createQuery(hql);
	    query.setParameter("patientId", patientId);
	    query.setParameter("fromDate", fromDate);
	    
	    return query.list();
	}
	
    public List<Object[]> findPatientsByDoctorId(int doctorId) {
        // First check if the user is a doctor
        Query<String> roleQuery = session.createQuery(
            "SELECT u.role.roleName FROM User u " +
            "JOIN Doctor d ON d.user.id = u.id " +
            "WHERE d.doctorId = :doctorId", String.class);
        roleQuery.setParameter("doctorId", doctorId);
        String role = roleQuery.uniqueResult();
        
        if (role == null || !role.equals("Doctor")) {
            return new ArrayList<>(); // Return empty list if not a doctor
        }
        
        // HQL query to get all patients that the doctor has handled
        Query<Object[]> query = session.createQuery(
            "SELECT DISTINCT " + 
            "   CONCAT(ud.firstName, ' ', ud.lastName), " +  // Patient Name
            "   ud.phoneNumber, " +                          // Contact Number
            "   ud.email, " +                                // Email
            "   p.bloodGrp, " +                              // Blood Group
            "   ud.dateOfBirth " +                           // Date of Birth
            "FROM Appointment a " +
            "JOIN a.schedule s " +
            "JOIN s.doctor d " +
            "JOIN a.patient p " +
            "JOIN p.user pu " +
            "JOIN UserDetail ud ON ud.user.id = pu.id " +
            "WHERE d.doctorId = :doctorId ",
            Object[].class);
        
        query.setParameter("doctorId", doctorId);
        return query.getResultList();
    }
    
    public List<Object[]> findAppointmentsByDoctorId(int doctorId) {
        Query<Object[]> query = session.createQuery(
            "SELECT " + 
            "   a.appointmentId, " +                      // Appointment ID
            "   CONCAT(ud.firstName, ' ', ud.lastName), " + // Patient Name
            "   ud.phoneNumber, " +                       // Contact Number
            "   a.appointmentDate, " +                    // Appointment Date
            "   a.tokenNo, " +                            // Token Number
            "   a.reason, " +                             // Reason
            "   aps.statusName " +                        // Appointment Status
            "FROM Appointment a " +
            "JOIN a.schedule s " +
            "JOIN s.doctor d " +
            "JOIN a.patient p " +
            "JOIN p.user pu " +
            "JOIN UserDetail ud ON ud.user.id = pu.id " +
            "JOIN a.status aps " +
            "WHERE d.doctorId = :doctorId " +
            "ORDER BY a.appointmentDate DESC, a.tokenNo ASC",
            Object[].class);
        
        query.setParameter("doctorId", doctorId);
        return query.getResultList();
    }
    
    public List<Object[]> findAppointmentsByPatientId(int patientId) {
        System.out.println("patientId "+patientId);
        List<Object[]> appointments = null;
        try {
            String hql = "SELECT a.appointmentId, ud.firstName, ud.lastName, a.appointmentDate, a.tokenNo, a.reason, " +
                         "s.statusName, " +
                         "mr.notes, mr.diagnosis, mr.treatment " +
                         "FROM Appointment a " +
                         "JOIN a.patient p " +
                         "JOIN a.schedule sch " +
                         "JOIN sch.doctor d " +
                         "JOIN d.user u " +
                         "JOIN UserDetail ud ON u.userId = ud.user.userId " +
                         "JOIN a.status s " +
                         "LEFT JOIN MedicalRecord mr ON mr.appointment = a " +
                         "WHERE p.id = :patientId " +
                         "ORDER BY a.appointmentDate DESC";

            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setParameter("patientId", patientId);
            appointments = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }
    
    public boolean addMedicalRecord(Integer appointmentId, String diagnosis, String treatment, String notes) {
    	Transaction transaction = null;
    	try {
    		System.out.println("appointmentId +"+appointmentId);
        	transaction = session.beginTransaction();
            
            // Find the appointment
            Appointment appointment = session.get(Appointment.class, appointmentId);
            if (appointment == null) {
                throw new IllegalArgumentException("Appointment not found with ID: " + appointmentId);
            }
            
            // Create new medical record
            MedicalRecord medicalRecord = new MedicalRecord();
            medicalRecord.setAppointment(appointment);
            medicalRecord.setDiagnosis(diagnosis);
            medicalRecord.setTreatment(treatment);
            medicalRecord.setNotes(notes);
            
            // Save the medical record
            session.save(medicalRecord);
            
            updateAppointmentStatus(appointmentId,2);
            
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
    
    public MedicalRecord findByAppointmentId(Integer appointmentId) {
        System.out.println("appointmentId DAO " + appointmentId);
        Transaction tx = null;
        try {
            // Start a new transaction
            tx = session.beginTransaction();
            
            // Try with native SQL
            NativeQuery<MedicalRecord> query = session.createNativeQuery(
                "SELECT * FROM medical_records WHERE appointment_id = :appId", 
                MedicalRecord.class);
            query.setParameter("appId", appointmentId);
            
            MedicalRecord result = query.uniqueResult();
            
            // Commit the transaction
            tx.commit();
            System.out.println("medical "+result);
            return result;
        } catch (Exception e) {
            // Rollback on error
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }
    }
}
