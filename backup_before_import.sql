-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
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
) ENGINE=InnoDB AUTO_INCREMENT=158 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,1,31),(32,1,32),(33,1,33),(34,1,34),(35,1,35),(36,1,36),(37,1,37),(38,1,38),(39,1,39),(40,1,40),(41,1,41),(42,1,42),(43,1,43),(44,1,44),(45,1,45),(46,1,46),(47,1,47),(48,1,48),(49,1,49),(50,1,50),(51,1,51),(52,1,52),(53,1,53),(54,1,54),(55,1,55),(56,1,56),(57,1,57),(58,1,58),(59,1,59),(60,1,60),(61,1,61),(62,1,62),(63,1,63),(64,1,64),(65,1,65),(66,1,66),(67,1,67),(68,1,68),(69,1,69),(70,1,70),(71,1,71),(72,1,72),(73,1,73),(74,1,74),(75,1,75),(76,1,76),(77,1,77),(78,1,78),(79,1,79),(80,1,80),(81,1,81),(82,1,82),(83,1,83),(84,1,84),(85,2,17),(86,2,18),(87,2,19),(88,2,20),(89,2,21),(90,2,22),(91,2,23),(92,2,24),(93,2,29),(94,2,30),(95,2,31),(96,2,32),(97,2,33),(98,2,34),(99,2,35),(100,2,36),(101,2,37),(102,2,38),(103,2,39),(104,2,40),(105,2,45),(106,2,46),(107,2,47),(108,2,48),(109,2,49),(110,2,50),(111,2,51),(112,2,52),(113,2,53),(114,2,54),(115,2,55),(116,2,56),(117,2,57),(118,2,58),(119,2,59),(120,2,60),(121,2,61),(122,2,62),(123,2,63),(124,2,64),(125,2,66),(126,2,67),(127,2,68),(128,2,69),(129,2,70),(130,2,71),(131,2,72),(132,2,74),(133,2,75),(134,2,76),(135,2,77),(136,2,78),(137,2,79),(138,2,80),(148,3,17),(149,3,18),(150,3,19),(151,3,20),(152,3,21),(153,3,22),(154,3,23),(155,3,24),(156,3,32),(142,3,40),(144,3,48),(146,3,52),(157,3,56),(147,3,60),(139,3,64),(140,3,68),(141,3,72),(143,3,76),(145,3,80);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$wywmv7bk09g7bGbgRlLDKS$0oF2acBJlbT6DyPunlEnCkb5mAMiVCQw9YG1hP+7kpw=','2026-02-11 06:40:37.000000',1,'user','User A','','',1,1,'2026-02-11 06:37:40.000000'),(2,'pbkdf2_sha256$870000$vp247jDzurDjueQfHDVxUQ$uSBURhUzr/jPpwpmmpFg73YmvYGZq8rJYzCAdgpQlZo=','2026-04-26 15:12:19.351457',1,'admin','Admin 1','','admin@email.com',1,1,'2026-03-29 09:59:35.000000'),(3,'pbkdf2_sha256$870000$G8H9xqxCHk6KUhlhspKOeT$tZw6CYdiTGaYY/kMnAzK+//6pWBCaVKsfyPVeHmvITA=','2026-04-17 15:48:17.045859',0,'Sales_Sandy','Sandy Santos','','',0,1,'2026-03-29 10:01:42.000000'),(4,'pbkdf2_sha256$870000$Ol0AyLoOGHSaE09m3pqNzF$GFmvbh4U5V12atXmJcqtdXcLqNri6WrALFtytsM2Lgc=','2026-04-26 14:58:57.175210',1,'fiona','Fiona Metran','','fiona@gmail.com',1,1,'2026-03-29 10:21:27.000000'),(6,'pbkdf2_sha256$870000$YUDjqqQlnlOQsoAmI37iq0$mSnbOm+UJfX6zENN5RrLW3+9wBvOA2huZlihTjuudTo=','2026-04-26 05:08:37.302091',0,'Aest_Chona','Chona Sandy Santos','','',0,1,'2026-03-29 15:20:45.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (18,1,1),(22,2,1),(20,3,3),(19,4,2),(8,6,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
INSERT INTO `auth_user_user_permissions` VALUES (1,2,1),(2,2,2),(3,2,3),(4,2,4),(5,2,5),(6,2,6),(7,2,7),(8,2,8),(9,2,9),(10,2,10),(11,2,11),(12,2,12),(13,2,13),(14,2,14),(15,2,15),(16,2,16),(17,2,17),(18,2,18),(19,2,19),(20,2,20),(21,2,21),(22,2,22),(23,2,23),(24,2,24),(25,2,25),(26,2,26),(27,2,27),(28,2,28),(29,2,29),(30,2,30),(31,2,31),(32,2,32),(33,2,33),(34,2,34),(35,2,35),(36,2,36),(37,2,37),(38,2,38),(39,2,39),(40,2,40),(41,2,41),(42,2,42),(43,2,43),(44,2,44),(45,2,45),(46,2,46),(47,2,47),(48,2,48),(49,2,49),(50,2,50),(51,2,51),(52,2,52),(53,2,53),(54,2,54),(55,2,55),(56,2,56),(57,2,57),(58,2,58),(59,2,59),(60,2,60),(61,2,61),(62,2,62),(63,2,63),(64,2,64),(65,2,65),(66,2,66),(67,2,67),(68,2,68),(69,2,69),(70,2,70),(71,2,71),(72,2,72),(73,2,73),(74,2,74),(75,2,75),(76,2,76),(77,2,77),(78,2,78),(79,2,79),(80,2,80),(81,2,81),(82,2,82),(83,2,83),(84,2,84),(85,3,1),(86,3,2),(87,3,3),(88,3,4),(89,3,5),(90,3,6),(91,3,7),(92,3,8),(93,3,9),(94,3,10),(95,3,11),(96,3,12),(97,3,13),(98,3,14),(99,3,15),(100,3,16),(101,3,17),(102,3,18),(103,3,19),(104,3,20),(105,3,21),(106,3,22),(107,3,23),(108,3,24),(109,3,25),(110,3,26),(111,3,27),(112,3,28),(113,3,29),(114,3,30),(115,3,31),(116,3,32),(117,3,33),(118,3,34),(119,3,35),(120,3,36),(121,3,37),(122,3,38),(123,3,39),(124,3,40),(125,3,41),(126,3,42),(127,3,43),(128,3,44),(129,3,45),(130,3,46),(131,3,47),(132,3,48),(133,3,49),(134,3,50),(135,3,51),(136,3,52),(137,3,53),(138,3,54),(139,3,55),(140,3,56),(141,3,57),(142,3,58),(143,3,59),(144,3,60),(145,3,61),(146,3,62),(147,3,63),(148,3,64),(149,3,65),(150,3,66),(151,3,67),(152,3,68),(153,3,69),(154,3,70),(155,3,71),(156,3,72),(157,3,73),(158,3,74),(159,3,75),(160,3,76),(161,3,77),(162,3,78),(163,3,79),(164,3,80),(165,3,81),(166,3,82),(167,3,83),(168,3,84);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchproduct`
--

LOCK TABLES `clinic_branchproduct` WRITE;
/*!40000 ALTER TABLE `clinic_branchproduct` DISABLE KEYS */;
INSERT INTO `clinic_branchproduct` VALUES (6,10,10,2,105),(7,8,9,2,104),(10,5,20,2,146),(11,5,10,1,147),(12,5,11,2,147),(13,1,-1,1,148),(14,1,-1,2,148),(15,1,10,1,149),(16,1,10,2,149),(17,10,9,1,104),(18,10,50,1,137),(19,1,10,1,150),(20,1,10,2,150);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_branchtreatment`
--

