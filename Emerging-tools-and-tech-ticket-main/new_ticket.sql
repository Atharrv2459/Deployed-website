--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2026-03-17 00:44:51

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA IF NOT EXISTS public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 33751)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_code character varying(50),
    company_name character varying(255) NOT NULL,
    industry_type character varying(100),
    contact_name character varying(255),
    contact_email character varying(255),
    contact_phone character varying(50),
    address text,
    city character varying(100),
    state character varying(100),
    country character varying(100),
    timezone character varying(50),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    created_by uuid
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 33759)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33766)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 219
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 220 (class 1259 OID 33767)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    role_name character varying(20) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33770)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 221
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 222 (class 1259 OID 33771)
-- Name: ticket_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket_attachments (
    id integer NOT NULL,
    ticket_id integer,
    file_name character varying(255),
    file_type character varying(50),
    file_path text,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uploaded_by integer
);


ALTER TABLE public.ticket_attachments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33777)
-- Name: ticket_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 223
-- Name: ticket_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_attachments_id_seq OWNED BY public.ticket_attachments.id;


--
-- TOC entry 224 (class 1259 OID 33778)
-- Name: ticket_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket_comments (
    id integer NOT NULL,
    ticket_id integer NOT NULL,
    commented_by integer NOT NULL,
    comment_subject character varying(255),
    comment_text text NOT NULL,
    commented_role character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ticket_comments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33784)
-- Name: ticket_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_comments_id_seq OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 225
-- Name: ticket_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_comments_id_seq OWNED BY public.ticket_comments.id;


--
-- TOC entry 226 (class 1259 OID 33785)
-- Name: ticket_status_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket_status_logs (
    id integer NOT NULL,
    ticket_id integer NOT NULL,
    old_status character varying(30),
    new_status character varying(30) NOT NULL,
    changed_by integer NOT NULL,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ticket_status_logs OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 33789)
-- Name: ticket_status_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ticket_status_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ticket_status_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 227
-- Name: ticket_status_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ticket_status_logs_id_seq OWNED BY public.ticket_status_logs.id;


--
-- TOC entry 228 (class 1259 OID 33790)
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    id integer NOT NULL,
    requester character varying(100) NOT NULL,
    contact_email character varying(100),
    contact_phone character varying(20),
    subject character varying(200) NOT NULL,
    description text,
    category character varying(50) NOT NULL,
    status character varying(30) DEFAULT 'Open'::character varying,
    priority character varying(20),
    assignee_id integer,
    account_name character varying(100),
    due_date date,
    sla_hours integer NOT NULL,
    resolution text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    escalated_to integer,
    escalation_reason text,
    delivery_lead_id integer,
    approval_status character varying(20) DEFAULT 'Pending'::character varying,
    approved_by integer,
    approved_at timestamp without time zone,
    assigned_by integer,
    assigned_at timestamp without time zone,
    rejection_reason text,
    sub_category character varying(100) NOT NULL,
    type character varying(30) NOT NULL,
    environment character varying(20) NOT NULL,
    rca text,
    comment text,
    waiting_for_customer boolean DEFAULT false,
    requester_id integer,
    customer_id uuid,
    created_for integer,
    CONSTRAINT ticket_status_check CHECK (((status)::text = ANY (ARRAY[('Unassigned'::character varying)::text, ('Open'::character varying)::text, ('Assigned'::character varying)::text, ('Requirements'::character varying)::text, ('Development'::character varying)::text, ('Internal Testing'::character varying)::text, ('UAT'::character varying)::text, ('Resolved'::character varying)::text, ('Closed'::character varying)::text]))),
    CONSTRAINT tickets_category_check CHECK (((category)::text = ANY (ARRAY[('SAP'::character varying)::text, ('Product'::character varying)::text, ('Integration'::character varying)::text, ('Other'::character varying)::text]))),
    CONSTRAINT tickets_environment_check CHECK (((environment)::text = ANY (ARRAY[('QA'::character varying)::text, ('PRD'::character varying)::text]))),
    CONSTRAINT tickets_type_check CHECK (((type)::text = ANY (ARRAY[('Incident'::character varying)::text, ('Query'::character varying)::text, ('Problem'::character varying)::text, ('Change'::character varying)::text])))
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33804)
-- Name: tickets_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets_backup (
    id integer,
    customer_id integer,
    requester character varying(100),
    contact_email character varying(100),
    contact_phone character varying(20),
    subject character varying(200),
    description text,
    category character varying(50),
    status character varying(30),
    priority character varying(20),
    assignee_id integer,
    account_name character varying(100),
    due_date date,
    sla_hours integer,
    resolution text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    escalated_to integer,
    escalation_reason text,
    delivery_lead_id integer,
    approval_status character varying(20),
    approved_by integer,
    approved_at timestamp without time zone,
    assigned_by integer,
    assigned_at timestamp without time zone,
    rejection_reason text,
    sub_category character varying(100),
    type character varying(30),
    environment character varying(20),
    rca text,
    comment text,
    waiting_for_customer boolean,
    requester_id integer
);


ALTER TABLE public.tickets_backup OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33809)
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tickets_id_seq OWNER TO postgres;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 230
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- TOC entry 231 (class 1259 OID 33810)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    role_id integer NOT NULL,
    phone character varying(20),
    department character varying(50),
    organization character varying(100),
    associated_account character varying(100),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    account_name character varying(100),
    agent_type character varying(20),
    delivery_lead_id integer,
    customer_type character varying(20),
    manager_id integer,
    user_type character varying(20),
    customer_id uuid,
    CONSTRAINT users_agent_type_check CHECK (((agent_type)::text = ANY (ARRAY[('normal'::character varying)::text, ('delivery_lead'::character varying)::text, ('admin'::character varying)::text, ('hod'::character varying)::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33818)
-- Name: users_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_backup (
    id integer,
    name character varying(100),
    email character varying(100),
    password_hash text,
    role_id integer,
    phone character varying(20),
    department character varying(50),
    organization character varying(100),
    associated_account character varying(100),
    is_active boolean,
    created_at timestamp without time zone,
    account_name character varying(100),
    agent_type character varying(20),
    delivery_lead_id integer,
    customer_type character varying(20),
    manager_id integer,
    customer_id integer,
    user_type character varying(20)
);


ALTER TABLE public.users_backup OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33823)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 233
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4787 (class 2604 OID 33936)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 33937)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 33938)
-- Name: ticket_attachments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_attachments ALTER COLUMN id SET DEFAULT nextval('public.ticket_attachments_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 33939)
-- Name: ticket_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_comments ALTER COLUMN id SET DEFAULT nextval('public.ticket_comments_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 33940)
-- Name: ticket_status_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_status_logs ALTER COLUMN id SET DEFAULT nextval('public.ticket_status_logs_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 33941)
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 33942)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4996 (class 0 OID 33751)
-- Dependencies: 217
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, customer_code, company_name, industry_type, contact_name, contact_email, contact_phone, address, city, state, country, timezone, status, created_at, created_by) FROM stdin;
98041a70-66f1-4a71-9fbc-c82196c957ae	samraddhi1123415	Test Company1	\N	\N	akul.varshney@xrstahasadasd.in	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
07d1cafe-2185-44f1-bb1b-aa9b797876a0	commonagent221234	Orane	\N	\N	commonagent22@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
2d8bc85a-96f9-43f1-a443-ca49453bbd55	haldiram12345	Orane	\N	\N	haldiram@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
6d159a55-4a4c-4403-831d-db1e5039a817	samraddhi1234	Test Company1	\N	\N	samraddhi.gupta@orane.in	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
c9e4c8c0-b011-42ac-9e97-b411acb23dfd	bharti1234	Orane	\N	\N	bharti@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
5352672b-103e-4466-a439-518f3a99ddbb	samraddhi12345	Test Company1	\N	\N	samraddhisatvik@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
a16df7aa-305f-43b3-8de0-fcb1888cae98	Akshay123	ABC Pvt Ltd	\N	\N	akshaytiwari@company.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
7e634209-31d2-4bf4-a5b5-402ac47164e3	amit_account	MyCompany	\N	\N	amit.customer@company.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
706634bf-9c5f-4b71-a93f-81a5e92cda14	Anjali1234	Test Company1	\N	\N	anjali.sharma@orane.in	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
7f2580d6-c000-4476-a3f6-2beca886035b	manager21234	Orane	\N	\N	commonManager2@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
d046cdf6-2591-411f-90f5-4379841f14e1	dl21234	Orane	\N	\N	commondl2@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
9b7c5db8-064c-4321-a60b-de492a90163b	manager1234	Orane	\N	\N	commonManager@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
75822183-c081-4db2-8ea7-0f4183739193	admin_account	MyCompany	\N	\N	customer@company.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
b2c0763d-63d4-43cc-a85e-c40f0c449e96	sanju1234	Test Company1	\N	\N	sanju.nishad@orane.in	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
089d0c8b-feed-444d-980e-ffb014efb487	samraddhi123415	Test Company1	\N	\N	akul.varshney@orane.in	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
38540862-b813-4824-b4af-61b7082e9500	Atharrv1234	Test Company1	\N	\N	atharrv1@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
06405950-6517-410b-b69f-8eae26faf54b	ABC Pvt Ltd	ABC Pvt Ltd	\N	\N	aryansaxena@company.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
b9995d3b-ac1e-45e2-8421-4c6e042c30fb	commonagent111234	Orane	\N	\N	commonagent11@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
1efaeb53-6177-43e1-9352-eb732b3f9ff4	namdhari1234	Orane	\N	\N	namdhari@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
a4cac835-54c6-4d93-9824-9b6fc141c0df	Ojas123	ABC Pvt Ltd	\N	\N	ojasverma@company.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
39037fa2-ae8d-4753-8bc6-d2f4005daa63	biba1234	Orane	\N	\N	biba@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
62a43d31-1d03-4e2a-879b-c7512f680509	shivangi11234	Test Company1	\N	\N	shivangi1329@gmail.com	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 22:24:42.945861	\N
0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	INTERNAL	Orane Internal / Legacy	\N	\N	\N	\N	\N	\N	\N	\N	\N	ACTIVE	2026-01-16 23:35:48.520525	\N
\.


--
-- TOC entry 4997 (class 0 OID 33759)
-- Dependencies: 218
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, title, message, is_read, created_at) FROM stdin;
1	55	Ticket Raised	Your ticket #82 has been raised successfully	f	2026-01-04 16:58:37.979596
2	60	New Ticket Pending Approval	Ticket #82 requires your approval	f	2026-01-04 16:58:38.055003
3	48	Ticket Approved	Ticket #82 has been approved and is ready for assignment	f	2026-01-04 16:59:01.506195
4	55	Ticket Raised	Your ticket #83 has been raised successfully	f	2026-01-05 10:45:27.185586
5	60	New Ticket Pending Approval	Ticket #83 requires your approval	f	2026-01-05 10:45:27.245393
6	55	Ticket Raised	Your ticket #84 has been raised successfully	f	2026-01-05 10:45:29.660963
7	60	New Ticket Pending Approval	Ticket #84 requires your approval	f	2026-01-05 10:45:29.772736
8	48	Ticket Approved	Ticket #83 has been approved and is ready for assignment	f	2026-01-05 10:48:28.267229
9	48	Ticket Approved	Ticket #84 has been approved and is ready for assignment	f	2026-01-05 10:48:35.123267
10	50	New Ticket Assigned	Ticket #83 has been assigned to you	f	2026-01-05 12:18:33.957534
11	48	Ticket Status Updated	Ticket #83 moved from Development to Uat	f	2026-01-05 12:30:27.747149
12	50	New Ticket Assigned	Ticket #84 has been assigned to you	f	2026-01-05 12:30:51.924761
13	48	Ticket Status Updated	Ticket #84 moved from Assigned to Requirements	f	2026-01-05 12:31:23.827838
14	48	Ticket Status Updated	Ticket #84 moved from Requirements to Development	f	2026-01-05 12:32:38.362403
15	48	Ticket Approved	Ticket #72 has been approved and is ready for assignment	f	2026-01-05 15:33:56.623289
16	50	New Ticket Assigned	Ticket #49 has been assigned to you	f	2026-01-05 15:34:24.142938
17	48	Ticket Approved	Ticket #69 has been approved and is ready for assignment	f	2026-01-05 15:41:01.337553
18	50	New Ticket Assigned	Ticket #74 has been assigned to you	f	2026-01-05 15:41:15.241526
19	55	Ticket Raised	Your ticket #92 has been raised successfully	f	2026-01-05 17:09:42.396563
20	60	New Ticket Pending Approval	Ticket #92 requires your approval	f	2026-01-05 17:09:42.452908
21	55	Ticket Raised	Your ticket #93 has been raised successfully	f	2026-01-05 17:10:14.499253
22	60	New Ticket Pending Approval	Ticket #93 requires your approval	f	2026-01-05 17:10:14.511441
23	55	Ticket Raised	Your ticket #94 has been raised successfully	f	2026-01-05 17:10:23.542597
24	60	New Ticket Pending Approval	Ticket #94 requires your approval	f	2026-01-05 17:10:23.646916
25	55	Ticket Raised	Your ticket #95 has been raised successfully	f	2026-01-05 17:20:24.428395
26	60	New Ticket Pending Approval	Ticket #95 requires your approval	f	2026-01-05 17:20:24.505404
27	55	Ticket Raised	Your ticket #96 has been raised successfully	f	2026-01-05 18:31:20.761174
28	60	New Ticket Pending Approval	Ticket #96 requires your approval	f	2026-01-05 18:31:20.826824
29	55	Ticket Raised	Your ticket #97 has been raised successfully	f	2026-01-05 19:47:29.107009
30	60	New Ticket Pending Approval	Ticket #97 requires your approval	f	2026-01-05 19:47:29.110924
31	55	Ticket Raised	Your ticket #98 has been raised successfully	f	2026-01-05 19:55:17.432114
32	60	New Ticket Pending Approval	Ticket #98 requires your approval	f	2026-01-05 19:55:17.451027
33	48	Ticket Approved	Ticket #98 has been approved and is ready for assignment	f	2026-01-05 19:55:30.640202
34	50	New Ticket Assigned	Ticket #98 has been assigned to you	f	2026-01-05 19:56:00.401017
35	55	Ticket Raised	Your ticket #99 has been raised successfully	f	2026-01-06 10:29:42.757198
36	60	New Ticket Pending Approval	Ticket #99 requires your approval	f	2026-01-06 10:29:43.172982
37	55	Ticket Raised	Your ticket #100 has been raised successfully	f	2026-01-06 10:30:31.675577
38	60	New Ticket Pending Approval	Ticket #100 requires your approval	f	2026-01-06 10:30:31.793917
39	48	Ticket Approved	Ticket #100 has been approved and is ready for assignment	f	2026-01-06 10:31:40.782268
40	50	New Ticket Assigned	Ticket #100 has been assigned to you	f	2026-01-06 10:33:02.046062
41	55	Ticket Raised	Your ticket #101 has been raised successfully	f	2026-01-06 11:55:52.429884
42	60	New Ticket Pending Approval	Ticket #101 requires your approval	f	2026-01-06 11:55:52.491078
43	55	Ticket Raised	Your ticket #102 has been raised successfully	f	2026-01-06 11:55:53.991532
44	60	New Ticket Pending Approval	Ticket #102 requires your approval	f	2026-01-06 11:55:54.017305
45	55	Ticket Raised	Your ticket #103 has been raised successfully	f	2026-01-06 11:55:55.57806
46	60	New Ticket Pending Approval	Ticket #103 requires your approval	f	2026-01-06 11:55:55.641803
47	55	Ticket Raised	Your ticket #104 has been raised successfully	f	2026-01-06 11:55:56.871017
48	60	New Ticket Pending Approval	Ticket #104 requires your approval	f	2026-01-06 11:55:56.88449
49	48	Ticket Approved	Ticket #101 has been approved and is ready for assignment	f	2026-01-06 11:56:09.763737
50	48	Ticket Approved	Ticket #102 has been approved and is ready for assignment	f	2026-01-06 11:56:12.74725
51	48	Ticket Approved	Ticket #103 has been approved and is ready for assignment	f	2026-01-06 11:56:15.807166
52	48	Ticket Approved	Ticket #104 has been approved and is ready for assignment	f	2026-01-06 11:56:18.660709
53	50	New Ticket Assigned	Ticket #101 has been assigned to you	f	2026-01-06 11:57:00.051684
54	50	New Ticket Assigned	Ticket #102 has been assigned to you	f	2026-01-06 11:57:06.306807
55	48	Ticket Status Updated	Ticket #101 moved from Assigned to Requirements	f	2026-01-06 15:03:32.077779
56	48	Ticket Status Updated	Ticket #101 moved from Requirements to Development	f	2026-01-06 15:13:56.33609
57	48	Ticket Status Updated	Ticket #101 moved from Development to Uat	f	2026-01-06 15:14:14.842187
58	48	Ticket Status Updated	Ticket #101 moved from Uat to Closed	f	2026-01-06 15:16:05.598971
59	55	Ticket Raised	Your ticket #105 has been raised successfully	f	2026-01-06 19:41:14.14402
60	60	New Ticket Pending Approval	Ticket #105 requires your approval	f	2026-01-06 19:41:14.206767
62	55	Ticket Raised	Your ticket #108 has been raised successfully	f	2026-01-06 23:29:27.687957
63	60	New Ticket Pending Approval	Ticket #108 requires your approval	f	2026-01-06 23:29:27.704146
64	55	Ticket Raised	Your ticket #109 has been raised successfully	f	2026-01-07 10:49:55.010361
65	60	New Ticket Pending Approval	Ticket #109 requires your approval	f	2026-01-07 10:49:55.012984
66	55	Ticket Raised	Your ticket #110 has been raised successfully	f	2026-01-07 11:02:03.355196
67	60	New Ticket Pending Approval	Ticket #110 requires your approval	f	2026-01-07 11:02:03.356715
68	55	Ticket Raised	Your ticket #111 has been raised successfully	f	2026-01-07 11:02:09.698414
69	60	New Ticket Pending Approval	Ticket #111 requires your approval	f	2026-01-07 11:02:09.768925
70	55	Ticket Raised	Your ticket #112 has been raised successfully	f	2026-01-07 11:12:21.130183
71	60	New Ticket Pending Approval	Ticket #112 requires your approval	f	2026-01-07 11:12:21.189466
72	55	Ticket Raised	Your ticket #113 has been raised successfully	f	2026-01-07 11:12:52.169604
73	60	New Ticket Pending Approval	Ticket #113 requires your approval	f	2026-01-07 11:12:52.181512
74	48	Ticket Status Updated	Ticket #102 moved from Assigned to Requirements	f	2026-01-07 11:19:49.558365
75	48	Ticket Status Updated	Ticket #102 moved from Requirements to Development	f	2026-01-07 11:28:58.294821
76	55	Ticket Raised	Your ticket #114 has been raised successfully	f	2026-01-07 11:47:18.507754
77	55	Ticket Raised	Your ticket #116 has been raised successfully	f	2026-01-07 11:47:18.51216
78	55	Ticket Raised	Your ticket #115 has been raised successfully	f	2026-01-07 11:47:18.512381
79	60	New Ticket Pending Approval	Ticket #114 requires your approval	f	2026-01-07 11:47:18.513212
80	60	New Ticket Pending Approval	Ticket #116 requires your approval	f	2026-01-07 11:47:18.513668
81	60	New Ticket Pending Approval	Ticket #115 requires your approval	f	2026-01-07 11:47:18.513911
82	48	Ticket Status Updated	Ticket #102 moved from Development to Uat	f	2026-01-07 11:57:19.453143
83	55	Ticket Raised	Your ticket #117 has been raised successfully	f	2026-01-07 14:34:43.692809
84	60	New Ticket Pending Approval	Ticket #117 requires your approval	f	2026-01-07 14:34:43.830295
85	48	Ticket Approved	Ticket #117 has been approved and is ready for assignment	f	2026-01-07 14:38:49.098136
86	55	Ticket Raised	Your ticket #118 has been raised successfully	f	2026-01-07 14:43:30.463868
87	60	New Ticket Pending Approval	Ticket #118 requires your approval	f	2026-01-07 14:43:30.486318
88	55	Ticket Raised	Your ticket #119 has been raised successfully	f	2026-01-07 14:44:00.326942
89	60	New Ticket Pending Approval	Ticket #119 requires your approval	f	2026-01-07 14:44:00.336491
90	55	Ticket Raised	Your ticket #120 has been raised successfully	f	2026-01-07 14:44:11.4478
91	60	New Ticket Pending Approval	Ticket #120 requires your approval	f	2026-01-07 14:44:11.469549
92	55	Ticket Raised	Your ticket #121 has been raised successfully	f	2026-01-07 14:47:52.346562
93	60	New Ticket Pending Approval	Ticket #121 requires your approval	f	2026-01-07 14:47:52.361231
94	55	Ticket Raised	Your ticket #122 has been raised successfully	f	2026-01-07 15:00:13.422632
95	60	New Ticket Pending Approval	Ticket #122 requires your approval	f	2026-01-07 15:00:13.486818
96	55	Ticket Raised	Your ticket #123 has been raised successfully	f	2026-01-07 15:39:42.740499
97	60	New Ticket Pending Approval	Ticket #123 requires your approval	f	2026-01-07 15:39:42.823759
98	48	Ticket Approved	Ticket #123 has been approved and is ready for assignment	f	2026-01-08 11:09:29.407977
99	50	New Ticket Assigned	Ticket #123 has been assigned to you	f	2026-01-08 11:10:06.785068
100	48	Ticket Approved	Ticket #120 has been approved and is ready for assignment	f	2026-01-08 12:24:46.478817
101	50	New Ticket Assigned	Ticket #120 has been assigned to you	f	2026-01-08 12:26:33.836502
102	55	Ticket Raised	Your ticket #124 has been raised successfully	f	2026-01-08 16:35:25.772485
103	60	New Ticket Pending Approval	Ticket #124 requires your approval	f	2026-01-08 16:35:26.030501
104	55	Ticket Raised	Your ticket #125 has been raised successfully	f	2026-01-08 16:38:43.734321
105	60	New Ticket Pending Approval	Ticket #125 requires your approval	f	2026-01-08 16:38:43.762444
106	48	Ticket Status Updated	Ticket #120 moved from Assigned to Requirements	f	2026-01-09 10:18:44.738204
107	48	Ticket Status Updated	Ticket #120 moved from Requirements to Development	f	2026-01-09 10:22:59.133846
108	48	Ticket Status Updated	Ticket #120 moved from Development to Internal Testing	f	2026-01-09 11:16:06.423982
109	55	Ticket Raised	Your ticket #126 has been raised successfully	f	2026-01-09 11:57:04.605875
110	60	New Ticket Pending Approval	Ticket #126 requires your approval	f	2026-01-09 11:57:04.711238
111	48	Ticket Approved	Ticket #126 has been approved and is ready for assignment	f	2026-01-09 11:57:35.447158
112	50	New Ticket Assigned	Ticket #126 has been assigned to you	f	2026-01-09 11:58:10.551792
113	55	Ticket Raised	Your ticket #127 has been raised successfully	f	2026-01-09 12:05:00.787866
114	60	New Ticket Pending Approval	Ticket #127 requires your approval	f	2026-01-09 12:05:00.811318
115	55	Ticket Raised	Your ticket #128 has been raised successfully	f	2026-01-09 12:55:48.994421
116	60	New Ticket Pending Approval	Ticket #128 requires your approval	f	2026-01-09 12:55:49.036685
117	55	Ticket Raised	Your ticket #129 has been raised successfully	f	2026-01-09 12:58:40.287287
118	60	New Ticket Pending Approval	Ticket #129 requires your approval	f	2026-01-09 12:58:40.380699
119	55	Ticket Raised	Your ticket #130 has been raised successfully	f	2026-01-09 13:17:40.904875
120	60	New Ticket Pending Approval	Ticket #130 requires your approval	f	2026-01-09 13:17:40.916672
121	48	Ticket Approved	Ticket #130 has been approved and is ready for assignment	f	2026-01-09 13:19:15.697578
122	50	New Ticket Assigned	Ticket #130 has been assigned to you	f	2026-01-09 13:23:37.00604
123	48	Ticket Status Updated	Ticket #130 moved from Development to Internal Testing	f	2026-01-09 15:57:35.342783
124	48	Ticket Status Updated	Ticket #130 moved from Internal Testing to UAT	f	2026-01-09 15:58:14.570258
125	48	Ticket Status Updated	Ticket #126 moved from Internal Testing to UAT	f	2026-01-09 16:41:31.04265
126	48	Ticket Status Updated	Ticket #98 moved from Assigned to Requirements	f	2026-01-09 17:59:29.609339
127	55	Ticket Raised	Your ticket #131 has been raised successfully	f	2026-01-11 23:17:47.162539
128	60	New Ticket Pending Approval	Ticket #131 requires your approval	f	2026-01-11 23:17:47.26338
129	55	Ticket Raised	Your ticket #136 has been raised successfully	f	2026-01-12 10:57:41.418258
130	60	New Ticket Pending Approval	Ticket #136 requires your approval	f	2026-01-12 10:57:41.730693
131	55	Ticket Raised	Your ticket #137 has been raised successfully	f	2026-01-12 11:47:56.107147
132	60	New Ticket Pending Approval	Ticket #137 requires your approval	f	2026-01-12 11:47:56.187367
133	48	Ticket Approved	Ticket #137 has been approved and is ready for assignment	f	2026-01-12 11:49:15.956406
134	48	Ticket Approved	Ticket #136 has been approved and is ready for assignment	f	2026-01-12 12:16:30.773486
135	55	Ticket Raised	Your ticket #138 has been raised successfully	f	2026-01-12 12:32:39.702653
136	60	New Ticket Pending Approval	Ticket #138 requires your approval	f	2026-01-12 12:32:39.707295
137	48	Ticket Approved	Ticket #138 has been approved and is ready for assignment	f	2026-01-12 12:38:24.780926
138	55	Ticket Raised	Your ticket #139 has been raised successfully	f	2026-01-12 13:06:49.855405
139	60	New Ticket Pending Approval	Ticket #139 requires your approval	f	2026-01-12 13:06:49.860397
140	55	Ticket Raised	Your ticket #140 has been raised successfully	f	2026-01-12 13:23:00.277488
141	60	New Ticket Pending Approval	Ticket #140 requires your approval	f	2026-01-12 13:23:00.400105
142	55	Ticket Raised	Your ticket #141 has been raised successfully	f	2026-01-12 13:32:28.856858
143	60	New Ticket Pending Approval	Ticket #141 requires your approval	f	2026-01-12 13:32:29.32125
144	55	Ticket Raised	Your ticket #142 has been raised successfully	f	2026-01-12 13:56:43.814156
145	60	New Ticket Pending Approval	Ticket #142 requires your approval	f	2026-01-12 13:56:43.873075
146	55	Ticket Raised	Your ticket #143 has been raised successfully	f	2026-01-12 13:57:29.623548
147	60	New Ticket Pending Approval	Ticket #143 requires your approval	f	2026-01-12 13:57:29.823707
148	55	Ticket Raised	Your ticket #144 has been raised successfully	f	2026-01-12 14:54:08.866408
149	60	New Ticket Pending Approval	Ticket #144 requires your approval	f	2026-01-12 14:54:08.899177
150	55	Ticket Raised	Your ticket #145 has been raised successfully	f	2026-01-12 15:03:53.231706
151	60	New Ticket Pending Approval	Ticket #145 requires your approval	f	2026-01-12 15:03:53.257859
152	48	Ticket Approved	Ticket #143 has been approved and is ready for assignment	f	2026-01-12 15:59:52.2438
153	50	New Ticket Assigned	Ticket #143 has been assigned to you	f	2026-01-12 16:00:38.109852
154	55	Ticket Raised	Your ticket #146 has been raised successfully	f	2026-01-12 16:21:27.518428
155	60	New Ticket Pending Approval	Ticket #146 requires your approval	f	2026-01-12 16:21:27.526009
156	55	Ticket Raised	Your ticket #147 has been raised successfully	f	2026-01-12 16:35:13.820675
157	60	New Ticket Pending Approval	Ticket #147 requires your approval	f	2026-01-12 16:35:14.315348
158	48	Ticket Approved	Ticket #147 has been approved and is ready for assignment	f	2026-01-12 16:35:39.587245
159	55	Ticket Raised	Your ticket #148 has been raised successfully	f	2026-01-12 16:37:05.548593
160	60	New Ticket Pending Approval	Ticket #148 requires your approval	f	2026-01-12 16:37:05.555145
161	55	Ticket Raised	Your ticket #149 has been raised successfully	f	2026-01-12 16:37:06.479628
162	60	New Ticket Pending Approval	Ticket #149 requires your approval	f	2026-01-12 16:37:06.48224
163	48	Ticket Approved	Ticket #149 has been approved and is ready for assignment	f	2026-01-12 16:38:50.136947
164	60	Ticket Created	Ticket #150 created successfully	f	2026-01-12 16:53:48.31268
165	60	Ticket Created	Ticket #151 created successfully	f	2026-01-12 16:55:42.701816
166	60	Ticket Raised	Your ticket #153 has been raised successfully	f	2026-01-12 22:45:55.131698
168	60	Ticket Raised	Your ticket #154 has been raised successfully	f	2026-01-12 22:46:06.536817
170	48	Ticket Raised	Your ticket #155 has been raised successfully	f	2026-01-12 22:48:17.85187
172	50	Ticket Raised	Your ticket #156 has been raised successfully	f	2026-01-12 22:52:22.405225
174	50	Ticket Raised	Your ticket #157 has been raised successfully	f	2026-01-12 23:08:43.641081
176	48	Ticket Raised	Your ticket #158 has been created successfully	f	2026-01-13 09:48:15.595406
177	48	Ticket Raised	Your ticket #159 has been created successfully	f	2026-01-13 10:34:47.540834
178	48	Ticket Approved	Ticket #148 has been approved and is ready for assignment	f	2026-01-13 12:26:07.821527
179	48	Ticket Approved	Ticket #168 has been approved and is ready for assignment	f	2026-01-13 13:41:28.832597
180	48	Ticket Approved	Ticket #170 has been approved and is ready for assignment	f	2026-01-13 14:42:27.319836
181	48	Ticket Approved	Ticket #181 has been approved and is ready for assignment	f	2026-01-13 22:35:39.046216
182	48	Ticket Approved	Ticket #184 has been approved and is ready for assignment	f	2026-01-14 11:45:57.83451
183	48	Ticket Approved	Ticket #185 has been approved and is ready for assignment	f	2026-01-14 11:46:01.576395
184	48	Ticket Approved	Ticket #191 has been approved and is ready for assignment	f	2026-01-14 12:31:53.594527
185	48	Ticket Approved	Ticket #187 has been approved and is ready for assignment	f	2026-01-14 12:38:56.938686
186	48	Ticket Approved	Ticket #192 has been approved and is ready for assignment	f	2026-01-14 12:39:26.331451
187	48	New Ticket Assigned	Ticket #183 has been assigned to you	f	2026-01-14 13:21:42.403688
188	50	New Ticket Assigned	Ticket #192 has been assigned to you	f	2026-01-14 13:40:27.590151
189	50	New Ticket Assigned	Ticket #191 has been assigned to you	f	2026-01-14 15:33:27.694376
190	48	New Ticket Assigned	Ticket #190 has been assigned to you	f	2026-01-14 15:34:50.434457
191	50	New Ticket Assigned	Ticket #188 has been assigned to you	f	2026-01-15 11:28:11.643343
192	50	New Ticket Assigned	Ticket #187 has been assigned to you	f	2026-01-15 11:30:03.997699
193	48	New Ticket Assigned	Ticket #196 has been assigned to you	f	2026-01-15 11:42:22.493838
194	50	New Ticket Assigned	Ticket #185 has been assigned to you	f	2026-01-15 11:42:40.79405
195	48	New Ticket Assigned	Ticket #184 has been assigned to you	f	2026-01-15 11:46:21.179972
196	50	New Ticket Assigned	Ticket #173 has been assigned to you	f	2026-01-15 11:46:26.264651
197	48	New Ticket Assigned	Ticket #170 has been assigned to you	f	2026-01-15 11:46:33.23613
198	50	New Ticket Assigned	Ticket #168 has been assigned to you	f	2026-01-15 11:46:36.206768
199	48	Ticket Approved	Ticket #197 has been approved and is ready for assignment	f	2026-01-15 12:16:45.814107
200	48	New Ticket Assigned	Ticket #197 has been assigned to you	f	2026-01-15 12:17:12.113816
201	50	New Ticket Assigned	Ticket #198 has been assigned to you	f	2026-01-15 13:03:24.584808
202	66	Ticket Approved	Ticket #201 has been approved and is ready for assignment	f	2026-01-15 21:56:31.603893
203	73	New Ticket Assigned	Ticket #201 has been assigned to you	f	2026-01-15 22:12:07.936955
204	66	Ticket Approved	Ticket #202 has been approved and is ready for assignment	f	2026-01-15 22:19:41.558802
205	73	New Ticket Assigned	Ticket #202 has been assigned to you	f	2026-01-15 22:20:14.951258
206	78	Ticket Approved	Ticket #204 has been approved and is ready for assignment	f	2026-01-16 15:24:35.991558
207	10	Ticket Approved	Ticket #206 has been approved and is ready for assignment	f	2026-01-19 16:32:45.907375
208	11	New Ticket Assigned	Ticket #206 has been assigned to you	f	2026-03-11 09:26:57.089975
209	10	Ticket Approved	Ticket #208 has been approved and is ready for assignment	f	2026-03-11 09:32:32.19896
210	10	New Ticket Assigned	Ticket #208 has been assigned to you	f	2026-03-11 09:33:25.543528
211	11	New Ticket Assigned	Ticket #45 has been assigned to you	f	2026-03-11 09:33:35.001103
212	11	New Ticket Assigned	Ticket #44 has been assigned to you	f	2026-03-11 09:33:43.848359
\.


