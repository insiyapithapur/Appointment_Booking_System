package com.training.project.dao.Imp;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.Role;
import com.training.project.model.User;

public class UserDaoImp implements GenericDao<User, Integer> {
	
	private Session session;
	
	public UserDaoImp() {
		super();
	}

	public UserDaoImp(Session session) {
		super();
		this.session = session;
	}
	
	@Override
	public User findById(Integer id) {
		System.out.println("Session in createDoctorByAdmin: id "+id+" " + session);
		Transaction tx = session.beginTransaction();
	    User user = session.get(User.class, id);
	    System.out.println("user "+user);
	    tx.commit();  // Ensure commit happens
	    return user;
	}

	@Override
	public List<User> findAll() {
		List<User> users = new ArrayList<>();
	    Transaction tx = null;
	    try {
	        tx = session.beginTransaction(); // Start transaction
	        users = session.createQuery("FROM User", User.class).list(); // Fetch all users
	        tx.commit(); // Commit transaction
	    } catch (Exception e) {
	        if (tx != null) tx.rollback(); // Rollback in case of error
	        e.printStackTrace();
	    }
	    System.out.print(users.isEmpty());
	    return users;	}

	public Integer createUser(User user) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Integer userId = (Integer) session.save(user);
            System.out.println("userId "+userId);
            tx.commit();
            return userId;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return 1;
        }
	}
	
	public User findToAuthenticate(String name) {
		String hql = "FROM User WHERE username = :name";
		 User user =  session.createQuery(hql, User.class)
                 .setParameter("name", name)
                 .uniqueResult();
		try {
	    
	   
		    User returnUser = new User();
		    if(user != null) {
		    returnUser.setUserId(user.getUserId());
		    returnUser.setUsername(user.getUsername());
		    returnUser.setPasswordHash(user.getPasswordHash());
		    returnUser.setRole(user.getRole());
		    return returnUser;
		    }
	    }
	    catch(Exception e) {
	    	user = null;
	    }
	    return user;
	}

	@Override
	public boolean update(User user) {
	    Transaction tx = null;
	    try {
	        tx = session.beginTransaction();
	        session.update(user);
	        tx.commit();
	        return true;
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	        return false;
	    }
	}
	
	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(User entity) {
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
	
	public User checkUsername(String username) {
        try {
            return session.createQuery("FROM User WHERE username = :username", User.class)
                    .setParameter("username", username)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
	
	@SuppressWarnings("unchecked")
	public List<Object> findIdsByUsername(String username,String password) {
	    try {
	        String role = null;
	        List<Object> detailsList = new ArrayList<>();
	        
	        // First, get the user's role
	        User user = session.createQuery("FROM User WHERE username = :username", User.class)
	            .setParameter("username", username)
	            .uniqueResult();

	        if (user == null) {
	            return null;
	        }
	        
	        if (!user.getPasswordHash().equals(password)) {
	        	System.out.println("jakcbnk");
	            return null; // Password doesn't match
	        }
	        
	        System.out.println("dwkdh");
	        role = user.getRole().getRoleName();

	        // Now get both IDs in a single query based on role
	        if ("DOCTOR".equalsIgnoreCase(role)) {
	            List<Object[]> results = session.createQuery(
	                "SELECT u.userId, d.doctorId FROM User u JOIN Doctor d ON u = d.user WHERE u.username = :username")
	                .setParameter("username", username)
	                .list();
	                
	            if (results != null && !results.isEmpty()) {
	                Object[] ids = results.get(0);
	                detailsList.add(ids[0]); // userId
	                detailsList.add(ids[1]); // doctorId
	                detailsList.add(role);   // role name
	                detailsList.add(username); // username
	            }
	        } else if ("PATIENT".equalsIgnoreCase(role)) {
	            List<Object[]> results = session.createQuery(
	                "SELECT u.userId, p.patientId FROM User u JOIN Patient p ON u = p.user WHERE u.username = :username")
	                .setParameter("username", username)
	                .list();
	                
	            if (results != null && !results.isEmpty()) {
	                Object[] ids = results.get(0);
	                detailsList.add(ids[0]); // userId
	                detailsList.add(ids[1]); // patientId
	                detailsList.add(role);   // role name
	                detailsList.add(username); // username
	            }
	        } else if ("ADMIN".equalsIgnoreCase(role)) {
	            Integer userId = (Integer) session.createQuery(
	                "SELECT u.userId FROM User u WHERE u.username = :username")
	                .setParameter("username", username)
	                .uniqueResult();

	            if (userId != null) {
	                detailsList.add(userId); // userId
	                detailsList.add(userId); // Use userId as roleSpecificId for admin
	                detailsList.add(role);   // role name
	                detailsList.add(username); // username
	            }
	        }

	        return detailsList.isEmpty() ? null : detailsList;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	
	//For register service
	public User findByUserName(String name) {
	    String hql = "FROM User WHERE username = :name";
	    User user =  session.createQuery(hql, User.class)
                .setParameter("name", name)
                .uniqueResult();
	    try {
	    
	   
	    
		    User returnUser = new User();
		    if(user != null) {
		    returnUser.setUserId(user.getUserId());
		    returnUser.setUsername(user.getUsername());
		    returnUser.setIsLogin(user.getIsLogin());
		    returnUser.setLastLogin(user.getLastLogin());
		    returnUser.setPasswordHash(user.getPasswordHash());
		    returnUser.setRole(user.getRole());
		    return returnUser;
		    }
	    }
	    catch(Exception e) {
	    	user = null;
	    }
	    
	    return user;
	}
	
	
	// it will add the user with the role as doctor if just want to create user as doctor

    public User addUser(String username, String passwordHash) {
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            // Fetch the Doctor role
            Query<Role> query = session.createQuery("FROM Role WHERE roleName = :roleName", Role.class);
            query.setParameter("roleName", "Doctor");
            Role doctorRole = query.uniqueResult();

            if (doctorRole == null) {
                System.out.println("Doctor role not found.");
                return null;
            }

            // Create new user with doctor role
            User newUser = new User(username, passwordHash, false, doctorRole);
            session.save(newUser);

            tx.commit();
            return newUser;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean updateById(Integer id, String newPassword) {
	    Transaction transaction = null;
	    try {
	        transaction = session.beginTransaction();
	        User user = session.get(User.class, id);
	        
	        if (user != null) {
	            user.setPasswordHash(newPassword);
	            session.update(user);
	            transaction.commit();
	            return true;
	        }
	    } catch (HibernateException e) {
	        if (transaction != null) transaction.rollback();
	       return false;
	    } 
	    return true;
	}
    
	@Override
	public boolean create(User entity) {
		// TODO Auto-generated method stub
		return false;
	}
}
