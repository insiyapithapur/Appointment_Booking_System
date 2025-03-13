package com.training.project;

import java.time.LocalDate;
import java.util.List;

import org.hibernate.SessionFactory;
import com.training.project.dao.Imp.*;
import com.training.project.model.*;
import com.training.project.service.*;
import com.training.project.util.HibernateUtil;

/**
 * Hello world!
 */
public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        try {
            // Load Hibernate session factory
        	SessionFactory sessionFactory=HibernateUtil.getSessionFactory();

        	/*RoleService roleService = new RoleService(sessionFactory);
        	
        	Role r1=new Role("Admin");
        	createdRole(roleService, r1);
        	
        	Role r2=new Role("Patient");
        	createdRole(roleService, r2);
        	
        	Role r3=new Role("Doctor");
        	createdRole(roleService, r3);*/
        	
//        	UserService userService = new UserService(sessionFactory);
//        	RoleDaoImp roledao = new RoleDaoImp();
//        	
//        	Role role = roledao.findById(3);
//        	User doctorUser1 = new User("Insiya_Doc1","ROOT",true,role);
//        	userService.createDoctorByAdmin(1);
//        	userService.createPatient();
//        	userService.AllUser();
        	
//        	userService.createDoctorDetails();
//        	String msg = userService.checkUserDoctorStatus(2);
//        	System.out.println("UserDetail msg : "+msg);
//        	userService.createPatientDetails();
//        	ScheduleService scheduleService = new ScheduleService(sessionFactory);
//        	scheduleService.createSchedule(1,1);
//        	List<String> profileDetails = userService.GetUserProfileDetails(5);
//        	profileDetails.forEach(System.out::println);
        	
//        	DoctorService doctorService = new DoctorService(sessionFactory);
//            List<Appointment> appointments = doctorService.getUpcomingAppointmentsForDoctor(2,LocalDate.now());
//            appointments.forEach(System.out::println);
//        	boolean isStatusUpdated = appointmentService.updateAppointmentStatus(2,1,2);
//            System.out.println("isStatusUpdated "+isStatusUpdated);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Failed to connect to Oracle!");
        }
        
    }
    
//    private static void createdRole(RoleService roleService, Role r) {
//		boolean isCreated=roleService.create(r);
//        if(isCreated) {
//        	System.out.println(r+" added to record");
//        }
//        else {
//        	System.out.println("Failed to added");
//        }
//	}
}
