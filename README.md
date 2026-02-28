# Ocean View Resort - Online Reservation System 🏨

A distributed web application developed using Java EE (Servlets/JSP) and MySQL for managing guest registrations and room bookings at Ocean View Resort.

## 📋 Project Overview
This system is designed to streamline the guest management process. It features a layered architecture to ensure maintainability and scalability, following professional software engineering standards.

## 🚀 Key Features
* **Guest Registration:** Securely register new guests with client-side validation.
* **Room Booking:** Efficiently manage room reservations linked to registered guests.
* **Data Integrity:** Implements server-side validation and relational database constraints.
* **Layered Architecture:** Clear separation of concerns into Controller, DAO, Model, and Utility layers.
* **Invoice Generation:** Automatically generates booking IDs and printable invoices.
* **Role-Based Access:** Dedicated dashboards for Customers, Staff, and Admins.

## 🛠️ Technologies Used
* **Frontend:** JSP, HTML5, CSS3, JavaScript (Client-side validation)
* **Backend:** Java Servlets (Java EE 8)
* **Database:** MySQL (Relational Database Management)
* **Design Patterns:** Singleton Pattern for Database Connection
* **Version Control:** Git & GitHub

## 📂 Project Structure
```text
src/
 └── com.oceanview
     ├── controller/ (Servlets)
     ├── dao/        (Database Access Objects)
     ├── model/      (Data Models/POJOs)
     └── util/       (Database Connection Utilities)
webapp/
 ├── register.jsp    (Guest Registration UI)
 ├── booking.jsp     (Room Booking UI)
 ├── viewReservation.jsp (Search & Manage Bookings)
 └── ...             (Other UI files)