<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Record</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --sidebar-bg: #4f95e9;
            --primary-color: #4f95e9;
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
        
        .record-container {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .record-header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .record-content {
            padding: 20px;
        }
        
        .doctor-info {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .doctor-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            font-size: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            float: left;
        }
        
        .record-details {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .record-details h4 {
            color: var(--primary-color);
            margin-bottom: 15px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
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
            background-color: #3d75a4;
        }
        
        /* Overlay for mobile when sidebar is active */
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
    </style>
</head>
<body>
    <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
    <div class="sidebar-overlay" id="sidebar-overlay" onclick="toggleSidebar()"></div>
    
    <div class="sidebar" id="sidebar">
        <div class="avatar">P+</div>
        <div class="patient-name mb-3">${sessionScope.username}</div>
        
        <div class="nav-item" onclick="navigateTo('Patient/Dashboard')">Dashboard</div>
        <div class="nav-item active" onclick="navigateTo('Patient/Appointments')">Appointments</div>
        <div class="nav-item" onclick="navigateTo('Patient/Doctors')">Doctors</div>
        <div class="nav-item" onclick="navigateTo('Patient/Profile')">Profile</div>
    </div>
    
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Medical Record</h2>
            <a href="${pageContext.request.contextPath}/Patient/Appointments" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left"></i> Back to Appointments
            </a>
        </div>
        
        <!-- Parse the appointment detail string -->
        <c:set var="appointmentParts" value="${fn:split(appointmentDetail, '|')}" />
        <c:set var="appointmentId" value="${fn:trim(fn:substringAfter(appointmentParts[0], 'ID:'))}" />
        <c:set var="doctorName" value="${fn:trim(fn:substringAfter(appointmentParts[1], 'Doctor:'))}" />
        <c:set var="appointmentDate" value="${fn:trim(fn:substringAfter(appointmentParts[2], 'Date:'))}" />
        <c:set var="tokenNo" value="${fn:trim(fn:substringAfter(appointmentParts[3], 'Token:'))}" />
        <c:set var="reason" value="${fn:trim(fn:substringAfter(appointmentParts[4], 'Reason:'))}" />
        <c:set var="status" value="${fn:trim(fn:substringAfter(appointmentParts[5], 'Status:'))}" />
        
        <!-- Parse medical record details -->
        <c:set var="medicalRecord" value="${fn:substringAfter(appointmentDetail, 'Medical Record:')}" />
        <c:set var="diagnosis" value="${fn:trim(fn:substringBetween(medicalRecord, 'Diagnosis:', ','))}" />
        <c:set var="treatment" value="${fn:trim(fn:substringBetween(medicalRecord, 'Treatment:', ','))}" />
        <c:set var="notes" value="${fn:trim(fn:substringBetween(medicalRecord, 'Notes:', '|'))}" />
        
        <!-- Check if there's a file -->
        <c:set var="hasFile" value="${fn:contains(appointmentDetail, 'File:')}" />
        <c:if test="${hasFile}">
            <c:set var="filePath" value="${fn:trim(fn:substringAfter(appointmentDetail, 'File:'))}" />
        </c:if>
        
        <div class="record-container">
            <div class="record-header">
                <i class="fas fa-file-medical me-2"></i> Medical Record #${appointmentId}
            </div>
            <div class="record-content">
                <div class="doctor-info clearfix">
                    <div class="doctor-avatar">
                        ${fn:substring(doctorName, 4, 5)}
                    </div>
                    <div>
                        <h4>${doctorName}</h4>
                        <p class="text-muted mb-0">Appointment Date: ${appointmentDate}</p>
                        <p class="text-muted mb-0">Token Number: ${tokenNo}</p>
                    </div>
                </div>
                
                <h5>Reason for Visit</h5>
                <p>${reason}</p>
                
                <div class="record-details">
                    <h4>Medical Diagnosis</h4>
                    <p>${diagnosis != "None" ? diagnosis : "No diagnosis recorded."}</p>
                    
                    <h4>Treatment Plan</h4>
                    <p>${treatment != "None" ? treatment : "No treatment plan specified."}</p>
                    
                    <h4>Doctor's Notes</h4>
                    <p>${notes != "None" ? notes : "No additional notes."}</p>
                    
                    <c:if test="${hasFile}">
                        <h4>Attached Documents</h4>
                        <div class="d-flex align-items-center mt-3">
                            <i class="fas fa-file-pdf text-danger fs-3 me-3"></i>
                            <div>
                                <p class="mb-1">Medical Report</p>
                                <a href="${filePath}" class="btn btn-sm btn-outline-primary" target="_blank">
                                    <i class="fas fa-download"></i> Download
                                </a>
                            </div>
                        </div>
                    </c:if>