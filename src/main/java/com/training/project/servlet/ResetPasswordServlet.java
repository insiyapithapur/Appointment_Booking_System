package com.training.project.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;
import org.hibernate.SessionFactory;


import com.training.project.service.UserService;

/**
 * Servlet implementation class resetPassword
 */
@WebServlet(name = "ResetPasswordServlet",urlPatterns= {"/UpdatePassword"})
public class ResetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ResetPasswordServlet() {
        super();
        System.out.println("reset password servlet");
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Please Enter Email");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		try{
			
			response.setContentType("text/html");

			// getting parameters from form
			String password = request.getParameter("password").trim();
			String confirmPassword = request.getParameter("confirmPassword").trim();

			request.setAttribute("password", password);
			request.setAttribute("confirmPassword", confirmPassword);
			HttpSession httpSession = request.getSession();
		    String storedUsername = (String) httpSession.getAttribute("username");

			UserService updateUserService = new UserService();
			
			String contextPath = request.getContextPath();
			if(password.equals(confirmPassword)) {
				System.out.println("confirmPassword"+confirmPassword);
			 if(updateUserService.resetPassword(storedUsername,confirmPassword)){
				 response.sendRedirect(contextPath);
				 httpSession.removeAttribute("email");
				 httpSession.invalidate();
			} 
			 else {
				  response.sendRedirect(contextPath + "/Forget.jsp");
			 }
			}
			else {
				String invalid = "Enter correct password";
				getServletContext().setAttribute("invalid", invalid);
				response.sendRedirect(contextPath + "/OtpVerification.jsp");
			}
			httpSession.invalidate();
		} catch (Exception e) {
			e.printStackTrace();
		
		}
		doGet(request, response);
		
	}

}
