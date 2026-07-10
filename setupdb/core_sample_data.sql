-- =============================================================
-- Sample Data: core schema
-- Generated : 2026-07-10T10:36:32.448Z
-- User IDs  : 240100000, 230100000
-- ProgramGroups: 5, 100
-- =============================================================

-- Insert order: parent tables first to satisfy FK constraints
--   1. core.setting      (no FK)
--   2. core.apps         (no FK)
--   3. core.group        (no FK)
--   4. core.user         (no FK)
--   5. core.usergroup    (FK → core.user, core.group)
--   6. core.programgroup (FK → self)
--   7. core.program      (FK → core.apps, core.programgroup)

SET search_path TO "core", public;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."setting"  (6 rows) — static seed
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_CODE', '01', 'kode perusahaan, 2 digit numerik, untuk keperluan konsolidasi bisa sistem dipakai di beberapa anak perusahaan', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_NAME', 'My Company Name', 'nama perusahaan', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_ADDR1', '1st line of address', 'alamat perusahaan baris 1', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_ADDR2', '2nd line of company address', 'alamat perusahaan baris 2', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_ADDR3', '3rd line of company address', 'alamat perusahaan baris 3', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;
INSERT INTO "core"."setting" ("setting_id", "setting_value", "setting_descr", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES ('COMPANY_PHONE', 'my company phone', 'nomor telepon perusahaan', 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("setting_id") DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."apps"  (1 row) — from DB
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."apps" ("apps_id", "apps_name", "apps_url", "apps_descr", "apps_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "apps_directory")
VALUES ('accounting', 'Accounting Apps', 'https://act-dev.transfashion.id', 'port 3003 accounting', FALSE, 240100000, '2025-09-11T06:04:10.197Z', NULL, NULL, '/home/ubuntu/Development/metroindonesia/accounting')
ON CONFLICT ("apps_id") DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."group"  (1 row) — from DB
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."group" ("group_id", "group_name", "group_descr", "group_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES (260300001, 'administrator', 'Administrator', FALSE, 240100000, '2026-02-01T04:59:34.748Z', NULL, NULL)
ON CONFLICT ("group_id") DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."user"  (2 rows) — from DB
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."user" ("user_id", "user_name", "user_nickname", "user_fullname", "user_email", "user_password", "user_isdisabled", "user_isdev", "user_isallowallprogram", "user_isshowallprogram", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES (230100000, 'SYSTEM', 'SYSTEM', 'SYSTEM', '', '$2b$10$jnzOyIDTQF4VdZymZGJys.0N2u2g3X1XJiLRvdS/CD2I1vPA8hqNe', FALSE, FALSE, FALSE, FALSE, 230100000, '2025-11-03T08:13:34.462Z', NULL, NULL)
ON CONFLICT ("user_id") DO NOTHING;
INSERT INTO "core"."user" ("user_id", "user_name", "user_nickname", "user_fullname", "user_email", "user_password", "user_isdisabled", "user_isdev", "user_isallowallprogram", "user_isshowallprogram", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES (240100000, 'agung', 'agung', 'Agung Nugroho', 'agung@email.com', '$2b$10$WhcTZsL0WQpmehEnVSK47un5qNgUXfxCcFt3VCu2V2PtOFzEOV5a6', FALSE, TRUE, TRUE, FALSE, 230100000, '2025-11-03T08:13:41.055Z', 240100000, '2026-06-27T00:05:32.709Z')
ON CONFLICT ("user_id") DO UPDATE SET user_password = EXCLUDED.user_password, user_email = EXCLUDED.user_email, user_isdev = EXCLUDED.user_isdev, user_isallowallprogram = EXCLUDED.user_isallowallprogram;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."usergroup"  (1 row) — from DB
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."usergroup" ("usergroup_id", "group_id", "usergroup_isdisabled", "user_id", "_createby", "_createdate", "_modifyby", "_modifydate")
VALUES (260202000001, 260300001, FALSE, 240100000, 240100000, '2026-02-01T05:03:42.951Z', NULL, NULL)
ON CONFLICT ("usergroup_id") DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."programgroup"  (2 rows) — from DB (ordered by hierarchy)
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."programgroup" ("programgroup_id", "programgroup_name", "programgroup_descr", "programgroup_isparent", "programgroup_parent", "programgroup_pathid", "programgroup_path", "programgroup_level", "_createby", "_createdate", "_modifyby", "_modifydate", "programgroup_icon")
VALUES (5, 'Developer', '', FALSE, NULL, 0005, 0005, 1, 240100000, '2026-02-13T03:11:15.095Z', NULL, NULL, '')
ON CONFLICT ("programgroup_id") DO NOTHING;
INSERT INTO "core"."programgroup" ("programgroup_id", "programgroup_name", "programgroup_descr", "programgroup_isparent", "programgroup_parent", "programgroup_pathid", "programgroup_path", "programgroup_level", "_createby", "_createdate", "_modifyby", "_modifydate", "programgroup_icon")
VALUES (100, 'Administrator', 'group untuk manage core apps di system', TRUE, NULL, 0100, 0100, 1, 240100000, '2026-01-31T21:45:08.396Z', 240100000, '2026-02-03T11:00:50.823Z', '')
ON CONFLICT ("programgroup_id") DO NOTHING;

-- ────────────────────────────────────────────────────────────
-- Sample data: "core"."program"  (10 rows) — from DB
-- ────────────────────────────────────────────────────────────
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260000002, 'Program Group', 'accounting', 'programgroup', NULL, 100, 'grouping program, untuk mengelompokkan program-program dalam hierarki', 'public/modules/programgroup/programgroup.svg', FALSE, 240100000, '2026-01-31T21:43:32.944Z', 1, '2026-06-23T03:29:39.434Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100001, 'Document', 'accounting', 'doc', NULL, 100, 'data document', 'public/modules/doc/doc.svg', FALSE, 240100000, '2026-02-01T01:57:45.709Z', 1, '2026-06-23T03:28:55.132Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100002, 'Program', 'accounting', 'program', NULL, 100, 'daftar program', 'public/modules/program/program.svg', FALSE, 240100000, '2026-02-01T02:57:54.698Z', 1, '2026-06-24T06:21:00.782Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100003, 'Application', 'accounting', 'apps', NULL, 100, 'daftar applikasi', 'public/modules/apps/apps.svg', TRUE, 240100000, '2026-02-01T03:51:05.115Z', 1, '2026-06-23T03:28:37.889Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100004, 'Group', 'accounting', 'group', NULL, 100, 'group', 'public/modules/group/group.svg', FALSE, 240100000, '2026-02-01T04:27:09.541Z', 1, '2026-06-24T06:20:28.696Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100005, 'User', 'accounting', 'user', NULL, 100, 'daftar user', 'public/modules/user/user.svg', FALSE, 240100000, '2026-02-01T04:32:20.387Z', 1, '2026-06-24T06:22:04.698Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100006, 'Interface', 'accounting', 'interface', NULL, 100, '', 'public/modules/interface/interface.svg', FALSE, 240100000, '2026-02-01T09:45:28.733Z', 1, '2026-06-23T03:29:01.995Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100007, 'Setting', 'accounting', 'setting', NULL, 100, 'setting', 'public/modules/setting/setting.svg', FALSE, 1, '2026-02-01T10:10:57.886Z', 1, '2026-06-23T03:29:46.435Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100008, 'Authorization', 'accounting', 'auth', NULL, 100, '', 'public/modules/auth/auth.svg', FALSE, 240100000, '2026-02-01T11:11:34.099Z', 1, '2026-06-23T03:28:40.233Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
INSERT INTO "core"."program" ("program_id", "program_title", "apps_id", "program_name", "program_variance", "programgroup_id", "program_descr", "program_icon", "program_isdisabled", "_createby", "_createdate", "_modifyby", "_modifydate", "generator_id")
VALUES (260100030, 'Program Generator', 'accounting', 'generator', NULL, 5, 'program generator', 'generator/generator.svg', TRUE, 240100000, '2026-02-13T03:12:05.062Z', 240100000, '2026-06-01T13:45:51.217Z', NULL)
ON CONFLICT ("program_id") DO NOTHING;