--
-- TOC entry 4999 (class 0 OID 33767)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, role_name) FROM stdin;
1	customer
2	agent
3	admin
\.


--
-- TOC entry 5001 (class 0 OID 33771)
-- Dependencies: 222
-- Data for Name: ticket_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_attachments (id, ticket_id, file_name, file_type, file_path, uploaded_at, uploaded_by) FROM stdin;
1	108	1 2.png	\N	uploads\\1767722366890-1 2.png	2026-01-06 23:29:27.56986	55
2	108	2 2.png	\N	uploads\\1767722366891-2 2.png	2026-01-06 23:29:27.612331	55
3	113	1 2.png	\N	uploads\\1767764571481-1 2.png	2026-01-07 11:12:52.069051	55
4	113	2 2.png	\N	uploads\\1767764571489-2 2.png	2026-01-07 11:12:52.131028	55
5	118	1 2.png	\N	uploads\\1767777209463-1 2.png	2026-01-07 14:43:30.373266	55
6	118	2 2.png	\N	uploads\\1767777209471-2 2.png	2026-01-07 14:43:30.448854	55
7	119	1 2.png	\N	uploads\\1767777239641-1 2.png	2026-01-07 14:44:00.30232	55
8	119	2 2.png	\N	uploads\\1767777239641-2 2.png	2026-01-07 14:44:00.316575	55
9	120	1 2.png	\N	uploads\\1767777250899-1 2.png	2026-01-07 14:44:11.384371	55
10	120	2 2.png	\N	uploads\\1767777250900-2 2.png	2026-01-07 14:44:11.397658	55
11	128	1 2.png	\N	uploads\\1767943548595-1 2.png	2026-01-09 12:55:48.890084	55
12	128	2 2.png	\N	uploads\\1767943548612-2 2.png	2026-01-09 12:55:48.955033	55
13	129	2.jpg	\N	uploads\\1767943719444-2.jpg	2026-01-09 12:58:40.170855	55
14	130	2.png	\N	uploads\\1767944860214-2.png	2026-01-09 13:17:40.836224	55
15	136	1 2.png	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768195659054_1%202.png	2026-01-12 10:57:41.34188	55
16	136	2 2.png	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768195659484_2%202.png	2026-01-12 10:57:41.404455	55
17	137	1.jpg	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768198675348_1.jpg	2026-01-12 11:47:56.105538	55
18	138	1.jpg	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768201358059_1.jpg	2026-01-12 12:32:39.149895	55
19	139	sap career .png	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768203408233_sap%20career%20.png	2026-01-12 13:06:49.659857	55
20	140	Think SAP = Coding.pdf	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768204378715_Think%20SAP%20%3D%20Coding.pdf	2026-01-12 13:23:00.24863	55
21	141	sap career .png	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768204947491_sap%20career%20.png	2026-01-12 13:32:28.855087	55
22	142	sap career .png	\N	https://ticket-management-app.s3.ap-southeast-1.amazonaws.com/tickets/1768206401942_sap%20career%20.png	2026-01-12 13:56:43.11189	55
23	143	1 2.png	\N	tickets/1768206446613_1 2.png	2026-01-12 13:57:29.304413	55
24	143	2 2.png	\N	tickets/1768206447105_2 2.png	2026-01-12 13:57:29.405537	55
25	144	1 2.png	\N	tickets/1768209846015_1 2.png	2026-01-12 14:54:08.776501	55
26	144	2 2.png	\N	tickets/1768209846497_2 2.png	2026-01-12 14:54:08.839638	55
27	145	1 2.png	\N	tickets/1768210430336_1_2.png	2026-01-12 15:03:53.097343	55
28	145	2 2.png	\N	tickets/1768210430770_2_2.png	2026-01-12 15:03:53.184806	55
29	146	agthia.jfif	\N	tickets/1768215086714_agthia.jfif	2026-01-12 16:21:27.51153	55
30	147	agthia-group.jpg	\N	tickets/1768215912994_agthia-group.jpg	2026-01-12 16:35:13.761118	55
31	148	2.png	\N	tickets/1768216024126_2.png	2026-01-12 16:37:05.540836	55
32	149	2.png	\N	tickets/1768216025742_2.png	2026-01-12 16:37:06.164449	55
33	160	sap career .png	\N	tickets/1768287343302_sap_career_.png	2026-01-13 12:25:44.846852	55
34	162	sap career .png	\N	tickets/1768287580805_sap_career_.png	2026-01-13 12:29:42.745964	55
35	184	2.png	\N	tickets/1768370712816_2.png	2026-01-14 11:35:13.668845	55
36	185	1.png	\N	tickets/1768370893894_1.png	2026-01-14 11:38:16.793972	60
37	186	2.png	\N	tickets/1768371019803_2.png	2026-01-14 11:40:23.633918	60
38	188	1.jpg	\N	tickets/1768371602049_1.jpg	2026-01-14 11:50:04.54989	50
39	189	1.jpg	\N	tickets/1768371643228_1.jpg	2026-01-14 11:50:46.260313	50
40	190	2.jpg	\N	tickets/1768371890712_2.jpg	2026-01-14 11:54:53.413223	48
41	196	1.png	\N	tickets/1768456938889_1.png	2026-01-15 11:32:20.253385	48
42	197	1.png	\N	tickets/1768459575659_1.png	2026-01-15 12:16:16.709467	60
43	198	1.png	\N	tickets/1768461592056_1.png	2026-01-15 12:49:54.283771	48
44	201	sap career .png	\N	tickets/1768494205906_sap_career_.png	2026-01-15 21:53:26.764712	70
45	204	sap career .png	\N	tickets/1768556832132_sap_career_.png	2026-01-16 15:17:13.38449	82
46	205	sap career .png	\N	tickets/1768556853877_sap_career_.png	2026-01-16 15:17:35.102433	82
\.


--
-- TOC entry 5003 (class 0 OID 33778)
-- Dependencies: 224
-- Data for Name: ticket_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_comments (id, ticket_id, commented_by, comment_subject, comment_text, commented_role, created_at) FROM stdin;
1	120	50	Work Started	I have started working on this issue. Will update soon.	agent	2026-01-08 13:51:28.920155
2	120	48	Please prioritize this ticket	This issue is critical. Please resolve it at the earliest.	delivery_lead	2026-01-08 15:04:51.355814
3	120	55	Need quick update	Please let me know the progress on this issue.	customer	2026-01-08 15:18:28.797118
4	123	50	wwewe	erere	agent	2026-01-08 16:13:39.070582
5	120	50	dffd	fdfdf	agent	2026-01-08 16:13:50.19977
6	117	50	ddd	ddd	agent	2026-01-08 16:21:25.649758
7	123	50	Testing	testing	agent	2026-01-08 17:42:14.498298
8	123	50	heading	testing	agent	2026-01-08 17:45:01.903142
9	123	50	hi	hiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiiihiiiiiiiiiiiiiiiiiiiiiiii	agent	2026-01-08 17:51:50.710861
10	125	55	ER	RER	customer	2026-01-08 18:15:48.560744
11	104	48	tt	hh	delivery_lead	2026-01-09 11:01:58.204814
12	130	55	hh	hvyvyvy	customer	2026-01-09 13:17:56.35159
13	137	55	test	hello	customer	2026-01-12 11:48:38.048189
\.


--
-- TOC entry 5005 (class 0 OID 33785)
-- Dependencies: 226
-- Data for Name: ticket_status_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket_status_logs (id, ticket_id, old_status, new_status, changed_by, changed_at) FROM stdin;
8	30	Open	Assigned	11	2025-12-29 16:54:43.08045
9	32	\N	InProgress	11	2025-12-29 17:29:16.203465
10	33	Open	Assigned	11	2025-12-30 10:46:46.937428
11	34	Open	Assigned	11	2025-12-30 10:56:43.347582
12	35	Open	Assigned	11	2025-12-30 11:37:41.891295
13	76	\N	requirements	50	2026-01-03 22:31:51.385365
14	76	\N	developments	50	2026-01-03 22:32:44.502142
15	76	\N	close	50	2026-01-03 22:33:26.002305
16	76	\N	developments	50	2026-01-03 22:33:55.806566
17	76	\N	developments	50	2026-01-03 22:45:38.518175
18	76	\N	close	50	2026-01-03 22:45:52.417271
19	76	\N	developments	50	2026-01-03 22:46:13.305053
20	76	\N	close	50	2026-01-03 22:54:38.934694
21	76	\N	developments	50	2026-01-03 22:55:43.267947
22	76	\N	close	50	2026-01-03 23:04:39.406666
23	76	\N	developments	50	2026-01-03 23:19:21.436813
24	76	\N	close	50	2026-01-03 23:19:31.141272
25	76	\N	developments	50	2026-01-04 08:57:33.5583
26	76	\N	Uat	50	2026-01-04 09:49:26.375439
27	76	\N	Development	50	2026-01-04 09:49:46.125832
28	76	\N	Uat	50	2026-01-04 09:50:27.895388
29	76	\N	Requirements	50	2026-01-04 09:51:12.187763
30	76	\N	Assigned	50	2026-01-04 09:56:37.882988
31	76	\N	Uat	50	2026-01-04 09:57:21.630079
32	76	\N	Uat	50	2026-01-04 10:04:18.953602
33	76	\N	Development	50	2026-01-04 10:04:34.790036
34	76	\N	Development	50	2026-01-04 10:05:19.647392
35	76	\N	Requirements	50	2026-01-04 10:05:32.83458
\.


