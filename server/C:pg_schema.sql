--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Homebrew)
-- Dumped by pg_dump version 16.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: enum_Users_role; Type: TYPE; Schema: public; Owner: studymate_user
--

CREATE TYPE public."enum_Users_role" AS ENUM (
    'student',
    'course_rep'
);


ALTER TYPE public."enum_Users_role" OWNER TO studymate_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ClassroomStudents; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."ClassroomStudents" (
    classroom_id uuid NOT NULL,
    student_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."ClassroomStudents" OWNER TO studymate_user;

--
-- Name: Classrooms; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."Classrooms" (
    classroom_id uuid NOT NULL,
    level integer NOT NULL,
    department character varying(255) NOT NULL,
    join_code character varying(255) NOT NULL,
    course_rep_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    session character varying(255) NOT NULL
);


ALTER TABLE public."Classrooms" OWNER TO studymate_user;

--
-- Name: CourseSections; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."CourseSections" (
    course_section_id integer NOT NULL,
    course_title character varying(255) NOT NULL,
    course_code character varying(255) NOT NULL,
    classroom_id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."CourseSections" OWNER TO studymate_user;

--
-- Name: CourseSections_course_section_id_seq; Type: SEQUENCE; Schema: public; Owner: studymate_user
--

CREATE SEQUENCE public."CourseSections_course_section_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CourseSections_course_section_id_seq" OWNER TO studymate_user;

--
-- Name: CourseSections_course_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: studymate_user
--

ALTER SEQUENCE public."CourseSections_course_section_id_seq" OWNED BY public."CourseSections".course_section_id;


--
-- Name: Leaderboards; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."Leaderboards" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    classroom_id uuid NOT NULL,
    current_streak integer DEFAULT 0 NOT NULL,
    highest_streak integer DEFAULT 0 NOT NULL,
    total_active_days integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Leaderboards" OWNER TO studymate_user;

--
-- Name: Leaderboards_id_seq; Type: SEQUENCE; Schema: public; Owner: studymate_user
--

CREATE SEQUENCE public."Leaderboards_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Leaderboards_id_seq" OWNER TO studymate_user;

--
-- Name: Leaderboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: studymate_user
--

ALTER SEQUENCE public."Leaderboards_id_seq" OWNED BY public."Leaderboards".id;


--
-- Name: PastQuestions; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."PastQuestions" (
    past_question_id uuid NOT NULL,
    past_question_name character varying(255) NOT NULL,
    course_section_id integer NOT NULL,
    file_names character varying(255)[] NOT NULL,
    file_urls character varying(255)[] NOT NULL,
    classroom_id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."PastQuestions" OWNER TO studymate_user;

--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO studymate_user;

--
-- Name: Slides; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."Slides" (
    slide_id uuid NOT NULL,
    slide_number integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url character varying(255) NOT NULL,
    course_section_id integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    slide_name text,
    classroom_id uuid NOT NULL
);


ALTER TABLE public."Slides" OWNER TO studymate_user;

--
-- Name: Users; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public."Users" (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    role public."enum_Users_role" NOT NULL,
    password character varying(255) NOT NULL,
    level integer NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    last_active_date date,
    current_streak integer DEFAULT 0 NOT NULL,
    highest_streak integer DEFAULT 0 NOT NULL,
    total_active_days integer DEFAULT 0 NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL
);


ALTER TABLE public."Users" OWNER TO studymate_user;

--
-- Name: Users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: studymate_user
--

CREATE SEQUENCE public."Users_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Users_user_id_seq" OWNER TO studymate_user;

--
-- Name: Users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: studymate_user
--

ALTER SEQUENCE public."Users_user_id_seq" OWNED BY public."Users".user_id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: studymate_user
--

CREATE TABLE public.announcements (
    announcement_id uuid NOT NULL,
    content text NOT NULL,
    date date NOT NULL,
    "time" time without time zone DEFAULT CURRENT_TIME NOT NULL,
    classroom_id uuid NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.announcements OWNER TO studymate_user;

--
-- Name: CourseSections course_section_id; Type: DEFAULT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."CourseSections" ALTER COLUMN course_section_id SET DEFAULT nextval('public."CourseSections_course_section_id_seq"'::regclass);


--
-- Name: Leaderboards id; Type: DEFAULT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Leaderboards" ALTER COLUMN id SET DEFAULT nextval('public."Leaderboards_id_seq"'::regclass);


--
-- Name: Users user_id; Type: DEFAULT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users" ALTER COLUMN user_id SET DEFAULT nextval('public."Users_user_id_seq"'::regclass);


--
-- Name: ClassroomStudents ClassroomStudents_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."ClassroomStudents"
    ADD CONSTRAINT "ClassroomStudents_pkey" PRIMARY KEY (classroom_id, student_id);


--
-- Name: Classrooms Classrooms_join_code_key; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key1; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key1" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key10; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key10" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key100; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key100" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key101; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key101" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key102; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key102" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key103; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key103" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key104; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key104" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key105; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key105" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key106; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key106" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key107; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key107" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key108; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key108" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key109; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key109" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key11; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key11" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key110; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key110" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key111; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key111" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key112; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key112" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key113; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key113" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key114; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key114" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key115; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key115" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key116; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key116" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key117; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key117" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key118; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key118" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key119; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key119" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key12; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key12" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key120; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key120" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key121; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key121" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key122; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key122" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key123; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key123" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key124; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key124" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key125; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key125" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key126; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key126" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key127; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key127" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key128; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key128" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key129; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key129" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key13; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key13" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key130; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key130" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key131; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key131" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key132; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key132" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key133; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key133" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key134; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key134" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key135; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key135" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key136; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key136" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key137; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key137" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key138; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key138" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key139; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key139" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key14; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key14" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key140; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key140" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key141; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key141" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key142; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key142" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key143; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key143" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key144; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key144" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key145; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key145" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key146; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key146" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key147; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key147" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key148; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key148" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key149; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key149" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key15; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key15" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key150; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key150" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key151; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key151" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key152; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key152" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key153; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key153" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key154; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key154" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key155; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key155" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key156; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key156" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key157; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key157" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key158; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key158" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key159; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key159" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key16; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key16" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key160; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key160" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key161; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key161" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key162; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key162" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key163; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key163" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key164; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key164" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key165; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key165" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key166; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key166" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key167; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key167" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key168; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key168" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key169; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key169" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key17; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key17" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key170; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key170" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key171; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key171" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key172; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key172" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key173; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key173" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key174; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key174" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key175; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key175" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key176; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key176" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key177; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key177" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key178; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key178" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key179; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key179" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key18; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key18" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key180; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key180" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key181; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key181" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key182; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key182" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key183; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key183" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key184; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key184" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key185; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key185" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key186; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key186" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key187; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key187" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key188; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key188" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key189; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key189" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key19; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key19" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key190; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key190" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key191; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key191" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key192; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key192" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key193; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key193" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key194; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key194" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key195; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key195" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key196; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key196" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key197; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key197" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key198; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key198" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key199; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key199" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key2; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key2" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key20; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key20" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key200; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key200" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key201; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key201" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key202; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key202" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key203; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key203" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key204; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key204" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key205; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key205" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key206; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key206" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key207; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key207" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key208; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key208" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key209; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key209" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key21; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key21" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key210; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key210" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key211; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key211" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key212; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key212" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key213; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key213" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key214; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key214" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key215; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key215" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key216; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key216" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key217; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key217" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key218; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key218" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key219; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key219" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key22; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key22" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key220; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key220" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key221; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key221" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key222; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key222" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key223; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key223" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key224; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key224" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key225; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key225" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key226; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key226" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key227; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key227" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key228; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key228" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key229; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key229" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key23; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key23" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key230; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key230" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key231; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key231" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key232; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key232" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key233; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key233" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key234; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key234" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key235; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key235" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key236; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key236" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key237; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key237" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key238; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key238" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key239; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key239" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key24; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key24" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key240; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key240" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key241; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key241" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key242; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key242" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key243; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key243" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key244; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key244" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key245; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key245" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key246; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key246" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key247; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key247" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key248; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key248" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key249; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key249" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key25; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key25" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key250; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key250" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key251; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key251" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key252; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key252" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key253; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key253" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key254; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key254" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key255; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key255" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key256; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key256" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key257; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key257" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key258; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key258" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key259; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key259" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key26; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key26" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key260; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key260" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key261; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key261" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key262; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key262" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key263; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key263" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key264; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key264" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key265; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key265" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key266; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key266" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key267; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key267" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key268; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key268" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key269; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key269" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key27; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key27" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key270; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key270" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key271; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key271" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key272; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key272" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key273; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key273" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key274; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key274" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key275; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key275" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key276; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key276" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key277; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key277" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key278; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key278" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key279; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key279" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key28; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key28" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key280; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key280" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key281; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key281" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key282; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key282" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key283; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key283" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key284; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key284" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key285; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key285" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key286; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key286" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key287; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key287" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key288; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key288" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key289; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key289" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key29; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key29" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key290; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key290" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key291; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key291" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key292; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key292" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key293; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key293" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key294; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key294" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key295; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key295" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key296; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key296" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key297; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key297" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key298; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key298" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key299; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key299" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key3; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key3" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key30; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key30" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key300; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key300" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key301; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key301" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key302; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key302" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key303; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key303" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key304; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key304" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key305; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key305" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key306; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key306" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key307; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key307" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key308; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key308" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key309; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key309" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key31; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key31" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key310; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key310" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key311; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key311" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key312; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key312" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key313; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key313" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key314; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key314" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key315; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key315" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key316; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key316" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key317; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key317" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key318; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key318" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key319; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key319" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key32; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key32" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key320; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key320" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key321; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key321" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key322; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key322" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key323; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key323" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key324; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key324" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key325; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key325" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key326; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key326" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key327; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key327" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key328; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key328" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key329; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key329" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key33; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key33" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key330; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key330" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key331; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key331" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key332; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key332" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key333; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key333" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key334; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key334" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key335; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key335" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key336; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key336" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key337; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key337" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key338; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key338" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key339; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key339" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key34; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key34" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key340; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key340" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key341; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key341" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key342; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key342" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key343; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key343" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key344; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key344" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key345; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key345" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key346; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key346" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key347; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key347" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key348; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key348" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key349; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key349" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key35; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key35" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key350; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key350" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key351; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key351" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key352; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key352" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key353; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key353" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key354; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key354" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key355; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key355" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key356; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key356" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key357; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key357" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key358; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key358" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key359; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key359" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key36; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key36" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key360; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key360" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key361; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key361" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key362; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key362" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key363; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key363" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key364; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key364" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key365; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key365" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key366; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key366" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key367; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key367" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key368; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key368" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key369; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key369" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key37; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key37" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key370; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key370" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key371; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key371" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key372; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key372" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key373; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key373" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key374; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key374" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key375; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key375" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key376; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key376" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key377; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key377" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key378; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key378" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key379; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key379" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key38; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key38" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key380; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key380" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key381; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key381" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key382; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key382" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key383; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key383" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key384; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key384" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key385; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key385" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key386; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key386" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key387; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key387" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key388; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key388" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key389; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key389" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key39; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key39" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key390; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key390" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key391; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key391" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key392; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key392" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key393; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key393" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key394; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key394" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key395; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key395" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key396; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key396" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key397; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key397" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key398; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key398" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key399; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key399" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key4; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key4" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key40; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key40" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key400; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key400" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key401; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key401" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key402; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key402" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key403; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key403" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key404; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key404" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key405; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key405" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key406; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key406" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key407; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key407" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key408; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key408" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key409; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key409" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key41; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key41" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key410; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key410" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key411; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key411" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key412; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key412" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key413; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key413" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key414; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key414" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key415; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key415" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key416; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key416" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key417; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key417" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key418; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key418" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key419; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key419" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key42; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key42" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key420; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key420" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key421; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key421" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key422; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key422" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key423; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key423" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key424; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key424" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key425; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key425" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key426; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key426" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key427; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key427" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key428; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key428" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key429; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key429" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key43; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key43" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key430; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key430" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key431; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key431" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key432; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key432" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key433; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key433" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key434; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key434" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key435; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key435" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key436; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key436" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key437; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key437" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key438; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key438" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key439; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key439" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key44; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key44" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key440; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key440" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key441; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key441" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key442; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key442" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key443; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key443" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key444; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key444" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key445; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key445" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key446; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key446" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key447; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key447" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key448; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key448" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key449; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key449" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key45; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key45" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key450; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key450" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key451; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key451" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key452; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key452" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key453; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key453" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key454; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key454" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key455; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key455" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key456; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key456" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key457; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key457" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key458; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key458" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key459; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key459" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key46; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key46" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key460; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key460" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key461; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key461" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key462; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key462" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key463; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key463" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key464; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key464" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key465; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key465" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key466; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key466" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key467; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key467" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key468; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key468" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key469; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key469" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key47; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key47" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key470; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key470" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key471; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key471" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key472; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key472" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key473; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key473" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key474; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key474" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key475; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key475" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key476; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key476" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key477; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key477" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key478; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key478" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key48; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key48" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key49; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key49" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key5; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key5" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key50; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key50" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key51; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key51" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key52; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key52" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key53; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key53" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key54; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key54" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key55; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key55" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key56; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key56" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key57; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key57" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key58; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key58" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key59; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key59" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key6; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key6" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key60; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key60" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key61; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key61" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key62; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key62" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key63; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key63" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key64; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key64" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key65; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key65" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key66; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key66" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key67; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key67" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key68; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key68" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key69; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key69" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key7; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key7" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key70; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key70" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key71; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key71" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key72; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key72" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key73; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key73" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key74; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key74" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key75; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key75" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key76; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key76" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key77; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key77" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key78; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key78" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key79; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key79" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key8; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key8" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key80; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key80" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key81; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key81" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key82; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key82" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key83; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key83" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key84; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key84" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key85; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key85" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key86; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key86" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key87; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key87" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key88; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key88" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key89; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key89" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key9; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key9" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key90; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key90" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key91; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key91" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key92; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key92" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key93; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key93" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key94; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key94" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key95; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key95" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key96; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key96" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key97; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key97" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key98; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key98" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_join_code_key99; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_join_code_key99" UNIQUE (join_code);


--
-- Name: Classrooms Classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_pkey" PRIMARY KEY (classroom_id);


--
-- Name: CourseSections CourseSections_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."CourseSections"
    ADD CONSTRAINT "CourseSections_pkey" PRIMARY KEY (course_section_id);


--
-- Name: Leaderboards Leaderboards_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Leaderboards"
    ADD CONSTRAINT "Leaderboards_pkey" PRIMARY KEY (id);


--
-- Name: PastQuestions PastQuestions_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."PastQuestions"
    ADD CONSTRAINT "PastQuestions_pkey" PRIMARY KEY (past_question_id);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: Slides Slides_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Slides"
    ADD CONSTRAINT "Slides_pkey" PRIMARY KEY (slide_id);


--
-- Name: Users Users_email_key; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key" UNIQUE (email);


--
-- Name: Users Users_email_key1; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key1" UNIQUE (email);


--
-- Name: Users Users_email_key10; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key10" UNIQUE (email);


--
-- Name: Users Users_email_key100; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key100" UNIQUE (email);


--
-- Name: Users Users_email_key101; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key101" UNIQUE (email);


--
-- Name: Users Users_email_key102; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key102" UNIQUE (email);


--
-- Name: Users Users_email_key103; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key103" UNIQUE (email);


--
-- Name: Users Users_email_key104; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key104" UNIQUE (email);


--
-- Name: Users Users_email_key105; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key105" UNIQUE (email);


--
-- Name: Users Users_email_key106; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key106" UNIQUE (email);


--
-- Name: Users Users_email_key107; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key107" UNIQUE (email);


--
-- Name: Users Users_email_key108; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key108" UNIQUE (email);


--
-- Name: Users Users_email_key109; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key109" UNIQUE (email);


--
-- Name: Users Users_email_key11; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key11" UNIQUE (email);


--
-- Name: Users Users_email_key110; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key110" UNIQUE (email);


--
-- Name: Users Users_email_key111; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key111" UNIQUE (email);


--
-- Name: Users Users_email_key112; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key112" UNIQUE (email);


--
-- Name: Users Users_email_key113; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key113" UNIQUE (email);


--
-- Name: Users Users_email_key114; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key114" UNIQUE (email);


--
-- Name: Users Users_email_key115; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key115" UNIQUE (email);


--
-- Name: Users Users_email_key116; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key116" UNIQUE (email);


--
-- Name: Users Users_email_key117; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key117" UNIQUE (email);


--
-- Name: Users Users_email_key118; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key118" UNIQUE (email);


--
-- Name: Users Users_email_key119; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key119" UNIQUE (email);


--
-- Name: Users Users_email_key12; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key12" UNIQUE (email);


--
-- Name: Users Users_email_key120; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key120" UNIQUE (email);


--
-- Name: Users Users_email_key121; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key121" UNIQUE (email);


--
-- Name: Users Users_email_key122; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key122" UNIQUE (email);


--
-- Name: Users Users_email_key123; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key123" UNIQUE (email);


--
-- Name: Users Users_email_key124; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key124" UNIQUE (email);


--
-- Name: Users Users_email_key125; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key125" UNIQUE (email);


--
-- Name: Users Users_email_key126; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key126" UNIQUE (email);


--
-- Name: Users Users_email_key127; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key127" UNIQUE (email);


--
-- Name: Users Users_email_key128; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key128" UNIQUE (email);


--
-- Name: Users Users_email_key129; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key129" UNIQUE (email);


--
-- Name: Users Users_email_key13; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key13" UNIQUE (email);


--
-- Name: Users Users_email_key130; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key130" UNIQUE (email);


--
-- Name: Users Users_email_key131; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key131" UNIQUE (email);


--
-- Name: Users Users_email_key132; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key132" UNIQUE (email);


--
-- Name: Users Users_email_key133; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key133" UNIQUE (email);


--
-- Name: Users Users_email_key134; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key134" UNIQUE (email);


--
-- Name: Users Users_email_key135; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key135" UNIQUE (email);


--
-- Name: Users Users_email_key136; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key136" UNIQUE (email);


--
-- Name: Users Users_email_key137; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key137" UNIQUE (email);


--
-- Name: Users Users_email_key138; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key138" UNIQUE (email);


--
-- Name: Users Users_email_key139; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key139" UNIQUE (email);


--
-- Name: Users Users_email_key14; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key14" UNIQUE (email);


--
-- Name: Users Users_email_key140; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key140" UNIQUE (email);


--
-- Name: Users Users_email_key141; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key141" UNIQUE (email);


--
-- Name: Users Users_email_key142; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key142" UNIQUE (email);


--
-- Name: Users Users_email_key143; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key143" UNIQUE (email);


--
-- Name: Users Users_email_key144; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key144" UNIQUE (email);


--
-- Name: Users Users_email_key145; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key145" UNIQUE (email);


--
-- Name: Users Users_email_key146; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key146" UNIQUE (email);


--
-- Name: Users Users_email_key147; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key147" UNIQUE (email);


--
-- Name: Users Users_email_key148; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key148" UNIQUE (email);


--
-- Name: Users Users_email_key149; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key149" UNIQUE (email);


--
-- Name: Users Users_email_key15; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key15" UNIQUE (email);


--
-- Name: Users Users_email_key150; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key150" UNIQUE (email);


--
-- Name: Users Users_email_key151; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key151" UNIQUE (email);


--
-- Name: Users Users_email_key152; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key152" UNIQUE (email);


--
-- Name: Users Users_email_key153; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key153" UNIQUE (email);


--
-- Name: Users Users_email_key154; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key154" UNIQUE (email);


--
-- Name: Users Users_email_key155; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key155" UNIQUE (email);


--
-- Name: Users Users_email_key156; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key156" UNIQUE (email);


--
-- Name: Users Users_email_key157; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key157" UNIQUE (email);


--
-- Name: Users Users_email_key158; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key158" UNIQUE (email);


--
-- Name: Users Users_email_key159; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key159" UNIQUE (email);


--
-- Name: Users Users_email_key16; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key16" UNIQUE (email);


--
-- Name: Users Users_email_key160; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key160" UNIQUE (email);


--
-- Name: Users Users_email_key161; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key161" UNIQUE (email);


--
-- Name: Users Users_email_key162; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key162" UNIQUE (email);


--
-- Name: Users Users_email_key163; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key163" UNIQUE (email);


--
-- Name: Users Users_email_key164; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key164" UNIQUE (email);


--
-- Name: Users Users_email_key165; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key165" UNIQUE (email);


--
-- Name: Users Users_email_key166; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key166" UNIQUE (email);


--
-- Name: Users Users_email_key167; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key167" UNIQUE (email);


--
-- Name: Users Users_email_key168; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key168" UNIQUE (email);


--
-- Name: Users Users_email_key169; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key169" UNIQUE (email);


--
-- Name: Users Users_email_key17; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key17" UNIQUE (email);


--
-- Name: Users Users_email_key170; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key170" UNIQUE (email);


--
-- Name: Users Users_email_key171; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key171" UNIQUE (email);


--
-- Name: Users Users_email_key172; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key172" UNIQUE (email);


--
-- Name: Users Users_email_key173; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key173" UNIQUE (email);


--
-- Name: Users Users_email_key174; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key174" UNIQUE (email);


--
-- Name: Users Users_email_key175; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key175" UNIQUE (email);


--
-- Name: Users Users_email_key176; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key176" UNIQUE (email);


--
-- Name: Users Users_email_key177; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key177" UNIQUE (email);


--
-- Name: Users Users_email_key178; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key178" UNIQUE (email);


--
-- Name: Users Users_email_key179; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key179" UNIQUE (email);


--
-- Name: Users Users_email_key18; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key18" UNIQUE (email);


--
-- Name: Users Users_email_key180; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key180" UNIQUE (email);


--
-- Name: Users Users_email_key181; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key181" UNIQUE (email);


--
-- Name: Users Users_email_key182; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key182" UNIQUE (email);


--
-- Name: Users Users_email_key183; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key183" UNIQUE (email);


--
-- Name: Users Users_email_key184; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key184" UNIQUE (email);


--
-- Name: Users Users_email_key185; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key185" UNIQUE (email);


--
-- Name: Users Users_email_key186; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key186" UNIQUE (email);


--
-- Name: Users Users_email_key187; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key187" UNIQUE (email);


--
-- Name: Users Users_email_key188; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key188" UNIQUE (email);


--
-- Name: Users Users_email_key189; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key189" UNIQUE (email);


--
-- Name: Users Users_email_key19; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key19" UNIQUE (email);


--
-- Name: Users Users_email_key190; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key190" UNIQUE (email);


--
-- Name: Users Users_email_key191; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key191" UNIQUE (email);


--
-- Name: Users Users_email_key192; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key192" UNIQUE (email);


--
-- Name: Users Users_email_key193; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key193" UNIQUE (email);


--
-- Name: Users Users_email_key194; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key194" UNIQUE (email);


--
-- Name: Users Users_email_key195; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key195" UNIQUE (email);


--
-- Name: Users Users_email_key196; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key196" UNIQUE (email);


--
-- Name: Users Users_email_key197; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key197" UNIQUE (email);


--
-- Name: Users Users_email_key198; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key198" UNIQUE (email);


--
-- Name: Users Users_email_key199; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key199" UNIQUE (email);


--
-- Name: Users Users_email_key2; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key2" UNIQUE (email);


--
-- Name: Users Users_email_key20; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key20" UNIQUE (email);


--
-- Name: Users Users_email_key200; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key200" UNIQUE (email);


--
-- Name: Users Users_email_key201; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key201" UNIQUE (email);


--
-- Name: Users Users_email_key202; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key202" UNIQUE (email);


--
-- Name: Users Users_email_key203; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key203" UNIQUE (email);


--
-- Name: Users Users_email_key204; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key204" UNIQUE (email);


--
-- Name: Users Users_email_key205; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key205" UNIQUE (email);


--
-- Name: Users Users_email_key206; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key206" UNIQUE (email);


--
-- Name: Users Users_email_key207; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key207" UNIQUE (email);


--
-- Name: Users Users_email_key208; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key208" UNIQUE (email);


--
-- Name: Users Users_email_key209; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key209" UNIQUE (email);


--
-- Name: Users Users_email_key21; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key21" UNIQUE (email);


--
-- Name: Users Users_email_key210; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key210" UNIQUE (email);


--
-- Name: Users Users_email_key211; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key211" UNIQUE (email);


--
-- Name: Users Users_email_key212; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key212" UNIQUE (email);


--
-- Name: Users Users_email_key213; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key213" UNIQUE (email);


--
-- Name: Users Users_email_key214; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key214" UNIQUE (email);


--
-- Name: Users Users_email_key215; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key215" UNIQUE (email);


--
-- Name: Users Users_email_key216; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key216" UNIQUE (email);


--
-- Name: Users Users_email_key217; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key217" UNIQUE (email);


--
-- Name: Users Users_email_key218; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key218" UNIQUE (email);


--
-- Name: Users Users_email_key219; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key219" UNIQUE (email);


--
-- Name: Users Users_email_key22; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key22" UNIQUE (email);


--
-- Name: Users Users_email_key220; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key220" UNIQUE (email);


--
-- Name: Users Users_email_key221; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key221" UNIQUE (email);


--
-- Name: Users Users_email_key222; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key222" UNIQUE (email);


--
-- Name: Users Users_email_key223; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key223" UNIQUE (email);


--
-- Name: Users Users_email_key224; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key224" UNIQUE (email);


--
-- Name: Users Users_email_key225; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key225" UNIQUE (email);


--
-- Name: Users Users_email_key226; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key226" UNIQUE (email);


--
-- Name: Users Users_email_key227; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key227" UNIQUE (email);


--
-- Name: Users Users_email_key228; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key228" UNIQUE (email);


--
-- Name: Users Users_email_key229; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key229" UNIQUE (email);


--
-- Name: Users Users_email_key23; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key23" UNIQUE (email);


--
-- Name: Users Users_email_key230; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key230" UNIQUE (email);


--
-- Name: Users Users_email_key231; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key231" UNIQUE (email);


--
-- Name: Users Users_email_key232; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key232" UNIQUE (email);


--
-- Name: Users Users_email_key233; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key233" UNIQUE (email);


--
-- Name: Users Users_email_key234; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key234" UNIQUE (email);


--
-- Name: Users Users_email_key235; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key235" UNIQUE (email);


--
-- Name: Users Users_email_key236; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key236" UNIQUE (email);


--
-- Name: Users Users_email_key237; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key237" UNIQUE (email);


--
-- Name: Users Users_email_key238; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key238" UNIQUE (email);


--
-- Name: Users Users_email_key239; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key239" UNIQUE (email);


--
-- Name: Users Users_email_key24; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key24" UNIQUE (email);


--
-- Name: Users Users_email_key240; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key240" UNIQUE (email);


--
-- Name: Users Users_email_key241; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key241" UNIQUE (email);


--
-- Name: Users Users_email_key242; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key242" UNIQUE (email);


--
-- Name: Users Users_email_key243; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key243" UNIQUE (email);


--
-- Name: Users Users_email_key244; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key244" UNIQUE (email);


--
-- Name: Users Users_email_key245; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key245" UNIQUE (email);


--
-- Name: Users Users_email_key246; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key246" UNIQUE (email);


--
-- Name: Users Users_email_key247; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key247" UNIQUE (email);


--
-- Name: Users Users_email_key248; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key248" UNIQUE (email);


--
-- Name: Users Users_email_key249; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key249" UNIQUE (email);


--
-- Name: Users Users_email_key25; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key25" UNIQUE (email);


--
-- Name: Users Users_email_key250; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key250" UNIQUE (email);


--
-- Name: Users Users_email_key251; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key251" UNIQUE (email);


--
-- Name: Users Users_email_key252; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key252" UNIQUE (email);


--
-- Name: Users Users_email_key253; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key253" UNIQUE (email);


--
-- Name: Users Users_email_key254; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key254" UNIQUE (email);


--
-- Name: Users Users_email_key255; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key255" UNIQUE (email);


--
-- Name: Users Users_email_key256; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key256" UNIQUE (email);


--
-- Name: Users Users_email_key257; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key257" UNIQUE (email);


--
-- Name: Users Users_email_key258; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key258" UNIQUE (email);


--
-- Name: Users Users_email_key259; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key259" UNIQUE (email);


--
-- Name: Users Users_email_key26; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key26" UNIQUE (email);


--
-- Name: Users Users_email_key260; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key260" UNIQUE (email);


--
-- Name: Users Users_email_key261; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key261" UNIQUE (email);


--
-- Name: Users Users_email_key262; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key262" UNIQUE (email);


--
-- Name: Users Users_email_key263; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key263" UNIQUE (email);


--
-- Name: Users Users_email_key264; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key264" UNIQUE (email);


--
-- Name: Users Users_email_key265; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key265" UNIQUE (email);


--
-- Name: Users Users_email_key266; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key266" UNIQUE (email);


--
-- Name: Users Users_email_key267; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key267" UNIQUE (email);


--
-- Name: Users Users_email_key268; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key268" UNIQUE (email);


--
-- Name: Users Users_email_key269; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key269" UNIQUE (email);


--
-- Name: Users Users_email_key27; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key27" UNIQUE (email);


--
-- Name: Users Users_email_key270; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key270" UNIQUE (email);


--
-- Name: Users Users_email_key271; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key271" UNIQUE (email);


--
-- Name: Users Users_email_key272; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key272" UNIQUE (email);


--
-- Name: Users Users_email_key273; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key273" UNIQUE (email);


--
-- Name: Users Users_email_key274; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key274" UNIQUE (email);


--
-- Name: Users Users_email_key275; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key275" UNIQUE (email);


--
-- Name: Users Users_email_key276; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key276" UNIQUE (email);


--
-- Name: Users Users_email_key277; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key277" UNIQUE (email);


--
-- Name: Users Users_email_key278; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key278" UNIQUE (email);


--
-- Name: Users Users_email_key279; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key279" UNIQUE (email);


--
-- Name: Users Users_email_key28; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key28" UNIQUE (email);


--
-- Name: Users Users_email_key280; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key280" UNIQUE (email);


--
-- Name: Users Users_email_key281; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key281" UNIQUE (email);


--
-- Name: Users Users_email_key282; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key282" UNIQUE (email);


--
-- Name: Users Users_email_key283; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key283" UNIQUE (email);


--
-- Name: Users Users_email_key284; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key284" UNIQUE (email);


--
-- Name: Users Users_email_key285; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key285" UNIQUE (email);


--
-- Name: Users Users_email_key286; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key286" UNIQUE (email);


--
-- Name: Users Users_email_key287; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key287" UNIQUE (email);


--
-- Name: Users Users_email_key288; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key288" UNIQUE (email);


--
-- Name: Users Users_email_key289; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key289" UNIQUE (email);


--
-- Name: Users Users_email_key29; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key29" UNIQUE (email);


--
-- Name: Users Users_email_key290; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key290" UNIQUE (email);


--
-- Name: Users Users_email_key291; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key291" UNIQUE (email);


--
-- Name: Users Users_email_key292; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key292" UNIQUE (email);


--
-- Name: Users Users_email_key293; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key293" UNIQUE (email);


--
-- Name: Users Users_email_key294; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key294" UNIQUE (email);


--
-- Name: Users Users_email_key295; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key295" UNIQUE (email);


--
-- Name: Users Users_email_key296; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key296" UNIQUE (email);


--
-- Name: Users Users_email_key297; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key297" UNIQUE (email);


--
-- Name: Users Users_email_key298; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key298" UNIQUE (email);


--
-- Name: Users Users_email_key299; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key299" UNIQUE (email);


--
-- Name: Users Users_email_key3; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key3" UNIQUE (email);


--
-- Name: Users Users_email_key30; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key30" UNIQUE (email);


--
-- Name: Users Users_email_key300; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key300" UNIQUE (email);


--
-- Name: Users Users_email_key301; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key301" UNIQUE (email);


--
-- Name: Users Users_email_key302; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key302" UNIQUE (email);


--
-- Name: Users Users_email_key303; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key303" UNIQUE (email);


--
-- Name: Users Users_email_key304; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key304" UNIQUE (email);


--
-- Name: Users Users_email_key305; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key305" UNIQUE (email);


--
-- Name: Users Users_email_key306; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key306" UNIQUE (email);


--
-- Name: Users Users_email_key307; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key307" UNIQUE (email);


--
-- Name: Users Users_email_key308; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key308" UNIQUE (email);


--
-- Name: Users Users_email_key309; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key309" UNIQUE (email);


--
-- Name: Users Users_email_key31; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key31" UNIQUE (email);


--
-- Name: Users Users_email_key310; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key310" UNIQUE (email);


--
-- Name: Users Users_email_key311; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key311" UNIQUE (email);


--
-- Name: Users Users_email_key312; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key312" UNIQUE (email);


--
-- Name: Users Users_email_key313; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key313" UNIQUE (email);


--
-- Name: Users Users_email_key314; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key314" UNIQUE (email);


--
-- Name: Users Users_email_key315; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key315" UNIQUE (email);


--
-- Name: Users Users_email_key316; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key316" UNIQUE (email);


--
-- Name: Users Users_email_key317; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key317" UNIQUE (email);


--
-- Name: Users Users_email_key318; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key318" UNIQUE (email);


--
-- Name: Users Users_email_key319; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key319" UNIQUE (email);


--
-- Name: Users Users_email_key32; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key32" UNIQUE (email);


--
-- Name: Users Users_email_key320; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key320" UNIQUE (email);


--
-- Name: Users Users_email_key321; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key321" UNIQUE (email);


--
-- Name: Users Users_email_key322; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key322" UNIQUE (email);


--
-- Name: Users Users_email_key323; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key323" UNIQUE (email);


--
-- Name: Users Users_email_key324; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key324" UNIQUE (email);


--
-- Name: Users Users_email_key325; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key325" UNIQUE (email);


--
-- Name: Users Users_email_key326; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key326" UNIQUE (email);


--
-- Name: Users Users_email_key327; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key327" UNIQUE (email);


--
-- Name: Users Users_email_key328; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key328" UNIQUE (email);


--
-- Name: Users Users_email_key329; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key329" UNIQUE (email);


--
-- Name: Users Users_email_key33; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key33" UNIQUE (email);


--
-- Name: Users Users_email_key330; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key330" UNIQUE (email);


--
-- Name: Users Users_email_key331; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key331" UNIQUE (email);


--
-- Name: Users Users_email_key332; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key332" UNIQUE (email);


--
-- Name: Users Users_email_key333; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key333" UNIQUE (email);


--
-- Name: Users Users_email_key334; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key334" UNIQUE (email);


--
-- Name: Users Users_email_key335; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key335" UNIQUE (email);


--
-- Name: Users Users_email_key336; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key336" UNIQUE (email);


--
-- Name: Users Users_email_key337; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key337" UNIQUE (email);


--
-- Name: Users Users_email_key338; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key338" UNIQUE (email);


--
-- Name: Users Users_email_key339; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key339" UNIQUE (email);


--
-- Name: Users Users_email_key34; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key34" UNIQUE (email);


--
-- Name: Users Users_email_key340; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key340" UNIQUE (email);


--
-- Name: Users Users_email_key341; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key341" UNIQUE (email);


--
-- Name: Users Users_email_key342; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key342" UNIQUE (email);


--
-- Name: Users Users_email_key343; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key343" UNIQUE (email);


--
-- Name: Users Users_email_key344; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key344" UNIQUE (email);


--
-- Name: Users Users_email_key345; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key345" UNIQUE (email);


--
-- Name: Users Users_email_key346; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key346" UNIQUE (email);


--
-- Name: Users Users_email_key347; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key347" UNIQUE (email);


--
-- Name: Users Users_email_key348; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key348" UNIQUE (email);


--
-- Name: Users Users_email_key349; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key349" UNIQUE (email);


--
-- Name: Users Users_email_key35; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key35" UNIQUE (email);


--
-- Name: Users Users_email_key350; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key350" UNIQUE (email);


--
-- Name: Users Users_email_key351; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key351" UNIQUE (email);


--
-- Name: Users Users_email_key352; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key352" UNIQUE (email);


--
-- Name: Users Users_email_key353; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key353" UNIQUE (email);


--
-- Name: Users Users_email_key354; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key354" UNIQUE (email);


--
-- Name: Users Users_email_key355; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key355" UNIQUE (email);


--
-- Name: Users Users_email_key356; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key356" UNIQUE (email);


--
-- Name: Users Users_email_key357; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key357" UNIQUE (email);


--
-- Name: Users Users_email_key358; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key358" UNIQUE (email);


--
-- Name: Users Users_email_key359; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key359" UNIQUE (email);


--
-- Name: Users Users_email_key36; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key36" UNIQUE (email);


--
-- Name: Users Users_email_key360; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key360" UNIQUE (email);


--
-- Name: Users Users_email_key361; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key361" UNIQUE (email);


--
-- Name: Users Users_email_key362; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key362" UNIQUE (email);


--
-- Name: Users Users_email_key363; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key363" UNIQUE (email);


--
-- Name: Users Users_email_key364; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key364" UNIQUE (email);


--
-- Name: Users Users_email_key365; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key365" UNIQUE (email);


--
-- Name: Users Users_email_key366; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key366" UNIQUE (email);


--
-- Name: Users Users_email_key367; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key367" UNIQUE (email);


--
-- Name: Users Users_email_key368; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key368" UNIQUE (email);


--
-- Name: Users Users_email_key369; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key369" UNIQUE (email);


--
-- Name: Users Users_email_key37; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key37" UNIQUE (email);


--
-- Name: Users Users_email_key370; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key370" UNIQUE (email);


--
-- Name: Users Users_email_key371; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key371" UNIQUE (email);


--
-- Name: Users Users_email_key372; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key372" UNIQUE (email);


--
-- Name: Users Users_email_key373; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key373" UNIQUE (email);


--
-- Name: Users Users_email_key374; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key374" UNIQUE (email);


--
-- Name: Users Users_email_key375; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key375" UNIQUE (email);


--
-- Name: Users Users_email_key376; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key376" UNIQUE (email);


--
-- Name: Users Users_email_key377; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key377" UNIQUE (email);


--
-- Name: Users Users_email_key378; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key378" UNIQUE (email);


--
-- Name: Users Users_email_key379; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key379" UNIQUE (email);


--
-- Name: Users Users_email_key38; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key38" UNIQUE (email);


--
-- Name: Users Users_email_key380; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key380" UNIQUE (email);


--
-- Name: Users Users_email_key381; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key381" UNIQUE (email);


--
-- Name: Users Users_email_key382; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key382" UNIQUE (email);


--
-- Name: Users Users_email_key383; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key383" UNIQUE (email);


--
-- Name: Users Users_email_key384; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key384" UNIQUE (email);


--
-- Name: Users Users_email_key385; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key385" UNIQUE (email);


--
-- Name: Users Users_email_key386; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key386" UNIQUE (email);


--
-- Name: Users Users_email_key387; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key387" UNIQUE (email);


--
-- Name: Users Users_email_key388; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key388" UNIQUE (email);


--
-- Name: Users Users_email_key389; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key389" UNIQUE (email);


--
-- Name: Users Users_email_key39; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key39" UNIQUE (email);


--
-- Name: Users Users_email_key390; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key390" UNIQUE (email);


--
-- Name: Users Users_email_key391; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key391" UNIQUE (email);


--
-- Name: Users Users_email_key392; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key392" UNIQUE (email);


--
-- Name: Users Users_email_key393; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key393" UNIQUE (email);


--
-- Name: Users Users_email_key394; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key394" UNIQUE (email);


--
-- Name: Users Users_email_key395; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key395" UNIQUE (email);


--
-- Name: Users Users_email_key396; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key396" UNIQUE (email);


--
-- Name: Users Users_email_key397; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key397" UNIQUE (email);


--
-- Name: Users Users_email_key398; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key398" UNIQUE (email);


--
-- Name: Users Users_email_key399; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key399" UNIQUE (email);


--
-- Name: Users Users_email_key4; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key4" UNIQUE (email);


--
-- Name: Users Users_email_key40; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key40" UNIQUE (email);


--
-- Name: Users Users_email_key400; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key400" UNIQUE (email);


--
-- Name: Users Users_email_key401; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key401" UNIQUE (email);


--
-- Name: Users Users_email_key402; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key402" UNIQUE (email);


--
-- Name: Users Users_email_key403; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key403" UNIQUE (email);


--
-- Name: Users Users_email_key404; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key404" UNIQUE (email);


--
-- Name: Users Users_email_key405; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key405" UNIQUE (email);


--
-- Name: Users Users_email_key406; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key406" UNIQUE (email);


--
-- Name: Users Users_email_key407; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key407" UNIQUE (email);


--
-- Name: Users Users_email_key408; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key408" UNIQUE (email);


--
-- Name: Users Users_email_key409; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key409" UNIQUE (email);


--
-- Name: Users Users_email_key41; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key41" UNIQUE (email);


--
-- Name: Users Users_email_key410; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key410" UNIQUE (email);


--
-- Name: Users Users_email_key411; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key411" UNIQUE (email);


--
-- Name: Users Users_email_key412; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key412" UNIQUE (email);


--
-- Name: Users Users_email_key413; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key413" UNIQUE (email);


--
-- Name: Users Users_email_key414; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key414" UNIQUE (email);


--
-- Name: Users Users_email_key415; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key415" UNIQUE (email);


--
-- Name: Users Users_email_key416; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key416" UNIQUE (email);


--
-- Name: Users Users_email_key417; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key417" UNIQUE (email);


--
-- Name: Users Users_email_key418; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key418" UNIQUE (email);


--
-- Name: Users Users_email_key419; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key419" UNIQUE (email);


--
-- Name: Users Users_email_key42; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key42" UNIQUE (email);


--
-- Name: Users Users_email_key420; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key420" UNIQUE (email);


--
-- Name: Users Users_email_key421; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key421" UNIQUE (email);


--
-- Name: Users Users_email_key422; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key422" UNIQUE (email);


--
-- Name: Users Users_email_key423; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key423" UNIQUE (email);


--
-- Name: Users Users_email_key424; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key424" UNIQUE (email);


--
-- Name: Users Users_email_key425; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key425" UNIQUE (email);


--
-- Name: Users Users_email_key426; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key426" UNIQUE (email);


--
-- Name: Users Users_email_key427; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key427" UNIQUE (email);


--
-- Name: Users Users_email_key428; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key428" UNIQUE (email);


--
-- Name: Users Users_email_key429; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key429" UNIQUE (email);


--
-- Name: Users Users_email_key43; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key43" UNIQUE (email);


--
-- Name: Users Users_email_key430; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key430" UNIQUE (email);


--
-- Name: Users Users_email_key431; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key431" UNIQUE (email);


--
-- Name: Users Users_email_key432; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key432" UNIQUE (email);


--
-- Name: Users Users_email_key433; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key433" UNIQUE (email);


--
-- Name: Users Users_email_key434; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key434" UNIQUE (email);


--
-- Name: Users Users_email_key435; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key435" UNIQUE (email);


--
-- Name: Users Users_email_key436; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key436" UNIQUE (email);


--
-- Name: Users Users_email_key437; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key437" UNIQUE (email);


--
-- Name: Users Users_email_key438; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key438" UNIQUE (email);


--
-- Name: Users Users_email_key439; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key439" UNIQUE (email);


--
-- Name: Users Users_email_key44; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key44" UNIQUE (email);


--
-- Name: Users Users_email_key440; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key440" UNIQUE (email);


--
-- Name: Users Users_email_key441; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key441" UNIQUE (email);


--
-- Name: Users Users_email_key442; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key442" UNIQUE (email);


--
-- Name: Users Users_email_key443; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key443" UNIQUE (email);


--
-- Name: Users Users_email_key444; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key444" UNIQUE (email);


--
-- Name: Users Users_email_key445; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key445" UNIQUE (email);


--
-- Name: Users Users_email_key446; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key446" UNIQUE (email);


--
-- Name: Users Users_email_key447; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key447" UNIQUE (email);


--
-- Name: Users Users_email_key448; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key448" UNIQUE (email);


--
-- Name: Users Users_email_key449; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key449" UNIQUE (email);


--
-- Name: Users Users_email_key45; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key45" UNIQUE (email);


--
-- Name: Users Users_email_key450; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key450" UNIQUE (email);


--
-- Name: Users Users_email_key451; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key451" UNIQUE (email);


--
-- Name: Users Users_email_key452; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key452" UNIQUE (email);


--
-- Name: Users Users_email_key453; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key453" UNIQUE (email);


--
-- Name: Users Users_email_key454; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key454" UNIQUE (email);


--
-- Name: Users Users_email_key455; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key455" UNIQUE (email);


--
-- Name: Users Users_email_key456; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key456" UNIQUE (email);


--
-- Name: Users Users_email_key457; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key457" UNIQUE (email);


--
-- Name: Users Users_email_key458; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key458" UNIQUE (email);


--
-- Name: Users Users_email_key459; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key459" UNIQUE (email);


--
-- Name: Users Users_email_key46; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key46" UNIQUE (email);


--
-- Name: Users Users_email_key460; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key460" UNIQUE (email);


--
-- Name: Users Users_email_key461; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key461" UNIQUE (email);


--
-- Name: Users Users_email_key462; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key462" UNIQUE (email);


--
-- Name: Users Users_email_key463; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key463" UNIQUE (email);


--
-- Name: Users Users_email_key464; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key464" UNIQUE (email);


--
-- Name: Users Users_email_key465; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key465" UNIQUE (email);


--
-- Name: Users Users_email_key466; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key466" UNIQUE (email);


--
-- Name: Users Users_email_key467; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key467" UNIQUE (email);


--
-- Name: Users Users_email_key468; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key468" UNIQUE (email);


--
-- Name: Users Users_email_key469; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key469" UNIQUE (email);


--
-- Name: Users Users_email_key47; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key47" UNIQUE (email);


--
-- Name: Users Users_email_key470; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key470" UNIQUE (email);


--
-- Name: Users Users_email_key471; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key471" UNIQUE (email);


--
-- Name: Users Users_email_key472; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key472" UNIQUE (email);


--
-- Name: Users Users_email_key473; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key473" UNIQUE (email);


--
-- Name: Users Users_email_key474; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key474" UNIQUE (email);


--
-- Name: Users Users_email_key475; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key475" UNIQUE (email);


--
-- Name: Users Users_email_key476; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key476" UNIQUE (email);


--
-- Name: Users Users_email_key477; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key477" UNIQUE (email);


--
-- Name: Users Users_email_key478; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key478" UNIQUE (email);


--
-- Name: Users Users_email_key479; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key479" UNIQUE (email);


--
-- Name: Users Users_email_key48; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key48" UNIQUE (email);


--
-- Name: Users Users_email_key480; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key480" UNIQUE (email);


--
-- Name: Users Users_email_key481; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key481" UNIQUE (email);


--
-- Name: Users Users_email_key482; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key482" UNIQUE (email);


--
-- Name: Users Users_email_key483; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key483" UNIQUE (email);


--
-- Name: Users Users_email_key484; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key484" UNIQUE (email);


--
-- Name: Users Users_email_key485; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key485" UNIQUE (email);


--
-- Name: Users Users_email_key486; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key486" UNIQUE (email);


--
-- Name: Users Users_email_key487; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key487" UNIQUE (email);


--
-- Name: Users Users_email_key488; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key488" UNIQUE (email);


--
-- Name: Users Users_email_key489; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key489" UNIQUE (email);


--
-- Name: Users Users_email_key49; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key49" UNIQUE (email);


--
-- Name: Users Users_email_key490; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key490" UNIQUE (email);


--
-- Name: Users Users_email_key491; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key491" UNIQUE (email);


--
-- Name: Users Users_email_key492; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key492" UNIQUE (email);


--
-- Name: Users Users_email_key493; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key493" UNIQUE (email);


--
-- Name: Users Users_email_key494; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key494" UNIQUE (email);


--
-- Name: Users Users_email_key495; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key495" UNIQUE (email);


--
-- Name: Users Users_email_key496; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key496" UNIQUE (email);


--
-- Name: Users Users_email_key497; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key497" UNIQUE (email);


--
-- Name: Users Users_email_key498; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key498" UNIQUE (email);


--
-- Name: Users Users_email_key499; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key499" UNIQUE (email);


--
-- Name: Users Users_email_key5; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key5" UNIQUE (email);


--
-- Name: Users Users_email_key50; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key50" UNIQUE (email);


--
-- Name: Users Users_email_key500; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key500" UNIQUE (email);


--
-- Name: Users Users_email_key501; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key501" UNIQUE (email);


--
-- Name: Users Users_email_key502; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key502" UNIQUE (email);


--
-- Name: Users Users_email_key503; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key503" UNIQUE (email);


--
-- Name: Users Users_email_key504; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key504" UNIQUE (email);


--
-- Name: Users Users_email_key505; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key505" UNIQUE (email);


--
-- Name: Users Users_email_key506; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key506" UNIQUE (email);


--
-- Name: Users Users_email_key507; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key507" UNIQUE (email);


--
-- Name: Users Users_email_key508; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key508" UNIQUE (email);


--
-- Name: Users Users_email_key509; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key509" UNIQUE (email);


--
-- Name: Users Users_email_key51; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key51" UNIQUE (email);


--
-- Name: Users Users_email_key510; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key510" UNIQUE (email);


--
-- Name: Users Users_email_key511; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key511" UNIQUE (email);


--
-- Name: Users Users_email_key512; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key512" UNIQUE (email);


--
-- Name: Users Users_email_key513; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key513" UNIQUE (email);


--
-- Name: Users Users_email_key514; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key514" UNIQUE (email);


--
-- Name: Users Users_email_key515; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key515" UNIQUE (email);


--
-- Name: Users Users_email_key516; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key516" UNIQUE (email);


--
-- Name: Users Users_email_key517; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key517" UNIQUE (email);


--
-- Name: Users Users_email_key518; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key518" UNIQUE (email);


--
-- Name: Users Users_email_key519; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key519" UNIQUE (email);


--
-- Name: Users Users_email_key52; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key52" UNIQUE (email);


--
-- Name: Users Users_email_key520; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key520" UNIQUE (email);


--
-- Name: Users Users_email_key521; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key521" UNIQUE (email);


--
-- Name: Users Users_email_key522; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key522" UNIQUE (email);


--
-- Name: Users Users_email_key523; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key523" UNIQUE (email);


--
-- Name: Users Users_email_key524; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key524" UNIQUE (email);


--
-- Name: Users Users_email_key525; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key525" UNIQUE (email);


--
-- Name: Users Users_email_key526; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key526" UNIQUE (email);


--
-- Name: Users Users_email_key527; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key527" UNIQUE (email);


--
-- Name: Users Users_email_key528; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key528" UNIQUE (email);


--
-- Name: Users Users_email_key529; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key529" UNIQUE (email);


--
-- Name: Users Users_email_key53; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key53" UNIQUE (email);


--
-- Name: Users Users_email_key530; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key530" UNIQUE (email);


--
-- Name: Users Users_email_key531; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key531" UNIQUE (email);


--
-- Name: Users Users_email_key532; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key532" UNIQUE (email);


--
-- Name: Users Users_email_key533; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key533" UNIQUE (email);


--
-- Name: Users Users_email_key534; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key534" UNIQUE (email);


--
-- Name: Users Users_email_key535; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key535" UNIQUE (email);


--
-- Name: Users Users_email_key536; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key536" UNIQUE (email);


--
-- Name: Users Users_email_key537; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key537" UNIQUE (email);


--
-- Name: Users Users_email_key538; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key538" UNIQUE (email);


--
-- Name: Users Users_email_key539; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key539" UNIQUE (email);


--
-- Name: Users Users_email_key54; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key54" UNIQUE (email);


--
-- Name: Users Users_email_key540; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key540" UNIQUE (email);


--
-- Name: Users Users_email_key541; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key541" UNIQUE (email);


--
-- Name: Users Users_email_key542; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key542" UNIQUE (email);


--
-- Name: Users Users_email_key543; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key543" UNIQUE (email);


--
-- Name: Users Users_email_key544; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key544" UNIQUE (email);


--
-- Name: Users Users_email_key545; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key545" UNIQUE (email);


--
-- Name: Users Users_email_key546; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key546" UNIQUE (email);


--
-- Name: Users Users_email_key547; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key547" UNIQUE (email);


--
-- Name: Users Users_email_key548; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key548" UNIQUE (email);


--
-- Name: Users Users_email_key549; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key549" UNIQUE (email);


--
-- Name: Users Users_email_key55; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key55" UNIQUE (email);


--
-- Name: Users Users_email_key550; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key550" UNIQUE (email);


--
-- Name: Users Users_email_key551; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key551" UNIQUE (email);


--
-- Name: Users Users_email_key552; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key552" UNIQUE (email);


--
-- Name: Users Users_email_key553; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key553" UNIQUE (email);


--
-- Name: Users Users_email_key554; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key554" UNIQUE (email);


--
-- Name: Users Users_email_key56; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key56" UNIQUE (email);


--
-- Name: Users Users_email_key57; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key57" UNIQUE (email);


--
-- Name: Users Users_email_key58; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key58" UNIQUE (email);


--
-- Name: Users Users_email_key59; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key59" UNIQUE (email);


--
-- Name: Users Users_email_key6; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key6" UNIQUE (email);


--
-- Name: Users Users_email_key60; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key60" UNIQUE (email);


--
-- Name: Users Users_email_key61; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key61" UNIQUE (email);


--
-- Name: Users Users_email_key62; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key62" UNIQUE (email);


--
-- Name: Users Users_email_key63; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key63" UNIQUE (email);


--
-- Name: Users Users_email_key64; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key64" UNIQUE (email);


--
-- Name: Users Users_email_key65; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key65" UNIQUE (email);


--
-- Name: Users Users_email_key66; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key66" UNIQUE (email);


--
-- Name: Users Users_email_key67; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key67" UNIQUE (email);


--
-- Name: Users Users_email_key68; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key68" UNIQUE (email);


--
-- Name: Users Users_email_key69; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key69" UNIQUE (email);


--
-- Name: Users Users_email_key7; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key7" UNIQUE (email);


--
-- Name: Users Users_email_key70; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key70" UNIQUE (email);


--
-- Name: Users Users_email_key71; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key71" UNIQUE (email);


--
-- Name: Users Users_email_key72; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key72" UNIQUE (email);


--
-- Name: Users Users_email_key73; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key73" UNIQUE (email);


--
-- Name: Users Users_email_key74; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key74" UNIQUE (email);


--
-- Name: Users Users_email_key75; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key75" UNIQUE (email);


--
-- Name: Users Users_email_key76; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key76" UNIQUE (email);


--
-- Name: Users Users_email_key77; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key77" UNIQUE (email);


--
-- Name: Users Users_email_key78; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key78" UNIQUE (email);


--
-- Name: Users Users_email_key79; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key79" UNIQUE (email);


--
-- Name: Users Users_email_key8; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key8" UNIQUE (email);


--
-- Name: Users Users_email_key80; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key80" UNIQUE (email);


--
-- Name: Users Users_email_key81; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key81" UNIQUE (email);


--
-- Name: Users Users_email_key82; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key82" UNIQUE (email);


--
-- Name: Users Users_email_key83; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key83" UNIQUE (email);


--
-- Name: Users Users_email_key84; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key84" UNIQUE (email);


--
-- Name: Users Users_email_key85; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key85" UNIQUE (email);


--
-- Name: Users Users_email_key86; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key86" UNIQUE (email);


--
-- Name: Users Users_email_key87; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key87" UNIQUE (email);


--
-- Name: Users Users_email_key88; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key88" UNIQUE (email);


--
-- Name: Users Users_email_key89; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key89" UNIQUE (email);


--
-- Name: Users Users_email_key9; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key9" UNIQUE (email);


--
-- Name: Users Users_email_key90; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key90" UNIQUE (email);


--
-- Name: Users Users_email_key91; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key91" UNIQUE (email);


--
-- Name: Users Users_email_key92; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key92" UNIQUE (email);


--
-- Name: Users Users_email_key93; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key93" UNIQUE (email);


--
-- Name: Users Users_email_key94; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key94" UNIQUE (email);


--
-- Name: Users Users_email_key95; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key95" UNIQUE (email);


--
-- Name: Users Users_email_key96; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key96" UNIQUE (email);


--
-- Name: Users Users_email_key97; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key97" UNIQUE (email);


--
-- Name: Users Users_email_key98; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key98" UNIQUE (email);


--
-- Name: Users Users_email_key99; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_email_key99" UNIQUE (email);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (user_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: classrooms_course_rep_id_level_department; Type: INDEX; Schema: public; Owner: studymate_user
--

CREATE UNIQUE INDEX classrooms_course_rep_id_level_department ON public."Classrooms" USING btree (course_rep_id, level, department);


--
-- Name: leaderboards_user_id_classroom_id; Type: INDEX; Schema: public; Owner: studymate_user
--

CREATE INDEX leaderboards_user_id_classroom_id ON public."Leaderboards" USING btree (user_id, classroom_id);


--
-- Name: ClassroomStudents ClassroomStudents_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."ClassroomStudents"
    ADD CONSTRAINT "ClassroomStudents_classroom_id_fkey" FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ClassroomStudents ClassroomStudents_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."ClassroomStudents"
    ADD CONSTRAINT "ClassroomStudents_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public."Users"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Classrooms Classrooms_course_rep_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Classrooms"
    ADD CONSTRAINT "Classrooms_course_rep_id_fkey" FOREIGN KEY (course_rep_id) REFERENCES public."Users"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CourseSections CourseSections_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."CourseSections"
    ADD CONSTRAINT "CourseSections_classroom_id_fkey" FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Leaderboards Leaderboards_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Leaderboards"
    ADD CONSTRAINT "Leaderboards_classroom_id_fkey" FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Leaderboards Leaderboards_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Leaderboards"
    ADD CONSTRAINT "Leaderboards_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."Users"(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PastQuestions PastQuestions_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."PastQuestions"
    ADD CONSTRAINT "PastQuestions_classroom_id_fkey" FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PastQuestions PastQuestions_course_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."PastQuestions"
    ADD CONSTRAINT "PastQuestions_course_section_id_fkey" FOREIGN KEY (course_section_id) REFERENCES public."CourseSections"(course_section_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Slides Slides_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Slides"
    ADD CONSTRAINT "Slides_classroom_id_fkey" FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Slides Slides_course_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public."Slides"
    ADD CONSTRAINT "Slides_course_section_id_fkey" FOREIGN KEY (course_section_id) REFERENCES public."CourseSections"(course_section_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: announcements announcements_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: studymate_user
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public."Classrooms"(classroom_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO studymate_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO adeyemi;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO studymate_user;


--
-- PostgreSQL database dump complete
--

