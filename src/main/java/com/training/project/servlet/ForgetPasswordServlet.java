package com.training.project.servlet;
import java.io.IOException;
import java.security.SecureRandom;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.training.project.service.UserService;

@WebServlet(name = "ForgetPasswordServlet", urlPatterns = { "/Forget" })
public class ForgetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ForgetPasswordServlet() {
		super();
		System.out.println("forget password");
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Redirect to the forget password page instead of showing error message
		response.sendRedirect(request.getContextPath() + "/ForgetPassword.jsp");
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			UserService userService = new UserService();
			String otp = generateOTP(6);
			
			// Get username from the request
			String username = request.getParameter("username").trim();
			
			// Store username in request
			request.setAttribute("username", username);
			HttpSession httpSession = request.getSession();
			String contextPath = request.getContextPath();
			
			// Get user's email based on username and send OTP
			if (userService.sendEmailByUsername(username, otp)) {
				System.out.println("otp forget password "+otp);
				httpSession.setAttribute("otp", otp);
				httpSession.setAttribute("username", username);
				System.out.println("contextPath "+contextPath);
				response.sendRedirect(contextPath + "/OtpVerification.jsp");
			} else {
				String invalid = "Username Doesn't Exist";
				getServletContext().setAttribute("invalid", invalid);
				response.sendRedirect(contextPath + "/ForgetPassword.jsp");
			}
		}
		catch (Exception e) {
			// Log the exception
			e.printStackTrace();
			
			// Set error message
			String invalid = "An error occurred. Please try again.";
			getServletContext().setAttribute("invalid", invalid);
			response.sendRedirect(request.getContextPath() + "/ForgetPassword.jsp");
		}
	}
	
	public String generateOTP(int length) {
		String digits = "0123456789";
		SecureRandom secureRandom = new SecureRandom();
		StringBuilder otp = new StringBuilder();
		for (int i = 0; i < length; i++) {
			otp.append(digits.charAt(secureRandom.nextInt(digits.length())));
		}
		return otp.toString();
	}
}