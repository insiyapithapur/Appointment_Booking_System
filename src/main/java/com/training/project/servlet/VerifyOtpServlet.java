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


@WebServlet(name = "VerifyOtpServlet",urlPatterns= {"/VerifyOtp"} )
public class VerifyOtpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public VerifyOtpServlet() {
        super();
        System.out.println("otp verification");
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Invalid ");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      SessionFactory sessionFactory = (SessionFactory) this.getServletContext().getAttribute("sessionFactory");
		try {
			
			String otp = request.getParameter("password");
			request.setAttribute("password", otp);
			
			String contextPath = request.getContextPath();
			
			HttpSession httpSession = request.getSession();
		    String storedOtp = (String) httpSession.getAttribute("otp"); // Retrieve OTP from session
		    System.out.println("verify otp "+storedOtp);
		    System.out.println("parameter otp"+otp);
			if (otp.equals(storedOtp)) {
				System.out.println("equals");
				response.sendRedirect(contextPath + "/UpdatePassword.jsp");
			} else {
				String invalid = "Enter correct otp";
				getServletContext().setAttribute("invalid", invalid);
				response.sendRedirect(contextPath + "/OtpVerification.jsp");
			}
		}

		catch (Exception e) {
			e.printStackTrace();
			doGet(request, response);
		}
		doGet(request, response);	}

}
