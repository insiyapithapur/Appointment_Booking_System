package com.training.project.dao.Imp;

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
	
}
