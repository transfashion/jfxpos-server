-- site.sql


/* =============================================
 * CREATE TABLE public."sitebrand"
 * ============================================*/
create table public."sitebrand" (
	sitebrand_id bigint not null,
	constraint sitebrand_pk primary key (sitebrand_id)
);
comment on table public."sitebrand" is '';	


-- =============================================
-- FIELD: brand_id int
-- =============================================
-- ADD brand_id
alter table public."sitebrand" add brand_id int  ;
comment on column public."sitebrand".brand_id is '';

-- MODIFY brand_id
alter table public."sitebrand"
	alter column brand_id type int,
	ALTER COLUMN brand_id DROP DEFAULT,
	ALTER COLUMN brand_id DROP NOT NULL;
comment on column public."sitebrand".brand_id is '';


-- =============================================
-- FIELD: sitebrand_isdisabled boolean
-- =============================================
-- ADD sitebrand_isdisabled
alter table public."sitebrand" add sitebrand_isdisabled boolean not null default false;
comment on column public."sitebrand".sitebrand_isdisabled is '';

-- MODIFY sitebrand_isdisabled
alter table public."sitebrand"
	alter column sitebrand_isdisabled type boolean,
	ALTER COLUMN sitebrand_isdisabled SET DEFAULT false,
	ALTER COLUMN sitebrand_isdisabled SET NOT NULL;
comment on column public."sitebrand".sitebrand_isdisabled is '';


-- =============================================
-- FIELD: datatimestamp timestamp with time zone
-- =============================================
-- ADD datatimestamp
alter table public."sitebrand" add datatimestamp timestamp with time zone  ;
comment on column public."sitebrand".datatimestamp is '';

-- MODIFY datatimestamp
alter table public."sitebrand"
	alter column datatimestamp type timestamp with time zone,
	ALTER COLUMN datatimestamp DROP DEFAULT,
	ALTER COLUMN datatimestamp DROP NOT NULL;
comment on column public."sitebrand".datatimestamp is '';


-- =============================================
-- FIELD: site_id int
-- =============================================
-- ADD site_id
alter table public."sitebrand" add site_id int  ;
comment on column public."sitebrand".site_id is '';

-- MODIFY site_id
alter table public."sitebrand"
	alter column site_id type int,
	ALTER COLUMN site_id DROP DEFAULT,
	ALTER COLUMN site_id DROP NOT NULL;
comment on column public."sitebrand".site_id is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."sitebrand" add _createby integer not null ;
comment on column public."sitebrand"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."sitebrand"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."sitebrand"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."sitebrand" add _createdate timestamp with time zone not null default now();
comment on column public."sitebrand"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."sitebrand"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."sitebrand"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."sitebrand" add _modifyby integer  ;
comment on column public."sitebrand"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."sitebrand"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."sitebrand"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."sitebrand" add _modifydate timestamp with time zone  ;
comment on column public."sitebrand"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."sitebrand"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."sitebrand"._modifydate is 'waktu terakhir record dimodifikasi';




-- =============================================
-- FOREIGN KEY CONSTRAINT
-- =============================================
-- Drop Existing Foreign Key Constraint 
ALTER TABLE public."sitebrand" DROP CONSTRAINT fk$public$sitebrand$brand_id;


-- Add Foreign Key Constraint  
ALTER TABLE public."sitebrand"
	ADD CONSTRAINT fk$public$sitebrand$brand_id
	FOREIGN KEY (brand_id)
	REFERENCES public."brand"(brand_id);


-- Add As Index, drop dulu jika sudah ada
DROP INDEX IF EXISTS public.idx_fk$public$sitebrand$brand_id;
CREATE INDEX idx_fk$public$sitebrand$brand_id ON public."sitebrand"(brand_id);	

	


-- =============================================
-- UNIQUE INDEX
-- =============================================