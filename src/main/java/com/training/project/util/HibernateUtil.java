package com.training.project.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.training.project.model.*;

public class HibernateUtil {
	private static final SessionFactory SESSION_FACTORY=buildSessionFactory();
	 
	private static SessionFactory buildSessionFactory() {
		try {
			// ✅ Set the Oracle Wallet path before Hibernate config is loaded valid for local environment only
//			System.setProperty("oracle.net.tns_admin", 
//					"C:/BTech CSD/8th semester/Mastek_Assignments/project/CapestoneProjectImplementation/AppointmentBookingSystem/Wallet_ABS");
			return new Configuration().configure("hibernate.cfg.xml")
					.addAnnotatedClass(Role.class)
					.addAnnotatedClass(User.class)
					.addAnnotatedClass(UserDetail.class)
					.addAnnotatedClass(Patient.class)
					.addAnnotatedClass(Doctor.class)
					.addAnnotatedClass(Schedule.class)
					.addAnnotatedClass(AppointmentsStatus.class)
					.addAnnotatedClass(Appointment.class)
					.addAnnotatedClass(MedicalRecord.class)
					.buildSessionFactory();
		} catch (Exception e) {
			e.printStackTrace();
			throw new ExceptionInInitializerError(e); //if session factory does not initialized
		}		
	}
 
	public static SessionFactory getSessionFactory() {
		return SESSION_FACTORY;
	}
}
