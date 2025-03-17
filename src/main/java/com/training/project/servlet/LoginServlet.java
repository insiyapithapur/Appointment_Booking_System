package com.training.project.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.training.project.service.DoctorService;
import com.training.project.service.PatientService;
import com.training.project.service.UserService;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Login servlet initialized");
        userService = new UserService();
    }

	public LoginServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			
//			response.getWriter().append("Invalid try again ");
		   request.getRequestDispatcher("/Login.jsp").forward(request, response);
		}
		
		protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
			try{
				response.setContentType("text/html");
	
				// getting parameters from form
				String username = request.getParameter("username").trim();
				System.out.println("username "+username);
				String password = request.getParameter("password").trim();
				System.out.println("password "+password);
				// setting attributes
				request.setAttribute("username", username);
				request.setAttribute("password", password);
	
				String contextPath = request.getContextPath();
				
				if(userService.checkUser(username)) {
						List<Object> userDetails = userService.checkPassword(username,password);
						System.out.println("userDetails LOGIN"+userDetails.get(0));
						if (userDetails != null) {
						    Integer userId = (Integer) userDetails.get(0);
						    Integer roleSpecificId = (Integer) userDetails.get(1);
						    String roleName = (String) userDetails.get(2);
						    String storedUsername = (String) userDetails.get(3);
						    
						    // Store in session
						    request.getSession().setAttribute("userId", userId);
						    request.getSession().setAttribute("roleSpecificId", roleSpecificId);
						    request.getSession().setAttribute("roleName", roleName);
						    request.getSession().setAttribute("username", storedUsername);
						    
						    String destination = "";
			                if ("ADMIN".equalsIgnoreCase(roleName)) {
			                    destination = "/Admin/Dashboard";
			                } else if ("DOCTOR".equalsIgnoreCase(roleName)) {
			                	System.out.println("destination "+destination);
			                    destination = "/Doctor/Dashboard";
			                } else if ("PATIENT".equalsIgnoreCase(roleName)) {
			                    destination = "/Patient/Dashboard";
			                }
			                
			                // Use RequestDispatcher to forward the request
			                request.getRequestDispatcher(destination).forward(request, response);
			                return; // Important to prevent further execution
						    
//						    request.getRequestDispatcher("/Dashboard").forward(request, response);
//			                return;
						}
						else {
							System.out.println("login servlet pass");
							String invalid = "Password Doesn't match";
							getServletContext().setAttribute("invalid", invalid);
							response.sendRedirect(contextPath+"/Login");
						}
					}
				else{
					System.out.println("login servlet");
					String invalid2 = "User Doesn't Exist";
					getServletContext().setAttribute("invalid2", invalid2);
					response.sendRedirect(contextPath+"/Login");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		
	
		doGet(request, response);
		}

}