--
-- TOC entry 5007 (class 0 OID 33790)
-- Dependencies: 228
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (id, requester, contact_email, contact_phone, subject, description, category, status, priority, assignee_id, account_name, due_date, sla_hours, resolution, created_at, updated_at, escalated_to, escalation_reason, delivery_lead_id, approval_status, approved_by, approved_at, assigned_by, assigned_at, rejection_reason, sub_category, type, environment, rca, comment, waiting_for_customer, requester_id, customer_id, created_for) FROM stdin;
198	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create New one	test	Product	Assigned	3	50	abhinav1234	\N	24	\N	2026-01-15 12:49:54.141181	2026-01-15 13:03:24.299701	\N	\N	48	Approved	48	2026-01-15 12:49:54.239	48	2026-01-15 13:03:24.299701	\N	Vendor Portal	Query	QA	\N	\N	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
173	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	abhinav1234	2026-01-08	24	\N	2026-01-13 15:38:48.909834	2026-01-15 11:46:25.909221	\N	\N	48	Approved	48	2026-01-13 15:38:47.386	48	2026-01-15 11:46:25.909221	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
158	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 09:48:15.495956	2026-01-13 09:48:15.495956	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
91	John Doe	john@test.com	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 16:27:33.722175	2026-01-05 16:27:33.722175	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	\N	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	\N
192	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:32:10.413258	2026-01-14 13:40:27.273048	\N	\N	48	Approved	60	2026-01-14 12:39:26.191349	48	2026-01-14 13:40:27.273048	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
92	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:09:42.28507	2026-01-05 17:09:42.28507	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
128	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:55:48.743601	2026-01-09 12:55:48.743601	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
98	sanju nishad	sanju.nishad@orane.in	1234567890	New Request	test	Product	Requirements	3	50	sanju1234	\N	24	Not Given Yet	2026-01-05 19:55:17.376549	2026-01-09 17:59:29.258125	\N	\N	48	Approved	60	2026-01-05 19:55:30.60249	48	2026-01-05 19:56:00.351556	\N	Customer Portal	Query	QA	12	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
106	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:08:19.654172	2026-01-06 23:08:19.654172	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
112	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:12:20.863684	2026-01-07 11:12:20.863684	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
133	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:26:42.425491	2026-01-12 09:26:42.425491	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
148	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:05.231559	2026-01-13 12:26:29.882215	\N	\N	48	Approved	60	2026-01-13 12:26:07.445298	50	2026-01-13 12:26:29.882215	\N	Vendor Portal	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
199	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:04:48.077834	2026-01-15 15:04:48.077834	\N	\N	48	Approved	48	2026-01-15 15:04:48.198	\N	\N	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
159	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 10:34:46.794855	2026-01-13 10:34:46.794855	\N	\N	48	Approved	48	2026-01-13 10:34:45.599	\N	\N	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
183	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	48	deepak1234	2026-01-08	24	\N	2026-01-14 11:16:04.037658	2026-01-14 13:21:41.987197	\N	\N	48	Approved	50	2026-01-14 11:16:03.803	48	2026-01-14 13:21:41.987197	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
182	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 22:58:36.980542	2026-01-13 23:36:57.005348	\N	\N	48	Approved	50	2026-01-13 22:58:36.854	50	2026-01-13 23:36:57.005348	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
200	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:09:01.824884	2026-01-15 15:09:01.824884	\N	\N	48	Approved	48	2026-01-15 15:09:01.943	\N	\N	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
155	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-12 22:48:17.737053	2026-01-12 22:48:17.737053	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
195	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-15 09:42:15.286739	2026-01-15 10:07:07.228433	\N	\N	48	Approved	50	2026-01-15 09:42:14.949	50	2026-01-15 10:07:07.228433	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
57	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:56.977752	2025-12-31 13:23:38.828342	\N	\N	48	Approved	51	2025-12-31 13:23:38.828342	\N	\N	\N	Other	Incident	QA	\N	\N	f	57	98041a70-66f1-4a71-9fbc-c82196c957ae	57
60	atharrv	atharrv1@gmail.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	50	Atharrv1234	\N	24	\N	2025-12-31 13:33:06.35065	2026-01-02 12:15:34.128891	\N	\N	48	Approved	51	2025-12-31 13:42:21.906216	48	2026-01-02 12:15:34.128891	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	57
185	Anjali sharma	anjali.sharma@orane.in	88888888568	Manager create	test	SAP	Assigned	1	50	Anjali1234	\N	6	\N	2026-01-14 11:38:16.508631	2026-01-15 11:42:40.746728	\N	\N	48	Approved	60	2026-01-14 11:46:01.445635	48	2026-01-15 11:42:40.746728	\N	MM	Incident	QA	\N	\N	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
187	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 11:43:16.403544	2026-01-15 11:30:03.276932	\N	\N	48	Approved	60	2026-01-14 12:38:56.728709	48	2026-01-15 11:30:03.276932	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
153	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:45:54.545774	2026-01-12 22:45:54.545774	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
154	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:46:05.742992	2026-01-12 22:46:05.742992	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
174	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:14:38.539112	2026-01-13 16:14:38.539112	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
178	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 21:53:57.726702	2026-01-13 21:54:59.020754	\N	\N	\N	Approved	60	2026-01-13 21:54:59.020754	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
175	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:18:43.050048	2026-01-13 16:18:43.050048	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
179	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:10:58.160891	2026-01-13 22:11:30.761033	\N	\N	\N	Approved	60	2026-01-13 22:11:30.761033	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
186	Anjali sharma	anjali.sharma@orane.in	88888888568	Manger Create	test	SAP	Closed	1	\N	Anjali1234	\N	6	\N	2026-01-14 11:40:23.403466	2026-01-14 11:46:23.38354	\N	\N	48	Rejected	60	2026-01-14 11:46:23.38354	\N	\N	By  Mistake cretea	MM	Incident	PRD	\N	\N	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
176	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:19:43.646216	2026-01-13 16:31:17.343841	\N	\N	\N	Approved	60	2026-01-13 16:31:17.343841	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
180	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:21:33.606472	2026-01-13 22:22:24.235218	\N	\N	\N	Approved	60	2026-01-13 22:22:24.235218	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
181	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-13 22:34:46.335788	2026-01-13 22:39:23.538101	\N	\N	48	Approved	60	2026-01-13 22:35:38.938343	50	2026-01-13 22:39:23.538101	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
193	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-14 12:33:00.846297	2026-01-14 12:35:20.892705	\N	\N	48	Rejected	60	2026-01-14 12:35:20.892705	\N	\N	hh	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
177	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:25:21.920511	2026-01-13 16:25:21.920511	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
196	abhinav jain	abhinav.jain@orane.in	8888888888	DL ticket	test	Product	Development	1	48	abhinav1234	\N	6	\N	2026-01-15 11:32:19.87505	2026-01-15 18:47:02.66391	\N	\N	48	Approved	48	2026-01-15 11:32:19.871	48	2026-01-15 11:42:22.213544	\N	Customer Portal	Incident	QA	asdfgghhhjhhj	\N	t	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
190	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create	Test	SAP	Assigned	2	48	abhinav1234	\N	12	\N	2026-01-14 11:54:53.284868	2026-01-14 15:34:50.058291	\N	\N	48	Approved	48	2026-01-14 11:54:52.018	48	2026-01-14 15:34:50.058291	\N	MM	Query	PRD	\N	\N	f	48	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	48
188	deepak sahani	deepak.sahani@orane.in	8888888888	Agent Create	test	SAP	Assigned	2	50	deepak1234	\N	12	\N	2026-01-14 11:50:04.164809	2026-01-15 11:28:11.377764	\N	\N	48	Approved	50	2026-01-14 11:50:02.89	48	2026-01-15 11:28:11.377764	\N	MM	Incident	PRD	\N	\N	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
156	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 22:52:22.297316	2026-01-12 22:52:22.297316	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
151	anjali sharma	anjali.shara@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:55:42.575596	2026-01-12 16:55:42.575596	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	\N
172	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 15:33:05.833576	2026-01-13 15:35:08.858021	\N	\N	48	Approved	50	2026-01-13 15:33:04.315	50	2026-01-13 15:35:08.858021	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
157	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 23:08:43.498122	2026-01-12 23:08:43.498122	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
189	deepak sahani	deepak.sahani@orane.in	8888888888	AgentCreate1	test	SAP	Assigned	1	50	deepak1234	\N	6	\N	2026-01-14 11:50:46.145128	2026-01-14 11:50:53.200156	\N	\N	48	Approved	50	2026-01-14 11:50:44.873	50	2026-01-14 11:50:53.200156	\N	MM	Incident	PRD	\N	\N	f	50	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	50
191	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:31:30.867104	2026-01-14 15:33:27.210345	\N	\N	48	Approved	60	2026-01-14 12:31:53.58027	48	2026-01-14 15:33:27.210345	\N	MM	Incident	PRD	\N	test	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
150	anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:53:48.11002	2026-01-12 16:53:48.11002	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	60
122	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 15:00:13.273164	2026-01-08 12:13:09.262065	\N	\N	48	Rejected	60	2026-01-08 12:13:09.262065	\N	\N	not A VALID TICKET	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
127	sanju nishad	sanju.nishad@orane.in	8888888888	test	att	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:05:00.765178	2026-01-09 12:05:00.765178	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
132	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:19:32.171479	2026-01-12 09:19:32.171479	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
137	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	SAP	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 11:47:56.063995	2026-01-12 12:13:34.746801	\N	\N	48	Approved	60	2026-01-12 11:49:15.806439	50	2026-01-12 12:13:34.746801	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
97	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 19:47:28.538363	2026-01-05 19:47:28.538363	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	QA	12345	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
105	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	\N	sanju1234	\N	24	\N	2026-01-06 19:41:14.006249	2026-01-06 19:41:25.96097	\N	\N	48	Rejected	60	2026-01-06 19:41:25.96097	\N	\N	This issue is outside the scope of support	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
110	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:03.309853	2026-01-07 11:02:03.309853	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
111	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:09.679803	2026-01-07 11:02:09.679803	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
116	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.465234	2026-01-07 11:47:18.465234	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
142	sanju nishad	sanju.nishad@orane.in	8888888888	wertyuio	wertyujk	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:56:42.842421	2026-01-12 13:56:42.842421	\N	\N	48	Pending	\N	\N	\N	\N	\N	General	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
147	sanju nishad	sanju.nishad@orane.in	8888888888	test	new Query	SAP	Open	1	\N	sanju1234	\N	6	\N	2026-01-12 16:35:13.50732	2026-01-12 16:35:39.529036	\N	\N	48	Approved	60	2026-01-12 16:35:39.529036	\N	\N	\N	MM	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
163	sanju nishad	sanju.nishad@orane.in	8888888888	yesssss	yes	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:53:51.08648	2026-01-13 12:53:51.08648	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
58	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:59.314104	2025-12-31 13:19:59.314104	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	57	98041a70-66f1-4a71-9fbc-c82196c957ae	57
94	sanju nishad	sanju.nisa@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:23.48991	2026-01-05 17:10:23.48991	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	\N
93	sanju nishad	sanju.nisad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:14.456445	2026-01-05 17:10:14.456445	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	0de6f11f-528f-4a87-b2c8-f0c9297f3a7c	\N
164	sanju nishad	sanju.nishad@orane.in	8888888888	check	check	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:59:00.822753	2026-01-13 12:59:00.822753	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
197	Anjali sharma	anjali.sharma@orane.in	88888888568	Mananer Ticket	test	SAP	Requirements	1	48	Anjali1234	\N	6	\N	2026-01-15 12:16:16.582781	2026-01-15 14:45:42.041272	\N	\N	48	Approved	60	2026-01-15 12:16:45.72467	48	2026-01-15 12:17:12.048393	\N	MM	Incident	PRD	\N	\N	f	60	98041a70-66f1-4a71-9fbc-c82196c957ae	60
203	sanju nishad	sanju.nishad@orane.in	8888888888	tyes	wertyuj	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-16 12:55:58.054471	2026-01-16 12:55:58.054471	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
168	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	sanju1234	2026-01-08	24	\N	2026-01-13 13:39:49.308156	2026-01-15 11:46:36.034821	\N	\N	48	Approved	60	2026-01-13 13:41:28.716517	48	2026-01-15 11:46:36.034821	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
51	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.941159	2025-12-31 12:51:40.794503	\N	\N	48	Approved	51	2025-12-31 12:51:40.794503	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
52	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.899229	2025-12-31 13:20:39.481164	\N	\N	48	Rejected	51	2025-12-31 13:20:39.481164	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
47	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:46:43.444645	2025-12-31 12:50:02.67343	\N	\N	48	Approved	51	2025-12-31 12:48:25.144042	48	2025-12-31 12:50:02.67343	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
138	sanju nishad	sanju.nishad@orane.in	8888888888	test	tes	Integration	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 12:32:38.771931	2026-01-12 12:38:42.413274	\N	\N	48	Approved	60	2026-01-12 12:38:24.489023	50	2026-01-12 12:38:42.413274	\N	Middleware	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
143	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Assigned	2	50	sanju1234	\N	12	\N	2026-01-12 13:57:29.151813	2026-01-12 16:00:37.945822	\N	\N	48	Approved	60	2026-01-12 15:59:51.965223	48	2026-01-12 16:00:37.945822	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
123	sanju nishad	sanju.nishad@orane.in	1234567890	test	new one	Product	Assigned	2	50	sanju1234	\N	12	\N	2026-01-07 15:39:42.318433	2026-01-08 11:24:07.836422	\N	\N	48	Approved	60	2026-01-08 11:09:29.322757	48	2026-01-08 11:10:06.678035	\N	Customer Portal	Change	QA	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
117	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	testing it	SAP	Assigned	3	50	sanju1234	\N	24	\N	2026-01-07 14:34:43.204998	2026-01-09 11:57:12.796418	\N	\N	48	Approved	60	2026-01-07 14:38:48.698903	50	2026-01-08 11:37:01.963675	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
169	sanju nishad	sanju.nishad@orane.in	8888888888	ertyy	ertyu	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 13:44:37.67372	2026-01-13 13:44:37.67372	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Problem	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
149	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:06.157775	2026-01-12 16:39:04.201115	\N	\N	48	Approved	60	2026-01-12 16:38:49.26123	50	2026-01-12 16:39:04.201115	\N	Vendor Portal	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
49	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:51:02.963897	2026-01-05 15:34:24.053215	\N	\N	48	Approved	51	2025-12-31 13:11:37.860431	48	2026-01-05 15:34:24.053215	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
50	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.888881	2025-12-31 12:51:42.880361	\N	\N	48	Approved	51	2025-12-31 12:51:42.880361	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
48	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:00.572047	2025-12-31 13:12:02.842423	\N	\N	48	Rejected	51	2025-12-31 13:12:02.842423	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
53	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.990854	2025-12-31 13:12:53.990854	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
54	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.001528	2025-12-31 13:12:54.001528	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
56	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:13:00.118354	2025-12-31 13:20:44.87405	\N	\N	48	Approved	51	2025-12-31 13:20:44.87405	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.08963	2025-12-31 13:24:38.379048	\N	\N	48	Approved	51	2025-12-31 13:24:38.379048	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
65	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:05:53.649478	2026-01-02 13:13:04.445316	\N	\N	48	Approved	60	2026-01-02 13:13:04.445316	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
64	sanju nishad	sanju.nishad@orane.in	1234567890	test	testr	Other	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:03:48.408776	2026-01-02 11:03:48.408776	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
99	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-06 10:29:42.526867	2026-01-06 10:29:42.526867	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
107	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:09:27.216569	2026-01-06 23:09:27.216569	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
113	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 11:12:51.936049	2026-01-07 11:12:51.936049	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
118	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:43:30.09533	2026-01-07 14:43:30.09533	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
124	sanju nishad	sanju.nishad@orane.in	\N	Query	New Query	Product	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-08 16:35:25.675679	2026-01-08 16:35:25.675679	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
129	sanju nishad	sanju.nishad@orane.in	8888888888	test	AA	SAP	Unassigned	4	\N	sanju1234	\N	48	\N	2026-01-09 12:58:40.059323	2026-01-09 12:58:40.059323	\N	\N	48	Pending	\N	\N	\N	\N	\N	FI	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
134	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:31:19.690802	2026-01-12 09:31:19.690802	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
139	sanju nishad	sanju.nishad@orane.in	8888888888	dfghj	sdfghj	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:06:49.377642	2026-01-12 13:06:49.377642	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
144	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 14:54:08.513067	2026-01-12 14:54:08.513067	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
160	sanju nishad	sanju.nishad@orane.in	8888888888	y	y	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:25:44.214634	2026-01-13 12:25:44.214634	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Problem	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
165	sanju nishad	sanju.nishad@orane.in	8888888888	yesss	noooooo	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:14:27.180094	2026-01-13 13:14:27.180094	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Query	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
100	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 10:30:31.21657	2026-01-09 12:08:05.501549	\N	\N	48	Approved	60	2026-01-06 10:31:40.640992	48	2026-01-06 10:33:01.924134	\N	MM	Incident	PRD	sdfg	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
166	sanju nishad	sanju.nishad@orane.in	8888888888	qwerty	qwerty	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:22:35.973777	2026-01-13 13:22:35.973777	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
171	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 15:29:03.21955	2026-01-13 15:29:03.21955	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
108	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:29:27.445089	2026-01-06 23:29:27.445089	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
114	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.354419	2026-01-07 11:47:18.354419	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
119	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:44:00.271775	2026-01-07 14:44:00.271775	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
125	sanju nishad	sanju.nishad@orane.in	8888888888	New Request	qUERY	Integration	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-08 16:38:43.653562	2026-01-08 16:38:43.653562	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
130	sanju nishad	sanju.nishad@orane.in	8888888888	g	h	Product	UAT	2	50	sanju1234	\N	12	wertyju	2026-01-09 13:17:40.656698	2026-01-09 16:28:37.325148	\N	\N	48	Approved	60	2026-01-09 13:19:15.672433	48	2026-01-09 13:23:36.964438	\N	Vendor Portal	Query	PRD	sdfg	\N	t	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
95	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:20:24.319367	2026-01-05 17:20:24.319367	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
135	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:32:11.745983	2026-01-12 09:32:11.745983	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
120	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Internal Testing	2	50	sanju1234	\N	12	\N	2026-01-07 14:44:11.3464	2026-01-09 11:16:06.327179	\N	\N	48	Approved	60	2026-01-08 12:24:46.320592	48	2026-01-08 12:26:33.818308	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
184	sanju nishad	sanju.nishad@orane.in	8888888888	customer create	test	SAP	Assigned	1	48	sanju1234	\N	6	\N	2026-01-14 11:35:13.562013	2026-01-15 11:46:21.018885	\N	\N	48	Approved	60	2026-01-14 11:45:57.283776	48	2026-01-15 11:46:21.018885	\N	SD	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
140	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	qwertyuiolkjhgfdsvbnm	Other	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:23:00.186726	2026-01-12 13:23:00.186726	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
145	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 15:03:52.908269	2026-01-12 15:03:52.908269	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
161	sanju nishad	sanju.nishad@orane.in	8888888888	s13 jan	13 jan	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:27:57.314646	2026-01-13 12:27:57.314646	\N	\N	48	\N	\N	\N	\N	\N	\N	Tax	Problem	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
96	sanju nishad	sanju.nishad@orane.in	\N	test	\N	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-05 18:31:20.106952	2026-01-05 18:31:20.106952	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	1211	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
102	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 11:55:53.967482	2026-01-09 12:19:53.729089	\N	\N	48	Approved	60	2026-01-06 11:56:12.729252	48	2026-01-06 11:57:06.261186	\N	MM	Incident	PRD	sdfg	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
103	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:55.470186	2026-01-06 11:56:15.79845	\N	\N	48	Approved	60	2026-01-06 11:56:15.79845	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
126	sanju nishad	sanju.nishad@orane.in	8888888888	test	attachment testing	SAP	UAT	1	50	sanju1234	\N	6	\N	2026-01-09 11:57:04.407593	2026-01-09 16:42:59.345552	\N	\N	48	Approved	60	2026-01-09 11:57:35.233734	48	2026-01-09 11:58:10.525091	\N	SD	Incident	QA	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
101	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	Updated VPN profile and verified successful connection	2026-01-06 11:55:52.298684	2026-01-06 15:16:05.534677	\N	\N	48	Approved	60	2026-01-06 11:56:09.745197	48	2026-01-06 11:56:59.931083	\N	MM	Incident	PRD	VPN configuration mismatch on client machine	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
104	sanju nishad	sanju.nishad@orane.in	9999999999	test	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:56.859972	2026-01-06 15:27:42.16559	\N	\N	48	Approved	60	2026-01-06 11:56:18.647677	\N	\N	\N	MM	Incident	QA	Timeout misconfiguration	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
109	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 10:49:54.8426	2026-01-07 10:49:54.8426	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	QA	test	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
131	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-11 23:17:46.994539	2026-01-11 23:17:46.994539	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
115	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.355369	2026-01-07 11:47:18.355369	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
121	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 14:47:52.306779	2026-01-07 14:47:52.306779	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
136	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Open	2	\N	sanju1234	\N	12	\N	2026-01-12 10:57:41.207875	2026-01-12 12:16:30.658498	\N	\N	48	Approved	60	2026-01-12 12:16:30.658498	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
141	sanju nishad	sanju.nishad@orane.in	8888888888	cvbnm	g	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 13:32:28.625322	2026-01-12 13:32:28.625322	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
146	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	Other	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 16:21:27.137909	2026-01-12 16:21:27.137909	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
152	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 17:29:34.27529	2026-01-12 17:29:34.27529	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
162	sanju nishad	sanju.nishad@orane.in	8888888888	heloooooooooooooooooo	hrloooooo	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:29:42.28325	2026-01-13 12:29:42.28325	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
167	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 13:30:51.172176	2026-01-13 13:30:51.172176	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
170	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	wertyui	SAP	Assigned	2	48	sanju1234	\N	12	\N	2026-01-13 14:38:55.931411	2026-01-15 11:46:32.743134	\N	\N	48	Approved	60	2026-01-13 14:42:27.153575	48	2026-01-15 11:46:32.743134	\N	ABAP	Query	PRD	\N	\N	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
82	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-04 16:58:37.838458	2026-01-05 15:36:01.762808	\N	\N	48	Approved	60	2026-01-04 16:59:01.49311	50	2026-01-05 15:36:01.762808	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
80	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-04 10:17:59.928832	2026-01-04 10:38:44.060394	\N	\N	48	Approved	60	2026-01-04 10:19:18.019932	48	2026-01-04 10:23:17.797088	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
83	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:27.084042	2026-01-05 12:30:27.623922	\N	\N	48	Approved	60	2026-01-05 10:48:28.099492	48	2026-01-05 12:18:33.753639	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
74	rani	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-02 22:41:17.413184	2026-01-05 15:41:15.161541	\N	\N	48	Approved	60	2026-01-02 22:42:15.51574	48	2026-01-05 15:41:15.161541	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
84	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Development	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:29.633771	2026-01-05 13:03:47.101803	\N	\N	48	Approved	60	2026-01-05 10:48:34.966126	48	2026-01-05 12:30:51.878794	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
76	rahul	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Requirements	4	50	sanju1234	\N	48	\N	2026-01-02 23:00:33.900465	2026-01-04 10:05:32.724787	\N	\N	48	Approved	60	2026-01-02 23:01:06.489556	48	2026-01-02 23:20:12.114751	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
75	ramu	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:54:20.656182	2026-01-05 13:15:55.626247	\N	\N	48	Rejected	60	2026-01-05 13:15:55.626247	\N	\N	not a vali dticket\n	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
68	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	2	\N	sanju1234	\N	12	wertyju	2026-01-02 16:43:09.671855	2026-01-09 15:45:17.776362	\N	\N	48	Approved	60	2026-01-02 22:37:22.591191	\N	\N	\N	Other	Incident	QA	sdfg	\N	f	51	98041a70-66f1-4a71-9fbc-c82196c957ae	55
72	deepika singh	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 22:02:19.998104	2026-01-05 15:33:56.298654	\N	\N	48	Approved	60	2026-01-05 15:33:56.298654	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
62	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:41:26.355426	2025-12-31 16:44:48.183323	\N	\N	48	Rejected	51	2025-12-31 16:44:48.183323	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
61	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 15:45:18.433835	2025-12-31 15:58:12.147158	\N	\N	48	Rejected	51	2025-12-31 15:58:12.147158	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
59	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2025-12-31 13:32:01.673554	2025-12-31 13:32:01.673554	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
66	Sanju gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2026-01-02 11:12:07.92215	2026-01-02 12:56:52.427984	\N	\N	48	Approved	60	2026-01-02 12:56:52.427984	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
67	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2026-01-02 12:33:03.334657	2026-01-02 12:40:04.508884	\N	\N	48	Rejected	60	2026-01-02 12:40:04.508884	\N	\N	invalid ticket	Other	Incident	QA	\N	\N	f	51	98041a70-66f1-4a71-9fbc-c82196c957ae	55
69	deepak gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 18:18:05.565088	2026-01-05 15:41:01.267897	\N	\N	48	Approved	60	2026-01-05 15:41:01.267897	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
63	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:58:23.098513	2025-12-31 16:58:37.614448	\N	\N	48	Rejected	51	2025-12-31 16:58:37.614448	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
194	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-15 09:40:27.85422	2026-01-15 09:40:27.85422	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55	98041a70-66f1-4a71-9fbc-c82196c957ae	55
73	ravi	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:41:08.671346	2026-01-02 22:41:53.257898	\N	\N	48	Rejected	60	2026-01-02 22:41:53.257898	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
71	deepika gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 18:33:18.038516	2026-01-02 22:37:59.906785	\N	\N	48	Rejected	60	2026-01-02 22:37:59.906785	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
81	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-04 10:21:13.672492	2026-01-04 10:21:26.510159	\N	\N	48	Rejected	60	2026-01-04 10:21:26.510159	\N	\N	test	Other	Incident	QA	\N	\N	f	\N	98041a70-66f1-4a71-9fbc-c82196c957ae	55
201	BIBA	biba@gmail.com	88888888568	testing	testing	SAP	Assigned	2	73	biba1234	\N	12	\N	2026-01-15 21:53:26.641915	2026-01-15 22:12:07.648968	\N	\N	66	Approved	67	2026-01-15 21:56:31.476872	66	2026-01-15 22:12:07.648968	\N	MM	Incident	PRD	\N	\N	f	\N	07d1cafe-2185-44f1-bb1b-aa9b797876a0	70
202	BHARTIexcel	bharti@gmail.com	88888888568	dfghjk	ertyui	Integration	Assigned	3	73	bharti1234	\N	24	\N	2026-01-15 22:17:52.182678	2026-01-15 22:20:14.890914	\N	\N	66	Approved	68	2026-01-15 22:19:41.516402	66	2026-01-15 22:20:14.890914	\N	Middleware	Query	QA	\N	\N	f	\N	07d1cafe-2185-44f1-bb1b-aa9b797876a0	72
205	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Unassigned	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:34.957413	2026-01-16 15:17:34.957413	\N	\N	78	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82	07d1cafe-2185-44f1-bb1b-aa9b797876a0	82
204	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Open	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:13.009899	2026-01-16 15:24:35.819062	\N	\N	78	Approved	67	2026-01-16 15:24:35.819062	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82	07d1cafe-2185-44f1-bb1b-aa9b797876a0	82
36	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Open	High	\N	Akshay123	\N	10	\N	2025-12-30 11:53:55.695187	2025-12-30 11:53:55.695187	\N	\N	10	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
40	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:23:09.563793	2025-12-30 12:27:40.434067	\N	\N	10	Approved	8	2025-12-30 12:27:04.820988	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
43	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:12.414258	2025-12-31 11:19:12.414258	\N	\N	10	Approved	8	2025-12-31 11:19:44.758201	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
42	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-31 10:57:22.041972	2025-12-31 10:57:50.374756	\N	\N	10	Approved	8	2025-12-31 10:57:38.644988	10	2025-12-31 10:57:50.374756	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
35	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 11:37:02.546096	2025-12-30 11:37:02.546096	\N	\N	10	Approved	8	2025-12-30 11:37:23.006257	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
34	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	SAP	Assigned	High	11	Akshay123	\N	20	\N	2025-12-30 10:55:46.085437	2025-12-30 10:55:46.085437	\N	\N	10	Approved	8	2025-12-30 10:56:08.243435	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
33	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn. Thank you	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 17:10:20.208597	2025-12-29 20:04:49.996777	\N	\N	10	Approved	8	2025-12-29 17:10:33.343345	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
39	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:10.712114	2025-12-30 12:12:11.450548	\N	\N	10	Approved	8	2025-12-30 12:11:29.564526	10	2025-12-30 12:12:11.450548	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
38	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:08.016959	2025-12-30 12:11:54.448435	\N	\N	10	Approved	8	2025-12-30 12:11:24.492013	11	2025-12-30 12:11:54.448435	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
46	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	Akshay123	\N	24	\N	2025-12-31 12:06:32.526289	2025-12-31 12:08:53.959738	\N	\N	10	Rejected	8	2025-12-31 12:08:53.959738	\N	\N	Not a valid ticket	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
41	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:30:48.54955	2025-12-30 12:36:45.596897	\N	\N	10	Approved	8	2025-12-30 12:31:29.194391	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
30	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 13:23:20.144123	2025-12-29 13:23:20.144123	\N	\N	10	Approved	8	2025-12-29 13:38:20.835075	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
45	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Assigned	High	11	Akshay123	\N	10	\N	2025-12-31 11:19:17.049915	2026-03-11 09:33:34.993755	\N	\N	10	Approved	8	2025-12-31 11:19:40.41727	10	2026-03-11 09:33:34.993755	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
44	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Assigned	High	11	Akshay123	\N	10	\N	2025-12-31 11:19:14.95744	2026-03-11 09:33:43.83695	\N	\N	10	Approved	8	2025-12-31 11:19:42.459778	10	2026-03-11 09:33:43.83695	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
32	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Requirements	High	11	Akshay123	\N	24	\N	2025-12-29 17:07:41.807736	2025-12-29 17:29:16.064044	\N	\N	10	Approved	8	2025-12-29 17:07:55.829496	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
31	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 16:59:30.573771	2025-12-30 11:56:03.294571	\N	\N	10	Approved	8	2025-12-29 17:01:16.21216	\N	\N	\N	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
37	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Closed	High	\N	Akshay123	\N	10	\N	2025-12-30 11:54:05.837996	2026-01-19 16:39:21.886992	\N	\N	10	Rejected	8	2026-01-19 16:39:21.886992	\N	\N	I am rejecting your ticket	Other	Incident	QA	\N	\N	f	7	a16df7aa-305f-43b3-8de0-fcb1888cae98	7
207	Akshay tiwari	akshaytiwari@company.com	9998887776	ok	testing	SAP	Unassigned	3	\N	Akshay123	\N	24	\N	2026-03-11 09:26:03.620883	2026-03-11 09:26:03.620883	\N	\N	10	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	7	\N	\N
206	Akshay tiwari	akshaytiwari@company.com	9998887776	ok	ok	SAP	Assigned	1	11	Akshay123	\N	6	\N	2026-01-18 13:21:06.960669	2026-03-11 09:26:57.075606	\N	\N	10	Approved	8	2026-01-19 16:32:45.892904	10	2026-03-11 09:26:57.075606	\N	MM	Query	PRD	\N	\N	f	7	\N	\N
208	Akshay tiwari	akshaytiwari@company.com	9998887776	ok	ok	SAP	Assigned	1	10	Akshay123	\N	6	\N	2026-03-11 09:29:48.724388	2026-03-11 09:33:25.5325	\N	\N	10	Approved	8	2026-03-11 09:32:32.193812	10	2026-03-11 09:33:25.5325	\N	MM	Problem	PRD	\N	\N	f	7	\N	\N
\.


