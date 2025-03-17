package com.training.project.dao.Imp;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.*;

public class UserDetailDaoImp implements GenericDao<UserDetail, Integer> {
	private Session session;
	
	public UserDetailDaoImp() {
		super();
	}

	public UserDetailDaoImp(Session session) {
		super();
		this.session = session;
	}

	@Override
	public UserDetail findById(Integer id) {
		UserDetail userDetails = session.get(UserDetail.class, id);
	    System.out.println("Doctor role id: " + userDetails);
		return userDetails;
	}

	@Override
	public List<UserDetail> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(UserDetail userDetail) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(userDetail);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(UserDetail entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(UserDetail entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public long count() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public boolean exists(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}
	
	public UserDetail findByUserId(Integer userId) {
		try {
			String hql = "FROM UserDetail ud WHERE ud.user.userId = :userId";
			Query<UserDetail> query = session.createQuery(hql, UserDetail.class);
			query.setParameter("userId", userId);
			
			// Get a single result or null if not found
			return query.uniqueResult();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public UserDetail findByEmail(String email) {
		try {
			
			String hql = "FROM UserDetail ud WHERE ud.email = :email";
			Query<UserDetail> query = session.createQuery(hql, UserDetail.class);
			query.setParameter("email", email);
			
			// Get a single result or null if not found
			return query.uniqueResult();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public List<Object[]> createPatientDetails(Integer userId, String firstName, String lastName, 
            LocalDate dob, String gender, String email, 
            String phone, String bloodGroup) {
Transaction transaction = null;
List<Object[]> result = null;

try {
// First, create/update the user detail
transaction = session.beginTransaction();

// Create UserDetail if not exists
UserDetail userDetail = new UserDetail();
userDetail.setFirstName(firstName);
userDetail.setLastName(lastName);
userDetail.setDateOfBirth(dob);
userDetail.setGender(gender);
userDetail.setEmail(email);
userDetail.setPhoneNumber(phone);

// Associate with user
User user = session.get(User.class, userId);
userDetail.setUser(user);
session.save(userDetail);

// Create Patient record
Patient patient = new Patient();
patient.setBloodGrp(bloodGroup);
patient.setUser(user);
session.save(patient);

transaction.commit();

// Now execute the query to get required data
String hql = "SELECT u.userId, p.patientId, u.username, r.roleName " +
"FROM User u " +
"JOIN u.role r " +
"JOIN Patient p ON p.user.userId = u.userId " +
"WHERE u.userId = :userId";

Query query = session.createQuery(hql);
query.setParameter("userId", userId);
result = query.list();

return result;
} catch (Exception e) {
if (transaction != null) {
transaction.rollback();
}
e.printStackTrace();
return null;
}
}
	
}
