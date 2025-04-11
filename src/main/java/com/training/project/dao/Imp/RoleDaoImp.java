package com.training.project.dao.Imp;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.training.project.dao.GenericDao;
import com.training.project.model.Role;
import com.training.project.model.User;

public class RoleDaoImp implements GenericDao<Role, Integer>{

	private Session session;
	
	public RoleDaoImp() {
		super();
	}

	public RoleDaoImp(Session session) {
		super();
		this.session = session;
	}
	
	@Override
	public Role findById(Integer id) {
		Role role = session.get(Role.class, id);
	    System.out.println("Doctor role id: " + role);
		return role;
	}

	@Override
	public List<Role> findAll() {
		return session.createQuery("FROM Role", Role.class).getResultList();
	}

	@Override
	public boolean create(Role role) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(role);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean update(Role role) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(role);
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
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Role role = session.get(Role.class, id);
            if (role != null) {
                session.delete(role);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public boolean delete(Role role) {
		Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(role);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
	}

	@Override
	public long count() {
		return session.createQuery("SELECT COUNT(*) FROM Role", Long.class)
                .getSingleResult();
	}

	@Override
	public boolean exists(Integer id) {
		return session.get(Role.class, id) != null;
	}
}
