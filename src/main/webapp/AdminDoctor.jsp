<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor List</title>
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
        
        .doctor-table-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .doctor-table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .doctor-table th {
            background-color: #f5f5f5;
            color: #555;
            font-weight: 600;
            padding: 12px 15px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .doctor-table tbody tr {
            transition: all 0.2s;
            cursor: pointer;
        }
        
        .doctor-table tbody tr:hover {
            background-color: rgba(79, 94, 149, 0.05);
        }
        
        .doctor-table td {
            padding: 12px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #eee;
        }
        
        .doctor-avatar {
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
        
        .specialization-badge {
            background-color: #81C784;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
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
        
        /* Filter section styles */
        .filter-section {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }
        
        .filter-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 15px;
        }
        
        .filter-badge {
            background-color: var(--primary-color);
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 12px;
            display: inline-flex;
            align-items: center;
            margin-right: 8px;
            cursor: pointer;
        }
        
        .filter-badge span {
            margin-left: 5px;
            font-weight: bold;
        }
        
        .clear-filters {
            color: var(--primary-color);
            background: none;
            border: none;
            font-size: 14px;
            cursor: pointer;
            padding: 0;
            font-weight: 500;
        }
        
        .clear-filters:hover {
            text-decoration: underline;
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
            .filter-row {
                flex-direction: column;
            }
            .filter-row > div {
                margin-bottom: 15px;
                width: 100%;
            }
            
            .doctor-table-container {
                overflow-x: auto;
            }
            
            .doctor-table th, 
            .doctor-table td {
                white-space: nowrap;
            }
        }
        
        @media (max-width: 576px) {
            .content {
                padding: 15px 10px;
            }
            
            /* Hide less important columns on very small screens */
            .hide-xs {
                display: none;
            }
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
        <div class="nav-item" onclick="navigateTo('Admin/Patients')">Patients</div>
        <div class="nav-item active" onclick="navigateTo('Admin/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Admin/Appointments')">Appointments</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
            Logout
        </div>
    </div>

    <div class="content">
        <h2>Doctors</h2>
        <p class="text-muted" id="current-datetime"></p>
        
        <div class="container-fluid px-0">
            <div class="d-flex justify-content-end align-items-center mb-4">
                <button class="btn btn-primary" onclick="navigateTo('AdminAddDoctor.jsp')">
                    <i class="fas fa-plus-circle me-2"></i> Add New Doctor
                </button>
            </div>
            
            <!-- Filter Section - Simplified to only include search and specialization -->
            <div class="filter-section mb-3">
                <div class="d-flex justify-content-between align-items-center">
                    <!-- Search Filter -->
                    <div class="me-2" style="width: 40%;">
                        <input type="text" id="search-filter" class="form-control" placeholder="Search by name or license..." oninput="applyFilters()">
                    </div>
                    
                    <!-- Specialization Filter -->
                    <div class="me-2" style="width: 40%;">
                        <select id="specialization-filter" class="form-select" onchange="applyFilters()">
                            <option value="">All Specializations</option>
                            <option value="Cardiology">Cardiology</option>
                            <option value="Neurology">Neurology</option>
                            <option value="Orthopedics">Orthopedics</option>
                            <option value="Pediatrics">Pediatrics</option>
                            <option value="Dermatology">Dermatology</option>
                            <option value="Oncology">Oncology</option>
                            <option value="Gynecology">Gynecology</option>
                            <option value="Ophthalmology">Ophthalmology</option>
                        </select>
                    </div>
                    
                    <!-- Clear Filters Button -->
                    <button class="clear-filters" onclick="clearAllFilters()">Clear All Filters</button>
                </div>
                
                <!-- Active Filters Display -->
                <div class="mt-3">
                    <div class="filter-badges" id="active-filters">
                        <!-- Active filters will be displayed here -->
                    </div>
                </div>
            </div>
            
            <!-- Doctor Table -->
            <div class="doctor-table-container">
                <table class="table doctor-table" id="doctor-table">
                    <thead>
                        <tr>
                            <th>Doctor</th>
                            <th>License</th>
                            <th>Specialization</th>
                            <th class="hide-xs">Experience</th>
                            <th class="hide-xs">Contact</th>
                            <th class="hide-xs">Email</th>
                        </tr>
                    </thead>
                    <tbody id="doctor-table-body">
                        <%
                            List<Object[]> doctors = (List<Object[]>) request.getAttribute("doctors");
                            if (doctors != null && !doctors.isEmpty()) {
                                for (Object[] row : doctors) {
                                    String[] colors = {"#42A5F5", "#66BB6A", "#FFA726", "#EC407A", "#AB47BC"};
                                    int colorIndex = Math.abs(row[0].toString().hashCode()) % colors.length;
                                    String bgColor = colors[colorIndex];
                                    
                                    // Get initials from first and last name
                                    String initials = row[4].toString().charAt(0) + "" + row[5].toString().charAt(0);
                        %>
                        <tr class="doctor-row"
                            data-name="<%= row[4] %> <%= row[5] %>" 
                            data-license="<%= row[1] %>"
                            data-specialization="<%= row[1] %>">
                            <td>
                                <div class="d-flex align-items-center">
                                    <div>Dr. <%= row[5] %> <%= row[6] %></div>
                                </div>
                            </td>
                            <td><%= row[2] %></td>
                            <td><%= row[1] %></td>
                            <td class="hide-xs"><%= row[3] %> years</td>
                            <td class="hide-xs"><%= row[10] %></td>
                            <td class="hide-xs"><%= row[8] %></td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr id="no-results-row">
                            <td colspan="7" class="text-center py-4">
                                <div class="alert-no-results">
                                    <i class="fas fa-user-md-slash me-2"></i> No doctors found
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
        
        function viewDoctor(username) {
            // In a real application, this would navigate to the doctor details page
            console.log("Viewing doctor: " + username);
            window.location.href = 'doctor-details.jsp?username=' + username;
        }
        
        function editDoctor(username) {
            // In a real application, this would navigate to the doctor edit page
            console.log("Editing doctor: " + username);
            window.location.href = 'edit-doctor.jsp?username=' + username;
        }
        
        function deleteDoctor(username) {
            // In a real application, this would show a confirmation dialog before deleting
            if (confirm("Are you sure you want to delete this doctor?")) {
                console.log("Deleting doctor: " + username);
                // Delete logic would go here
            }
        }
        
        // Handle responsive behavior
        window.addEventListener('resize', function() {
            if (window.innerWidth > 768) {
                document.getElementById("sidebar").classList.remove("active");
                document.getElementById("sidebar-overlay").classList.remove("active");
            }
        });
        
        // Filter functionality - Simplified for search and specialization only
        let activeFilters = {
            search: '',
            specialization: ''
        };
        
        function applyFilters() {
            // Get filter values
            const searchValue = document.getElementById('search-filter').value.toLowerCase();
            const specializationValue = document.getElementById('specialization-filter').value;
            
            // Update active filters
            activeFilters.search = searchValue;
            activeFilters.specialization = specializationValue;
            
            // Display active filters
            updateActiveFiltersDisplay();
            
            // Get all doctor rows
            const doctorRows = document.querySelectorAll('.doctor-row');
            let visibleCount = 0;
            
            // Filter the rows
            Array.from(doctorRows).forEach(row => {
                const name = row.getAttribute('data-name').toLowerCase();
                const license = row.getAttribute('data-license').toLowerCase();
                const specialization = row.getAttribute('data-specialization');
                
                // Apply search filter
                const matchesSearch = searchValue === '' || 
                                     name.includes(searchValue) || 
                                     license.includes(searchValue);
                
                // Apply specialization filter
                const matchesSpecialization = specializationValue === '' || 
                                             specialization === specializationValue;
                
                // Show or hide based on all filters
                const isVisible = matchesSearch && matchesSpecialization;
                
                if (isVisible) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Show or hide no results message
            const noResultsRow = document.getElementById('no-results-row');
            const tbody = document.getElementById('doctor-table-body');
            
            // Remove dynamic no results row if it exists
            const dynamicNoResults = document.getElementById('dynamic-no-results');
            if (dynamicNoResults) {
                dynamicNoResults.remove();
            }
            
            // Add no results row if needed
            if (visibleCount === 0 && doctorRows.length > 0) {
                const newNoResultsRow = document.createElement('tr');
                newNoResultsRow.id = 'dynamic-no-results';
                newNoResultsRow.innerHTML = `
                    <td colspan="7" class="text-center py-4">
                        <div class="alert-no-results">
                            <i class="fas fa-filter me-2"></i> No doctors match your filters
                        </div>
                    </td>
                `;
                tbody.appendChild(newNoResultsRow);
            }
            
            // Update results count
            updateResultsCount(visibleCount);
        }
        
        function updateResultsCount(count) {
            const resultsCountElement = document.getElementById('results-count');
            if (count === 0) {
                resultsCountElement.textContent = 'No doctors match your filters';
            } else if (count === 1) {
                resultsCountElement.textContent = 'Showing 1 doctor';
            } else {
                resultsCountElement.textContent = `Showing ${count} doctors`;
            }
        }
        
        function updateActiveFiltersDisplay() {
            const activeFiltersContainer = document.getElementById('active-filters');
            activeFiltersContainer.innerHTML = '';
            
            // Add search filter badge
            if (activeFilters.search) {
                const badge = document.createElement('div');
                badge.className = 'filter-badge';
                badge.innerHTML = `Search: ${activeFilters.search} <span onclick="clearFilter('search')">×</span>`;
                activeFiltersContainer.appendChild(badge);
            }
            
            // Add specialization filter badge
            if (activeFilters.specialization) {
                const badge = document.createElement('div');
                badge.className = 'filter-badge';
                badge.innerHTML = `Specialization: ${activeFilters.specialization} <span onclick="clearFilter('specialization')">×</span>`;
                activeFiltersContainer.appendChild(badge);
            }
        }
        
        function clearFilter(filterType) {
            if (filterType === 'search') {
                document.getElementById('search-filter').value = '';
                activeFilters.search = '';
            } else if (filterType === 'specialization') {
                document.getElementById('specialization-filter').value = '';
                activeFilters.specialization = '';
            }
            
            applyFilters();
        }
        
        function clearAllFilters() {
            document.getElementById('search-filter').value = '';
            document.getElementById('specialization-filter').value = '';
            
            activeFilters = {
                search: '',
                specialization: ''
            };
            
            applyFilters();
        }
        
        // Initialize with default values
        document.addEventListener('DOMContentLoaded', function() {
            // Count initial doctors
            const doctorRows = document.querySelectorAll('.doctor-row');
            updateResultsCount(doctorRows.length);
        });
    </script>
</body>
</html>