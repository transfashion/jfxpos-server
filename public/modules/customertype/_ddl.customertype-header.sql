-- customertype.sql


/* =============================================
 * CREATE TABLE public."customertype"
 * ============================================*/
create table public."customertype" (
	customertype_id smallint not null,
	constraint customertype_pk primary key (customertype_id)
);
comment on table public."customertype" is '';	


-- =============================================
-- FIELD: customertype_name text
-- =============================================
-- ADD customertype_name
alter table public."customertype" add customertype_name text  ;
comment on column public."customertype".customertype_name is '';

-- MODIFY customertype_name
alter table public."customertype"
	alter column customertype_name type text,
	ALTER COLUMN customertype_name DROP DEFAULT,
	ALTER COLUMN customertype_name DROP NOT NULL;
comment on column public."customertype".customertype_name is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."customertype" add _createby integer not null ;
comment on column public."customertype"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."customertype"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."customertype"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."customertype" add _createdate timestamp with time zone not null default now();
comment on column public."customertype"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."customertype"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."customertype"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."customertype" add _modifyby integer  ;
comment on column public."customertype"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."customertype"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."customertype"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."customertype" add _modifydate timestamp with time zone  ;
comment on column public."customertype"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."customertype"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."customertype"._modifydate is 'waktu terakhir record dimodifikasi';






-- =============================================
-- UNIQUE INDEX
-- =============================================
-- Drop existing unique index 
alter table public."customertype"
	drop constraint uq$public$customertype$customertype_name;
	

-- Add unique index 
alter table  public."customertype"
	add constraint uq$public$customertype$customertype_name unique (customertype_name); 

