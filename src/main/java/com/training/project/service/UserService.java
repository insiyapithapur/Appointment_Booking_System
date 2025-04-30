package com.training.project.service;

import java.time.LocalDate;
import java.util.*;

import javax.mail.MessagingException;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.util.EmailUtil;
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
	    
	    UserDetail userDetails = userDetailDao.findByUserId(userId);
	    System.out.println("userDetails.EMAIL"+userDetails.getEmail());
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
	
	/**
	 * Combined login function that checks username, verifies password,
	 * and updates login status if credentials are valid
	 * 
	 * @param username The username to check
	 * @param password The password to verify
	 * @return Map containing userDetails (if successful) or errorType (if failed)
	 */
	public Map<String, Object> loginUser(String username, String password) {
	    Map<String, Object> result = new HashMap<>();
	    Session session = sessionFactory.openSession();
	    try {
	        userDao = new UserDaoImp(session);
	        
	        // First check if user exists
	        User user = userDao.checkUsername(username);
	        if (user == null) {
	            System.out.println("User doesn't exist: " + username);
	            result.put("errorType", "INVALID_USERNAME");
	            result.put("errorMessage", "User doesn't exist.");
	            return result;
	        }
	        
	        // Then verify password and get user details
	        List<Object> sessionContent = userDao.findIdsByUsername(username, password);
	        if (sessionContent == null) {
	            System.out.println("Invalid password for user: " + username);
	            result.put("errorType", "INVALID_PASSWORD");
	            result.put("errorMessage", "Password is incorrect.");
	            return result;
	        }
	        
	        // If we got here, both username and password are correct
	        // Update is_login status to 1 (true)
	        Integer userId = (Integer) sessionContent.get(0);
	        boolean updateSuccess = userDao.updateLoginStatus(userId, true);
	        
	        if (!updateSuccess) {
	            System.out.println("Failed to update login status for user: " + username);
	            result.put("errorType", "LOGIN_STATUS_UPDATE_FAILED");
	            result.put("errorMessage", "Failed to update login status. Please try again.");
	            result.put("userDetails", sessionContent); // Include session content anyway
	            return result;
	        }
	        
	        System.out.println("Login status updated for user: " + username);
	        result.put("success", true);
	        result.put("userDetails", sessionContent);
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("errorType", "SYSTEM_ERROR");
	        result.put("errorMessage", "System error occurred. Please try again later.");
	        return result;
	    } finally {
	        session.close();
	    }
	}
	
	/*
	 * Forget Password
	 */
	public boolean resetPassword(String username , String newPassword) {
		System.out.println("email"+username+" new password "+newPassword);
		boolean result = false;
		Session session = sessionFactory.openSession();
		userDao = new UserDaoImp(session);
		 userDetailDao = new UserDetailDaoImp(session);
		 
		 User user = userDao.findByUserName(username);
		 
		 System.out.println("user "+user.getPasswordHash());
		 System.out.println("user "+user.getUsername());
		if (user != null) {
			//user.setPasswordHash(newPassword);
			result = userDao.updateById(user.getUserId(), newPassword);
			System.out.println("result reset password service"+result);
		}
		session.close();
		System.out.println("result reset password"+result);
		return result;
	}
	
	public UserDetail findByEmail(String email) {
        try {
            Session session = sessionFactory.openSession();
            userDetailDao = new UserDetailDaoImp(session);
            return userDetailDao.findByEmail(email);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	public UserDetail findByUsername(String username) {
        try {
            Session session = sessionFactory.openSession();
            userDetailDao = new UserDetailDaoImp(session);
            return userDetailDao.findByUsername(username);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	public boolean sendEmailByUsername(String username, String otp) {
		System.out.println("send email by username");
        Session session = sessionFactory.openSession();
        userDetailDao = new UserDetailDaoImp(session);
        UserDetail userDetail = userDetailDao.findByUsername(username);
        
        if (userDetail == null) {
            return false;
        }
        
        String email = userDetail.getEmail();
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String emailBody = "<p>Hello " + userDetail.getUser().getUsername() + ",</p>" + 
                           "<p>This is your one time password: <strong>" + otp + "</strong></p>" + 
                           "<p>Please enter the OTP on the website to update your password!</p>";

        try {
            EmailUtil.sendHtmlEmail(email, "Password Change Request", emailBody);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
	
	public boolean sendEmail(String email, String otp) {
        Session session = sessionFactory.openSession();
        UserDetailDaoImp userDetailDao = new UserDetailDaoImp(session);
        UserDetail userDetail = userDetailDao.findByEmail(email);
        
        if (userDetail == null) {
            return false;
        }

        String emailBody = "<p>Hello " + userDetail.getUser().getUsername() + ",</p>" + 
                           "<p>This is your one time password: <strong>" + otp + "</strong></p>" + 
                           "<p>Please enter the OTP on the website to update your password!</p>";

        try {
            EmailUtil.sendHtmlEmail(userDetail.getEmail(), "Password Change Request", emailBody);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
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
	
	public boolean updateUserLoginStatus(Integer userId) {
	    Session session = sessionFactory.openSession();
	    try {
	        userDao = new UserDaoImp(session);
	        return userDao.updateLoginStatus(userId, false);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        session.close();
	    }
	}
	
	 private boolean isAdminRole(Role role) {
	        return role.getRoleId() == 1;
	    }
}
