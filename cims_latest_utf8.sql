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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$wywmv7bk09g7bGbgRlLDKS$0oF2acBJlbT6DyPunlEnCkb5mAMiVCQw9YG1hP+7kpw=','2026-04-10 08:34:59.201911',1,'cookie','Cookie','','',1,1,'2026-02-11 06:37:40.652883'),(2,'pbkdf2_sha256$1200000$BXBDo9EDkrCQWh264xNN4r$dNkG3f6Snv+ifOs5OV944Kng6OFhBg92b2BJFteOvRA=','2026-03-17 05:51:37.000000',0,'jenny','Jenny','','',1,1,'2026-03-17 05:51:17.000000'),(3,'pbkdf2_sha256$1200000$5xSc73PM7tI6a6hDQZODPU$jP7qhqxNyZYK3Fam6W9wfkIWrPfno2uin/Uz+rkrZPQ=','2026-04-24 06:40:32.861927',0,'martinco','','','',1,1,'2026-03-22 06:50:43.000000'),(4,'pbkdf2_sha256$1200000$7DOUY1uI52lIPSrx9lmkQc$Rzc62yazQHywZXT9xVi8DYrpcTsrd06rOPrD4CvNpS8=','2026-04-22 10:13:19.865063',1,'random','test','','',1,0,'2026-04-10 09:15:17.521141'),(5,'pbkdf2_sha256$1200000$9Vwhv9t2vq0dJK7SvIMP9o$+k3ZR3c/7jWq6ukl6vFtEPKegQZBNMQKmZXhbYTw5vU=','2026-04-12 10:31:58.085703',1,'marie','Marie','','',1,1,'2026-04-12 10:24:56.000000'),(6,'pbkdf2_sha256$1200000$jgtURzcVCgPSFSbRTZmC10$iJOFoyg2uTVKdj7T+fkqRkN337hHy77q+VThs14Jzh4=',NULL,0,'ChonaSP','Owner Chona','','',0,1,'2026-04-12 10:40:40.599154'),(7,'pbkdf2_sha256$1200000$AEgDIks64L1G4m530kjonR$4EmWyBs7IQM2HxUe9mG4PopQuuIAGVauzeCAHWlv/zc=',NULL,0,'QCMissKim','Aesthetician Kim Updated','','',0,0,'2026-04-22 07:42:55.602449'),(8,'pbkdf2_sha256$1200000$8hcd7QwqiAOXMuloBx8EFn$i581WflNsqwgDKulf4w2L1/2fKQ6qF3WtdnVbJbw6Jo=',NULL,0,'MissIya','Sales Team Iya','','',0,1,'2026-04-22 07:44:36.629199'),(9,'pbkdf2_sha256$1200000$huChR69lSUFDq1H4w6mnJM$lHQE4tiZc2Ws23NpuXa3DyGh1+Mlw8h6Jji2IEby09w=',NULL,0,'NewIyak','Sales Team Iyak','','',0,1,'2026-04-22 07:49:55.300266');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (8,1,2),(6,2,2),(1,3,1),(23,4,2),(7,5,3),(3,6,1),(20,7,3),(10,8,3),(11,9,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchproduct`
--