--
-- TOC entry 5008 (class 0 OID 33804)
-- Dependencies: 229
-- Data for Name: tickets_backup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets_backup (id, customer_id, requester, contact_email, contact_phone, subject, description, category, status, priority, assignee_id, account_name, due_date, sla_hours, resolution, created_at, updated_at, escalated_to, escalation_reason, delivery_lead_id, approval_status, approved_by, approved_at, assigned_by, assigned_at, rejection_reason, sub_category, type, environment, rca, comment, waiting_for_customer, requester_id) FROM stdin;
192	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:32:10.413258	2026-01-14 13:40:27.273048	\N	\N	48	Approved	60	2026-01-14 12:39:26.191349	48	2026-01-14 13:40:27.273048	\N	MM	Incident	PRD	\N	test	f	60
158	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 09:48:15.495956	2026-01-13 09:48:15.495956	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
31	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 16:59:30.573771	2025-12-30 11:56:03.294571	\N	\N	10	Approved	8	2025-12-29 17:01:16.21216	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
32	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Requirements	High	11	Akshay123	\N	24	\N	2025-12-29 17:07:41.807736	2025-12-29 17:29:16.064044	\N	\N	10	Approved	8	2025-12-29 17:07:55.829496	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
30	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 13:23:20.144123	2025-12-29 13:23:20.144123	\N	\N	10	Approved	8	2025-12-29 13:38:20.835075	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
173	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	abhinav1234	2026-01-08	24	\N	2026-01-13 15:38:48.909834	2026-01-15 11:46:25.909221	\N	\N	48	Approved	48	2026-01-13 15:38:47.386	48	2026-01-15 11:46:25.909221	\N	MM	Incident	PRD	\N	test	f	48
81	55	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-04 10:21:13.672492	2026-01-04 10:21:26.510159	\N	\N	48	Rejected	60	2026-01-04 10:21:26.510159	\N	\N	test	Other	Incident	QA	\N	\N	f	\N
71	55	deepika gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 18:33:18.038516	2026-01-02 22:37:59.906785	\N	\N	48	Rejected	60	2026-01-02 22:37:59.906785	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
73	55	ravi	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:41:08.671346	2026-01-02 22:41:53.257898	\N	\N	48	Rejected	60	2026-01-02 22:41:53.257898	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
198	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create New one	test	Product	Assigned	3	50	abhinav1234	\N	24	\N	2026-01-15 12:49:54.141181	2026-01-15 13:03:24.299701	\N	\N	48	Approved	48	2026-01-15 12:49:54.239	48	2026-01-15 13:03:24.299701	\N	Vendor Portal	Query	QA	\N	\N	f	48
204	82	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Open	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:13.009899	2026-01-16 15:24:35.819062	\N	\N	78	Approved	67	2026-01-16 15:24:35.819062	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82
91	55	John Doe	john@test.com	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 16:27:33.722175	2026-01-05 16:27:33.722175	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	\N
41	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:30:48.54955	2025-12-30 12:36:45.596897	\N	\N	10	Approved	8	2025-12-30 12:31:29.194391	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
194	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-15 09:40:27.85422	2026-01-15 09:40:27.85422	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
63	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:58:23.098513	2025-12-31 16:58:37.614448	\N	\N	48	Rejected	51	2025-12-31 16:58:37.614448	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
60	55	atharrv	atharrv1@gmail.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	50	Atharrv1234	\N	24	\N	2025-12-31 13:33:06.35065	2026-01-02 12:15:34.128891	\N	\N	48	Approved	51	2025-12-31 13:42:21.906216	48	2026-01-02 12:15:34.128891	\N	Other	Incident	QA	\N	\N	f	\N
182	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 22:58:36.980542	2026-01-13 23:36:57.005348	\N	\N	48	Approved	50	2026-01-13 22:58:36.854	50	2026-01-13 23:36:57.005348	\N	MM	Incident	PRD	\N	test	f	50
183	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	48	deepak1234	2026-01-08	24	\N	2026-01-14 11:16:04.037658	2026-01-14 13:21:41.987197	\N	\N	48	Approved	50	2026-01-14 11:16:03.803	48	2026-01-14 13:21:41.987197	\N	MM	Incident	PRD	\N	test	f	50
159	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 10:34:46.794855	2026-01-13 10:34:46.794855	\N	\N	48	Approved	48	2026-01-13 10:34:45.599	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
69	55	deepak gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 18:18:05.565088	2026-01-05 15:41:01.267897	\N	\N	48	Approved	60	2026-01-05 15:41:01.267897	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
46	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	Akshay123	\N	24	\N	2025-12-31 12:06:32.526289	2025-12-31 12:08:53.959738	\N	\N	10	Rejected	8	2025-12-31 12:08:53.959738	\N	\N	Not a valid ticket	Other	Incident	QA	\N	\N	f	7
38	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:08.016959	2025-12-30 12:11:54.448435	\N	\N	10	Approved	8	2025-12-30 12:11:24.492013	11	2025-12-30 12:11:54.448435	\N	Other	Incident	QA	\N	\N	f	7
39	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:10.712114	2025-12-30 12:12:11.450548	\N	\N	10	Approved	8	2025-12-30 12:11:29.564526	10	2025-12-30 12:12:11.450548	\N	Other	Incident	QA	\N	\N	f	7
33	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn. Thank you	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 17:10:20.208597	2025-12-29 20:04:49.996777	\N	\N	10	Approved	8	2025-12-29 17:10:33.343345	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
67	55	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2026-01-02 12:33:03.334657	2026-01-02 12:40:04.508884	\N	\N	48	Rejected	60	2026-01-02 12:40:04.508884	\N	\N	invalid ticket	Other	Incident	QA	\N	\N	f	51
66	55	Sanju gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2026-01-02 11:12:07.92215	2026-01-02 12:56:52.427984	\N	\N	48	Approved	60	2026-01-02 12:56:52.427984	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
199	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:04:48.077834	2026-01-15 15:04:48.077834	\N	\N	48	Approved	48	2026-01-15 15:04:48.198	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
205	82	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Unassigned	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:34.957413	2026-01-16 15:17:34.957413	\N	\N	78	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82
34	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	SAP	Assigned	High	11	Akshay123	\N	20	\N	2025-12-30 10:55:46.085437	2025-12-30 10:55:46.085437	\N	\N	10	Approved	8	2025-12-30 10:56:08.243435	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
57	57	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:56.977752	2025-12-31 13:23:38.828342	\N	\N	48	Approved	51	2025-12-31 13:23:38.828342	\N	\N	\N	Other	Incident	QA	\N	\N	f	57
155	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-12 22:48:17.737053	2026-01-12 22:48:17.737053	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
59	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2025-12-31 13:32:01.673554	2025-12-31 13:32:01.673554	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
61	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 15:45:18.433835	2025-12-31 15:58:12.147158	\N	\N	48	Rejected	51	2025-12-31 15:58:12.147158	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
62	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:41:26.355426	2025-12-31 16:44:48.183323	\N	\N	48	Rejected	51	2025-12-31 16:44:48.183323	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
35	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 11:37:02.546096	2025-12-30 11:37:02.546096	\N	\N	10	Approved	8	2025-12-30 11:37:23.006257	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
195	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-15 09:42:15.286739	2026-01-15 10:07:07.228433	\N	\N	48	Approved	50	2026-01-15 09:42:14.949	50	2026-01-15 10:07:07.228433	\N	MM	Incident	PRD	\N	test	f	50
200	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:09:01.824884	2026-01-15 15:09:01.824884	\N	\N	48	Approved	48	2026-01-15 15:09:01.943	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
150	60	anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:53:48.11002	2026-01-12 16:53:48.11002	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N
42	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-31 10:57:22.041972	2025-12-31 10:57:50.374756	\N	\N	10	Approved	8	2025-12-31 10:57:38.644988	10	2025-12-31 10:57:50.374756	\N	Other	Incident	QA	\N	\N	f	7
156	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 22:52:22.297316	2026-01-12 22:52:22.297316	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50
72	55	deepika singh	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 22:02:19.998104	2026-01-05 15:33:56.298654	\N	\N	48	Approved	60	2026-01-05 15:33:56.298654	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
190	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create	Test	SAP	Assigned	2	48	abhinav1234	\N	12	\N	2026-01-14 11:54:53.284868	2026-01-14 15:34:50.058291	\N	\N	48	Approved	48	2026-01-14 11:54:52.018	48	2026-01-14 15:34:50.058291	\N	MM	Query	PRD	\N	\N	f	48
68	55	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	2	\N	sanju1234	\N	12	wertyju	2026-01-02 16:43:09.671855	2026-01-09 15:45:17.776362	\N	\N	48	Approved	60	2026-01-02 22:37:22.591191	\N	\N	\N	Other	Incident	QA	sdfg	\N	f	51
75	55	ramu	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:54:20.656182	2026-01-05 13:15:55.626247	\N	\N	48	Rejected	60	2026-01-05 13:15:55.626247	\N	\N	not a vali dticket\n	Other	Incident	QA	\N	\N	f	\N
76	55	rahul	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Requirements	4	50	sanju1234	\N	48	\N	2026-01-02 23:00:33.900465	2026-01-04 10:05:32.724787	\N	\N	48	Approved	60	2026-01-02 23:01:06.489556	48	2026-01-02 23:20:12.114751	\N	Other	Incident	QA	\N	\N	f	\N
188	50	deepak sahani	deepak.sahani@orane.in	8888888888	Agent Create	test	SAP	Assigned	2	50	deepak1234	\N	12	\N	2026-01-14 11:50:04.164809	2026-01-15 11:28:11.377764	\N	\N	48	Approved	50	2026-01-14 11:50:02.89	48	2026-01-15 11:28:11.377764	\N	MM	Incident	PRD	\N	\N	f	50
196	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL ticket	test	Product	Development	1	48	abhinav1234	\N	6	\N	2026-01-15 11:32:19.87505	2026-01-15 18:47:02.66391	\N	\N	48	Approved	48	2026-01-15 11:32:19.871	48	2026-01-15 11:42:22.213544	\N	Customer Portal	Incident	QA	asdfgghhhjhhj	\N	t	48
201	70	BIBA	biba@gmail.com	88888888568	testing	testing	SAP	Assigned	2	73	biba1234	\N	12	\N	2026-01-15 21:53:26.641915	2026-01-15 22:12:07.648968	\N	\N	66	Approved	67	2026-01-15 21:56:31.476872	66	2026-01-15 22:12:07.648968	\N	MM	Incident	PRD	\N	\N	f	\N
84	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Development	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:29.633771	2026-01-05 13:03:47.101803	\N	\N	48	Approved	60	2026-01-05 10:48:34.966126	48	2026-01-05 12:30:51.878794	\N	Other	Incident	QA	\N	\N	f	\N
74	55	rani	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-02 22:41:17.413184	2026-01-05 15:41:15.161541	\N	\N	48	Approved	60	2026-01-02 22:42:15.51574	48	2026-01-05 15:41:15.161541	\N	Other	Incident	QA	\N	\N	f	\N
83	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:27.084042	2026-01-05 12:30:27.623922	\N	\N	48	Approved	60	2026-01-05 10:48:28.099492	48	2026-01-05 12:18:33.753639	\N	Other	Incident	QA	\N	\N	f	\N
80	55	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-04 10:17:59.928832	2026-01-04 10:38:44.060394	\N	\N	48	Approved	60	2026-01-04 10:19:18.019932	48	2026-01-04 10:23:17.797088	\N	Other	Incident	QA	\N	\N	f	\N
151	60	anjali sharma	anjali.shara@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:55:42.575596	2026-01-12 16:55:42.575596	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N
43	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:12.414258	2025-12-31 11:19:12.414258	\N	\N	10	Approved	8	2025-12-31 11:19:44.758201	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
189	50	deepak sahani	deepak.sahani@orane.in	8888888888	AgentCreate1	test	SAP	Assigned	1	50	deepak1234	\N	6	\N	2026-01-14 11:50:46.145128	2026-01-14 11:50:53.200156	\N	\N	48	Approved	50	2026-01-14 11:50:44.873	50	2026-01-14 11:50:53.200156	\N	MM	Incident	PRD	\N	\N	f	50
82	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-04 16:58:37.838458	2026-01-05 15:36:01.762808	\N	\N	48	Approved	60	2026-01-04 16:59:01.49311	50	2026-01-05 15:36:01.762808	\N	Other	Incident	QA	\N	\N	f	\N
157	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 23:08:43.498122	2026-01-12 23:08:43.498122	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50
172	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 15:33:05.833576	2026-01-13 15:35:08.858021	\N	\N	48	Approved	50	2026-01-13 15:33:04.315	50	2026-01-13 15:35:08.858021	\N	MM	Incident	PRD	\N	test	f	50
170	55	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	wertyui	SAP	Assigned	2	48	sanju1234	\N	12	\N	2026-01-13 14:38:55.931411	2026-01-15 11:46:32.743134	\N	\N	48	Approved	60	2026-01-13 14:42:27.153575	48	2026-01-15 11:46:32.743134	\N	ABAP	Query	PRD	\N	\N	f	55
202	72	BHARTIexcel	bharti@gmail.com	88888888568	dfghjk	ertyui	Integration	Assigned	3	73	bharti1234	\N	24	\N	2026-01-15 22:17:52.182678	2026-01-15 22:20:14.890914	\N	\N	66	Approved	68	2026-01-15 22:19:41.516402	66	2026-01-15 22:20:14.890914	\N	Middleware	Query	QA	\N	\N	f	\N
191	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:31:30.867104	2026-01-14 15:33:27.210345	\N	\N	48	Approved	60	2026-01-14 12:31:53.58027	48	2026-01-14 15:33:27.210345	\N	MM	Incident	PRD	\N	test	f	60
44	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:14.95744	2025-12-31 11:19:14.95744	\N	\N	10	Approved	8	2025-12-31 11:19:42.459778	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
45	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:17.049915	2025-12-31 11:19:17.049915	\N	\N	10	Approved	8	2025-12-31 11:19:40.41727	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
40	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:23:09.563793	2025-12-30 12:27:40.434067	\N	\N	10	Approved	8	2025-12-30 12:27:04.820988	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
37	7	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Open	High	\N	Akshay123	\N	10	\N	2025-12-30 11:54:05.837996	2025-12-30 11:54:05.837996	\N	\N	10	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
36	7	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Open	High	\N	Akshay123	\N	10	\N	2025-12-30 11:53:55.695187	2025-12-30 11:53:55.695187	\N	\N	10	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
58	57	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:59.314104	2025-12-31 13:19:59.314104	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	57
177	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:25:21.920511	2026-01-13 16:25:21.920511	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
193	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-14 12:33:00.846297	2026-01-14 12:35:20.892705	\N	\N	48	Rejected	60	2026-01-14 12:35:20.892705	\N	\N	hh	MM	Incident	PRD	\N	test	f	60
181	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-13 22:34:46.335788	2026-01-13 22:39:23.538101	\N	\N	48	Approved	60	2026-01-13 22:35:38.938343	50	2026-01-13 22:39:23.538101	\N	MM	Incident	PRD	\N	test	f	60
180	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:21:33.606472	2026-01-13 22:22:24.235218	\N	\N	\N	Approved	60	2026-01-13 22:22:24.235218	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
176	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:19:43.646216	2026-01-13 16:31:17.343841	\N	\N	\N	Approved	60	2026-01-13 16:31:17.343841	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
186	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Manger Create	test	SAP	Closed	1	\N	Anjali1234	\N	6	\N	2026-01-14 11:40:23.403466	2026-01-14 11:46:23.38354	\N	\N	48	Rejected	60	2026-01-14 11:46:23.38354	\N	\N	By  Mistake cretea	MM	Incident	PRD	\N	\N	f	60
179	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:10:58.160891	2026-01-13 22:11:30.761033	\N	\N	\N	Approved	60	2026-01-13 22:11:30.761033	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
175	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:18:43.050048	2026-01-13 16:18:43.050048	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
178	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 21:53:57.726702	2026-01-13 21:54:59.020754	\N	\N	\N	Approved	60	2026-01-13 21:54:59.020754	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
174	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:14:38.539112	2026-01-13 16:14:38.539112	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
154	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:46:05.742992	2026-01-12 22:46:05.742992	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
153	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:45:54.545774	2026-01-12 22:45:54.545774	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
167	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 13:30:51.172176	2026-01-13 13:30:51.172176	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
162	55	sanju nishad	sanju.nishad@orane.in	8888888888	heloooooooooooooooooo	hrloooooo	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:29:42.28325	2026-01-13 12:29:42.28325	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
152	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 17:29:34.27529	2026-01-12 17:29:34.27529	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
146	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	Other	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 16:21:27.137909	2026-01-12 16:21:27.137909	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	PRD	\N	\N	f	55
141	55	sanju nishad	sanju.nishad@orane.in	8888888888	cvbnm	g	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 13:32:28.625322	2026-01-12 13:32:28.625322	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	PRD	\N	\N	f	55
136	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Open	2	\N	sanju1234	\N	12	\N	2026-01-12 10:57:41.207875	2026-01-12 12:16:30.658498	\N	\N	48	Approved	60	2026-01-12 12:16:30.658498	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
121	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 14:47:52.306779	2026-01-07 14:47:52.306779	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
115	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.355369	2026-01-07 11:47:18.355369	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
131	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-11 23:17:46.994539	2026-01-11 23:17:46.994539	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
109	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 10:49:54.8426	2026-01-07 10:49:54.8426	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	QA	test	\N	f	55
104	55	sanju nishad	sanju.nishad@orane.in	9999999999	test	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:56.859972	2026-01-06 15:27:42.16559	\N	\N	48	Approved	60	2026-01-06 11:56:18.647677	\N	\N	\N	MM	Incident	QA	Timeout misconfiguration	\N	f	55
101	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	Updated VPN profile and verified successful connection	2026-01-06 11:55:52.298684	2026-01-06 15:16:05.534677	\N	\N	48	Approved	60	2026-01-06 11:56:09.745197	48	2026-01-06 11:56:59.931083	\N	MM	Incident	PRD	VPN configuration mismatch on client machine	\N	f	55
126	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	attachment testing	SAP	UAT	1	50	sanju1234	\N	6	\N	2026-01-09 11:57:04.407593	2026-01-09 16:42:59.345552	\N	\N	48	Approved	60	2026-01-09 11:57:35.233734	48	2026-01-09 11:58:10.525091	\N	SD	Incident	QA	\N	\N	f	55
103	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:55.470186	2026-01-06 11:56:15.79845	\N	\N	48	Approved	60	2026-01-06 11:56:15.79845	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
102	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 11:55:53.967482	2026-01-09 12:19:53.729089	\N	\N	48	Approved	60	2026-01-06 11:56:12.729252	48	2026-01-06 11:57:06.261186	\N	MM	Incident	PRD	sdfg	\N	f	55
96	55	sanju nishad	sanju.nishad@orane.in	\N	test	\N	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-05 18:31:20.106952	2026-01-05 18:31:20.106952	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	1211	\N	f	55
161	55	sanju nishad	sanju.nishad@orane.in	8888888888	s13 jan	13 jan	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:27:57.314646	2026-01-13 12:27:57.314646	\N	\N	48	\N	\N	\N	\N	\N	\N	Tax	Problem	QA	\N	\N	f	55
145	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 15:03:52.908269	2026-01-12 15:03:52.908269	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
140	55	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	qwertyuiolkjhgfdsvbnm	Other	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:23:00.186726	2026-01-12 13:23:00.186726	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
187	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 11:43:16.403544	2026-01-15 11:30:03.276932	\N	\N	48	Approved	60	2026-01-14 12:38:56.728709	48	2026-01-15 11:30:03.276932	\N	MM	Incident	PRD	\N	test	f	60
185	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Manager create	test	SAP	Assigned	1	50	Anjali1234	\N	6	\N	2026-01-14 11:38:16.508631	2026-01-15 11:42:40.746728	\N	\N	48	Approved	60	2026-01-14 11:46:01.445635	48	2026-01-15 11:42:40.746728	\N	MM	Incident	QA	\N	\N	f	60
184	55	sanju nishad	sanju.nishad@orane.in	8888888888	customer create	test	SAP	Assigned	1	48	sanju1234	\N	6	\N	2026-01-14 11:35:13.562013	2026-01-15 11:46:21.018885	\N	\N	48	Approved	60	2026-01-14 11:45:57.283776	48	2026-01-15 11:46:21.018885	\N	SD	Incident	PRD	\N	\N	f	55
120	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Internal Testing	2	50	sanju1234	\N	12	\N	2026-01-07 14:44:11.3464	2026-01-09 11:16:06.327179	\N	\N	48	Approved	60	2026-01-08 12:24:46.320592	48	2026-01-08 12:26:33.818308	\N	MM	Incident	PRD	\N	\N	f	55
135	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:32:11.745983	2026-01-12 09:32:11.745983	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
95	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:20:24.319367	2026-01-05 17:20:24.319367	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
130	55	sanju nishad	sanju.nishad@orane.in	8888888888	g	h	Product	UAT	2	50	sanju1234	\N	12	wertyju	2026-01-09 13:17:40.656698	2026-01-09 16:28:37.325148	\N	\N	48	Approved	60	2026-01-09 13:19:15.672433	48	2026-01-09 13:23:36.964438	\N	Vendor Portal	Query	PRD	sdfg	\N	t	55
125	55	sanju nishad	sanju.nishad@orane.in	8888888888	New Request	qUERY	Integration	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-08 16:38:43.653562	2026-01-08 16:38:43.653562	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55
119	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:44:00.271775	2026-01-07 14:44:00.271775	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
114	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.354419	2026-01-07 11:47:18.354419	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
108	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:29:27.445089	2026-01-06 23:29:27.445089	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
171	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 15:29:03.21955	2026-01-13 15:29:03.21955	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
166	55	sanju nishad	sanju.nishad@orane.in	8888888888	qwerty	qwerty	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:22:35.973777	2026-01-13 13:22:35.973777	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55
100	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 10:30:31.21657	2026-01-09 12:08:05.501549	\N	\N	48	Approved	60	2026-01-06 10:31:40.640992	48	2026-01-06 10:33:01.924134	\N	MM	Incident	PRD	sdfg	\N	f	55
165	55	sanju nishad	sanju.nishad@orane.in	8888888888	yesss	noooooo	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:14:27.180094	2026-01-13 13:14:27.180094	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Query	QA	\N	\N	f	55
160	55	sanju nishad	sanju.nishad@orane.in	8888888888	y	y	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:25:44.214634	2026-01-13 12:25:44.214634	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Problem	PRD	\N	\N	f	55
144	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 14:54:08.513067	2026-01-12 14:54:08.513067	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
139	55	sanju nishad	sanju.nishad@orane.in	8888888888	dfghj	sdfghj	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:06:49.377642	2026-01-12 13:06:49.377642	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	\N	\N	f	55
134	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:31:19.690802	2026-01-12 09:31:19.690802	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
129	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	AA	SAP	Unassigned	4	\N	sanju1234	\N	48	\N	2026-01-09 12:58:40.059323	2026-01-09 12:58:40.059323	\N	\N	48	Pending	\N	\N	\N	\N	\N	FI	Query	PRD	\N	\N	f	55
124	55	sanju nishad	sanju.nishad@orane.in	\N	Query	New Query	Product	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-08 16:35:25.675679	2026-01-08 16:35:25.675679	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	PRD	\N	\N	f	55
118	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:43:30.09533	2026-01-07 14:43:30.09533	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
113	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 11:12:51.936049	2026-01-07 11:12:51.936049	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
107	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:09:27.216569	2026-01-06 23:09:27.216569	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
99	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-06 10:29:42.526867	2026-01-06 10:29:42.526867	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
94	55	sanju nishad	sanju.nisa@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:23.48991	2026-01-05 17:10:23.48991	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
93	55	sanju nishad	sanju.nisad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:14.456445	2026-01-05 17:10:14.456445	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
64	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	testr	Other	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:03:48.408776	2026-01-02 11:03:48.408776	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
65	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:05:53.649478	2026-01-02 13:13:04.445316	\N	\N	48	Approved	60	2026-01-02 13:13:04.445316	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
55	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.08963	2025-12-31 13:24:38.379048	\N	\N	48	Approved	51	2025-12-31 13:24:38.379048	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
56	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:13:00.118354	2025-12-31 13:20:44.87405	\N	\N	48	Approved	51	2025-12-31 13:20:44.87405	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
54	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.001528	2025-12-31 13:12:54.001528	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
53	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.990854	2025-12-31 13:12:53.990854	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
48	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:00.572047	2025-12-31 13:12:02.842423	\N	\N	48	Rejected	51	2025-12-31 13:12:02.842423	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55
50	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.888881	2025-12-31 12:51:42.880361	\N	\N	48	Approved	51	2025-12-31 12:51:42.880361	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
49	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:51:02.963897	2026-01-05 15:34:24.053215	\N	\N	48	Approved	51	2025-12-31 13:11:37.860431	48	2026-01-05 15:34:24.053215	\N	Other	Incident	QA	\N	\N	f	55
149	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:06.157775	2026-01-12 16:39:04.201115	\N	\N	48	Approved	60	2026-01-12 16:38:49.26123	50	2026-01-12 16:39:04.201115	\N	Vendor Portal	Query	PRD	\N	\N	f	55
169	55	sanju nishad	sanju.nishad@orane.in	8888888888	ertyy	ertyu	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 13:44:37.67372	2026-01-13 13:44:37.67372	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Problem	PRD	\N	\N	f	55
117	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	testing it	SAP	Assigned	3	50	sanju1234	\N	24	\N	2026-01-07 14:34:43.204998	2026-01-09 11:57:12.796418	\N	\N	48	Approved	60	2026-01-07 14:38:48.698903	50	2026-01-08 11:37:01.963675	\N	MM	Incident	PRD	\N	\N	f	55
123	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	new one	Product	Assigned	2	50	sanju1234	\N	12	\N	2026-01-07 15:39:42.318433	2026-01-08 11:24:07.836422	\N	\N	48	Approved	60	2026-01-08 11:09:29.322757	48	2026-01-08 11:10:06.678035	\N	Customer Portal	Change	QA	\N	test	f	55
143	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Assigned	2	50	sanju1234	\N	12	\N	2026-01-12 13:57:29.151813	2026-01-12 16:00:37.945822	\N	\N	48	Approved	60	2026-01-12 15:59:51.965223	48	2026-01-12 16:00:37.945822	\N	MM	Incident	PRD	\N	\N	f	55
164	55	sanju nishad	sanju.nishad@orane.in	8888888888	check	check	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:59:00.822753	2026-01-13 12:59:00.822753	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Query	PRD	\N	\N	f	55
138	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	tes	Integration	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 12:32:38.771931	2026-01-12 12:38:42.413274	\N	\N	48	Approved	60	2026-01-12 12:38:24.489023	50	2026-01-12 12:38:42.413274	\N	Middleware	Incident	QA	\N	\N	f	55
148	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:05.231559	2026-01-13 12:26:29.882215	\N	\N	48	Approved	60	2026-01-13 12:26:07.445298	50	2026-01-13 12:26:29.882215	\N	Vendor Portal	Query	PRD	\N	\N	f	55
133	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:26:42.425491	2026-01-12 09:26:42.425491	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
112	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:12:20.863684	2026-01-07 11:12:20.863684	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
106	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:08:19.654172	2026-01-06 23:08:19.654172	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
98	55	sanju nishad	sanju.nishad@orane.in	1234567890	New Request	test	Product	Requirements	3	50	sanju1234	\N	24	Not Given Yet	2026-01-05 19:55:17.376549	2026-01-09 17:59:29.258125	\N	\N	48	Approved	60	2026-01-05 19:55:30.60249	48	2026-01-05 19:56:00.351556	\N	Customer Portal	Query	QA	12	\N	f	55
128	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:55:48.743601	2026-01-09 12:55:48.743601	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
92	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:09:42.28507	2026-01-05 17:09:42.28507	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
163	55	sanju nishad	sanju.nishad@orane.in	8888888888	yesssss	yes	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:53:51.08648	2026-01-13 12:53:51.08648	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Incident	PRD	\N	\N	f	55
147	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new Query	SAP	Open	1	\N	sanju1234	\N	6	\N	2026-01-12 16:35:13.50732	2026-01-12 16:35:39.529036	\N	\N	48	Approved	60	2026-01-12 16:35:39.529036	\N	\N	\N	MM	Incident	QA	\N	\N	f	55
142	55	sanju nishad	sanju.nishad@orane.in	8888888888	wertyuio	wertyujk	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:56:42.842421	2026-01-12 13:56:42.842421	\N	\N	48	Pending	\N	\N	\N	\N	\N	General	Incident	PRD	\N	\N	f	55
116	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.465234	2026-01-07 11:47:18.465234	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
111	55	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:09.679803	2026-01-07 11:02:09.679803	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55
110	55	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:03.309853	2026-01-07 11:02:03.309853	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55
105	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	\N	sanju1234	\N	24	\N	2026-01-06 19:41:14.006249	2026-01-06 19:41:25.96097	\N	\N	48	Rejected	60	2026-01-06 19:41:25.96097	\N	\N	This issue is outside the scope of support	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
97	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 19:47:28.538363	2026-01-05 19:47:28.538363	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	QA	12345	\N	f	55
137	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	SAP	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 11:47:56.063995	2026-01-12 12:13:34.746801	\N	\N	48	Approved	60	2026-01-12 11:49:15.806439	50	2026-01-12 12:13:34.746801	\N	MM	Incident	PRD	\N	\N	f	55
132	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:19:32.171479	2026-01-12 09:19:32.171479	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
127	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	att	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:05:00.765178	2026-01-09 12:05:00.765178	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	QA	\N	\N	f	55
122	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 15:00:13.273164	2026-01-08 12:13:09.262065	\N	\N	48	Rejected	60	2026-01-08 12:13:09.262065	\N	\N	not A VALID TICKET	MM	Incident	PRD	\N	test	f	55
47	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:46:43.444645	2025-12-31 12:50:02.67343	\N	\N	48	Approved	51	2025-12-31 12:48:25.144042	48	2025-12-31 12:50:02.67343	\N	Other	Incident	QA	\N	\N	f	55
52	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.899229	2025-12-31 13:20:39.481164	\N	\N	48	Rejected	51	2025-12-31 13:20:39.481164	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55
51	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.941159	2025-12-31 12:51:40.794503	\N	\N	48	Approved	51	2025-12-31 12:51:40.794503	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
168	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	sanju1234	2026-01-08	24	\N	2026-01-13 13:39:49.308156	2026-01-15 11:46:36.034821	\N	\N	48	Approved	60	2026-01-13 13:41:28.716517	48	2026-01-15 11:46:36.034821	\N	MM	Incident	PRD	\N	test	f	55
197	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Mananer Ticket	test	SAP	Requirements	1	48	Anjali1234	\N	6	\N	2026-01-15 12:16:16.582781	2026-01-15 14:45:42.041272	\N	\N	48	Approved	60	2026-01-15 12:16:45.72467	48	2026-01-15 12:17:12.048393	\N	MM	Incident	PRD	\N	\N	f	60
203	55	sanju nishad	sanju.nishad@orane.in	8888888888	tyes	wertyuj	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-16 12:55:58.054471	2026-01-16 12:55:58.054471	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	PRD	\N	\N	f	55
192	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:32:10.413258	2026-01-14 13:40:27.273048	\N	\N	48	Approved	60	2026-01-14 12:39:26.191349	48	2026-01-14 13:40:27.273048	\N	MM	Incident	PRD	\N	test	f	60
158	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 09:48:15.495956	2026-01-13 09:48:15.495956	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
31	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 16:59:30.573771	2025-12-30 11:56:03.294571	\N	\N	10	Approved	8	2025-12-29 17:01:16.21216	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
32	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Requirements	High	11	Akshay123	\N	24	\N	2025-12-29 17:07:41.807736	2025-12-29 17:29:16.064044	\N	\N	10	Approved	8	2025-12-29 17:07:55.829496	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
30	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to login	Getting invalid password error	SAP	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 13:23:20.144123	2025-12-29 13:23:20.144123	\N	\N	10	Approved	8	2025-12-29 13:38:20.835075	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
173	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	abhinav1234	2026-01-08	24	\N	2026-01-13 15:38:48.909834	2026-01-15 11:46:25.909221	\N	\N	48	Approved	48	2026-01-13 15:38:47.386	48	2026-01-15 11:46:25.909221	\N	MM	Incident	PRD	\N	test	f	48
81	55	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-04 10:21:13.672492	2026-01-04 10:21:26.510159	\N	\N	48	Rejected	60	2026-01-04 10:21:26.510159	\N	\N	test	Other	Incident	QA	\N	\N	f	\N
71	55	deepika gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 18:33:18.038516	2026-01-02 22:37:59.906785	\N	\N	48	Rejected	60	2026-01-02 22:37:59.906785	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
73	55	ravi	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:41:08.671346	2026-01-02 22:41:53.257898	\N	\N	48	Rejected	60	2026-01-02 22:41:53.257898	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
198	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create New one	test	Product	Assigned	3	50	abhinav1234	\N	24	\N	2026-01-15 12:49:54.141181	2026-01-15 13:03:24.299701	\N	\N	48	Approved	48	2026-01-15 12:49:54.239	48	2026-01-15 13:03:24.299701	\N	Vendor Portal	Query	QA	\N	\N	f	48
204	82	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Open	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:13.009899	2026-01-16 15:24:35.819062	\N	\N	78	Approved	67	2026-01-16 15:24:35.819062	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82
91	55	John Doe	john@test.com	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 16:27:33.722175	2026-01-05 16:27:33.722175	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	\N
41	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:30:48.54955	2025-12-30 12:36:45.596897	\N	\N	10	Approved	8	2025-12-30 12:31:29.194391	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
194	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-15 09:40:27.85422	2026-01-15 09:40:27.85422	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
63	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:58:23.098513	2025-12-31 16:58:37.614448	\N	\N	48	Rejected	51	2025-12-31 16:58:37.614448	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
60	55	atharrv	atharrv1@gmail.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	50	Atharrv1234	\N	24	\N	2025-12-31 13:33:06.35065	2026-01-02 12:15:34.128891	\N	\N	48	Approved	51	2025-12-31 13:42:21.906216	48	2026-01-02 12:15:34.128891	\N	Other	Incident	QA	\N	\N	f	\N
182	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 22:58:36.980542	2026-01-13 23:36:57.005348	\N	\N	48	Approved	50	2026-01-13 22:58:36.854	50	2026-01-13 23:36:57.005348	\N	MM	Incident	PRD	\N	test	f	50
183	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	48	deepak1234	2026-01-08	24	\N	2026-01-14 11:16:04.037658	2026-01-14 13:21:41.987197	\N	\N	48	Approved	50	2026-01-14 11:16:03.803	48	2026-01-14 13:21:41.987197	\N	MM	Incident	PRD	\N	test	f	50
159	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-13 10:34:46.794855	2026-01-13 10:34:46.794855	\N	\N	48	Approved	48	2026-01-13 10:34:45.599	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
69	55	deepak gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 18:18:05.565088	2026-01-05 15:41:01.267897	\N	\N	48	Approved	60	2026-01-05 15:41:01.267897	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
46	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	Akshay123	\N	24	\N	2025-12-31 12:06:32.526289	2025-12-31 12:08:53.959738	\N	\N	10	Rejected	8	2025-12-31 12:08:53.959738	\N	\N	Not a valid ticket	Other	Incident	QA	\N	\N	f	7
38	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:08.016959	2025-12-30 12:11:54.448435	\N	\N	10	Approved	8	2025-12-30 12:11:24.492013	11	2025-12-30 12:11:54.448435	\N	Other	Incident	QA	\N	\N	f	7
39	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 12:11:10.712114	2025-12-30 12:12:11.450548	\N	\N	10	Approved	8	2025-12-30 12:11:29.564526	10	2025-12-30 12:12:11.450548	\N	Other	Incident	QA	\N	\N	f	7
33	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn. Thank you	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-29 17:10:20.208597	2025-12-29 20:04:49.996777	\N	\N	10	Approved	8	2025-12-29 17:10:33.343345	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
67	55	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2026-01-02 12:33:03.334657	2026-01-02 12:40:04.508884	\N	\N	48	Rejected	60	2026-01-02 12:40:04.508884	\N	\N	invalid ticket	Other	Incident	QA	\N	\N	f	51
66	55	Sanju gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2026-01-02 11:12:07.92215	2026-01-02 12:56:52.427984	\N	\N	48	Approved	60	2026-01-02 12:56:52.427984	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
199	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:04:48.077834	2026-01-15 15:04:48.077834	\N	\N	48	Approved	48	2026-01-15 15:04:48.198	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
205	82	haldiram	haldiram@gmail.com	88888888568	sdfghjkl;	qwertyui	SAP	Unassigned	1	\N	haldiram12345	\N	6	\N	2026-01-16 15:17:34.957413	2026-01-16 15:17:34.957413	\N	\N	78	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	82
34	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	SAP	Assigned	High	11	Akshay123	\N	20	\N	2025-12-30 10:55:46.085437	2025-12-30 10:55:46.085437	\N	\N	10	Approved	8	2025-12-30 10:56:08.243435	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
57	57	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:56.977752	2025-12-31 13:23:38.828342	\N	\N	48	Approved	51	2025-12-31 13:23:38.828342	\N	\N	\N	Other	Incident	QA	\N	\N	f	57
155	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-12 22:48:17.737053	2026-01-12 22:48:17.737053	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
59	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	High	\N	sanju1234	\N	24	\N	2025-12-31 13:32:01.673554	2025-12-31 13:32:01.673554	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
61	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 15:45:18.433835	2025-12-31 15:58:12.147158	\N	\N	48	Rejected	51	2025-12-31 15:58:12.147158	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
62	55	Sanju Nishad	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	High	\N	sanju1234	\N	24	\N	2025-12-31 16:41:26.355426	2025-12-31 16:44:48.183323	\N	\N	48	Rejected	51	2025-12-31 16:44:48.183323	\N	\N	This issue is outside the scope of support	Other	Incident	QA	\N	\N	f	\N
35	7	Akshay Tiwari	akshaytiwari@company.com	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	High	11	Akshay123	\N	24	\N	2025-12-30 11:37:02.546096	2025-12-30 11:37:02.546096	\N	\N	10	Approved	8	2025-12-30 11:37:23.006257	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
195	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-15 09:42:15.286739	2026-01-15 10:07:07.228433	\N	\N	48	Approved	50	2026-01-15 09:42:14.949	50	2026-01-15 10:07:07.228433	\N	MM	Incident	PRD	\N	test	f	50
200	48	abhinav jain	abhinav.jain@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	abhinav1234	2026-01-08	24	\N	2026-01-15 15:09:01.824884	2026-01-15 15:09:01.824884	\N	\N	48	Approved	48	2026-01-15 15:09:01.943	\N	\N	\N	MM	Incident	PRD	\N	test	f	48
150	60	anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:53:48.11002	2026-01-12 16:53:48.11002	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N
42	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-31 10:57:22.041972	2025-12-31 10:57:50.374756	\N	\N	10	Approved	8	2025-12-31 10:57:38.644988	10	2025-12-31 10:57:50.374756	\N	Other	Incident	QA	\N	\N	f	7
156	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 22:52:22.297316	2026-01-12 22:52:22.297316	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50
72	55	deepika singh	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Open	4	\N	sanju1234	\N	48	\N	2026-01-02 22:02:19.998104	2026-01-05 15:33:56.298654	\N	\N	48	Approved	60	2026-01-05 15:33:56.298654	\N	\N	\N	Other	Incident	QA	\N	\N	f	\N
190	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL Create	Test	SAP	Assigned	2	48	abhinav1234	\N	12	\N	2026-01-14 11:54:53.284868	2026-01-14 15:34:50.058291	\N	\N	48	Approved	48	2026-01-14 11:54:52.018	48	2026-01-14 15:34:50.058291	\N	MM	Query	PRD	\N	\N	f	48
68	55	Samraddhi gupta	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	2	\N	sanju1234	\N	12	wertyju	2026-01-02 16:43:09.671855	2026-01-09 15:45:17.776362	\N	\N	48	Approved	60	2026-01-02 22:37:22.591191	\N	\N	\N	Other	Incident	QA	sdfg	\N	f	51
75	55	ramu	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Closed	4	\N	sanju1234	\N	48	\N	2026-01-02 22:54:20.656182	2026-01-05 13:15:55.626247	\N	\N	48	Rejected	60	2026-01-05 13:15:55.626247	\N	\N	not a vali dticket\n	Other	Incident	QA	\N	\N	f	\N
76	55	rahul	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Requirements	4	50	sanju1234	\N	48	\N	2026-01-02 23:00:33.900465	2026-01-04 10:05:32.724787	\N	\N	48	Approved	60	2026-01-02 23:01:06.489556	48	2026-01-02 23:20:12.114751	\N	Other	Incident	QA	\N	\N	f	\N
188	50	deepak sahani	deepak.sahani@orane.in	8888888888	Agent Create	test	SAP	Assigned	2	50	deepak1234	\N	12	\N	2026-01-14 11:50:04.164809	2026-01-15 11:28:11.377764	\N	\N	48	Approved	50	2026-01-14 11:50:02.89	48	2026-01-15 11:28:11.377764	\N	MM	Incident	PRD	\N	\N	f	50
196	48	abhinav jain	abhinav.jain@orane.in	8888888888	DL ticket	test	Product	Development	1	48	abhinav1234	\N	6	\N	2026-01-15 11:32:19.87505	2026-01-15 18:47:02.66391	\N	\N	48	Approved	48	2026-01-15 11:32:19.871	48	2026-01-15 11:42:22.213544	\N	Customer Portal	Incident	QA	asdfgghhhjhhj	\N	t	48
201	70	BIBA	biba@gmail.com	88888888568	testing	testing	SAP	Assigned	2	73	biba1234	\N	12	\N	2026-01-15 21:53:26.641915	2026-01-15 22:12:07.648968	\N	\N	66	Approved	67	2026-01-15 21:56:31.476872	66	2026-01-15 22:12:07.648968	\N	MM	Incident	PRD	\N	\N	f	\N
84	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Development	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:29.633771	2026-01-05 13:03:47.101803	\N	\N	48	Approved	60	2026-01-05 10:48:34.966126	48	2026-01-05 12:30:51.878794	\N	Other	Incident	QA	\N	\N	f	\N
74	55	rani	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-02 22:41:17.413184	2026-01-05 15:41:15.161541	\N	\N	48	Approved	60	2026-01-02 22:42:15.51574	48	2026-01-05 15:41:15.161541	\N	Other	Incident	QA	\N	\N	f	\N
83	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-05 10:45:27.084042	2026-01-05 12:30:27.623922	\N	\N	48	Approved	60	2026-01-05 10:48:28.099492	48	2026-01-05 12:18:33.753639	\N	Other	Incident	QA	\N	\N	f	\N
80	55	krishna	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	UAT	4	50	sanju1234	\N	48	\N	2026-01-04 10:17:59.928832	2026-01-04 10:38:44.060394	\N	\N	48	Approved	60	2026-01-04 10:19:18.019932	48	2026-01-04 10:23:17.797088	\N	Other	Incident	QA	\N	\N	f	\N
151	60	anjali sharma	anjali.shara@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 16:55:42.575596	2026-01-12 16:55:42.575596	\N	\N	\N	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	\N
43	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:12.414258	2025-12-31 11:19:12.414258	\N	\N	10	Approved	8	2025-12-31 11:19:44.758201	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
189	50	deepak sahani	deepak.sahani@orane.in	8888888888	AgentCreate1	test	SAP	Assigned	1	50	deepak1234	\N	6	\N	2026-01-14 11:50:46.145128	2026-01-14 11:50:53.200156	\N	\N	48	Approved	50	2026-01-14 11:50:44.873	50	2026-01-14 11:50:53.200156	\N	MM	Incident	PRD	\N	\N	f	50
82	55	krishnaa	sanju.nishad@orane.in	9999999999	Unable to connect with vpn	I am not able to connect with vpn	Product	Assigned	4	50	sanju1234	\N	48	\N	2026-01-04 16:58:37.838458	2026-01-05 15:36:01.762808	\N	\N	48	Approved	60	2026-01-04 16:59:01.49311	50	2026-01-05 15:36:01.762808	\N	Other	Incident	QA	\N	\N	f	\N
157	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	deepak1234	2026-01-08	24	\N	2026-01-12 23:08:43.498122	2026-01-12 23:08:43.498122	\N	\N	48	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	50
172	50	deepak sahani	deepak.sahani@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	deepak1234	2026-01-08	24	\N	2026-01-13 15:33:05.833576	2026-01-13 15:35:08.858021	\N	\N	48	Approved	50	2026-01-13 15:33:04.315	50	2026-01-13 15:35:08.858021	\N	MM	Incident	PRD	\N	test	f	50
170	55	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	wertyui	SAP	Assigned	2	48	sanju1234	\N	12	\N	2026-01-13 14:38:55.931411	2026-01-15 11:46:32.743134	\N	\N	48	Approved	60	2026-01-13 14:42:27.153575	48	2026-01-15 11:46:32.743134	\N	ABAP	Query	PRD	\N	\N	f	55
202	72	BHARTIexcel	bharti@gmail.com	88888888568	dfghjk	ertyui	Integration	Assigned	3	73	bharti1234	\N	24	\N	2026-01-15 22:17:52.182678	2026-01-15 22:20:14.890914	\N	\N	66	Approved	68	2026-01-15 22:19:41.516402	66	2026-01-15 22:20:14.890914	\N	Middleware	Query	QA	\N	\N	f	\N
191	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 12:31:30.867104	2026-01-14 15:33:27.210345	\N	\N	48	Approved	60	2026-01-14 12:31:53.58027	48	2026-01-14 15:33:27.210345	\N	MM	Incident	PRD	\N	test	f	60
44	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:14.95744	2025-12-31 11:19:14.95744	\N	\N	10	Approved	8	2025-12-31 11:19:42.459778	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
45	7	Akshay tiwari	akshaytiwari@company.com	1234567890-	test	test	Other	Open	High	\N	Akshay123	\N	10	\N	2025-12-31 11:19:17.049915	2025-12-31 11:19:17.049915	\N	\N	10	Approved	8	2025-12-31 11:19:40.41727	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
40	7	Akshay tiwari	akshaytiwari@company.com	1234567890	test	test	Integration	Assigned	High	11	Akshay123	\N	10	\N	2025-12-30 12:23:09.563793	2025-12-30 12:27:40.434067	\N	\N	10	Approved	8	2025-12-30 12:27:04.820988	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
37	7	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Open	High	\N	Akshay123	\N	10	\N	2025-12-30 11:54:05.837996	2025-12-30 11:54:05.837996	\N	\N	10	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
36	7	Akshay tiwari	akshaytiwari@company.com	1234567890	Password Issue	Password issue	SAP	Open	High	\N	Akshay123	\N	10	\N	2025-12-30 11:53:55.695187	2025-12-30 11:53:55.695187	\N	\N	10	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	7
58	57	Atharrv Bhatnagar	atharrv1@gmail.com	1234567890	test	test	Integration	Open	High	\N	Atharrv1234	\N	10	\N	2025-12-31 13:19:59.314104	2025-12-31 13:19:59.314104	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	57
177	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:25:21.920511	2026-01-13 16:25:21.920511	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
193	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-14 12:33:00.846297	2026-01-14 12:35:20.892705	\N	\N	48	Rejected	60	2026-01-14 12:35:20.892705	\N	\N	hh	MM	Incident	PRD	\N	test	f	60
181	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-13 22:34:46.335788	2026-01-13 22:39:23.538101	\N	\N	48	Approved	60	2026-01-13 22:35:38.938343	50	2026-01-13 22:39:23.538101	\N	MM	Incident	PRD	\N	test	f	60
180	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:21:33.606472	2026-01-13 22:22:24.235218	\N	\N	\N	Approved	60	2026-01-13 22:22:24.235218	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
176	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:19:43.646216	2026-01-13 16:31:17.343841	\N	\N	\N	Approved	60	2026-01-13 16:31:17.343841	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
186	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Manger Create	test	SAP	Closed	1	\N	Anjali1234	\N	6	\N	2026-01-14 11:40:23.403466	2026-01-14 11:46:23.38354	\N	\N	48	Rejected	60	2026-01-14 11:46:23.38354	\N	\N	By  Mistake cretea	MM	Incident	PRD	\N	\N	f	60
179	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 22:10:58.160891	2026-01-13 22:11:30.761033	\N	\N	\N	Approved	60	2026-01-13 22:11:30.761033	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
175	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:18:43.050048	2026-01-13 16:18:43.050048	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
178	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 21:53:57.726702	2026-01-13 21:54:59.020754	\N	\N	\N	Approved	60	2026-01-13 21:54:59.020754	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
174	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-13 16:14:38.539112	2026-01-13 16:14:38.539112	\N	\N	\N	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
154	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:46:05.742992	2026-01-12 22:46:05.742992	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
153	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Open	3	\N	Anjali1234	2026-01-08	24	\N	2026-01-12 22:45:54.545774	2026-01-12 22:45:54.545774	\N	\N	\N	Approved	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	60
167	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 13:30:51.172176	2026-01-13 13:30:51.172176	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
162	55	sanju nishad	sanju.nishad@orane.in	8888888888	heloooooooooooooooooo	hrloooooo	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:29:42.28325	2026-01-13 12:29:42.28325	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
152	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	\N	3	\N	sanju1234	2026-01-08	24	\N	2026-01-12 17:29:34.27529	2026-01-12 17:29:34.27529	\N	\N	48	\N	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
146	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	Other	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 16:21:27.137909	2026-01-12 16:21:27.137909	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	PRD	\N	\N	f	55
141	55	sanju nishad	sanju.nishad@orane.in	8888888888	cvbnm	g	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-12 13:32:28.625322	2026-01-12 13:32:28.625322	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	PRD	\N	\N	f	55
136	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Open	2	\N	sanju1234	\N	12	\N	2026-01-12 10:57:41.207875	2026-01-12 12:16:30.658498	\N	\N	48	Approved	60	2026-01-12 12:16:30.658498	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
121	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 14:47:52.306779	2026-01-07 14:47:52.306779	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
115	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.355369	2026-01-07 11:47:18.355369	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
131	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-11 23:17:46.994539	2026-01-11 23:17:46.994539	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
109	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 10:49:54.8426	2026-01-07 10:49:54.8426	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	QA	test	\N	f	55
104	55	sanju nishad	sanju.nishad@orane.in	9999999999	test	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:56.859972	2026-01-06 15:27:42.16559	\N	\N	48	Approved	60	2026-01-06 11:56:18.647677	\N	\N	\N	MM	Incident	QA	Timeout misconfiguration	\N	f	55
101	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	Updated VPN profile and verified successful connection	2026-01-06 11:55:52.298684	2026-01-06 15:16:05.534677	\N	\N	48	Approved	60	2026-01-06 11:56:09.745197	48	2026-01-06 11:56:59.931083	\N	MM	Incident	PRD	VPN configuration mismatch on client machine	\N	f	55
126	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	attachment testing	SAP	UAT	1	50	sanju1234	\N	6	\N	2026-01-09 11:57:04.407593	2026-01-09 16:42:59.345552	\N	\N	48	Approved	60	2026-01-09 11:57:35.233734	48	2026-01-09 11:58:10.525091	\N	SD	Incident	QA	\N	\N	f	55
103	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Open	3	\N	sanju1234	\N	24	\N	2026-01-06 11:55:55.470186	2026-01-06 11:56:15.79845	\N	\N	48	Approved	60	2026-01-06 11:56:15.79845	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
102	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 11:55:53.967482	2026-01-09 12:19:53.729089	\N	\N	48	Approved	60	2026-01-06 11:56:12.729252	48	2026-01-06 11:57:06.261186	\N	MM	Incident	PRD	sdfg	\N	f	55
96	55	sanju nishad	sanju.nishad@orane.in	\N	test	\N	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-05 18:31:20.106952	2026-01-05 18:31:20.106952	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	1211	\N	f	55
161	55	sanju nishad	sanju.nishad@orane.in	8888888888	s13 jan	13 jan	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:27:57.314646	2026-01-13 12:27:57.314646	\N	\N	48	\N	\N	\N	\N	\N	\N	Tax	Problem	QA	\N	\N	f	55
145	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 15:03:52.908269	2026-01-12 15:03:52.908269	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
140	55	sanju nishad	sanju.nishad@orane.in	8888888888	sdfghjkl;	qwertyuiolkjhgfdsvbnm	Other	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:23:00.186726	2026-01-12 13:23:00.186726	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
187	60	Anjali sharma	anjali.sharma@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	Anjali1234	2026-01-08	24	\N	2026-01-14 11:43:16.403544	2026-01-15 11:30:03.276932	\N	\N	48	Approved	60	2026-01-14 12:38:56.728709	48	2026-01-15 11:30:03.276932	\N	MM	Incident	PRD	\N	test	f	60
185	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Manager create	test	SAP	Assigned	1	50	Anjali1234	\N	6	\N	2026-01-14 11:38:16.508631	2026-01-15 11:42:40.746728	\N	\N	48	Approved	60	2026-01-14 11:46:01.445635	48	2026-01-15 11:42:40.746728	\N	MM	Incident	QA	\N	\N	f	60
184	55	sanju nishad	sanju.nishad@orane.in	8888888888	customer create	test	SAP	Assigned	1	48	sanju1234	\N	6	\N	2026-01-14 11:35:13.562013	2026-01-15 11:46:21.018885	\N	\N	48	Approved	60	2026-01-14 11:45:57.283776	48	2026-01-15 11:46:21.018885	\N	SD	Incident	PRD	\N	\N	f	55
120	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Internal Testing	2	50	sanju1234	\N	12	\N	2026-01-07 14:44:11.3464	2026-01-09 11:16:06.327179	\N	\N	48	Approved	60	2026-01-08 12:24:46.320592	48	2026-01-08 12:26:33.818308	\N	MM	Incident	PRD	\N	\N	f	55
135	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:32:11.745983	2026-01-12 09:32:11.745983	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
95	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:20:24.319367	2026-01-05 17:20:24.319367	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
130	55	sanju nishad	sanju.nishad@orane.in	8888888888	g	h	Product	UAT	2	50	sanju1234	\N	12	wertyju	2026-01-09 13:17:40.656698	2026-01-09 16:28:37.325148	\N	\N	48	Approved	60	2026-01-09 13:19:15.672433	48	2026-01-09 13:23:36.964438	\N	Vendor Portal	Query	PRD	sdfg	\N	t	55
125	55	sanju nishad	sanju.nishad@orane.in	8888888888	New Request	qUERY	Integration	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-08 16:38:43.653562	2026-01-08 16:38:43.653562	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55
119	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:44:00.271775	2026-01-07 14:44:00.271775	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
114	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.354419	2026-01-07 11:47:18.354419	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
108	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:29:27.445089	2026-01-06 23:29:27.445089	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
171	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Unassigned	3	\N	sanju1234	2026-01-08	24	\N	2026-01-13 15:29:03.21955	2026-01-13 15:29:03.21955	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	test	f	55
166	55	sanju nishad	sanju.nishad@orane.in	8888888888	qwerty	qwerty	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:22:35.973777	2026-01-13 13:22:35.973777	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Incident	QA	\N	\N	f	55
100	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	50	sanju1234	\N	24	wertyju	2026-01-06 10:30:31.21657	2026-01-09 12:08:05.501549	\N	\N	48	Approved	60	2026-01-06 10:31:40.640992	48	2026-01-06 10:33:01.924134	\N	MM	Incident	PRD	sdfg	\N	f	55
165	55	sanju nishad	sanju.nishad@orane.in	8888888888	yesss	noooooo	Integration	\N	1	\N	sanju1234	\N	6	\N	2026-01-13 13:14:27.180094	2026-01-13 13:14:27.180094	\N	\N	48	\N	\N	\N	\N	\N	\N	Middleware	Query	QA	\N	\N	f	55
160	55	sanju nishad	sanju.nishad@orane.in	8888888888	y	y	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:25:44.214634	2026-01-13 12:25:44.214634	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Problem	PRD	\N	\N	f	55
144	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 14:54:08.513067	2026-01-12 14:54:08.513067	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
139	55	sanju nishad	sanju.nishad@orane.in	8888888888	dfghj	sdfghj	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:06:49.377642	2026-01-12 13:06:49.377642	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Query	PRD	\N	\N	f	55
134	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:31:19.690802	2026-01-12 09:31:19.690802	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
129	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	AA	SAP	Unassigned	4	\N	sanju1234	\N	48	\N	2026-01-09 12:58:40.059323	2026-01-09 12:58:40.059323	\N	\N	48	Pending	\N	\N	\N	\N	\N	FI	Query	PRD	\N	\N	f	55
124	55	sanju nishad	sanju.nishad@orane.in	\N	Query	New Query	Product	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-08 16:35:25.675679	2026-01-08 16:35:25.675679	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	PRD	\N	\N	f	55
118	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 14:43:30.09533	2026-01-07 14:43:30.09533	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
113	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-07 11:12:51.936049	2026-01-07 11:12:51.936049	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
107	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:09:27.216569	2026-01-06 23:09:27.216569	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
99	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-06 10:29:42.526867	2026-01-06 10:29:42.526867	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
94	55	sanju nishad	sanju.nisa@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:23.48991	2026-01-05 17:10:23.48991	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
93	55	sanju nishad	sanju.nisad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:10:14.456445	2026-01-05 17:10:14.456445	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
64	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	testr	Other	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:03:48.408776	2026-01-02 11:03:48.408776	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
65	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2026-01-02 11:05:53.649478	2026-01-02 13:13:04.445316	\N	\N	48	Approved	60	2026-01-02 13:13:04.445316	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
55	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.08963	2025-12-31 13:24:38.379048	\N	\N	48	Approved	51	2025-12-31 13:24:38.379048	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
56	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:13:00.118354	2025-12-31 13:20:44.87405	\N	\N	48	Approved	51	2025-12-31 13:20:44.87405	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
54	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:54.001528	2025-12-31 13:12:54.001528	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
53	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.990854	2025-12-31 13:12:53.990854	\N	\N	48	Pending	\N	\N	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
48	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:00.572047	2025-12-31 13:12:02.842423	\N	\N	48	Rejected	51	2025-12-31 13:12:02.842423	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55
50	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.888881	2025-12-31 12:51:42.880361	\N	\N	48	Approved	51	2025-12-31 12:51:42.880361	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
49	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:51:02.963897	2026-01-05 15:34:24.053215	\N	\N	48	Approved	51	2025-12-31 13:11:37.860431	48	2026-01-05 15:34:24.053215	\N	Other	Incident	QA	\N	\N	f	55
149	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:06.157775	2026-01-12 16:39:04.201115	\N	\N	48	Approved	60	2026-01-12 16:38:49.26123	50	2026-01-12 16:39:04.201115	\N	Vendor Portal	Query	PRD	\N	\N	f	55
169	55	sanju nishad	sanju.nishad@orane.in	8888888888	ertyy	ertyu	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 13:44:37.67372	2026-01-13 13:44:37.67372	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Problem	PRD	\N	\N	f	55
117	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	testing it	SAP	Assigned	3	50	sanju1234	\N	24	\N	2026-01-07 14:34:43.204998	2026-01-09 11:57:12.796418	\N	\N	48	Approved	60	2026-01-07 14:38:48.698903	50	2026-01-08 11:37:01.963675	\N	MM	Incident	PRD	\N	\N	f	55
123	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	new one	Product	Assigned	2	50	sanju1234	\N	12	\N	2026-01-07 15:39:42.318433	2026-01-08 11:24:07.836422	\N	\N	48	Approved	60	2026-01-08 11:09:29.322757	48	2026-01-08 11:10:06.678035	\N	Customer Portal	Change	QA	\N	test	f	55
143	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Assigned	2	50	sanju1234	\N	12	\N	2026-01-12 13:57:29.151813	2026-01-12 16:00:37.945822	\N	\N	48	Approved	60	2026-01-12 15:59:51.965223	48	2026-01-12 16:00:37.945822	\N	MM	Incident	PRD	\N	\N	f	55
164	55	sanju nishad	sanju.nishad@orane.in	8888888888	check	check	SAP	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:59:00.822753	2026-01-13 12:59:00.822753	\N	\N	48	\N	\N	\N	\N	\N	\N	SD	Query	PRD	\N	\N	f	55
138	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	tes	Integration	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 12:32:38.771931	2026-01-12 12:38:42.413274	\N	\N	48	Approved	60	2026-01-12 12:38:24.489023	50	2026-01-12 12:38:42.413274	\N	Middleware	Incident	QA	\N	\N	f	55
148	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new	Product	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 16:37:05.231559	2026-01-13 12:26:29.882215	\N	\N	48	Approved	60	2026-01-13 12:26:07.445298	50	2026-01-13 12:26:29.882215	\N	Vendor Portal	Query	PRD	\N	\N	f	55
133	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:26:42.425491	2026-01-12 09:26:42.425491	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
112	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:12:20.863684	2026-01-07 11:12:20.863684	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
106	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-06 23:08:19.654172	2026-01-06 23:08:19.654172	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
98	55	sanju nishad	sanju.nishad@orane.in	1234567890	New Request	test	Product	Requirements	3	50	sanju1234	\N	24	Not Given Yet	2026-01-05 19:55:17.376549	2026-01-09 17:59:29.258125	\N	\N	48	Approved	60	2026-01-05 19:55:30.60249	48	2026-01-05 19:56:00.351556	\N	Customer Portal	Query	QA	12	\N	f	55
128	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:55:48.743601	2026-01-09 12:55:48.743601	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
92	55	sanju nishad	sanju.nishad@orane.in	\N	Login issue	\N	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 17:09:42.28507	2026-01-05 17:09:42.28507	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
163	55	sanju nishad	sanju.nishad@orane.in	8888888888	yesssss	yes	Product	\N	2	\N	sanju1234	\N	12	\N	2026-01-13 12:53:51.08648	2026-01-13 12:53:51.08648	\N	\N	48	\N	\N	\N	\N	\N	\N	Customer Portal	Incident	PRD	\N	\N	f	55
147	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	new Query	SAP	Open	1	\N	sanju1234	\N	6	\N	2026-01-12 16:35:13.50732	2026-01-12 16:35:39.529036	\N	\N	48	Approved	60	2026-01-12 16:35:39.529036	\N	\N	\N	MM	Incident	QA	\N	\N	f	55
142	55	sanju nishad	sanju.nishad@orane.in	8888888888	wertyuio	wertyujk	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-12 13:56:42.842421	2026-01-12 13:56:42.842421	\N	\N	48	Pending	\N	\N	\N	\N	\N	General	Incident	PRD	\N	\N	f	55
116	55	sanju nishad	sanju.nishad@orane.in	1234567890	12345	234567	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:47:18.465234	2026-01-07 11:47:18.465234	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	\N	\N	f	55
111	55	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:09.679803	2026-01-07 11:02:09.679803	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55
110	55	sanju nishad	sanju.nishad@orane.in	1234567890	123456789	23456789	SAP	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-07 11:02:03.309853	2026-01-07 11:02:03.309853	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	PRD	126	\N	f	55
105	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	\N	SAP	Closed	3	\N	sanju1234	\N	24	\N	2026-01-06 19:41:14.006249	2026-01-06 19:41:25.96097	\N	\N	48	Rejected	60	2026-01-06 19:41:25.96097	\N	\N	This issue is outside the scope of support	MM	Incident	PRD	Timeout misconfiguration	\N	f	55
97	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Product	Unassigned	3	\N	sanju1234	\N	24	\N	2026-01-05 19:47:28.538363	2026-01-05 19:47:28.538363	\N	\N	48	Pending	\N	\N	\N	\N	\N	Vendor Portal	Query	QA	12345	\N	f	55
137	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	test	SAP	Assigned	1	50	sanju1234	\N	6	\N	2026-01-12 11:47:56.063995	2026-01-12 12:13:34.746801	\N	\N	48	Approved	60	2026-01-12 11:49:15.806439	50	2026-01-12 12:13:34.746801	\N	MM	Incident	PRD	\N	\N	f	55
132	55	sanju nishad	sanju.nishad@orane.in	3456789876	issue	test	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-12 09:19:32.171479	2026-01-12 09:19:32.171479	\N	\N	48	Pending	\N	\N	\N	\N	\N	MM	Incident	PRD	\N	\N	f	55
127	55	sanju nishad	sanju.nishad@orane.in	8888888888	test	att	SAP	Unassigned	2	\N	sanju1234	\N	12	\N	2026-01-09 12:05:00.765178	2026-01-09 12:05:00.765178	\N	\N	48	Pending	\N	\N	\N	\N	\N	SD	Incident	QA	\N	\N	f	55
122	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Closed	3	\N	sanju1234	2026-01-08	24	\N	2026-01-07 15:00:13.273164	2026-01-08 12:13:09.262065	\N	\N	48	Rejected	60	2026-01-08 12:13:09.262065	\N	\N	not A VALID TICKET	MM	Incident	PRD	\N	test	f	55
47	55	sanju nishad	sanju.nishad@orane.in	1234567890	test	test	Integration	Assigned	High	50	sanju1234	\N	10	\N	2025-12-31 12:46:43.444645	2025-12-31 12:50:02.67343	\N	\N	48	Approved	51	2025-12-31 12:48:25.144042	48	2025-12-31 12:50:02.67343	\N	Other	Incident	QA	\N	\N	f	55
52	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Closed	High	\N	sanju1234	\N	10	\N	2025-12-31 13:12:53.899229	2025-12-31 13:20:39.481164	\N	\N	48	Rejected	51	2025-12-31 13:20:39.481164	\N	\N	not a valid ticket	Other	Incident	QA	\N	\N	f	55
51	55	sanju nishad	sanju.nishad@orane.in	test	test	test	Integration	Open	High	\N	sanju1234	\N	10	\N	2025-12-31 12:51:04.941159	2025-12-31 12:51:40.794503	\N	\N	48	Approved	51	2025-12-31 12:51:40.794503	\N	\N	\N	Other	Incident	QA	\N	\N	f	55
168	55	sanju nishad	sanju.nishad@orane.in	9999999999	Login issue	I am not able to connect with vpn	SAP	Assigned	3	50	sanju1234	2026-01-08	24	\N	2026-01-13 13:39:49.308156	2026-01-15 11:46:36.034821	\N	\N	48	Approved	60	2026-01-13 13:41:28.716517	48	2026-01-15 11:46:36.034821	\N	MM	Incident	PRD	\N	test	f	55
197	60	Anjali sharma	anjali.sharma@orane.in	88888888568	Mananer Ticket	test	SAP	Requirements	1	48	Anjali1234	\N	6	\N	2026-01-15 12:16:16.582781	2026-01-15 14:45:42.041272	\N	\N	48	Approved	60	2026-01-15 12:16:45.72467	48	2026-01-15 12:17:12.048393	\N	MM	Incident	PRD	\N	\N	f	60
203	55	sanju nishad	sanju.nishad@orane.in	8888888888	tyes	wertyuj	Integration	Unassigned	1	\N	sanju1234	\N	6	\N	2026-01-16 12:55:58.054471	2026-01-16 12:55:58.054471	\N	\N	48	Pending	\N	\N	\N	\N	\N	Middleware	Query	PRD	\N	\N	f	55
\.


