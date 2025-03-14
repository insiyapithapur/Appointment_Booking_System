package com.training.project.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import org.hibernate.*;
import org.hibernate.query.Query;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.util.HibernateUtil;

public class PatientService {
	private SessionFactory sessionFactory;
	private PatientDaoImp patientDao;
	private UserDetailDaoImp userDetailDao;
	private AppointmentDaoImp appointmentDao;
	private DoctorDaoImp doctorDao;
	private UserDaoImp userDao;
	
	public PatientService() {
	    try {
	        this.sessionFactory = HibernateUtil.getSessionFactory();
	        if (this.sessionFactory == null) {
	            System.err.println("Failed to initialize SessionFactory in DoctorService constructor");
	        }
	    } catch (Exception e) {
	        System.err.println("Error initializing SessionFactory: " + e.getMessage());
	        e.printStackTrace();
	    }
	}

	public PatientService(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}
	
	/*
	 * Fill UserDetails and Patient Details
	 */
//	public boolean createDoctorDetails(UserDetail userDetail, Patient patient) {
	public boolean createPatientDetails() {
		Session session = sessionFactory.openSession();
		patientDao = new PatientDaoImp(session);
		userDetailDao = new UserDetailDaoImp(session);
		
		UserDaoImp userDao = new UserDaoImp(session);
    	User user = userDao.findById(5);
    	
    	LocalDate dateOfBirth = LocalDate.of(2003, 4, 8);
    	UserDetail userDetail = new UserDetail("Insiya","Patient",dateOfBirth,"F","9016222140","banupithapur@gmail.com",user);
		
    	Patient patient = new Patient("A+",user);
    	
		if (userDetail.getUser() == null || patient.getUser() == null || 
		        !userDetail.getUser().getUserId().equals(patient.getUser().getUserId())) {
		        return false;
		    }
		try {
	        // Check if userDetail already exists for this user
	        UserDetail existingUserDetail = userDetailDao.findById(userDetail.getUser().getUserId());
	        if (existingUserDetail != null) {
	            return true;
	        } else {
	            // Create new userDetail
	            boolean userDetailCreated = userDetailDao.create(userDetail);
	            if (!userDetailCreated) {
	                return false;
	            }
	        }
	        
	        // Check if Patient details already exist for this user
	        Patient existingPatient = patientDao.findById(patient.getUser().getUserId());
	        if (existingPatient != null) {
	            return true;
	        } else {
	            // Create new Patient
	            boolean patientCreated = patientDao.create(patient);
	            if (!patientCreated) {
	                return false;
	            }
	        }
	        
	        return true;
	    } catch (Exception e) {
	        System.out.println("Error creating patient details: " + e.getMessage());
	        e.printStackTrace();
	        return false;
	    }finally {
	    	session.close();
	    }
	}
	
	/*
	 * Get all appointments of patient from present day
	 */
	public List<String> getUpcomingAppointmentsForPatient(int userId, LocalDate fromDate) {
	    Session session = sessionFactory.openSession();
	    appointmentDao = new AppointmentDaoImp(session);
	    try {
	        return appointmentDao.findUpcomingAppointmentsForUser(userId, fromDate);
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * View All Appointments for patient
	 * pending, cancelled and completed
	 */
	public List<Appointment> viewPastAppointments(int patientId) {
		Session session = sessionFactory.openSession();
        try {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment WHERE patient.id = :patientId AND appointmentDate <= :today", Appointment.class);
            query.setParameter("patientId", patientId);
            query.setParameter("today", LocalDate.now());
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
	
	/*
	 * Book Appointment ( patients )
	 */
	public boolean bookAppointment(int patientId, int scheduleId, LocalDate appointmentDate, String reason) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
        try{
            tx = session.beginTransaction();
            
            Patient patient = session.get(Patient.class, patientId);
            Schedule schedule = session.get(Schedule.class, scheduleId);
            AppointmentsStatus status = session.get(AppointmentsStatus.class, 1); // "Pending"

            if (patient == null || schedule == null) {
                return false;
            }

            Appointment appointment = new Appointment();
            appointment.setPatient(patient);
            appointment.setSchedule(schedule);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setAptTime(LocalDateTime.now());
            appointment.setTokenNo(1);
            appointment.setReason(reason);
            appointment.setStatus(status);

            session.save(appointment);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }
	
	/*
	 * Appointment Status pending --> cancel
	 */
	/*
	 * Update Appointment Status for both doctors and patients 
	 * - Doctors can change Pending -> Completed
	 * - Patients can change Pending -> Cancelled
	 *  newStatusId The new status ID (1=Pending, 2=Completed, 3=Cancelled)
	 */
	public boolean updateAppointmentStatus(int userId, int appointmentId, int newStatusId) {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    doctorDao = new DoctorDaoImp(session);
	    patientDao = new PatientDaoImp(session);
	    appointmentDao = new AppointmentDaoImp(session);

	    try {
	        // Step 1: Validate if the user exists
	        User user = userDao.findById(userId);
	        if (user == null) {
	            throw new IllegalArgumentException("User does not exist");
	        }

	        // Step 2: Get user role
	        String roleName = user.getRole().getRoleName();
	        
	        // Step 3: Fetch the appointment
	        Appointment appointment = appointmentDao.findById(appointmentId);
	        if (appointment == null) {
	            throw new IllegalArgumentException("Appointment not found with ID: " + appointmentId);
	        }
	        
	        // Step 4: Validate current appointment status
	        int currentStatusId = appointment.getStatus().getStatusId();
	        
	        // Only allow updates if appointment is in Pending status (statusId = 1)
	        if (currentStatusId != 1) {
	            throw new IllegalArgumentException("Cannot update appointment: current status is not Pending");
	        }

	        // Step 5: Check role-specific permissions and validate ownership
	        if (roleName.equalsIgnoreCase("Doctor")) {
	            // For doctors
	            
	            // Check if the doctor exists
	            Doctor doctor = doctorDao.findByUserId(userId);
	            if (doctor == null) {
	                throw new IllegalArgumentException("Doctor not found for userId: " + userId);
	            }
	            
	            // Validate if the appointment belongs to the doctor
	            if (!appointment.getSchedule().getDoctor().getDoctorId().equals(doctor.getDoctorId())) {
	                throw new IllegalArgumentException("Doctor does not own this appointment");
	            }
	            
	            // Verify allowed status changes for doctors (Pending -> Completed)
	            if (newStatusId != 2) {
	                throw new IllegalArgumentException("Doctors can only mark appointments as Completed");
	            }
	            
	        } else if (roleName.equalsIgnoreCase("Patient")) {
	            // For patients
	            
	            // Check if the patient exists
	            Patient patient = patientDao.findByUserId(userId);
	            if (patient == null) {
	                throw new IllegalArgumentException("Patient not found for userId: " + userId);
	            }
	            
	            // Validate if the appointment belongs to the patient
	            if (!appointment.getPatient().getPatientId().equals(patient.getPatientId())) {
	                throw new IllegalArgumentException("Patient does not own this appointment");
	            }
	            
	            // Verify allowed status changes for patients (Pending -> Cancelled)
	            if (newStatusId != 3) {
	                throw new IllegalArgumentException("Patients can only cancel appointments");
	            }
	            
	        } else {
	            throw new IllegalArgumentException("User role is not authorized to update appointment status");
	        }

	        // Step 6: Update appointment status
	        boolean isUpdated = appointmentDao.updateAppointmentStatus(appointmentId, newStatusId);

	        return isUpdated;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        session.close();
	    }
	}
}
