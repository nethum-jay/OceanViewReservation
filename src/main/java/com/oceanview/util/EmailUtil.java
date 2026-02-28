package com.oceanview.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtil {

    public static void sendBookingEmail(int bookingId, String toEmail, String guestName, String roomType, String checkIn, String checkOut, int persons, double totalCost) {

        final String fromEmail = "njayanuka189@gmail.com";
        final String password = "zwxb slaz njgr posc";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Booking Confirmation #" + bookingId + " - Ocean View Resort");

            // Creating an HTML E-Bill
            String htmlContent =
                    "<html>" +
                            "<body style='font-family: Arial, sans-serif; color: #333;'>" +
                            "<div style='max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;'>" +
                            "<div style='background-color: #005f73; color: white; padding: 20px; text-align: center;'>" +
                            "<h1 style='margin: 0;'>Ocean View Resort</h1>" +
                            "<p style='margin: 5px 0;'>Booking Confirmation</p>" +
                            "</div>" +
                            "<div style='padding: 20px;'>" +
                            "<p>Dear <strong>" + guestName + "</strong>,</p>" +
                            "<p>Thank you for choosing Ocean View Resort! Your reservation has been confirmed. Below is your booking summary and invoice.</p>" +

                            "<div style='background-color: #f4f7f6; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; border: 1px dashed #0a9396;'>" +
                            "<h3 style='margin: 0; color: #005f73;'>Booking ID: #" + bookingId + "</h3>" +
                            "</div>" +

                            "<table style='width: 100%; border-collapse: collapse; margin-top: 20px;'>" +
                            "<tr style='background-color: #f2f2f2;'>" +
                            "<th style='padding: 10px; border: 1px solid #ddd; text-align: left;'>Description</th>" +
                            "<th style='padding: 10px; border: 1px solid #ddd; text-align: right;'>Details</th>" +
                            "</tr>" +
                            "<tr>" +
                            "<td style='padding: 10px; border: 1px solid #ddd;'>Room Type</td>" +
                            "<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>" + roomType + "</td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td style='padding: 10px; border: 1px solid #ddd;'>Check-In Date</td>" +
                            "<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>" + checkIn + "</td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td style='padding: 10px; border: 1px solid #ddd;'>Check-Out Date</td>" +
                            "<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>" + checkOut + "</td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td style='padding: 10px; border: 1px solid #ddd;'>Guests</td>" +
                            "<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>" + persons + "</td>" +
                            "</tr>" +
                            "<tr style='font-weight: bold; background-color: #e0fbfc;'>" +
                            "<td style='padding: 10px; border: 1px solid #ddd;'>Total Amount (LKR)</td>" +
                            "<td style='padding: 10px; border: 1px solid #ddd; text-align: right;'>Rs. " + String.format("%,.2f", totalCost) + "</td>" +
                            "</tr>" +
                            "</table>" +

                            "<p style='margin-top: 20px; font-size: 12px; color: #666;'>* Please present this email and your Booking ID upon arrival.</p>" +
                            "</div>" +
                            "<div style='background-color: #f9f9f9; padding: 15px; text-align: center; font-size: 12px; color: #888;'>" +
                            "Ocean View Resort, Malabe | Tel: +94 11 234 5678" +
                            "</div>" +
                            "</div>" +
                            "</body>" +
                            "</html>";

            // Setting HTML content to Email
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("HTML Booking confirmation sent to: " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}