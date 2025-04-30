package com.training.project.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.UserService;

/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private UserService userService;
	
	@Override
    public void init() throws ServletException {
        super.init();
        System.out.println("Logout servlet initialized");
        userService = new UserService();
    }
       
    /**
     * @see HttpServlet#HttpServlet()
     */
   
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 HttpSession session = request.getSession(false);
	        if (session != null) {
	        	Integer userId = (Integer) session.getAttribute("userId");
	            
	            if (userId != null) {
	                // Update the is_login status in the database
	            	userService.updateUserLoginStatus(userId);
	            }
	            
	        	session.removeAttribute("userId");
	        	session.removeAttribute("roleSpecificId");
	        	session.removeAttribute("roleName");
	        	session.removeAttribute("username");
	            session.invalidate(); // Destroy the session
	        }
	        response.sendRedirect(request.getContextPath() + "/Login.jsp"); // Redirect to login page
	}

	

}