LOCK TABLES `clinic_branchtreatment` WRITE;
/*!40000 ALTER TABLE `clinic_branchtreatment` DISABLE KEYS */;
INSERT INTO `clinic_branchtreatment` VALUES (1,1,1,9),(2,1,1,21),(3,1,2,9),(4,1,2,67),(5,1,2,28),(6,1,2,63),(8,1,2,84),(9,1,2,174),(10,0,1,20),(11,0,2,20),(12,0,1,84),(13,1,1,175),(14,1,2,175),(15,1,1,176),(16,1,2,176);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_clinicbranch`
--

LOCK TABLES `clinic_clinicbranch` WRITE;
/*!40000 ALTER TABLE `clinic_clinicbranch` DISABLE KEYS */;
INSERT INTO `clinic_clinicbranch` VALUES (1,'Mecauayan, Bulacan',NULL,0),(2,'Quezon City',NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_employeeprofile`
--

LOCK TABLES `clinic_employeeprofile` WRITE;
/*!40000 ALTER TABLE `clinic_employeeprofile` DISABLE KEYS */;
INSERT INTO `clinic_employeeprofile` VALUES (1,1,NULL,1),(2,0,1,6),(3,0,1,3),(4,1,NULL,2),(5,0,2,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_inventoryshipment`
--

LOCK TABLES `clinic_inventoryshipment` WRITE;
/*!40000 ALTER TABLE `clinic_inventoryshipment` DISABLE KEYS */;
INSERT INTO `clinic_inventoryshipment` VALUES (3,'Retinol Serum',1,3,'2026-04-05'),(6,'Acne Laser',2,2,'2026-04-12'),(8,'Acne Shot',2,2,'2026-04-12'),(9,'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',2,3,'2026-04-13'),(10,'Test',2,3,'2026-04-17'),(13,'Acne Shot',1,2,'2026-04-26'),(14,'Anti-Melasma Serum',1,2,'2026-04-26');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_patient`
--

LOCK TABLES `clinic_patient` WRITE;
/*!40000 ALTER TABLE `clinic_patient` DISABLE KEYS */;
INSERT INTO `clinic_patient` VALUES (1,'Abesamis','Jaron','I.','Jr','Fairview','0906058609','2026-02-11','M',0),(2,'Delapaz','Marie','Santos','','Loyola Heights, Quezon City','09111111112','2004-04-04','F',0),(3,'Monty','Boy','Sample','Jr.','Sample Address','09060506964','2002-05-24','M',0),(5,'a','a','a','','a','09333333333','2004-04-18','F',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_product`
--

LOCK TABLES `clinic_product` WRITE;
/*!40000 ALTER TABLE `clinic_product` DISABLE KEYS */;
INSERT INTO `clinic_product` VALUES (97,'Esthetmax Jelly Mask','Add-On',NULL,599.00,2,0),(98,'Special Mask','Add-On',NULL,200.00,2,0),(99,'Jelly Mask','Add-On',NULL,400.00,2,0),(100,'Gold Mask','Add-On',NULL,550.00,2,0),(101,'Extraction','Add-On',NULL,250.00,2,0),(102,'Ear Gun Piercing','Add-On',NULL,450.00,2,0),(103,'Keloid Injection','Add-On','Per unit',150.00,2,0),(104,'Acne Shot','Add-On','Per unit',150.00,2,0),(105,'Acne Laser','Add-On','None',250.00,2,0),(106,'Topical Anesthesia','Add-On',NULL,500.00,2,0),(107,'Local Anesthesia','Add-On',NULL,600.00,2,0),(108,'Gluta IV Push','Add-On','Per vial',800.00,2,0),(109,'Night Cream (10g)','Cream',NULL,380.00,2,0),(110,'Night Cream (25g)','Cream',NULL,780.00,2,0),(111,'Day Cream (10g)','Cream',NULL,380.00,2,0),(112,'Day Cream (25g)','Cream',NULL,780.00,2,0),(113,'Peeling Cream (10g)','Cream',NULL,480.00,2,0),(114,'Peeling Cream (25g)','Cream',NULL,880.00,2,0),(115,'Sunscreen Gel (10g)','Cream',NULL,420.00,2,0),(116,'Sunscreen Foundation (10g)','Cream',NULL,420.00,2,0),(117,'Sunblock Foundation (10g)','Cream',NULL,420.00,2,0),(118,'Clindamycin Cream (10g)','Cream',NULL,400.00,2,0),(119,'Collagen Cream (10g)','Cream',NULL,480.00,2,0),(120,'Glycolic Cream (10g)','Cream',NULL,420.00,2,0),(121,'Hydrocortisone Cream (10g)','Cream',NULL,420.00,2,0),(122,'Erythromycin Cream (10g)','Cream',NULL,300.00,2,0),(123,'Underarm Whitening (10g)','Cream',NULL,420.00,2,0),(124,'Cleansing Solution (60ml)','Solution',NULL,220.00,2,0),(125,'Cleansing Solution (150ml)','Solution',NULL,400.00,2,0),(126,'Clarifying Solution (60ml)','Solution',NULL,300.00,2,0),(127,'Clarifying Solution (150ml)','Solution',NULL,450.00,2,0),(128,'Clindamycin Solution (60ml)','Solution',NULL,390.00,2,0),(129,'Body Astringent (150ml)','Solution',NULL,650.00,2,0),(130,'Brightening Soap (90g)','Soap',NULL,200.00,2,0),(131,'Bleaching Soap (90g)','Soap',NULL,280.00,2,0),(132,'Hydramide Soap (150g)','Soap',NULL,420.00,2,0),(133,'Collagen Serum','Serum',NULL,450.00,2,0),(134,'Miracle Serum','Serum',NULL,450.00,2,0),(135,'Tomato Serum','Serum',NULL,450.00,2,0),(136,'Hydrating Serum','Serum',NULL,450.00,2,0),(137,'Anti-Melasma Serum','Serum','None',500.00,2,0),(138,'Glass Serum','Serum',NULL,450.00,2,0),(139,'Gold Serum','Serum',NULL,450.00,2,0),(140,'Retinol Serum','Serum',NULL,500.00,2,0),(141,'Niacinamide Serum','Serum',NULL,450.00,2,0),(142,'Hyaluronic Serum','Serum',NULL,450.00,2,0),(143,'Puff Away Serum','Serum',NULL,450.00,2,0),(146,'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx','Cream','lalala',100.00,3,1),(147,'Test','Cream','lalala',100.00,3,1),(148,'Testing','Add-On','a',100.00,3,1),(149,'Testing','Add-On','a',100.00,3,1),(150,'Test Product','Add-on','a',100.00,3,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_receivedproduct`
--

LOCK TABLES `clinic_receivedproduct` WRITE;
/*!40000 ALTER TABLE `clinic_receivedproduct` DISABLE KEYS */;
INSERT INTO `clinic_receivedproduct` VALUES (5,50,'2026-04-18',2,6,105),(7,9,'2026-04-25',2,8,104),(8,10,'2026-04-18',2,9,146),(9,1,'2026-04-25',2,10,147),(12,9,'2026-04-30',1,13,104),(13,50,'2030-04-26',1,14,137);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_salestransaction`
--

LOCK TABLES `clinic_salestransaction` WRITE;
/*!40000 ALTER TABLE `clinic_salestransaction` DISABLE KEYS */;
INSERT INTO `clinic_salestransaction` VALUES (1,'2026-03-31','Cash',200.00,200.00,1,'',2,0.00,0),(2,'2026-03-31','Cash',9999.00,9999.00,1,'lalala',2,0.00,0),(3,'2026-03-31','GCash',3000.00,3000.00,1,'allergic to xenon',2,0.00,0),(4,'2026-04-04','Cash',500.00,500.00,2,'',2,0.00,0),(5,'2026-04-04','Cash',1199.00,1199.00,2,'',2,0.00,0),(9,'2026-04-12','Bank Transfer',0.00,10000.00,2,'',2,0.00,0),(10,'2026-04-12','GCash',0.00,1350.00,2,'',2,0.00,0),(11,'2026-04-13','Card',0.00,150.00,3,'',2,0.00,0),(13,'2026-04-17','Cash',4499.00,4499.00,5,'aaaaaaaaaa',1,0.00,0);
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
INSERT INTO `clinic_supplier` VALUES (2,'Mr. Supplier','Mang Tani','09060585960','Over There',0),(3,'SkinCare Distributors Inc.','Ate Maria','09171234567','San Antonio, Makati',0),(5,'ABC Supplier','Juan Dela Cruz','09222222222','Taguig',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_transactionitem`
--

LOCK TABLES `clinic_transactionitem` WRITE;
/*!40000 ALTER TABLE `clinic_transactionitem` DISABLE KEYS */;
INSERT INTO `clinic_transactionitem` VALUES (1,1,200.00,NULL,1,1),(2,1,9999.00,NULL,2,NULL),(7,2,3000.00,NULL,3,67),(8,1,500.00,NULL,4,87),(10,1,400.00,NULL,5,86),(11,1,799.00,NULL,5,5),(19,40,10000.00,105,9,NULL),(20,9,1350.00,104,10,NULL),(22,1,150.00,104,11,NULL),(23,1,4499.00,NULL,13,30);
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
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_treatment`
--

LOCK TABLES `clinic_treatment` WRITE;
/*!40000 ALTER TABLE `clinic_treatment` DISABLE KEYS */;
INSERT INTO `clinic_treatment` VALUES (1,'Chiro','Massage',200.00,'sa likod',0),(2,'Peel the Banana','Peel',300.00,'yupps',0),(3,'Deluxe Facial','Facial',499.00,NULL,0),(4,'Whitening Glow Facial','Facial',599.00,NULL,0),(5,'Oil Control Facial','Facial',799.00,NULL,0),(6,'Collagen Facial','Facial',699.00,NULL,0),(7,'Skin Brightening Treatment','Facial',999.00,NULL,0),(8,'Teen Acne Clear Facial','Facial',999.00,NULL,0),(9,'Adult Acne Clear Facial','Facial',1499.00,'Buy 5 Sessions, Get 1 Free',0),(10,'Facial Dermaplanning','Premium Facial',1499.00,NULL,0),(11,'C Aesthetic Luxe Facial','Premium Facial',2499.00,NULL,0),(12,'C Aesthetic ZO Facial','Premium Facial',3499.00,NULL,0),(13,'Full Hydra Facial Treatment','Premium Facial',3499.00,NULL,0),(14,'Full Hydra Facial + Pico/Carbon','Premium Facial',6000.00,NULL,0),(15,'Korean Facial','Premium Facial',2999.00,NULL,0),(16,'Micro Corrective Peel - Per Session','Face Peel',2499.00,NULL,0),(17,'Micro Corrective Peel - Package (2 sessions)','Face Peel',4500.00,NULL,0),(18,'Standard Peel - Per Session','Face Peel',3499.00,NULL,0),(19,'Standard Peel - Package (2 sessions)','Face Peel',5999.00,NULL,0),(20,'Advance Corrective Peel - Per Session','Face Peel',3899.00,'None',0),(21,'Advance Corrective Peel - Package (3 sessions)','Face Peel',9599.00,'None',0),(22,'Spot Treatment Peel - Per Session','Face Peel',2199.00,NULL,0),(23,'Spot Treatment Peel - Package (2 sessions)','Face Peel',3499.00,NULL,0),(24,'TCA Cross / Ice Pick Peel - Per Session','Face Peel',4599.00,NULL,0),(25,'TCA Cross / Ice Pick Peel - Package (3 sessions)','Face Peel',11999.00,NULL,0),(26,'Neck Whitening Peel','Body Peel',2599.00,'Buy 4 Sessions, Get 1 Free',0),(27,'Underarm Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(28,'Arm Whitening Peel','Body Peel',4999.00,'Buy 4 Sessions, Get 1 Free',0),(29,'Chest Whitening Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(30,'Back Peel','Body Peel',4499.00,'Buy 4 Sessions, Get 1 Free',0),(31,'Groin Whitening Peel','Body Peel',2499.00,'Buy 4 Sessions, Get 1 Free',0),(32,'Full Leg Peel','Body Peel',9999.00,'Buy 4 Sessions, Get 1 Free',0),(33,'Half Leg Peel','Body Peel',6999.00,'Buy 4 Sessions, Get 1 Free',0),(34,'Full Face','Whitening Laser',3499.00,'Buy 5 Sessions, Get 1 Free',0),(35,'Partial Face','Whitening Laser',2499.00,'Buy 5 Sessions, Get 1 Free',0),(36,'Nape','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(37,'Underarm','Whitening Laser',1599.00,'Buy 5 Sessions, Get 1 Free',0),(38,'Groin Area','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(39,'Knee','Whitening Laser',1299.00,'Buy 5 Sessions, Get 1 Free',0),(40,'Tattoo Removal','Whitening Laser',1499.00,'Buy 5 Sessions, Get 1 Free',0),(41,'Full Face','HIFU',14999.00,NULL,0),(42,'Partial Face','HIFU',6999.00,NULL,0),(43,'Full Face','Thermage',11999.00,NULL,0),(44,'Partial Face','Thermage',6999.00,NULL,0),(45,'Eye','Thermage',5999.00,NULL,0),(46,'Full Face','HIFU + Thermage',25000.00,NULL,0),(47,'Half Face','HIFU + Thermage',12000.00,NULL,0),(48,'Exosome Facial Stamp','Microneedling & RF',5999.00,NULL,0),(49,'Premium RF w/ Exosome','Microneedling & RF',11999.00,NULL,0),(50,'Full Face','Exilift Ultra 360',7500.00,'Buy 5 Sessions, Get 1 Free',0),(51,'Upper Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(52,'Lower Face','Exilift Ultra 360',4500.00,'Buy 5 Sessions, Get 1 Free',0),(53,'Neck','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(54,'Chin','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(55,'Arms','Exilift Ultra 360',2500.00,'Buy 5 Sessions, Get 1 Free',0),(56,'Back - Butterfly','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(57,'Back - Upper','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(58,'Back - Lower','Exilift Ultra 360',2000.00,'Buy 5 Sessions, Get 1 Free',0),(59,'Tummy','Exilift Ultra 360',3000.00,'Buy 5 Sessions, Get 1 Free',0),(60,'Back & Tummy','Exilift Ultra 360',4000.00,'Buy 5 Sessions, Get 1 Free',0),(61,'Upper / Lower Lip','Diode Laser',499.00,NULL,0),(62,'Underarm - Diode & Whitening Scrub','Diode Laser',1799.00,'+799 Laser Whitening add-on available',0),(63,'Arm - Plain Diode & Whitening Scrub','Diode Laser',2499.00,'+999 Laser Whitening add-on available',0),(64,'Bikini Area with Whitening Scrub','Diode Laser',1499.00,'+599 Laser Whitening add-on available',0),(65,'Legs - Plain Diode & Whitening Scrub','Diode Laser',2799.00,'+1299 Laser Whitening add-on available',0),(66,'Underarm Whitening Scrub','Body Scrub',499.00,NULL,0),(67,'Arm Brightening Scrub','Body Scrub',1500.00,'None',0),(68,'Back Brightening Scrub','Body Scrub',1500.00,NULL,0),(69,'Legs Brightening Scrub','Body Scrub',1800.00,NULL,0),(70,'Face (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(71,'Neck (Unlimited)','Warts/Skin Tag/Milia',1599.00,NULL,0),(72,'Face + Neck','Warts/Skin Tag/Milia',3000.00,NULL,0),(73,'Back','Warts/Skin Tag/Milia',1899.00,NULL,0),(74,'Chest','Warts/Skin Tag/Milia',1899.00,NULL,0),(75,'Back + Chest','Warts/Skin Tag/Milia',3500.00,NULL,0),(76,'Genital Warts','Warts/Skin Tag/Milia',2499.00,'Starts at 2,499',0),(77,'Per Piece Big Warts','Warts/Skin Tag/Milia',2499.00,'Per area',0),(78,'Syringoma Removal','Warts/Skin Tag/Milia',1499.00,'Per area',0),(79,'Milia Removal','Warts/Skin Tag/Milia',1499.00,NULL,0),(80,'Full Face','Botox',8000.00,NULL,0),(81,'Forehead','Botox',5000.00,NULL,0),(82,'Crowsfeet','Botox',3500.00,NULL,0),(83,'Jawtox','Botox',10000.00,NULL,0),(84,'Alartox','Botox',7000.00,'None',0),(85,'Sweatox','Botox',10000.00,NULL,0),(86,'Regular Natural Look','Eyelash Extension',400.00,NULL,0),(87,'Volume','Eyelash Extension',500.00,NULL,0),(174,'Rarara','Facial',100.00,'1',1),(175,'Facial B','Facial',100.00,'a',0),(176,'Test Treatment','Facial',100.00,'a',0);
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
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clinic_userlockout`
--

LOCK TABLES `clinic_userlockout` WRITE;
/*!40000 ALTER TABLE `clinic_userlockout` DISABLE KEYS */;
INSERT INTO `clinic_userlockout` VALUES (1,0,NULL,2),(2,0,NULL,4),(3,0,NULL,6),(4,0,NULL,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-02-11 07:49:24.476256','1','Mr. Supplier',1,'[{\"added\": {}}]',17,1),(2,'2026-02-11 07:49:45.128049','1','Gluta Test',1,'[{\"added\": {}}]',14,1),(3,'2026-02-11 07:50:08.166722','2','Cleanser Test',1,'[{\"added\": {}}]',14,1),(4,'2026-02-11 07:50:56.043038','1','Chiro',1,'[{\"added\": {}}]',19,1),(5,'2026-02-11 07:51:43.161842','2','Peel the Banana',1,'[{\"added\": {}}]',19,1),(6,'2026-02-11 08:02:35.011229','1','Abesamis, Jaron',1,'[{\"added\": {}}]',12,1),(7,'2026-03-29 10:01:10.238539','1','Owner',1,'[{\"added\": {}}]',2,2),(8,'2026-03-29 10:01:43.219004','3','Owner',1,'[{\"added\": {}}]',4,2),(9,'2026-03-29 10:22:30.513804','2','admin',2,'[{\"changed\": {\"fields\": [\"Groups\", \"User permissions\"]}}]',4,4),(10,'2026-03-29 10:22:42.473718','3','Owner',2,'[{\"changed\": {\"fields\": [\"Groups\", \"User permissions\"]}}]',4,4),(11,'2026-03-29 15:38:39.053957','1','user',2,'[{\"changed\": {\"fields\": [\"First name\"]}}]',4,4),(12,'2026-03-29 15:39:01.383263','3','Owner',2,'[{\"changed\": {\"fields\": [\"First name\"]}}]',4,4),(13,'2026-03-29 15:39:36.915744','4','fiona',2,'[{\"changed\": {\"fields\": [\"First name\"]}}]',4,4),(14,'2026-03-29 15:40:19.854060','2','admin',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,4),(15,'2026-03-29 15:40:24.219630','2','admin',2,'[]',4,4),(16,'2026-03-29 15:40:30.437756','2','admin',2,'[{\"changed\": {\"fields\": [\"First name\"]}}]',4,4),(17,'2026-03-29 15:47:07.824892','2','Aesthetician',1,'[{\"added\": {}}]',2,4),(18,'2026-03-29 15:48:43.966000','3','Sales Team',1,'[{\"added\": {}}]',2,4),(19,'2026-03-29 15:49:37.158607','6','chona',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,4),(20,'2026-03-29 15:49:47.777907','3','Owner',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,4),(21,'2026-03-29 15:50:08.315076','1','user',2,'[]',4,4),(22,'2026-03-29 15:50:54.376353','3','Sales_Sandy',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',4,4),(23,'2026-03-29 15:51:02.658263','6','Aest_Chona',2,'[{\"changed\": {\"fields\": [\"Username\"]}}]',4,4),(24,'2026-03-29 15:53:20.104679','4','fiona',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,4),(25,'2026-03-29 15:53:44.282446','2','admin',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,4),(26,'2026-03-29 15:55:02.540381','3','Sales_Sandy',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,4),(27,'2026-03-29 15:55:33.515735','3','Sales Team',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',2,4),(28,'2026-03-29 15:59:16.487577','3','Sales Team',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',2,4),(29,'2026-03-29 15:59:29.709945','3','Sales Team',2,'[]',2,4),(30,'2026-03-31 08:02:31.348684','3','Sales',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',2,4),(31,'2026-03-31 14:12:08.275964','96','Puff Away Serum',3,'',14,2),(32,'2026-03-31 14:12:08.275964','95','Hyaluronic Serum',3,'',14,2),(33,'2026-03-31 14:12:08.275964','94','Niacinamide Serum',3,'',14,2),(34,'2026-03-31 14:12:08.275964','93','Retinol Serum',3,'',14,2),(35,'2026-03-31 14:12:08.275964','92','Gold Serum',3,'',14,2),(36,'2026-03-31 14:12:08.275964','91','Glass Serum',3,'',14,2),(37,'2026-03-31 14:12:08.275964','90','Anti-Melasma Serum',3,'',14,2),(38,'2026-03-31 14:12:08.275964','89','Hydrating Serum',3,'',14,2),(39,'2026-03-31 14:12:08.275964','88','Tomato Serum',3,'',14,2),(40,'2026-03-31 14:12:08.275964','87','Miracle Serum',3,'',14,2),(41,'2026-03-31 14:12:08.275964','86','Collagen Serum',3,'',14,2),(42,'2026-03-31 14:12:08.275964','85','Hydramide Soap (150g)',3,'',14,2),(43,'2026-03-31 14:12:08.275964','84','Bleaching Soap (90g)',3,'',14,2),(44,'2026-03-31 14:12:08.275964','83','Brightening Soap (90g)',3,'',14,2),(45,'2026-03-31 14:12:08.275964','82','Body Astringent (150ml)',3,'',14,2),(46,'2026-03-31 14:12:08.275964','81','Clindamycin Solution (60ml)',3,'',14,2),(47,'2026-03-31 14:12:08.275964','80','Clarifying Solution (150ml)',3,'',14,2),(48,'2026-03-31 14:12:08.275964','79','Clarifying Solution (60ml)',3,'',14,2),(49,'2026-03-31 14:12:08.275964','78','Cleansing Solution (150ml)',3,'',14,2),(50,'2026-03-31 14:12:08.275964','77','Cleansing Solution (60ml)',3,'',14,2),(51,'2026-03-31 14:12:08.275964','76','Underarm Whitening (10g)',3,'',14,2),(52,'2026-03-31 14:12:08.275964','75','Erythromycin Cream (10g)',3,'',14,2),(53,'2026-03-31 14:12:08.275964','74','Hydrocortisone Cream (10g)',3,'',14,2),(54,'2026-03-31 14:12:08.275964','73','Glycolic Cream (10g)',3,'',14,2),(55,'2026-03-31 14:12:08.275964','72','Collagen Cream (10g)',3,'',14,2),(56,'2026-03-31 14:12:08.275964','71','Clindamycin Cream (10g)',3,'',14,2),(57,'2026-03-31 14:12:08.275964','70','Sunblock Foundation (10g)',3,'',14,2),(58,'2026-03-31 14:12:08.275964','69','Sunscreen Foundation (10g)',3,'',14,2),(59,'2026-03-31 14:12:08.275964','68','Sunscreen Gel (10g)',3,'',14,2),(60,'2026-03-31 14:12:08.275964','67','Peeling Cream (25g)',3,'',14,2),(61,'2026-03-31 14:12:08.275964','66','Peeling Cream (10g)',3,'',14,2),(62,'2026-03-31 14:12:08.275964','65','Day Cream (25g)',3,'',14,2),(63,'2026-03-31 14:12:08.275964','64','Day Cream (10g)',3,'',14,2),(64,'2026-03-31 14:12:08.275964','63','Night Cream (25g)',3,'',14,2),(65,'2026-03-31 14:12:08.275964','62','Night Cream (10g)',3,'',14,2),(66,'2026-03-31 14:12:08.275964','61','Gluta IV Push',3,'',14,2),(67,'2026-03-31 14:12:08.275964','60','Local Anesthesia',3,'',14,2),(68,'2026-03-31 14:12:08.275964','59','Topical Anesthesia',3,'',14,2),(69,'2026-03-31 14:12:08.275964','58','Acne Laser',3,'',14,2),(70,'2026-03-31 14:12:08.275964','57','Acne Shot',3,'',14,2),(71,'2026-03-31 14:12:08.275964','56','Keloid Injection',3,'',14,2),(72,'2026-03-31 14:12:08.275964','55','Ear Gun Piercing',3,'',14,2),(73,'2026-03-31 14:12:08.275964','54','Extraction',3,'',14,2),(74,'2026-03-31 14:12:08.275964','53','Gold Mask',3,'',14,2),(75,'2026-03-31 14:12:08.275964','52','Jelly Mask',3,'',14,2),(76,'2026-03-31 14:12:08.275964','51','Special Mask',3,'',14,2),(77,'2026-03-31 14:12:08.275964','50','Esthetmax Jelly Mask',3,'',14,2),(78,'2026-03-31 14:12:58.490798','172','Volume',3,'',19,2),(79,'2026-03-31 14:12:58.490798','171','Regular Natural Look',3,'',19,2),(80,'2026-03-31 14:12:58.490798','170','Sweatox',3,'',19,2),(81,'2026-03-31 14:12:58.490798','169','Alartox',3,'',19,2),(82,'2026-03-31 14:12:58.490798','168','Jawtox',3,'',19,2),(83,'2026-03-31 14:12:58.490798','167','Crowsfeet',3,'',19,2),(84,'2026-03-31 14:12:58.490798','166','Forehead',3,'',19,2),(85,'2026-03-31 14:12:58.490798','165','Full Face',3,'',19,2),(86,'2026-03-31 14:12:58.490798','164','Milia Removal',3,'',19,2),(87,'2026-03-31 14:12:58.493804','163','Syringoma Removal',3,'',19,2),(88,'2026-03-31 14:12:58.493804','162','Per Piece Big Warts',3,'',19,2),(89,'2026-03-31 14:12:58.493804','161','Genital Warts',3,'',19,2),(90,'2026-03-31 14:12:58.493804','160','Back + Chest',3,'',19,2),(91,'2026-03-31 14:12:58.493804','159','Chest',3,'',19,2),(92,'2026-03-31 14:12:58.493804','158','Back',3,'',19,2),(93,'2026-03-31 14:12:58.493804','157','Face + Neck',3,'',19,2),(94,'2026-03-31 14:12:58.493804','156','Neck (Unlimited)',3,'',19,2),(95,'2026-03-31 14:12:58.493888','155','Face (Unlimited)',3,'',19,2),(96,'2026-03-31 14:12:58.493888','154','Legs Brightening Scrub',3,'',19,2),(97,'2026-03-31 14:12:58.493888','153','Back Brightening Scrub',3,'',19,2),(98,'2026-03-31 14:12:58.493888','152','Arm Brightening Scrub',3,'',19,2),(99,'2026-03-31 14:12:58.493888','151','Underarm Whitening Scrub',3,'',19,2),(100,'2026-03-31 14:12:58.493888','150','Legs - Plain Diode & Whitening Scrub',3,'',19,2),(101,'2026-03-31 14:12:58.493974','149','Bikini Area with Whitening Scrub',3,'',19,2),(102,'2026-03-31 14:12:58.493974','148','Arm - Plain Diode & Whitening Scrub',3,'',19,2),(103,'2026-03-31 14:12:58.493974','147','Underarm - Diode & Whitening Scrub',3,'',19,2),(104,'2026-03-31 14:12:58.493974','146','Upper / Lower Lip',3,'',19,2),(105,'2026-03-31 14:12:58.493974','145','Back & Tummy',3,'',19,2),(106,'2026-03-31 14:12:58.493974','144','Tummy',3,'',19,2),(107,'2026-03-31 14:12:58.493974','143','Back - Lower',3,'',19,2),(108,'2026-03-31 14:12:58.493974','142','Back - Upper',3,'',19,2),(109,'2026-03-31 14:12:58.493974','141','Back - Butterfly',3,'',19,2),(110,'2026-03-31 14:12:58.493974','140','Arms',3,'',19,2),(111,'2026-03-31 14:12:58.493974','139','Chin',3,'',19,2),(112,'2026-03-31 14:12:58.493974','138','Neck',3,'',19,2),(113,'2026-03-31 14:12:58.493974','137','Lower Face',3,'',19,2),(114,'2026-03-31 14:12:58.493974','136','Upper Face',3,'',19,2),(115,'2026-03-31 14:12:58.493974','135','Full Face',3,'',19,2),(116,'2026-03-31 14:12:58.493974','134','Premium RF w/ Exosome',3,'',19,2),(117,'2026-03-31 14:12:58.493974','133','Exosome Facial Stamp',3,'',19,2),(118,'2026-03-31 14:12:58.493974','132','Half Face',3,'',19,2),(119,'2026-03-31 14:12:58.493974','131','Full Face',3,'',19,2),(120,'2026-03-31 14:12:58.493974','130','Eye',3,'',19,2),(121,'2026-03-31 14:12:58.493974','129','Partial Face',3,'',19,2),(122,'2026-03-31 14:12:58.493974','128','Full Face',3,'',19,2),(123,'2026-03-31 14:12:58.493974','127','Partial Face',3,'',19,2),(124,'2026-03-31 14:12:58.493974','126','Full Face',3,'',19,2),(125,'2026-03-31 14:12:58.493974','125','Tattoo Removal',3,'',19,2),(126,'2026-03-31 14:12:58.493974','124','Knee',3,'',19,2),(127,'2026-03-31 14:12:58.493974','123','Groin Area',3,'',19,2),(128,'2026-03-31 14:12:58.493974','122','Underarm',3,'',19,2),(129,'2026-03-31 14:12:58.493974','121','Nape',3,'',19,2),(130,'2026-03-31 14:12:58.493974','120','Partial Face',3,'',19,2),(131,'2026-03-31 14:12:58.493974','119','Full Face',3,'',19,2),(132,'2026-03-31 14:12:58.493974','118','Half Leg Peel',3,'',19,2),(133,'2026-03-31 14:12:58.493974','117','Full Leg Peel',3,'',19,2),(134,'2026-03-31 14:12:58.493974','116','Groin Whitening Peel',3,'',19,2),(135,'2026-03-31 14:12:58.493974','115','Back Peel',3,'',19,2),(136,'2026-03-31 14:12:58.493974','114','Chest Whitening Peel',3,'',19,2),(137,'2026-03-31 14:12:58.493974','113','Arm Whitening Peel',3,'',19,2),(138,'2026-03-31 14:12:58.493974','112','Underarm Whitening Peel',3,'',19,2),(139,'2026-03-31 14:12:58.493974','111','Neck Whitening Peel',3,'',19,2),(140,'2026-03-31 14:12:58.493974','110','TCA Cross / Ice Pick Peel - Package (3 sessions)',3,'',19,2),(141,'2026-03-31 14:12:58.493974','109','TCA Cross / Ice Pick Peel - Per Session',3,'',19,2),(142,'2026-03-31 14:12:58.493974','108','Spot Treatment Peel - Package (2 sessions)',3,'',19,2),(143,'2026-03-31 14:12:58.493974','107','Spot Treatment Peel - Per Session',3,'',19,2),(144,'2026-03-31 14:12:58.493974','106','Advance Corrective Peel - Package (3 sessions)',3,'',19,2),(145,'2026-03-31 14:12:58.493974','105','Advance Corrective Peel - Per Session',3,'',19,2),(146,'2026-03-31 14:12:58.493974','104','Standard Peel - Package (2 sessions)',3,'',19,2),(147,'2026-03-31 14:12:58.493974','103','Standard Peel - Per Session',3,'',19,2),(148,'2026-03-31 14:12:58.493974','102','Micro Corrective Peel - Package (2 sessions)',3,'',19,2),(149,'2026-03-31 14:12:58.493974','101','Micro Corrective Peel - Per Session',3,'',19,2),(150,'2026-03-31 14:12:58.493974','100','Korean Facial',3,'',19,2),(151,'2026-03-31 14:12:58.493974','99','Full Hydra Facial + Pico/Carbon',3,'',19,2),(152,'2026-03-31 14:12:58.493974','98','Full Hydra Facial Treatment',3,'',19,2),(153,'2026-03-31 14:12:58.493974','97','C Aesthetic ZO Facial',3,'',19,2),(154,'2026-03-31 14:12:58.493974','96','C Aesthetic Luxe Facial',3,'',19,2),(155,'2026-03-31 14:12:58.493974','95','Facial Dermaplanning',3,'',19,2),(156,'2026-03-31 14:12:58.493974','94','Adult Acne Clear Facial',3,'',19,2),(157,'2026-03-31 14:12:58.493974','93','Teen Acne Clear Facial',3,'',19,2),(158,'2026-03-31 14:12:58.493974','92','Skin Brightening Treatment',3,'',19,2),(159,'2026-03-31 14:12:58.493974','91','Collagen Facial',3,'',19,2),(160,'2026-03-31 14:12:58.493974','90','Oil Control Facial',3,'',19,2),(161,'2026-03-31 14:12:58.493974','89','Whitening Glow Facial',3,'',19,2),(162,'2026-03-31 14:12:58.493974','88','Deluxe Facial',3,'',19,2),(163,'2026-04-13 01:41:22.692083','144','xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',3,'',14,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-02-11 06:36:29.751908'),(2,'auth','0001_initial','2026-02-11 06:36:30.380513'),(3,'admin','0001_initial','2026-02-11 06:36:30.535690'),(4,'admin','0002_logentry_remove_auto_add','2026-02-11 06:36:30.564713'),(5,'admin','0003_logentry_add_action_flag_choices','2026-02-11 06:36:30.602916'),(6,'contenttypes','0002_remove_content_type_name','2026-02-11 06:36:30.702700'),(7,'auth','0002_alter_permission_name_max_length','2026-02-11 06:36:30.822800'),(8,'auth','0003_alter_user_email_max_length','2026-02-11 06:36:30.881481'),(9,'auth','0004_alter_user_username_opts','2026-02-11 06:36:30.916413'),(10,'auth','0005_alter_user_last_login_null','2026-02-11 06:36:30.997886'),(11,'auth','0006_require_contenttypes_0002','2026-02-11 06:36:31.006123'),(12,'auth','0007_alter_validators_add_error_messages','2026-02-11 06:36:31.032827'),(13,'auth','0008_alter_user_username_max_length','2026-02-11 06:36:31.066820'),(14,'auth','0009_alter_user_last_name_max_length','2026-02-11 06:36:31.103154'),(15,'auth','0010_alter_group_name_max_length','2026-02-11 06:36:31.147806'),(16,'auth','0011_update_proxy_permissions','2026-02-11 06:36:31.165709'),(17,'auth','0012_alter_user_first_name_max_length','2026-02-11 06:36:31.188489'),(18,'clinic','0001_initial','2026-02-11 06:36:33.037314'),(19,'sessions','0001_initial','2026-02-11 06:36:33.080913'),(20,'clinic','0002_alter_branchproduct_id_alter_branchtreatment_id_and_more','2026-03-29 09:47:58.883639'),(21,'clinic','0003_salestransaction_notes','2026-03-29 09:47:58.893649'),(22,'clinic','0004_employeeprofile_delete_account','2026-03-29 09:47:58.993883'),(23,'clinic','0005_remove_clinicbranch_branch_address_and_more','2026-03-29 09:47:59.025151'),(24,'clinic','0006_clinicbranch_branch_address','2026-03-29 09:47:59.039701'),(25,'clinic','0007_remove_inventoryshipment_date_received_and_more','2026-03-29 09:47:59.055776'),(26,'clinic','0008_inventoryshipment_date_received','2026-03-29 09:47:59.083647'),(27,'clinic','0009_salestransaction_branch','2026-03-31 10:23:56.255533'),(28,'clinic','0010_remove_clinicbranch_date_added_delete_patientvisit','2026-04-09 09:36:04.150739'),(29,'clinic','0010_remove_clinicbranch_date_added_userlockout_and_more','2026-04-13 08:18:19.460198'),(30,'clinic','0011_remove_clinicbranch_date_added','2026-04-13 09:41:16.854244'),(31,'clinic','0012_product_is_deleted_treatment_is_deleted','2026-04-13 09:43:43.693073'),(32,'clinic','0013_patient_is_deleted','2026-04-17 10:58:54.671360'),(33,'clinic','0014_alter_patient_middle_name','2026-04-17 11:44:25.983971'),(34,'clinic','0015_patient_unique_patient_identity','2026-04-17 11:44:25.999437'),(35,'clinic','0016_supplier_is_deleted','2026-04-24 11:29:06.921340'),(36,'clinic','0016_remove_clinicbranch_branch_address_and_more','2026-04-26 04:18:13.480881'),(37,'clinic','0017_clinicbranch_branch_address_and_more','2026-04-26 04:18:13.502750'),(38,'clinic','0018_clinicbranch_is_deleted','2026-04-26 04:18:13.515861'),(39,'clinic','0019_merge_20260425_2336','2026-04-26 04:18:13.518007'),(40,'clinic','0020_remove_clinicbranch_is_deleted_and_more','2026-04-26 04:18:13.537971'),(41,'clinic','0021_clinicbranch_is_deleted','2026-04-26 04:18:13.548766');
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
INSERT INTO `django_session` VALUES ('0fbn30gvjrlu9u2p2m35po6uchm736yf','.eJxVjEEOwiAQRe_C2hBoZ5jWpXvPQGAGpGpoUtqV8e7apAvd_vfefykftrX4raXFT6LOyqrT7xYDP1LdgdxDvc2a57ouU9S7og_a9HWW9Lwc7t9BCa1869EAIkqKmSCyAwM5OuI0IoJhMWBslyORI8GcByJLLMwOQz_0HbB6fwDb3zew:1vq3tt:kXxVgqfWtbKy9a087z-RslDySTSmJh-JrUK_STrvobk','2026-02-25 06:40:37.097256'),('9hsgafkjcd18cyeorp7ex9571usdlg2x','.eJxVjMEOwiAQBf9lz02DCIX26N1vIAssthbBFDgZ_12b9NLrm5n3gYBLJG-wVnq9a4GJdRCzW01LdYkwpRZjBwZbnU0rtJnFwwQCTptFt1LagX9ieuTe5VS3xfa70h-09PfsKd4O93QwY5n_NV24Q4cjaadGhUp7klxKK5izWoZBeH7FYEchrQ9KOeJSIZMD88NVS67g-wMzk0W-:1wB62T:iE9bL0n0T9hUHwMMEbFAzRuzUI53DTohpe_1wqsPn6o','2026-04-24 07:12:25.116379'),('cyaf25rbfudpuwekjlg6vda8i9j7uich','.eJxVjDkOwyAUBe_yawsBZrFdps8ZEGtMQiAyUEW5e2zJjds3M-8LQcfkndKt-fenVVjwAKnYl-q5xQRL7ikNoHRvq-rVbyo6WIDCZTPavnw-gHvq_CjIlty2aNChoJNWdC_Op9vpXg5WXde9JqOd5SQFJ94ZbAMxgQYxUua4GGdPJGOM4mB3h5MQmPAUW8knYozTmFn4_QH_QUUd:1wHMMV:GU34foMxwk5-O2mwh_sNWhzQd-GqBWmcv6DVESNY0MY','2026-05-11 13:50:59.610913');
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

-- Dump completed on 2026-04-27 22:01:01
