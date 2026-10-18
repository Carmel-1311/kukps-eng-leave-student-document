-- Local Docker schema-only metadata; inspected 2026-10-18 (Asia/Bangkok)
-- MySQL 8.0.44; source database: leave-request-components
-- No rows, credentials, or inferred foreign keys. Import as MySQL DDL.

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `advisor_student` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `advisor_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `student_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `advisor_student_student_code_key` (`student_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `subject_section_lecturers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_section_id` bigint unsigned NOT NULL,
  `lecturer_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lecturer_name` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subject_section_lecturers_section_lecturer` (`subject_section_id`,`lecturer_code`),
  CONSTRAINT `fk_subject_section_lecturers_section` FOREIGN KEY (`subject_section_id`) REFERENCES `subject_sections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_subject_section_lecturers_identity` CHECK ((((`lecturer_code` is not null) and (char_length(trim(`lecturer_code`)) > 0)) or ((`lecturer_name` is not null) and (char_length(trim(`lecturer_name`)) > 0))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `subject_sections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint unsigned NOT NULL,
  `section` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `schedule_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `schedule` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subject_sections_subject_section_schedule` (`subject_id`,`section`,`schedule_text`),
  CONSTRAINT `fk_subject_sections_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `subjects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subjects_subject_code` (`subject_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
