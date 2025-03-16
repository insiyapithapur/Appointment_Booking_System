package com.training.project.service;

import java.time.LocalDateTime;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.training.project.dao.Imp.RoleDaoImp;
import com.training.project.dao.Imp.UserDaoImp;
import com.training.project.model.User;
import com.training.project.util.HibernateUtil;

public class RegisterService {
	
	private SessionFactory sessionFactory;
	
	public RegisterService() {
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
	
	
	public Integer createUser(String username,String password) {
		Session session = sessionFactory.openSession();
	   //Patient == role = 2
	   User user = new User();
	   Integer userId = 1;
	   UserDaoImp userDao = new UserDaoImp(session);
	   RoleDaoImp roleDao = new RoleDaoImp(session);
	   
	   user.setRole(roleDao.findById(2));
	   user.setUsername(username);
	   user.setPasswordHash(password);
	   
	   if(userDao.findByUserName(username)==null) {
		   userId =  userDao.createUser(user); 
	   }
	   
	   session.close();
	   System.out.println("userId service"+userId);
	    return userId; 
	}
}
