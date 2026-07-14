-- customer.sql


/* =============================================
 * CREATE TABLE public."customer"
 * ============================================*/
create table public."customer" (
	customer_id bigint not null,
	constraint customer_pk primary key (customer_id)
);
comment on table public."customer" is '';	


-- =============================================
-- FIELD: customer_name text
-- =============================================
-- ADD customer_name
alter table public."customer" add customer_name text  ;
comment on column public."customer".customer_name is '';

-- MODIFY customer_name
alter table public."customer"
	alter column customer_name type text,
	ALTER COLUMN customer_name DROP DEFAULT,
	ALTER COLUMN customer_name DROP NOT NULL;
comment on column public."customer".customer_name is '';


-- =============================================
-- FIELD: customertype_id smallint
-- =============================================
-- ADD customertype_id
alter table public."customer" add customertype_id smallint  ;
comment on column public."customer".customertype_id is '';

-- MODIFY customertype_id
alter table public."customer"
	alter column customertype_id type smallint,
	ALTER COLUMN customertype_id DROP DEFAULT,
	ALTER COLUMN customertype_id DROP NOT NULL;
comment on column public."customer".customertype_id is '';


-- =============================================
-- FIELD: gender_id smallint
-- =============================================
-- ADD gender_id
alter table public."customer" add gender_id smallint  ;
comment on column public."customer".gender_id is '';

-- MODIFY gender_id
alter table public."customer"
	alter column gender_id type smallint,
	ALTER COLUMN gender_id DROP DEFAULT,
	ALTER COLUMN gender_id DROP NOT NULL;
comment on column public."customer".gender_id is '';


-- =============================================
-- FIELD: customer_birthdate date
-- =============================================
-- ADD customer_birthdate
alter table public."customer" add customer_birthdate date  default now();
comment on column public."customer".customer_birthdate is '';

-- MODIFY customer_birthdate
alter table public."customer"
	alter column customer_birthdate type date,
	ALTER COLUMN customer_birthdate SET DEFAULT now(),
	ALTER COLUMN customer_birthdate DROP NOT NULL;
comment on column public."customer".customer_birthdate is '';


-- =============================================
-- FIELD: customer_hasbirthdate boolean
-- =============================================
-- ADD customer_hasbirthdate
alter table public."customer" add customer_hasbirthdate boolean not null default false;
comment on column public."customer".customer_hasbirthdate is '';

-- MODIFY customer_hasbirthdate
alter table public."customer"
	alter column customer_hasbirthdate type boolean,
	ALTER COLUMN customer_hasbirthdate SET DEFAULT false,
	ALTER COLUMN customer_hasbirthdate SET NOT NULL;
comment on column public."customer".customer_hasbirthdate is '';


-- =============================================
-- FIELD: datatimestamp timestamp with time zone
-- =============================================
-- ADD datatimestamp
alter table public."customer" add datatimestamp timestamp with time zone  ;
comment on column public."customer".datatimestamp is '';

-- MODIFY datatimestamp
alter table public."customer"
	alter column datatimestamp type timestamp with time zone,
	ALTER COLUMN datatimestamp DROP DEFAULT,
	ALTER COLUMN datatimestamp DROP NOT NULL;
comment on column public."customer".datatimestamp is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."customer" add _createby integer not null ;
comment on column public."customer"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."customer"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."customer"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."customer" add _createdate timestamp with time zone not null default now();
comment on column public."customer"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."customer"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."customer"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."customer" add _modifyby integer  ;
comment on column public."customer"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."customer"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."customer"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."customer" add _modifydate timestamp with time zone  ;
comment on column public."customer"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."customer"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."customer"._modifydate is 'waktu terakhir record dimodifikasi';




-- =============================================
-- FOREIGN KEY CONSTRAINT
-- =============================================
-- Drop Existing Foreign Key Constraint 
ALTER TABLE public."customer" DROP CONSTRAINT fk$public$customer$customertype_id;
ALTER TABLE public."customer" DROP CONSTRAINT fk$public$customer$gender_id;


-- Add Foreign Key Constraint  
ALTER TABLE public."customer"
	ADD CONSTRAINT fk$public$customer$customertype_id
	FOREIGN KEY (customertype_id)
	REFERENCES public."customertype"(customertype_id);


-- Add As Index, drop dulu jika sudah ada
DROP INDEX IF EXISTS public.idx_fk$public$customer$customertype_id;
CREATE INDEX idx_fk$public$customer$customertype_id ON public."customer"(customertype_id);	


ALTER TABLE public."customer"
	ADD CONSTRAINT fk$public$customer$gender_id
	FOREIGN KEY (gender_id)
	REFERENCES public."gender"(gender_id);


-- Add As Index, drop dulu jika sudah ada
DROP INDEX IF EXISTS public.idx_fk$public$customer$gender_id;
CREATE INDEX idx_fk$public$customer$gender_id ON public."customer"(gender_id);	

	


-- =============================================
-- UNIQUE INDEX
-- =============================================