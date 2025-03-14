package com.training.project.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import org.hibernate.*;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;

public class AdminService {
	private SessionFactory sessionFactory;
	private PatientDaoImp patientDao;
	private DoctorDaoImp doctorDao;
	private ScheduleDaoImp scheduleDao;
	private UserDaoImp userDao;
	private UserDetailDaoImp userDetailDao;
	
	public AdminService(SessionFactory sessionFactory) {
		super();
		this.sessionFactory = sessionFactory;
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

//	public Doctor addDoctor(String username, String passwordHash, String specialization, String licenseNumber,
//			Float experience, String degree) {
//		Session session = sessionFactory.openSession();
//		doctorDao = new DoctorDaoImp(session);
//		return doctorDao.addDoctor(username, passwordHash, specialization, licenseNumber, experience, degree);
//	}
	
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
        
        private boolean isAdminRole(Role role) {
	        return role.getRoleId() == 1;
	    }
}
