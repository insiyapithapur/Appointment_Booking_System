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
    <title>Patient List</title>
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
        
        .patient-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
            margin-right: 10px;
        }
        
        .patient-info {
            display: flex;
            align-items: center;
        }
        
        .patient-table {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .patient-table th {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 15px;
            font-weight: 500;
        }
        
        .patient-table td {
            padding: 12px 15px;
            vertical-align: middle;
        }
        
        .patient-table tbody tr {
            transition: all 0.3s;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .patient-table tbody tr:hover {
            background-color: rgba(79, 94, 149, 0.05);
            cursor: pointer;
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
        
        /* Responsive styles */
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
            .patient-table {
                font-size: 14px;
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
        
        <div class="nav-item" onclick="navigateTo('Doctor/Dashboard')">Dashboard</div>
        <div class="nav-item active" onclick="navigateTo('Doctor/Patient')">Patients</div>
        <div class="nav-item" onclick="navigateTo('Doctor/Appointment')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('Doctor/Profile')">Profile</div>
    </div>

    <div class="content">
        <h2>Patients</h2>
        <p class="text-muted" id="current-datetime"></p>
        
        <div class="container-fluid px-0">
          
            <!-- Filters Row -->
            <div class="filters-row mb-4">
                <div class="row align-items-center">
                    <div class="col-md-4 mb-2 mb-md-0">
                        <div class="search-box">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" class="form-control" id="searchInput" placeholder="Search patients..." oninput="filterPatients()">
                        </div>
                    </div>
                    <div class="col-md-2 mb-2 mb-md-0">
                        <select class="form-select" id="bloodTypeFilter" onchange="filterPatients()">
                            <option value="">All Blood Types</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                        </select>
                    </div>
                    
                    <div class="col-md-2 mb-2 mb-md-0">
                        <select class="form-select" id="sortBy" onchange="sortPatients()">
                            <option value="nameAsc">Name (A-Z)</option>
                            <option value="nameDesc">Name (Z-A)</option>
                            <option value="idAsc">ID (Low-High)</option>
                            <option value="idDesc">ID (High-Low)</option>
                        </select>
                    </div>
                    <div class="col-md-2 text-md-end">
                        <div class="reset-container">
                            <button class="btn btn-reset" onclick="resetFilters()">
                                <i class="fas fa-redo me-1"></i> Reset
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Patients Table -->
            <div class="card patient-table">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table mb-0" id="patientTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Blood Type</th>
                                    <th>Age</th>
                                    <th>Gender</th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Object[]> patients = (List<Object[]>) request.getAttribute("patients");
                                    if (patients != null && !patients.isEmpty()) {
                                        for (Object[] row : patients) {
                                            String initials = row[1].toString().charAt(0) + "" + row[2].toString().charAt(0);
                                            
                                            // Use color based on blood type
                                            String bloodType = row[0].toString();
                                            String bgColor = "#64B5F6"; // Default color
                                            
                                            // Map blood types to different colors
                                            if (bloodType.startsWith("A")) {
                                                bgColor = "#4CAF50"; // Green
                                            } else if (bloodType.startsWith("B")) {
                                                bgColor = "#FF9800"; // Orange
                                            } else if (bloodType.startsWith("AB")) {
                                                bgColor = "#9C27B0"; // Purple
                                            } else if (bloodType.startsWith("O")) {
                                                bgColor = "#F44336"; // Red
                                            }
                                            
                                            String fullName = row[1].toString() + " " + row[2].toString();
                                            String patientId = row[3].toString();
                                            String age = row[4].toString();
                                            String gender = row[5].toString();
                                            String phone = row[6].toString();
                                            String email = row[7].toString();
                                %>
                                <tr data-id="<%= patientId %>" 
                                    data-name="<%= fullName %>"
                                    data-blood="<%= bloodType %>"
                                    data-phone="<%= phone %>"
                                    data-email="<%= email %>"
                                    onclick="viewPatient(<%= patientId %>)">
                                    <td><%= patientId %></td>
                                    <td>
                                        <div class="patient-info">
                                            <div class="patient-avatar" style="background-color: <%= bgColor %>;">
                                                <%= initials.toUpperCase() %>
                                            </div>
                                            <%= fullName %>
                                        </div>
                                    </td>
                                    <td><%= bloodType %></td>
                                    <td><%= age %></td>
                                    <td><%= gender %></td>
                                    <td><%= phone %></td>
                                    <td><%= email %></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-danger" id="noResults">No patients found</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
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
        
        function viewPatient(id) {
            console.log("Viewing patient ID: " + id);
            window.location.href = 'patient-details.jsp?id=' + id;
        }
        
        // Filter functions
        function filterPatients() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const bloodType = document.getElementById('bloodTypeFilter').value;
            
            const rows = document.querySelectorAll('#patientTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                // Skip the "No patients found" row if present
                if (row.cells.length === 1 && row.cells[0].id === 'noResults') {
                    return;
                }
                
                const name = row.getAttribute('data-name').toLowerCase();
                const id = row.getAttribute('data-id');
                const phone = row.getAttribute('data-phone');
                const email = row.getAttribute('data-email').toLowerCase();
                const patientBloodType = row.getAttribute('data-blood');
                
                // Check if patient matches all selected filters
                const matchesSearch = name.includes(searchText) || 
                                     id.includes(searchText) || 
                                     phone.includes(searchText) ||
                                     email.includes(searchText);
                const matchesBloodType = bloodType === '' || patientBloodType === bloodType;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesBloodType) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Show "No results" message if no patients match filters
            const noResultsRow = document.getElementById('noResults');
            if (noResultsRow) {
                if (visibleCount === 0) {
                    noResultsRow.parentElement.style.display = '';
                } else {
                    noResultsRow.parentElement.style.display = 'none';
                }
            }
        }
        
        function sortPatients() {
            const sortBy = document.getElementById('sortBy').value;
            const table = document.getElementById('patientTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            // Filter out the "No patients found" row if present
            const dataRows = rows.filter(row => row.cells.length > 1 || row.cells[0].id !== 'noResults');
            
            // Sort patients based on selected criteria
            dataRows.sort((a, b) => {
                switch(sortBy) {
                    case 'nameAsc':
                        return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                    case 'nameDesc':
                        return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
                    case 'idAsc':
                        return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
                    case 'idDesc':
                        return parseInt(b.getAttribute('data-id')) - parseInt(a.getAttribute('data-id'));
                    default:
                        return 0;
                }
            });
            
            // Clear the table body
            tbody.innerHTML = '';
            
            // Reappend sorted rows to the tbody
            dataRows.forEach(row => {
                tbody.appendChild(row);
            });
            
            // Add back the "No results" row if needed
            const noResultsRow = rows.find(row => row.cells.length === 1 && row.cells[0].id === 'noResults');
            if (noResultsRow) {
                tbody.appendChild(noResultsRow);
            }
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('bloodTypeFilter').value = '';
            document.getElementById('sortBy').value = 'nameAsc';
            
            filterPatients();
            sortPatients();
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