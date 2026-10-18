-- Railway schema-only metadata; inspected 2026-10-18 (Asia/Bangkok)
-- MySQL 9.7.2; source database: kukps-eng-leave-request-wh
-- No rows, credentials, or inferred foreign keys. Import as MySQL DDL.

CREATE TABLE `dw_bridge_leave_subject_lecturer` (
  `request_key` bigint unsigned NOT NULL,
  `offering_key` bigint unsigned NOT NULL,
  `lecturer_key` bigint unsigned NOT NULL COMMENT 'Affected lecturer in request snapshot',
  `read_at` datetime(3) DEFAULT NULL COMMENT 'UTC; read receipt is NOT approval',
  PRIMARY KEY (`request_key`,`offering_key`,`lecturer_key`),
  KEY `ix_leave_lecturer` (`lecturer_key`,`request_key`,`offering_key`),
  CONSTRAINT `dw_bridge_leave_subject_lecturer_ibfk_1` FOREIGN KEY (`request_key`, `offering_key`) REFERENCES `dw_fact_leave_subject` (`request_key`, `offering_key`),
  CONSTRAINT `dw_bridge_leave_subject_lecturer_ibfk_2` FOREIGN KEY (`lecturer_key`) REFERENCES `dw_dim_person` (`person_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_bridge_offering_lecturer` (
  `offering_key` bigint unsigned NOT NULL,
  `lecturer_key` bigint unsigned NOT NULL,
  PRIMARY KEY (`offering_key`,`lecturer_key`),
  KEY `ix_offering_lecturer` (`lecturer_key`,`offering_key`),
  CONSTRAINT `dw_bridge_offering_lecturer_ibfk_1` FOREIGN KEY (`offering_key`) REFERENCES `dw_dim_offering` (`offering_key`),
  CONSTRAINT `dw_bridge_offering_lecturer_ibfk_2` FOREIGN KEY (`lecturer_key`) REFERENCES `dw_dim_person` (`person_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_bridge_person_department_term` (
  `person_key` bigint unsigned NOT NULL,
  `department_key` bigint unsigned NOT NULL,
  `term_key` bigint unsigned NOT NULL,
  `role_code` varchar(30) NOT NULL COMMENT 'Analytics affiliation, NOT application authorization',
  PRIMARY KEY (`person_key`,`department_key`,`term_key`,`role_code`),
  KEY `term_key` (`term_key`),
  KEY `ix_person_department` (`department_key`,`term_key`,`role_code`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_1` FOREIGN KEY (`person_key`) REFERENCES `dw_dim_person` (`person_key`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_2` FOREIGN KEY (`department_key`) REFERENCES `dw_dim_department` (`department_key`),
  CONSTRAINT `dw_bridge_person_department_term_ibfk_3` FOREIGN KEY (`term_key`) REFERENCES `dw_dim_term` (`term_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_data_issue` (
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
  CONSTRAINT `dw_data_issue_ibfk_1` FOREIGN KEY (`batch_key`) REFERENCES `dw_load_batch` (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_curriculum` (
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
  CONSTRAINT `dw_dim_curriculum_ibfk_1` FOREIGN KEY (`department_key`) REFERENCES `dw_dim_department` (`department_key`),
  CONSTRAINT `ck_program_type` CHECK ((`program_type` in (_utf8mb4'REGULAR',_utf8mb4'SPECIAL',_utf8mb4'INTERNATIONAL',_utf8mb4'UNKNOWN')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_date` (
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

CREATE TABLE `dw_dim_department` (
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
  CONSTRAINT `dw_dim_department_ibfk_1` FOREIGN KEY (`faculty_key`) REFERENCES `dw_dim_faculty` (`faculty_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_faculty` (
  `faculty_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `faculty_code` varchar(20) DEFAULT NULL,
  `name_th` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`faculty_key`),
  UNIQUE KEY `uq_faculty_source` (`source_system`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_leave_type` (
  `leave_type_key` bigint unsigned NOT NULL AUTO_INCREMENT,
  `source_system` varchar(40) NOT NULL,
  `source_id` varchar(128) NOT NULL,
  `type_code` varchar(30) NOT NULL COMMENT 'Explicit mapping, e.g. sick/personal',
  `name_th` varchar(255) NOT NULL,
  PRIMARY KEY (`leave_type_key`),
  UNIQUE KEY `uq_leave_type_source` (`source_system`,`source_id`),
  UNIQUE KEY `uq_leave_type_code` (`type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_offering` (
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
  CONSTRAINT `dw_dim_offering_ibfk_1` FOREIGN KEY (`subject_key`) REFERENCES `dw_dim_subject` (`subject_key`),
  CONSTRAINT `dw_dim_offering_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `dw_dim_term` (`term_key`),
  CONSTRAINT `dw_dim_offering_ibfk_3` FOREIGN KEY (`owner_department_key`) REFERENCES `dw_dim_department` (`department_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_person` (
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

CREATE TABLE `dw_dim_student` (
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

CREATE TABLE `dw_dim_subject` (
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
  CONSTRAINT `dw_dim_subject_ibfk_1` FOREIGN KEY (`owner_department_key`) REFERENCES `dw_dim_department` (`department_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_dim_term` (
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

CREATE TABLE `dw_fact_approval_step` (
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
  CONSTRAINT `dw_fact_approval_step_ibfk_1` FOREIGN KEY (`request_key`) REFERENCES `dw_fact_leave_request` (`request_key`),
  CONSTRAINT `dw_fact_approval_step_ibfk_2` FOREIGN KEY (`approver_key`) REFERENCES `dw_dim_person` (`person_key`),
  CONSTRAINT `dw_fact_approval_step_ibfk_3` FOREIGN KEY (`batch_key`) REFERENCES `dw_load_batch` (`batch_key`),
  CONSTRAINT `ck_approval_business_days` CHECK ((`business_days` >= 0)),
  CONSTRAINT `ck_approval_dates` CHECK ((`decided_at` >= `ready_at`)),
  CONSTRAINT `ck_approval_decision` CHECK (((`decided_at` is null) or (`decision_status` in (_utf8mb4'APPROVED',_utf8mb4'REJECTED')))),
  CONSTRAINT `ck_approval_quality` CHECK ((`timing_quality` in (_utf8mb4'EXACT',_utf8mb4'DERIVED',_utf8mb4'MISSING')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_fact_leave_request` (
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
  CONSTRAINT `dw_fact_leave_request_ibfk_1` FOREIGN KEY (`student_key`) REFERENCES `dw_dim_student` (`student_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `dw_dim_term` (`term_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_3` FOREIGN KEY (`leave_type_key`) REFERENCES `dw_dim_leave_type` (`leave_type_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_4` FOREIGN KEY (`faculty_key`) REFERENCES `dw_dim_faculty` (`faculty_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_5` FOREIGN KEY (`department_key`) REFERENCES `dw_dim_department` (`department_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_6` FOREIGN KEY (`curriculum_key`) REFERENCES `dw_dim_curriculum` (`curriculum_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_7` FOREIGN KEY (`advisor_key`) REFERENCES `dw_dim_person` (`person_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_8` FOREIGN KEY (`advisor_department_key`) REFERENCES `dw_dim_department` (`department_key`),
  CONSTRAINT `dw_fact_leave_request_ibfk_9` FOREIGN KEY (`batch_key`) REFERENCES `dw_load_batch` (`batch_key`),
  CONSTRAINT `ck_request_dates` CHECK ((`end_date` >= `start_date`)),
  CONSTRAINT `ck_request_days` CHECK ((`request_days` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_fact_leave_subject` (
  `request_key` bigint unsigned NOT NULL,
  `offering_key` bigint unsigned NOT NULL,
  `affected_teaching_days` decimal(10,2) DEFAULT NULL COMMENT 'NULL until verified timetable/affected-date data exists',
  PRIMARY KEY (`request_key`,`offering_key`),
  KEY `ix_leave_subject_offering` (`offering_key`,`request_key`),
  CONSTRAINT `dw_fact_leave_subject_ibfk_1` FOREIGN KEY (`request_key`) REFERENCES `dw_fact_leave_request` (`request_key`),
  CONSTRAINT `dw_fact_leave_subject_ibfk_2` FOREIGN KEY (`offering_key`) REFERENCES `dw_dim_offering` (`offering_key`),
  CONSTRAINT `ck_subject_days` CHECK ((`affected_teaching_days` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `dw_load_batch` (
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

CREATE TABLE `dw_snapshot_student_term` (
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
  CONSTRAINT `dw_snapshot_student_term_ibfk_1` FOREIGN KEY (`student_key`) REFERENCES `dw_dim_student` (`student_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_2` FOREIGN KEY (`term_key`) REFERENCES `dw_dim_term` (`term_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_3` FOREIGN KEY (`department_key`) REFERENCES `dw_dim_department` (`department_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_4` FOREIGN KEY (`curriculum_key`) REFERENCES `dw_dim_curriculum` (`curriculum_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_5` FOREIGN KEY (`advisor_key`) REFERENCES `dw_dim_person` (`person_key`),
  CONSTRAINT `dw_snapshot_student_term_ibfk_6` FOREIGN KEY (`batch_key`) REFERENCES `dw_load_batch` (`batch_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
