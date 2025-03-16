package com.training.project.dao.Imp;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.Schedule;
import com.training.project.model.UserDetail;

public class ScheduleDaoImp implements GenericDao<Schedule, Integer> {
	private Session session;
	
	public ScheduleDaoImp() {
		super();
	}
	
	public ScheduleDaoImp(Session session) {
		super();
		this.session = session;
	}

	@Override
	public Schedule findById(Integer id) {
		Schedule schedule = session.get(Schedule.class, id);
	    System.out.println("Doctor role id: " + schedule);
		return schedule;

	}

	@Override
	public List<Schedule> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Schedule schedule) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            System.out.println("123456 "+schedule);
            session.save(schedule);
            System.out.println("ins");
            tx.commit();
            return true;
        } catch (Exception e) {
        	System.out.println("jhj");
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(Schedule entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Schedule entity) {
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
	
	public List<Object[]> findSchedulesByDoctorId(int doctorId) {
		Transaction transaction = null;
	    List<Object[]> scheduleDetails = null;
	    System.out.println("doctorId DAO"+doctorId);
	    try {
	    	String hql = "SELECT s.scheduleId, s.doctor.id, s.dayOfWeek, s.startTime, s.endTime, s.maxTokens, s.isAvailable " +
	                 "FROM Schedule s " +
	                 "WHERE s.doctor.id = :doctorId";
	    
		    Query<Object[]> query = session.createQuery(hql, Object[].class);
		    query.setParameter("doctorId", doctorId);
		    scheduleDetails = query.getResultList();
		    transaction.commit();
	    } catch (Exception e) {
	        if (transaction != null) {
	            transaction.rollback();
	        }
	        e.printStackTrace();
	    }
	    return scheduleDetails;
	}
}
