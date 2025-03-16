package com.training.project.service;

import java.time.LocalDate;
import java.util.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.util.HibernateUtil;

public class UserService {
	private SessionFactory sessionFactory;
	private UserDaoImp userDao;
	private UserDetailDaoImp userDetailDao;
	private DoctorDaoImp doctorDao;
	private PatientDaoImp patientDao;
	
	public UserService() {
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
//	/*
//	 * Registration of doctor
//	 */
////	public boolean createDoctorByAdmin(int adminId, User doctorUser) {
//	public boolean createDoctorByAdmin(Integer adminId) {
//	    Session session = sessionFactory.openSession();
//	    userDao = new UserDaoImp(session);
//	    
//	    RoleDaoImp roledao = new RoleDaoImp(session);
//    	Role role = roledao.findById(3);
//    	User doctorUser = new User("Insiya_Doc3","ROOT",true,role);
//    	
//	    try {
//	    	System.out.println("Session in createDoctorByAdmin: 1 " + session);
//	        // 1. Verify the admin ID is valid
//	        User adminUser = userDao.findById(adminId);
//	        System.out.println("Session in createDoctorByAdmin: 2 " + session);
//
//	        if (adminUser == null) {
//	            System.out.println("Admin user not found with ID: " + adminId);
//	            return false;
//	        }
//	        
//	        // 2. Verify the user has admin role
//	        Role adminRole = adminUser.getRole();
//	        if (adminRole == null || !isAdminRole(adminRole)) {
//	            System.out.println("User with ID " + adminId + " does not have admin privileges");
//	            return false;
//	        }
//	        
//	        // 3. Check if the username already exists
//	        User existingUser = userDao.findByUsername(doctorUser.getUsername());
//	        if (existingUser != null) {
//	            System.out.println("Username '" + doctorUser.getUsername() + "' already exists");
//	            return false;
//	        }
//	        
//	        // 5. Create the doctor user
//	        boolean result = userDao.create(doctorUser);
//	        return result;
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        return false;
//	    } finally {
//	    	System.out.println("Session in createDoctorByAdmin: closing " + session);
//	        session.close();
//	    }
//	}
	
	/*
	 * After Login Details Checking Existence for doctor
	 * Update for patient also
	 */
	public String checkUserDoctorStatus(Integer userId) {
		Session session = sessionFactory.openSession();
		doctorDao = new DoctorDaoImp(session);
		userDetailDao = new UserDetailDaoImp(session);
		
	    // Check if user details exist
	    UserDetail userDetail = userDetailDao.findById(userId);
	    boolean userExists = userDetail != null;
	    
	    // Check if doctor details exist
	    Doctor doctorDetail = doctorDao.findById(userId);
	    boolean doctorExists = doctorDetail != null;
	    session.close();
	    if (!userExists) {
	        return "Please complete your user profile first.";
	    } else if (!doctorExists) {
	        return "Please complete your doctor details.";
	    } else {
	        return "All details complete.";
	    }
	}
	
//	/*
//	 * Fill UserDetails and Doctor Details
//	 */
////	public boolean createDoctorDetails(UserDetail userDetail, Doctor doctor) {
//	public boolean createDoctorDetails() {
//		Session session = sessionFactory.openSession();
//		doctorDao = new DoctorDaoImp(session);
//		userDetailDao = new UserDetailDaoImp(session);
//		
//		UserDaoImp userDao = new UserDaoImp(session);
//    	User user = userDao.findById(2);
//    	
//    	LocalDate dateOfBirth = LocalDate.of(2003, 4, 8);
//    	UserDetail userDetail = new UserDetail("Insiya","Pithapur",dateOfBirth,"F","9016222140","banupithapur@gmail.com",user);
//		
//    	Doctor doctor = new Doctor("ENT","L123456",(float)1.5,"MBBS",true,user);
//    	
//		if (userDetail.getUser() == null || doctor.getUser() == null || 
//		        !userDetail.getUser().getUserId().equals(doctor.getUser().getUserId())) {
//		        return false;
//		    }
//		try {
//	        // Check if userDetail already exists for this user
//	        UserDetail existingUserDetail = userDetailDao.findById(userDetail.getUser().getUserId());
//	        if (existingUserDetail != null) {
//	            return true;
//	        } else {
//	            // Create new userDetail
//	            boolean userDetailCreated = userDetailDao.create(userDetail);
//	            if (!userDetailCreated) {
//	                return false;
//	            }
//	        }
//	        
//	        // Check if doctor details already exist for this user
//	        Doctor existingDoctor = doctorDao.findById(doctor.getUser().getUserId());
//	        if (existingDoctor != null) {
//	            return true;
//	        } else {
//	            // Create new doctor
//	            boolean doctorCreated = doctorDao.create(doctor);
//	            if (!doctorCreated) {
//	                return false;
//	            }
//	        }
//	        
//	        return true;
//	    } catch (Exception e) {
//	        System.out.println("Error creating doctor details: " + e.getMessage());
//	        e.printStackTrace();
//	        return false;
//	    }finally {
//	    	session.close();
//	    }
//	}
	
	/*
	 * Registration of Patient
	 */
	public boolean createPatient() {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    
	    RoleDaoImp roledao = new RoleDaoImp(session);
    	Role role = roledao.findById(2);
    	User patientUser = new User("Insiya_Patient3","ROOT",true,role);
    	
	    try {
	        // 1. Check if the username already exists
	        User existingUser = userDao.checkUsername(patientUser.getUsername());
	        if (existingUser != null) {
	            System.out.println("Username '" + patientUser.getUsername() + "' already exists");
	            return false;
	        }
	        
	        // 5. Create the doctor user
	        boolean result = userDao.create(patientUser);
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        session.close();
	    }
	}
	
//	/*
//	 * Fill UserDetails and Patient Details
//	 */
////	public boolean createDoctorDetails(UserDetail userDetail, Doctor doctor) {
//	public boolean createPatientDetails() {
//		Session session = sessionFactory.openSession();
//		patientDao = new PatientDaoImp(session);
//		userDetailDao = new UserDetailDaoImp(session);
//		
//		UserDaoImp userDao = new UserDaoImp(session);
//    	User user = userDao.findById(5);
//    	
//    	LocalDate dateOfBirth = LocalDate.of(2003, 4, 8);
//    	UserDetail userDetail = new UserDetail("Insiya","Patient",dateOfBirth,"F","9016222140","banupithapur@gmail.com",user);
//		
//    	Patient patient = new Patient("A+",user);
//    	
//		if (userDetail.getUser() == null || patient.getUser() == null || 
//		        !userDetail.getUser().getUserId().equals(patient.getUser().getUserId())) {
//		        return false;
//		    }
//		try {
//	        // Check if userDetail already exists for this user
//	        UserDetail existingUserDetail = userDetailDao.findById(userDetail.getUser().getUserId());
//	        if (existingUserDetail != null) {
//	            return true;
//	        } else {
//	            // Create new userDetail
//	            boolean userDetailCreated = userDetailDao.create(userDetail);
//	            if (!userDetailCreated) {
//	                return false;
//	            }
//	        }
//	        
//	        // Check if Patient details already exist for this user
//	        Patient existingPatient = patientDao.findById(patient.getUser().getUserId());
//	        if (existingPatient != null) {
//	            return true;
//	        } else {
//	            // Create new Patient
//	            boolean patientCreated = patientDao.create(patient);
//	            if (!patientCreated) {
//	                return false;
//	            }
//	        }
//	        
//	        return true;
//	    } catch (Exception e) {
//	        System.out.println("Error creating patient details: " + e.getMessage());
//	        e.printStackTrace();
//	        return false;
//	    }finally {
//	    	session.close();
//	    }
//	}
	
	/*
	 * Get Profile Details by user_id for both doctor and patient
	 */
	public List<String> GetUserProfileDetails(Integer userId) {
		List<String> profileDetails = new ArrayList<>();
		Session session = sessionFactory.openSession();
		patientDao = new PatientDaoImp(session);
		userDetailDao = new UserDetailDaoImp(session);
		doctorDao = new DoctorDaoImp(session);
		userDao = new UserDaoImp(session);
		
		User user = userDao.findById(userId);
	    if (user == null) {
	        return profileDetails; // Return empty list if user not found
	    }
	    
	    profileDetails.add("User ID: " + user.getUserId());
	    profileDetails.add("Username: " + user.getUsername());
	    
	    UserDetail userDetails = userDetailDao.findById(userId);
	    if (userDetails != null) {
	        profileDetails.add("Name: " + userDetails.getFirstName()+" "+userDetails.getLastName());
	        profileDetails.add("Email: " + userDetails.getEmail());
	        profileDetails.add("DOB: " + userDetails.getDateOfBirth());
	        profileDetails.add("Gender: " + userDetails.getGender());
	        profileDetails.add("Phone: " + userDetails.getPhoneNumber());
	    }
	    
	    Integer role = user.getRole().getRoleId();
	    if (role == 2) {
	        // Patient specific information
	        Patient patient = patientDao.findByUserId(userId);
	        if (patient != null) {
	            profileDetails.add("Patient ID: " + patient.getPatientId());
	            profileDetails.add("Blood Group: " + patient.getBloodGrp());
	        }
	    } else if (role == 3) {
	        // Doctor specific information
	        Doctor doctor = doctorDao.findByUserId(userId);
	        if (doctor != null) {
	            profileDetails.add("Doctor ID: " + doctor.getDoctorId());
	            profileDetails.add("Specialization: " + doctor.getSpecialization());
	            profileDetails.add("License Number: " + doctor.getLicenseNumber());
	            profileDetails.add("Degree: " + doctor.getDegree());
//	            profileDetails.add("Degree: " + doctor.getIsActive());
	        }
	    }
	    session.close();
	    return profileDetails;
	}
	
	/*
	 * Login for all Users
	 */
	public boolean checkUser(String username) {
		Session session = sessionFactory.openSession();
		userDao = new UserDaoImp(session);
		User user =  userDao.checkUsername(username);
		return user != null;
	}
	public List<Object> checkPassword(String username,String password) {
		Session session = sessionFactory.openSession();
		userDao = new UserDaoImp(session);
		
		List<Object> sessionContent =  userDao.findIdsByUsername(username);
		if(sessionContent == null) {
			return null;
		}
		return sessionContent;
	}
	
	/*
	 * Forget Password
	 */
	public boolean resetPassword(String username, String oldPassword,String newPassword) {
	    Session session = sessionFactory.openSession();
	    boolean result = false;
	    userDao = new UserDaoImp(session);
	    
	    User user = userDao.checkUsername(username);

	    if(user != null&&user.getUsername().equals(username)) {
	    	if(oldPassword.equals(user.getPasswordHash())) {
	    		user.setPasswordHash(newPassword);
	    		result = userDao.update(user);
	    	}
        }
	 	session.close();
	    return result;
	}
	
	public List<User> AllUser() {
	    Session session = sessionFactory.openSession();
	    userDao = new UserDaoImp(session);
	    
	    List<User> users = userDao.findAll(); // Fetch all users
	    System.out.println("kjbfkjsdbf");
	    
	    users.forEach(System.out::println);
	    

	    session.close(); // Close the session to prevent memory leaks
	    return users;
	}
	
	/*
	 * Create UserDetails and Patient Details
	 */
	public List<Object> fillUserDetailsForPatient(Integer userId, String firstName, String lastName,
            LocalDate dob, String gender, String email,
            String phone, String bloodGroup) {
		
			Session session = sessionFactory.openSession();
			userDetailDao = new UserDetailDaoImp(session);
			List<Object> result = new ArrayList<>();

try {
List<Object[]> queryResult = userDetailDao.createPatientDetails(userId, firstName, lastName,
                                       dob, gender, email,
                                       phone, bloodGroup);

// Convert List<Object[]> to List<Object> preserving original types
if (queryResult != null && !queryResult.isEmpty()) {
Object[] data = queryResult.get(0);
for (Object item : data) {
result.add(item); // Keep original types
}
}

return result;
} catch (Exception e) {
e.printStackTrace();
return result;
} finally {
session.close();
}
}
	
    
	 private boolean isAdminRole(Role role) {
	        return role.getRoleId() == 1;
	    }
}
