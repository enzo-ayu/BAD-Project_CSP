-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 11, 2026 at 09:35 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cims_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 3, 'add_permission'),
(6, 'Can change permission', 3, 'change_permission'),
(7, 'Can delete permission', 3, 'delete_permission'),
(8, 'Can view permission', 3, 'view_permission'),
(9, 'Can add group', 2, 'add_group'),
(10, 'Can change group', 2, 'change_group'),
(11, 'Can delete group', 2, 'delete_group'),
(12, 'Can view group', 2, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add clinic branch', 10, 'add_clinicbranch'),
(26, 'Can change clinic branch', 10, 'change_clinicbranch'),
(27, 'Can delete clinic branch', 10, 'delete_clinicbranch'),
(28, 'Can view clinic branch', 10, 'view_clinicbranch'),
(29, 'Can add patient', 12, 'add_patient'),
(30, 'Can change patient', 12, 'change_patient'),
(31, 'Can delete patient', 12, 'delete_patient'),
(32, 'Can view patient', 12, 'view_patient'),
(33, 'Can add supplier', 17, 'add_supplier'),
(34, 'Can change supplier', 17, 'change_supplier'),
(35, 'Can delete supplier', 17, 'delete_supplier'),
(36, 'Can view supplier', 17, 'view_supplier'),
(37, 'Can add treatment', 19, 'add_treatment'),
(38, 'Can change treatment', 19, 'change_treatment'),
(39, 'Can delete treatment', 19, 'delete_treatment'),
(40, 'Can view treatment', 19, 'view_treatment'),
(41, 'Can add account', 7, 'add_account'),
(42, 'Can change account', 7, 'change_account'),
(43, 'Can delete account', 7, 'delete_account'),
(44, 'Can view account', 7, 'view_account'),
(45, 'Can add inventory shipment', 11, 'add_inventoryshipment'),
(46, 'Can change inventory shipment', 11, 'change_inventoryshipment'),
(47, 'Can delete inventory shipment', 11, 'delete_inventoryshipment'),
(48, 'Can view inventory shipment', 11, 'view_inventoryshipment'),
(49, 'Can add sales transaction', 16, 'add_salestransaction'),
(50, 'Can change sales transaction', 16, 'change_salestransaction'),
(51, 'Can delete sales transaction', 16, 'delete_salestransaction'),
(52, 'Can view sales transaction', 16, 'view_salestransaction'),
(53, 'Can add product', 14, 'add_product'),
(54, 'Can change product', 14, 'change_product'),
(55, 'Can delete product', 14, 'delete_product'),
(56, 'Can view product', 14, 'view_product'),
(57, 'Can add transaction item', 18, 'add_transactionitem'),
(58, 'Can change transaction item', 18, 'change_transactionitem'),
(59, 'Can delete transaction item', 18, 'delete_transactionitem'),
(60, 'Can view transaction item', 18, 'view_transactionitem'),
(61, 'Can add patient visit', 13, 'add_patientvisit'),
(62, 'Can change patient visit', 13, 'change_patientvisit'),
(63, 'Can delete patient visit', 13, 'delete_patientvisit'),
(64, 'Can view patient visit', 13, 'view_patientvisit'),
(65, 'Can add branch product', 8, 'add_branchproduct'),
(66, 'Can change branch product', 8, 'change_branchproduct'),
(67, 'Can delete branch product', 8, 'delete_branchproduct'),
(68, 'Can view branch product', 8, 'view_branchproduct'),
(69, 'Can add received product', 15, 'add_receivedproduct'),
(70, 'Can change received product', 15, 'change_receivedproduct'),
(71, 'Can delete received product', 15, 'delete_receivedproduct'),
(72, 'Can view received product', 15, 'view_receivedproduct'),
(73, 'Can add branch treatment', 9, 'add_branchtreatment'),
(74, 'Can change branch treatment', 9, 'change_branchtreatment'),
(75, 'Can delete branch treatment', 9, 'delete_branchtreatment'),
(76, 'Can view branch treatment', 9, 'view_branchtreatment'),
(77, 'Can add treatment product', 20, 'add_treatmentproduct'),
(78, 'Can change treatment product', 20, 'change_treatmentproduct'),
(79, 'Can delete treatment product', 20, 'delete_treatmentproduct'),
(80, 'Can view treatment product', 20, 'view_treatmentproduct');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$1200000$wywmv7bk09g7bGbgRlLDKS$0oF2acBJlbT6DyPunlEnCkb5mAMiVCQw9YG1hP+7kpw=', '2026-02-11 06:40:37.096226', 1, 'user', '', '', '', 1, 1, '2026-02-11 06:37:40.652883');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_account`
--

CREATE TABLE `clinic_account` (
  `account_id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `account_name` varchar(150) NOT NULL,
  `account_type` varchar(25) NOT NULL,
  `date_created` date NOT NULL,
  `status` tinyint(1) NOT NULL,
  `all_branches` tinyint(1) NOT NULL,
  `branch_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_branchproduct`
--

CREATE TABLE `clinic_branchproduct` (
  `id` bigint(20) NOT NULL,
  `quantity_minimum` int(11) NOT NULL,
  `stock_quantity` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_branchtreatment`
--

CREATE TABLE `clinic_branchtreatment` (
  `id` bigint(20) NOT NULL,
  `availability_status` tinyint(1) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_clinicbranch`
--

CREATE TABLE `clinic_clinicbranch` (
  `branch_id` int(11) NOT NULL,
  `branch_location` varchar(100) NOT NULL,
  `branch_address` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_inventoryshipment`
--

CREATE TABLE `clinic_inventoryshipment` (
  `inventory_record_id` int(11) NOT NULL,
  `received_product_name` varchar(100) NOT NULL,
  `date_received` date NOT NULL,
  `branch_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_patient`
--

CREATE TABLE `clinic_patient` (
  `patient_id` int(11) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `patient_address` varchar(300) NOT NULL,
  `patient_contact_number` varchar(11) NOT NULL,
  `birthday` date NOT NULL,
  `sex` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clinic_patient`
--

INSERT INTO `clinic_patient` (`patient_id`, `last_name`, `first_name`, `middle_name`, `suffix`, `patient_address`, `patient_contact_number`, `birthday`, `sex`) VALUES
(1, 'Abesamis', 'Jaron', 'I.', 'JUNIOR', 'Fairview', '0906058609', '2026-02-11', 'M');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_patientvisit`
--

CREATE TABLE `clinic_patientvisit` (
  `id` bigint(20) NOT NULL,
  `patient_notes` longtext DEFAULT NULL,
  `branch_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_product`
--

CREATE TABLE `clinic_product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_type` varchar(30) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `unit_cost` decimal(8,2) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clinic_product`
--

INSERT INTO `clinic_product` (`product_id`, `product_name`, `product_type`, `description`, `unit_cost`, `supplier_id`) VALUES
(1, 'Gluta Test', 'Glutathione', 'Testing Gluta', 750.00, 1),
(2, 'Cleanser Test', 'Cleanser', 'tesitng lang', 500.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `clinic_receivedproduct`
--

CREATE TABLE `clinic_receivedproduct` (
  `id` bigint(20) NOT NULL,
  `quantity_received` int(11) NOT NULL,
  `expiration_date` date NOT NULL,
  `branch_id` int(11) NOT NULL,
  `inventory_record_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_salestransaction`
--

CREATE TABLE `clinic_salestransaction` (
  `transaction_id` int(11) NOT NULL,
  `transaction_date` date NOT NULL,
  `mode_of_payment` varchar(20) NOT NULL,
  `total_price_of_products` decimal(8,2) DEFAULT NULL,
  `total_price_of_treatments` decimal(8,2) DEFAULT NULL,
  `total_amount` decimal(8,2) NOT NULL,
  `patient_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_supplier`
--

CREATE TABLE `clinic_supplier` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(150) NOT NULL,
  `contact_person` varchar(100) NOT NULL,
  `supplier_contact_number` varchar(11) NOT NULL,
  `supplier_address` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clinic_supplier`
--

INSERT INTO `clinic_supplier` (`supplier_id`, `supplier_name`, `contact_person`, `supplier_contact_number`, `supplier_address`) VALUES
(1, 'Mr. Supplier', 'Fiona Metran', '0912473924', 'Cubao');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_transactionitem`
--

CREATE TABLE `clinic_transactionitem` (
  `item_id` int(11) NOT NULL,
  `quantity_purchased` int(11) NOT NULL,
  `subtotal` decimal(8,2) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `transaction_id` int(11) NOT NULL,
  `treatment_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clinic_treatment`
--

CREATE TABLE `clinic_treatment` (
  `treatment_id` int(11) NOT NULL,
  `treatment_name` varchar(100) NOT NULL,
  `treatment_type` varchar(30) NOT NULL,
  `treatment_cost` decimal(8,2) NOT NULL,
  `description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clinic_treatment`
--

INSERT INTO `clinic_treatment` (`treatment_id`, `treatment_name`, `treatment_type`, `treatment_cost`, `description`) VALUES
(1, 'Chiro', 'Massage', 200.00, 'sa likod'),
(2, 'Peel the Banana', 'Peel', 300.00, 'yupps');

-- --------------------------------------------------------

--
-- Table structure for table `clinic_treatmentproduct`
--

CREATE TABLE `clinic_treatmentproduct` (
  `id` bigint(20) NOT NULL,
  `quantity_used` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `treatment_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2026-02-11 07:49:24.476256', '1', 'Mr. Supplier', 1, '[{\"added\": {}}]', 17, 1),
(2, '2026-02-11 07:49:45.128049', '1', 'Gluta Test', 1, '[{\"added\": {}}]', 14, 1),
(3, '2026-02-11 07:50:08.166722', '2', 'Cleanser Test', 1, '[{\"added\": {}}]', 14, 1),
(4, '2026-02-11 07:50:56.043038', '1', 'Chiro', 1, '[{\"added\": {}}]', 19, 1),
(5, '2026-02-11 07:51:43.161842', '2', 'Peel the Banana', 1, '[{\"added\": {}}]', 19, 1),
(6, '2026-02-11 08:02:35.011229', '1', 'Abesamis, Jaron', 1, '[{\"added\": {}}]', 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'group'),
(3, 'auth', 'permission'),
(4, 'auth', 'user'),
(7, 'clinic', 'account'),
(8, 'clinic', 'branchproduct'),
(9, 'clinic', 'branchtreatment'),
(10, 'clinic', 'clinicbranch'),
(11, 'clinic', 'inventoryshipment'),
(12, 'clinic', 'patient'),
(13, 'clinic', 'patientvisit'),
(14, 'clinic', 'product'),
(15, 'clinic', 'receivedproduct'),
(16, 'clinic', 'salestransaction'),
(17, 'clinic', 'supplier'),
(18, 'clinic', 'transactionitem'),
(19, 'clinic', 'treatment'),
(20, 'clinic', 'treatmentproduct'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-02-11 06:36:29.751908'),
(2, 'auth', '0001_initial', '2026-02-11 06:36:30.380513'),
(3, 'admin', '0001_initial', '2026-02-11 06:36:30.535690'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-02-11 06:36:30.564713'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-11 06:36:30.602916'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-02-11 06:36:30.702700'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-02-11 06:36:30.822800'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-02-11 06:36:30.881481'),
(9, 'auth', '0004_alter_user_username_opts', '2026-02-11 06:36:30.916413'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-02-11 06:36:30.997886'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-02-11 06:36:31.006123'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-11 06:36:31.032827'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-02-11 06:36:31.066820'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-11 06:36:31.103154'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-02-11 06:36:31.147806'),
(16, 'auth', '0011_update_proxy_permissions', '2026-02-11 06:36:31.165709'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-11 06:36:31.188489'),
(18, 'clinic', '0001_initial', '2026-02-11 06:36:33.037314'),
(19, 'sessions', '0001_initial', '2026-02-11 06:36:33.080913');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0fbn30gvjrlu9u2p2m35po6uchm736yf', '.eJxVjEEOwiAQRe_C2hBoZ5jWpXvPQGAGpGpoUtqV8e7apAvd_vfefykftrX4raXFT6LOyqrT7xYDP1LdgdxDvc2a57ouU9S7og_a9HWW9Lwc7t9BCa1869EAIkqKmSCyAwM5OuI0IoJhMWBslyORI8GcByJLLMwOQz_0HbB6fwDb3zew:1vq3tt:kXxVgqfWtbKy9a087z-RslDySTSmJh-JrUK_STrvobk', '2026-02-25 06:40:37.097256');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `clinic_account`
--
ALTER TABLE `clinic_account`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `clinic_account_branch_id_2b6fafa0_fk_clinic_cl` (`branch_id`);

--
-- Indexes for table `clinic_branchproduct`
--
ALTER TABLE `clinic_branchproduct`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clinic_branchproduct_branch_id_product_id_3f64fe26_uniq` (`branch_id`,`product_id`),
  ADD KEY `clinic_branchproduct_product_id_157c5a4a_fk_clinic_pr` (`product_id`);

--
-- Indexes for table `clinic_branchtreatment`
--
ALTER TABLE `clinic_branchtreatment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clinic_branchtreatment_branch_id_treatment_id_a191e555_uniq` (`branch_id`,`treatment_id`),
  ADD KEY `clinic_branchtreatme_treatment_id_8d17b2dd_fk_clinic_tr` (`treatment_id`);

--
-- Indexes for table `clinic_clinicbranch`
--
ALTER TABLE `clinic_clinicbranch`
  ADD PRIMARY KEY (`branch_id`);

--
-- Indexes for table `clinic_inventoryshipment`
--
ALTER TABLE `clinic_inventoryshipment`
  ADD PRIMARY KEY (`inventory_record_id`),
  ADD KEY `clinic_inventoryship_branch_id_e10248e4_fk_clinic_cl` (`branch_id`),
  ADD KEY `clinic_inventoryship_supplier_id_e5dab4ca_fk_clinic_su` (`supplier_id`);

--
-- Indexes for table `clinic_patient`
--
ALTER TABLE `clinic_patient`
  ADD PRIMARY KEY (`patient_id`);

--
-- Indexes for table `clinic_patientvisit`
--
ALTER TABLE `clinic_patientvisit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clinic_patientvisit_patient_id_branch_id_be6b9b1c_uniq` (`patient_id`,`branch_id`),
  ADD KEY `clinic_patientvisit_branch_id_e3e7bd04_fk_clinic_cl` (`branch_id`);

--
-- Indexes for table `clinic_product`
--
ALTER TABLE `clinic_product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `clinic_product_supplier_id_c95683ba_fk_clinic_su` (`supplier_id`);

--
-- Indexes for table `clinic_receivedproduct`
--
ALTER TABLE `clinic_receivedproduct`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clinic_receivedproduct_inventory_record_id_prod_5d6e9647_uniq` (`inventory_record_id`,`product_id`),
  ADD KEY `clinic_receivedprodu_branch_id_bea10a7a_fk_clinic_cl` (`branch_id`),
  ADD KEY `clinic_receivedprodu_product_id_99ceac6e_fk_clinic_pr` (`product_id`);

--
-- Indexes for table `clinic_salestransaction`
--
ALTER TABLE `clinic_salestransaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` (`patient_id`);

--
-- Indexes for table `clinic_supplier`
--
ALTER TABLE `clinic_supplier`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `clinic_transactionitem`
--
ALTER TABLE `clinic_transactionitem`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `clinic_transactionit_product_id_048d8cd8_fk_clinic_pr` (`product_id`),
  ADD KEY `clinic_transactionit_transaction_id_b85110ce_fk_clinic_sa` (`transaction_id`),
  ADD KEY `clinic_transactionit_treatment_id_bc4be356_fk_clinic_tr` (`treatment_id`);

--
-- Indexes for table `clinic_treatment`
--
ALTER TABLE `clinic_treatment`
  ADD PRIMARY KEY (`treatment_id`);

--
-- Indexes for table `clinic_treatmentproduct`
--
ALTER TABLE `clinic_treatmentproduct`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clinic_treatmentproduct_branch_id_treatment_id_p_41224be2_uniq` (`branch_id`,`treatment_id`,`product_id`),
  ADD KEY `clinic_treatmentprod_product_id_b8b3a019_fk_clinic_pr` (`product_id`),
  ADD KEY `clinic_treatmentprod_treatment_id_afdded54_fk_clinic_tr` (`treatment_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_account`
--
ALTER TABLE `clinic_account`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_branchproduct`
--
ALTER TABLE `clinic_branchproduct`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_branchtreatment`
--
ALTER TABLE `clinic_branchtreatment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_clinicbranch`
--
ALTER TABLE `clinic_clinicbranch`
  MODIFY `branch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_inventoryshipment`
--
ALTER TABLE `clinic_inventoryshipment`
  MODIFY `inventory_record_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_patient`
--
ALTER TABLE `clinic_patient`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_patientvisit`
--
ALTER TABLE `clinic_patientvisit`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_product`
--
ALTER TABLE `clinic_product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_receivedproduct`
--
ALTER TABLE `clinic_receivedproduct`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_salestransaction`
--
ALTER TABLE `clinic_salestransaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_supplier`
--
ALTER TABLE `clinic_supplier`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `clinic_transactionitem`
--
ALTER TABLE `clinic_transactionitem`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clinic_treatment`
--
ALTER TABLE `clinic_treatment`
  MODIFY `treatment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `clinic_treatmentproduct`
--
ALTER TABLE `clinic_treatmentproduct`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `clinic_account`
--
ALTER TABLE `clinic_account`
  ADD CONSTRAINT `clinic_account_branch_id_2b6fafa0_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`);

--
-- Constraints for table `clinic_branchproduct`
--
ALTER TABLE `clinic_branchproduct`
  ADD CONSTRAINT `clinic_branchproduct_branch_id_aaf48fed_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_branchproduct_product_id_157c5a4a_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`);

--
-- Constraints for table `clinic_branchtreatment`
--
ALTER TABLE `clinic_branchtreatment`
  ADD CONSTRAINT `clinic_branchtreatme_branch_id_dea3fbfc_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_branchtreatme_treatment_id_8d17b2dd_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`);

--
-- Constraints for table `clinic_inventoryshipment`
--
ALTER TABLE `clinic_inventoryshipment`
  ADD CONSTRAINT `clinic_inventoryship_branch_id_e10248e4_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_inventoryship_supplier_id_e5dab4ca_fk_clinic_su` FOREIGN KEY (`supplier_id`) REFERENCES `clinic_supplier` (`supplier_id`);

--
-- Constraints for table `clinic_patientvisit`
--
ALTER TABLE `clinic_patientvisit`
  ADD CONSTRAINT `clinic_patientvisit_branch_id_e3e7bd04_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_patientvisit_patient_id_05782eaf_fk_clinic_pa` FOREIGN KEY (`patient_id`) REFERENCES `clinic_patient` (`patient_id`);

--
-- Constraints for table `clinic_product`
--
ALTER TABLE `clinic_product`
  ADD CONSTRAINT `clinic_product_supplier_id_c95683ba_fk_clinic_su` FOREIGN KEY (`supplier_id`) REFERENCES `clinic_supplier` (`supplier_id`);

--
-- Constraints for table `clinic_receivedproduct`
--
ALTER TABLE `clinic_receivedproduct`
  ADD CONSTRAINT `clinic_receivedprodu_branch_id_bea10a7a_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_receivedprodu_inventory_record_id_e6495ad0_fk_clinic_in` FOREIGN KEY (`inventory_record_id`) REFERENCES `clinic_inventoryshipment` (`inventory_record_id`),
  ADD CONSTRAINT `clinic_receivedprodu_product_id_99ceac6e_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`);

--
-- Constraints for table `clinic_salestransaction`
--
ALTER TABLE `clinic_salestransaction`
  ADD CONSTRAINT `clinic_salestransact_patient_id_ef8cda5d_fk_clinic_pa` FOREIGN KEY (`patient_id`) REFERENCES `clinic_patient` (`patient_id`);

--
-- Constraints for table `clinic_transactionitem`
--
ALTER TABLE `clinic_transactionitem`
  ADD CONSTRAINT `clinic_transactionit_product_id_048d8cd8_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`),
  ADD CONSTRAINT `clinic_transactionit_transaction_id_b85110ce_fk_clinic_sa` FOREIGN KEY (`transaction_id`) REFERENCES `clinic_salestransaction` (`transaction_id`),
  ADD CONSTRAINT `clinic_transactionit_treatment_id_bc4be356_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`);

--
-- Constraints for table `clinic_treatmentproduct`
--
ALTER TABLE `clinic_treatmentproduct`
  ADD CONSTRAINT `clinic_treatmentprod_branch_id_4f531c41_fk_clinic_cl` FOREIGN KEY (`branch_id`) REFERENCES `clinic_clinicbranch` (`branch_id`),
  ADD CONSTRAINT `clinic_treatmentprod_product_id_b8b3a019_fk_clinic_pr` FOREIGN KEY (`product_id`) REFERENCES `clinic_product` (`product_id`),
  ADD CONSTRAINT `clinic_treatmentprod_treatment_id_afdded54_fk_clinic_tr` FOREIGN KEY (`treatment_id`) REFERENCES `clinic_treatment` (`treatment_id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
