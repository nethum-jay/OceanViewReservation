# Ocean View Resort - Online Reservation System 🏨

A distributed web application developed using pure Java EE (Servlets/JSP) and MySQL for managing guest registrations and room bookings at Ocean View Resort.

## 📋 Project Overview
This system is designed to replace the manual reservation process with a digital solution. It features a layered MVC architecture (Model-View-Controller) to ensure maintainability, security, and scalability, following professional software engineering standards. Developed as part of the Advanced Programming assignment.

## 🚀 Key Features
* **Role-Based Acces s Control (RBAC):** Dedicated, secure dashboards for Admin, Staff, and Customers.
* **Guest Registration & Authentication:** Secure login and registration with strong password validations.
* **Room Booking & Management:** Real-time room availability checks and dynamic price calculation.
* **Admin & Staff Controls:** Full CRUD operations for users and reservations, with graphical reporting tools.
* **Invoice Generation:** Automatically generates booking IDs and printable professional invoices.
* **Quality Assurance:** Integrated automated testing using JUnit and Selenium WebDriver for high reliability.

## 🛠️ Technologies Used
* **Frontend:** HTML5, CSS3, JavaScript, AJAX, JSP (JavaServer Pages)
* **Backend:** Java EE (Servlets), JDBC
* **Database:** MySQL
* **Design Patterns:** MVC Architecture, Singleton Pattern (Database Connection)
* **Testing:** JUnit, Selenium WebDriver
* **Version Control:** Git & GitHub

## ⚙️ Prerequisites
Before running this project, ensure you have the following installed:
* Java Development Kit (JDK 8 or higher)
* Apache Tomcat Server (v9.0 or higher)
* MySQL Server & MySQL Workbench
* IntelliJ IDEA (or any Java EE compatible IDE)

## 🛠️ How to Run the Project (Installation Guide)

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/nethum-jay/OceanViewReservation.git](https://github.com/nethum-jay/OceanViewReservation.git)

Database Setup:

    Open MySQL Workbench or any MySQL client.

    Create a new database named oceanview_db.
    
    Import the provided database/oceanview_db.sql file to automatically create the required tables and dummy data.

Database Configuration:

    Open the project in your IDE.
    
    Navigate to src/main/java/com/oceanview/util/DBConnection.java.
    
    Update the database credentials (USER and PASSWORD) to match your local MySQL configuration if necessary.

Deploy the Application:

    Configure a Local Tomcat Server in IntelliJ IDEA.
    
    Build the project and deploy the generated war or exploded artifact.
    
    Run the server and navigate to http://localhost:8080/OceanViewReservation (port may vary based on your Tomcat setup) to view the application.

📂 Project Structure

OceanViewReservation/
├── database/               (Contains oceanview_db.sql for DB setup)
├── src/main/java/com/oceanview/
│   ├── controller/         (Servlets for handling HTTP requests)
│   ├── dao/                (Data Access Objects for MySQL operations)
│   ├── model/              (Data Models / POJOs)
│   └── util/               (DBConnection Singleton configuration)
└── src/main/webapp/        (JSP pages, CSS, and Frontend resources)
