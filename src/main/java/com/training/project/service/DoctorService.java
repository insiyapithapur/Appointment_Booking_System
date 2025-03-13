package com.training.project.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import com.training.project.dao.Imp.AppointmentDaoImp;
import com.training.project.dao.Imp.DoctorDaoImp;
import com.training.project.dao.Imp.PatientDaoImp;
import com.training.project.dao.Imp.ScheduleDaoImp;
import com.training.project.dao.Imp.UserDaoImp;
import com.training.project.model.Appointment;
import com.training.project.model.Doctor;
import com.training.project.model.Patient;
import com.training.project.model.Schedule;
import com.training.project.model.User;
import com.training.project.util.HibernateUtil;

public class DoctorService {
	private SessionFactory sessionFactory;
	private UserDaoImp userDao;
    private DoctorDaoImp doctorDao;
    private PatientDaoImp patientDao;
    private ScheduleDaoImp scheduleDao;
	private AppointmentDaoImp appointmentDao;
	
	public DoctorService() {
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
	public DoctorService(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
	}

	/*
	 * Get all appointments of patient for present day
	 */
	public List<Appointment> getUpcomingAppointmentsForDoctor(int userId, LocalDate fromDate) {
	    Session session = sessionFactory.openSession();
	    appointmentDao = new AppointmentDaoImp(session);
	    
	    try {
	        return appointmentDao.findUpcomingAppointmentsForUser(userId, fromDate);
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get ALl Handled Patient by doctor
	 */
	public List<String> getAllPatients(int userId) {
	    List<String> patientDetails = new ArrayList<>();
	    Session session = sessionFactory.openSession();
	    
	    try {
	        // Fetch the user role first
	        Query<Integer> roleQuery = session.createQuery(
	            "SELECT u.role.id FROM User u WHERE u.id = :userId", Integer.class);
	        roleQuery.setParameter("userId", userId);
	        Integer roleId = roleQuery.uniqueResult();

	        if (roleId == null) {
	            System.out.println("User not found.");
	            return patientDetails;
	        }

	        Query<Object[]> query;

	        if (roleId == 1) { // Admin: Fetch all patients
	            query = session.createQuery(
	                "SELECT DISTINCT ud.firstName, ud.lastName, ud.phoneNumber " +
	                "FROM UserDetail ud " +
	                "JOIN ud.user u " +
	                "JOIN Patient p ON p.user.id = u.id",
	                Object[].class
	            );
	        } else if (roleId == 3) { // Doctor: Fetch only patients who visited this doctor
	            query = session.createQuery(
	                "SELECT DISTINCT ud.firstName, ud.lastName, ud.phoneNumber " +
	                "FROM UserDetail ud " +
	                "JOIN ud.user u " +
	                "JOIN Patient p ON p.user.id = u.id " +
	                "JOIN Appointment a ON a.patient.id = p.id " + // FIXED JOIN
	                "JOIN a.schedule s " +
	                "JOIN s.doctor d " +
	                "WHERE d.user.id = :userId",
	                Object[].class
	            );
	            query.setParameter("userId", userId);
	        } else {
	            System.out.println("Access Denied! Only Admins or Doctors can view patients.");
	            return patientDetails;
	        }

	        List<Object[]> results = query.getResultList();

	        if (results.isEmpty()) {
	            System.out.println("No patients found for this doctor.");
	            return patientDetails;
	        }

	        for (Object[] row : results) {
	            String patientInfo = row[0] + " " + row[1] + " - " + row[2];
	            patientDetails.add(patientInfo);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }

	    return patientDetails;
	}
	
	/*
	 * Get All Appointments for a user, regardless of whether they are a doctor or patient
	 * integrate medical records are left
	 */
	public List<Appointment> getAppointmentsForUser(int userId) {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    doctorDao = new DoctorDaoImp(session);
	    patientDao = new PatientDaoImp(session);
	    scheduleDao = new ScheduleDaoImp(session);
	    appointmentDao = new AppointmentDaoImp(session);
	    
	    try {
	        // Step 1: Validate if the user exists
	        User user = userDao.findById(userId);
	        if (user == null) {
	            throw new IllegalArgumentException("User does not exist");
	        }
	        
	        String roleName = user.getRole().getRoleName();
	        
	        // Check role and get appointments accordingly
	        if (roleName.equalsIgnoreCase("Doctor")) {
	            // Get doctor's appointments
	            Doctor doctor = doctorDao.findByUserId(userId);
	            if (doctor == null) {
	                throw new IllegalArgumentException("Doctor not found for the userId: " + userId);
	            }
	            
	            // Fetch schedules for the doctor
	            List<Schedule> schedules = scheduleDao.findByDoctorId(doctor.getDoctorId());
	            
	            if (schedules.isEmpty()) {
	                return new ArrayList<>(); // Return empty list instead of throwing exception
	            }
	            
	            // Fetch appointments for the schedules
	            return appointmentDao.findByScheduleIds(
	                schedules.stream().map(Schedule::getScheduleId).toList()
	            );
	        } 
	        else if (roleName.equalsIgnoreCase("Patient")) {
	            // Get patient's appointments
	            Patient patient = patientDao.findByUserId(userId);
	            if (patient == null) {
	                throw new IllegalArgumentException("Patient not found for the userId: " + userId);
	            }
	            
	            // Fetch appointments for the patient
	            return appointmentDao.findByPatientId(patient.getPatientId());
	        }
	        else {
	            throw new IllegalArgumentException("User role " + roleName + " is not supported for appointment retrieval");
	        }
	    } finally {
	        session.close();
	    }
	}

}
