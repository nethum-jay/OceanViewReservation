-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: oceanview_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guestID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `nic` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(200) NOT NULL,
  `contactNo` varchar(15) NOT NULL,
  PRIMARY KEY (`guestID`),
  UNIQUE KEY `nic` (`nic`),
  UNIQUE KEY `contactNo` (`contactNo`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (1,'Kasun Liyanage','200256478','liyanage@gmail.com','563/2 D, Athurugiriya Road, Malabe','0764686189'),(2,'Sachin','981234567V','sachin@gmail.com','10, Main Rd, Colombo','0763572159'),(3,'Nimali Silva','200056781234','nimali88@yahoo.com','45, Kandy Rd, Peradeniya','0712223333'),(4,'Nuwan Pradeep','199012349999','nuwan.p90@yahoo.com','67, Fort, Galle','0740001111'),(5,'Kamal Fernando','851112223V','kamal.f@outlook.com','88/2, Galle Rd, Panadura','0765554444'),(6,'Sanduni Peiris','199967891234','sanduni.p@gmail.com','15, Temple Rd, Nugegoda','0723339999'),(7,'Chamara Weera','199512345678','chamara.w@gmail.com','7, New Town, Anuradhapura','0756665555'),(8,'Piyumi Hansika','925556667V','piyumi.h@test.lk','44/A, Beach Rd, Negombo','0741231234'),(9,'Ashan Bandara','971239876V','ashan.b@hotmail.com','33, Station Rd, Gampaha','0770001111');
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservationID` int NOT NULL AUTO_INCREMENT,
  `guestID` int NOT NULL,
  `roomType` varchar(50) NOT NULL,
  `checkInDate` date NOT NULL,
  `checkOutDate` date NOT NULL,
  `noOfPersons` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Confirmed',
  PRIMARY KEY (`reservationID`),
  KEY `fk_guest_reservation` (`guestID`),
  CONSTRAINT `fk_guest_reservation` FOREIGN KEY (`guestID`) REFERENCES `guest` (`guestID`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`guestID`) REFERENCES `guest` (`guestID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,1,'Double','2026-03-07','2026-03-08',2,'Confirmed'),(2,2,'Single','2026-03-09','2026-03-13',1,'Confirmed'),(3,3,'Single','2026-03-15','2026-03-16',1,'Confirmed'),(4,4,'Single','2026-03-14','2026-03-15',1,'Confirmed'),(5,5,'Family','2026-04-01','2026-04-03',4,'Confirmed'),(6,5,'Suite','2026-12-24','2026-12-26',2,'Confirmed'),(7,2,'Double','2026-03-10','2026-03-12',2,'Confirmed'),(8,6,'Family','2026-04-10','2026-04-15',3,'Confirmed'),(9,6,'Single','2026-05-01','2026-05-05',1,'Confirmed'),(10,6,'Double','2026-03-11','2026-03-12',1,'Confirmed'),(11,6,'Family','2026-04-10','2026-04-15',3,'Confirmed'),(12,7,'Double','2026-06-10','2026-06-11',2,'Confirmed'),(13,8,'Family','2026-04-20','2026-04-27',2,'Confirmed'),(14,8,'Double','2026-03-08','2026-03-10',2,'Confirmed'),(15,8,'Single','2026-07-01','2026-07-10',1,'Confirmed'),(16,8,'Family','2026-03-18','2026-03-22',4,'Confirmed'),(17,9,'Suite','2026-08-15','2026-08-18',2,'Confirmed'),(18,9,'Double','2026-05-20','2026-05-21',2,'Confirmed'),(19,9,'Single','2026-03-25','2026-03-27',1,'Confirmed'),(20,9,'Family','2026-04-05','2026-04-08',3,'Confirmed'),(21,1,'Single','2026-03-10','2026-03-11',1,'Cancel_Requested');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` varchar(20) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','Admin@123','Admin','0766579198'),(2,'Staff','Staff@123','Staff','0775901184'),(3,'Kasun','Kasun@123','Customer','0764686189'),(4,'Sachinda','Sachin@123','Customer','0763572159'),(5,'Nimali','Nim#2026','Customer','0719876543'),(7,'Sanduni','San*Pass12','Customer','0723339999'),(8,'Chamara','Chamara!12','Customer','0756665555'),(9,'Piyumi','Piyu&32145','Customer','0741231234'),(10,'Ashan','Ash@n9991','Customer','0770001111'),(11,'Saman','Saman@123','Customer','0745896325'),(12,'Dasun Shanka','Dasun @123','Customer','0766589412'),(13,'Kasuni','Kasuni@123','Customer','0751489665');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'oceanview_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-07 14:40:56