LOCK TABLES `clinic_branchproduct` WRITE;
/*!40000 ALTER TABLE `clinic_branchproduct` DISABLE KEYS */;
INSERT INTO `clinic_branchproduct` VALUES (1,30,750,1,31),(2,30,94,1,8),(3,30,31,1,9),(4,30,67,1,41),(5,30,100,1,1),(6,30,50,1,2),(7,30,100,1,3),(8,30,50,1,4),(9,30,100,1,5),(10,30,50,1,6),(11,30,100,1,7),(12,30,50,1,10),(13,30,100,1,29),(14,30,100,1,30),(15,30,100,1,33),(16,30,100,1,34),(17,30,100,1,35),(19,30,134,1,49),(20,30,0,1,11),(21,30,0,1,12),(22,30,0,1,13),(23,30,0,1,14),(24,30,0,1,15),(25,30,0,1,16),(26,30,0,1,17),(27,30,0,1,18),(28,30,0,1,19),(29,30,0,1,20),(30,30,0,1,21),(31,30,0,1,22),(32,30,0,1,23),(33,30,0,1,24),(34,30,0,1,25),(35,30,0,1,26),(36,30,0,1,27),(37,30,0,1,28),(38,30,0,1,32),(39,30,0,1,36),(40,30,0,1,37),(41,30,0,1,38),(42,30,0,1,39),(43,30,0,1,40),(44,30,0,1,42),(45,30,0,1,43),(46,30,0,1,44),(47,30,0,1,45),(48,30,0,1,46),(49,30,0,1,47),(51,30,3,2,9),(53,30,23,1,50),(54,30,20,4,50),(55,30,20,2,50),(56,30,0,4,1),(57,30,0,2,1),(58,30,0,4,2),(59,30,0,2,2),(60,30,0,4,3),(61,30,0,2,3),(62,30,0,4,4),(63,30,0,2,4),(64,30,0,4,5),(65,30,0,2,5),(66,30,0,4,6),(67,30,0,2,6),(68,30,0,4,7),(69,30,0,2,7),(70,30,0,4,8),(71,30,0,2,8),(72,30,0,4,9),(73,30,0,4,10),(74,30,0,2,10),(75,30,0,4,11),(76,30,0,2,11),(77,30,0,4,12),(78,30,0,2,12),(79,30,0,4,13),(80,30,0,2,13),(81,30,0,4,14),(82,30,0,2,14),(83,30,0,4,15),(84,30,0,2,15),(85,30,0,4,16),(86,30,0,2,16),(87,30,0,4,17),(88,30,0,2,17),(89,30,0,4,18),(90,30,0,2,18),(91,30,0,4,19),(92,30,0,2,19),(93,30,0,4,20),(94,30,0,2,20),(95,30,0,4,21),(96,30,0,2,21),(97,30,0,4,22),(98,30,0,2,22),(99,30,0,4,23),(100,30,0,2,23),(101,30,0,4,24),(102,30,0,2,24),(103,30,0,4,25),(104,30,0,2,25),(105,30,0,4,26),(106,30,0,2,26),(107,30,0,4,27),(108,30,0,2,27),(109,30,0,4,28),(110,30,0,2,28),(111,30,0,4,29),(112,30,0,2,29),(113,30,0,4,30),(114,30,0,2,30),(115,30,0,4,31),(116,30,0,2,31),(117,30,0,4,32),(118,30,0,2,32),(119,30,0,4,33),(120,30,0,2,33),(121,30,0,4,34),(122,30,0,2,34),(123,30,0,4,35),(124,30,0,2,35),(125,30,0,4,36),(126,30,0,2,36),(127,30,0,4,37),(128,30,0,2,37),(129,30,0,4,38),(130,30,0,2,38),(131,30,0,4,39),(132,30,0,2,39),(133,30,0,4,40),(134,30,0,2,40),(135,30,0,4,41),(136,30,0,2,41),(137,30,0,4,42),(138,30,0,2,42),(139,30,0,4,43),(140,30,0,2,43),(141,30,0,4,44),(142,30,0,2,44),(143,30,0,4,45),(144,30,0,2,45),(145,30,0,4,46),(146,30,0,2,46),(147,30,0,4,47),(148,30,0,2,47),(149,30,0,4,49),(150,30,0,2,49);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchtreatment`
--

LOCK TABLES `clinic_branchtreatment` WRITE;
/*!40000 ALTER TABLE `clinic_branchtreatment` DISABLE KEYS */;
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
  PRIMARY KEY (`branch_id`),
  UNIQUE KEY `clinic_clinicbranch_branch_location_f4a2f259_uniq` (`branch_location`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_clinicbranch`
--

LOCK TABLES `clinic_clinicbranch` WRITE;
/*!40000 ALTER TABLE `clinic_clinicbranch` DISABLE KEYS */;
INSERT INTO `clinic_clinicbranch` VALUES (1,'Meycauayan, Bulacan',NULL),(2,'San Juan','Greenhills'),(4,'Quezon City','New York, Cubao');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_employeeprofile`
--

LOCK TABLES `clinic_employeeprofile` WRITE;
/*!40000 ALTER TABLE `clinic_employeeprofile` DISABLE KEYS */;
INSERT INTO `clinic_employeeprofile` VALUES (1,0,2,1),(2,0,1,3),(3,1,NULL,6),(4,0,2,4),(5,0,1,2),(6,1,NULL,5),(7,0,1,7),(8,0,4,8),(9,0,4,9);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_inventoryshipment`
--

