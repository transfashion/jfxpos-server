-- gender.sql


/* =============================================
 * CREATE TABLE public."gender"
 * ============================================*/
create table public."gender" (
	gender_id smallint not null,
	constraint gender_pk primary key (gender_id)
);
comment on table public."gender" is '';	


-- =============================================
-- FIELD: gender_name text
-- =============================================
-- ADD gender_name
alter table public."gender" add gender_name text  ;
comment on column public."gender".gender_name is '';

-- MODIFY gender_name
alter table public."gender"
	alter column gender_name type text,
	ALTER COLUMN gender_name DROP DEFAULT,
	ALTER COLUMN gender_name DROP NOT NULL;
comment on column public."gender".gender_name is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."gender" add _createby integer not null ;
comment on column public."gender"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."gender"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."gender"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."gender" add _createdate timestamp with time zone not null default now();
comment on column public."gender"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."gender"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."gender"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."gender" add _modifyby integer  ;
comment on column public."gender"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."gender"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."gender"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."gender" add _modifydate timestamp with time zone  ;
comment on column public."gender"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."gender"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."gender"._modifydate is 'waktu terakhir record dimodifikasi';






-- =============================================
-- UNIQUE INDEX
-- =============================================
-- Add unique index 
alter table  public."gender"
	add constraint uq$public$gender$gender_name unique (gender_name); 

