-- Combined visualization only: table names prefixed db__, wh__, leave_com__ to avoid collisions.
-- Individual schema SQL files preserve original names.

-- ==================== db ====================
-- Railway schema-only metadata; inspected 2026-10-18 (Asia/Bangkok)
-- MySQL 9.7.2; source database: kukps-eng-leave-request
-- No rows, credentials, or inferred foreign keys. Import as MySQL DDL.

CREATE TABLE `db___prisma_migrations` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `applied_steps_count` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__academic_setting` (
  `id` tinyint unsigned NOT NULL DEFAULT '1',
  `current_academic_term_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `current_academic_term_id` (`current_academic_term_id`),
  CONSTRAINT `academic_setting_current_term_ibfk_1` FOREIGN KEY (`current_academic_term_id`) REFERENCES `db__academic_term` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `db__academic_term` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `academic_year` year NOT NULL,
  `term` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `academic_term_year_term_unique` (`academic_year`,`term`),
  KEY `academic_term_year_term_idx` (`academic_year`,`term`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__account` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nontri_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nontri_id` (`nontri_id`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__approval` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `leave_request_id` bigint unsigned NOT NULL,
  `approver_id` bigint unsigned NOT NULL,
  `approver_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `step` int DEFAULT NULL,
  `decision_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp(3) NULL DEFAULT NULL,
  `activated_at` timestamp(3) NULL DEFAULT NULL,
  `decided_at` timestamp(3) NULL DEFAULT NULL,
  `decision_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'MANUAL',
  `decided_by_nontri_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `decided_by_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_delegated` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `approver_id` (`approver_id`),
  KEY `leave_request_id` (`leave_request_id`),
  KEY `approval_status_activated_idx` (`decision_status`,`activated_at`),
  CONSTRAINT `approval_ibfk_1` FOREIGN KEY (`leave_request_id`) REFERENCES `db__leave_request` (`id`) ON DELETE CASCADE,
  CONSTRAINT `approval_ibfk_2` FOREIGN KEY (`approver_id`) REFERENCES `db__users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__business_calendar_day` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `calendar_date` date NOT NULL,
  `is_working_day` tinyint(1) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `business_calendar_day_date_unique` (`calendar_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__district` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `province_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `province_id` (`province_id`),
  CONSTRAINT `district_ibfk_1` FOREIGN KEY (`province_id`) REFERENCES `db__province` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__faculty` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `faculty_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__leave_request` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `leave_type_id` bigint unsigned NOT NULL,
  `student_id` bigint unsigned NOT NULL,
  `academic_term_id` bigint unsigned DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int DEFAULT NULL,
  `affected_subject_count` int DEFAULT '0',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `json_file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `evidence_file_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `leave_type_id` (`leave_type_id`),
  KEY `student_id` (`student_id`),
  KEY `leave_request_status_idx` (`status`),
  KEY `leave_request_date_range_idx` (`start_date`,`end_date`),
  KEY `leave_request_student_status_idx` (`student_id`,`status`),
  KEY `leave_request_academic_term_id_idx` (`academic_term_id`),
  CONSTRAINT `leave_request_academic_term_ibfk_1` FOREIGN KEY (`academic_term_id`) REFERENCES `db__academic_term` (`id`) ON DELETE SET NULL,
  CONSTRAINT `leave_request_ibfk_1` FOREIGN KEY (`leave_type_id`) REFERENCES `db__leave_type` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `leave_request_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `db__student` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__leave_request_lecturer_read` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `leave_request_id` bigint unsigned NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `subject_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sec` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lecturer_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leave_request_lecturer_read_unique` (`leave_request_id`,`subject_code`,`sec`,`lecturer_code`),
  KEY `leave_request_id` (`leave_request_id`),
  KEY `lecturer_code` (`lecturer_code`),
  CONSTRAINT `leave_request_lecturer_read_leave_request_ibfk_1` FOREIGN KEY (`leave_request_id`) REFERENCES `db__leave_request` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__leave_type` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__major` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `faculty_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `major_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `faculty_id` (`faculty_id`),
  CONSTRAINT `major_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `db__faculty` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__province` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__student` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `prefix` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `full_name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `full_name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `major_id` bigint unsigned DEFAULT NULL,
  `address_detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `zipcode_id` bigint unsigned DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_id` (`account_id`),
  KEY `major_id` (`major_id`),
  KEY `zipcode_id` (`zipcode_id`),
  CONSTRAINT `student_account_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `db__account` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `db__major` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_ibfk_2` FOREIGN KEY (`zipcode_id`) REFERENCES `db__zipcode` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__student_subject_shortcut` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint unsigned NOT NULL,
  `subject_code` varchar(50) NOT NULL,
  `subject_name` varchar(255) DEFAULT NULL,
  `section_id` varchar(50) NOT NULL,
  `section` varchar(20) NOT NULL,
  `schedule_text` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `schedule` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_subject_shortcut_unique` (`student_id`,`subject_code`,`section_id`),
  KEY `student_id` (`student_id`),
  KEY `student_subject_shortcut_subject_code_idx` (`subject_code`),
  CONSTRAINT `student_subject_shortcut_student_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `db__student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `db__sub_district` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name_th` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `district_id` (`district_id`),
  CONSTRAINT `sub_district_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `db__district` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__user_auto_approve_rule` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `after_days` int unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_auto_approve_rule_account_role_unique` (`account_id`,`role`),
  KEY `user_auto_approve_rule_enabled_role_idx` (`enabled`,`role`),
  CONSTRAINT `user_auto_approve_rule_account_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `db__account` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `major_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_id` (`account_id`),
  KEY `major_id` (`major_id`),
  CONSTRAINT `users_account_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `db__account` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`major_id`) REFERENCES `db__major` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `db__zipcode` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `zipcode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_district_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sub_district_id` (`sub_district_id`),
  CONSTRAINT `zipcode_ibfk_1` FOREIGN KEY (`sub_district_id`) REFERENCES `db__sub_district` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==================== wh ====================
-- Railway schema-only metadata; inspected 2026-10-18 (Asia/Bangkok)
-- MySQL 9.7.2; source database: kukps-eng-leave-request-wh
-- No rows, credentials, or inferred foreign keys. Import as MySQL DDL.

CREATE TABLE `wh__dw_bridge_leave_subject_lecturer` (
  `request_key` bigint unsigned NOT NULL,
  `offering_key` bigint unsigned NOT NULL,
  `lecturer_key` bigint unsigned NOT NULL COMMENT 'Affected lecturer in request snapshot',
  `read_at` datetime(3) DEFAULT NULL COMMENT 'UTC; read receipt is NOT approval',
  PRIMARY KEY (`request_key`,`offering_key`,`lecturer_key`),
  KEY `ix_leave_lecturer` (`lecturer_key`,`request_key`,`offering_key`),
  CONSTRAINT `dw_bridge_leave_subject_lecturer_ibfk_1` FOREIGN KEY (`request_key`, `offering_key`) REFERENCES `wh__dw_fact_leave_subject` (`request_key`, `offering_key`),
  CONSTRAINT `dw_bridge_leave_subject_lecturer_ibfk_2` FOREIGN KEY (`lecturer_key`) REFERENCES `wh__dw_dim_person` (`person_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_bridge_offering_lecturer` (
  `offering_key` bigint unsigned NOT NULL,
  `lecturer_key` bigint unsigned NOT NULL,
  PRIMARY KEY (`offering_key`,`lecturer_key`),
  KEY `ix_offering_lecturer` (`lecturer_key`,`offering_key`),
  CONSTRAINT `dw_bridge_offering_lecturer_ibfk_1` FOREIGN KEY (`offering_key`) REFERENCES `wh__dw_dim_offering` (`offering_key`),
  CONSTRAINT `dw_bridge_offering_lecturer_ibfk_2` FOREIGN KEY (`lecturer_key`) REFERENCES `wh__dw_dim_person` (`person_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_bridge_person_department_term` (
  `person_key` bigint unsigned NOT NULL,
  `department_key` bigint unsigned NOT NULL,
  `term_key` bigint unsigned NOT NULL,
  `role_code` varchar(30) NOT NULL COMMENT 'Analytics affiliation, NOT application authorization',
  PRIMARY KEY (`person_key`,`department_key`,`term_key`,`role_code`),
  KEY `term_key` (`term_key`),
  KEY `ix_person_department` (`department_key`,`term_key`,`role_code`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_1` FOREIGN KEY (`person_key`) REFERENCES `wh__dw_dim_person` (`person_key`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_2` FOREIGN KEY (`department_key`) REFERENCES `wh__dw_dim_department` (`department_key`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_3` FOREIGN KEY (`term_key`) REFERENCES `wh__dw_dim_term` (`term_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_data_issue` (
  `issue_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `batch_key` bigint unsigned NOT NULL,
  `entity_type` varchar(60) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `issue_code` varchar(80) NOT NULL,
  `detail` varchar(1000) NOT NULL COMMENT 'Sanitized diagnostic; no reason/evidence/contact data',
  `resolved_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`issue_key`),
  KEY `batch_key` (`batch_key`),
  KEY `ix_issue_source` (`entity_type`,`source_id`),
  CONSTRAINT `dw_data_issue_ibfk_1` FOREIGN KEY (`batch_key`) REFERENCES `wh__dw_load_batch` (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_curriculum` (
  `curriculum_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `department_key` bigint unsigned NOT NULL,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL COMMENT 'Official program + revision identifier',
  `curriculum_code` varchar(50) NOT NULL,
  `revision_year_be` smallint unsigned DEFAULT NULL,
  `name_th` varchar(255) NOT NULL,
  `program_type` varchar(20) NOT NULL COMMENT 'Executive grouping: REGULAR/SPECIAL/INTERNATIONAL/UNKNOWN',
  PRIMARY KEY (`curriculum_key`),
  UNIQUE KEY `uq_curriculum_source` (`source_system`,`source_id`),
  KEY `department_key` (`department_key`),
  CONSTRAINT `dw_dim_curriculum_ibfk_1` FOREIGN KEY (`department_key`) REFERENCES `wh__dw_dim_department` (`department_key`),
  CONSTRAINT `ck_program_type` CHECK ((`program_type` in (_utf8mb4'REGULAR',_utf8mb4'SPECIAL',_utf8mb4'INTERNATIONAL',_utf8mb4'UNKNOWN')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_date` (
  `calendar_date` date NOT NULL,
  `calendar_year` smallint unsigned NOT NULL,
  `calendar_month` tinyint unsigned NOT NULL,
  `iso_weekday` tinyint unsigned NOT NULL COMMENT '1=Monday, 7=Sunday; Asia/Bangkok',
  `is_business_day` tinyint(1) NOT NULL,
  `holiday_name_th` varchar(255) DEFAULT NULL,
  `calendar_version` varchar(40) NOT NULL,
  PRIMARY KEY (`calendar_date`),
  CONSTRAINT `ck_calendar_month` CHECK ((`calendar_month` between 1 and 12)),
  CONSTRAINT `ck_calendar_weekday` CHECK ((`iso_weekday` between 1 and 7))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_department` (
  `department_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `faculty_key` bigint unsigned NOT NULL,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `department_code` varchar(30) NOT NULL,
  `name_th` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`department_key`),
  UNIQUE KEY `uq_department_source` (`source_system`,`source_id`),
  KEY `faculty_key` (`faculty_key`),
  CONSTRAINT `dw_dim_department_ibfk_1` FOREIGN KEY (`faculty_key`) REFERENCES `wh__dw_dim_faculty` (`faculty_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_faculty` (
  `faculty_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `faculty_code` varchar(20) DEFAULT NULL,
  `name_th` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`faculty_key`),
  UNIQUE KEY `uq_faculty_source` (`source_system`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_leave_type` (
  `leave_type_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `type_code` varchar(30) NOT NULL COMMENT 'Explicit mapping, e.g. sick/personal',
  `name_th` varchar(255) NOT NULL,
  PRIMARY KEY (`leave_type_key`),
  UNIQUE KEY `uq_leave_type_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_leave_type_code` (`type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_offering` (
  `offering_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `subject_key` bigint unsigned NOT NULL,
  `term_key` bigint unsigned NOT NULL,
  `section_code` varchar(20) NOT NULL,
  `section_kind` varchar(20) NOT NULL DEFAULT 'LECTURE',
  `owner_department_key` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`offering_key`),
  UNIQUE KEY `uq_offering_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_offering_natural` (`subject_key`,`term_key`,`section_code`,`section_kind`),
  KEY `term_key` (`term_key`),
  KEY `ix_offering_department_term` (`owner_department_key`,`term_key`),
  CONSTRAINT `dw_dim_offering_ibfk_1` FOREIGN KEY (`subject_key`) REFERENCES `wh__dw_dim_subject` (`subject_key`),
  CONSTRAINT `dw_dim_offering_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `wh__dw_dim_term` (`term_key`),
  CONSTRAINT `dw_dim_offering_ibfk_3` FOREIGN KEY (`owner_department_key`) REFERENCES `wh__dw_dim_department` (`department_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_person` (
  `person_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `nontri_id` varchar(50) DEFAULT NULL,
  `personnel_code` varchar(50) DEFAULT NULL,
  `full_name_th` varchar(255) NOT NULL,
  `full_name_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`person_key`),
  UNIQUE KEY `uq_person_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_person_nontri` (`nontri_id`),
  UNIQUE KEY `uq_person_code` (`personnel_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_student` (
  `student_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `student_code` varchar(20) NOT NULL,
  `prefix_th` varchar(50) DEFAULT NULL,
  `full_name_th` varchar(255) DEFAULT NULL,
  `full_name_en` varchar(255) DEFAULT NULL,
  `entry_year_be` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`student_key`),
  UNIQUE KEY `uq_student_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_student_code` (`student_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_subject` (
  `subject_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL COMMENT 'Official subject/version identifier',
  `subject_code` varchar(50) NOT NULL,
  `catalog_version` varchar(40) NOT NULL DEFAULT '',
  `name_th` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `owner_department_key` bigint unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`subject_key`),
  UNIQUE KEY `uq_subject_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_subject_version` (`subject_code`,`catalog_version`),
  KEY `owner_department_key` (`owner_department_key`),
  CONSTRAINT `dw_dim_subject_ibfk_1` FOREIGN KEY (`owner_department_key`) REFERENCES `wh__dw_dim_department` (`department_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_dim_term` (
  `term_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `academic_year_ce` smallint unsigned NOT NULL,
  `academic_year_be` smallint unsigned GENERATED ALWAYS AS ((`academic_year_ce` + 543)) STORED,
  `term_code` varchar(10) NOT NULL COMMENT 'Canonical 1=first, 2=second, 3=summer',
  `term_order` tinyint unsigned NOT NULL,
  `display_label_th` varchar(100) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`term_key`),
  UNIQUE KEY `uq_term_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_term_year_code` (`academic_year_ce`,`term_code`),
  UNIQUE KEY `uq_term_year_order` (`academic_year_ce`,`term_order`),
  CONSTRAINT `ck_term_code` CHECK ((`term_code` in (_utf8mb4'1',_utf8mb4'2',_utf8mb4'3'))),
  CONSTRAINT `ck_term_dates` CHECK ((`end_date` >= `start_date`)),
  CONSTRAINT `ck_term_order` CHECK ((`term_order` between 1 and 3))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_fact_approval_step` (
  `approval_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_approval_id` varchar(128) NOT NULL,
  `request_key` bigint unsigned NOT NULL,
  `approver_key` bigint unsigned NOT NULL,
  `role_code` varchar(30) NOT NULL COMMENT 'ADVISOR/DEPARTMENT_HEAD/ASSOCIATE_DEAN; do not infer from step_order',
  `step_order` smallint unsigned NOT NULL,
  `decision_status` varchar(30) NOT NULL,
  `decision_source` varchar(20) DEFAULT NULL,
  `ready_at` datetime(3) DEFAULT NULL COMMENT 'When this step became actionable, UTC',
  `decided_at` datetime(3) DEFAULT NULL,
  `timing_quality` varchar(20) NOT NULL COMMENT 'EXACT/DERIVED/MISSING',
  `elapsed_seconds` decimal(16,3) GENERATED ALWAYS AS ((timestampdiff(MICROSECOND,`ready_at`,`decided_at`) / 1000000.0)) STORED,
  `business_days` decimal(10,2) DEFAULT NULL COMMENT 'Uncapped, policy-calculated in ETL',
  `business_policy_version` varchar(80) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `source_updated_at` datetime(3) DEFAULT NULL,
  `loaded_at` datetime(3) NOT NULL,
  `batch_key` bigint unsigned NOT NULL,
  PRIMARY KEY (`approval_key`),
  UNIQUE KEY `uq_approval_source` (`source_system`,`source_approval_id`),
  KEY `batch_key` (`batch_key`),
  KEY `ix_approval_person` (`approver_key`,`role_code`,`decided_at`),
  KEY `ix_approval_request` (`request_key`,`step_order`),
  CONSTRAINT `dw_fact_approval_step_ibfk_1` FOREIGN KEY (`request_key`) REFERENCES `wh__dw_fact_leave_request` (`request_key`),
  CONSTRAINT `dw_fact_approval_step_ibfk_2` FOREIGN KEY (`approver_key`) REFERENCES `wh__dw_dim_person` (`person_key`),
  CONSTRAINT `dw_fact_approval_step_ibfk_3` FOREIGN KEY (`batch_key`) REFERENCES `wh__dw_load_batch` (`batch_key`),
  CONSTRAINT `ck_approval_business_days` CHECK ((`business_days` >= 0)),
  CONSTRAINT `ck_approval_dates` CHECK ((`decided_at` >= `ready_at`)),
  CONSTRAINT `ck_approval_decision` CHECK (((`decided_at` is null) or (`decision_status` in (_utf8mb4'APPROVED',_utf8mb4'REJECTED')))),
  CONSTRAINT `ck_approval_quality` CHECK ((`timing_quality` in (_utf8mb4'EXACT',_utf8mb4'DERIVED',_utf8mb4'MISSING')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_fact_leave_request` (
  `request_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_request_id` varchar(128) NOT NULL,
  `student_key` bigint unsigned NOT NULL,
  `term_key` bigint unsigned NOT NULL,
  `leave_type_key` bigint unsigned NOT NULL,
  `faculty_key` bigint unsigned DEFAULT NULL,
  `department_key` bigint unsigned DEFAULT NULL COMMENT 'Student department at submission',
  `curriculum_key` bigint unsigned DEFAULT NULL,
  `advisor_key` bigint unsigned DEFAULT NULL COMMENT 'Primary advisor at submission',
  `advisor_department_key` bigint unsigned DEFAULT NULL COMMENT 'Advisor affiliation at submission',
  `student_year` tinyint unsigned DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `request_days` decimal(10,2) NOT NULL,
  `day_range` varchar(12) GENERATED ALWAYS AS ((case when (`request_days` <= 15) then _utf8mb4'notOver15' else _utf8mb4'over15' end)) STORED,
  `status_code` varchar(30) NOT NULL,
  `declared_subject_count` int unsigned DEFAULT NULL COMMENT 'Source count, reconciliation only',
  `snapshot_subject_entry_count` int unsigned DEFAULT NULL COMMENT 'Raw affectedSubjects length BEFORE deduplication',
  `submitted_at` datetime(3) DEFAULT NULL COMMENT 'UTC',
  `source_updated_at` datetime(3) DEFAULT NULL,
  `source_hash` char(64) NOT NULL COMMENT 'SHA256 of canonical analytics fields + snapshot',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `loaded_at` datetime(3) NOT NULL,
  `batch_key` bigint unsigned NOT NULL,
  PRIMARY KEY (`request_key`),
  UNIQUE KEY `uq_request_source` (`source_system`,`source_request_id`),
  KEY `leave_type_key` (`leave_type_key`),
  KEY `advisor_department_key` (`advisor_department_key`),
  KEY `batch_key` (`batch_key`),
  KEY `ix_request_term` (`term_key`,`status_code`,`leave_type_key`,`day_range`),
  KEY `ix_request_student` (`student_key`,`term_key`,`status_code`),
  KEY `ix_request_advisor` (`advisor_key`,`term_key`,`status_code`),
  KEY `ix_request_department` (`department_key`,`term_key`,`status_code`),
  KEY `ix_request_faculty` (`faculty_key`,`term_key`,`status_code`),
  KEY `ix_request_curriculum` (`curriculum_key`,`term_key`),
  KEY `ix_request_dates` (`start_date`,`end_date`),
  CONSTRAINT `dw_fact_leave_request_ibfk_1` FOREIGN KEY (`student_key`) REFERENCES `wh__dw_dim_student` (`student_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `wh__dw_dim_term` (`term_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_3` FOREIGN KEY (`leave_type_key`) REFERENCES `wh__dw_dim_leave_type` (`leave_type_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_4` FOREIGN KEY (`faculty_key`) REFERENCES `wh__dw_dim_faculty` (`faculty_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_5` FOREIGN KEY (`department_key`) REFERENCES `wh__dw_dim_department` (`department_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_6` FOREIGN KEY (`curriculum_key`) REFERENCES `wh__dw_dim_curriculum` (`curriculum_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_7` FOREIGN KEY (`advisor_key`) REFERENCES `wh__dw_dim_person` (`person_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_8` FOREIGN KEY (`advisor_department_key`) REFERENCES `wh__dw_dim_department` (`department_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_9` FOREIGN KEY (`batch_key`) REFERENCES `wh__dw_load_batch` (`batch_key`),
  CONSTRAINT `ck_request_dates` CHECK ((`end_date` >= `start_date`)),
  CONSTRAINT `ck_request_days` CHECK ((`request_days` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_fact_leave_subject` (
  `request_key` bigint unsigned NOT NULL,
  `offering_key` bigint unsigned NOT NULL,
  `affected_teaching_days` decimal(10,2) DEFAULT NULL COMMENT 'NULL until verified timetable/affected-date data exists',
  PRIMARY KEY (`request_key`,`offering_key`),
  KEY `ix_leave_subject_offering` (`offering_key`,`request_key`),
  CONSTRAINT `dw_fact_leave_subject_ibfk_1` FOREIGN KEY (`request_key`) REFERENCES `wh__dw_fact_leave_request` (`request_key`),
  CONSTRAINT `dw_fact_leave_subject_ibfk_2` FOREIGN KEY (`offering_key`) REFERENCES `wh__dw_dim_offering` (`offering_key`),
  CONSTRAINT `ck_subject_days` CHECK ((`affected_teaching_days` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_load_batch` (
  `batch_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pipeline_code` varchar(80) NOT NULL,
  `started_at` datetime(3) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `source_watermark_from` varchar(255) DEFAULT NULL,
  `source_watermark_to` varchar(255) DEFAULT NULL,
  `loaded_rows` bigint unsigned NOT NULL DEFAULT '0',
  `rejected_rows` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_key`),
  KEY `ix_batch_pipeline` (`pipeline_code`,`started_at`),
  CONSTRAINT `ck_batch_status` CHECK ((`status` in (_utf8mb4'RUNNING',_utf8mb4'SUCCEEDED',_utf8mb4'FAILED')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `wh__dw_snapshot_student_term` (
  `student_key` bigint unsigned NOT NULL,
  `term_key` bigint unsigned NOT NULL,
  `department_key` bigint unsigned DEFAULT NULL,
  `curriculum_key` bigint unsigned DEFAULT NULL,
  `advisor_key` bigint unsigned DEFAULT NULL COMMENT 'Primary advisor at snapshot time; facts retain advisor at submission',
  `student_year` tinyint unsigned DEFAULT NULL,
  `roster_status` varchar(20) NOT NULL,
  `captured_at` datetime(3) NOT NULL,
  `batch_key` bigint unsigned NOT NULL,
  PRIMARY KEY (`student_key`,`term_key`),
  KEY `term_key` (`term_key`),
  KEY `curriculum_key` (`curriculum_key`),
  KEY `batch_key` (`batch_key`),
  KEY `ix_roster_advisor` (`advisor_key`,`term_key`),
  KEY `ix_roster_department` (`department_key`,`term_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_1` FOREIGN KEY (`student_key`) REFERENCES `wh__dw_dim_student` (`student_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `wh__dw_dim_term` (`term_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_3` FOREIGN KEY (`department_key`) REFERENCES `wh__dw_dim_department` (`department_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_4` FOREIGN KEY (`curriculum_key`) REFERENCES `wh__dw_dim_curriculum` (`curriculum_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_5` FOREIGN KEY (`advisor_key`) REFERENCES `wh__dw_dim_person` (`person_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_6` FOREIGN KEY (`batch_key`) REFERENCES `wh__dw_load_batch` (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ==================== leave-com ====================
-- Local Docker schema-only metadata; inspected 2026-10-18 (Asia/Bangkok)
-- MySQL 8.0.44; source database: leave-request-components
-- No rows, credentials, or inferred foreign keys. Import as MySQL DDL.

CREATE TABLE `leave_com___prisma_migrations` (
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

CREATE TABLE `leave_com__advisor_student` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `advisor_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `student_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `advisor_student_student_code_key` (`student_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `leave_com__subject_section_lecturers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_section_id` bigint unsigned NOT NULL,
  `lecturer_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lecturer_name` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subject_section_lecturers_section_lecturer` (`subject_section_id`,`lecturer_code`),
  CONSTRAINT `fk_subject_section_lecturers_section` FOREIGN KEY (`subject_section_id`) REFERENCES `leave_com__subject_sections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_subject_section_lecturers_identity` CHECK ((((`lecturer_code` is not null) and (char_length(trim(`lecturer_code`)) > 0)) or ((`lecturer_name` is not null) and (char_length(trim(`lecturer_name`)) > 0))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `leave_com__subject_sections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint unsigned NOT NULL,
  `section` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `schedule_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `schedule` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subject_sections_subject_section_schedule` (`subject_id`,`section`,`schedule_text`),
  CONSTRAINT `fk_subject_sections_subject` FOREIGN KEY (`subject_id`) REFERENCES `leave_com__subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `leave_com__subjects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subjects_subject_code` (`subject_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
