-- struct.sql


/* =============================================
 * CREATE TABLE public."struct"
 * ============================================*/
create table public."struct" (
	struct_id int not null,
	constraint struct_pk primary key (struct_id)
);
comment on table public."struct" is '';	


-- =============================================
-- FIELD: struct_isdisabled boolean
-- =============================================
-- ADD struct_isdisabled
alter table public."struct" add struct_isdisabled boolean not null default false;
comment on column public."struct".struct_isdisabled is '';

-- MODIFY struct_isdisabled
alter table public."struct"
	alter column struct_isdisabled type boolean,
	ALTER COLUMN struct_isdisabled SET DEFAULT false,
	ALTER COLUMN struct_isdisabled SET NOT NULL;
comment on column public."struct".struct_isdisabled is '';


-- =============================================
-- FIELD: struct_code text
-- =============================================
-- ADD struct_code
alter table public."struct" add struct_code text  ;
comment on column public."struct".struct_code is '';

-- MODIFY struct_code
alter table public."struct"
	alter column struct_code type text,
	ALTER COLUMN struct_code DROP DEFAULT,
	ALTER COLUMN struct_code DROP NOT NULL;
comment on column public."struct".struct_code is '';


-- =============================================
-- FIELD: struct_name text
-- =============================================
-- ADD struct_name
alter table public."struct" add struct_name text  ;
comment on column public."struct".struct_name is '';

-- MODIFY struct_name
alter table public."struct"
	alter column struct_name type text,
	ALTER COLUMN struct_name DROP DEFAULT,
	ALTER COLUMN struct_name DROP NOT NULL;
comment on column public."struct".struct_name is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."struct" add _createby integer not null ;
comment on column public."struct"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."struct"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."struct"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."struct" add _createdate timestamp with time zone not null default now();
comment on column public."struct"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."struct"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."struct"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."struct" add _modifyby integer  ;
comment on column public."struct"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."struct"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."struct"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."struct" add _modifydate timestamp with time zone  ;
comment on column public."struct"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."struct"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."struct"._modifydate is 'waktu terakhir record dimodifikasi';






-- =============================================
-- UNIQUE INDEX
-- =============================================
-- Add unique index 
alter table  public."struct"
	add constraint uq$public$struct$struct_code unique (struct_code); 

alter table  public."struct"
	add constraint uq$public$struct$struct_name unique (struct_name); 

