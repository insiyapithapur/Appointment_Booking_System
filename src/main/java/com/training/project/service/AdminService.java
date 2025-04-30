package com.training.project.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.*;
import org.hibernate.query.Query;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.util.HibernateUtil;

public class AdminService {
	private SessionFactory sessionFactory;
	private PatientDaoImp patientDao;
	private DoctorDaoImp doctorDao;
	private ScheduleDaoImp scheduleDao;
	private UserDaoImp userDao;
	private UserDetailDaoImp userDetailDao;
	private AppointmentDaoImp appointmentDao;
	
	public AdminService() {
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
	
	public List<Patient> fetchAllPatients() {
		Session session = sessionFactory.openSession();
		patientDao = new PatientDaoImp(session);
        return patientDao.getAllPatients();
    }
    
    //patient with user detailes
    
    public List<Object[]> getPatientDetails() {
    	Session session = sessionFactory.openSession();
		patientDao = new PatientDaoImp(session);
        return patientDao.getPatientDetails();
    }
    
    
    public Object[] getPatientById(int patientId) {
    	Session session = sessionFactory.openSession();
		patientDao = new PatientDaoImp(session);
        return patientDao.getPatientById(patientId);
    }
    
    public List<Object[]> getDoctorDetails() {
    	Session session = sessionFactory.openSession();
    	doctorDao = new DoctorDaoImp(session);
		return doctorDao.getDoctorDetails();
	}

	public Doctor getDoctorById(Integer doctorId) {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
		return doctorDao.getDoctorById(doctorId);
	}

	public void updateDoctor(Doctor doctor) {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
		doctorDao.updateDoctor(doctor);
	}

	public void deleteDoctor(Integer doctorId) {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
		doctorDao.deleteDoctor(doctorId);
	}

	/*
	 * Registration of doctor by admin
	 */
//	public boolean createDoctorByAdmin(int adminId, User doctorUser) {
	public boolean createDoctorByAdmin(Integer adminId) {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    
	    RoleDaoImp roledao = new RoleDaoImp(session);
    	Role role = roledao.findById(3);
    	User doctorUser = new User("Insiya_Doc3","ROOT",true,role);
    	
	    try {
	    	System.out.println("Session in createDoctorByAdmin: 1 " + session);
	        // 1. Verify the admin ID is valid
	        User adminUser = userDao.findById(adminId);
	        System.out.println("Session in createDoctorByAdmin: 2 " + session);

	        if (adminUser == null) {
	            System.out.println("Admin user not found with ID: " + adminId);
	            return false;
	        }
	        
	        // 2. Verify the user has admin role
	        Role adminRole = adminUser.getRole();
	        if (adminRole == null || !isAdminRole(adminRole)) {
	            System.out.println("User with ID " + adminId + " does not have admin privileges");
	            return false;
	        }
	        
	        // 3. Check if the username already exists
	        User existingUser = userDao.checkUsername(doctorUser.getUsername());
	        if (existingUser != null) {
	            System.out.println("Username '" + doctorUser.getUsername() + "' already exists");
	            return false;
	        }
	        
	        // 5. Create the doctor user
	        boolean result = userDao.create(doctorUser);
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	    	System.out.println("Session in createDoctorByAdmin: closing " + session);
	        session.close();
	    }
	}
	
	/*
	 * Fill UserDetails and Doctor Details
	 */
//	public boolean createDoctorDetails(UserDetail userDetail, Doctor doctor) {
	public boolean createDoctorDetails() {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
		userDetailDao = new UserDetailDaoImp(session);
		
		UserDaoImp userDao = new UserDaoImp(session);
    	User user = userDao.findById(2);
    	
    	LocalDate dateOfBirth = LocalDate.of(2003, 4, 8);
    	UserDetail userDetail = new UserDetail("Insiya","Pithapur",dateOfBirth,"F","9016222140","banupithapur@gmail.com",user);
		
    	Doctor doctor = new Doctor("ENT","L123456",(float)1.5,"MBBS",true,user);
    	
		if (userDetail.getUser() == null || doctor.getUser() == null || 
		        !userDetail.getUser().getUserId().equals(doctor.getUser().getUserId())) {
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
	        
	        // Check if doctor details already exist for this user
	        Doctor existingDoctor = doctorDao.findById(doctor.getUser().getUserId());
	        if (existingDoctor != null) {
	            return true;
	        } else {
	            // Create new doctor
	            boolean doctorCreated = doctorDao.create(doctor);
	            if (!doctorCreated) {
	                return false;
	            }
	        }
	        
	        return true;
	    } catch (Exception e) {
	        System.out.println("Error creating doctor details: " + e.getMessage());
	        e.printStackTrace();
	        return false;
	    }finally {
	    	session.close();
	    }
	}
	
	/*
	 * Admin will create schedule
	 */
//	public boolean createSchedule(Integer adminId, Schedule schedule) {
	public boolean createSchedule(Integer adminId,Integer doctorId) {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    scheduleDao = new ScheduleDaoImp(session);
	    doctorDao = new DoctorDaoImp(session);
	    
	    Doctor insertDoctor = doctorDao.findById(doctorId);
	    System.out.println("insertDoctor "+insertDoctor);
	    LocalDateTime startDateTime = LocalDateTime.of(2023, 5, 16, 9, 0); // 2023-05-15 09:00:00
	    LocalDateTime endDateTime = LocalDateTime.of(2023, 5, 16, 12, 0);  // 2023-05-15 12:00:00
	    Schedule schedule = new Schedule(1,startDateTime, endDateTime, 30,true,insertDoctor);
	    System.out.println("scheduleeeee "+schedule);
	    User adminUser = userDao.findById(adminId);
	    
	    // 1. Verify the admin ID is valid
	    if (adminUser == null) {
	        System.out.println("Admin user not found with ID: " + adminId);
	        return false;
	    }
	    
	    // 2. Verify the user has admin role
	    Role adminRole = adminUser.getRole();
	    if (adminRole == null || !isAdminRole(adminRole)) {
	        System.out.println("User with ID " + adminId + " does not have admin privileges");
	        return false;
	    }
	    
	    // 3. Validate schedule data
	    if (schedule == null || schedule.getDoctor() == null) {
	        System.out.println("Invalid schedule data");
	        return false;
	    }
	    
	    // 4. Check if the doctor exists
	    Doctor doctor = schedule.getDoctor();
	    Doctor existingDoctor = doctorDao.findById(doctor.getDoctorId());
	    if (existingDoctor == null) {
	        System.out.println("Doctor not found with ID: " + doctor.getDoctorId());
	        return false;
	    }
	    
	    boolean isScheduleCreated = scheduleDao.create(schedule);
	    session.close();
	    return isScheduleCreated;
	}
	
	/*
	 * Get total count of patients
	 */
	public long getTotalPatientCount() {
	    Session session = sessionFactory.openSession();
	    patientDao = new PatientDaoImp(session);
	    try {
	        Query<Long> query = session.createQuery(
	            "SELECT COUNT(p) FROM Patient p", Long.class);
	        return query.uniqueResult();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    } finally {
	        session.close();
	    }
	}
	
	/**
     * Get total count of doctors
     */
    public long getDoctorCount() {
        Session session = sessionFactory.openSession();
        try {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(d) FROM Doctor d", Long.class);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            session.close();
        }
    }
    
    /*
	 * Get count of active doctors
	 */
	public long getActiveDoctorCount() {
	    Session session = sessionFactory.openSession();
	    try {
	        Query<Long> query = session.createQuery(
	            "SELECT COUNT(d) FROM Doctor d WHERE d.isActive = true", Long.class);
	        return query.uniqueResult();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    } finally {
	        session.close();
	    }
	}
	
	public List<Appointment> fetchAppointments() {
	    Session session = sessionFactory.openSession();
	    try {
	    	appointmentDao = new AppointmentDaoImp(session);
	        return appointmentDao.getAllAppointments();
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get list of active doctors with details
	 */
	public List<Object[]> getActiveDoctorDetails() {
	    Session session = sessionFactory.openSession();
	    doctorDao = new DoctorDaoImp(session);
	    try {
	        Query<Object[]> query = session.createQuery(
	            "SELECT d.doctorId, u.username, ud.firstName, ud.lastName, " +
	            "d.specialization, d.experience, d.degree " +
	            "FROM Doctor d " +
	            "JOIN d.user u " +
	            "JOIN UserDetail ud ON u.userId = ud.user.userId " +
	            "WHERE d.isActive = true", Object[].class);
	        return query.getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get count of today's appointments
	 */
	public long getTodayAppointmentCount() {
	    Session session = sessionFactory.openSession();
	    try {
	        LocalDate today = LocalDate.now();
	        Query<Long> query = session.createQuery(
	            "SELECT COUNT(a) FROM Appointment a WHERE a.appointmentDate = :today", Long.class);
	        query.setParameter("today", today);
	        return query.uniqueResult();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get total count of users
	 */
	public long getTotalUserCount() {
	    Session session = sessionFactory.openSession();
	    try {
	        Query<Long> query = session.createQuery(
	            "SELECT COUNT(u) FROM User u", Long.class);
	        return query.uniqueResult();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Get total count of appointments
	 */
	public long getTotalAppointmentCount() {
	    Session session = sessionFactory.openSession();
	    try {
	        Query<Long> query = session.createQuery("SELECT COUNT(*) FROM Appointment", Long.class);
	        Long result = query.uniqueResult();
	        return result != null ? result : 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0;
	    } finally {
	        session.close();
	    }
	}
	
	/**
	 * To Get schedules for that doctor
	 * @param doctorId
	 * @return
	 */
	public List<Object[]> getDoctorSchedules(int doctorId) {
		Session session = sessionFactory.openSession();
	    try {
	    	scheduleDao = new ScheduleDaoImp(session);
	        return scheduleDao.findSchedulesByDoctorId(doctorId);
	    } catch (Exception e) {
	        return new ArrayList<>(); // Return empty list instead of null
	    }
	}
	
	/**
	 * Service method to get doctor details by doctor ID
	 * @param doctorId The ID of the doctor to retrieve
	 * @return List of Object arrays containing doctor details or an empty list if not found
	 */
	public List<Object[]> getDoctorDetailsById(Integer doctorId) {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
	    try {
	        // Call the DAO method to get doctor details
	        List<Object[]> doctorDetails = doctorDao.findDoctorDetailsById(doctorId);
	        
	        // Return the result, which might be null if an exception occurred in the DAO
	        return doctorDetails != null ? doctorDetails : new ArrayList<>();
	    } catch (Exception e) {
	        
	        return new ArrayList<>();
	    }
	}
	
	public boolean updateScheduleAvailability(int scheduleId, boolean isAvailable) {
		Session session = sessionFactory.openSession();
		scheduleDao = new ScheduleDaoImp(session);
	    try {
	        return scheduleDao.updateScheduleAvailability(scheduleId, isAvailable);
	    } catch (Exception e) {
	        return false;
	    }
	}
	
	/**
	 * Dashboard content
	 * @return analytics
	 */
	public Map<String, List<Map<String, Object>>> getDashboardSummary() {
	    Map<String, List<Map<String, Object>>> summary = new HashMap<>();
	    Session session = sessionFactory.openSession();
	    try {
	        patientDao = new PatientDaoImp(session);
	        doctorDao = new DoctorDaoImp(session);
	        appointmentDao = new AppointmentDaoImp(session);

	        // Get all analytics in one go
	        summary.put("patientAnalytics", patientDao.getPatientAnalytics());
	        summary.put("doctorAnalytics", doctorDao.getDoctorAnalytics());
	        summary.put("todayActiveDoctors", doctorDao.getTodayActiveDoctors());
	        summary.put("todayAppointmentAnalytics", appointmentDao.getTodayAppointmentAnalytics());
	        summary.put("overallAppointmentAnalytics", appointmentDao.getOverallAppointmentAnalytics());

	        summary.forEach((key, value) -> System.out.println(key + ": " + value));
	        
	        return summary;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new HashMap<>();
	    } finally {
	        session.close();
	    }
	}
        
        private boolean isAdminRole(Role role) {
	        return role.getRoleId() == 1;
	    }
}
