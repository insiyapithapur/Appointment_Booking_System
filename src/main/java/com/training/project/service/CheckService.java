package com.training.project.service;


import javax.mail.MessagingException;

import org.hibernate.Session;

import com.training.project.dao.Imp.UserDaoImp;
import com.training.project.dao.Imp.UserDetailDaoImp;
import com.training.project.model.User;
import com.training.project.model.UserDetail;
import com.training.project.util.EmailUtil;

public class CheckService {
	Session session;

	public CheckService(Session session) {
		
		super();
		this.session = session;
	}

	public boolean checkUser(String username) {
		
		UserDaoImp userDao = new UserDaoImp(session);
		User user =  userDao.findByUserName(username);
		
		return user != null;
	}
	public boolean checkPassword(String username,String password) {
		
		UserDaoImp userDao = new UserDaoImp(session);
		
		User user =  userDao.findToAuthenticate(username);
		String dbPassword = user.getPasswordHash();
		//decrypt logic
		String decryptedPassword = dbPassword;
		
		return decryptedPassword.equals(password);
	}

	public int getRole(String userName) {
		UserDaoImp userDao = new UserDaoImp(session);
		User user =  userDao.findByUserName(userName);
		return user.getRole().getRoleId();
		
	}
	
	public boolean checkOtp(String givenOtp,String otp){
		if(givenOtp.equals(otp)) {
			return true;
		}
			return false;
	}
   

	public boolean sendEmail(String email,String otp) {
		UserDetailDaoImp userDetailDao = new UserDetailDaoImp(session);
		UserDetail userDetail = userDetailDao.findByEmail(email);		
		
		String emailBody = "<p>Hello " +",</p>" 
                + "<p>this is your one time  password</p>"
                + otp
                + "<p>Please enter the otp on website to update password!</p>";	
		
		try {
			EmailUtil.sendHtmlEmail(userDetail.getEmail(), "Password Change request: " , emailBody);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			return false;
		}
		return true;
	}


}
