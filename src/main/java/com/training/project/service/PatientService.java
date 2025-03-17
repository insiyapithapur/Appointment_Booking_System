package com.training.project.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
	private ScheduleDaoImp scheduleDao;
	
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
	public List<String> getUpcomingAppointmentsForPatient(int patientId, LocalDate fromDate) {
	    List<String> appointmentDetails = new ArrayList<>();
	    Session session = sessionFactory.openSession();

	    try {
	        appointmentDao = new AppointmentDaoImp(session);
	        List<Object> results = appointmentDao.findUpcomingAppointmentsForPatient(patientId, fromDate);
	        System.out.println("results results" + results);
	        
	        // Format the results into readable strings
	        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");

	        for (Object result : results) {
	            // Each result is now an ArrayList
	            List<?> row = (List<?>) result;
	            
	            String doctorName = (String) row.get(0);
	            int appointmentId = (Integer) row.get(1);
	            LocalDate appointmentDate = (LocalDate) row.get(2);
	            Integer tokenNo = (Integer) row.get(3);
	            String reason = (String) row.get(4);
	            String status = (String) row.get(5);

	            String formattedDate = appointmentDate != null ? appointmentDate.format(dateFormatter) : "N/A";

	            String appointmentInfo = String.format(
	                "Doctor: %s | Appointment ID: %d | Date: %s | Token: %s | Reason: %s | Status: %s",
	                doctorName,
	                appointmentId,
	                formattedDate,
	                tokenNo,
	                reason,
	                status
	            );

	            appointmentDetails.add(appointmentInfo);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }

	    System.out.println("Appointment details: " + appointmentDetails);
	    return appointmentDetails;
	}
	
	/*
	 * View All Appointments for patient
	 * pending, cancelled and completed
	 */
	public List<String> getPatientAppointmentHistory(int patientId) {
		System.out.println("patientId "+patientId);
	    List<String> appointmentHistory = new ArrayList<>();
	    Session session = sessionFactory.openSession();
	    
	    try {
	        appointmentDao = new AppointmentDaoImp(session);
	        List<Object[]> results = appointmentDao.findAppointmentsByPatientId(patientId);
	        System.out.println("results "+results);
	        
	        // Format the results into readable strings
	        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
	        
	        for (Object[] row : results) {
	            Integer appointmentId = (Integer) row[0];
	            String firstName = (String) row[1];
	            String lastName = (String) row[2];
	            LocalDate appointmentDate = (LocalDate) row[3];
	            Integer tokenNo = (Integer) row[4];
	            String reason = (String) row[5];
	            String status = (String) row[6];
	            String notes = (String) row[7];
	            String diagnosis = (String) row[8];
	            String treatment = (String) row[9];
	            
	            String doctorName = "Dr. " + firstName + " " + lastName;
	            String formattedDate = appointmentDate != null ? appointmentDate.format(dateFormatter) : "N/A";
	            
	            // Build main appointment info
	            StringBuilder appointmentInfo = new StringBuilder();
	            appointmentInfo.append(String.format(
	                "ID: %d | Doctor: %s | Date: %s | Token: %d | Reason: %s | Status: %s",
	                appointmentId,
	                doctorName,
	                formattedDate,
	                tokenNo,
	                reason,
	                status
	            ));
	            
	            // Add medical record info if available
	            if (diagnosis != null || notes != null || treatment != null) {
	                appointmentInfo.append(" | Medical Record: ");
	                
	                if (diagnosis != null && !diagnosis.isEmpty()) {
	                    appointmentInfo.append("Diagnosis: ").append(diagnosis);
	                }
	                
	                if (treatment != null && !treatment.isEmpty()) {
	                    if (diagnosis != null && !diagnosis.isEmpty()) {
	                        appointmentInfo.append(", ");
	                    }
	                    appointmentInfo.append("Treatment: ").append(treatment);
	                }
	                
	                if (notes != null && !notes.isEmpty()) {
	                    if ((diagnosis != null && !diagnosis.isEmpty()) || 
	                        (treatment != null && !treatment.isEmpty())) {
	                        appointmentInfo.append(", ");
	                    }
	                    appointmentInfo.append("Notes: ").append(notes);
	                }
	            }
	            
	            appointmentHistory.add(appointmentInfo.toString());
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }
	    
	    System.out.println("Appointment history: " + appointmentHistory);
	    return appointmentHistory;
	}
	
	/*
	 * Book Appointment ( patients )
	 */
	public boolean bookAppointment(int patientId, int scheduleId, LocalDate appointmentDate, String reason) {
		Session session = sessionFactory.openSession();
		Transaction tx = null;
		System.out.println("patientId "+patientId+" scheduleId "+scheduleId+" appointmentDate "+appointmentDate+" reason"+reason);
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
	public boolean updateAppointmentStatus(int appointmentId, int newStatusId) {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    doctorDao = new DoctorDaoImp(session);
	    patientDao = new PatientDaoImp(session);
	    appointmentDao = new AppointmentDaoImp(session);

	    try {
	        Appointment appointment = appointmentDao.findById(appointmentId);
	        if (appointment == null) {
	            throw new IllegalArgumentException("Appointment not found with ID: " + appointmentId);
	        }
	        int currentStatusId = appointment.getStatus().getStatusId();
	        
	        if (currentStatusId != 1) {
	            throw new IllegalArgumentException("Cannot update appointment: current status is not Pending");
	        }
	        
	        boolean isUpdated = appointmentDao.updateAppointmentStatus(appointmentId, newStatusId);

	        return isUpdated;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        session.close();
	    }
	}
	
	/**
     * Get doctor details
     */
	public List<String> getDoctorDetails() {
	    List<String> doctorDetailsList = new ArrayList<>();
	    Session session = sessionFactory.openSession();

	    try {
	        doctorDao = new DoctorDaoImp(session);
	        List<Object[]> results = doctorDao.getDoctorDetails();

	        for (Object[] row : results) {
	            Integer doctorId = (Integer) row[0];
	            String specialization = (String) row[1];
	            String licenseNumber = (String) row[2];
	            Float experience = (Float) row[3];
	            String degree = (String) row[4];
	            String firstName = (String) row[5];
	            String lastName = (String) row[6];
	            String email = (String) row[8];
	            String phoneNumber = (String) row[10];
	            Boolean isActive = (Boolean) row[11];
	            
	            String doctorInfo = String.format(
	            		"ID: %d | Dr. %s %s | %s | Exp: %.1f years | %s | Contact: %s | Email: %s | License: %s | isActive %s",
	                doctorId,
	                firstName,
	                lastName,
	                specialization,
	                experience,
	                degree,
	                phoneNumber,
	                email,
	                licenseNumber,
	                isActive
	            );

	            doctorDetailsList.add(doctorInfo);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }

	    return doctorDetailsList;
	}
	
	/*
	 * Get All Schedule of Doctor with its details
	 */
	public List<String> getScheduleDetailsByDoctorId(int doctorId) {
		System.out.println("doctorId "+doctorId);
	    Session session = sessionFactory.openSession();
	    List<String> scheduleDetailsList = new ArrayList<>();

	    try {
	        // Get doctor details first
	        doctorDao = new DoctorDaoImp(session);
	        List<Object[]> doctorDetails = doctorDao.findDoctorDetailsById(doctorId);
	        
	        // If doctor exists, add doctor info at the beginning of the list
	        if (doctorDetails != null && !doctorDetails.isEmpty()) {
	            Object[] doctor = doctorDetails.get(0);
	            
	            // Extract doctor data
	            String firstName = (String) doctor[6];
	            String lastName = (String) doctor[7];
	            String specialization = (String) doctor[1];
	            Float experience = (Float) doctor[3];
	            String degree = (String) doctor[4];
	            String phoneNumber = (String) doctor[9];
	            String email = (String) doctor[10];
	            
	            // Format doctor info
	            String doctorInfo = String.format(
	                "Doctor: Dr. %s %s | Specialization: %s | Experience: %.1f years | Degree: %s | Contact: %s | Email: %s",
	                firstName,
	                lastName,
	                specialization,
	                experience,
	                degree,
	                phoneNumber,
	                email
	            );
	            
	            // Add to list
	            scheduleDetailsList.add(doctorInfo);
	        }
	        
	        // Now get schedule details
	        scheduleDao = new ScheduleDaoImp(session);
	        List<Object[]> results = scheduleDao.findSchedulesByDoctorId(doctorId);
	        System.out.println("results in service "+results);
	        for (Object[] row : results) {
	            Integer scheduleId = (Integer) row[0];
	            Integer docId = (Integer) row[1];
	            Integer dayOfWeek = (Integer) row[2];
	            LocalDateTime startTime = (LocalDateTime) row[3];
	            LocalDateTime endTime = (LocalDateTime) row[4];
	            Integer maxTokens = (Integer) row[5];
	            Boolean isAvailable = (Boolean) row[6];

	            String dayName = getDayName(dayOfWeek);
	            String timeRange = formatTimeRange(startTime, endTime);

	            String scheduleInfo = String.format(
	                "Schedule ID: %d | Doctor ID: %d | Day: %s | Time: %s | Max Tokens: %d | Available: %s",
	                scheduleId,
	                docId,
	                dayName,
	                timeRange,
	                maxTokens,
	                isAvailable ? "Yes" : "No"
	            );

	            scheduleDetailsList.add(scheduleInfo);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        session.close();
	    }

	    return scheduleDetailsList;
	}

	// Helper method to convert day number to name
	private String getDayName(Integer dayOfWeek) {
	    switch (dayOfWeek) {
	        case 1: return "Sunday";
	        case 2: return "Monday";
	        case 3: return "Tuesday";
	        case 4: return "Wednesday";
	        case 5: return "Thursday";
	        case 6: return "Friday";
	        case 7: return "Saturday";
	        default: return "Unknown";
	    }
	}
	
	public MedicalRecord getMedicalRecordByAppointmentId(Integer appointmentId) {
        Session session = sessionFactory.openSession();
        appointmentDao = new AppointmentDaoImp(session);
        
        try {
            return appointmentDao.findByAppointmentId(appointmentId);
        } finally {
            session.close();
        }
    }

	// Helper method to format the time range
	private String formatTimeRange(LocalDateTime startTime, LocalDateTime endTime) {
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("h:mm a");
	    return startTime.format(formatter) + " - " + endTime.format(formatter);
	}
}