LOCK TABLES `clinic_inventoryshipment` WRITE;
/*!40000 ALTER TABLE `clinic_inventoryshipment` DISABLE KEYS */;
INSERT INTO `clinic_inventoryshipment` VALUES (6,'Acne Laser',1,1,'2026-03-13'),(7,'Anti-Melasma Serum',1,1,'2026-03-16'),(8,'Esthetmax Jelly Mask',1,1,'2025-10-05'),(9,'Special Mask',1,1,'2025-10-18'),(10,'Jelly Mask',1,1,'2025-11-03'),(11,'Gold Mask',1,1,'2025-11-20'),(12,'Extraction',1,1,'2025-12-02'),(13,'Ear Gun Piercing',1,1,'2025-12-15'),(14,'Keloid Injection',1,1,'2026-01-08'),(15,'Acne Shot',1,1,'2026-01-22'),(16,'Topical Anesthesia',1,1,'2026-03-01'),(17,'Cleansing Solution (150ml)',1,1,'2026-01-10'),(18,'Clarifying Solution (60ml)',1,1,'2026-01-15'),(19,'Body Astringent (150ml)',1,1,'2026-02-01'),(20,'Brightening Soap (90g)',1,1,'2026-02-15'),(21,'Bleaching Soap (90g)',1,1,'2026-03-01'),(22,'Acne Shot',1,1,'2026-03-17'),(23,'Acne Laser',1,1,'2026-04-10'),(24,'Acne Laser',2,1,'2026-04-10'),(26,'Test Soap',1,5,'2026-04-24');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_patient`
--

LOCK TABLES `clinic_patient` WRITE;
/*!40000 ALTER TABLE `clinic_patient` DISABLE KEYS */;
INSERT INTO `clinic_patient` VALUES (1,'Abesamis','Jaron','I.','JUNIOR','yes','0906058609','2025-02-11','M',0),(2,'Ayunga','Enzo','',NULL,'There','09084201347','2004-02-05','M',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_product`
--

