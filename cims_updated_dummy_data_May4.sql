-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: cims_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (2,'Aesthetician'),(1,'Owner'),(3,'Sales');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,1,31),(32,1,32),(33,1,33),(34,1,34),(35,1,35),(36,1,36),(37,1,37),(38,1,38),(39,1,39),(40,1,40),(41,1,41),(42,1,42),(43,1,43),(44,1,44),(45,1,45),(46,1,46),(47,1,47),(48,1,48),(49,1,49),(50,1,50),(51,1,51),(52,1,52),(53,1,53),(54,1,54),(55,1,55),(56,1,56),(57,1,57),(58,1,58),(59,1,59),(60,1,60),(61,1,61),(62,1,62),(63,1,63),(64,1,64),(65,1,65),(66,1,66),(67,1,67),(68,1,68),(69,1,69),(70,1,70),(71,1,71),(72,1,72),(73,1,73),(74,1,74),(75,1,75),(76,1,76),(77,1,77),(78,1,78),(79,1,79),(80,1,80),(81,1,81),(82,1,82),(83,1,83),(84,1,84);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add clinic branch',10,'add_clinicbranch'),(26,'Can change clinic branch',10,'change_clinicbranch'),(27,'Can delete clinic branch',10,'delete_clinicbranch'),(28,'Can view clinic branch',10,'view_clinicbranch'),(29,'Can add patient',12,'add_patient'),(30,'Can change patient',12,'change_patient'),(31,'Can delete patient',12,'delete_patient'),(32,'Can view patient',12,'view_patient'),(33,'Can add supplier',17,'add_supplier'),(34,'Can change supplier',17,'change_supplier'),(35,'Can delete supplier',17,'delete_supplier'),(36,'Can view supplier',17,'view_supplier'),(37,'Can add treatment',19,'add_treatment'),(38,'Can change treatment',19,'change_treatment'),(39,'Can delete treatment',19,'delete_treatment'),(40,'Can view treatment',19,'view_treatment'),(41,'Can add account',7,'add_account'),(42,'Can change account',7,'change_account'),(43,'Can delete account',7,'delete_account'),(44,'Can view account',7,'view_account'),(45,'Can add inventory shipment',11,'add_inventoryshipment'),(46,'Can change inventory shipment',11,'change_inventoryshipment'),(47,'Can delete inventory shipment',11,'delete_inventoryshipment'),(48,'Can view inventory shipment',11,'view_inventoryshipment'),(49,'Can add sales transaction',16,'add_salestransaction'),(50,'Can change sales transaction',16,'change_salestransaction'),(51,'Can delete sales transaction',16,'delete_salestransaction'),(52,'Can view sales transaction',16,'view_salestransaction'),(53,'Can add product',14,'add_product'),(54,'Can change product',14,'change_product'),(55,'Can delete product',14,'delete_product'),(56,'Can view product',14,'view_product'),(57,'Can add transaction item',18,'add_transactionitem'),(58,'Can change transaction item',18,'change_transactionitem'),(59,'Can delete transaction item',18,'delete_transactionitem'),(60,'Can view transaction item',18,'view_transactionitem'),(61,'Can add patient visit',13,'add_patientvisit'),(62,'Can change patient visit',13,'change_patientvisit'),(63,'Can delete patient visit',13,'delete_patientvisit'),(64,'Can view patient visit',13,'view_patientvisit'),(65,'Can add branch product',8,'add_branchproduct'),(66,'Can change branch product',8,'change_branchproduct'),(67,'Can delete branch product',8,'delete_branchproduct'),(68,'Can view branch product',8,'view_branchproduct'),(69,'Can add received product',15,'add_receivedproduct'),(70,'Can change received product',15,'change_receivedproduct'),(71,'Can delete received product',15,'delete_receivedproduct'),(72,'Can view received product',15,'view_receivedproduct'),(73,'Can add branch treatment',9,'add_branchtreatment'),(74,'Can change branch treatment',9,'change_branchtreatment'),(75,'Can delete branch treatment',9,'delete_branchtreatment'),(76,'Can view branch treatment',9,'view_branchtreatment'),(77,'Can add treatment product',20,'add_treatmentproduct'),(78,'Can change treatment product',20,'change_treatmentproduct'),(79,'Can delete treatment product',20,'delete_treatmentproduct'),(80,'Can view treatment product',20,'view_treatmentproduct'),(81,'Can add employee profile',21,'add_employeeprofile'),(82,'Can change employee profile',21,'change_employeeprofile'),(83,'Can delete employee profile',21,'delete_employeeprofile'),(84,'Can view employee profile',21,'view_employeeprofile'),(85,'Can add user lockout',22,'add_userlockout'),(86,'Can change user lockout',22,'change_userlockout'),(87,'Can delete user lockout',22,'delete_userlockout'),(88,'Can view user lockout',22,'view_userlockout');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$wywmv7bk09g7bGbgRlLDKS$0oF2acBJlbT6DyPunlEnCkb5mAMiVCQw9YG1hP+7kpw=','2026-04-10 08:34:59.201911',1,'cookie','Cookie','','',1,1,'2026-02-11 06:37:40.652883'),(2,'pbkdf2_sha256$1200000$FIdN0fi7FHnJ18Nt792HYR$jZwRzSeY91ksMy8IzCKxIWDYztzGZpSE3w5q5VCngD8=','2026-04-25 11:07:05.875807',0,'jenny','Jenny','','',1,1,'2026-03-17 05:51:17.000000'),(3,'pbkdf2_sha256$1200000$5xSc73PM7tI6a6hDQZODPU$jP7qhqxNyZYK3Fam6W9wfkIWrPfno2uin/Uz+rkrZPQ=','2026-04-25 11:15:41.323797',0,'martinco','','','',1,1,'2026-03-22 06:50:43.000000'),(4,'pbkdf2_sha256$1200000$7DOUY1uI52lIPSrx9lmkQc$Rzc62yazQHywZXT9xVi8DYrpcTsrd06rOPrD4CvNpS8=','2026-04-22 10:13:19.865063',1,'random','test','','',1,0,'2026-04-10 09:15:17.521141'),(5,'pbkdf2_sha256$1200000$9Vwhv9t2vq0dJK7SvIMP9o$+k3ZR3c/7jWq6ukl6vFtEPKegQZBNMQKmZXhbYTw5vU=','2026-04-12 10:31:58.085703',1,'marie','Marie','','',1,1,'2026-04-12 10:24:56.000000'),(6,'pbkdf2_sha256$1200000$jgtURzcVCgPSFSbRTZmC10$iJOFoyg2uTVKdj7T+fkqRkN337hHy77q+VThs14Jzh4=',NULL,0,'ChonaSP','Owner Chona','','',0,1,'2026-04-12 10:40:40.599154'),(7,'pbkdf2_sha256$1200000$AEgDIks64L1G4m530kjonR$4EmWyBs7IQM2HxUe9mG4PopQuuIAGVauzeCAHWlv/zc=',NULL,0,'QCMissKim','Aesthetician Kim Updated','','',0,0,'2026-04-22 07:42:55.602449'),(8,'pbkdf2_sha256$1200000$8hcd7QwqiAOXMuloBx8EFn$i581WflNsqwgDKulf4w2L1/2fKQ6qF3WtdnVbJbw6Jo=',NULL,0,'MissIya','Sales Team Iya','','',0,1,'2026-04-22 07:44:36.629199'),(9,'pbkdf2_sha256$1200000$huChR69lSUFDq1H4w6mnJM$lHQE4tiZc2Ws23NpuXa3DyGh1+Mlw8h6Jji2IEby09w=',NULL,0,'NewIyak','Sales Team Iyak','','',0,1,'2026-04-22 07:49:55.300266'),(10,'pbkdf2_sha256$1200000$wpA4PxvuuwH8gOWAIjPNuY$Ma2Ky0usEm4RtKVHdysRsGFfTyKqxd1jYldlOl2baGE=',NULL,0,'forscreens','For Screens','','',0,1,'2026-04-26 06:01:17.800202'),(11,'pbkdf2_sha256$1200000$mcKWiGAt12vKUuJ5vsrkRZ$iVeYJ+5mqYSS/yrUPo6KaTP7eVDmaMoZNF/Fyc13JHE=',NULL,0,'newaest1','Marie','','',0,1,'2026-04-29 10:41:36.627831'),(12,'pbkdf2_sha256$1200000$6noXVt5uMwCGSfCyHLhRPe$TCunJe3Gh4SuV4/9krkLsWQ8b5mG2PvXXrreSRilMEU=',NULL,0,'sales','saleman','','',0,1,'2026-04-29 10:42:13.387986');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (8,1,2),(26,2,2),(1,3,1),(23,4,2),(7,5,3),(3,6,1),(20,7,3),(10,8,3),(11,9,3),(29,10,2),(30,11,2),(31,12,3);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_branchproduct`
--

DROP TABLE IF EXISTS `clinic_branchproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_branchproduct` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity_minimum` int(11) NOT NULL,
  `stock_quantity` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_branchproduct_branch_id_product_id_3f64fe26_uniq` (`branch_id`,`product_id`),
  KEY `clinic_branchproduct_product_id_157c5a4a_fk_clinic_pr` (`product_id`),
  CONSTRAINT `clinic_branchproduct_branch_id_aaf48fed_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_branchproduct_product_id_157c5a4a_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchproduct`
--

LOCK TABLES `clinic_branchproduct` WRITE;
/*!40000 ALTER TABLE `clinic_branchproduct` DISABLE KEYS */;
INSERT INTO `clinic_branchproduct` VALUES (1,30,77,1,31),(2,30,84,1,8),(3,30,62,1,9),(4,30,16,1,41),(5,30,44,1,1),(6,30,84,1,2),(7,30,52,1,3),(8,30,68,1,4),(9,30,73,1,5),(10,30,66,1,6),(11,30,75,1,7),(12,30,79,1,10),(13,30,65,1,29),(14,30,52,1,30),(15,30,73,1,33),(16,30,66,1,34),(17,30,62,1,35),(19,30,15,1,49),(20,30,94,1,11),(21,30,60,1,12),(22,30,56,1,13),(23,30,45,1,14),(24,30,67,1,15),(25,30,53,1,16),(26,30,90,1,17),(27,30,59,1,18),(28,30,61,1,19),(29,30,82,1,20),(30,30,72,1,21),(31,30,65,1,22),(32,30,89,1,23),(33,30,82,1,24),(34,30,46,1,25),(35,30,50,1,26),(36,30,74,1,27),(37,30,73,1,28),(38,30,52,1,32),(39,30,10,1,36),(40,30,11,1,37),(41,30,14,1,38),(42,30,11,1,39),(43,30,26,1,40),(44,30,11,1,42),(45,30,26,1,43),(46,30,12,1,44),(47,30,13,1,45),(48,30,24,1,46),(49,30,11,1,47),(51,30,65,2,9),(53,30,24,1,50),(54,30,21,4,50),(55,30,27,2,50),(56,30,90,4,1),(57,30,56,2,1),(58,30,76,4,2),(59,30,58,2,2),(60,30,71,4,3),(61,30,89,2,3),(62,30,74,4,4),(63,30,61,2,4),(64,30,87,4,5),(65,30,55,2,5),(66,30,81,4,6),(67,30,93,2,6),(68,30,54,4,7),(69,30,72,2,7),(70,30,90,4,8),(71,30,87,2,8),(72,30,56,4,9),(73,30,45,4,10),(74,30,58,2,10),(75,30,63,4,11),(76,30,89,2,11),(77,30,64,4,12),(78,30,64,2,12),(79,30,91,4,13),(80,30,96,2,13),(81,30,50,4,14),(82,30,95,2,14),(83,30,50,4,15),(84,30,44,2,15),(85,30,75,4,16),(86,30,88,2,16),(87,30,56,4,17),(88,30,92,2,17),(89,30,76,4,18),(90,30,72,2,18),(91,30,81,4,19),(92,30,86,2,19),(93,30,48,4,20),(94,30,96,2,20),(95,30,70,4,21),(96,30,73,2,21),(97,30,50,4,22),(98,30,59,2,22),(99,30,89,4,23),(100,30,58,2,23),(101,30,47,4,24),(102,30,70,2,24),(103,30,49,4,25),(104,30,52,2,25),(105,30,72,4,26),(106,30,53,2,26),(107,30,61,4,27),(108,30,55,2,27),(109,30,94,4,28),(110,30,96,2,28),(111,30,96,4,29),(112,30,47,2,29),(113,30,68,4,30),(114,30,70,2,30),(115,30,83,4,31),(116,30,44,2,31),(117,30,51,4,32),(118,30,86,2,32),(119,30,61,4,33),(120,30,64,2,33),(121,30,44,4,34),(122,30,92,2,34),(123,30,61,4,35),(124,30,94,2,35),(125,30,19,4,36),(126,30,13,2,36),(127,30,17,4,37),(128,30,20,2,37),(129,30,22,4,38),(130,30,23,2,38),(131,30,21,4,39),(132,30,9,2,39),(133,30,13,4,40),(134,30,13,2,40),(135,30,18,4,41),(136,30,22,2,41),(137,30,11,4,42),(138,30,19,2,42),(139,30,16,4,43),(140,30,14,2,43),(141,30,14,4,44),(142,30,21,2,44),(143,30,14,4,45),(144,30,20,2,45),(145,30,13,4,46),(146,30,17,2,46),(147,30,16,4,47),(148,30,23,2,47),(149,30,20,4,49),(150,30,22,2,49),(152,30,23,1,51),(153,30,21,4,51),(154,30,11,2,51);
/*!40000 ALTER TABLE `clinic_branchproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_branchtreatment`
--

DROP TABLE IF EXISTS `clinic_branchtreatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_branchtreatment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `availability_status` tinyint(1) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_branchtreatment_branch_id_treatment_id_a191e555_uniq` (`branch_id`,`treatment_id`),
  KEY `clinic_branchtreatme_treatment_id_8d17b2dd_fk_clinic_tr` (`treatment_id`),
  CONSTRAINT `clinic_branchtreatme_branch_id_dea3fbfc_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_branchtreatme_treatment_id_8d17b2dd_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=515 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchtreatment`
--

LOCK TABLES `clinic_branchtreatment` WRITE;
/*!40000 ALTER TABLE `clinic_branchtreatment` DISABLE KEYS */;
INSERT INTO `clinic_branchtreatment` VALUES (1,1,1,86),(2,1,4,86),(3,1,2,86),(5,1,1,1),(6,1,4,1),(7,1,2,1),(10,1,1,2),(11,1,4,2),(12,1,2,2),(15,1,1,3),(16,1,4,3),(17,1,2,3),(20,1,1,4),(21,1,4,4),(22,1,2,4),(25,1,1,5),(26,1,4,5),(27,1,2,5),(30,1,1,6),(31,1,4,6),(32,1,2,6),(35,1,1,7),(36,1,4,7),(37,1,2,7),(40,1,1,8),(41,1,4,8),(42,1,2,8),(45,1,1,9),(46,1,4,9),(47,1,2,9),(50,1,1,10),(51,1,4,10),(52,1,2,10),(55,1,1,11),(56,1,4,11),(57,1,2,11),(60,1,1,12),(61,1,4,12),(62,1,2,12),(65,1,1,13),(66,1,4,13),(67,1,2,13),(70,1,1,14),(71,1,4,14),(72,1,2,14),(75,1,1,15),(76,1,4,15),(77,1,2,15),(80,1,1,16),(81,1,4,16),(82,1,2,16),(85,1,1,17),(86,1,4,17),(87,1,2,17),(90,1,1,18),(91,1,4,18),(92,1,2,18),(95,1,1,19),(96,1,4,19),(97,1,2,19),(100,1,1,20),(101,1,4,20),(102,1,2,20),(105,1,1,21),(106,1,4,21),(107,1,2,21),(110,1,1,22),(111,1,4,22),(112,1,2,22),(115,1,1,23),(116,1,4,23),(117,1,2,23),(120,1,1,24),(121,1,4,24),(122,1,2,24),(125,1,1,25),(126,1,4,25),(127,1,2,25),(130,1,1,26),(131,1,4,26),(132,1,2,26),(135,1,1,27),(136,1,4,27),(137,1,2,27),(140,1,1,28),(141,1,4,28),(142,1,2,28),(145,1,1,29),(146,1,4,29),(147,1,2,29),(150,1,1,30),(151,1,4,30),(152,1,2,30),(155,1,1,31),(156,1,4,31),(157,1,2,31),(160,1,1,32),(161,1,4,32),(162,1,2,32),(165,1,1,33),(166,1,4,33),(167,1,2,33),(170,1,1,34),(171,1,4,34),(172,1,2,34),(175,1,1,35),(176,1,4,35),(177,1,2,35),(180,1,1,36),(181,1,4,36),(182,1,2,36),(185,1,1,37),(186,1,4,37),(187,1,2,37),(190,1,1,38),(191,1,4,38),(192,1,2,38),(195,1,1,39),(196,1,4,39),(197,1,2,39),(200,1,1,40),(201,1,4,40),(202,1,2,40),(205,1,1,41),(206,1,4,41),(207,1,2,41),(210,1,1,42),(211,1,4,42),(212,1,2,42),(215,1,1,43),(216,1,4,43),(217,1,2,43),(220,1,1,44),(221,1,4,44),(222,1,2,44),(225,1,1,45),(226,1,4,45),(227,1,2,45),(230,1,1,46),(231,1,4,46),(232,1,2,46),(235,1,1,47),(236,1,4,47),(237,1,2,47),(240,1,1,48),(241,1,4,48),(242,1,2,48),(245,1,1,49),(246,1,4,49),(247,1,2,49),(250,1,1,50),(251,1,4,50),(252,1,2,50),(255,1,1,51),(256,1,4,51),(257,1,2,51),(260,1,1,52),(261,1,4,52),(262,1,2,52),(265,1,1,53),(266,1,4,53),(267,1,2,53),(270,1,1,54),(271,1,4,54),(272,1,2,54),(275,1,1,55),(276,1,4,55),(277,1,2,55),(280,1,1,56),(281,1,4,56),(282,1,2,56),(285,1,1,57),(286,1,4,57),(287,1,2,57),(290,1,1,58),(291,1,4,58),(292,1,2,58),(295,1,1,59),(296,1,4,59),(297,1,2,59),(300,1,1,60),(301,1,4,60),(302,1,2,60),(305,1,1,61),(306,1,4,61),(307,1,2,61),(310,1,1,62),(311,1,4,62),(312,1,2,62),(315,1,1,63),(316,1,4,63),(317,1,2,63),(320,1,1,64),(321,1,4,64),(322,1,2,64),(325,1,1,65),(326,1,4,65),(327,1,2,65),(330,1,1,66),(331,1,4,66),(332,1,2,66),(335,1,1,67),(336,1,4,67),(337,1,2,67),(340,1,1,68),(341,1,4,68),(342,1,2,68),(345,1,1,69),(346,1,4,69),(347,1,2,69),(350,1,1,70),(351,1,4,70),(352,1,2,70),(355,1,1,71),(356,1,4,71),(357,1,2,71),(360,1,1,72),(361,1,4,72),(362,1,2,72),(365,1,1,73),(366,1,4,73),(367,1,2,73),(370,1,1,74),(371,1,4,74),(372,1,2,74),(375,1,1,75),(376,1,4,75),(377,1,2,75),(380,1,1,76),(381,1,4,76),(382,1,2,76),(385,1,1,77),(386,1,4,77),(387,1,2,77),(390,1,1,78),(391,1,4,78),(392,1,2,78),(395,1,1,79),(396,1,4,79),(397,1,2,79),(400,1,1,80),(401,1,4,80),(402,1,2,80),(405,1,1,81),(406,1,4,81),(407,1,2,81),(410,1,1,82),(411,1,4,82),(412,1,2,82),(415,1,1,83),(416,1,4,83),(417,1,2,83),(420,1,1,84),(421,1,4,84),(422,1,2,84),(425,1,1,85),(426,1,4,85),(427,1,2,85);
/*!40000 ALTER TABLE `clinic_branchtreatment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_clinicbranch`
--

DROP TABLE IF EXISTS `clinic_clinicbranch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_clinicbranch` (
  `branch_id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_location` varchar(255) NOT NULL,
  `branch_address` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`branch_id`),
  UNIQUE KEY `clinic_clinicbranch_branch_location_f4a2f259_uniq` (`branch_location`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_clinicbranch`
