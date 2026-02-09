-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09 فبراير 2026 الساعة 15:26
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
-- Database: `security_system`
--

-- --------------------------------------------------------

--
-- بنية الجدول `alerts`
--

CREATE TABLE `alerts` (
  `alert_id` int(11) NOT NULL,
  `attempt_id` int(11) DEFAULT NULL,
  `alert_type` varchar(50) DEFAULT NULL,
  `status` enum('sent','pending') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `alerts`
--

INSERT INTO `alerts` (`alert_id`, `attempt_id`, `alert_type`, `status`, `created_at`) VALUES
(1, 2, 'Unauthorized Access', 'sent', '2026-02-09 14:15:49');

-- --------------------------------------------------------

--
-- بنية الجدول `biometric_data`
--

CREATE TABLE `biometric_data` (
  `bio_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `face_hash` varchar(255) DEFAULT NULL,
  `voice_hash` varchar(255) DEFAULT NULL,
  `ecg_hash` varchar(255) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `biometric_data`
--

INSERT INTO `biometric_data` (`bio_id`, `user_id`, `face_hash`, `voice_hash`, `ecg_hash`, `last_update`) VALUES
(1, 1, 'face_hash_admin', 'voice_hash_admin', 'ecg_hash_admin', '2026-02-09 14:15:49'),
(2, 2, 'face_hash_security', 'voice_hash_security', 'ecg_hash_security', '2026-02-09 14:15:49'),
(3, 3, 'face_hash_test', 'voice_hash_test', 'ecg_hash_test', '2026-02-09 14:15:49');

-- --------------------------------------------------------

--
-- بنية الجدول `login_attempts`
--

CREATE TABLE `login_attempts` (
  `attempt_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `face_result` enum('pass','fail') DEFAULT NULL,
  `voice_result` enum('pass','fail') DEFAULT NULL,
  `ecg_result` enum('pass','fail') DEFAULT NULL,
  `final_result` enum('success','failed') DEFAULT NULL,
  `attempt_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `login_attempts`
--

INSERT INTO `login_attempts` (`attempt_id`, `user_id`, `face_result`, `voice_result`, `ecg_result`, `final_result`, `attempt_time`) VALUES
(2, 3, 'pass', 'pass', 'pass', 'success', '2026-02-09 14:15:49'),
(3, 3, 'pass', 'fail', 'pass', 'failed', '2026-02-09 14:15:49');

-- --------------------------------------------------------

--
-- بنية الجدول `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `national_id` varchar(20) DEFAULT NULL,
  `role` enum('admin','security','user') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- إرجاع أو استيراد بيانات الجدول `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `national_id`, `role`, `created_at`) VALUES
(1, 'Admin User', '1111111111', 'admin', '2026-02-09 14:15:49'),
(2, 'Security Officer', '2222222222', 'security', '2026-02-09 14:15:49'),
(3, 'Test User', '3333333333', 'user', '2026-02-09 14:15:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`alert_id`),
  ADD KEY `attempt_id` (`attempt_id`);

--
-- Indexes for table `biometric_data`
--
ALTER TABLE `biometric_data`
  ADD PRIMARY KEY (`bio_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`attempt_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `alert_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `biometric_data`
--
ALTER TABLE `biometric_data`
  MODIFY `bio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `attempt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- قيود الجداول المُلقاة.
--

--
-- قيود الجداول `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `login_attempts` (`attempt_id`);

--
-- قيود الجداول `biometric_data`
--
ALTER TABLE `biometric_data`
  ADD CONSTRAINT `biometric_data_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- قيود الجداول `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD CONSTRAINT `login_attempts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
