<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
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
            height: 100vh;
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
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: #96c8fb;
            color: white;
            font-size: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .avatar:hover {
            transform: scale(1.05);
        }
        
        .nav-item {
            padding: 12px 24px;
            margin: 5px 0;
            cursor: pointer;
            transition: all 0.3s;
            text-align: left;
        }
        
        .nav-item.active {
            background-color: #4CAF50;
            border-radius: 5px;
        }
        
        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        
        .patient-table-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            overflow: hidden;
        }
        
        .patient-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .patient-table th {
            background-color: #f5f5f5;
            color: #555;
            font-weight: 600;
            padding: 12px 15px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .patient-table tbody tr {
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .patient-table tbody tr:hover {
            background-color: rgba(79, 94, 149, 0.05);
        }
        
        .patient-table td {
            padding: 12px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #eee;
        }
        
        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 16px;
            margin-right: 10px;
        }
        
        .patient-status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            display: inline-block;
        }
        
        .status-active {
            background-color: #81C784;
            color: white;
        }
        
        .status-inactive {
            background-color: #E57373;
            color: white;
        }
        
        .status-new {
            background-color: #FFD54F;
            color: #664d03;
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
        
        /* Responsive styles */
        @media (max-width: 992px) {
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
            
            .patient-table-container {
                overflow-x: auto;
            }
            
            .patient-table th, 
            .patient-table td {
                white-space: nowrap;
            }
        }
        
        /* For very small screens */
        @media (max-width: 576px) {
            .content {
                padding: 15px 10px;
            }
            
            /* Hide less important columns on very small screens */
            .hide-xs {
                display: none;
            }
        }
        
        /* Alert styles for "No records found" */
        .alert-no-results {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            color: #6c757d;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
            width: 100%;
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar">Admin</div>
        <div class="doctor-name mb-4"></div>      
        <div class="nav-item" onclick="navigateTo('Admin/Dashboard')">Dashboard</div>
        <div class="nav-item active" onclick="navigateTo('Admin/Patients')">Patients</div>
        <div class="nav-item" onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Admin/Appointments')">Appointments</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
            Logout
        </div>
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
                        <select class="form-select" id="statusFilter" onchange="filterPatients()">
                            <option value="">All Statuses</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                            <option value="new">New</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-2 mb-md-0">
                        <select class="form-select" id="sortBy" onchange="sortPatients()">
                            <option value="nameAsc">Name (A-Z)</option>
                            <option value="nameDesc">Name (Z-A)</option>
                            <option value="idAsc">ID (Low-High)</option>
                            <option value="idDesc">ID (High-Low)</option>
                            <option value="recent">Recent Visit</option>
                        </select>
                    </div>
                    <div class="col-md-2 text-md-end">
                        <button class="btn btn-outline-secondary" onclick="resetFilters()">
                            <i class="fas fa-redo me-1"></i> Reset
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Patient Table -->
            <div class="patient-table-container">
                <table class="table patient-table" id="patientTable">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>ID</th>
                            <th>Blood Type</th>
                            <th class="hide-xs">Phone</th>
                            <th class="hide-xs">Last Visit</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="patientTableBody">
                        <%
                            List<Object[]> patients = (List<Object[]>) request.getAttribute("patients");
                            if (patients != null && !patients.isEmpty()) {
                                for (Object[] row : patients) {
                                    String initials = row[1].toString().charAt(0) + "" + row[2].toString().charAt(0);
                                    String bgColor = "#64B5F6"; // Default color
                                    
                                    // Randomly assign a status for demonstration purposes
                                    String[] statuses = {"active", "inactive", "new"};
                                    String status = statuses[(int)(Math.random() * 3)];
                                    String statusClass = "status-" + status;
                                    String statusText = status.substring(0, 1).toUpperCase() + status.substring(1);
                        %>
                        <tr class="patient-row" onclick="viewPatient('<%= row[3] %>')"
                            data-name="<%= row[1] %> <%= row[2] %>"
                            data-id="<%= row[3] %>"
                            data-blood="<%= row[0] %>"
                            data-status="<%= status %>"
                            data-phone="<%= row[6] %>"
                            data-recent="March 10, 2025">
                            <td>
                                <div class="d-flex align-items-center">
                                    <div><%= row[1] %> <%= row[2] %></div>
                                </div>
                            </td>
                            <td><%= row[3] %></td>
                            <td><%= row[0] %></td>
                            <td class="hide-xs"><%= row[6] %></td>
                            <td class="hide-xs">March 10, 2025</td>
                            <td><span class="patient-status-badge <%= statusClass %>"><%= statusText %></span></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr id="noResultsRow">
                            <td colspan="7" class="text-center py-4">
                                <div class="alert-no-results">
                                    <i class="fas fa-user-slash me-2"></i> No patients found
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
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            
            const formattedDateTime = now.toLocaleDateString('en-US', options);
            document.getElementById('current-datetime').textContent = formattedDateTime;
        }
        
        // Update date and time when page loads
        updateDateTime();
        
        // Update date and time every second
        setInterval(updateDateTime, 1000);
        
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        function navigateTo(page) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        function viewPatient(id) {
            // In a real application, this would navigate to the patient details page
            console.log("Viewing patient ID: " + id);
            window.location.href = 'patient-details.jsp?id=' + id;
        }
        
        function editPatient(id) {
            // In a real application, this would navigate to the patient edit page
            console.log("Editing patient ID: " + id);
            window.location.href = 'edit-patient.jsp?id=' + id;
        }
        
        // Filter functions
        function filterPatients() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const bloodType = document.getElementById('bloodTypeFilter').value;
            const status = document.getElementById('statusFilter').value;
            
            const patients = document.querySelectorAll('.patient-row');
            let visibleCount = 0;
            
            patients.forEach(patient => {
                const name = patient.getAttribute('data-name').toLowerCase();
                const id = patient.getAttribute('data-id');
                const phone = patient.getAttribute('data-phone');
                const patientBloodType = patient.getAttribute('data-blood');
                const patientStatus = patient.getAttribute('data-status');
                
                // Check if patient matches all selected filters
                const matchesSearch = name.includes(searchText) || 
                                     id.includes(searchText) || 
                                     phone.includes(searchText);
                const matchesBloodType = bloodType === '' || patientBloodType === bloodType;
                const matchesStatus = status === '' || patientStatus === status;
                
                // Show or hide based on filter results
                if (matchesSearch && matchesBloodType && matchesStatus) {
                    patient.style.display = '';
                    visibleCount++;
                } else {
                    patient.style.display = 'none';
                }
            });
            
            // Show "No results" message if no patients match filters
            const noResultsRow = document.getElementById('noResultsRow');
            if (noResultsRow) {
                if (visibleCount === 0 && patients.length > 0) {
                    // Create "no results" row if it doesn't exist
                    if (!document.getElementById('dynamicNoResults')) {
                        const tbody = document.getElementById('patientTableBody');
                        const noResultsTr = document.createElement('tr');
                        noResultsTr.id = 'dynamicNoResults';
                        noResultsTr.innerHTML = `
                            <td colspan="7" class="text-center py-4">
                                <div class="alert-no-results">
                                    <i class="fas fa-filter me-2"></i> No patients match your filters
                                </div>
                            </td>
                        `;
                        tbody.appendChild(noResultsTr);
                    }
                } else {
                    // Remove dynamic "no results" row if it exists
                    const dynamicNoResults = document.getElementById('dynamicNoResults');
                    if (dynamicNoResults) {
                        dynamicNoResults.remove();
                    }
                }
            }
        }
        
        function sortPatients() {
            const sortBy = document.getElementById('sortBy').value;
            const tbody = document.getElementById('patientTableBody');
            const patients = Array.from(document.querySelectorAll('.patient-row'));
            
            // Sort patients based on selected criteria
            patients.sort((a, b) => {
                switch(sortBy) {
                    case 'nameAsc':
                        return a.getAttribute('data-name').localeCompare(b.getAttribute('data-name'));
                    case 'nameDesc':
                        return b.getAttribute('data-name').localeCompare(a.getAttribute('data-name'));
                    case 'idAsc':
                        return parseInt(a.getAttribute('data-id')) - parseInt(b.getAttribute('data-id'));
                    case 'idDesc':
                        return parseInt(b.getAttribute('data-id')) - parseInt(a.getAttribute('data-id'));
                    case 'recent':
                        return b.getAttribute('data-recent').localeCompare(a.getAttribute('data-recent'));
                    default:
                        return 0;
                }
            });
            
            // Reappend sorted patients to the container
            const noResultsRow = document.getElementById('noResultsRow');
            
            // Clear tbody except for the no results row if it exists
            if (noResultsRow) {
                // If we have a static no results row, preserve it
                tbody.innerHTML = '';
                tbody.appendChild(noResultsRow);
            } else {
                tbody.innerHTML = '';
            }
            
            // Add the sorted rows back
            patients.forEach(patient => {
                tbody.appendChild(patient);
            });
            
            // Check if we need to add a dynamic "no results" row
            const dynamicNoResults = document.getElementById('dynamicNoResults');
            if (dynamicNoResults) {
                tbody.appendChild(dynamicNoResults);
            }
        }
        
        function resetFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('bloodTypeFilter').value = '';
            document.getElementById('statusFilter').value = '';
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