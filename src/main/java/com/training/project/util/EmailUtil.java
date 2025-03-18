package com.training.project.util;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {
	// Default email configuration constants
	private static final String SMTP_HOST = "smtp.gmail.com";
	private static final String SMTP_PORT = "587";
	private static final String SMTP_USERNAME = "nkp8615@gmail.com";
	private static final String SMTP_PASSWORD = "qfiz nbvo swfv cqsm";
	private static final String FROM_EMAIL = SMTP_USERNAME;

	public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
		send(toEmail, subject, body, false);
	}

	public static void sendHtmlEmail(String toEmail, String subject, String htmlBody) throws MessagingException {
		send(toEmail, subject, htmlBody, true);
	}

	private static void send(String toEmail, String subject, String content, boolean isHtml) throws MessagingException {
		// Validate input
		if (toEmail == null || toEmail.trim().isEmpty() || !toEmail.contains("@")) {
			throw new IllegalArgumentException("Invalid recipient email address: " + toEmail);
		}
		if (subject == null) {
			subject = ""; // Default to empty subject if null
		}
		if (content == null) {
			content = ""; // Default to empty body if null
		}

		// Set up mail server properties
		Properties props = new Properties();
		props.put("mail.smtp.host", SMTP_HOST);
		props.put("mail.smtp.port", SMTP_PORT);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");

		// Create a mail session with authentication
		Session session = Session.getInstance(props, new Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
			}
		});

		try {
			// Create a new email message
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(FROM_EMAIL));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
			message.setSubject(subject);

			if (isHtml) {
				message.setContent(content, "text/html; charset=utf-8");
			} else {
				message.setText(content);
			}

			// Send the email
			Transport.send(message);
			System.out.println("Email sent successfully to: " + toEmail + " (HTML: " + isHtml + ")");
		} catch (MessagingException e) {
			System.err.println("Failed to send email to " + toEmail + ": " + e.getMessage());
			throw e; // Re-throw exception
		}
	}
}