LOCK TABLES `clinic_product` WRITE;
/*!40000 ALTER TABLE `clinic_product` DISABLE KEYS */;
INSERT INTO `clinic_product` VALUES (1,'Esthetmax Jelly Mask','Add-On',NULL,599.00,1,0),(2,'Special Mask','Add-On',NULL,200.00,1,0),(3,'Jelly Mask','Add-On',NULL,400.00,1,0),(4,'Gold Mask','Add-On',NULL,550.00,1,0),(5,'Extraction','Add-On',NULL,250.00,1,0),(6,'Ear Gun Piercing','Add-On',NULL,450.00,1,0),(7,'Keloid Injection','Add-On','Per unit',150.00,1,0),(8,'Acne Shot','Add-On','Per unit',150.00,1,0),(9,'Acne Laser','Add-On','None',250.00,1,0),(10,'Topical Anesthesia','Add-On',NULL,500.00,1,0),(11,'Local Anesthesia','Add-On',NULL,600.00,1,0),(12,'Gluta IV Push','Add-On','Per vial',800.00,1,0),(13,'Night Cream (10g)','Cream',NULL,380.00,1,0),(14,'Night Cream (25g)','Cream',NULL,780.00,1,0),(15,'Day Cream (10g)','Cream',NULL,380.00,1,0),(16,'Day Cream (25g)','Cream',NULL,780.00,1,0),(17,'Peeling Cream (10g)','Cream',NULL,480.00,1,0),(18,'Peeling Cream (25g)','Cream',NULL,880.00,1,0),(19,'Sunscreen Gel (10g)','Cream',NULL,420.00,1,0),(20,'Sunscreen Foundation (10g)','Cream',NULL,420.00,1,0),(21,'Sunblock Foundation (10g)','Cream',NULL,420.00,1,0),(22,'Clindamycin Cream (10g)','Cream',NULL,400.00,1,0),(23,'Collagen Cream (10g)','Cream',NULL,480.00,1,0),(24,'Glycolic Cream (10g)','Cream',NULL,420.00,1,0),(25,'Hydrocortisone Cream (10g)','Cream',NULL,420.00,1,0),(26,'Erythromycin Cream (10g)','Cream',NULL,300.00,1,0),(27,'Underarm Whitening (10g)','Cream',NULL,420.00,1,0),(28,'Cleansing Solution (60ml)','Solution',NULL,220.00,1,0),(29,'Cleansing Solution (150ml)','Solution',NULL,400.00,1,0),(30,'Clarifying Solution (60ml)','Solution',NULL,300.00,1,0),(31,'Clarifying Solution (150ml)','Solution',NULL,450.00,1,0),(32,'Clindamycin Solution (60ml)','Solution',NULL,390.00,1,0),(33,'Body Astringent (150ml)','Solution',NULL,650.00,1,0),(34,'Brightening Soap (90g)','Soap',NULL,200.00,1,0),(35,'Bleaching Soap (90g)','Soap',NULL,280.00,1,0),(36,'Hydramide Soap (150g)','Soap',NULL,420.00,1,0),(37,'Collagen Serum','Serum',NULL,450.00,1,0),(38,'Miracle Serum','Serum',NULL,450.00,1,0),(39,'Tomato Serum','Serum',NULL,450.00,1,0),(40,'Hydrating Serum','Serum',NULL,450.00,1,0),(41,'Anti-Melasma Serum','Serum',NULL,500.00,1,0),(42,'Glass Serum','Serum',NULL,450.00,1,0),(43,'Gold Serum','Serum',NULL,450.00,1,0),(44,'Retinol Serum','Serum',NULL,500.00,1,0),(45,'Niacinamide Serum','Serum',NULL,450.00,1,0),(46,'Hyaluronic Serum','Serum',NULL,450.00,1,0),(47,'Puff Away Serum','Serum',NULL,450.00,1,0),(49,'New Product Updated','New type','this',400.00,1,0),(50,'Test Soap','Soap','pangtest lang',50.00,5,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
  `total_price_of_products` decimal(8,2) DEFAULT NULL,
  `total_price_of_treatments` decimal(8,2) DEFAULT NULL,
  `total_amount` decimal(8,2) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `notes` longtext DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` (`patient_id`),
  KEY `clinic_salestransact_branch_id_8434fca6_fk_clinic_cl` (`branch_id`),
  CONSTRAINT `clinic_salestransact_branch_id_8434fca6_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  CONSTRAINT `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` FOREIGN KEY (`patient_id`) REFERENCES `clinic_patient` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_salestransaction`
--

LOCK TABLES `clinic_salestransaction` WRITE;
/*!40000 ALTER TABLE `clinic_salestransaction` DISABLE KEYS */;
INSERT INTO `clinic_salestransaction` VALUES (1,'2026-02-23','Card',480.00,499.00,979.00,1,NULL,1),(2,'2026-02-23','GCash',0.00,2499.00,2499.00,1,NULL,1),(3,'2026-02-23','GCash',0.00,24500.00,24500.00,1,NULL,1),(4,'2026-02-23','Card',480.00,1499.00,1979.00,1,NULL,1),(5,'2026-02-23','Cash',0.00,2499.00,2499.00,2,NULL,1),(7,'2026-03-22','GCash',75000.00,0.00,75000.00,1,'',1),(8,'2026-03-22','Cash',10000.00,0.00,10000.00,1,'',1),(13,'2026-03-24','Cash',1050.00,0.00,1050.00,1,'none',1),(15,'2026-04-22','GCash',750.00,4499.00,5249.00,2,'',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_supplier`
--

LOCK TABLES `clinic_supplier` WRITE;
/*!40000 ALTER TABLE `clinic_supplier` DISABLE KEYS */;
INSERT INTO `clinic_supplier` VALUES (1,'Mr. Supplier','Mang Tani','09060585960','Over There',0),(2,'Test Supplier for Page','Sir Jal','09060453412','Katipunan Ave.',1),(3,'SkinCare Distributors Inc.','Maria De Mesa','09171234123','Tomas Morato, Quezon City',0),(4,'Supplier Updated','Fiona Metran','09060585960','there pala',0),(5,'For Deleting','delte','09060596070','yup',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_transactionitem`
--

LOCK TABLES `clinic_transactionitem` WRITE;
/*!40000 ALTER TABLE `clinic_transactionitem` DISABLE KEYS */;
INSERT INTO `clinic_transactionitem` VALUES (1,1,480.00,23,1,NULL),(2,1,499.00,NULL,1,64),(3,1,2499.00,NULL,2,75),(4,7,24500.00,NULL,3,80),(5,1,480.00,23,4,NULL),(6,1,1499.00,NULL,4,77),(9,1,2499.00,NULL,5,75),(13,500,75000.00,8,7,NULL),(14,40,10000.00,9,8,NULL),(18,7,1050.00,8,13,NULL),(19,5,750.00,8,15,NULL),(20,1,4499.00,NULL,15,28);
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
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_treatment`
--

LOCK TABLES `clinic_treatment` WRITE;
/*!40000 ALTER TABLE `clinic_treatment` DISABLE KEYS */;
INSERT INTO `clinic_treatment` VALUES (1,'Deluxe Facial','Facial',499.00,NULL,0),(2,'Whitening Glow Facial','Facial',599.00,NULL,0),(3,'Oil Control Facial','Facial',799.00,NULL,0),(4,'Collagen Facial','Facial',699.00,NULL,0),(5,'Skin Brightening Treatment','Facial',999.00,NULL,0),(6,'Teen Acne Clear Facial','Facial',999.00,NULL,0),(7,'Adult Acne Clear Facial','Facial',1499.00,'Buy 5 Sessions, Get 1 Free',0),(8,'Facial Dermaplanning','Premium Facial',1499.00,NULL,0),(9,'C Aesthetic Luxe Facial','Premium Facial',2499.00,NULL,0),(10,'C Aesthetic ZO Facial','Premium Facial',3499.00,NULL,0),(11,'Full Hydra Facial Treatment','Premium Facial',3499.00,NULL,0),(12,'Full Hydra Facial + Pico/Carbon','Premium Facial',6000.00,NULL,0),(13,'Korean Facial','Premium Facial',2999.00,NULL,0),(14,'Micro Corrective Peel - Per Session','Face Peel',2499.00,NULL,0),(15,'Micro Corrective Peel - Package (2 sessions)','Face Peel',4500.00,NULL,0),(16,'Standard Peel - Per Session','Face Peel',3499.00,NULL,0),(17,'Standard Peel - Package (2 sessions)','Face Peel',5999.00,NULL,0),(18,'Advance Corrective Peel - Per Session','Face Peel',3899.00,NULL,0),(19,'Advance Corrective Peel - Package (3 sessions)','Face Peel',9599.00,NULL,0),(20,'Spot Treatment Peel - Per Session','Face Peel',2199.00,NULL,0),(21,'Spot Treatment Peel - Package (2 sessions)','Face Peel',3499.00,NULL,0),(22,'TCA Cross / Ice Pick Peel - Per Session','Face Peel',4599.00,NULL,0),(23,'TCA Cross / Ice Pick Peel - Package (3 sessions)','Face Peel',11999.00,NULL,0),(24,'Neck Whitening Peel','Body Peel',2599.00,'Buy 4 Sessions, Get 1 Free',0),(25,'Underarm Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(26,'Arm Whitening Peel','Body Peel',4999.00,'Buy 4 Sessions, Get 1 Free',0),(27,'Chest Whitening Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(28,'Back Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(29,'Groin Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(30,'Full Leg Peel','Body Peel',9999.00,'Buy 4 Sessions, Get 1 Free',0),(31,'Half Leg Peel','Body Peel',6999.00,'Buy 4 Sessions, Get 1 Free',0),(32,'Full Face','Whitening Laser',3499.00,'Buy 5 Sessions, Get 1 Free',0),(33,'Partial Face','Whitening Laser',2499.00,'Buy 5 Sessions, Get 1 Free',0),(34,'Nape','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(35,'Underarm','Whitening Laser',1599.00,'Buy 5 Sessions, Get 1 Free',0),(36,'Groin Area','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(37,'Knee','Whitening Laser',1299.00,'Buy 5 Sessions, Get 1 Free',0),(38,'Tattoo Removal','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(39,'Full Face','HIFU',14999.00,NULL,0),(40,'Partial Face','HIFU',6999.00,NULL,0),(41,'Full Face','Thermage',11999.00,NULL,0),(42,'Partial Face','Thermage',6999.00,NULL,0),(43,'Eye','Thermage',5999.00,NULL,0),(44,'Full Face','HIFU + Thermage',25000.00,NULL,0),(45,'Half Face','HIFU + Thermage',12000.00,NULL,0),(46,'Exosome Facial Stamp','Microneedling & RF',5999.00,NULL,0),(47,'Premium RF w/ Exosome','Microneedling & RF',11999.00,NULL,0),(48,'Full Face','Exilift Ultra 360',7500.00,'Buy 5 Sessions, Get 1 Free',0),(49,'Upper Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(50,'Lower Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(51,'Neck','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(52,'Chin','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(53,'Arms','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(54,'Back - Butterfly','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(55,'Back - Upper','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(56,'Back - Lower','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(57,'Tummy','Exilift Ultra 360',3000.00,'Buy 5 Sessions, Get 1 Free',0),(58,'Back & Tummy','Exilift Ultra 360',4000.00,'Buy 5 Sessions, Get 1 Free',0),(59,'Upper / Lower Lip','Diode Laser',499.00,NULL,0),(60,'Underarm - Diode & Whitening Scrub','Diode Laser',1799.00,'+799 Laser Whitening add-on available',0),(61,'Arm - Plain Diode & Whitening Scrub','Diode Laser',2499.00,'+999 Laser Whitening add-on available',0),(62,'Bikini Area with Whitening Scrub','Diode Laser',1499.00,'+599 Laser Whitening add-on available',0),(63,'Legs - Plain Diode & Whitening Scrub','Diode Laser',2799.00,'+1299 Laser Whitening add-on available',0),(64,'Underarm Whitening Scrub','Body Scrub',499.00,NULL,0),(65,'Arm Brightening Scrub','Body Scrub',1500.00,NULL,0),(66,'Back Brightening Scrub','Body Scrub',1500.00,NULL,0),(67,'Legs Brightening Scrub','Body Scrub',1800.00,NULL,0),(68,'Face (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(69,'Neck (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(70,'Face + Neck','Warts/Skin Tag/Milia',3000.00,NULL,0),(71,'Back','Warts/Skin Tag/Milia',1899.00,NULL,0),(72,'Chest','Warts/Skin Tag/Milia',1899.00,NULL,0),(73,'Back + Chest','Warts/Skin Tag/Milia',3500.00,NULL,0),(74,'Genital Warts','Warts/Skin Tag/Milia',2499.00,'Starts at 2,499',0),(75,'Per Piece Big Warts','Warts/Skin Tag/Milia',2499.00,'Per area',0),(76,'Syringoma Removal','Warts/Skin Tag/Milia',1499.00,'Per area',0),(77,'Milia Removal','Warts/Skin Tag/Milia',1499.00,NULL,0),(78,'Full Face','Botox',8000.00,NULL,0),(79,'Forehead','Botox',5000.00,NULL,0),(80,'Crowsfeet','Botox',3500.00,NULL,0),(81,'Jawtox','Botox',10000.00,NULL,0),(82,'Alartox','Botox',7000.00,NULL,0),(83,'Sweatox','Botox',10000.00,NULL,0),(84,'Regular Natural Look','Eyelash Extension',400.00,NULL,0),(85,'Volume','Eyelash Extension',500.00,NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_userlockout`
--

LOCK TABLES `clinic_userlockout` WRITE;
/*!40000 ALTER TABLE `clinic_userlockout` DISABLE KEYS */;
INSERT INTO `clinic_userlockout` VALUES (1,0,NULL,3),(2,0,NULL,5),(3,1,NULL,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-02-11 06:36:29.751908'),(2,'auth','0001_initial','2026-02-11 06:36:30.380513'),(3,'admin','0001_initial','2026-02-11 06:36:30.535690'),(4,'admin','0002_logentry_remove_auto_add','2026-02-11 06:36:30.564713'),(5,'admin','0003_logentry_add_action_flag_choices','2026-02-11 06:36:30.602916'),(6,'contenttypes','0002_remove_content_type_name','2026-02-11 06:36:30.702700'),(7,'auth','0002_alter_permission_name_max_length','2026-02-11 06:36:30.822800'),(8,'auth','0003_alter_user_email_max_length','2026-02-11 06:36:30.881481'),(9,'auth','0004_alter_user_username_opts','2026-02-11 06:36:30.916413'),(10,'auth','0005_alter_user_last_login_null','2026-02-11 06:36:30.997886'),(11,'auth','0006_require_contenttypes_0002','2026-02-11 06:36:31.006123'),(12,'auth','0007_alter_validators_add_error_messages','2026-02-11 06:36:31.032827'),(13,'auth','0008_alter_user_username_max_length','2026-02-11 06:36:31.066820'),(14,'auth','0009_alter_user_last_name_max_length','2026-02-11 06:36:31.103154'),(15,'auth','0010_alter_group_name_max_length','2026-02-11 06:36:31.147806'),(16,'auth','0011_update_proxy_permissions','2026-02-11 06:36:31.165709'),(17,'auth','0012_alter_user_first_name_max_length','2026-02-11 06:36:31.188489'),(18,'clinic','0001_initial','2026-02-11 06:36:33.037314'),(19,'sessions','0001_initial','2026-02-11 06:36:33.080913'),(20,'clinic','0002_alter_branchproduct_id_alter_branchtreatment_id_and_more','2026-02-23 09:41:09.059545'),(21,'clinic','0003_salestransaction_notes','2026-03-15 08:49:37.345526'),(22,'clinic','0004_employeeprofile_delete_account','2026-03-17 05:36:55.489511'),(23,'clinic','0005_remove_clinicbranch_branch_address_and_more','2026-03-17 05:36:55.563816'),(24,'clinic','0006_clinicbranch_branch_address','2026-03-17 05:36:55.581494'),(25,'clinic','0007_remove_inventoryshipment_date_received_and_more','2026-03-22 07:19:16.858447'),(26,'clinic','0008_inventoryshipment_date_received','2026-03-22 07:34:16.116061'),(27,'clinic','0009_salestransaction_branch','2026-04-10 08:28:06.407058'),(28,'clinic','0010_remove_clinicbranch_date_added_userlockout_and_more','2026-04-10 08:28:06.528544'),(29,'clinic','0011_remove_clinicbranch_date_added','2026-04-10 08:28:06.543541'),(30,'clinic','0012_product_is_deleted_treatment_is_deleted','2026-04-14 07:13:15.928662'),(31,'clinic','0013_patient_is_deleted','2026-04-22 05:35:10.312996'),(32,'clinic','0014_alter_patient_middle_name','2026-04-22 05:35:10.388957'),(33,'clinic','0015_patient_unique_patient_identity','2026-04-22 05:35:10.419256'),(34,'clinic','0016_supplier_is_deleted','2026-04-22 11:23:21.515292');
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
INSERT INTO `django_session` VALUES ('0fbn30gvjrlu9u2p2m35po6uchm736yf','.eJxVjEEOwiAQRe_C2hBoZ5jWpXvPQGAGpGpoUtqV8e7apAvd_vfefykftrX4raXFT6LOyqrT7xYDP1LdgdxDvc2a57ouU9S7og_a9HWW9Lwc7t9BCa1869EAIkqKmSCyAwM5OuI0IoJhMWBslyORI8GcByJLLMwOQz_0HbB6fwDb3zew:1vq3tt:kXxVgqfWtbKy9a087z-RslDySTSmJh-JrUK_STrvobk','2026-02-25 06:40:37.097256'),('26ird0i12bvabkufm9krh44nhe6cdqwa','.eJxVjMsOgyAUBf_lro1BARGX3fcbyOVVqRQagVXTf29N3Lg9M3M-4DFEZxXW6l7vWmAhHcRsNtVSDRGW1GLsQGGrq2rF7SpYWIDCZdNoNpcOYJ-YHrk3OdU96P5Q-pOW_p6ti7fTvRysWNZ_zQbLcBSOoEDGvObS09EQSuZ5mohEYuWgmWaGcjpIwSmdKOdaOKcNZ7OH7w_4PkS4:1wCXy9:r8adCvD5IAt_STTP1beNqwp07_hP7PRr4lDfp12RvDU','2026-04-28 07:13:57.092224'),('2ls3061dbirvv7gwwb3kki8wl51fvux5','.eJxVjEsOAiEQBe_C2hC-QVy69wykm25k1EAyzKyMdzcks9Dtq6r3Fgn2raZ98JoWEhfhxOl3Q8hPbhPQA9q9y9zbti4opyIPOuStE7-uh_t3UGHUWavonQ0ERSNpxU4hQrCYvTlrZJWD5RJ99qw1FTCFdGRjjQmkLNgsPl_5wThw:1wB7y8:BgxwccjssIHLoRzfyfR0uNHNsAraJG289mhi7vHjCVI','2026-04-24 09:16:04.588112'),('9rqszvbz8u9i9101z48cakib61hti0e8','.eJxVjMsOgyAUBf_lro1BARGX3fcbyOVVqRQagVXTf29N3Lg9M3M-4DFEZxXW6l7vWmAhHcRsNtVSDRGW1GLsQGGrq2rF7SpYWIDCZdNoNpcOYJ-YHrk3OdU96P5Q-pOW_p6ti7fTvRysWNZ_zQbLcBSOoEDGvObS09EQSuZ5mohEYuWgmWaGcjpIwSmdKOdaOKcNZ7OH7w_4PkS4:1wGAQ5:AuJzgVX1zWN8IrIY4HVi6wMbpgjDSZ2CShgBi8dp-vw','2026-05-08 06:53:45.367913'),('9yp8ovciu9ewbsfnei1gruhwgji15n4h','.eJxVjEsOAiEQBe_C2hC-QVy69wykm25k1EAyzKyMdzcks9Dtq6r3Fgn2raZ98JoWEhfhxOl3Q8hPbhPQA9q9y9zbti4opyIPOuStE7-uh_t3UGHUWavonQ0ERSNpxU4hQrCYvTlrZJWD5RJ99qw1FTCFdGRjjQmkLNgsPl_5wThw:1wB8Li:LbHXIVxOXE9hRHQ0LNntuqLGcwe0g6Mia9jSt_4Iygw','2026-04-24 09:40:26.648123'),('btu0zeosmt8wqsjkrj9zpfibame8zwv8','.eJxVjMsOgyAUBf_lro1BARGX3fcbyOVVqRQagVXTf29N3Lg9M3M-4DFEZxXW6l7vWmAhHcRsNtVSDRGW1GLsQGGrq2rF7SpYWIDCZdNoNpcOYJ-YHrk3OdU96P5Q-pOW_p6ti7fTvRysWNZ_zQbLcBSOoEDGvObS09EQSuZ5mohEYuWgmWaGcjpIwSmdKOdaOKcNZ7OH7w_4PkS4:1wGAxI:O3noqxtXG7IMwteDycfMTNNpLEDbN_Diy3s7_y1Nixo','2026-05-08 07:28:04.716671'),('r4vgobh0o6civr43kl7znc8y4ffh3ibj','.eJxVjEsOAiEQBe_C2hCYbgZw6d4zkG4-Mmogmc_KeHedZBa6fVX1XiLQttawLXkOUxJnAeL0uzHFR247SHdqty5jb-s8sdwVedBFXnvKz8vh_h1UWuq3Rp2QBpsVWUIsbHyBISpQzo2j8qSS14yMEQxobw3ACMawzZmjQVfE-wPGyDcP:1w4CgT:CZFWg84EtzcxNTRIWGXxa2YDUmBKgA6v6LDOini7-lw','2026-04-05 06:53:13.105723');
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

-- Dump completed on 2026-04-24 15:29:09
