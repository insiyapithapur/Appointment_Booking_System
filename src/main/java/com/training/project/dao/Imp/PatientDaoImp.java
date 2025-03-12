package com.training.project.dao.Imp;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import com.training.project.dao.GenericDao;
import com.training.project.model.Patient;

public class PatientDaoImp implements GenericDao<Patient, Integer> {
	private Session session;
	
	public PatientDaoImp(){
		super();
	}

	public PatientDaoImp(Session session) {
		super();
		this.session = session;
	}

	@Override
	public Patient findById(Integer id) {
		Patient patient = session.get(Patient.class, id);
	    System.out.println("Patient id: " + patient);
		return patient;
	}

	@Override
	public List<Patient> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Patient patient) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(patient);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(Patient entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Patient entity) {
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
	public Patient findByUserId(Integer userId) {
	    Transaction tx = null;
	    Patient patient = null;
	    
	    try {
	        tx = session.beginTransaction();
	        
	        // Using HQL (Hibernate Query Language) to find patient by userId
	        String hql = "FROM Patient p WHERE p.user.userId = :userId";
	        patient = session.createQuery(hql, Patient.class)
	                       .setParameter("userId", userId)
	                       .uniqueResult();
	                       
	        tx.commit();
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	    }
	    
	    return patient;
	}
	
	public List<Patient> getAllPatients() {
        List<Patient> patients = null;
        try {
            Query<Patient> query = session.createQuery("FROM Patient", Patient.class);
            patients = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    			//get patients with user detailes
    
    public List<Object[]> getPatientDetails() {
        Transaction transaction = null;
        List<Object[]> patientDetails = null;
        try {
            transaction = session.beginTransaction();
            
            String hql = "SELECT p.bloodGrp, ud.firstName, ud.lastName, u.username, " +
                         "ud.email, ud.gender, ud.phoneNumber " +
                         "FROM Patient p " +
                         "JOIN p.user u " +
                         "JOIN UserDetail ud ON u.userId = ud.user.userId";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            patientDetails = query.getResultList();
            
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        return patientDetails;
    }
    
    
    
    
    //patient by id 
    
    
    
    public Object[] getPatientById(int patientId) {
        Transaction transaction = null;
        Object[] patientDetails = null;
        try {
            transaction = session.beginTransaction();
            
            String hql = "SELECT p.bloodGrp, ud.firstName, ud.lastName, u.username, " +
                         "ud.email, ud.gender, ud.phoneNumber " +
                         "FROM Patient p " +
                         "JOIN p.user u " +
                         "JOIN UserDetail ud ON u.userId = ud.user.userId " +
                         "WHERE p.patientId = :patientId";
            
            Query<Object[]> query = session.createQuery(hql, Object[].class);
            query.setParameter("patientId", patientId);
            
            patientDetails = query.uniqueResult();
            
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        }
        return patientDetails;
    }
}
