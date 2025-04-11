<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f5e95;
            --primary-color: #4f5e95;
            --light-bg: #f7f9fc;
            --confirmed-color: #e8f5e9;
            --pending-color: #e3f2fd;
            --text-color: #333;
        }
        
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-bg);
        }
        
        .sidebar {
            background-color: var(--sidebar-bg);
            color: white;
            min-height: 100vh;
            position: fixed;
            width: 250px;
            padding: 20px 0;
            text-align: center;
            transition: all 0.3s;
            z-index: 1000;
            overflow-y: auto;
        }
        
        .content {
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s;
        }
        
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #96c8fb;
            color: white;
            font-size: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .avatar:hover {
            transform: scale(1.05);
        }
        
        .nav-item {
            padding: 15px 24px;
            margin: 5px 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: left;
            border-radius: 5px;
        }
        
        .nav-item.active {
            background-color: #81c784;
            font-weight: bold;
        }
        
        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        
        .appointment-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .appointment-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: all 0.3s;
            height: 100%;
        }
        
        .appointment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .appointment-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .appointment-info {
            flex-grow: 1;
        }
        
        .appointment-name {
            font-size: 18px;
            font-weight: bold;
            color: var(--text-color);
            margin-bottom: 5px;
        }
        
        .appointment-details {
            color: #777;
            font-size: 14px;
            margin-bottom: 3px;
        }
        
        .appointment-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            text-align: center;
            margin-top: 10px;
            display: inline-block;
        }
        
        .status-confirmed {
            background-color: var(--confirmed-color);
            color: #2e7d32;
        }
        
        .status-pending {
            background-color: #fff8e1;
            color: #f57f17;
        }
        
        .status-cancelled {
            background-color: #ffebee;
            color: #c62828;
        }
        
        .status-completed {
            background-color: var(--pending-color);
            color: #1565c0;
        }
        
        .toggle-sidebar {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1001;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 8px 12px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .toggle-sidebar:hover {
            background-color: #3d4a75;
        }
        
        .sidebar-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }
        
        /* Table styles */
        .appointment-table {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .appointment-table th {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 15px;
            font-weight: 500;
        }
        
        .appointment-table td {
            padding: 12px 15px;
            vertical-align: middle;
        }
        
        .appointment-table tbody tr {
            transition: all 0.3s;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .appointment-table tbody tr:hover {
            background-color: rgba(79, 94, 149, 0.05);
        }
        
        /* Custom badge styles with CSS variables */
        .badge-confirmed {
            background-color: var(--confirmed-color);
            color: #2e7d32;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-pending {
            background-color: #fff8e1;
            color: #f57f17;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-cancelled {
            background-color: #ffebee;
            color: #c62828;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        .badge-completed {
            background-color: var(--pending-color);
            color: #1565c0;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }
        
        /* Pagination styles */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        
        /* Filter styles */
        .filters-row {
            background-color: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .search-box {
            position: relative;
        }
        
        .search-box .search-icon {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        .search-box input {
            padding-left: 40px;
            border-radius: 50px;
            border: 1px solid #ddd;
        }
        
        .btn-reset {
            border-color: #ddd;
            background-color: white;
            color: #666;
            transition: all 0.3s ease;
        }
        
        .btn-reset:hover {
            background-color: #61CE70;
            border-color: #61CE70;
            color: white;
        }
        
        /* Container for the reset button */
        .reset-container {
            display: flex;
            justify-content: flex-end;
        }
        
        /* Action buttons */
        .btn-group .btn {
            padding: 5px 10px;
            margin-right: 5px;
        }
        
        /* Responsive styles */
        @media (max-width: 1200px) {
            .appointment-list {
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            }
        }
        
        @media (max-width: 991px) {
            .sidebar {
                width: 220px;
            }
            .content {
                margin-left: 220px;
            }
        }
        
        @media (max-width: 768px) {
            .toggle-sidebar {
                display: block;
            }
            .sidebar {
                transform: translateX(-100%);
                width: 250px;
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .sidebar-overlay.active {
                display: block;
            }
            .content {
                margin-left: 0;
            }
            .filters-row .col-md-3 {
                margin-bottom: 10px;
            }
        }
        
        @media (max-width: 576px) {
            .content {
                padding: 15px 10px;
            }
            .appointment-table {
                font-size: 14px;
            }
            .appointment-table th,
            .appointment-table td {
                padding: 10px 8px;
            }
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar" onclick="navigateTo('profile.jsp')">MD+</div>
        <div class="doctor-name mb-4">${doctorName}</div>
        
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/Doctor/Dashboard'">Dashboard</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/Doctor/Patient'">Patients</div>
        <div class="nav-item active" onclick="window.location.href='${pageContext.request.contextPath}/Doctor/Appointment'">Appointments</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/Doctor/Profile'">Profile</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
    Logout
</div>
    </div>

    <div class="content">
        <h2>Appointments</h2>
        <p class="text-muted" id="current-datetime"></p>
        
        <div class="container-fluid px-0">
            
            
            <!-- Appointments Table -->
            <div class="card appointment-table">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty appointmentDetails}">
                            <div class="table-responsive">
                                <table class="table mb-0" id="appointmentTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Patient</th>
                                            <th>Contact</th>
                                            <th>Date</th>
                                            <th>Token</th>
                                            <th>Reason</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${appointmentDetails}" var="appointment" varStatus="status">
                                            <%-- Parse the appointment string --%>
                                            <% 
                                            String appointmentStr = (String)pageContext.getAttribute("appointment");
                                            String[] parts = appointmentStr.split("\\|");
                                            
                                            String patientName = "N/A";
                                            String contactNumber = "N/A";
                                            String formattedDate = "N/A";
                                            String tokenNo = "N/A";
                                            String reasonText = "N/A";
                                            String statusValue = "N/A";
                                            
                                            for (String part : parts) {
                                                part = part.trim();
                                                if (part.startsWith("Patient:")) {
                                                    patientName = part.substring("Patient:".length()).trim();
                                                } else if (part.startsWith("Contact:")) {
                                                    contactNumber = part.substring("Contact:".length()).trim();
                                                } else if (part.startsWith("Date:")) {
                                                    formattedDate = part.substring("Date:".length()).trim();
                                                } else if (part.startsWith("Token:")) {
                                                    tokenNo = part.substring("Token:".length()).trim();
                                                } else if (part.startsWith("Reason:")) {
                                                    reasonText = part.substring("Reason:".length()).trim();
                                                } else if (part.startsWith("Status:")) {
                                                    statusValue = part.substring("Status:".length()).trim();
                                                }
                                            }
                                            
                                            pageContext.setAttribute("patientName", patientName);
                                            pageContext.setAttribute("contactNumber", contactNumber);
                                            pageContext.setAttribute("formattedDate", formattedDate);
                                            pageContext.setAttribute("tokenNo", tokenNo);
                                            pageContext.setAttribute("reasonText", reasonText);
                                            pageContext.setAttribute("statusValue", statusValue);
                                            
                                            // Get initials for avatar
                                            String initials = "NA";
                                            if (!patientName.equals("N/A") && patientName.length() > 1) {
                                                String[] nameParts = patientName.split(" ");
                                                if (nameParts.length > 1) {
                                                    initials = nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1);
                                                } else {
                                                    initials = nameParts[0].substring(0, 1);
                                                }
                                            }
                                            pageContext.setAttribute("initials", initials.toUpperCase());
                                            
                                            // Set avatar color based on status
                                            String avatarColor = "#64B5F6"; // Default blue
                                            if (statusValue.equals("CONFIRMED")) {
                                                avatarColor = "#81C784"; // Green
                                            } else if (statusValue.equals("PENDING")) {
                                                avatarColor = "#FFD54F"; // Yellow
                                            } else if (statusValue.equals("CANCELLED")) {
                                                avatarColor = "#E57373"; // Red
                                            }
                                            pageContext.setAttribute("avatarColor", avatarColor);
                                            %>
                                            
                                            <tr data-patient="${patientName}" 
                                                data-contact="${contactNumber}" 
                                                data-date="${formattedDate}" 
                                                data-status="${statusValue}"
                                                data-token="${tokenNo}"
                                                data-reason="${reasonText}">
                                                <td>${status.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="appointment-avatar me-2" style="background-color: ${avatarColor}; width: 35px; height: 35px; font-size: 14px;">
                                                            ${initials}
                                                        </div>
                                                        ${patientName}
                                                    </div>
                                                </td>
                                                <td>${contactNumber}</td>
                                                <td>${formattedDate}</td>
                                                <td>${tokenNo}</td>
                                                <td>${reasonText}</td>
                                                <td>
                                                    <span class="badge-${fn:toLowerCase(statusValue)}">
                                                        ${statusValue}
                                                    </span>
                                                </td>
                                                <td>
                                <c:choose>
								    <c:when test="${statusValue eq 'Completed'}">
								        <!-- If completed: View enabled, Complete disabled -->
								        <a href="${pageContext.request.contextPath}/Doctor/ViewMedicalRecord?appointmentId=${appointment.appointmentId}"
								           class="btn btn-sm btn-primary" style="background-color: #61CE70; border-color: #61CE70;">
								            <i class="fas fa-eye"></i> View
								        </a>
								    </c:when>
								    <c:when test="${statusValue eq 'Cancelled'}">
								        <!-- If cancelled: No button shown -->
								        <span class="text-muted">NA</span>
								    </c:when>
								    <c:otherwise>
								        <!-- If pending/confirmed: Complete enabled -->
								        <a href="${pageContext.request.contextPath}/Doctor/CompleteAppointment?appointmentId=${appointment.appointmentId}"
								           class="btn btn-sm btn-success" style="background-color: #61CE70; border-color: #61CE70;">
								            <i class="fas fa-check-circle"></i> Complete
								        </a>
								    </c:otherwise>
								</c:choose>
                               </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info text-center m-3">
                                No appointments found for this doctor.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to update date and time
        function updateDateTime() {
            const now = new Date();
            
            // Format the date: Weekday, Month Day, Year
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric'
            };
            
            const formattedDateTime = now.toLocaleDateString('en-US', options);
            document.getElementById('current-datetime').textContent = formattedDateTime;
        }
        
        // Update date and time when page loads
        updateDateTime();
        
        // Update date and time every minute
        setInterval(updateDateTime, 60000);
        
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        function navigateTo(page) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        function viewAppointmentDetails(appointmentData) {
            alert('Appointment Details:\n' + appointmentData);
        }
        
        // Filter functions
        function filterAppointments() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            
            const rows = document.querySelectorAll('#appointmentTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const patient = row.getAttribute('data-patient').toLowerCase();
                const contact = row.getAttribute('data-contact').toLowerCase();
                const date = row.getAttribute('data-date').toLowerCase();
                const reason = row.getAttribute('data-reason').toLowerCase();
                const status = row.getAttribute('data-status');
                
                // Check if appointment matches all selected filters
                const matchesSearch = patient.includes(searchText) || 
                                     contact.includes(searchText) || 
                                     date.includes(searchText) ||
                                     reason.includes(searchText);
                const matchesStatus = statusFilter === '' || status === statusFilter;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Handle no results message if needed
        }
        
        function sortAppointments() {
            const sortBy = document.getElementById('sortBy').value;
            const table = document.getElementById('appointmentTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Sort rows based on selected criteria
            rows.sort((a, b) => {
                switch(sortBy) {
                    case 'dateAsc':
                        return new Date(a.getAttribute('data-date')) - new Date(b.getAttribute('data-date'));
                    case 'dateDesc':
                        return new Date(b.getAttribute('data-date')) - new Date(a.getAttribute('data-date'));
                    case 'nameAsc':
                        return a.getAttribute('data-patient').localeCompare(b.getAttribute('data-patient'));
                    case 'nameDesc':
                        return b.getAttribute('data-patient').localeCompare(a.getAttribute('data-patient'));
                    default:
                        return 0;
                }
            });
            
            // Reappend sorted rows to the tbody
            rows.forEach(row => {
                tbody.appendChild(row);
            });
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('sortBy').value = 'dateAsc';
            
            filterAppointments();
        }
        
        
        
        // Handle responsive behavior
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                document.getElementById("sidebar").classList.remove("active");
                document.getElementById("sidebar-overlay").classList.remove("active");
            }
        });
    </script>
</body>
</html>