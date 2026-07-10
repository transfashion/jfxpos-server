-- =============================================================
-- Migration: Create / Sync schema "log"
-- Generated: 2026-07-10T10:36:15.826Z
-- Tables   : 1
-- Functions: 0
-- Strategy : Phase 0 = sequences
--            Phase 1 = tables/columns/constraints/indexes
--            Phase 2 = foreign keys (after all tables exist)
--            Phase 3 = functions & procedures (CREATE OR REPLACE)
-- =============================================================

-- Ensure schema exists
CREATE SCHEMA IF NOT EXISTS "log";

SET search_path TO "log", public;
-- =============================================================
-- PHASE 0: Sequences (referenced by DEFAULT nextval() in tables)
-- =============================================================
-- Sequences for "log"."datalog"
CREATE SEQUENCE IF NOT EXISTS "log"."datalog_log_id_seq"
  START WITH 1
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  CACHE 1
  NO CYCLE;

-- =============================================================
-- PHASE 1: Create tables, columns, PK/unique/check, indexes
-- =============================================================
-- ============================================================
-- Table: "log"."datalog"
-- ============================================================

-- Step 1: Create table if not exists
CREATE TABLE IF NOT EXISTS "log"."datalog" (
  "log_id" BIGINT DEFAULT nextval('log.datalog_log_id_seq'::regclass) NOT NULL,
  "log_time" TIMESTAMPTZ NOT NULL,
  "log_user_id" TEXT,
  "log_user_name" TEXT,
  "log_action" TEXT,
  "log_ipaddress" TEXT,
  "log_module" TEXT,
  "log_table" TEXT,
  "log_doc_id" TEXT,
  "log_remark" TEXT,
  "log_executiontime" INTEGER,
  "log_metadata" JSONB,
  CONSTRAINT "datalog_pkey" PRIMARY KEY ("log_id")
);

-- Step 2: Add columns if not exists (safe to re-run)
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_id" BIGINT DEFAULT nextval('log.datalog_log_id_seq'::regclass) NOT NULL;
-- WARNING: "log_time" is NOT NULL without DEFAULT.
-- Adding as NULL first; you must backfill before setting NOT NULL.
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_time" TIMESTAMPTZ;
-- TODO: UPDATE "log"."datalog" SET "log_time" = <value> WHERE "log_time" IS NULL;
-- ALTER TABLE "log"."datalog" ALTER COLUMN "log_time" SET NOT NULL;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_user_id" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_user_name" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_action" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_ipaddress" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_module" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_table" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_doc_id" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_remark" TEXT;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_executiontime" INTEGER;
ALTER TABLE "log"."datalog"
  ADD COLUMN IF NOT EXISTS "log_metadata" JSONB;

-- Step 3: Add PK / unique / check constraints if not exists
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_schema = 'log' AND table_name = 'datalog'
      AND constraint_name = 'datalog_pkey' AND constraint_type = 'PRIMARY KEY'
  ) THEN
    ALTER TABLE "log"."datalog" ADD CONSTRAINT "datalog_pkey" PRIMARY KEY ("log_id");
  END IF;
END $$;

-- Step 4: Create indexes if not exists
CREATE INDEX IF NOT EXISTS "datalog_log_time_idx" ON "log"."datalog" USING BTREE ("log_time");
CREATE INDEX IF NOT EXISTS "idx_datalog_module_table_id" ON "log"."datalog" USING BTREE ("log_module", "log_table", "log_doc_id");