--
-- TOC entry 5010 (class 0 OID 33810)
-- Dependencies: 231
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_hash, role_id, phone, department, organization, associated_account, is_active, created_at, account_name, agent_type, delivery_lead_id, customer_type, manager_id, user_type, customer_id) FROM stdin;
2	Rahul Sharma	rahul@company.com	$2b$10$D6JRmcutLL6JkXGEmkjdReOl2LBZrac8V3PmADhQKBsxB1AVL9UgW	2	9876543210	IT Support	Orane	Noida office	t	2025-12-19 17:37:54.334249	\N	\N	\N	\N	\N	\N	\N
9	Kartik Singh	kartiksingh@company.com	$2b$10$LM24JS/i645MLal6GJiNJuT1MhS8YMvIHpqqZxCe9q2UKGt3YkB6C	2	9998887776	Information technology	Orane	\N	t	2025-12-26 16:57:55.324736	Kartik123	\N	\N	\N	\N	\N	\N
12	Rohit Lead	rohit.lead@company.com	$2b$10$SCPf8MAW.oVkUTra/gRoc.B3NPSqpWjeFz0QX22b44oy9FystfXrG	2	9999990001	Support	MyCompany	\N	t	2025-12-26 18:56:09.466761	rohit_lead_account	delivery_lead	\N	\N	\N	\N	\N
13	Ankit Agent	ankit.agent@company.com	$2b$10$GmSrNIlj3GPZh7PJnbXbfOqN3KosewNOFQzEXZU75Y0JPirZH/d8m	2	9999990002	Support	MyCompany	\N	t	2025-12-26 19:07:30.302804	ankit_agent_account	normal	12	\N	\N	\N	\N
4	Aryan Singh	aryan@company.com	$2b$10$OMp0c4GAadqIlzLGMPqMnOFObdlzriz4m2tmq2RYD/BmgulXUT5Z.	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-21 16:50:06.679026	\N	normal	12	\N	\N	\N	\N
10	Kartik chopra	kartikchopra@company.com	$2b$10$Ne/dOgxxSDrFYd3Awr6AFOPLWU3oVlsC/qvNdpH9G0hRidLaK70Ru	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:00:25.917818	Kartik1234	delivery_lead	\N	\N	\N	\N	\N
11	Arush Kumar	arushkumar@company.com	$2b$10$v/s.Akg1V.jHkefa7YYu9ucp6Cr5AD8Jft5zF8KnVWwBZm9xtiIFi	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:01:58.731638	Arush123	normal	10	\N	\N	\N	\N
5	Arnav saxena	arnav@company.com	$2b$10$BWviJjlN5HlVEYSCjVLBmOlB.8k4U7BJsXrHF1ccx4DVd.0NpXm6C	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 11:37:51.705179	\N	hod	\N	\N	\N	\N	\N
20	Dev sharma	devsharma@company.com	$2b$10$kL4YKzFPfj5EMYfbLxiPdurAoEGoKEDlpqSa0BhnZezAdD576Htna	2	9999999999	IT	MyCompany	\N	t	2025-12-29 12:31:21.429136	hod_account	hod	\N	\N	\N	\N	\N
23	Deepak sahani	deepushahni43@gmail.com	$2b$10$3/Xc67G.faRuBL.xdeuT6uc.JdlwWPmYI8fWun/ZdkOlTkufY8oIO	2	9999999999	IT	MyCompany	\N	t	2025-12-30 13:37:15.17653	deepak123	normal	\N	\N	\N	\N	\N
24	Super Admin	atharrv@gmail.com	$2b$10$DftmwsXdCPZ8YpD0psHFJOdJvRzPdEjloULU22WmUrSAxSS7qgZ76	2	\N	\N	\N	\N	t	2025-12-30 16:27:51.432236	\N	admin	\N	\N	\N	\N	\N
48	abhinav jain	abhinav.jain@orane.in	$2b$10$1MqOimw/bqLj9xu6FTpZIe9ZilaNwj8QS.y/uaep7NcQlfVcyZXvK	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:25:47.055866	abhinav1234	delivery_lead	\N	\N	\N	\N	\N
49	sanjeev kumar	sanjeev.kumar@orane.in	$2b$10$BoBPOdVTYOsiMPP6UMpreeD95GJCA4EBC/smi/EGoas0XcYS2wya6	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:31:56.726408	sanjeev1234	hod	\N	\N	\N	\N	\N
50	deepak sahani	deepak.sahani@orane.in	$2b$10$W5Z6gjjT7aDzkVQ9QU4GLuMLPfmK3wZ9arLn5ovg2xFI4rDxx1Uwa	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:38:12.445747	deepak1234	normal	48	\N	\N	\N	\N
61	Anjali sharma	anjalisharma1329@gmail.com	$2b$10$FRbgDaFGDHLI7f4N2QTLbeHH.BSJZcLJjBJeKa3laNJGX5hWbQNTi	2	88888888568	IT	Test Company1	\N	t	2026-01-02 11:02:26.709982	Anjali11234	admin	\N	\N	\N	\N	\N
64	gurleen kaur	samraddhigupta50@gmail.com	$2b$10$q28Hmhqzdyf0BqD5JZnIOOXHODH1GI9fr5oHeENBsbyv/oCfgwA9S	2	88888888568	IT	Orane	\N	t	2026-01-15 12:54:17.857867	gurleen1234	admin	\N	\N	\N	\N	\N
66	commonDL	commondl@gmail.com	$2b$10$55Vhu.pAKLnnOHxcLaUjruvxQT4PITplLzdIuMAKt7MeOiSAQgiZy	2	88888888568	IT	Orane	\N	t	2026-01-15 15:49:50.426453	dl1234	delivery_lead	\N	\N	\N	\N	\N
73	commonagent	commonagent@gmail.com	$2b$10$fBJu4Utols8g1/BOU9mvAe5YKJ7eqws7ISoXhSqRSjZ1VS4TSiwnm	2	88888888568	IT	Orane	\N	t	2026-01-15 16:36:25.858084	commonagent1234	normal	66	\N	\N	\N	\N
76	commonagent33	commonagent33@gmail.com	$2b$10$PA1v/HLqAz22saroG/C0VuBQGY.fLSwHKGdrSsoNHy2lAiqbr4uRW	2	88888888568	IT	Orane	\N	t	2026-01-15 22:07:35.482593	commonagent331234	normal	66	\N	\N	\N	\N
77	commonagent44	commonagent44@gmail.com	$2b$10$x1B8oqBWByQybfdo0EYoleuxeKS6aGeAMz7kTrv0uiUGXyUQwWilO	2	88888888568	IT	Orane	\N	t	2026-01-15 22:11:36.436197	commonagent441234	normal	66	\N	\N	\N	\N
78	DL	DL@gmail.com	$2b$10$A85EgLemUC9txTPbWrPJP.FmYAbXshD1yCrHVNdtep.bOIZdfCp8a	2	88888888568	SAP	Orane	\N	t	2026-01-16 14:48:18.652658	dl12345	delivery_lead	\N	\N	\N	\N	\N
79	agent1	agent1@gmail.com	$2b$10$QSayvPnlapfOJUuFy/1.C.fNS6.TTIRHfu3Q5MdxsIrYQyhCeuStG	2	88888888568	MM	Orane	\N	t	2026-01-16 14:53:47.48603	agent112345	normal	78	\N	\N	\N	\N
80	agent2	agent2@gmail.com	$2b$10$PxSAB3qwv3GQNiDhFa4oheaiG7X3BgCXMm6NJ975X2/8hD2cpqbKG	2	88888888568	SD	Orane	\N	t	2026-01-16 14:54:11.536796	agent212345	normal	78	\N	\N	\N	\N
81	agent3	agent3@gmail.com	$2b$10$.HVsRVw6t0nC1aT31rP3yek4Bn/iitf2FmyGCXMq2YZTwCpmcNQWG	2	88888888568	FI	Orane	\N	t	2026-01-16 14:54:34.880135	agent312345	normal	78	\N	\N	\N	\N
57	Atharrv Bhatnagar	atharrv1@gmail.com	$2b$10$XOAZhXo.5qHd3i0N0n86auH7C3eoyEwAn8pW/MqoBCD87Kwa/nENm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 13:02:52.732203	Atharrv1234	\N	48	customer	51	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
51	samraddhi gupta	samraddhi.gupta@orane.in	$2b$10$rGXoNPfGrUUZ7RD1qC0AW.Mol5aVC0OMKi/mZFFl5/1zG4H7PtPyq	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:21:07.487762	samraddhi1234	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
52	samraddhi gupta	samraddhisatvik@gmail.com	$2b$10$SPBYCo0/chdjPKfTPKqP2e7RzbNwjyEmfLHrhs9uxZAaQ1MrM2Wxy	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:24:34.450756	samraddhi12345	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
53	samraddhi gupta	akul.varshney@orane.in	$2b$10$CbDauuvALDHt6VObXcNkMO/QM74XRfysm79sSm55L2ke79bUkdJte	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:47:51.365674	samraddhi123415	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
54	samraddhi gupta	akul.varshney@xrstahasadasd.in	$2b$10$WgcT/kQK4MNe0Ag83UAsAOqKxxLlNAVdxm1oMuwDIUp3r5lfaYLdm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:51:26.373172	samraddhi1123415	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
60	Anjali sharma	anjali.sharma@orane.in	$2b$10$NNBFb6MIHw4CdFD/3s531evB0f6bkH79T8ujz2GHr7j/fCOsfurOS	1	88888888568	IT	Test Company1	\N	t	2026-01-02 10:57:01.946169	Anjali1234	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
55	sanju nishad	sanju.nishad@orane.in	$2b$10$k4aGXeF7SKnmDqXVhhAnCeA5Deo545KFcZJtxoqwFuOzhoNqos4F2	1	8888888888	IT	Test Company1	\N	t	2025-12-31 12:36:17.828	sanju1234	\N	48	customer	60	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
62	shivangi	shivangi1329@gmail.com	$2b$10$bgBEs6Yi88N/9xdKs/gxMOorC05b758w7BGKZYNRkvE64qKozSv4G	1	88888888568	IT	Test Company1	\N	t	2026-01-13 11:51:57.326782	shivangi11234	\N	\N	manager	\N	CUSTOMER	98041a70-66f1-4a71-9fbc-c82196c957ae
68	commonManager2	commonManager2@gmail.com	$2b$10$9Bk7nlyQA1Wg0mNKT3Xz3uBkDWW6B4v8i7NnQrkEpP38FTm5/3Tlm	1	88888888568	IT	Orane	\N	t	2026-01-15 16:03:19.11277	manager21234	\N	\N	manager	\N	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
69	commonDL2	commondl2@gmail.com	$2b$10$GL0j0vXgmSP0DnVgr8BI9.IfoV0yq7YF.A7Hy68s5UUbhYV3fgVqW	1	88888888568	IT	Orane	\N	t	2026-01-15 16:04:10.564915	dl21234	\N	\N	manager	\N	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
67	commonManager	commonManager@gmail.com	$2b$10$t2Oo8CXCF4zZSqLsrCuvc.vsmjsD5Kwwb0FOfa5mJETgbGP7quGEC	1	88888888568	IT	Orane	\N	t	2026-01-15 15:51:47.856524	manager1234	\N	\N	manager	\N	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
70	BIBA	biba@gmail.com	$2b$10$gt4yIGzCXr8q0yRnrNKh9.hWv6DqjqKhk5V1hjyjS.D9AY2MzJUNu	1	88888888568	IT	Orane	\N	t	2026-01-15 16:10:28.034445	biba1234	\N	66	customer	67	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
71	NAMDHARI	namdhari@gmail.com	$2b$10$XLD8XfFIiutXmUUKOz2ZcOYeyYaenqa7Vq/lP2tgf286plWPhf7Ky	1	88888888568	IT	Orane	\N	t	2026-01-15 16:11:48.426764	namdhari1234	\N	66	customer	67	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
72	BHARTIexcel	bharti@gmail.com	$2b$10$Ja9660ZUQ0wVihdN8G6qX.t5bBJi2tHfmuKogjW2mkWChEfp1tfzq	1	88888888568	IT	Orane	\N	t	2026-01-15 16:13:46.580024	bharti1234	\N	66	customer	68	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
74	commonagent11	commonagent11@gmail.com	$2b$10$AfDS6TukqXsS0C9/wm397eW6w2kjbtFf3kWAlmdhcwxpRZrBZhlfe	1	88888888568	IT	Orane	\N	t	2026-01-15 17:59:34.813236	commonagent111234	\N	\N	manager	\N	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
75	commonagent22	commonagent22@gmail.com	$2b$10$S6AA9Cv6HBnng909/1WKl./.p828IixIj9LWEm1zWjMimi2BJvJS6	1	88888888568	IT	Orane	\N	t	2026-01-15 22:01:46.621444	commonagent221234	\N	\N	normal	\N	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
82	haldiram	haldiram@gmail.com	$2b$10$ORNTDChV9Kh2tjMexb4owe2fSug1sEDRCN7wPgv0FI0rk90NSLCoi	1	88888888568	FI	Orane	\N	t	2026-01-16 15:05:03.036966	haldiram12345	\N	78	customer	67	CUSTOMER	07d1cafe-2185-44f1-bb1b-aa9b797876a0
3	Amit Verma	amit@company.com	$2b$10$QV.EKnjZLIL7ngUJDNiMqOosf0UK1234wXd2zHGBtm8tJx9RmGIBe	1	9998887776	Finance	ABC Pvt Ltd	Delhi Office	t	2025-12-19 17:50:57.024508	\N	\N	\N	\N	\N	CUSTOMER	a16df7aa-305f-43b3-8de0-fcb1888cae98
6	Aryan saxena	aryansaxena@company.com	$2b$10$7YMc0pHuXI3grghCtneEKeVMNoXrTYzZCUyHU9aAVIZN/ZFCyeffy	1	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 12:26:56.758683	\N	\N	\N	\N	\N	CUSTOMER	a16df7aa-305f-43b3-8de0-fcb1888cae98
8	Ojas Verma	ojasverma@company.com	$2b$10$AeOZPVQj38hin2i4Uf0DA.odWfrGq5CqhfIt9bEkjtBsFonPm.Gpa	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-24 12:15:40.460948	Ojas123	\N	\N	manager	\N	CUSTOMER	a16df7aa-305f-43b3-8de0-fcb1888cae98
7	Akshay tiwari	akshaytiwari@company.com	$2b$10$b3XCSPjfVwwUF/DxYhFk.uTz/dqqfwmQemjLN4mHCKBD/NeB6jFVO	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-23 12:56:16.515572	Akshay123	\N	10	customer	8	CUSTOMER	a16df7aa-305f-43b3-8de0-fcb1888cae98
14	Amit Verma	amit.customer@company.com	$2b$10$Yod9v/69HMHTb7lry5yvQOPn.hDg3fytdCsn9c2UnufglyK.TQhNO	1	9999990003	HR	MyCompany	\N	t	2025-12-26 19:09:51.941577	amit_account	\N	\N	\N	\N	CUSTOMER	7e634209-31d2-4bf4-a5b5-402ac47164e3
18	Test customer	customer@company.com	$2b$10$f2BCWy.S0U5eRevoFHvgZOnmQNQ.lvjALKSWf0zBDAfELpPb1gBkm	1	9999999999	IT	MyCompany	\N	t	2025-12-28 12:10:39.131301	admin_account	\N	12	\N	\N	CUSTOMER	7e634209-31d2-4bf4-a5b5-402ac47164e3
\.


