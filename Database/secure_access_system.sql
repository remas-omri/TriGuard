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

INSERT INTO `alerts` (`alert_id`, `attempt_id`, `alert_type`, `status`, `message`, `created_at`, `sent_at`, `acknowledged_at`, `acknowledged_by`) VALUES
(1, 1, 'verification_failed', 'pending', 'Verification failed', '2026-02-11 14:55:11', NULL, NULL, NULL),
(2, 3, 'verification_failed', 'pending', 'Verification failed', '2026-02-13 20:37:57', NULL, NULL, NULL),
(3, 5, 'verification_failed', 'acknowledged', 'Verification failed', '2026-02-14 00:12:30', NULL, '2026-02-14 00:21:02', 1);

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

INSERT INTO `attempts` (`attempt_id`, `device_id`, `user_id`, `attempt_time`, `final_result`, `status`, `failure_reason`, `ip_address`, `user_agent`, `meta`, `created_at`) VALUES
(1, 1, 1, '2026-02-11 14:55:11', 'failed', 'recorded', NULL, NULL, NULL, '{\"note\":\"first test attempt\"}', '2026-02-11 14:55:11'),
(2, 1, 1, '2026-02-13 17:17:11', 'passed', 'recorded', NULL, NULL, NULL, '{\"note\":\"test verification_results\"}', '2026-02-13 17:17:11'),
(3, 1, 1, '2026-02-13 20:37:57', 'failed', 'recorded', NULL, '::1', 'PostmanRuntime/7.51.1', '{\"note\":\"after drop columns test\"}', '2026-02-13 20:37:57'),
(4, 4, 1, '2026-02-14 00:02:57', 'passed', 'recorded', NULL, '::1', 'PostmanRuntime/7.51.1', NULL, '2026-02-14 00:02:57'),
(5, 4, 1, '2026-02-14 00:12:30', 'failed', 'recorded', NULL, '::1', 'PostmanRuntime/7.51.1', NULL, '2026-02-14 00:12:30'),
(6, 4, 1, '2026-02-14 16:44:00', 'passed', 'recorded', NULL, '::1', 'PostmanRuntime/7.51.1', NULL, '2026-02-14 16:44:00');

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

INSERT INTO `devices` (`device_id`, `serial`, `location`, `api_key_hash`, `is_active`, `created_at`) VALUES
(1, 'ESP32-001-OLD-20260214023855', 'Gate A', '$2a$10$OWp2tdvZvOPBf2YwuSTR1.fnU5uKmb21RpepCcObyWbpT2KQlWoeW', 0, '2026-02-11 14:50:34'),
(4, 'ESP32-001', 'OR Door', '$2a$10$8eDShWtiumkXj/GlJE9WL.lETQImb20DUHv19J4IY3Ehzsr9htoG2', 1, '2026-02-13 23:42:36');

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

INSERT INTO `roles` (`role_id`, `name`) VALUES
(1, 'admin'),
(2, 'security'),
(3, 'user');

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

INSERT INTO `users` (`user_id`, `full_name`, `national_id`, `email`, `phone`, `password_hash`, `role_id`, `is_active`, `created_at`) VALUES
(1, 'Admin', '1234567890', 'admin@local', '0500000000', '$2b$10$Z9ekif/LR0.e6H/Ys2q0ZeHP2WyccOTGQawyMGKnB5lXsykT4s8Nu', 1, 1, '2026-02-11 07:12:45'),
(2, 'Security Officer', '1111111111', 'security@local', '0500000001', '$2a$10$8r47IgvwiyZY2NE5NijMsOTT8681GKokoxVhENZQ9gDCh0vFT1ibS', 2, 1, '2026-02-12 08:09:57');

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

INSERT INTO `user_biometrics` (`user_id`, `face_template`, `voice_print`, `ecg_template`, `updated_at`) VALUES
(1, NULL, NULL, NULL, '2026-02-11 07:12:45'),
(2, NULL, NULL, NULL, '2026-02-12 08:09:57');

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

INSERT INTO `verification_results` (`verification_id`, `attempt_id`, `method`, `result`, `score`, `created_at`) VALUES
(1, 2, 'face', 'pass', 95.50, '2026-02-13 17:17:11'),
(2, 2, 'voice', 'pass', 93.20, '2026-02-13 17:17:11'),
(3, 2, 'ecg', 'pass', 91.00, '2026-02-13 17:17:11'),
(4, 1, 'face', 'pass', NULL, '2026-02-13 20:30:58'),
(5, 1, 'voice', 'fail', NULL, '2026-02-13 20:30:58'),
(6, 1, 'ecg', 'pass', NULL, '2026-02-13 20:30:58'),
(11, 3, 'face', 'pass', 95.50, '2026-02-13 20:37:57'),
(12, 3, 'voice', 'fail', 40.00, '2026-02-13 20:37:57'),
(13, 3, 'ecg', 'pass', 90.00, '2026-02-13 20:37:57'),
(14, 4, 'face', 'pass', 95.50, '2026-02-14 00:02:57'),
(15, 4, 'voice', 'pass', 93.20, '2026-02-14 00:02:57'),
(16, 4, 'ecg', 'pass', 91.00, '2026-02-14 00:02:57'),
(17, 5, 'face', 'pass', NULL, '2026-02-14 00:12:30'),
(18, 5, 'voice', 'fail', 20.00, '2026-02-14 00:12:30'),
(19, 5, 'ecg', 'pass', NULL, '2026-02-14 00:12:30'),
(20, 6, 'face', 'pass', NULL, '2026-02-14 16:44:00'),
(21, 6, 'voice', 'pass', NULL, '2026-02-14 16:44:00'),
(22, 6, 'ecg', 'pass', NULL, '2026-02-14 16:44:00');

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
