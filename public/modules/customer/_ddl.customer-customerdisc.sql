-- customer.sql


/* =============================================
 * CREATE TABLE public."customerdisc"
 * ============================================*/
create table public."customerdisc" (
	customerdisc_id bigint not null,
	constraint customerdisc_pk primary key (customerdisc_id)
);
comment on table public."customerdisc" is '';	


-- =============================================
-- FIELD: customerdisc_start date
-- =============================================
-- ADD customerdisc_start
alter table public."customerdisc" add customerdisc_start date  default now();
comment on column public."customerdisc".customerdisc_start is '';

-- MODIFY customerdisc_start
alter table public."customerdisc"
	alter column customerdisc_start type date,
	ALTER COLUMN customerdisc_start SET DEFAULT now(),
	ALTER COLUMN customerdisc_start DROP NOT NULL;
comment on column public."customerdisc".customerdisc_start is '';


-- =============================================
-- FIELD: customerdisc_end date
-- =============================================
-- ADD customerdisc_end
alter table public."customerdisc" add customerdisc_end date  default now();
comment on column public."customerdisc".customerdisc_end is '';

-- MODIFY customerdisc_end
alter table public."customerdisc"
	alter column customerdisc_end type date,
	ALTER COLUMN customerdisc_end SET DEFAULT now(),
	ALTER COLUMN customerdisc_end DROP NOT NULL;
comment on column public."customerdisc".customerdisc_end is '';


-- =============================================
-- FIELD: customerdisc_ref text
-- =============================================
-- ADD customerdisc_ref
alter table public."customerdisc" add customerdisc_ref text  ;
comment on column public."customerdisc".customerdisc_ref is '';

-- MODIFY customerdisc_ref
alter table public."customerdisc"
	alter column customerdisc_ref type text,
	ALTER COLUMN customerdisc_ref DROP DEFAULT,
	ALTER COLUMN customerdisc_ref DROP NOT NULL;
comment on column public."customerdisc".customerdisc_ref is '';


-- =============================================
-- FIELD: customerdisc_percent decimal(6, 2)
-- =============================================
-- ADD customerdisc_percent
alter table public."customerdisc" add customerdisc_percent decimal(6, 2) not null default 0;
comment on column public."customerdisc".customerdisc_percent is '';

-- MODIFY customerdisc_percent
alter table public."customerdisc"
	alter column customerdisc_percent type decimal(6, 2),
	ALTER COLUMN customerdisc_percent SET DEFAULT 0,
	ALTER COLUMN customerdisc_percent SET NOT NULL;
comment on column public."customerdisc".customerdisc_percent is '';


-- =============================================
-- FIELD: customerdisc_rebate decimal(9, 0)
-- =============================================
-- ADD customerdisc_rebate
alter table public."customerdisc" add customerdisc_rebate decimal(9, 0) not null default 0;
comment on column public."customerdisc".customerdisc_rebate is '';

-- MODIFY customerdisc_rebate
alter table public."customerdisc"
	alter column customerdisc_rebate type decimal(9, 0),
	ALTER COLUMN customerdisc_rebate SET DEFAULT 0,
	ALTER COLUMN customerdisc_rebate SET NOT NULL;
comment on column public."customerdisc".customerdisc_rebate is '';


-- =============================================
-- FIELD: customer_id bigint
-- =============================================
-- ADD customer_id
alter table public."customerdisc" add customer_id bigint  ;
comment on column public."customerdisc".customer_id is '';

-- MODIFY customer_id
alter table public."customerdisc"
	alter column customer_id type bigint,
	ALTER COLUMN customer_id DROP DEFAULT,
	ALTER COLUMN customer_id DROP NOT NULL;
comment on column public."customerdisc".customer_id is '';


-- =============================================
-- FIELD: _createby integer
-- =============================================
-- ADD _createby
alter table public."customerdisc" add _createby integer not null ;
comment on column public."customerdisc"._createby is 'user yang pertama kali membuat record ini';

-- MODIFY _createby
alter table public."customerdisc"
	alter column _createby type integer,
	ALTER COLUMN _createby DROP DEFAULT,
	ALTER COLUMN _createby SET NOT NULL;
comment on column public."customerdisc"._createby is 'user yang pertama kali membuat record ini';


-- =============================================
-- FIELD: _createdate timestamp with time zone
-- =============================================
-- ADD _createdate
alter table public."customerdisc" add _createdate timestamp with time zone not null default now();
comment on column public."customerdisc"._createdate is 'waktu record dibuat pertama kali';

-- MODIFY _createdate
alter table public."customerdisc"
	alter column _createdate type timestamp with time zone,
	ALTER COLUMN _createdate SET DEFAULT now(),
	ALTER COLUMN _createdate SET NOT NULL;
comment on column public."customerdisc"._createdate is 'waktu record dibuat pertama kali';


-- =============================================
-- FIELD: _modifyby integer
-- =============================================
-- ADD _modifyby
alter table public."customerdisc" add _modifyby integer  ;
comment on column public."customerdisc"._modifyby is 'user yang terakhir modifikasi record ini';

-- MODIFY _modifyby
alter table public."customerdisc"
	alter column _modifyby type integer,
	ALTER COLUMN _modifyby DROP DEFAULT,
	ALTER COLUMN _modifyby DROP NOT NULL;
comment on column public."customerdisc"._modifyby is 'user yang terakhir modifikasi record ini';


-- =============================================
-- FIELD: _modifydate timestamp with time zone
-- =============================================
-- ADD _modifydate
alter table public."customerdisc" add _modifydate timestamp with time zone  ;
comment on column public."customerdisc"._modifydate is 'waktu terakhir record dimodifikasi';

-- MODIFY _modifydate
alter table public."customerdisc"
	alter column _modifydate type timestamp with time zone,
	ALTER COLUMN _modifydate DROP DEFAULT,
	ALTER COLUMN _modifydate DROP NOT NULL;
comment on column public."customerdisc"._modifydate is 'waktu terakhir record dimodifikasi';






-- =============================================
-- UNIQUE INDEX
-- =============================================