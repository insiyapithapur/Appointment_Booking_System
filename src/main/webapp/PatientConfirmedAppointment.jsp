<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Appointment</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f5e95;
            --primary-color: #4f5e95;
            --light-bg: #f7f9fc;
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
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #3d4a75;
            border-color: #3d4a75;
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
                z-index: 1000;
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
        }
        
        .confirm-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        /* Style for disabled dates */
        .date-disabled {
            background-color: #f8f9fa;
            cursor: not-allowed;
        }
        
        /* Styles for available slots */
        .available-slots-container {
            margin-top: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #f8f9fc;
        }
        
        .slot-item {
            padding: 8px 12px;
            margin-bottom: 5px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.2s;
        }
        
        .slot-item:hover {
            background-color: #eef2ff;
        }
        
        .slot-date {
            font-weight: 500;
        }
        
        .slot-available {
            font-size: 0.9rem;
            padding: 3px 8px;
            border-radius: 12px;
            color: white;
        }
        
        .slot-available.high {
            background-color: #4caf50;
        }
        
        .slot-available.medium {
            background-color: #ff9800;
        }
        
        .slot-available.low {
            background-color: #f44336;
        }
        
        .slot-none {
            background-color: #9e9e9e;
        }
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar">P+</div>
        <div class="patient-name mb-3">${sessionScope.username}</div>
        
        <div class="nav-item" onclick="navigateTo('Patient/Dashboard')">Dashboard</div>
        <div class="nav-item" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item active" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
        <div class="nav-item" onclick="window.location.href='${pageContext.request.contextPath}/LogoutServlet'">
            Logout
        </div>
    </div>
    
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Confirm Appointment</h2>
            <button class="btn btn-outline-primary" onclick="history.back()">
                <i class="fas fa-arrow-left me-2"></i> Back
            </button>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger mb-4">${errorMessage}</div>
        </c:if>
        
        <div class="confirm-card">
            <h4 class="mb-4">Please confirm your appointment details</h4>
            
            <form action="${pageContext.request.contextPath}/Patient/ConfirmAppointment" method="post">
                <input type="hidden" name="scheduleId" value="${scheduleId}">
                <input type="hidden" id="scheduleDay" value="${scheduleDay}">
                <input type="hidden" id="doctorId" value="${doctorId}">
                
                <div class="mb-3">
                    <label for="appointmentDate" class="form-label">Appointment Date</label>
                    <div class="input-group">
                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        <span class="input-group-text bg-light">
                            <i class="fas fa-info-circle" data-bs-toggle="tooltip" 
                               title="Only dates that fall on ${scheduleDay} are available for selection"></i>
                        </span>
                    </div>
                    <small class="text-muted mt-1">Note: You can only select dates that fall on ${scheduleDay}</small>
                </div>
                
                <!-- Available Slots Section -->
                <div class="available-slots-container">
                    <h5 class="mb-3">Available Appointment Slots</h5>
                    <div id="availableSlotsDisplay">
                        <c:if test="${not empty availableSlots}">
                            <c:forEach var="slot" items="${availableSlots}">
                                <div class="slot-item" data-slot-info="${slot}">
                                    <c:set var="slotParts" value="${fn:split(slot, '|')}" />
                                    <c:set var="dateInfo" value="${fn:trim(slotParts[0])}" />
                                    
                                    <c:set var="availableParts" value="${fn:split(slotParts[4], ':')}" />
                                    <c:set var="availableCount" value="${fn:trim(availableParts[1])}" />
                                    
                                    <span class="slot-date">${dateInfo}</span>
                                    <span class="slot-available 
                                        <c:choose>
                                            <c:when test="${availableCount > 5}">high</c:when>
                                            <c:when test="${availableCount > 2}">medium</c:when>
                                            <c:when test="${availableCount > 0}">low</c:when>
                                            <c:otherwise>slot-none</c:otherwise>
                                        </c:choose>">
                                        ${availableCount} slots available
                                    </span>
                                </div>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty availableSlots}">
                            <div class="alert alert-info">No available slots found for the selected date range.</div>
                        </c:if>
                    </div>
                </div>
                
                <div class="mb-3 mt-4">
                    <label for="reason" class="form-label">Reason for Appointment</label>
                    <textarea class="form-control" id="reason" name="reason" rows="3" 
                              placeholder="Please describe your symptoms or reason for the appointment..." required></textarea>
                </div>
                
                <div class="d-flex justify-content-end mt-4">
                    <a href="${pageContext.request.contextPath}/Patient/Doctors" class="btn btn-outline-secondary me-2">Cancel</a>
                    <button type="submit" class="btn btn-primary">Confirm Booking</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Bootstrap & jQuery JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("active");
            document.getElementById("sidebar-overlay").classList.toggle("active");
        }
        
        function navigateTo(page) {
            const contextPath = '${pageContext.request.contextPath}';
            window.location.href = contextPath + '/' + page;
        }
        
        // Function to get the day of the week for a date
        function getDayOfWeek(date) {
            const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
            return days[date.getDay()];
        }
        
        // Function to check if a date is valid for selection
        function isValidDate(date) {
            const scheduleDay = document.getElementById('scheduleDay').value;
            return getDayOfWeek(date) === scheduleDay;
        }
        
        // Function to refresh available slots
        function refreshAvailableSlots(selectedDate) {
            const doctorId = document.getElementById('doctorId').value;
            const contextPath = '${pageContext.request.contextPath}';
            
            // Format date for display
            const formattedDate = selectedDate.toISOString().split('T')[0];
            
            // Make AJAX call to get updated slot information
            fetch(`${contextPath}/Patient/ConfirmAppointment?fetchSlots=true&doctorId=${doctorId}`)
                .then(response => response.json())
                .then(slots => {
                    updateAvailableSlotsDisplay(slots, formattedDate);
                })
                .catch(error => console.error('Error fetching slots:', error));
        }
        
        // Function to update the display with latest slot information
        function updateAvailableSlotsDisplay(slots, selectedDateStr) {
            const slotsContainer = document.getElementById('availableSlotsDisplay');
            
            if (!slots || slots.length === 0) {
                slotsContainer.innerHTML = '<div class="alert alert-info">No available slots found for the selected date range.</div>';
                return;
            }
            
            let html = '';
            
            slots.forEach(slot => {
                const slotParts = slot.split('|');
                const dateInfo = slotParts[0].trim();
                
                // Extract date for matching
                const slotDatePart = dateInfo.split(',')[1]?.trim() || '';
                
                // Extract available count
                const availableParts = slotParts[4].split(':');
                const availableCount = availableParts[1].trim();
                
                // Determine appropriate class based on available count
                let availableClass = 'slot-none';
                if (availableCount > 5) {
                    availableClass = 'high';
                } else if (availableCount > 2) {
                    availableClass = 'medium';
                } else if (availableCount > 0) {
                    availableClass = 'low';
                }
                
                // Highlight the row if it matches the selected date
                const isSelectedDate = dateInfo.includes(selectedDateStr);
                const highlightClass = isSelectedDate ? 'bg-light' : '';
                
                html += `
                    <div class="slot-item ${highlightClass}" data-slot-info="${slot}">
                        <span class="slot-date">${dateInfo}</span>
                        <span class="slot-available ${availableClass}">
                            ${availableCount} slots available
                        </span>
                    </div>
                `;
            });
            
            slotsContainer.innerHTML = html;
            
            // Add click event to slot items to select the date
            document.querySelectorAll('.slot-item').forEach(item => {
                item.addEventListener('click', function() {
                    const slotInfo = this.getAttribute('data-slot-info');
                    const slotParts = slotInfo.split('|');
                    const dateInfo = slotParts[0].trim();
                    
                    // Extract date for setting the input
                    try {
                        const dateString = dateInfo.replace(/^\w+,\s/, ''); // Remove day name
                        const date = new Date(dateString);
                        
                        if (!isNaN(date.getTime())) {
                            const formattedDate = date.toISOString().split('T')[0];
                            document.getElementById('appointmentDate').value = formattedDate;
                            
                            // Highlight the selected slot
                            document.querySelectorAll('.slot-item').forEach(el => {
                                el.classList.remove('bg-light');
                            });
                            this.classList.add('bg-light');
                        }
                    } catch (e) {
                        console.error('Error parsing date:', e);
                    }
                });
            });
        }
        
        // Set up date field with restrictions
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('appointmentDate');
            const scheduleDay = document.getElementById('scheduleDay').value;
            
            // Enable tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
            
            // Find the next valid date (today or future date that falls on the schedule day)
            let currentDate = new Date();
            while (!isValidDate(currentDate) || currentDate < new Date(new Date().setHours(0,0,0,0))) {
                currentDate.setDate(currentDate.getDate()+1);
            }
            
            // Set the initial date to the next valid date
            const formattedDate = currentDate.toISOString().split('T')[0];
            dateInput.value = formattedDate;
            
            // Make slot items clickable
            document.querySelectorAll('.slot-item').forEach(item => {
                item.addEventListener('click', function() {
                    const slotInfo = this.getAttribute('data-slot-info');
                    const slotParts = slotInfo.split('|');
                    const dateInfo = slotParts[0].trim();
                    
                    // Extract date for setting the input
                    try {
                        const dateString = dateInfo.replace(/^\w+,\s/, ''); // Remove day name
                        const date = new Date(dateString);
                        
                        if (!isNaN(date.getTime())) {
                            const formattedDate = date.toISOString().split('T')[0];
                            dateInput.value = formattedDate;
                            
                            // Highlight the selected slot
                            document.querySelectorAll('.slot-item').forEach(el => {
                                el.classList.remove('bg-light');
                            });
                            this.classList.add('bg-light');
                        }
                    } catch (e) {
                        console.error('Error parsing date:', e);
                    }
                });
            });
            
            // Custom date validation
            dateInput.addEventListener('input', function(e) {
                const selectedDate = new Date(this.value);
                
                if (!isValidDate(selectedDate)) {
                    // If not valid day of week, show warning and reset
                    alert(`Please select a date that falls on ${scheduleDay}. Other days are not available for this schedule.`);
                    this.value = formattedDate; // Reset to valid date
                }
            });
            
            // Handle date navigation with browser date picker
            dateInput.addEventListener('change', function(e) {
                const selectedDate = new Date(this.value);
                
                // Ensure it's a valid day of week
                if (!isValidDate(selectedDate)) {
                    alert(`Please select a date that falls on ${scheduleDay}. Other days are not available for this schedule.`);
                    this.value = formattedDate; // Reset to valid date
                    return;
                }
                
                // Ensure it's not in the past
                const today = new Date(new Date().setHours(0,0,0,0));
                if (selectedDate < today) {
                    alert("Please select a future date.");
                    this.value = formattedDate; // Reset to valid date
                    return;
                }
                
                // Highlight the matching slot if it exists
                const selectedDateStr = this.value;
                document.querySelectorAll('.slot-item').forEach(item => {
                    const slotInfo = item.getAttribute('data-slot-info');
                    if (slotInfo.includes(selectedDateStr)) {
                        document.querySelectorAll('.slot-item').forEach(el => {
                            el.classList.remove('bg-light');
                        });
                        item.classList.add('bg-light');
                        
                        // Scroll to the highlighted item
                        item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                    }
                });
                
                // Optionally refresh slots data when date changes
                // refreshAvailableSlots(selectedDate);
            });
        });
    </script>
</body>
</html>