--
-- TOC entry 5011 (class 0 OID 33818)
-- Dependencies: 232
-- Data for Name: users_backup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_backup (id, name, email, password_hash, role_id, phone, department, organization, associated_account, is_active, created_at, account_name, agent_type, delivery_lead_id, customer_type, manager_id, customer_id, user_type) FROM stdin;
2	Rahul Sharma	rahul@company.com	$2b$10$D6JRmcutLL6JkXGEmkjdReOl2LBZrac8V3PmADhQKBsxB1AVL9UgW	2	9876543210	IT Support	Orane	Noida office	t	2025-12-19 17:37:54.334249	\N	\N	\N	\N	\N	\N	\N
3	Amit Verma	amit@company.com	$2b$10$QV.EKnjZLIL7ngUJDNiMqOosf0UK1234wXd2zHGBtm8tJx9RmGIBe	1	9998887776	Finance	ABC Pvt Ltd	Delhi Office	t	2025-12-19 17:50:57.024508	\N	\N	\N	\N	\N	\N	\N
6	Aryan saxena	aryansaxena@company.com	$2b$10$7YMc0pHuXI3grghCtneEKeVMNoXrTYzZCUyHU9aAVIZN/ZFCyeffy	1	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 12:26:56.758683	\N	\N	\N	\N	\N	\N	\N
9	Kartik Singh	kartiksingh@company.com	$2b$10$LM24JS/i645MLal6GJiNJuT1MhS8YMvIHpqqZxCe9q2UKGt3YkB6C	2	9998887776	Information technology	Orane	\N	t	2025-12-26 16:57:55.324736	Kartik123	\N	\N	\N	\N	\N	\N
14	Amit Verma	amit.customer@company.com	$2b$10$Yod9v/69HMHTb7lry5yvQOPn.hDg3fytdCsn9c2UnufglyK.TQhNO	1	9999990003	HR	MyCompany	\N	t	2025-12-26 19:09:51.941577	amit_account	\N	\N	\N	\N	\N	\N
12	Rohit Lead	rohit.lead@company.com	$2b$10$SCPf8MAW.oVkUTra/gRoc.B3NPSqpWjeFz0QX22b44oy9FystfXrG	2	9999990001	Support	MyCompany	\N	t	2025-12-26 18:56:09.466761	rohit_lead_account	delivery_lead	\N	\N	\N	\N	\N
13	Ankit Agent	ankit.agent@company.com	$2b$10$GmSrNIlj3GPZh7PJnbXbfOqN3KosewNOFQzEXZU75Y0JPirZH/d8m	2	9999990002	Support	MyCompany	\N	t	2025-12-26 19:07:30.302804	ankit_agent_account	normal	12	\N	\N	\N	\N
4	Aryan Singh	aryan@company.com	$2b$10$OMp0c4GAadqIlzLGMPqMnOFObdlzriz4m2tmq2RYD/BmgulXUT5Z.	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-21 16:50:06.679026	\N	normal	12	\N	\N	\N	\N
18	Test customer	customer@company.com	$2b$10$f2BCWy.S0U5eRevoFHvgZOnmQNQ.lvjALKSWf0zBDAfELpPb1gBkm	1	9999999999	IT	MyCompany	\N	t	2025-12-28 12:10:39.131301	admin_account	\N	12	\N	\N	\N	\N
10	Kartik chopra	kartikchopra@company.com	$2b$10$Ne/dOgxxSDrFYd3Awr6AFOPLWU3oVlsC/qvNdpH9G0hRidLaK70Ru	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:00:25.917818	Kartik1234	delivery_lead	\N	\N	\N	\N	\N
11	Arush Kumar	arushkumar@company.com	$2b$10$v/s.Akg1V.jHkefa7YYu9ucp6Cr5AD8Jft5zF8KnVWwBZm9xtiIFi	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:01:58.731638	Arush123	normal	10	\N	\N	\N	\N
8	Ojas Verma	ojasverma@company.com	$2b$10$AeOZPVQj38hin2i4Uf0DA.odWfrGq5CqhfIt9bEkjtBsFonPm.Gpa	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-24 12:15:40.460948	Ojas123	\N	\N	manager	\N	\N	\N
7	Akshay tiwari	akshaytiwari@company.com	$2b$10$b3XCSPjfVwwUF/DxYhFk.uTz/dqqfwmQemjLN4mHCKBD/NeB6jFVO	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-23 12:56:16.515572	Akshay123	\N	10	customer	8	\N	\N
5	Arnav saxena	arnav@company.com	$2b$10$BWviJjlN5HlVEYSCjVLBmOlB.8k4U7BJsXrHF1ccx4DVd.0NpXm6C	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 11:37:51.705179	\N	hod	\N	\N	\N	\N	\N
20	Dev sharma	devsharma@company.com	$2b$10$kL4YKzFPfj5EMYfbLxiPdurAoEGoKEDlpqSa0BhnZezAdD576Htna	2	9999999999	IT	MyCompany	\N	t	2025-12-29 12:31:21.429136	hod_account	hod	\N	\N	\N	\N	\N
23	Deepak sahani	deepushahni43@gmail.com	$2b$10$3/Xc67G.faRuBL.xdeuT6uc.JdlwWPmYI8fWun/ZdkOlTkufY8oIO	2	9999999999	IT	MyCompany	\N	t	2025-12-30 13:37:15.17653	deepak123	normal	\N	\N	\N	\N	\N
24	Super Admin	atharrv@gmail.com	$2b$10$DftmwsXdCPZ8YpD0psHFJOdJvRzPdEjloULU22WmUrSAxSS7qgZ76	2	\N	\N	\N	\N	t	2025-12-30 16:27:51.432236	\N	admin	\N	\N	\N	\N	\N
57	Atharrv Bhatnagar	atharrv1@gmail.com	$2b$10$XOAZhXo.5qHd3i0N0n86auH7C3eoyEwAn8pW/MqoBCD87Kwa/nENm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 13:02:52.732203	Atharrv1234	\N	48	customer	51	\N	\N
48	abhinav jain	abhinav.jain@orane.in	$2b$10$1MqOimw/bqLj9xu6FTpZIe9ZilaNwj8QS.y/uaep7NcQlfVcyZXvK	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:25:47.055866	abhinav1234	delivery_lead	\N	\N	\N	\N	\N
49	sanjeev kumar	sanjeev.kumar@orane.in	$2b$10$BoBPOdVTYOsiMPP6UMpreeD95GJCA4EBC/smi/EGoas0XcYS2wya6	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:31:56.726408	sanjeev1234	hod	\N	\N	\N	\N	\N
50	deepak sahani	deepak.sahani@orane.in	$2b$10$W5Z6gjjT7aDzkVQ9QU4GLuMLPfmK3wZ9arLn5ovg2xFI4rDxx1Uwa	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:38:12.445747	deepak1234	normal	48	\N	\N	\N	\N
51	samraddhi gupta	samraddhi.gupta@orane.in	$2b$10$rGXoNPfGrUUZ7RD1qC0AW.Mol5aVC0OMKi/mZFFl5/1zG4H7PtPyq	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:21:07.487762	samraddhi1234	\N	\N	manager	\N	\N	\N
52	samraddhi gupta	samraddhisatvik@gmail.com	$2b$10$SPBYCo0/chdjPKfTPKqP2e7RzbNwjyEmfLHrhs9uxZAaQ1MrM2Wxy	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:24:34.450756	samraddhi12345	\N	\N	manager	\N	\N	\N
53	samraddhi gupta	akul.varshney@orane.in	$2b$10$CbDauuvALDHt6VObXcNkMO/QM74XRfysm79sSm55L2ke79bUkdJte	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:47:51.365674	samraddhi123415	\N	\N	manager	\N	\N	\N
54	samraddhi gupta	akul.varshney@xrstahasadasd.in	$2b$10$WgcT/kQK4MNe0Ag83UAsAOqKxxLlNAVdxm1oMuwDIUp3r5lfaYLdm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:51:26.373172	samraddhi1123415	\N	\N	manager	\N	\N	\N
68	commonManager2	commonManager2@gmail.com	$2b$10$9Bk7nlyQA1Wg0mNKT3Xz3uBkDWW6B4v8i7NnQrkEpP38FTm5/3Tlm	1	88888888568	IT	Orane	\N	t	2026-01-15 16:03:19.11277	manager21234	\N	\N	manager	\N	\N	\N
60	Anjali sharma	anjali.sharma@orane.in	$2b$10$NNBFb6MIHw4CdFD/3s531evB0f6bkH79T8ujz2GHr7j/fCOsfurOS	1	88888888568	IT	Test Company1	\N	t	2026-01-02 10:57:01.946169	Anjali1234	\N	\N	manager	\N	\N	\N
61	Anjali sharma	anjalisharma1329@gmail.com	$2b$10$FRbgDaFGDHLI7f4N2QTLbeHH.BSJZcLJjBJeKa3laNJGX5hWbQNTi	2	88888888568	IT	Test Company1	\N	t	2026-01-02 11:02:26.709982	Anjali11234	admin	\N	\N	\N	\N	\N
69	commonDL2	commondl2@gmail.com	$2b$10$GL0j0vXgmSP0DnVgr8BI9.IfoV0yq7YF.A7Hy68s5UUbhYV3fgVqW	1	88888888568	IT	Orane	\N	t	2026-01-15 16:04:10.564915	dl21234	\N	\N	manager	\N	\N	\N
55	sanju nishad	sanju.nishad@orane.in	$2b$10$k4aGXeF7SKnmDqXVhhAnCeA5Deo545KFcZJtxoqwFuOzhoNqos4F2	1	8888888888	IT	Test Company1	\N	t	2025-12-31 12:36:17.828	sanju1234	\N	48	customer	60	\N	\N
62	shivangi	shivangi1329@gmail.com	$2b$10$bgBEs6Yi88N/9xdKs/gxMOorC05b758w7BGKZYNRkvE64qKozSv4G	1	88888888568	IT	Test Company1	\N	t	2026-01-13 11:51:57.326782	shivangi11234	\N	\N	manager	\N	\N	\N
64	gurleen kaur	samraddhigupta50@gmail.com	$2b$10$q28Hmhqzdyf0BqD5JZnIOOXHODH1GI9fr5oHeENBsbyv/oCfgwA9S	2	88888888568	IT	Orane	\N	t	2026-01-15 12:54:17.857867	gurleen1234	admin	\N	\N	\N	\N	\N
66	commonDL	commondl@gmail.com	$2b$10$55Vhu.pAKLnnOHxcLaUjruvxQT4PITplLzdIuMAKt7MeOiSAQgiZy	2	88888888568	IT	Orane	\N	t	2026-01-15 15:49:50.426453	dl1234	delivery_lead	\N	\N	\N	\N	\N
67	commonManager	commonManager@gmail.com	$2b$10$t2Oo8CXCF4zZSqLsrCuvc.vsmjsD5Kwwb0FOfa5mJETgbGP7quGEC	1	88888888568	IT	Orane	\N	t	2026-01-15 15:51:47.856524	manager1234	\N	\N	manager	\N	\N	\N
70	BIBA	biba@gmail.com	$2b$10$gt4yIGzCXr8q0yRnrNKh9.hWv6DqjqKhk5V1hjyjS.D9AY2MzJUNu	1	88888888568	IT	Orane	\N	t	2026-01-15 16:10:28.034445	biba1234	\N	66	customer	67	\N	\N
71	NAMDHARI	namdhari@gmail.com	$2b$10$XLD8XfFIiutXmUUKOz2ZcOYeyYaenqa7Vq/lP2tgf286plWPhf7Ky	1	88888888568	IT	Orane	\N	t	2026-01-15 16:11:48.426764	namdhari1234	\N	66	customer	67	\N	\N
72	BHARTIexcel	bharti@gmail.com	$2b$10$Ja9660ZUQ0wVihdN8G6qX.t5bBJi2tHfmuKogjW2mkWChEfp1tfzq	1	88888888568	IT	Orane	\N	t	2026-01-15 16:13:46.580024	bharti1234	\N	66	customer	68	\N	\N
73	commonagent	commonagent@gmail.com	$2b$10$fBJu4Utols8g1/BOU9mvAe5YKJ7eqws7ISoXhSqRSjZ1VS4TSiwnm	2	88888888568	IT	Orane	\N	t	2026-01-15 16:36:25.858084	commonagent1234	normal	66	\N	\N	\N	\N
74	commonagent11	commonagent11@gmail.com	$2b$10$AfDS6TukqXsS0C9/wm397eW6w2kjbtFf3kWAlmdhcwxpRZrBZhlfe	1	88888888568	IT	Orane	\N	t	2026-01-15 17:59:34.813236	commonagent111234	\N	\N	manager	\N	\N	\N
75	commonagent22	commonagent22@gmail.com	$2b$10$S6AA9Cv6HBnng909/1WKl./.p828IixIj9LWEm1zWjMimi2BJvJS6	1	88888888568	IT	Orane	\N	t	2026-01-15 22:01:46.621444	commonagent221234	\N	\N	normal	\N	\N	\N
76	commonagent33	commonagent33@gmail.com	$2b$10$PA1v/HLqAz22saroG/C0VuBQGY.fLSwHKGdrSsoNHy2lAiqbr4uRW	2	88888888568	IT	Orane	\N	t	2026-01-15 22:07:35.482593	commonagent331234	normal	66	\N	\N	\N	\N
77	commonagent44	commonagent44@gmail.com	$2b$10$x1B8oqBWByQybfdo0EYoleuxeKS6aGeAMz7kTrv0uiUGXyUQwWilO	2	88888888568	IT	Orane	\N	t	2026-01-15 22:11:36.436197	commonagent441234	normal	66	\N	\N	\N	\N
78	DL	DL@gmail.com	$2b$10$A85EgLemUC9txTPbWrPJP.FmYAbXshD1yCrHVNdtep.bOIZdfCp8a	2	88888888568	SAP	Orane	\N	t	2026-01-16 14:48:18.652658	dl12345	delivery_lead	\N	\N	\N	\N	\N
79	agent1	agent1@gmail.com	$2b$10$QSayvPnlapfOJUuFy/1.C.fNS6.TTIRHfu3Q5MdxsIrYQyhCeuStG	2	88888888568	MM	Orane	\N	t	2026-01-16 14:53:47.48603	agent112345	normal	78	\N	\N	\N	\N
80	agent2	agent2@gmail.com	$2b$10$PxSAB3qwv3GQNiDhFa4oheaiG7X3BgCXMm6NJ975X2/8hD2cpqbKG	2	88888888568	SD	Orane	\N	t	2026-01-16 14:54:11.536796	agent212345	normal	78	\N	\N	\N	\N
81	agent3	agent3@gmail.com	$2b$10$.HVsRVw6t0nC1aT31rP3yek4Bn/iitf2FmyGCXMq2YZTwCpmcNQWG	2	88888888568	FI	Orane	\N	t	2026-01-16 14:54:34.880135	agent312345	normal	78	\N	\N	\N	\N
82	haldiram	haldiram@gmail.com	$2b$10$ORNTDChV9Kh2tjMexb4owe2fSug1sEDRCN7wPgv0FI0rk90NSLCoi	1	88888888568	FI	Orane	\N	t	2026-01-16 15:05:03.036966	haldiram12345	\N	78	customer	67	\N	\N
2	Rahul Sharma	rahul@company.com	$2b$10$D6JRmcutLL6JkXGEmkjdReOl2LBZrac8V3PmADhQKBsxB1AVL9UgW	2	9876543210	IT Support	Orane	Noida office	t	2025-12-19 17:37:54.334249	\N	\N	\N	\N	\N	\N	\N
3	Amit Verma	amit@company.com	$2b$10$QV.EKnjZLIL7ngUJDNiMqOosf0UK1234wXd2zHGBtm8tJx9RmGIBe	1	9998887776	Finance	ABC Pvt Ltd	Delhi Office	t	2025-12-19 17:50:57.024508	\N	\N	\N	\N	\N	\N	\N
6	Aryan saxena	aryansaxena@company.com	$2b$10$7YMc0pHuXI3grghCtneEKeVMNoXrTYzZCUyHU9aAVIZN/ZFCyeffy	1	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 12:26:56.758683	\N	\N	\N	\N	\N	\N	\N
9	Kartik Singh	kartiksingh@company.com	$2b$10$LM24JS/i645MLal6GJiNJuT1MhS8YMvIHpqqZxCe9q2UKGt3YkB6C	2	9998887776	Information technology	Orane	\N	t	2025-12-26 16:57:55.324736	Kartik123	\N	\N	\N	\N	\N	\N
14	Amit Verma	amit.customer@company.com	$2b$10$Yod9v/69HMHTb7lry5yvQOPn.hDg3fytdCsn9c2UnufglyK.TQhNO	1	9999990003	HR	MyCompany	\N	t	2025-12-26 19:09:51.941577	amit_account	\N	\N	\N	\N	\N	\N
12	Rohit Lead	rohit.lead@company.com	$2b$10$SCPf8MAW.oVkUTra/gRoc.B3NPSqpWjeFz0QX22b44oy9FystfXrG	2	9999990001	Support	MyCompany	\N	t	2025-12-26 18:56:09.466761	rohit_lead_account	delivery_lead	\N	\N	\N	\N	\N
13	Ankit Agent	ankit.agent@company.com	$2b$10$GmSrNIlj3GPZh7PJnbXbfOqN3KosewNOFQzEXZU75Y0JPirZH/d8m	2	9999990002	Support	MyCompany	\N	t	2025-12-26 19:07:30.302804	ankit_agent_account	normal	12	\N	\N	\N	\N
4	Aryan Singh	aryan@company.com	$2b$10$OMp0c4GAadqIlzLGMPqMnOFObdlzriz4m2tmq2RYD/BmgulXUT5Z.	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-21 16:50:06.679026	\N	normal	12	\N	\N	\N	\N
18	Test customer	customer@company.com	$2b$10$f2BCWy.S0U5eRevoFHvgZOnmQNQ.lvjALKSWf0zBDAfELpPb1gBkm	1	9999999999	IT	MyCompany	\N	t	2025-12-28 12:10:39.131301	admin_account	\N	12	\N	\N	\N	\N
10	Kartik chopra	kartikchopra@company.com	$2b$10$Ne/dOgxxSDrFYd3Awr6AFOPLWU3oVlsC/qvNdpH9G0hRidLaK70Ru	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:00:25.917818	Kartik1234	delivery_lead	\N	\N	\N	\N	\N
11	Arush Kumar	arushkumar@company.com	$2b$10$v/s.Akg1V.jHkefa7YYu9ucp6Cr5AD8Jft5zF8KnVWwBZm9xtiIFi	2	9998887776	Information technology	Orane	\N	t	2025-12-26 17:01:58.731638	Arush123	normal	10	\N	\N	\N	\N
8	Ojas Verma	ojasverma@company.com	$2b$10$AeOZPVQj38hin2i4Uf0DA.odWfrGq5CqhfIt9bEkjtBsFonPm.Gpa	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-24 12:15:40.460948	Ojas123	\N	\N	manager	\N	\N	\N
7	Akshay tiwari	akshaytiwari@company.com	$2b$10$b3XCSPjfVwwUF/DxYhFk.uTz/dqqfwmQemjLN4mHCKBD/NeB6jFVO	1	9998887776	Education	ABC Pvt Ltd	\N	t	2025-12-23 12:56:16.515572	Akshay123	\N	10	customer	8	\N	\N
5	Arnav saxena	arnav@company.com	$2b$10$BWviJjlN5HlVEYSCjVLBmOlB.8k4U7BJsXrHF1ccx4DVd.0NpXm6C	2	9998887776	Education	ABC Pvt Ltd	Delhi Office	t	2025-12-22 11:37:51.705179	\N	hod	\N	\N	\N	\N	\N
20	Dev sharma	devsharma@company.com	$2b$10$kL4YKzFPfj5EMYfbLxiPdurAoEGoKEDlpqSa0BhnZezAdD576Htna	2	9999999999	IT	MyCompany	\N	t	2025-12-29 12:31:21.429136	hod_account	hod	\N	\N	\N	\N	\N
23	Deepak sahani	deepushahni43@gmail.com	$2b$10$3/Xc67G.faRuBL.xdeuT6uc.JdlwWPmYI8fWun/ZdkOlTkufY8oIO	2	9999999999	IT	MyCompany	\N	t	2025-12-30 13:37:15.17653	deepak123	normal	\N	\N	\N	\N	\N
24	Super Admin	atharrv@gmail.com	$2b$10$DftmwsXdCPZ8YpD0psHFJOdJvRzPdEjloULU22WmUrSAxSS7qgZ76	2	\N	\N	\N	\N	t	2025-12-30 16:27:51.432236	\N	admin	\N	\N	\N	\N	\N
57	Atharrv Bhatnagar	atharrv1@gmail.com	$2b$10$XOAZhXo.5qHd3i0N0n86auH7C3eoyEwAn8pW/MqoBCD87Kwa/nENm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 13:02:52.732203	Atharrv1234	\N	48	customer	51	\N	\N
48	abhinav jain	abhinav.jain@orane.in	$2b$10$1MqOimw/bqLj9xu6FTpZIe9ZilaNwj8QS.y/uaep7NcQlfVcyZXvK	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:25:47.055866	abhinav1234	delivery_lead	\N	\N	\N	\N	\N
49	sanjeev kumar	sanjeev.kumar@orane.in	$2b$10$BoBPOdVTYOsiMPP6UMpreeD95GJCA4EBC/smi/EGoas0XcYS2wya6	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:31:56.726408	sanjeev1234	hod	\N	\N	\N	\N	\N
50	deepak sahani	deepak.sahani@orane.in	$2b$10$W5Z6gjjT7aDzkVQ9QU4GLuMLPfmK3wZ9arLn5ovg2xFI4rDxx1Uwa	2	8888888888	IT	Test Company1	\N	t	2025-12-31 10:38:12.445747	deepak1234	normal	48	\N	\N	\N	\N
51	samraddhi gupta	samraddhi.gupta@orane.in	$2b$10$rGXoNPfGrUUZ7RD1qC0AW.Mol5aVC0OMKi/mZFFl5/1zG4H7PtPyq	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:21:07.487762	samraddhi1234	\N	\N	manager	\N	\N	\N
52	samraddhi gupta	samraddhisatvik@gmail.com	$2b$10$SPBYCo0/chdjPKfTPKqP2e7RzbNwjyEmfLHrhs9uxZAaQ1MrM2Wxy	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:24:34.450756	samraddhi12345	\N	\N	manager	\N	\N	\N
53	samraddhi gupta	akul.varshney@orane.in	$2b$10$CbDauuvALDHt6VObXcNkMO/QM74XRfysm79sSm55L2ke79bUkdJte	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:47:51.365674	samraddhi123415	\N	\N	manager	\N	\N	\N
54	samraddhi gupta	akul.varshney@xrstahasadasd.in	$2b$10$WgcT/kQK4MNe0Ag83UAsAOqKxxLlNAVdxm1oMuwDIUp3r5lfaYLdm	1	8888888888	IT	Test Company1	\N	t	2025-12-31 11:51:26.373172	samraddhi1123415	\N	\N	manager	\N	\N	\N
68	commonManager2	commonManager2@gmail.com	$2b$10$9Bk7nlyQA1Wg0mNKT3Xz3uBkDWW6B4v8i7NnQrkEpP38FTm5/3Tlm	1	88888888568	IT	Orane	\N	t	2026-01-15 16:03:19.11277	manager21234	\N	\N	manager	\N	\N	\N
60	Anjali sharma	anjali.sharma@orane.in	$2b$10$NNBFb6MIHw4CdFD/3s531evB0f6bkH79T8ujz2GHr7j/fCOsfurOS	1	88888888568	IT	Test Company1	\N	t	2026-01-02 10:57:01.946169	Anjali1234	\N	\N	manager	\N	\N	\N
61	Anjali sharma	anjalisharma1329@gmail.com	$2b$10$FRbgDaFGDHLI7f4N2QTLbeHH.BSJZcLJjBJeKa3laNJGX5hWbQNTi	2	88888888568	IT	Test Company1	\N	t	2026-01-02 11:02:26.709982	Anjali11234	admin	\N	\N	\N	\N	\N
69	commonDL2	commondl2@gmail.com	$2b$10$GL0j0vXgmSP0DnVgr8BI9.IfoV0yq7YF.A7Hy68s5UUbhYV3fgVqW	1	88888888568	IT	Orane	\N	t	2026-01-15 16:04:10.564915	dl21234	\N	\N	manager	\N	\N	\N
55	sanju nishad	sanju.nishad@orane.in	$2b$10$k4aGXeF7SKnmDqXVhhAnCeA5Deo545KFcZJtxoqwFuOzhoNqos4F2	1	8888888888	IT	Test Company1	\N	t	2025-12-31 12:36:17.828	sanju1234	\N	48	customer	60	\N	\N
62	shivangi	shivangi1329@gmail.com	$2b$10$bgBEs6Yi88N/9xdKs/gxMOorC05b758w7BGKZYNRkvE64qKozSv4G	1	88888888568	IT	Test Company1	\N	t	2026-01-13 11:51:57.326782	shivangi11234	\N	\N	manager	\N	\N	\N
64	gurleen kaur	samraddhigupta50@gmail.com	$2b$10$q28Hmhqzdyf0BqD5JZnIOOXHODH1GI9fr5oHeENBsbyv/oCfgwA9S	2	88888888568	IT	Orane	\N	t	2026-01-15 12:54:17.857867	gurleen1234	admin	\N	\N	\N	\N	\N
66	commonDL	commondl@gmail.com	$2b$10$55Vhu.pAKLnnOHxcLaUjruvxQT4PITplLzdIuMAKt7MeOiSAQgiZy	2	88888888568	IT	Orane	\N	t	2026-01-15 15:49:50.426453	dl1234	delivery_lead	\N	\N	\N	\N	\N
67	commonManager	commonManager@gmail.com	$2b$10$t2Oo8CXCF4zZSqLsrCuvc.vsmjsD5Kwwb0FOfa5mJETgbGP7quGEC	1	88888888568	IT	Orane	\N	t	2026-01-15 15:51:47.856524	manager1234	\N	\N	manager	\N	\N	\N
70	BIBA	biba@gmail.com	$2b$10$gt4yIGzCXr8q0yRnrNKh9.hWv6DqjqKhk5V1hjyjS.D9AY2MzJUNu	1	88888888568	IT	Orane	\N	t	2026-01-15 16:10:28.034445	biba1234	\N	66	customer	67	\N	\N
71	NAMDHARI	namdhari@gmail.com	$2b$10$XLD8XfFIiutXmUUKOz2ZcOYeyYaenqa7Vq/lP2tgf286plWPhf7Ky	1	88888888568	IT	Orane	\N	t	2026-01-15 16:11:48.426764	namdhari1234	\N	66	customer	67	\N	\N
72	BHARTIexcel	bharti@gmail.com	$2b$10$Ja9660ZUQ0wVihdN8G6qX.t5bBJi2tHfmuKogjW2mkWChEfp1tfzq	1	88888888568	IT	Orane	\N	t	2026-01-15 16:13:46.580024	bharti1234	\N	66	customer	68	\N	\N
73	commonagent	commonagent@gmail.com	$2b$10$fBJu4Utols8g1/BOU9mvAe5YKJ7eqws7ISoXhSqRSjZ1VS4TSiwnm	2	88888888568	IT	Orane	\N	t	2026-01-15 16:36:25.858084	commonagent1234	normal	66	\N	\N	\N	\N
74	commonagent11	commonagent11@gmail.com	$2b$10$AfDS6TukqXsS0C9/wm397eW6w2kjbtFf3kWAlmdhcwxpRZrBZhlfe	1	88888888568	IT	Orane	\N	t	2026-01-15 17:59:34.813236	commonagent111234	\N	\N	manager	\N	\N	\N
75	commonagent22	commonagent22@gmail.com	$2b$10$S6AA9Cv6HBnng909/1WKl./.p828IixIj9LWEm1zWjMimi2BJvJS6	1	88888888568	IT	Orane	\N	t	2026-01-15 22:01:46.621444	commonagent221234	\N	\N	normal	\N	\N	\N
76	commonagent33	commonagent33@gmail.com	$2b$10$PA1v/HLqAz22saroG/C0VuBQGY.fLSwHKGdrSsoNHy2lAiqbr4uRW	2	88888888568	IT	Orane	\N	t	2026-01-15 22:07:35.482593	commonagent331234	normal	66	\N	\N	\N	\N
77	commonagent44	commonagent44@gmail.com	$2b$10$x1B8oqBWByQybfdo0EYoleuxeKS6aGeAMz7kTrv0uiUGXyUQwWilO	2	88888888568	IT	Orane	\N	t	2026-01-15 22:11:36.436197	commonagent441234	normal	66	\N	\N	\N	\N
78	DL	DL@gmail.com	$2b$10$A85EgLemUC9txTPbWrPJP.FmYAbXshD1yCrHVNdtep.bOIZdfCp8a	2	88888888568	SAP	Orane	\N	t	2026-01-16 14:48:18.652658	dl12345	delivery_lead	\N	\N	\N	\N	\N
79	agent1	agent1@gmail.com	$2b$10$QSayvPnlapfOJUuFy/1.C.fNS6.TTIRHfu3Q5MdxsIrYQyhCeuStG	2	88888888568	MM	Orane	\N	t	2026-01-16 14:53:47.48603	agent112345	normal	78	\N	\N	\N	\N
80	agent2	agent2@gmail.com	$2b$10$PxSAB3qwv3GQNiDhFa4oheaiG7X3BgCXMm6NJ975X2/8hD2cpqbKG	2	88888888568	SD	Orane	\N	t	2026-01-16 14:54:11.536796	agent212345	normal	78	\N	\N	\N	\N
81	agent3	agent3@gmail.com	$2b$10$.HVsRVw6t0nC1aT31rP3yek4Bn/iitf2FmyGCXMq2YZTwCpmcNQWG	2	88888888568	FI	Orane	\N	t	2026-01-16 14:54:34.880135	agent312345	normal	78	\N	\N	\N	\N
82	haldiram	haldiram@gmail.com	$2b$10$ORNTDChV9Kh2tjMexb4owe2fSug1sEDRCN7wPgv0FI0rk90NSLCoi	1	88888888568	FI	Orane	\N	t	2026-01-16 15:05:03.036966	haldiram12345	\N	78	customer	67	\N	\N
\.


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 219
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 212, true);


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 221
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 223
-- Name: ticket_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_attachments_id_seq', 46, true);


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 225
-- Name: ticket_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_comments_id_seq', 13, true);


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 227
-- Name: ticket_status_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ticket_status_logs_id_seq', 35, true);


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 230
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 208, true);


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 233
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 82, true);


