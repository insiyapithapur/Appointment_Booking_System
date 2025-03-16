package com.training.project.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
	public List<String> getUpcomingAppointmentsForDoctor(int doctorId, LocalDate fromDate) {
	    Session session = sessionFactory.openSession();
	    appointmentDao = new AppointmentDaoImp(session);
	    
	    try {
	        return appointmentDao.findUpcomingAppointmentsForUser(doctorId, fromDate);
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get ALl Handled Patient by doctor
	 */
	 public List<String> getAllPatients(int doctorId) {
	        List<String> patientDetails = new ArrayList<>();
	        Session session = sessionFactory.openSession();
	        
	        try {
	        	appointmentDao = new AppointmentDaoImp(session);
	            List<Object[]> results = appointmentDao.findPatientsByDoctorId(doctorId);
	            
	            // Format the results into readable strings
	            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
	            
	            for (Object[] row : results) {
	                String patientName = (String) row[0];
	                String contactNumber = (String) row[1];
	                String email = (String) row[2];
	                String bloodGroup = (String) row[3];
	                LocalDate dob = (LocalDate) row[4];
	                
	                String formattedDob = dob != null ? dob.format(dateFormatter) : "N/A";
	                String bloodGroupValue = bloodGroup != null ? bloodGroup : "Unknown";
	                
	                String patientInfo = String.format(
	                    "Patient: %s | Contact: %s | Email: %s | Blood Group: %s | DOB: %s",
	                    patientName,
	                    contactNumber,
	                    email,
	                    bloodGroupValue,
	                    formattedDob
	                );
	                
	                patientDetails.add(patientInfo);
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            session.close();
	        }
	        System.out.println("patient details "+patientDetails);
	        return patientDetails;
	    }
	
	/*
	 * Get All Appointments for a user, regardless of whether they are a doctor or patient
	 * integrate medical records are left
	 */
	/*public List<Appointment> getAppointmentsForUser(int userId) {
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
	}*/
	 
	 
	 /*
	  * Get All Appointments for doctor
	  * integrate medical records are left
	*/
	 public List<String> getAppointmentsForDoctor(int doctorId) {
	        List<String> appointmentDetails = new ArrayList<>();
	        Session session = sessionFactory.openSession();
	        
	        try {
	            // First check if the user is a doctor
	        	doctorDao = new DoctorDaoImp(session);
	            User doctor = doctorDao.getUserByDoctorId(doctorId);
	            
	            if (doctor == null || !doctor.getRole().getRoleName().equals("Doctor")) {
	                return appointmentDetails; // Return empty list if not a doctor
	            }
	            
	            // Get appointments for the doctor
	            appointmentDao = new AppointmentDaoImp(session);
	            List<Object[]> results = appointmentDao.findAppointmentsByDoctorId(doctorId);
	            
	            // Format the results into readable strings
	            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
	            
	            for (Object[] row : results) {
	                try {
	                    Integer appointmentId = (Integer) row[0];
	                    String patientName = (String) row[1];
	                    String contactNumber = (String) row[2];
	                    LocalDate appointmentDate = (LocalDate) row[3];
	                    Integer tokenNo = (Integer) row[4];
	                    String reason = (String) row[5];
	                    String status = (String) row[6];
	                    
	                    String formattedDate = appointmentDate != null ? appointmentDate.format(dateFormatter) : "N/A";
	                    String reasonText = reason != null ? reason : "N/A";
	                    
	                    String appointmentInfo = String.format(
	                        "ID: %d | Patient: %s | Contact: %s | Date: %s | Token: %d | Reason: %s | Status: %s",
	                        appointmentId,
	                        patientName,
	                        contactNumber,
	                        formattedDate,
	                        tokenNo,
	                        reasonText,
	                        status
	                    );
	                    
	                    appointmentDetails.add(appointmentInfo);
	                } catch (Exception e) {
	                    System.err.println("Error processing appointment: " + e.getMessage());
	                }
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            session.close();
	        }
	        System.out.println("appointmentDetails"+appointmentDetails);
	        return appointmentDetails;
	    }
	 
	 /*
	  * update to completed ==2 and add medical records
	  */
	 public boolean addMedicalRecord(Integer appointmentId, String diagnosis, String treatment, String notes) {
		Session session = sessionFactory.openSession();
		appointmentDao = new AppointmentDaoImp(session);
		System.out.println("appointmentId "+appointmentId);
		try {
			boolean result = appointmentDao.addMedicalRecord(
			appointmentId, diagnosis, treatment, notes);
			System.out.println("result "+result);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			session.close();
		}
	 }
}