--

LOCK TABLES `clinic_clinicbranch` WRITE;
/*!40000 ALTER TABLE `clinic_clinicbranch` DISABLE KEYS */;
INSERT INTO `clinic_clinicbranch` VALUES (1,'Meycauayan, Bulacan','Main Loc',0),(2,'San Juan','Near GH',0),(4,'Quezon City','Near Alimall (upd)',0);
/*!40000 ALTER TABLE `clinic_clinicbranch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_employeeprofile`
--

DROP TABLE IF EXISTS `clinic_employeeprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_employeeprofile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `all_branches` tinyint(1) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `clinic_employeeprofi_branch_id_d01f6fe8_fk_clinic_cl` (`branch_id`),
  CONSTRAINT `clinic_employeeprofi_branch_id_d01f6fe8_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_employeeprofile_user_id_9bc9f99d_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_employeeprofile`
--

LOCK TABLES `clinic_employeeprofile` WRITE;
/*!40000 ALTER TABLE `clinic_employeeprofile` DISABLE KEYS */;
INSERT INTO `clinic_employeeprofile` VALUES (1,0,2,1),(2,0,1,3),(3,1,NULL,6),(4,0,2,4),(5,0,1,2),(6,1,NULL,5),(7,0,1,7),(8,0,4,8),(9,0,4,9),(10,0,2,10),(11,0,1,11),(12,1,NULL,12);
/*!40000 ALTER TABLE `clinic_employeeprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_inventoryshipment`
--

DROP TABLE IF EXISTS `clinic_inventoryshipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_inventoryshipment` (
  `inventory_record_id` int(11) NOT NULL AUTO_INCREMENT,
  `received_product_name` varchar(100) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `date_received` date NOT NULL,
  PRIMARY KEY (`inventory_record_id`),
  KEY `clinic_inventoryship_branch_id_e10248e4_fk_clinic_cl` (`branch_id`),
  KEY `clinic_inventoryship_supplier_id_e5dab4ca_fk_clinic_su` (`supplier_id`),
  CONSTRAINT `clinic_inventoryship_branch_id_e10248e4_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_inventoryship_supplier_id_e5dab4ca_fk_clinic_su` FOREIGN KEY (`supplier_id`) REFERENCES `clinic_supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_inventoryshipment`
--

LOCK TABLES `clinic_inventoryshipment` WRITE;
/*!40000 ALTER TABLE `clinic_inventoryshipment` DISABLE KEYS */;
INSERT INTO `clinic_inventoryshipment` VALUES (6,'Acne Laser',1,1,'2026-03-13'),(7,'Anti-Melasma Serum',1,1,'2026-03-16'),(8,'Esthetmax Jelly Mask',1,1,'2025-10-05'),(9,'Special Mask',1,1,'2025-10-18'),(10,'Jelly Mask',1,1,'2025-11-03'),(11,'Gold Mask',1,1,'2025-11-20'),(12,'Extraction',1,1,'2025-12-02'),(13,'Ear Gun Piercing',1,1,'2025-12-15'),(14,'Keloid Injection',1,1,'2026-01-08'),(15,'Acne Shot',1,1,'2026-01-22'),(16,'Topical Anesthesia',1,1,'2026-03-01'),(17,'Cleansing Solution (150ml)',1,1,'2026-01-10'),(18,'Clarifying Solution (60ml)',1,1,'2026-01-15'),(19,'Body Astringent (150ml)',1,1,'2026-02-01'),(20,'Brightening Soap (90g)',1,1,'2026-02-15'),(21,'Bleaching Soap (90g)',1,1,'2026-03-01'),(22,'Acne Shot',1,1,'2026-03-17'),(23,'Acne Laser',1,1,'2026-04-10'),(24,'Acne Laser',2,1,'2026-04-10'),(26,'Test Soap',1,5,'2026-04-24'),(32,'Esthetmax Jelly Mask',4,1,'2026-04-03'),(33,'Esthetmax Jelly Mask',2,1,'2026-04-24'),(36,'Special Mask',4,1,'2026-04-19'),(37,'Special Mask',2,1,'2026-03-13'),(40,'Jelly Mask',4,1,'2026-03-06'),(41,'Jelly Mask',2,1,'2026-03-12'),(44,'Gold Mask',4,1,'2026-03-10'),(45,'Gold Mask',2,1,'2026-03-28'),(48,'Extraction',4,1,'2026-03-27'),(49,'Extraction',2,1,'2026-04-14'),(52,'Ear Gun Piercing',4,1,'2026-04-07'),(53,'Ear Gun Piercing',2,1,'2026-04-11');
/*!40000 ALTER TABLE `clinic_inventoryshipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_patient`
--

DROP TABLE IF EXISTS `clinic_patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_patient` (
  `patient_id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `patient_address` varchar(300) NOT NULL,
  `patient_contact_number` varchar(11) NOT NULL,
  `birthday` date NOT NULL,
  `sex` varchar(1) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `unique_patient_identity` (`last_name`,`first_name`,`middle_name`,`birthday`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_patient`
--

LOCK TABLES `clinic_patient` WRITE;
/*!40000 ALTER TABLE `clinic_patient` DISABLE KEYS */;
INSERT INTO `clinic_patient` VALUES (1,'Abesamis','Jaron','I.','JUNIOR','yes','0906058609','2025-02-11','M',0),(2,'Ayunga','Enzo','',NULL,'There','09084201347','2004-02-05','M',0),(4,'Patient','Sample','','3000','Yes','09203054079','2026-04-08','M',0),(5,'Santos','Maria','Lopez',NULL,'Quezon City','09171230001','1998-02-10','F',0),(6,'Reyes','John','Cruz',NULL,'San Juan','09171230002','1996-05-22','M',0),(7,'Garcia','Angela','Tan',NULL,'Makati','09171230003','1999-01-14','F',0),(8,'Lim','Paolo','Sy',NULL,'Bulacan','09171230004','1995-07-11','M',0),(9,'Co','Jasmine','Uy',NULL,'UPTC','09171230005','2000-10-01','F',0),(10,'Torres','Miguel','Diaz',NULL,'QC','09171230006','1997-06-09','M',0),(11,'Tan','Nicole','Go',NULL,'Makati','09171230007','1998-09-19','F',0),(12,'Yu','Kevin','Lee',NULL,'Pasig','09171230008','1994-11-28','M',0),(13,'Ong','Patricia','Tan',NULL,'QC','09171230009','2001-03-18','F',0),(14,'Dela Cruz','Carlo','Mendoza',NULL,'Bulacan','09171230010','1993-12-30','M',0),(15,'Lecena','Earth','Ramos',NULL,'Quezon City','09171231001','2001-03-14','F',0),(16,'Pacis','Charles','Navarro',NULL,'Makati City','09171231002','1999-07-22','M',0),(17,'Sarayan','Simone','Villanueva',NULL,'Pasig City','09171231003','2002-11-05','F',0),(18,'Bautista','Elise','Santos',NULL,'Taguig City','09171231004','2000-09-18','F',0),(19,'Ungson','Kiyo','Del Rosario',NULL,'Mandaluyong City','09171231005','1998-01-27','M',0),(20,'Metran','Fiona','Garcia',NULL,'San Juan City','09171231006','2001-06-11','F',0),(21,'Azurin','Keisha','Fernandez',NULL,'Parañaque City','09171231007','2003-04-09','F',0),(22,'Lim','Malcolm','Tan',NULL,'Manila City','09171231008','1997-12-30','M',0),(23,'Pacheco','Sam','Reyes',NULL,'Pasay City','09171231009','2000-08-16','M',0),(24,'Salubo','Lyra','Mendoza',NULL,'Marikina City','09171231010','2002-05-25','F',0);
/*!40000 ALTER TABLE `clinic_patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_product`
--

DROP TABLE IF EXISTS `clinic_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `product_type` varchar(30) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `unit_cost` decimal(8,2) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `clinic_product_supplier_id_c95683ba_fk_clinic_su` (`supplier_id`),
  CONSTRAINT `clinic_product_supplier_id_c95683ba_fk_clinic_su` FOREIGN KEY (`supplier_id`) REFERENCES `clinic_supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_product`
--

LOCK TABLES `clinic_product` WRITE;
/*!40000 ALTER TABLE `clinic_product` DISABLE KEYS */;
INSERT INTO `clinic_product` VALUES (1,'Esthetmax Jelly Mask','Add-On',NULL,599.00,1,0),(2,'Special Mask','Add-On',NULL,200.00,1,0),(3,'Jelly Mask','Add-On',NULL,400.00,1,0),(4,'Gold Mask','Add-On',NULL,550.00,1,0),(5,'Extraction','Add-On',NULL,250.00,1,0),(6,'Ear Gun Piercing','Add-On',NULL,450.00,1,0),(7,'Keloid Injection','Add-On','Per unit',150.00,1,0),(8,'Acne Shot','Add-On','Per unit',150.00,1,0),(9,'Acne Laser','Add-On','None',250.00,1,0),(10,'Topical Anesthesia','Add-On',NULL,500.00,1,0),(11,'Local Anesthesia','Add-On',NULL,600.00,1,0),(12,'Gluta IV Push','Add-On','Per vial',800.00,1,0),(13,'Night Cream (10g)','Cream',NULL,380.00,1,0),(14,'Night Cream (25g)','Cream',NULL,780.00,1,0),(15,'Day Cream (10g)','Cream',NULL,380.00,1,0),(16,'Day Cream (25g)','Cream',NULL,780.00,1,0),(17,'Peeling Cream (10g)','Cream',NULL,480.00,1,0),(18,'Peeling Cream (25g)','Cream',NULL,880.00,1,0),(19,'Sunscreen Gel (10g)','Cream',NULL,420.00,1,0),(20,'Sunscreen Foundation (10g)','Cream',NULL,420.00,1,0),(21,'Sunblock Foundation (10g)','Cream',NULL,420.00,1,0),(22,'Clindamycin Cream (10g)','Cream',NULL,400.00,1,0),(23,'Collagen Cream (10g)','Cream',NULL,480.00,1,0),(24,'Glycolic Cream (10g)','Cream',NULL,420.00,1,0),(25,'Hydrocortisone Cream (10g)','Cream',NULL,420.00,1,0),(26,'Erythromycin Cream (10g)','Cream',NULL,300.00,1,0),(27,'Underarm Whitening (10g)','Cream',NULL,420.00,1,0),(28,'Cleansing Solution (60ml)','Solution',NULL,220.00,1,0),(29,'Cleansing Solution (150ml)','Solution',NULL,400.00,1,0),(30,'Clarifying Solution (60ml)','Solution',NULL,300.00,1,0),(31,'Clarifying Solution (150ml)','Solution',NULL,450.00,1,0),(32,'Clindamycin Solution (60ml)','Solution',NULL,390.00,1,0),(33,'Body Astringent (150ml)','Solution',NULL,650.00,1,0),(34,'Brightening Soap (90g)','Soap',NULL,200.00,1,0),(35,'Bleaching Soap (90g)','Soap',NULL,280.00,1,0),(36,'Hydramide Soap (150g)','Soap',NULL,420.00,1,0),(37,'Collagen Serum','Serum',NULL,450.00,1,0),(38,'Miracle Serum','Serum',NULL,450.00,1,0),(39,'Tomato Serum','Serum',NULL,450.00,1,0),(40,'Hydrating Serum','Serum',NULL,450.00,1,0),(41,'Anti-Melasma Serum','Serum',NULL,500.00,1,0),(42,'Glass Serum','Serum',NULL,450.00,1,0),(43,'Gold Serum','Serum',NULL,450.00,1,0),(44,'Retinol Serum','Serum',NULL,500.00,1,0),(45,'Niacinamide Serum','Serum',NULL,450.00,1,0),(46,'Hyaluronic Serum','Serum',NULL,450.00,1,0),(47,'Puff Away Serum','Serum',NULL,450.00,1,0),(49,'New Product Updated','New type','this',400.00,1,0),(50,'Test Soap','Soap','pangtest lang',50.00,5,0),(51,'Gluta Test','Glutathione','fro test',500.00,1,0);
/*!40000 ALTER TABLE `clinic_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_receivedproduct`
--

DROP TABLE IF EXISTS `clinic_receivedproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_receivedproduct` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity_received` int(11) NOT NULL,
  `expiration_date` date NOT NULL,
  `branch_id` int(11) NOT NULL,
  `inventory_record_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_receivedproduct_inventory_record_id_prod_5d6e9647_uniq` (`inventory_record_id`,`product_id`),
  KEY `clinic_receivedprodu_branch_id_bea10a7a_fk_clinic_cl` (`branch_id`),
  KEY `clinic_receivedprodu_product_id_99ceac6e_fk_clinic_pr` (`product_id`),
  CONSTRAINT `clinic_receivedprodu_branch_id_bea10a7a_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_receivedprodu_inventory_record_id_e6495ad0_fk_clinic_in` FOREIGN KEY (`inventory_record_id`) REFERENCES `clinic_inventoryshipment` (`inventory_record_id`),
  CONSTRAINT `clinic_receivedprodu_product_id_99ceac6e_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_receivedproduct`
--

LOCK TABLES `clinic_receivedproduct` WRITE;
/*!40000 ALTER TABLE `clinic_receivedproduct` DISABLE KEYS */;
INSERT INTO `clinic_receivedproduct` VALUES (6,50,'2027-10-20',1,6,9),(7,67,'2026-03-27',1,7,41),(8,100,'2027-10-05',1,8,1),(9,50,'2027-10-18',1,9,2),(10,100,'2027-11-03',1,10,3),(11,50,'2027-11-20',1,11,4),(12,100,'2027-12-02',1,12,5),(13,50,'2027-12-15',1,13,6),(14,100,'2028-01-08',1,14,7),(15,50,'2028-01-22',1,15,8),(16,50,'2028-03-01',1,16,10),(17,100,'2027-01-10',1,17,29),(18,100,'2027-01-15',1,18,30),(19,100,'2027-02-01',1,19,33),(20,100,'2027-02-15',1,20,34),(21,100,'2027-03-01',1,21,35),(22,56,'2027-09-07',1,22,8),(23,21,'2029-10-10',1,23,9),(24,3,'2028-06-10',2,24,9),(26,3,'2035-03-02',1,26,50);
/*!40000 ALTER TABLE `clinic_receivedproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_salestransaction`
--

DROP TABLE IF EXISTS `clinic_salestransaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_salestransaction` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_date` date NOT NULL,
  `mode_of_payment` varchar(20) NOT NULL,
  `total_price_of_treatments` decimal(8,2) DEFAULT NULL,
  `total_amount` decimal(8,2) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `notes` longtext DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `total_price_of_products` decimal(8,2) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` (`patient_id`),
  KEY `clinic_salestransact_branch_id_8434fca6_fk_clinic_cl` (`branch_id`),
  CONSTRAINT `clinic_salestransact_branch_id_8434fca6_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` FOREIGN KEY (`patient_id`) REFERENCES `clinic_patient` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_salestransaction`
--

LOCK TABLES `clinic_salestransaction` WRITE;
/*!40000 ALTER TABLE `clinic_salestransaction` DISABLE KEYS */;
INSERT INTO `clinic_salestransaction` VALUES (1,'2026-02-23','Card',499.00,979.00,1,NULL,1,0.00,0),(2,'2026-02-23','GCash',2499.00,2499.00,1,NULL,1,0.00,0),(3,'2026-02-23','GCash',24500.00,24500.00,1,NULL,1,0.00,0),(4,'2026-02-23','Card',1499.00,1979.00,1,NULL,1,0.00,0),(5,'2026-02-23','Cash',2499.00,2499.00,2,NULL,1,0.00,0),(7,'2026-03-22','GCash',0.00,75000.00,1,'',1,0.00,0),(8,'2026-03-22','Cash',0.00,10000.00,1,'',1,0.00,0),(13,'2026-03-24','Cash',0.00,1050.00,1,'none',1,0.00,0),(15,'2026-04-22','GCash',4499.00,5249.00,2,'',1,0.00,0),(17,'2026-04-25','Cash',499.00,499.00,4,'sample',1,0.00,0),(145,'2026-01-25','Cash',6999.00,6999.00,19,'DASHBOARD_DUMMY_treatment_only',2,0.00,0),(146,'2026-01-13','GCash',3500.00,3500.00,21,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(147,'2026-01-20','Cash',6999.00,6999.00,5,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(148,'2026-01-31','Cash',2000.00,2000.00,16,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(149,'2026-01-02','GCash',2499.00,2499.00,4,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(150,'2026-01-07','Cash',0.00,900.00,20,'DASHBOARD_DUMMY_product_only',4,900.00,0),(151,'2026-01-31','Cash',0.00,200.00,20,'DASHBOARD_DUMMY_product_only',2,200.00,0),(152,'2026-01-08','Cash',0.00,1260.00,12,'DASHBOARD_DUMMY_product_only',1,1260.00,0),(153,'2026-01-08','GCash',0.00,150.00,17,'DASHBOARD_DUMMY_product_only',4,150.00,0),(154,'2026-01-17','Cash',0.00,1760.00,2,'DASHBOARD_DUMMY_product_only',4,1760.00,0),(155,'2026-01-27','GCash',0.00,840.00,14,'DASHBOARD_DUMMY_product_only',1,840.00,0),(156,'2026-01-24','GCash',0.00,2700.00,6,'DASHBOARD_DUMMY_product_only',2,2700.00,0),(157,'2026-01-05','Cash',0.00,800.00,23,'DASHBOARD_DUMMY_product_only',4,800.00,0),(158,'2026-01-18','Cash',0.00,940.00,5,'DASHBOARD_DUMMY_product_only',4,940.00,0),(159,'2026-01-09','GCash',699.00,1899.00,24,'DASHBOARD_DUMMY_mixed',2,1200.00,0),(160,'2026-01-24','Card',6999.00,7779.00,4,'DASHBOARD_DUMMY_mixed',2,780.00,0),(161,'2026-01-30','Cash',3000.00,3840.00,1,'DASHBOARD_DUMMY_mixed',4,840.00,0),(162,'2026-01-14','Cash',1799.00,2969.00,20,'DASHBOARD_DUMMY_mixed',4,1170.00,0),(163,'2026-01-10','GCash',2599.00,3439.00,20,'DASHBOARD_DUMMY_mixed',1,840.00,0),(164,'2026-01-10','GCash',9999.00,10599.00,23,'DASHBOARD_DUMMY_mixed',2,600.00,0),(165,'2026-01-20','Cash',4500.00,4880.00,23,'DASHBOARD_DUMMY_mixed',2,380.00,0),(166,'2026-01-07','Cash',4999.00,5399.00,7,'DASHBOARD_DUMMY_mixed',1,400.00,0),(167,'2026-01-06','GCash',2499.00,3339.00,9,'DASHBOARD_DUMMY_mixed',2,840.00,0),(168,'2026-01-06','GCash',3899.00,5459.00,2,'DASHBOARD_DUMMY_mixed',4,1560.00,0),(169,'2026-01-12','Cash',1799.00,2449.00,13,'DASHBOARD_DUMMY_mixed',1,650.00,0),(170,'2026-02-10','Cash',2499.00,2499.00,19,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(171,'2026-02-16','GCash',6999.00,6999.00,20,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(172,'2026-02-23','Cash',799.00,799.00,10,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(173,'2026-02-09','GCash',4500.00,4500.00,14,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(174,'2026-02-03','Card',499.00,499.00,2,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(175,'2026-02-18','Cash',0.00,760.00,15,'DASHBOARD_DUMMY_product_only',1,760.00,0),(176,'2026-02-22','Card',0.00,2038.00,4,'DASHBOARD_DUMMY_product_only',1,2038.00,0),(177,'2026-02-28','Cash',0.00,900.00,14,'DASHBOARD_DUMMY_product_only',4,900.00,0),(178,'2026-02-16','GCash',0.00,1470.00,5,'DASHBOARD_DUMMY_product_only',1,1470.00,0),(179,'2026-02-25','GCash',0.00,380.00,24,'DASHBOARD_DUMMY_product_only',1,380.00,0),(180,'2026-02-19','Cash',0.00,1200.00,9,'DASHBOARD_DUMMY_product_only',4,1200.00,0),(181,'2026-02-21','Cash',0.00,250.00,19,'DASHBOARD_DUMMY_product_only',1,250.00,0),(182,'2026-02-21','GCash',0.00,700.00,14,'DASHBOARD_DUMMY_product_only',4,700.00,0),(183,'2026-02-11','GCash',0.00,650.00,11,'DASHBOARD_DUMMY_product_only',4,650.00,0),(184,'2026-02-20','Cash',2000.00,3350.00,8,'DASHBOARD_DUMMY_mixed',1,1350.00,0),(185,'2026-02-09','GCash',200.00,1550.00,5,'DASHBOARD_DUMMY_mixed',2,1350.00,0),(186,'2026-02-15','Cash',9599.00,10099.00,17,'DASHBOARD_DUMMY_mixed',1,500.00,0),(187,'2026-02-19','Cash',9599.00,10399.00,20,'DASHBOARD_DUMMY_mixed',4,800.00,0),(188,'2026-02-22','GCash',4500.00,5500.00,20,'DASHBOARD_DUMMY_mixed',2,1000.00,0),(189,'2026-02-23','Cash',2499.00,2919.00,9,'DASHBOARD_DUMMY_mixed',1,420.00,0),(190,'2026-02-20','GCash',6999.00,8199.00,11,'DASHBOARD_DUMMY_mixed',1,1200.00,0),(191,'2026-02-02','Cash',5999.00,7259.00,20,'DASHBOARD_DUMMY_mixed',4,1260.00,0),(192,'2026-02-04','Cash',4500.00,4750.00,16,'DASHBOARD_DUMMY_mixed',2,250.00,0),(193,'2026-02-17','GCash',2599.00,3349.00,11,'DASHBOARD_DUMMY_mixed',2,750.00,0),(194,'2026-02-14','GCash',4599.00,5349.00,11,'DASHBOARD_DUMMY_mixed',2,750.00,0),(195,'2026-03-21','Card',10000.00,10000.00,15,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(196,'2026-03-26','GCash',2000.00,2000.00,12,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(197,'2026-03-05','GCash',6000.00,6000.00,11,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(198,'2026-03-07','GCash',3499.00,3499.00,18,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(199,'2026-03-22','Card',1499.00,1499.00,11,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(200,'2026-03-25','Cash',0.00,1200.00,6,'DASHBOARD_DUMMY_product_only',1,1200.00,0),(201,'2026-03-29','GCash',0.00,1560.00,6,'DASHBOARD_DUMMY_product_only',1,1560.00,0),(202,'2026-03-07','GCash',0.00,1560.00,21,'DASHBOARD_DUMMY_product_only',1,1560.00,0),(203,'2026-03-11','GCash',0.00,400.00,9,'DASHBOARD_DUMMY_product_only',1,400.00,0),(204,'2026-03-01','Cash',0.00,850.00,17,'DASHBOARD_DUMMY_product_only',1,850.00,0),(205,'2026-03-02','GCash',0.00,500.00,1,'DASHBOARD_DUMMY_product_only',2,500.00,0),(206,'2026-03-08','Card',0.00,1220.00,10,'DASHBOARD_DUMMY_product_only',4,1220.00,0),(207,'2026-03-02','Cash',0.00,400.00,20,'DASHBOARD_DUMMY_product_only',1,400.00,0),(208,'2026-03-14','Card',0.00,860.00,1,'DASHBOARD_DUMMY_product_only',1,860.00,0),(209,'2026-03-05','GCash',2500.00,3700.00,22,'DASHBOARD_DUMMY_mixed',4,1200.00,0),(210,'2026-03-11','GCash',9999.00,10879.00,21,'DASHBOARD_DUMMY_mixed',1,880.00,0),(211,'2026-03-09','GCash',400.00,780.00,5,'DASHBOARD_DUMMY_mixed',1,380.00,0),(212,'2026-03-11','GCash',4500.00,6840.00,11,'DASHBOARD_DUMMY_mixed',1,2340.00,0),(213,'2026-03-27','Cash',3000.00,3400.00,19,'DASHBOARD_DUMMY_mixed',1,400.00,0),(214,'2026-03-09','Cash',3499.00,3919.00,20,'DASHBOARD_DUMMY_mixed',1,420.00,0),(215,'2026-03-27','GCash',1899.00,4299.00,23,'DASHBOARD_DUMMY_mixed',1,2400.00,0),(216,'2026-03-12','Card',2499.00,3759.00,12,'DASHBOARD_DUMMY_mixed',1,1260.00,0),(217,'2026-03-13','GCash',499.00,899.00,22,'DASHBOARD_DUMMY_mixed',4,400.00,0),(218,'2026-03-25','GCash',11999.00,12749.00,16,'DASHBOARD_DUMMY_mixed',4,750.00,0),(219,'2026-03-25','GCash',2499.00,3259.00,6,'DASHBOARD_DUMMY_mixed',4,760.00,0),(220,'2026-04-17','Cash',10000.00,10000.00,8,'DASHBOARD_DUMMY_treatment_only',2,0.00,0),(221,'2026-04-11','Cash',699.00,699.00,6,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(222,'2026-04-06','Cash',999.00,999.00,15,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(223,'2026-04-26','Card',5000.00,5000.00,9,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(224,'2026-04-20','Card',11999.00,11999.00,9,'DASHBOARD_DUMMY_treatment_only',4,0.00,0),(225,'2026-04-24','Cash',0.00,1600.00,17,'DASHBOARD_DUMMY_product_only',1,1600.00,0),(226,'2026-04-30','Cash',0.00,1250.00,9,'DASHBOARD_DUMMY_product_only',4,1250.00,0),(227,'2026-04-15','Cash',0.00,2640.00,5,'DASHBOARD_DUMMY_product_only',4,2640.00,0),(228,'2026-04-16','GCash',0.00,2840.00,14,'DASHBOARD_DUMMY_product_only',1,2840.00,0),(229,'2026-04-04','GCash',0.00,800.00,2,'DASHBOARD_DUMMY_product_only',1,800.00,0),(230,'2026-04-02','Cash',0.00,1200.00,16,'DASHBOARD_DUMMY_product_only',4,1200.00,0),(231,'2026-04-27','GCash',0.00,420.00,20,'DASHBOARD_DUMMY_product_only',4,420.00,0),(232,'2026-04-08','GCash',0.00,2040.00,1,'DASHBOARD_DUMMY_product_only',1,2040.00,0),(233,'2026-04-19','Cash',0.00,250.00,10,'DASHBOARD_DUMMY_product_only',1,250.00,0),(234,'2026-04-09','GCash',4000.00,4400.00,1,'DASHBOARD_DUMMY_mixed',1,400.00,0),(235,'2026-04-21','Cash',599.00,1799.00,1,'DASHBOARD_DUMMY_mixed',1,1200.00,0),(236,'2026-04-14','GCash',2499.00,3249.00,24,'DASHBOARD_DUMMY_mixed',1,750.00,0),(237,'2026-04-07','GCash',1499.00,2339.00,13,'DASHBOARD_DUMMY_mixed',1,840.00,0),(238,'2026-04-22','GCash',400.00,850.00,18,'DASHBOARD_DUMMY_mixed',1,450.00,0),(239,'2026-04-01','Card',25000.00,25300.00,21,'DASHBOARD_DUMMY_mixed',1,300.00,0),(240,'2026-04-27','GCash',5999.00,6599.00,17,'DASHBOARD_DUMMY_mixed',2,600.00,0),(241,'2026-04-12','Card',2000.00,2800.00,10,'DASHBOARD_DUMMY_mixed',4,800.00,0),(242,'2026-04-08','GCash',1499.00,2799.00,20,'DASHBOARD_DUMMY_mixed',4,1300.00,0),(243,'2026-04-05','Cash',10000.00,11800.00,4,'DASHBOARD_DUMMY_mixed',2,1800.00,0),(244,'2026-04-29','GCash',1500.00,1800.00,17,'DASHBOARD_DUMMY_mixed',1,300.00,0),(245,'2026-05-02','Cash',3000.00,3000.00,13,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(246,'2026-05-01','Cash',2499.00,2499.00,21,'DASHBOARD_DUMMY_treatment_only',1,0.00,0),(247,'2026-05-04','Card',0.00,250.00,22,'DASHBOARD_DUMMY_product_only',1,250.00,0),(248,'2026-05-03','GCash',0.00,1140.00,21,'DASHBOARD_DUMMY_product_only',1,1140.00,0),(249,'2026-05-01','Cash',0.00,750.00,7,'DASHBOARD_DUMMY_product_only',4,750.00,0),(250,'2026-05-02','Card',200.00,2150.00,11,'DASHBOARD_DUMMY_mixed',2,1950.00,0),(251,'2026-05-01','Cash',599.00,2549.00,19,'DASHBOARD_DUMMY_mixed',1,1950.00,0),(252,'2026-05-03','Cash',500.00,1940.00,11,'DASHBOARD_DUMMY_mixed',2,1440.00,0),(253,'2026-05-01','Cash',2499.00,3759.00,18,'DASHBOARD_DUMMY_mixed',2,1260.00,0),(254,'2026-05-03','GCash',1899.00,3659.00,10,'DASHBOARD_DUMMY_mixed',1,1760.00,0);
/*!40000 ALTER TABLE `clinic_salestransaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_supplier`
--

DROP TABLE IF EXISTS `clinic_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_supplier` (
  `supplier_id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(150) NOT NULL,
  `contact_person` varchar(100) NOT NULL,
  `supplier_contact_number` varchar(11) NOT NULL,
  `supplier_address` varchar(300) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_supplier`
--

LOCK TABLES `clinic_supplier` WRITE;
/*!40000 ALTER TABLE `clinic_supplier` DISABLE KEYS */;
INSERT INTO `clinic_supplier` VALUES (1,'Mr. Supplier','Mang Tani','09060585960','Over There',0),(2,'Test Supplier for Page','Sir Jal','09060453412','Katipunan Ave.',1),(3,'SkinCare Distributors Inc.','Maria De Mesa','09171234123','Tomas Morato, Quezon City',0),(4,'Supplier Updated','Fiona Metran','09060585960','there pala',0),(5,'For Deleting','delte','09060596070','yup',1),(6,'for delete','sj','09465483091','oisd',1);
/*!40000 ALTER TABLE `clinic_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_transactionitem`
--

DROP TABLE IF EXISTS `clinic_transactionitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_transactionitem` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity_purchased` int(11) NOT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) NOT NULL,
  `treatment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `clinic_transactionit_product_id_048d8cd8_fk_clinic_pr` (`product_id`),
  KEY `clinic_transactionit_transaction_id_b85110ce_fk_clinic_sa` (`transaction_id`),
  KEY `clinic_transactionit_treatment_id_bc4be356_fk_clinic_tr` (`treatment_id`),
  CONSTRAINT `clinic_transactionit_product_id_048d8cd8_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`),
  CONSTRAINT `clinic_transactionit_transaction_id_b85110ce_fk_clinic_sa` FOREIGN KEY (`transaction_id`) REFERENCES `clinic_salestransaction` (`transaction_id`),
  CONSTRAINT `clinic_transactionit_treatment_id_bc4be356_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5553 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_transactionitem`
--

LOCK TABLES `clinic_transactionitem` WRITE;
/*!40000 ALTER TABLE `clinic_transactionitem` DISABLE KEYS */;
INSERT INTO `clinic_transactionitem` VALUES (1,1,480.00,23,1,NULL),(2,1,499.00,NULL,1,64),(3,1,2499.00,NULL,2,75),(4,7,24500.00,NULL,3,80),(5,1,480.00,23,4,NULL),(6,1,1499.00,NULL,4,77),(9,1,2499.00,NULL,5,75),(13,500,75000.00,8,7,NULL),(14,40,10000.00,9,8,NULL),(18,7,1050.00,8,13,NULL),(19,5,750.00,8,15,NULL),(20,1,4499.00,NULL,15,28),(22,1,499.00,NULL,17,1),(5268,1,6999.00,NULL,145,31),(5269,1,3500.00,NULL,146,80),(5270,1,6999.00,NULL,147,31),(5271,1,2000.00,NULL,148,55),(5272,1,2499.00,NULL,149,74),(5273,1,699.00,NULL,159,4),(5274,1,6999.00,NULL,160,40),(5275,1,3000.00,NULL,161,57),(5276,1,1799.00,NULL,162,60),(5277,1,2599.00,NULL,163,24),(5278,1,9999.00,NULL,164,30),(5279,1,4500.00,NULL,165,15),(5280,1,4999.00,NULL,166,26),(5281,1,2499.00,NULL,167,25),(5282,1,3899.00,NULL,168,18),(5283,1,1799.00,NULL,169,60),(5284,1,2499.00,NULL,170,75),(5285,1,6999.00,NULL,171,40),(5286,1,799.00,NULL,172,3),(5287,1,4500.00,NULL,173,49),(5288,1,499.00,NULL,174,1),(5289,1,2000.00,NULL,184,54),(5290,1,200.00,NULL,185,86),(5291,1,9599.00,NULL,186,19),(5292,1,9599.00,NULL,187,19),(5293,1,4500.00,NULL,188,49),(5294,1,2499.00,NULL,189,25),(5295,1,6999.00,NULL,190,42),(5296,1,5999.00,NULL,191,17),(5297,1,4500.00,NULL,192,15),(5298,1,2599.00,NULL,193,24),(5299,1,4599.00,NULL,194,22),(5300,1,10000.00,NULL,195,81),(5301,1,2000.00,NULL,196,51),(5302,1,6000.00,NULL,197,12),(5303,1,3499.00,NULL,198,11),(5304,1,1499.00,NULL,199,34),(5305,1,2500.00,NULL,209,53),(5306,1,9999.00,NULL,210,30),(5307,1,400.00,NULL,211,84),(5308,1,4500.00,NULL,212,50),(5309,1,3000.00,NULL,213,57),(5310,1,3499.00,NULL,214,32),(5311,1,1899.00,NULL,215,71),(5312,1,2499.00,NULL,216,74),(5313,1,499.00,NULL,217,1),(5314,1,11999.00,NULL,218,47),(5315,1,2499.00,NULL,219,74),(5316,1,10000.00,NULL,220,83),(5317,1,699.00,NULL,221,4),(5318,1,999.00,NULL,222,5),(5319,1,5000.00,NULL,223,79),(5320,1,11999.00,NULL,224,41),(5321,1,4000.00,NULL,234,58),(5322,1,599.00,NULL,235,2),(5323,1,2499.00,NULL,236,25),(5324,1,1499.00,NULL,237,76),(5325,1,400.00,NULL,238,84),(5326,1,25000.00,NULL,239,44),(5327,1,5999.00,NULL,240,43),(5328,1,2000.00,NULL,241,54),(5329,1,1499.00,NULL,242,7),(5330,1,10000.00,NULL,243,81),(5331,1,1500.00,NULL,244,66),(5332,1,3000.00,NULL,245,70),(5333,1,2499.00,NULL,246,29),(5334,1,200.00,NULL,250,86),(5335,1,599.00,NULL,251,2),(5336,1,500.00,NULL,252,85),(5337,1,2499.00,NULL,253,61),(5338,1,1899.00,NULL,254,71),(5395,1,300.00,30,150,NULL),(5396,1,200.00,34,151,NULL),(5397,3,660.00,28,152,NULL),(5398,1,150.00,7,153,NULL),(5399,2,800.00,29,154,NULL),(5400,2,840.00,24,155,NULL),(5401,3,2400.00,12,156,NULL),(5402,1,800.00,12,157,NULL),(5403,1,550.00,4,158,NULL),(5404,3,1200.00,29,159,NULL),(5405,2,780.00,32,160,NULL),(5406,2,840.00,25,161,NULL),(5407,3,1170.00,32,162,NULL),(5408,2,840.00,25,163,NULL),(5409,1,600.00,11,164,NULL),(5410,1,380.00,15,165,NULL),(5411,1,400.00,29,166,NULL),(5412,2,840.00,25,167,NULL),(5413,2,1560.00,14,168,NULL),(5414,1,650.00,33,169,NULL),(5415,2,760.00,13,175,NULL),(5416,2,1198.00,1,176,NULL),(5417,2,900.00,6,177,NULL),(5418,3,1170.00,32,178,NULL),(5419,1,380.00,15,179,NULL),(5420,3,900.00,30,180,NULL),(5421,1,250.00,5,181,NULL),(5422,2,400.00,34,182,NULL),(5423,1,650.00,33,183,NULL),(5424,3,1350.00,6,184,NULL),(5425,3,1350.00,31,185,NULL),(5426,1,500.00,10,186,NULL),(5427,1,800.00,12,187,NULL),(5428,2,1000.00,10,188,NULL),(5429,1,420.00,19,189,NULL),(5430,3,1200.00,3,190,NULL),(5431,3,1260.00,27,191,NULL),(5432,1,250.00,5,192,NULL),(5433,3,750.00,9,193,NULL),(5434,3,750.00,9,194,NULL),(5435,1,400.00,22,200,NULL),(5436,2,1560.00,14,201,NULL),(5437,2,800.00,22,202,NULL),(5438,1,400.00,3,203,NULL),(5439,3,450.00,8,204,NULL),(5440,2,500.00,5,205,NULL),(5441,1,380.00,15,206,NULL),(5442,2,400.00,2,207,NULL),(5443,2,440.00,28,208,NULL),(5444,3,1200.00,22,209,NULL),(5445,1,880.00,18,210,NULL),(5446,1,380.00,15,211,NULL),(5447,3,2340.00,16,212,NULL),(5448,2,400.00,2,213,NULL),(5449,1,420.00,19,214,NULL),(5450,3,2400.00,12,215,NULL),(5451,3,1260.00,27,216,NULL),(5452,1,400.00,29,217,NULL),(5453,3,750.00,9,218,NULL),(5454,2,760.00,15,219,NULL),(5455,2,1600.00,12,225,NULL),(5456,1,800.00,12,226,NULL),(5457,3,2640.00,18,227,NULL),(5458,3,2640.00,18,228,NULL),(5459,2,800.00,29,229,NULL),(5460,3,900.00,30,230,NULL),(5461,1,420.00,20,231,NULL),(5462,2,1560.00,16,232,NULL),(5463,1,250.00,5,233,NULL),(5464,2,400.00,2,234,NULL),(5465,3,1200.00,22,235,NULL),(5466,3,750.00,9,236,NULL),(5467,2,840.00,20,237,NULL),(5468,3,450.00,8,238,NULL),(5469,1,300.00,30,239,NULL),(5470,2,600.00,26,240,NULL),(5471,2,800.00,3,241,NULL),(5472,2,1300.00,33,242,NULL),(5473,3,1800.00,11,243,NULL),(5474,1,300.00,26,244,NULL),(5475,1,250.00,9,247,NULL),(5476,1,300.00,30,248,NULL),(5477,3,750.00,5,249,NULL),(5478,3,1950.00,33,250,NULL),(5479,3,1950.00,33,251,NULL),(5480,3,1440.00,23,252,NULL),(5481,3,1260.00,19,253,NULL),(5482,2,1760.00,18,254,NULL),(5522,2,600.00,26,150,NULL),(5523,2,600.00,26,152,NULL),(5524,2,960.00,17,154,NULL),(5525,1,300.00,26,156,NULL),(5526,1,390.00,32,158,NULL),(5527,2,840.00,21,176,NULL),(5528,2,300.00,7,178,NULL),(5529,2,300.00,8,180,NULL),(5530,1,300.00,26,182,NULL),(5531,1,800.00,12,200,NULL),(5532,2,760.00,15,202,NULL),(5533,2,400.00,2,204,NULL),(5534,2,840.00,24,206,NULL),(5535,1,420.00,27,208,NULL),(5536,1,450.00,6,226,NULL),(5537,1,200.00,34,228,NULL),(5538,2,300.00,7,230,NULL),(5539,1,480.00,23,232,NULL),(5540,2,840.00,19,248,NULL);
/*!40000 ALTER TABLE `clinic_transactionitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_treatment`
--

DROP TABLE IF EXISTS `clinic_treatment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_treatment` (
  `treatment_id` int(11) NOT NULL AUTO_INCREMENT,
  `treatment_name` varchar(100) NOT NULL,
  `treatment_type` varchar(30) NOT NULL,
  `treatment_cost` decimal(8,2) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`treatment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_treatment`
--

LOCK TABLES `clinic_treatment` WRITE;
/*!40000 ALTER TABLE `clinic_treatment` DISABLE KEYS */;
INSERT INTO `clinic_treatment` VALUES (1,'Deluxe Facial','Facial',499.00,NULL,0),(2,'Whitening Glow Facial','Facial',599.00,NULL,0),(3,'Oil Control Facial','Facial',799.00,NULL,0),(4,'Collagen Facial','Facial',699.00,NULL,0),(5,'Skin Brightening Treatment','Facial',999.00,NULL,0),(6,'Teen Acne Clear Facial','Facial',999.00,NULL,0),(7,'Adult Acne Clear Facial','Facial',1499.00,'Buy 5 Sessions, Get 1 Free',0),(8,'Facial Dermaplanning','Premium Facial',1499.00,NULL,0),(9,'C Aesthetic Luxe Facial','Premium Facial',2499.00,NULL,0),(10,'C Aesthetic ZO Facial','Premium Facial',3499.00,NULL,0),(11,'Full Hydra Facial Treatment','Premium Facial',3499.00,NULL,0),(12,'Full Hydra Facial + Pico/Carbon','Premium Facial',6000.00,NULL,0),(13,'Korean Facial','Premium Facial',2999.00,NULL,0),(14,'Micro Corrective Peel - Per Session','Face Peel',2499.00,NULL,0),(15,'Micro Corrective Peel - Package (2 sessions)','Face Peel',4500.00,NULL,0),(16,'Standard Peel - Per Session','Face Peel',3499.00,NULL,0),(17,'Standard Peel - Package (2 sessions)','Face Peel',5999.00,NULL,0),(18,'Advance Corrective Peel - Per Session','Face Peel',3899.00,NULL,0),(19,'Advance Corrective Peel - Package (3 sessions)','Face Peel',9599.00,NULL,0),(20,'Spot Treatment Peel - Per Session','Face Peel',2199.00,NULL,0),(21,'Spot Treatment Peel - Package (2 sessions)','Face Peel',3499.00,NULL,0),(22,'TCA Cross / Ice Pick Peel - Per Session','Face Peel',4599.00,NULL,0),(23,'TCA Cross / Ice Pick Peel - Package (3 sessions)','Face Peel',11999.00,NULL,0),(24,'Neck Whitening Peel','Body Peel',2599.00,'Buy 4 Sessions, Get 1 Free',0),(25,'Underarm Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(26,'Arm Whitening Peel','Body Peel',4999.00,'Buy 4 Sessions, Get 1 Free',0),(27,'Chest Whitening Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(28,'Back Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(29,'Groin Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(30,'Full Leg Peel','Body Peel',9999.00,'Buy 4 Sessions, Get 1 Free',0),(31,'Half Leg Peel','Body Peel',6999.00,'Buy 4 Sessions, Get 1 Free',0),(32,'Full Face','Whitening Laser',3499.00,'Buy 5 Sessions, Get 1 Free',0),(33,'Partial Face','Whitening Laser',2499.00,'Buy 5 Sessions, Get 1 Free',0),(34,'Nape','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(35,'Underarm','Whitening Laser',1599.00,'Buy 5 Sessions, Get 1 Free',0),(36,'Groin Area','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(37,'Knee','Whitening Laser',1299.00,'Buy 5 Sessions, Get 1 Free',0),(38,'Tattoo Removal','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(39,'Full Face','HIFU',14999.00,NULL,0),(40,'Partial Face','HIFU',6999.00,NULL,0),(41,'Full Face','Thermage',11999.00,NULL,0),(42,'Partial Face','Thermage',6999.00,NULL,0),(43,'Eye','Thermage',5999.00,NULL,0),(44,'Full Face','HIFU + Thermage',25000.00,NULL,0),(45,'Half Face','HIFU + Thermage',12000.00,NULL,0),(46,'Exosome Facial Stamp','Microneedling & RF',5999.00,NULL,0),(47,'Premium RF w/ Exosome','Microneedling & RF',11999.00,NULL,0),(48,'Full Face','Exilift Ultra 360',7500.00,'Buy 5 Sessions, Get 1 Free',0),(49,'Upper Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(50,'Lower Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(51,'Neck','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(52,'Chin','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(53,'Arms','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(54,'Back - Butterfly','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(55,'Back - Upper','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(56,'Back - Lower','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(57,'Tummy','Exilift Ultra 360',3000.00,'Buy 5 Sessions, Get 1 Free',0),(58,'Back & Tummy','Exilift Ultra 360',4000.00,'Buy 5 Sessions, Get 1 Free',0),(59,'Upper / Lower Lip','Diode Laser',499.00,NULL,0),(60,'Underarm - Diode & Whitening Scrub','Diode Laser',1799.00,'+799 Laser Whitening add-on available',0),(61,'Arm - Plain Diode & Whitening Scrub','Diode Laser',2499.00,'+999 Laser Whitening add-on available',0),(62,'Bikini Area with Whitening Scrub','Diode Laser',1499.00,'+599 Laser Whitening add-on available',0),(63,'Legs - Plain Diode & Whitening Scrub','Diode Laser',2799.00,'+1299 Laser Whitening add-on available',0),(64,'Underarm Whitening Scrub','Body Scrub',499.00,NULL,0),(65,'Arm Brightening Scrub','Body Scrub',1500.00,NULL,0),(66,'Back Brightening Scrub','Body Scrub',1500.00,NULL,0),(67,'Legs Brightening Scrub','Body Scrub',1800.00,NULL,0),(68,'Face (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(69,'Neck (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(70,'Face + Neck','Warts/Skin Tag/Milia',3000.00,NULL,0),(71,'Back','Warts/Skin Tag/Milia',1899.00,NULL,0),(72,'Chest','Warts/Skin Tag/Milia',1899.00,NULL,0),(73,'Back + Chest','Warts/Skin Tag/Milia',3500.00,NULL,0),(74,'Genital Warts','Warts/Skin Tag/Milia',2499.00,'Starts at 2,499',0),(75,'Per Piece Big Warts','Warts/Skin Tag/Milia',2499.00,'Per area',0),(76,'Syringoma Removal','Warts/Skin Tag/Milia',1499.00,'Per area',0),(77,'Milia Removal','Warts/Skin Tag/Milia',1499.00,NULL,0),(78,'Full Face','Botox',8000.00,NULL,0),(79,'Forehead','Botox',5000.00,NULL,0),(80,'Crowsfeet','Botox',3500.00,NULL,0),(81,'Jawtox','Botox',10000.00,NULL,0),(82,'Alartox','Botox',7000.00,NULL,0),(83,'Sweatox','Botox',10000.00,NULL,0),(84,'Regular Natural Look','Eyelash Extension',400.00,NULL,0),(85,'Volume','Eyelash Extension',500.00,NULL,0),(86,'Chiro','Massage',200.00,'chrio massage',0);
/*!40000 ALTER TABLE `clinic_treatment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_treatmentproduct`
--

DROP TABLE IF EXISTS `clinic_treatmentproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_treatmentproduct` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity_used` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clinic_treatmentproduct_branch_id_treatment_id_p_41224be2_uniq` (`branch_id`,`treatment_id`,`product_id`),
  KEY `clinic_treatmentprod_product_id_b8b3a019_fk_clinic_pr` (`product_id`),
  KEY `clinic_treatmentprod_treatment_id_afdded54_fk_clinic_tr` (`treatment_id`),
  CONSTRAINT `clinic_treatmentprod_branch_id_4f531c41_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_treatmentprod_product_id_b8b3a019_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`),
  CONSTRAINT `clinic_treatmentprod_treatment_id_afdded54_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_treatmentproduct`
--

LOCK TABLES `clinic_treatmentproduct` WRITE;
/*!40000 ALTER TABLE `clinic_treatmentproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `clinic_treatmentproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clinic_userlockout`
--

DROP TABLE IF EXISTS `clinic_userlockout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clinic_userlockout` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `failed_attempts` int(11) NOT NULL,
  `lock_until` datetime(6) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `clinic_userlockout_user_id_267edba5_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_userlockout`
--

LOCK TABLES `clinic_userlockout` WRITE;
/*!40000 ALTER TABLE `clinic_userlockout` DISABLE KEYS */;
INSERT INTO `clinic_userlockout` VALUES (1,0,NULL,3),(2,0,NULL,5),(3,1,NULL,4),(4,0,NULL,2);
/*!40000 ALTER TABLE `clinic_userlockout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-02-11 07:49:24.476256','1','Mr. Supplier',1,'[{\"added\": {}}]',17,1),(2,'2026-02-11 07:49:45.128049','1','Gluta Test',1,'[{\"added\": {}}]',14,1),(3,'2026-02-11 07:50:08.166722','2','Cleanser Test',1,'[{\"added\": {}}]',14,1),(4,'2026-02-11 07:50:56.043038','1','Chiro',1,'[{\"added\": {}}]',19,1),(5,'2026-02-11 07:51:43.161842','2','Peel the Banana',1,'[{\"added\": {}}]',19,1),(6,'2026-02-11 08:02:35.011229','1','Abesamis, Jaron',1,'[{\"added\": {}}]',12,1),(7,'2026-03-15 16:07:22.299054','1','Main',1,'[{\"added\": {}}]',10,1),(8,'2026-03-17 05:42:41.388851','1','Profile for user',1,'[{\"added\": {}}]',21,1),(9,'2026-03-17 05:44:41.708195','1','Owner',1,'[{\"added\": {}}]',2,1),(10,'2026-03-17 05:44:56.531389','1','Owner',2,'[]',2,1),(11,'2026-03-17 05:48:16.601416','1','Owner',2,'[]',2,1),(12,'2026-03-17 05:51:18.681152','2','owner',1,'[{\"added\": {}}]',4,1),(13,'2026-03-22 06:50:46.123623','3','martinco',1,'[{\"added\": {}}]',4,1),(14,'2026-04-10 09:17:58.263821','3','martinco',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',4,4),(15,'2026-04-10 09:18:24.765602','2','owner',2,'[{\"changed\": {\"fields\": [\"Staff status\"]}}]',4,4),(16,'2026-04-10 09:46:48.002088','3','martinco',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,4),(17,'2026-04-12 10:24:58.996040','5','owner01',1,'[{\"added\": {}}]',4,3),(18,'2026-04-12 10:27:00.655270','5','owner01',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Superuser status\", \"Groups\"]}}]',4,3);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(7,'clinic','account'),(8,'clinic','branchproduct'),(9,'clinic','branchtreatment'),(10,'clinic','clinicbranch'),(21,'clinic','employeeprofile'),(11,'clinic','inventoryshipment'),(12,'clinic','patient'),(13,'clinic','patientvisit'),(14,'clinic','product'),(15,'clinic','receivedproduct'),(16,'clinic','salestransaction'),(17,'clinic','supplier'),(18,'clinic','transactionitem'),(19,'clinic','treatment'),(20,'clinic','treatmentproduct'),(22,'clinic','userlockout'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-02-11 06:36:29.751908'),(2,'auth','0001_initial','2026-02-11 06:36:30.380513'),(3,'admin','0001_initial','2026-02-11 06:36:30.535690'),(4,'admin','0002_logentry_remove_auto_add','2026-02-11 06:36:30.564713'),(5,'admin','0003_logentry_add_action_flag_choices','2026-02-11 06:36:30.602916'),(6,'contenttypes','0002_remove_content_type_name','2026-02-11 06:36:30.702700'),(7,'auth','0002_alter_permission_name_max_length','2026-02-11 06:36:30.822800'),(8,'auth','0003_alter_user_email_max_length','2026-02-11 06:36:30.881481'),(9,'auth','0004_alter_user_username_opts','2026-02-11 06:36:30.916413'),(10,'auth','0005_alter_user_last_login_null','2026-02-11 06:36:30.997886'),(11,'auth','0006_require_contenttypes_0002','2026-02-11 06:36:31.006123'),(12,'auth','0007_alter_validators_add_error_messages','2026-02-11 06:36:31.032827'),(13,'auth','0008_alter_user_username_max_length','2026-02-11 06:36:31.066820'),(14,'auth','0009_alter_user_last_name_max_length','2026-02-11 06:36:31.103154'),(15,'auth','0010_alter_group_name_max_length','2026-02-11 06:36:31.147806'),(16,'auth','0011_update_proxy_permissions','2026-02-11 06:36:31.165709'),(17,'auth','0012_alter_user_first_name_max_length','2026-02-11 06:36:31.188489'),(18,'clinic','0001_initial','2026-02-11 06:36:33.037314'),(19,'sessions','0001_initial','2026-02-11 06:36:33.080913'),(20,'clinic','0002_alter_branchproduct_id_alter_branchtreatment_id_and_more','2026-02-23 09:41:09.059545'),(21,'clinic','0003_salestransaction_notes','2026-03-15 08:49:37.345526'),(22,'clinic','0004_employeeprofile_delete_account','2026-03-17 05:36:55.489511'),(23,'clinic','0005_remove_clinicbranch_branch_address_and_more','2026-03-17 05:36:55.563816'),(24,'clinic','0006_clinicbranch_branch_address','2026-03-17 05:36:55.581494'),(25,'clinic','0007_remove_inventoryshipment_date_received_and_more','2026-03-22 07:19:16.858447'),(26,'clinic','0008_inventoryshipment_date_received','2026-03-22 07:34:16.116061'),(27,'clinic','0009_salestransaction_branch','2026-04-10 08:28:06.407058'),(28,'clinic','0010_remove_clinicbranch_date_added_userlockout_and_more','2026-04-10 08:28:06.528544'),(29,'clinic','0011_remove_clinicbranch_date_added','2026-04-10 08:28:06.543541'),(30,'clinic','0012_product_is_deleted_treatment_is_deleted','2026-04-14 07:13:15.928662'),(31,'clinic','0013_patient_is_deleted','2026-04-22 05:35:10.312996'),(32,'clinic','0014_alter_patient_middle_name','2026-04-22 05:35:10.388957'),(33,'clinic','0015_patient_unique_patient_identity','2026-04-22 05:35:10.419256'),(34,'clinic','0016_supplier_is_deleted','2026-04-22 11:23:21.515292'),(35,'clinic','0016_remove_clinicbranch_branch_address_and_more','2026-04-25 16:25:13.253525'),(36,'clinic','0017_clinicbranch_branch_address_and_more','2026-04-25 16:25:13.319454'),(37,'clinic','0018_clinicbranch_is_deleted','2026-04-25 16:25:13.350755'),(38,'clinic','0019_merge_20260425_2336','2026-04-25 16:25:13.354361'),(39,'clinic','0020_remove_clinicbranch_is_deleted_and_more','2026-04-25 16:25:13.415343'),(40,'clinic','0021_clinicbranch_is_deleted','2026-04-26 05:19:31.382540');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0fbn30gvjrlu9u2p2m35po6uchm736yf','.eJxVjEEOwiAQRe_C2hBoZ5jWpXvPQGAGpGpoUtqV8e7apAvd_vfefykftrX4raXFT6LOyqrT7xYDP1LdgdxDvc2a57ouU9S7og_a9HWW9Lwc7t9BCa1869EAIkqKmSCyAwM5OuI0IoJhMWBslyORI8GcByJLLMwOQz_0HbB6fwDb3zew:1vq3tt:kXxVgqfWtbKy9a087z-RslDySTSmJh-JrUK_STrvobk','2026-02-25 06:40:37.097256'),('26ird0i12bvabkufm9krh44nhe6cdqwa','.eJxVjMsOgyAUBf_lro1BARGX3fcbyOVVqRQagVXTf29N3Lg9M3M-4DFEZxXW6l7vWmAhHcRsNtVSDRGW1GLsQGGrq2rF7SpYWIDCZdNoNpcOYJ-YHrk3OdU96P5Q-pOW_p6ti7fTvRysWNZ_zQbLcBSOoEDGvObS09EQSuZ5mohEYuWgmWaGcjpIwSmdKOdaOKcNZ7OH7w_4PkS4:1wCXy9:r8adCvD5IAt_STTP1beNqwp07_hP7PRr4lDfp12RvDU','2026-04-28 07:13:57.092224'),('2ls3061dbirvv7gwwb3kki8wl51fvux5','.eJxVjEsOAiEQBe_C2hC-QVy69wykm25k1EAyzKyMdzcks9Dtq6r3Fgn2raZ98JoWEhfhxOl3Q8hPbhPQA9q9y9zbti4opyIPOuStE7-uh_t3UGHUWavonQ0ERSNpxU4hQrCYvTlrZJWD5RJ99qw1FTCFdGRjjQmkLNgsPl_5wThw:1wB7y8:BgxwccjssIHLoRzfyfR0uNHNsAraJG289mhi7vHjCVI','2026-04-24 09:16:04.588112'),('5fmnxbrbwg5takcgcc98mvht81jibanq','.eJxVj0EOgyAURO_y18aggKjL7nsG8oFPpaXYCKya3r2auHE7b-Yl8wWPIZLTWAq9PyXDzBqIq33pmkqIMKcaYwMaa1l0zbTp4GAGDpfMoH1ROoB7YnqsrV1T2YJpj0p70tzeV0fxdnYvggXzsq9F5wT2ihgqFMIbOXneW8bZOA4Dm5C5qTPCCMsl7yYlOR-4lEYRGSvF6Hdppki27I_Mhske0g5-fzV2S-0:1wGCUp:P7_XGOxS85YVwOk-A0MNo2pPBZY0fqyPStw8CJugUnk','2026-05-08 09:06:47.481149'),('9yp8ovciu9ewbsfnei1gruhwgji15n4h','.eJxVjEsOAiEQBe_C2hC-QVy69wykm25k1EAyzKyMdzcks9Dtq6r3Fgn2raZ98JoWEhfhxOl3Q8hPbhPQA9q9y9zbti4opyIPOuStE7-uh_t3UGHUWavonQ0ERSNpxU4hQrCYvTlrZJWD5RJ99qw1FTCFdGRjjQmkLNgsPl_5wThw:1wB8Li:LbHXIVxOXE9hRHQ0LNntuqLGcwe0g6Mia9jSt_4Iygw','2026-04-24 09:40:26.648123'),('btu0zeosmt8wqsjkrj9zpfibame8zwv8','.eJxVj0EOgyAURO_y18aggKjL7nsG8oFPpaXYCKya3r2auHE7b-Yl8wWPIZLTWAq9PyXDzBqIq33pmkqIMKcaYwMaa1l0zbTp4GAGDpfMoH1ROoB7YnqsrV1T2YJpj0p70tzeV0fxdnYvggXzsq9F5wT2ihgqFMIbOXneW8bZOA4Dm5C5qTPCCMsl7yYlOR-4lEYRGSvF6Hdppki27I_Mhske0g5-fzV2S-0:1wGfp2:LdGnzSHYcqnaoh1ZMt04WasbE9wioyxD_bZ_jRh0S3U','2026-05-09 16:25:36.314524'),('em93cvjdb539rs612gnh5q6ube1y7hii','.eJxVjMsOgyAUBf_lro1BARGX3fcbyOVVqRQagVXTf29N3Lg9M3M-4DFEZxXW6l7vWmAhHcRsNtVSDRGW1GLsQGGrq2rF7SpYWIDCZdNoNpcOYJ-YHrk3OdU96P5Q-pOW_p6ti7fTvRysWNZ_zQbLcBSOoEDGvObS09EQSuZ5mohEYuWgmWaGcjpIwSmdKOdaOKcNZ7OH7w_4PkS4:1wGsjO:KcHdeLWICasrfDOZc2RMv_jV-O3MWkk7p2l501L5H8I','2026-05-10 06:12:38.897120'),('r4vgobh0o6civr43kl7znc8y4ffh3ibj','.eJxVjEsOAiEQBe_C2hCYbgZw6d4zkG4-Mmogmc_KeHedZBa6fVX1XiLQttawLXkOUxJnAeL0uzHFR247SHdqty5jb-s8sdwVedBFXnvKz8vh_h1UWuq3Rp2QBpsVWUIsbHyBISpQzo2j8qSS14yMEQxobw3ACMawzZmjQVfE-wPGyDcP:1w4CgT:CZFWg84EtzcxNTRIWGXxa2YDUmBKgA6v6LDOini7-lw','2026-04-05 06:53:13.105723');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-04  1:02:33