--
-- TOC entry 4812 (class 2606 OID 33832)
-- Name: customers customers_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_customer_code_key UNIQUE (customer_code);


--
-- TOC entry 4814 (class 2606 OID 33834)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 33836)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 33838)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 33840)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 4822 (class 2606 OID 33842)
-- Name: ticket_attachments ticket_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_attachments
    ADD CONSTRAINT ticket_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 33844)
-- Name: ticket_comments ticket_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 33846)
-- Name: ticket_status_logs ticket_status_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_status_logs
    ADD CONSTRAINT ticket_status_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 33848)
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4830 (class 2606 OID 33850)
-- Name: users users_account_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_unique UNIQUE (account_name);


--
-- TOC entry 4832 (class 2606 OID 33852)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4834 (class 2606 OID 33854)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 33855)
-- Name: ticket_attachments fk_uploaded_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_attachments
    ADD CONSTRAINT fk_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- TOC entry 4835 (class 2606 OID 33860)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4837 (class 2606 OID 33865)
-- Name: ticket_attachments ticket_attachments_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_attachments
    ADD CONSTRAINT ticket_attachments_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id) ON DELETE CASCADE;


--
-- TOC entry 4838 (class 2606 OID 33870)
-- Name: ticket_comments ticket_comments_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id) ON DELETE CASCADE;


