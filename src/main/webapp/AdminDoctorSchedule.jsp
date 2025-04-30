<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalTime" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Schedules</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inter font from Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            /* Sky blue theme colors */
            --primary-color: #4dabf7;
            --primary-light: #e7f5ff;
            --primary-dark: #339af0;
            --bg-color: #ffffff;
            --bg-secondary: #f8fafc;
            --sidebar-bg: #f8fafc;
            --text-primary: #2b3d4f;
            --text-secondary: #6c757d;
            --border-color: #dbe4ff;
            
            /* Status colors */
            --confirmed-color: #219653;
            --pending-color: #f2994a;
            --cancelled-color: #eb5757;
            --completed-color: #2f80ed;
            --active-color: #81C784;
            --inactive-color: #E57373;
            --new-color: #FFD54F;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-primary);
            line-height: 1.5;
            font-size: 14px;
        }
        
        /* Sidebar */
        .sidebar {
            position: fixed;
            width: 220px;
            height: 100vh;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--border-color);
            padding: 0 0 30px 0;
            z-index: 1000;
            transition: all 0.3s;
        }
        
        /* Updated profile section - LinkedIn style */
        .profile-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 20px;
            position: relative;
            border-bottom: 1px solid var(--border-color);
        }
        
        .profile-background {
            width: 100%;
            height: 80px;
            background-color: var(--primary-color);
            background-image: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8ZyBvcGFjaXR5PSIwLjIiIGZpbGw9IiNmZmZmZmYiPgogICAgPHBhdGggZD0iTTI1LDUwIEE4LDggMCAwLDEgMzMsNTggTDMzLDY1IEE4LDggMCAwLDEgMjUsNzMgTC0xNSw3MyBBOCw4IDAgMCwxIC0yMyw2NSBMLTI1LDYwIEE1LDUgMCAwLDEgLTIwLDU1IEwtNSw1NSBBNSw1IDAgMCwxIDAsNjAgTDAsNjUgQTIsIDIgMCAwLDAgMiw2NyBMMTAsNjcgQTIsIDIgMCAwLDAgMTIsNjUgTDEyLDYwIEE4LDggMCAwLDEgMjAsNTIgTDI1LDUwIFoiPgogICAgICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgZnJvbT0iMCA1MCA1MCIgdG89IjM2MCA1MCA1MCIgZHVyPSIxMHMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogICAgPC9wYXRoPgogICAgPHBhdGggZD0iTTkwLDUwIEE4LDggMCAwLDEgOTgsNTggTDk4LDY1IEE4LDggMCAwLDEgOTAsNzMgTDUwLDczIEE4LDggMCAwLDEgNDIsNjUgTDQwLDYwIEE1LDUgMCAwLDEgNDUsNTUgTDYwLDU1IEE1LDUgMCAwLDEgNjUsNjAgTDY1LDY1IEEyLCAyIDAgMCwwIDY3LDY3IEw3NSw2NyBBMiwgMiAwIDAsIDAgNzcsNjUgTDc3LDYwIEE4LDggMCAwLDEgODUsNTIgTDkwLDUwIFoiPgogICAgICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgZnJvbT0iMCA1MCA1MCIgdG89IjM2MCA1MCA1MCIgZHVyPSIxNXMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiAvPgogICAgPC9wYXRoPgogICAgPHBhdGggZD0iTTE1NSw1MCBBOCw4IDAgMCwxIDE2Myw1OCBMMTY1LDY1IEE4LDggMCAwLDEgMTU3LDczIEwxMTUsNzMgQTgsOCAwIDAsIDEgMTA3LDY1IEwxMDUsNjAgQTUsNSAwIDAsIDEgMTEwLDU1IEwxMjUsNTUgQTUsNSAwIDAsIDEgMTMwLDYwIEwxMzAsNjUgQTIsIDIgMCAwLDAgMTMyLDY3IEwxNDAsNjcgQTIsIDIgMCAwLDAgMTQyLDY1IEwxNDIsNjAgQTgsOCAwIDAsIDEgMTUwLDUyIEwxNTUsNTAgWiI+CiAgICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBmcm9tPSIwIDUwIDUwIiB0bz0iMzYwIDUwIDUwIiBkdXI9IjIwcyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+CiAgICA8L3BhdGg+CiAgICA8cGF0aCBkPSJNMjIwLDUwIEE4LDggMCAwLDEgMjI4LDU4IEwyMzAsNjUgQTgsOCAwIDAsIDEgMjIyLDczIEwxODAsNzMgQTgsOCAwIDAsIDEgMTcyLDY1IEwxNzAsNjAgQTUsNSAwIDAsIDEgMTc1LDU1IEwxOTAsNTUgQTUsNSAwIDAsIDEgMTk1LDYwIEwxOTUsNjUgQTIsIDIgMCAwLDAgMTk3LDY3IEwyMDUsNjcgQTIsIDIgMCAwLDAgMjA3LDY1IEwyMDcsNjAgQTgsOCAwIDAsIDEgMjE1LDUyIEwyMjAsNTAgWiI+CiAgICAgIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBmcm9tPSIwIDUwIDUwIiB0bz0iMzYwIDUwIDUwIiBkdXI9IjI1cyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIC8+CiAgICA8L3BhdGg+CiAgPC9nPgo8L3N2Zz4=');
            background-repeat: repeat;
        }
        
        .profile-avatar {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background-color: var(--primary-light);
            border: 4px solid white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: -45px;
            position: relative;
            font-weight: 600;
            font-size: 24px;
            color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .profile-name {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin-top: 12px;
            text-align: center;
            line-height: 1.2;
        }
        
        .profile-title {
            font-size: 12px;
            color: var(--text-secondary);
            margin-top: 4px;
            text-align: center;
            padding: 0 20px;
        }
        
        .profile-badge {
            display: inline-block;
            padding: 4px 10px;
            background-color: var(--primary-light);
            color: var(--primary-color);
            border-radius: 12px;
            font-size: 12px;
            margin-top: 10px;
            font-weight: 500;
        }
        
        .profile-badge i {
            margin-right: 4px;
            font-size: 10px;
        }
        
        .nav-menu {
            list-style-type: none;
            padding: 0 20px;
            margin-top: 20px;
        }
        
        .nav-item {
            margin-bottom: 10px;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            border-radius: 6px;
            text-decoration: none;
            color: var(--text-secondary);
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .nav-link.active {
            background-color: var(--primary-light);
            color: var(--primary-color);
            font-weight: 500;
        }
        
        .nav-link:hover:not(.active) {
            background-color: var(--bg-secondary);
            color: var(--primary-dark);
        }
        
        /* Main Content */
        .content {
            margin-left: 220px;
            padding: 30px;
            transition: all 0.3s;
        }
        
        /* Page header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 600; 
            color: var(--primary-color);
            margin-bottom: 4px;
        }
        
        .doctor-info {
            margin-bottom: 20px;
            padding: 20px;
            background-color: var(--primary-light);
            border-radius: 8px;
            border: 1px solid var(--border-color);
        }
        
        .doctor-info h2 {
            color: var(--text-primary);
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .doctor-info p {
            margin-bottom: 5px;
            color: var(--text-secondary);
        }
        
        .doctor-info .badge {
            font-size: 12px;
            padding: 5px 10px;
            margin-top: 10px;
            display: inline-block;
        }
        
        /* Schedule table */
        .schedule-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }
        
        .schedule-table th {
            background-color: var(--primary-light);
            color: var(--primary-color);
            font-weight: 600;
            padding: 12px 15px;
            text-align: left;
            border-top: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
        }
        
        .schedule-table th:first-child {
            border-left: 1px solid var(--border-color);
            border-top-left-radius: 8px;
        }
        
        .schedule-table th:last-child {
            border-right: 1px solid var(--border-color);
            border-top-right-radius: 8px;
        }
        
        .schedule-table td {
            padding: 12px 15px;
        }

        
        .schedule-table tr:last-child td:first-child {
            border-bottom-left-radius: 8px;
        }
        
        .schedule-table tr:last-child td:last-child {
            border-bottom-right-radius: 8px;
        }
        
        .schedule-table tbody tr:hover {
            background-color: var(--bg-secondary);
        }
        
        .badge-available {
            background-color: var(--active-color);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        .badge-unavailable {
            background-color: var(--inactive-color);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        .btn-schedule {
            font-size: 12px;
            padding: 5px 10px;
        }
        
        /* Alert */
        .alert {
            margin-bottom: 20px;
            padding: 12px 15px;
            border-radius: 6px;
            border: 1px solid transparent;
        }
        
        .alert-success {
            background-color: rgba(33, 150, 83, 0.1);
            border-color: rgba(33, 150, 83, 0.2);
            color: var(--confirmed-color);
        }
        
        .alert-danger {
            background-color: rgba(235, 87, 87, 0.1);
            border-color: rgba(235, 87, 87, 0.2);
            color: var(--cancelled-color);
        }
        
        /* Toggle Sidebar Button */
        .toggle-sidebar {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background-color: var(--bg-color);
            color: var(--primary-color);
            border: 1px solid var(--border-color);
            border-radius: 6px;
            width: 40px;
            height: 40px;
            cursor: pointer;
            transition: all 0.3s;
            align-items: center;
            justify-content: center;
        }
        
        .toggle-sidebar:hover {
            background-color: var(--primary-light);
        }
        
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.2);
            z-index: 999;
            backdrop-filter: blur(2px);
        }
        
        /* Responsive Styles */
        @media (max-width: 991px) {
            .sidebar {
                width: 200px;
            }
            .content {
                margin-left: 200px;
            }
        }
        
        @media (max-width: 768px) {
            .toggle-sidebar {
                display: flex;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .sidebar-overlay.active {
                display: block;
            }
            
            .content {
                margin-left: 0;
                padding: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .content {
                padding: 15px;
            }
            
            .hide-xs {
                display: none;
            }
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <!-- Updated LinkedIn-style profile section -->
        <div class="profile-section">
            <div class="profile-background"></div>
            <div class="profile-avatar">
                A
            </div>
            <div class="profile-name">Admin</div>
            <div class="profile-title">System Administrator</div>
            <div class="profile-badge">
                <i class="fas fa-circle"></i> Admin Portal
            </div>
        </div>
        
        <ul class="nav-menu">
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Dashboard')" class="nav-link">
                    <i class="fas fa-home"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Patients')" class="nav-link">
                    <i class="fas fa-user-injured"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Doctors')" class="nav-link active">
                    <i class="fas fa-user-md"></i> Doctors
                </a>
            </li>
            <li class="nav-item">
                <a onclick="navigateTo('Admin/Appointments')" class="nav-link">
                    <i class="fas fa-calendar-check"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>

    <div class="content">
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">Doctor Schedules</h1>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/Admin/Doctors" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i> Back to Doctors
                </a>
            </div>
        </div>
        
        <!-- Status Messages -->
        <% String status = request.getParameter("status"); %>
        <% if ("success".equals(status)) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i> Schedule updated successfully!
            </div>
        <% } else if ("error".equals(status)) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i> Failed to update schedule. Please try again.
            </div>
        <% } %>
        
        <!-- Doctor Information -->
        <%
		    List<Object[]> doctorList = (List<Object[]>) request.getAttribute("doctor");
		    Object[] doctor = (doctorList != null && !doctorList.isEmpty()) ? doctorList.get(0) : null;
		
		    String doctorFirstName = "";
		    String doctorLastName = "";
		    String specialization = "";
		    String experience = "";
		    String email = "";
		
		    if (doctor != null) {
		        doctorFirstName = (String) doctor[6];
		        doctorLastName = (String) doctor[7];
		        specialization = (String) doctor[1];
		        experience = String.valueOf(doctor[3]);
		        email = (String) doctor[10];
		    }
		%>

        
        <div class="doctor-info">
            <h2><i class="fas fa-user-md me-2"></i> Dr. <%= doctorFirstName %> <%= doctorLastName %></h2>
            <p><strong>Specialization:</strong> <%= specialization %></p>
            <p><strong>Experience:</strong> <%= experience %> years</p>
            <p><strong>Email:</strong> <%= email %></p>
        </div>
        
        <!-- Schedules Table -->
            <div class="card-body">
                <table class="schedule-table">
                    <thead>
                        <tr>
                            <th>Day</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Max Tokens</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Object[]> schedules = (List<Object[]>) request.getAttribute("schedules");
                            if (schedules != null && !schedules.isEmpty()) {
                                for (Object[] schedule : schedules) {
                                    Integer scheduleId = (Integer) schedule[0];
                                    Integer dayOfWeekInt = (Integer) schedule[2];
                                    String dayOfWeek = "";
                                    switch (dayOfWeekInt) {
                                        case 1: dayOfWeek = "Monday"; break;
                                        case 2: dayOfWeek = "Tuesday"; break;
                                        case 3: dayOfWeek = "Wednesday"; break;
                                        case 4: dayOfWeek = "Thursday"; break;
                                        case 5: dayOfWeek = "Friday"; break;
                                        case 6: dayOfWeek = "Saturday"; break;
                                        case 7: dayOfWeek = "Sunday"; break;
                                        default: dayOfWeek = "Unknown"; break;
                                    }
                                    String startTime = schedule[3].toString();
                                    String endTime = schedule[4].toString();
                                    Integer maxTokens = (Integer) schedule[5];
                                    Boolean isAvailable = (Boolean) schedule[6];
                        %>
                        <tr>
                            <td><strong><%= dayOfWeek %></strong></td>
                            <td><%= startTime %></td>
                            <td><%= endTime %></td>
                            <td><%= maxTokens %></td>
                            <td>
                                <% if (isAvailable) { %>
                                    <span class="badge-available">Available</span>
                                <% } else { %>
                                    <span class="badge-unavailable">Unavailable</span>
                                <% } %>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/Admin/DoctorSchedules" method="post" style="display:inline-block;">
								    <input type="hidden" name="scheduleId" value="<%= scheduleId %>">
								    <input type="hidden" name="doctorId" value="<%= doctor[0] %>">
								    <% if (isAvailable) { %>
								        <input type="hidden" name="availability" value="false">
								        <button type="submit" class="btn btn-sm btn-danger btn-schedule">
								            <i class="fas fa-ban me-1"></i> Make Unavailable
								        </button>
								    <% } else { %>
								        <input type="hidden" name="availability" value="true">
								        <button type="submit" class="btn btn-sm btn-success btn-schedule">
								            <i class="fas fa-check-circle me-1"></i> Make Available
								        </button>
								    <% } %>
								</form>
							</td>
						</tr>
						<%
								}
							} else {
						%>
						<tr>
							<td colspan="6" class="text-center py-4">
								 <div class="alert-no-results">
								            <i class="fas fa-calendar-times me-2"></i> No schedules found for this doctor
								        </div>
								  </td>
						</tr>
								<%
								    }
								%>
                    </tbody>
                </table>
            </div>
        </div>
    
    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to toggle sidebar on mobile
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        // Function for navigation
        function navigateTo(page) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        // Initialize tooltips
        $(function () {
            $('[data-bs-toggle="tooltip"]').tooltip();
            
            // Handle responsive behavior
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    document.getElementById("sidebar").classList.remove("active");
                    document.getElementById("sidebar-overlay").classList.remove("active");
                }
            });
        });
    </script>
</body>
</html>