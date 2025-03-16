package com.training.project.servlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.training.project.service.RegisterService;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private RegisterService registerService;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		request.getRequestDispatcher("/Register.jsp").forward(request, response);
//		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
			
			response.setContentType("text/html");

			// getting parameters from form
			String userName = request.getParameter("user").trim();
			String password = request.getParameter("password").trim();


			request.setAttribute("userName", userName);
			request.setAttribute("password", password);

			registerService = new RegisterService();
			String contextPath = request.getContextPath();
			Integer userId = registerService.createUser(userName,password);
			 if(userId == 1){
				 String invalid = "User already Exist";
					getServletContext().setAttribute("invalid", invalid);
			} 
			 else {
				 request.getSession().setAttribute("userId", userId);
				 response.sendRedirect(contextPath+"/UserDetails.jsp");
				 
			 }
		} catch (Exception e) {
			e.printStackTrace();
		
		}
		doGet(request, response);
	}

}
