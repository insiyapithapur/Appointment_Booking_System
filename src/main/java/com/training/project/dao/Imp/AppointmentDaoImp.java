package com.training.project.dao.Imp;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.training.project.dao.GenericDao;
import com.training.project.model.Appointment;
import com.training.project.model.AppointmentsStatus;

public class AppointmentDaoImp implements GenericDao<Appointment, Integer> {
	private Session session;
	
	public AppointmentDaoImp(){
		super();
	}

	public AppointmentDaoImp(Session session) {
		super();
		this.session = session;
	}
	
	@Override
	public Appointment findById(Integer id) {
		Appointment appointment = session.get(Appointment.class, id);
	    System.out.println("Doctor id: " + appointment);
		return appointment;
	}

	@Override
	public List<Appointment> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean create(Appointment entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean update(Appointment entity) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteById(Integer id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean delete(Appointment entity) {
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
	
	public List<Appointment> findByScheduleIds(List<Integer> scheduleIds) {
        Query<Appointment> query = session.createQuery(
            "FROM Appointment WHERE schedule.id IN (:scheduleIds)", Appointment.class);
        query.setParameter("scheduleIds", scheduleIds);
        return query.list();
    }
	
	public List<Appointment> findByPatientId(Integer patientId) {
	    List<Appointment> appointments = new ArrayList<>();
	    Transaction tx = null;    
	    try {
	        tx = session.beginTransaction();
	        
	        String hql = "FROM Appointment a WHERE a.patient.patientId = :patientId";
	        appointments = session.createQuery(hql, Appointment.class)
	                            .setParameter("patientId", patientId)
	                            .list();
	        
	        tx.commit();
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	    }
	    
	    return appointments;
	}
	
	public boolean updateAppointmentStatus(int appointmentId, Integer newStatusId) {
	    Transaction tx = null;
	    try {
	        tx = session.beginTransaction();
	        
	        // Fetch the appointment by ID
	        Appointment appointment = session.get(Appointment.class, appointmentId);
	        if (appointment == null) {
	            throw new IllegalArgumentException("Appointment not found with ID: " + appointmentId);
	        }

	        // Fetch the new status from the AppointmentStatus table
	        AppointmentsStatus newStatus = session.get(AppointmentsStatus.class, newStatusId);
	        
	        if (newStatus == null) {
	            throw new IllegalArgumentException("Invalid status ID: " + newStatusId);
	        }

	        // Update appointment status
	        appointment.setStatus(newStatus);
	        session.update(appointment);
	        
	        tx.commit();
	        return true;
	    } catch (Exception e) {
	        if (tx != null) tx.rollback();
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public List<Appointment> findUpcomingAppointmentsForUser(int userId, LocalDate fromDate) {
	    try {
	        // Fetch role of the user
	        String roleQuery = "SELECT u.role.roleName FROM User u WHERE u.userId = :userId";
	        Query<String> queryRole = session.createQuery(roleQuery, String.class);
	        queryRole.setParameter("userId", userId);
	        String roleName = queryRole.uniqueResult();

	        if (roleName == null) {
	            throw new IllegalArgumentException("User not found with userId: " + userId);
	        }

	        String hql;
	        if (roleName.equalsIgnoreCase("Patient")) {
	            // Query for patient: Fetch all upcoming appointments
	            hql = "FROM Appointment a WHERE a.patient.user.userId = :userId "
	                + "AND a.appointmentDate >= :fromDate ORDER BY a.appointmentDate ASC";
	        } else if (roleName.equalsIgnoreCase("Doctor")) {
	            // Query for doctor: Fetch appointments only for the specific date
	            hql = "SELECT a FROM Appointment a JOIN a.schedule s "
	                + "WHERE s.doctor.user.userId = :userId "
	                + "AND a.appointmentDate >= :fromDate ORDER BY a.appointmentDate ASC";
	        } else {
	            throw new IllegalArgumentException("User role " + roleName + " is not supported for appointment retrieval");
	        }

	        Query<Appointment> query = session.createQuery(hql, Appointment.class);
	        query.setParameter("userId", userId);
	        query.setParameter("fromDate", fromDate);

	        return query.list();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return List.of();
	    }
	}
}