--
-- TOC entry 4839 (class 2606 OID 33875)
-- Name: ticket_comments ticket_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_comments
    ADD CONSTRAINT ticket_comments_user_id_fkey FOREIGN KEY (commented_by) REFERENCES public.users(id);


--
-- TOC entry 4840 (class 2606 OID 33880)
-- Name: ticket_status_logs ticket_status_logs_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_status_logs
    ADD CONSTRAINT ticket_status_logs_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- TOC entry 4841 (class 2606 OID 33885)
-- Name: ticket_status_logs ticket_status_logs_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket_status_logs
    ADD CONSTRAINT ticket_status_logs_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id) ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 33890)
-- Name: tickets tickets_account_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_account_name_fkey FOREIGN KEY (account_name) REFERENCES public.users(account_name);


--
-- TOC entry 4843 (class 2606 OID 33895)
-- Name: tickets tickets_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 4844 (class 2606 OID 33900)
-- Name: tickets tickets_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4845 (class 2606 OID 33905)
-- Name: tickets tickets_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id);


--
-- TOC entry 4846 (class 2606 OID 33910)
-- Name: tickets tickets_delivery_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_delivery_lead_id_fkey FOREIGN KEY (delivery_lead_id) REFERENCES public.users(id);


--
-- TOC entry 4847 (class 2606 OID 33915)
-- Name: tickets tickets_escalated_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_escalated_to_fkey FOREIGN KEY (escalated_to) REFERENCES public.users(id);


--
-- TOC entry 4848 (class 2606 OID 33920)
-- Name: users users_delivery_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_delivery_lead_id_fkey FOREIGN KEY (delivery_lead_id) REFERENCES public.users(id);


--
-- TOC entry 4849 (class 2606 OID 33925)
-- Name: users users_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4850 (class 2606 OID 33930)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-03-17 00:44:52

--
-- PostgreSQL database dump complete
--


ALTER DATABASE new_ticket SET search_path TO public;
