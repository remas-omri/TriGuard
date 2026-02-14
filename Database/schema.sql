-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 14 فبراير 2026 الساعة 17:45
-- إصدار الخادم: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;



-- --------------------------------------------------------
-- Database bootstrap
-- --------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `secure_access_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `secure_access_system`;

--
-- Database: `secure_access_system`
--

-- --------------------------------------------------------

--
-- بنية الجدول `alerts`
--

CREATE TABLE `alerts` (
  `alert_id` bigint(20) UNSIGNED NOT NULL,
  `attempt_id` bigint(20) UNSIGNED NOT NULL,
  `alert_type` enum('unauthorized_attempt','verification_failed','device_tamper','system') NOT NULL,
  `status` enum('pending','sent','acknowledged') NOT NULL DEFAULT 'pending',
  `message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `sent_at` timestamp NULL DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  `acknowledged_by` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `alerts`
--
-- --------------------------------------------------------

--
-- بنية الجدول `attempts`
--

CREATE TABLE `attempts` (
  `attempt_id` bigint(20) UNSIGNED NOT NULL,
  `device_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `attempt_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `final_result` enum('passed','failed') NOT NULL,
  `status` enum('recorded','reviewed') NOT NULL DEFAULT 'recorded',
  `failure_reason` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `meta` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `attempts`
--
-- --------------------------------------------------------

--
-- بنية الجدول `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `actor_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(64) NOT NULL,
  `entity` varchar(64) NOT NULL,
  `entity_id` varchar(64) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `devices`
--

CREATE TABLE `devices` (
  `device_id` bigint(20) UNSIGNED NOT NULL,
  `serial` varchar(64) NOT NULL,
  `location` varchar(160) DEFAULT NULL,
  `api_key_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `devices`
--
-- --------------------------------------------------------

--
-- بنية الجدول `roles`
--

CREATE TABLE `roles` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `roles`
--
-- --------------------------------------------------------

--
-- بنية الجدول `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(120) NOT NULL,
  `national_id` varchar(20) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `users`
--
-- --------------------------------------------------------

--
-- بنية الجدول `user_biometrics`
--

CREATE TABLE `user_biometrics` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `face_template` varbinary(2048) DEFAULT NULL,
  `voice_print` varbinary(2048) DEFAULT NULL,
  `ecg_template` varbinary(2048) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `user_biometrics`
--
-- --------------------------------------------------------

--
-- بنية الجدول `verification_results`
--

CREATE TABLE `verification_results` (
  `verification_id` bigint(20) UNSIGNED NOT NULL,
  `attempt_id` bigint(20) UNSIGNED NOT NULL,
  `method` enum('face','voice','ecg') NOT NULL,
  `result` enum('pass','fail','na') NOT NULL DEFAULT 'na',
  `score` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- إرجاع أو استيراد بيانات الجدول `verification_results`
--
--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`alert_id`),
  ADD UNIQUE KEY `attempt_id` (`attempt_id`),
  ADD KEY `fk_alert_ack_user` (`acknowledged_by`),
  ADD KEY `idx_alert_status_created` (`status`,`created_at`);

--
-- Indexes for table `attempts`
--
ALTER TABLE `attempts`
  ADD PRIMARY KEY (`attempt_id`),
  ADD KEY `idx_attempt_time` (`attempt_time`),
  ADD KEY `idx_attempt_user_time` (`user_id`,`attempt_time`),
  ADD KEY `idx_attempt_device_time` (`device_id`,`attempt_time`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `fk_audit_actor` (`actor_user_id`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`device_id`),
  ADD UNIQUE KEY `serial` (`serial`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_users_role` (`role_id`);

--
-- Indexes for table `user_biometrics`
--
ALTER TABLE `user_biometrics`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `verification_results`
--
ALTER TABLE `verification_results`
  ADD PRIMARY KEY (`verification_id`),
  ADD UNIQUE KEY `uq_attempt_method` (`attempt_id`,`method`),
  ADD KEY `idx_vr_attempt` (`attempt_id`),
  ADD KEY `idx_vr_method_result` (`method`,`result`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `alert_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attempts`
--
ALTER TABLE `attempts`
  MODIFY `attempt_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `device_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `verification_results`
--
ALTER TABLE `verification_results`
  MODIFY `verification_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- قيود الجداول المُلقاة.
--

--
-- قيود الجداول `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `fk_alert_ack_user` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_alert_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `attempts` (`attempt_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- قيود الجداول `attempts`
--
ALTER TABLE `attempts`
  ADD CONSTRAINT `fk_attempt_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_attempt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- قيود الجداول `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- قيود الجداول `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;

--
-- قيود الجداول `user_biometrics`
--
ALTER TABLE `user_biometrics`
  ADD CONSTRAINT `fk_bio_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- قيود الجداول `verification_results`
--
ALTER TABLE `verification_results`
  ADD CONSTRAINT `fk_vr_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `attempts` (`attempt_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
