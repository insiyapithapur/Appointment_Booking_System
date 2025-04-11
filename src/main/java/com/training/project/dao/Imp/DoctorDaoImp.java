package com.training.project.dao.Imp;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.Doctor;
import com.training.project.model.User;

public class DoctorDaoImp implements GenericDao<Doctor, Integer> {
	private Session session;
	
	
	public DoctorDaoImp(){
		super();
	}

	public DoctorDaoImp(Session session) {
		super();
		this.session = session;
	}

	@Override
	public Doctor findById(Integer id) {
		Doctor doctor = session.get(Doctor.class, id);
	    System.out.println("Doctor id: " + doctor);
		return doctor;
	}

	@Override
	public List<Doctor> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Doctor doctor) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(doctor);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(Doctor entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Doctor entity) {
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
	
	public Doctor findByUserId(Integer userId) {
	    Transaction tx = null;
	    Doctor doctor = null;

	    try {
	        tx = session.beginTransaction();

	        // Using HQL - access user.userId through the relationship
	        String hql = "FROM Doctor d WHERE d.user.userId = :userId";
	        doctor = session.createQuery(hql, Doctor.class)
	                .setParameter("userId", userId)
	                .uniqueResult();

	        tx.commit();
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	    }

	    return doctor;
	}
	
	public List<Object[]> findDoctorDetailsById(Integer doctorId) {
	    Transaction transaction = null;
	    List<Object[]> doctorDetails = null;
	    
	    try {
	        transaction = session.beginTransaction();
	        
	        String hql = "SELECT d.doctorId, d.specialization, d.licenseNumber, d.experience, d.degree, d.isActive, " +
	                     "ud.firstName, ud.lastName, ud.gender, ud.phoneNumber, ud.email, ud.dateOfBirth " +
	                     "FROM Doctor d " +
	                     "JOIN d.user u " +
	                     "JOIN UserDetail ud ON u.userId = ud.user.userId " +
	                     "WHERE d.doctorId = :doctorId";
	        
	        Query<Object[]> query = session.createQuery(hql, Object[].class);
	        query.setParameter("doctorId", doctorId);
	        doctorDetails = query.getResultList();
	        
	        transaction.commit();
	    } catch (Exception e) {
	        if (transaction != null) {
	            transaction.rollback();
	        }
	        e.printStackTrace();
	    }
	    
	    return doctorDetails;
	}
	
	public List<Object[]> getDoctorDetails() {
	    Transaction transaction = null;
	    List<Object[]> doctorDetails = null;
	    try {
	        transaction = session.beginTransaction();

	        String hql = "SELECT d.doctorId, d.specialization, d.licenseNumber, d.experience, COALESCE(d.degree, 'N/A'), " +
	                "ud.firstName, ud.lastName, u.username, ud.email, ud.gender, ud.phoneNumber, d.isActive " +
	                "FROM Doctor d " +
	                "JOIN d.user u " +
	                "JOIN UserDetail ud ON u.userId = ud.user.userId";

	        Query<Object[]> query = session.createQuery(hql, Object[].class);
	        doctorDetails = query.getResultList();
	        
	        for (int i = 0; i < doctorDetails.size(); i++) {
	            Object[] row = doctorDetails.get(i);
	            System.out.println("Doctor #" + i + " data:");
	            for (int j = 0; j < row.length; j++) {
	                System.out.println("  Index " + j + ": " + (row[j] == null ? "null" : row[j]));
	            }
	            System.out.println("-------------------");
	        }
	        
	        transaction.commit();
	    } catch (Exception e) {
	        if (transaction != null) {
	            transaction.rollback();
	        }
	        e.printStackTrace();
	    }
	    System.out.println("doctorDetails"+doctorDetails);
	    return doctorDetails;
	}
	
	public User getUserByDoctorId(int doctorId) {
        Query<User> query = session.createQuery(
            "SELECT d.user FROM Doctor d WHERE d.doctorId = :doctorId", 
            User.class);
        query.setParameter("doctorId", doctorId);
        return query.uniqueResult();
    }
	
	//find by id 

	public Doctor getDoctorById(Integer doctorId) {
		Transaction transaction = session.beginTransaction();
		Doctor doctor = session.get(Doctor.class, doctorId);
		transaction.commit();
		session.close();
		return doctor;
	}

						//Update

	public void updateDoctor(Doctor doctor) {
		Transaction transaction = session.beginTransaction();
		session.update(doctor);
		transaction.commit();
		session.close();
	}

						//delete

 public void deleteDoctor(Integer doctorId) {
        Transaction transaction = session.beginTransaction();
        Doctor doctor = session.get(Doctor.class, doctorId);
        if (doctor != null) {
            session.delete(doctor);
        }
        transaction.commit();
        session.close();
    }
 
 
 
 
 	//	add doctor with its detailes here we will add doctor with its detailes 
// it will workin two parts we have user dao in which we create user as doctor so first we will call it here
// i commented here add user with doctor role and after it user create asdoctor we will add doctors entery with its personal detailes which is in doctor detailes 
// and if he want then he can add normal name etc which is in user detailes by their own 
// 
 
 public Doctor addDoctor(String username, String passwordHash, String specialization, String licenseNumber, Float experience, String degree) {
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            // Add user with Doctor role
            UserDaoImp userDao = new UserDaoImp();
            User newUser = userDao.addUser(username, passwordHash);

            if (newUser == null) {
                System.out.println("User creation failed.");
                return null;
            }

            // Create doctor entry linked to the user
            Doctor newDoctor = new Doctor(specialization, licenseNumber, experience, degree, true, null, newUser);
            session.save(newDoctor);

            tx.commit();
            return newDoctor;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return null;
        }

     }
}
