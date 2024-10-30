--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.3

-- Started on 2024-06-30 01:50:45

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

SET default_tablespace = '';

SET default_table_access_method = heap;

-- CREATE USER alfri_be WITH PASSWORD 'password123';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO alfri_be;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO alfri_be;

--
-- TOC entry 240 (class 1259 OID 17971)
-- Name: answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer
(
    question_id      integer NOT NULL,
    user_id          integer NOT NULL,
    answer_id        integer NOT NULL,
    questionnaire_id integer NOT NULL
);


ALTER TABLE public.answer
    OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17991)
-- Name: answer_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answer_answer_id_seq OWNER TO postgres;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 241
-- Name: answer_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_answer_id_seq OWNED BY public.answer.answer_id;


--
-- TOC entry 243 (class 1259 OID 17993)
-- Name: answer_text; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer_text
(
    answer_text_id integer NOT NULL,
    answer_text    text    NOT NULL,
    answer_id      integer NOT NULL
);


ALTER TABLE public.answer_text
    OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17992)
-- Name: answer_text_answer_text_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_text_answer_text_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answer_text_answer_text_id_seq OWNER TO postgres;

--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 242
-- Name: answer_text_answer_text_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_text_answer_text_id_seq OWNED BY public.answer_text.answer_text_id;


--
-- TOC entry 215 (class 1259 OID 17608)
-- Name: answer_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer_type
(
    answer_type_id integer               NOT NULL,
    name           character varying(50) NOT NULL
);


ALTER TABLE public.answer_type
    OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17611)
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_type_answer_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answer_type_answer_type_id_seq OWNER TO postgres;

--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 216
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_type_answer_type_id_seq OWNED BY public.answer_type.answer_type_id;


--
-- TOC entry 217 (class 1259 OID 17612)
-- Name: focus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.focus
(
    math_focus       integer NOT NULL,
    logic_focus      integer NOT NULL,
    programming_focus integer NOT NULL,
    design_focus     integer NOT NULL,
    economics_focus  integer NOT NULL,
    management_focus integer NOT NULL,
    hardware_focus   integer NOT NULL,
    network_focus    integer NOT NULL,
    data_focus       integer NOT NULL,
    testing_focus    integer NOT NULL,
    language_focus   integer NOT NULL,
    physical_focus   integer NOT NULL,
    subject_id       integer NOT NULL
);


ALTER TABLE public.focus
    OWNER TO postgres;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE focus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.focus IS 'public.subject''s focuses';


--
-- TOC entry 218 (class 1259 OID 17632)
-- Name: options_answer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.options_answer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.options_answer_seq OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17633)
-- Name: question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question
(
    question_id         integer NOT NULL,
    section_id          integer NOT NULL,
    answer_type_id      integer NOT NULL,
    position_in_questionnaire integer NOT NULL,
    question_title      text    NOT NULL,
    optional            boolean NOT NULL,
    question_identifier text    NOT NULL
);


ALTER TABLE public.question
    OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17894)
-- Name: question_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_option
(
    question_option_id integer NOT NULL,
    question_option    text    NOT NULL,
    question_id        integer NOT NULL
);


ALTER TABLE public.question_option
    OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17893)
-- Name: question_options_question_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_options_question_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.question_options_question_option_id_seq OWNER TO postgres;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 237
-- Name: question_options_question_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_options_question_option_id_seq OWNED BY public.question_option.question_option_id;


--
-- TOC entry 220 (class 1259 OID 17638)
-- Name: question_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.question_question_id_seq OWNER TO postgres;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 220
-- Name: question_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_question_id_seq OWNED BY public.question.question_id;


--
-- TOC entry 221 (class 1259 OID 17639)
-- Name: questionnaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire
(
    questionnaire_id integer                NOT NULL,
    title            character varying(100) NOT NULL,
    description      text                   NOT NULL,
    date_of_creation timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.questionnaire
    OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17645)
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_questionnaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questionnaire_questionnaire_id_seq OWNER TO postgres;

--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 222
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_questionnaire_id_seq OWNED BY public.questionnaire.questionnaire_id;


--
-- TOC entry 236 (class 1259 OID 17862)
-- Name: questionnaire_section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_section
(
    section_id       integer NOT NULL,
    questionnaire_id integer,
    section_title    text
);


ALTER TABLE public.questionnaire_section
    OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17917)
-- Name: questionnaire_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questionnaire_section_id_seq OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 239
-- Name: questionnaire_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_section_id_seq OWNED BY public.questionnaire_section.section_id;


--
-- TOC entry 223 (class 1259 OID 17646)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role
(
    role_id integer               NOT NULL,
    name    character varying(50) NOT NULL
);


ALTER TABLE public.role
    OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17649)
-- Name: role_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_role_id_seq OWNER TO postgres;

--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 224
-- Name: role_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_role_id_seq OWNED BY public.role.role_id;


--
-- TOC entry 225 (class 1259 OID 17650)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student
(
    student_id integer NOT NULL,
    user_id    integer,
    study_program_id integer NOT NULL,
    year       integer NOT NULL
);


ALTER TABLE public.student
    OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17653)
-- Name: student_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_id OWNER TO postgres;

--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 226
-- Name: student_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id OWNED BY public.student.student_id;


--
-- TOC entry 227 (class 1259 OID 17654)
-- Name: student_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_subject
(
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    mark character varying(2),
    year integer NOT NULL
);


ALTER TABLE public.student_subject
    OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17657)
-- Name: study_program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_program
(
    study_program_id integer                NOT NULL,
    name             character varying(100) NOT NULL
);


ALTER TABLE public.study_program
    OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17660)
-- Name: study_program_id_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_program_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_program_id_sequence OWNER TO postgres;

--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 229
-- Name: study_program_id_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_program_id_sequence OWNED BY public.study_program.study_program_id;


--
-- TOC entry 230 (class 1259 OID 17661)
-- Name: study_program_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_program_subject
(
    study_program_id integer              NOT NULL,
    subject_id       integer              NOT NULL,
    obligation       character varying(4) NOT NULL,
    recommended_year integer              NOT NULL,
    semester_winter  boolean              NOT NULL
);


ALTER TABLE public.study_program_subject
    OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17664)
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject
(
    subject_id   integer                NOT NULL,
    name         character varying(100) NOT NULL,
    code         character varying(50)  NOT NULL,
    abbreviation text                   NOT NULL
);


ALTER TABLE public.subject
    OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17680)
-- Name: subject_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_grades
(
    subject_id     integer NOT NULL,
    grade_a        real    NOT NULL,
    grade_b        real    NOT NULL,
    grade_c        real    NOT NULL,
    grade_d        real    NOT NULL,
    grade_e        real,
    grade_fx       real,
    students_count integer NOT NULL,
    grade_average  real    NOT NULL
);


ALTER TABLE public.subject_grades
    OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17669)
-- Name: subject_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_subject_id_seq OWNER TO postgres;

--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 232
-- Name: subject_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_subject_id_seq OWNED BY public.subject.subject_id;


--
-- TOC entry 233 (class 1259 OID 17676)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user"
(
    user_id    integer                NOT NULL,
    role_id    integer                NOT NULL,
    email      character varying(100) NOT NULL,
    first_name character varying(50)  NOT NULL,
    last_name  character varying(50)  NOT NULL,
    password   character varying(72)  NOT NULL
);


ALTER TABLE public."user"
    OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17679)
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_user_id_seq OWNER TO postgres;

--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 234
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- TOC entry 3329 (class 2604 OID 18007)
-- Name: answer answer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ALTER COLUMN answer_id SET DEFAULT nextval('public.answer_answer_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 17996)
-- Name: answer_text answer_text_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_text
    ALTER COLUMN answer_text_id SET DEFAULT nextval('public.answer_text_answer_text_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 17683)
-- Name: answer_type answer_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_type
    ALTER COLUMN answer_type_id SET DEFAULT nextval('public.answer_type_answer_type_id_seq'::regclass);


--
-- TOC entry 3319 (class 2604 OID 17685)
-- Name: question question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ALTER COLUMN question_id SET DEFAULT nextval('public.question_question_id_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 17897)
-- Name: question_option question_option_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_option
    ALTER COLUMN question_option_id SET DEFAULT nextval('public.question_options_question_option_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 17686)
-- Name: questionnaire questionnaire_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire
    ALTER COLUMN questionnaire_id SET DEFAULT nextval('public.questionnaire_questionnaire_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 17919)
-- Name: questionnaire_section section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_section
    ALTER COLUMN section_id SET DEFAULT nextval('public.questionnaire_section_id_seq'::regclass);


--
-- TOC entry 3322 (class 2604 OID 17687)
-- Name: role role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ALTER COLUMN role_id SET DEFAULT nextval('public.role_role_id_seq'::regclass);


--
-- TOC entry 3323 (class 2604 OID 17688)
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ALTER COLUMN student_id SET DEFAULT nextval('public.student_id'::regclass);


--
-- TOC entry 3324 (class 2604 OID 17689)
-- Name: study_program study_program_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program
    ALTER COLUMN study_program_id SET DEFAULT nextval('public.study_program_id_sequence'::regclass);


--
-- TOC entry 3325 (class 2604 OID 17690)
-- Name: subject subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ALTER COLUMN subject_id SET DEFAULT nextval('public.subject_subject_id_seq'::regclass);


--
-- TOC entry 3326 (class 2604 OID 17691)
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);

--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 241
-- Name: answer_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_answer_id_seq', 2, true);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 242
-- Name: answer_text_answer_text_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_text_answer_text_id_seq', 1, true);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 216
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_type_answer_type_id_seq', 3, true);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 218
-- Name: options_answer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.options_answer_seq', 1, false);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 237
-- Name: question_options_question_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_options_question_option_id_seq', 48, true);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 220
-- Name: question_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_question_id_seq', 43, true);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 222
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_questionnaire_id_seq', 62, true);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 239
-- Name: questionnaire_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_section_id_seq', 45, true);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 224
-- Name: role_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_role_id_seq', 5, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 226
-- Name: student_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_id', 4, true);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 229
-- Name: study_program_id_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_program_id_sequence', 3, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 232
-- Name: subject_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_subject_id_seq', 175, true);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 234
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 9, true);


--
-- TOC entry 3363 (class 2606 OID 17975)
-- Name: answer answer_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT answer_id PRIMARY KEY (answer_id);


--
-- TOC entry 3365 (class 2606 OID 18000)
-- Name: answer_text answer_text_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_text
    ADD CONSTRAINT answer_text_pk PRIMARY KEY (answer_text_id);


--
-- TOC entry 3332 (class 2606 OID 17693)
-- Name: answer_type answer_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_type
    ADD CONSTRAINT answer_type_pk PRIMARY KEY (answer_type_id);


--
-- TOC entry 3334 (class 2606 OID 17695)
-- Name: focus focus_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.focus
    ADD CONSTRAINT focus_pk PRIMARY KEY (subject_id);


--
-- TOC entry 3361 (class 2606 OID 17899)
-- Name: question_option question_option_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_option
    ADD CONSTRAINT question_option_pk PRIMARY KEY (question_option_id);


--
-- TOC entry 3337 (class 2606 OID 17705)
-- Name: question question_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_pk PRIMARY KEY (question_id);


--
-- TOC entry 3339 (class 2606 OID 17707)
-- Name: questionnaire questionnaire_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire
    ADD CONSTRAINT questionnaire_pk PRIMARY KEY (questionnaire_id);


--
-- TOC entry 3359 (class 2606 OID 17868)
-- Name: questionnaire_section questionnaire_section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_section
    ADD CONSTRAINT questionnaire_section_pkey PRIMARY KEY (section_id);


--
-- TOC entry 3341 (class 2606 OID 17709)
-- Name: role role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pk PRIMARY KEY (role_id);


--
-- TOC entry 3343 (class 2606 OID 17711)
-- Name: student student_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pk PRIMARY KEY (student_id);


--
-- TOC entry 3345 (class 2606 OID 17713)
-- Name: student_subject student_subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_pk PRIMARY KEY (student_id, subject_id);


--
-- TOC entry 3347 (class 2606 OID 17715)
-- Name: study_program study_program_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program
    ADD CONSTRAINT study_program_pk PRIMARY KEY (study_program_id);


--
-- TOC entry 3349 (class 2606 OID 17717)
-- Name: study_program_subject study_program_subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject_pk PRIMARY KEY (subject_id, study_program_id);


--
-- TOC entry 3357 (class 2606 OID 17727)
-- Name: subject_grades subject_grades_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades_pk PRIMARY KEY (subject_id);


--
-- TOC entry 3351 (class 2606 OID 17719)
-- Name: subject subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pk PRIMARY KEY (subject_id);


--
-- TOC entry 3353 (class 2606 OID 17723)
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- TOC entry 3355 (class 2606 OID 17725)
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);


--
-- TOC entry 3335 (class 1259 OID 17925)
-- Name: fki_questionnaire_section_id_fk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_questionnaire_section_id_fk ON public.question USING btree (section_id);


--
-- TOC entry 3382 (class 2606 OID 18001)
-- Name: answer_text answer_text_answer_id___fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_text
    ADD CONSTRAINT answer_text_answer_id___fk FOREIGN KEY (answer_id) REFERENCES public.answer (answer_id);


--
-- TOC entry 3366 (class 2606 OID 17728)
-- Name: focus focus_subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.focus
    ADD CONSTRAINT focus_subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- TOC entry 3367 (class 2606 OID 17788)
-- Name: question question_answer_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_answer_type_fk FOREIGN KEY (answer_type_id) REFERENCES public.answer_type (answer_type_id);


--
-- TOC entry 3379 (class 2606 OID 17976)
-- Name: answer question_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT question_id FOREIGN KEY (question_id) REFERENCES public.question (question_id);


--
-- TOC entry 3378 (class 2606 OID 17931)
-- Name: question_option question_id___fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_option
    ADD CONSTRAINT question_id___fk FOREIGN KEY (question_id) REFERENCES public.question (question_id);


--
-- TOC entry 3377 (class 2606 OID 17869)
-- Name: questionnaire_section questionnaire_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_section
    ADD CONSTRAINT questionnaire_fk FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire (questionnaire_id) NOT VALID;


--
-- TOC entry 3368 (class 2606 OID 17920)
-- Name: question questionnaire_section_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT questionnaire_section_id_fk FOREIGN KEY (section_id) REFERENCES public.questionnaire_section (section_id);


--
-- TOC entry 3380 (class 2606 OID 17986)
-- Name: answer questionnaireid___fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT questionnaireid___fk FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire (questionnaire_id);


--
-- TOC entry 3369 (class 2606 OID 17798)
-- Name: student student_study_program_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_study_program_id_fk FOREIGN KEY (study_program_id) REFERENCES public.study_program (study_program_id);


--
-- TOC entry 3371 (class 2606 OID 17803)
-- Name: student_subject student_subject__student_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject__student_fk FOREIGN KEY (student_id) REFERENCES public.student (student_id);


--
-- TOC entry 3372 (class 2606 OID 17808)
-- Name: student_subject student_subject__subject_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject__subject_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- TOC entry 3370 (class 2606 OID 17813)
-- Name: student student_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_user_id_fk FOREIGN KEY (user_id) REFERENCES public."user" (user_id);


--
-- TOC entry 3373 (class 2606 OID 17818)
-- Name: study_program_subject study_program_subject__study_program_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject__study_program_fk FOREIGN KEY (study_program_id) REFERENCES public.study_program (study_program_id);


--
-- TOC entry 3374 (class 2606 OID 17823)
-- Name: study_program_subject study_program_subject__subject_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject__subject_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- TOC entry 3376 (class 2606 OID 17838)
-- Name: subject_grades subject_grades__subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades__subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- TOC entry 3381 (class 2606 OID 17981)
-- Name: answer user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer
    ADD CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES public."user" (user_id);


--
-- TOC entry 3375 (class 2606 OID 17833)
-- Name: user user_role_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_role_id_fk FOREIGN KEY (role_id) REFERENCES public.role (role_id);


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO alfri_be;


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE answer; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.answer TO alfri_be;


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE answer_answer_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.answer_answer_id_seq TO alfri_be;


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE answer_text; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.answer_text TO alfri_be;


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE answer_text_answer_text_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.answer_text_answer_text_id_seq TO alfri_be;


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE answer_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.answer_type TO alfri_be;


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE answer_type_answer_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.answer_type_answer_type_id_seq TO alfri_be;


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE focus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.focus TO alfri_be;


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE options_answer_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.options_answer_seq TO alfri_be;


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE question; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.question TO alfri_be;


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE question_option; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.question_option TO alfri_be;


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 237
-- Name: SEQUENCE question_options_question_option_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.question_options_question_option_id_seq TO alfri_be;


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE question_question_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.question_question_id_seq TO alfri_be;


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE questionnaire; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.questionnaire TO alfri_be;


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE questionnaire_questionnaire_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.questionnaire_questionnaire_id_seq TO alfri_be;


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE questionnaire_section; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.questionnaire_section TO alfri_be;


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE questionnaire_section_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.questionnaire_section_id_seq TO alfri_be;


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE role; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.role TO alfri_be;


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE role_role_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.role_role_id_seq TO alfri_be;


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE student; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student TO alfri_be;


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE student_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.student_id TO alfri_be;


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE student_subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student_subject TO alfri_be;


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE study_program; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.study_program TO alfri_be;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE study_program_id_sequence; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.study_program_id_sequence TO alfri_be;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE study_program_subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.study_program_subject TO alfri_be;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.subject TO alfri_be;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE subject_grades; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.subject_grades TO alfri_be;


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE subject_subject_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.subject_subject_id_seq TO alfri_be;


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."user" TO alfri_be;


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE user_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.user_user_id_seq TO alfri_be;

insert into public.answer_type (answer_type_id, name)
values (2, 'NUMERIC');
insert into public.answer_type (answer_type_id, name)
values (3, 'RADIO');
insert into public.answer_type (answer_type_id, name)
values (1, 'TEXT');
insert into public.answer_type (answer_type_id, name)
values (4, 'CHECKBOX');



INSERT INTO public.role (role_id, name)
VALUES (2, 'teacher');
INSERT INTO public.role (role_id, name)
VALUES (1, 'student');
INSERT INTO public.role (role_id, name)
VALUES (3, 'visitor');

INSERT INTO public.study_program (study_program_id, name)
VALUES (3, 'informatika');

INSERT INTO public.questionnaire (questionnaire_id, title, description, date_of_creation)
VALUES (2, 'Úvodný dotazník', 'úvod', '2024-05-23 11:11:21.000000');

INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (1, 1, 'nagy1@stud.uniza.sk', 'Adam', 'Nagy', '$2a$10$FWZ7zGzeQGdlMX3Bd.nTTOYyY0n8GtsGdgq53a414w65OPHgOv8Me');
INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (2, 1, 'majba@stud.uniza.sk', 'Maroš', 'Majba', '$2a$10$.s7derW1HlXmpRLyTEJjGOZEV6nZEuYYZqAWYXrIauIHLPm9u5mI6');
INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (3, 1, 'szathmary@stud.uniza.sk', 'Peter', 'Szathmáry',
        '$2a$10$rcn.t1DBfl67OcbY/5bqmeRGLuSVkueYmp19I/CgfMz0sQuS1UbM2');

INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (89, 'algebra', '6BA0001', 'Alg');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (90, 'matematika pre informatikov', '6BA0009', 'MpInf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (91, 'úvod do štúdia', '6BH0003', 'ÚŠ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (92, 'informatika 1', '6BI0011', 'INF1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (93, 'základy ekonómie', '6BM0027', 'ZE');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (94, 'praktické cvičenia z matematiky 1', '6BA0012', 'PCzM1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (95, 'praktikum z programovania 1', '6BI0032', 'PrzPr1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (96, 'slovenský jazyk 1', '6BJ0011', 'JS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (97, 'telesná výchova 1', '6BT0001', 'TV1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (98, 'algoritmická teória grafov', '6BA0002', 'ATG');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (99, 'diskrétna pravdepodobnosť', '6BA0005', 'DPrav');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (100, 'informatika 2', '6BI0012', 'INF2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (101, 'princípy IKS', '6BI0034', 'PIKS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (102, 'ekonomické a právne aspekty podnikania', '6BL0001', 'EaPAP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (103, 'praktické cvičenia z matematiky 2', '6BA0013', 'PCzM2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (104, 'linux - základy', '6BI0018', 'L-z');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (105, 'praktikum z programovania 2', '6BI0033', 'PrzPr2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (106, 'úvod do operačných systémov', '6BI0046', 'UdOS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (107, 'slovenský jazyk 2', '6BJ0012', 'SJ2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (108, 'telesná výchova 2', '6BT0002', 'TV2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (109, 'telovýchovné sústredenie 1', '6BT0007', 'TVS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (110, 'matematická analýza 1', '6BA0006', 'MatA1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (111, 'číslicové počítače', '6BI0003', 'ČísPoč');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (112, 'informatika 3', '6BI0013', 'INF3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (113, 'logické systémy', '6BI0019', 'LogS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (114, 'strojovo orientované jazyky', '6BI0039', 'SOJaz');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (115, '3D tlač', '6BI0001', '3DT');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (116, 'počítačové siete 1', '6BI0026', 'PS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (117, 'analýza procesov', '6UI0005', 'AP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (118, 'praktické cvičenia z matematiky 3', '6BA0014', 'PCzM3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (119, 'digitálne meny a blockchain', '6BI0007', 'DMB');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (120, 'otvorené geografické dáta 1', '6BI0023', 'OGD1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (121, 'UNIX - vývojové prostredie', '6BI0045', 'UNIXVP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (122, 'jazyk anglický 1', '6BJ0005', 'JA1_inf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (123, 'ekonómia podniku', '6BM0003', 'EP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (124, 'povolanie podnikateľ 1', '6BM0019', 'PP1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (125, 'telesná výchova 3', '6BT0003', 'TV3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (126, 'telovýchovné sústredenie 2', '6BT0008', 'TVS2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (127, 'diskrétna optimalizácia', '6BA0004', 'DO');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (128, 'databázové systémy', '6BI0005', 'DS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (129, 'pravdepodobnosť a štatistika', '6UA0002', 'PaŠ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (130, 'algoritmy a údajové štruktúry 1', '6UI0004', 'AaUD1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (131, 'matematická analýza 2', '6BA0007', 'MatA2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (132, 'jazyk C# a .NET', '6BI0016', 'JCN');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (133, 'počítačové siete 2', '6BI0027', 'PS2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (134, 'softvérové modelovanie', '6BI0038', 'SF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (135, 'vývoj aplikácií pre mobilné zariadenia', '6BI0048', 'VAMZ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (136, 'numerické metódy', '6BA0011', 'NM');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (137, 'sociológia', '6BH0002', 'Soc');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (138, 'metaprogramovanie', '6BI0021', 'MT');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (139, 'otvorené geografické dáta 2', '6BI0024', 'OGD2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (140, 'techniky programovania 1', '6BI0041', 'TechP1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (141, 'jazyk anglický 2', '6BJ0006', 'JA2_inf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (142, 'povolanie podnikateľ 2', '6BM0020', 'PP2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (143, 'telesná výchova 4', '6BT0004', 'TV4');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (144, 'tabuľkové procesory', '6UI0002', 'TP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (145, 'elektronické spracovanie a prezentácia dokumentov', '6UI0006', 'ESPD');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (146, 'makroekonómia', '6UM0002', 'ME');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (147, 'princípy operačných systémov', '6BI0035', 'POS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (148, 'anglický jazyk bc. 1', '6BJ0001', 'AJB1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (149, 'modelovanie a simulácia', '6UA0003', 'MS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (150, 'softvérové inžinierstvo', '6UI0010', 'SI');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (151, 'vývoj aplikácií pre internet a intranet', '6UI0012', 'VAII');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (152, 'modelovanie a optimalizácia', '6BA0010', 'ModaOp');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (153, 'počítačové siete 3', '6BI0028', 'PS3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (154, 'dáta, informácie, znalosti', '6UA0001', 'DIZ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (155, 'matematická analýza 3', '6BA0008', 'MatA3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (156, 'python v sieťových aplikáciách', '6BI0037', 'PSA');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (157, 'technické prostriedky PC', '6BI0040', 'TP-PC');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (158, 'techniky programovania 2', '6BI0042', 'TechP2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (159, 'zabezpečenie sietí zariadeniami Fortinet', '6BI0052', 'ZSZF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (160, 'základy programovania vo Windows', '6BI0054', 'ZPrvW');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (161, 'základy testovania softvéru', '6BI0055', 'ZTS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (162, 'ekonómia v praxi', '6BM0029', 'EvP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (163, 'telesná výchova 5', '6BT0005', 'TV5');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (164, 'internet vecí', '6UI0007', 'IV');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (165, 'dane a rozpočet', '6UM0004', 'DaR');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (166, 'podnikové financie', '6UM0007', 'PF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (167, 'anglický jazyk bc. 2', '6BJ0002', 'AJB2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (168, 'prax', '6BX0001', 'Prax');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (169, 'bakalárska práca', '6BZ0001', 'BP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (170, 'analýza viacrozmerných dát', '6BA0003', 'AVD');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (171, 'implementácie UNIXu-LINUX', '6BI0009', 'IU-Lin');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (172, 'vývoj aplikácií v Unity3D', '6BI0049', 'VAU3D');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (173, 'vývoj pokročilých aplikácií', '6BI0050', 'VPA');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (174, 'telesná výchova 6', '6BT0006', 'TV6');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (175, 'manažérska komunikácia', '6UM0005', 'MaKo');

INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (3, 2, 3, 3);
INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (2, 1, 3, 2);
INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (4, 3, 3, 4);


INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 147, 'B', 3);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 110, 'D', 2);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 108, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 93, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 91, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 89, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 90, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 93, 'D', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 90, 'E', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 92, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 92, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 91, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 90, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 91, 'D', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 89, 'E', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 89, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 93, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 92, 'D', 1);

INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 107, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 96, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 159, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 126, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 140, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 151, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 100, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 95, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 133, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 132, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 173, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 167, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 106, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 125, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 112, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 119, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 118, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 166, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 160, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 108, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 99, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 98, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 117, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 172, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 168, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 162, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 157, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 109, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 153, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 89, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 120, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 101, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 102, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 161, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 94, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 93, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 124, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 175, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 158, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 156, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 152, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 123, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 171, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 169, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 150, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 149, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 148, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 111, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 110, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 170, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 147, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 128, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 91, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 164, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 122, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 155, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 136, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 163, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 103, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 127, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 92, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 114, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 115, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 154, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 146, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 145, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 90, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 121, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 104, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 135, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 144, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 113, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 165, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 116, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 105, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 130, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 142, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 134, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 138, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 129, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 131, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 97, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 143, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 137, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 139, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 141, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 174, 'Výb.', 3, false);

INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 89);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 90);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 0, 4, 0, 0, 3, 0, 2, 0, 91);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 92);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (6, 6, 0, 0, 10, 3, 0, 0, 2, 0, 0, 0, 93);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 94);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 10, 2, 0, 0, 0, 0, 2, 5, 0, 0, 95);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 0, 0, 5, 0, 0, 0, 0, 10, 0, 96);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 97);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (7, 10, 6, 2, 0, 0, 0, 3, 5, 0, 0, 0, 98);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 7, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 99);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 100);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 6, 3, 2, 0, 0, 6, 10, 0, 0, 0, 0, 101);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 8, 10, 10, 0, 0, 0, 0, 0, 0, 102);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 103);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 104);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 105);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 6, 0, 0, 0, 4, 6, 0, 0, 0, 0, 106);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 0, 0, 5, 0, 0, 0, 0, 10, 0, 107);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 109);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 110);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 8, 4, 0, 0, 10, 0, 0, 0, 0, 0, 111);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 112);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 8, 4, 0, 0, 10, 0, 0, 0, 0, 0, 113);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 9, 4, 0, 0, 7, 0, 0, 0, 0, 0, 114);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 10, 0, 0, 10, 0, 0, 0, 0, 0, 115);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 116);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 0, 0, 0, 10, 0, 0, 0, 117);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 118);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 8, 0, 0, 10, 2, 0, 0, 6, 0, 0, 0, 119);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 2, 8, 0, 0, 0, 0, 6, 0, 0, 0, 120);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 121);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 122);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 123);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 124);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 125);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 126);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (8, 10, 5, 4, 0, 0, 0, 3, 5, 0, 0, 0, 127);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 10, 8, 6, 0, 4, 0, 2, 8, 0, 0, 0, 128);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 2, 0, 0, 10, 0, 0, 0, 129);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 10, 10, 3, 0, 0, 3, 0, 0, 8, 0, 0, 130);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 131);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 6, 0, 0, 0, 0, 0, 3, 0, 0, 132);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 133);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 3, 10, 0, 6, 0, 2, 0, 6, 0, 0, 134);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 6, 0, 0, 0, 0, 0, 3, 0, 0, 135);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 0, 0, 0, 10, 0, 0, 0, 136);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 0, 4, 7, 10, 0, 0, 4, 0, 0, 0, 137);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 6, 0, 0, 0, 0, 3, 2, 0, 0, 138);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 2, 8, 0, 0, 0, 0, 6, 0, 0, 0, 139);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 8, 0, 0, 0, 0, 2, 4, 0, 0, 140);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 141);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 142);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 143);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 6, 0, 4, 0, 4, 0, 0, 6, 0, 0, 0, 144);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 8, 0, 4, 0, 0, 3, 0, 2, 0, 145);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 4, 0, 6, 10, 7, 0, 0, 3, 0, 0, 0, 146);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 6, 0, 0, 0, 4, 6, 0, 0, 0, 0, 147);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 148);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 9, 4, 7, 3, 5, 0, 0, 10, 6, 0, 0, 149);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 3, 10, 0, 6, 0, 2, 0, 6, 0, 0, 150);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 8, 0, 0, 0, 0, 0, 7, 0, 0, 151);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 6, 4, 5, 2, 5, 0, 0, 10, 6, 0, 0, 152);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 153);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (6, 8, 5, 2, 6, 3, 0, 0, 10, 0, 0, 0, 154);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 155);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 10, 0, 0, 0, 0, 10, 6, 5, 0, 0, 156);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 5, 2, 3, 2, 0, 10, 2, 0, 0, 0, 0, 157);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 8, 0, 0, 0, 0, 2, 4, 0, 0, 158);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 2, 0, 0, 0, 0, 10, 2, 6, 0, 0, 159);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 160);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 7, 0, 0, 0, 0, 0, 0, 10, 0, 0, 161);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 4, 0, 6, 10, 7, 0, 0, 3, 0, 0, 0, 162);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 163);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 7, 0, 0, 9, 10, 0, 3, 0, 0, 164);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (8, 6, 0, 2, 10, 9, 0, 0, 6, 0, 0, 0, 165);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 4, 0, 0, 0, 166);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 167);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 168);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 169);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (7, 9, 3, 0, 7, 0, 0, 0, 10, 5, 0, 0, 170);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 171);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 8, 8, 8, 0, 0, 0, 0, 0, 4, 0, 0, 172);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 10, 9, 6, 0, 0, 4, 8, 0, 4, 0, 0, 173);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 174);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 4, 0, 10, 0, 0, 0, 0, 8, 0, 175);


INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0021'), 0.00, 0.00, 5.88, 0.00, 8.82, 85.29, 34,
        5.7348);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0011'), 3.10, 7.36, 6.98, 14.34, 19.19, 49.03, 516,
        4.8625);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0038'), 5.43, 4.35, 8.70, 20.65, 33.70, 27.17, 92,
        4.5435);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0010'), 2.08, 5.21, 13.54, 35.42, 16.67, 27.08, 96,
        4.4063);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0004'), 10.81, 2.70, 21.62, 16.22, 10.81, 37.84, 37,
        4.2704);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0006'), 8.54, 5.38, 11.39, 14.87, 48.42, 11.39, 316,
        4.2339);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BL0001'), 2.65, 5.30, 19.21, 33.11, 26.49, 13.25, 151,
        4.152699999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0002'), 4.76, 14.29, 14.29, 23.81, 28.57, 14.29, 21,
        4.0004);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0012'), 5.83, 3.33, 20.83, 30.00, 37.50, 2.50, 120,
        3.9748);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0034'), 5.86, 12.55, 18.83, 17.57, 33.89, 11.30, 239,
        3.9498);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0001'), 13.08, 11.21, 14.02, 15.89, 29.91, 15.89, 107,
        3.8601000000000005);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0002'), 16.28, 5.43, 14.73, 17.83, 35.66, 10.08, 129,
        3.8142999999999994);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0001'), 12.58, 9.20, 15.34, 22.70, 30.37, 9.82, 326,
        3.7857);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0012'), 8.70, 8.70, 21.74, 23.91, 30.43, 6.52, 46,
        3.7823);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0005'), 4.41, 4.41, 44.12, 22.06, 8.82, 16.18, 68,
        3.7500999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0009'), 7.50, 15.62, 20.00, 23.44, 18.75, 14.69, 320,
        3.7439);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0004'), 1.89, 16.98, 26.42, 30.19, 15.09, 9.43, 53,
        3.6790000000000003);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0007'), 46.88, 0.00, 0.00, 0.00, 0.00, 53.12, 64,
        3.6559999999999997);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0026'), 11.76, 13.24, 19.12, 24.26, 22.06, 9.56, 136,
        3.603);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0016'), 6.67, 13.33, 20.00, 33.33, 26.67, 0.00, 15,
        3.6);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0008'), 23.08, 7.69, 15.38, 7.69, 38.46, 7.69, 13,
        3.5380000000000003);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0035'), 3.82, 14.01, 33.12, 29.94, 13.38, 5.73, 157,
        3.5224);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0046'), 9.68, 16.13, 16.13, 38.71, 12.90, 6.45, 31,
        3.4837000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0027'), 21.74, 14.49, 11.59, 15.94, 18.84, 17.39, 69,
        3.4779);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0055'), 11.48, 13.93, 25.41, 27.05, 9.02, 13.11, 122,
        3.4753);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0010'), 7.49, 11.73, 32.57, 27.69, 15.31, 5.21, 307,
        3.4723);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0039'), 21.76, 11.92, 16.58, 11.40, 23.83, 14.51, 193,
        3.4715);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0020'), 20.29, 18.84, 20.29, 5.80, 7.25, 27.54, 69,
        3.4353000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0004'), 16.28, 13.95, 20.93, 23.26, 11.63, 13.95, 43,
        3.4186);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0041'), 0.00, 0.00, 66.67, 33.33, 0.00, 0.00, 3,
        3.3333);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0040'), 16.88, 7.79, 18.18, 40.26, 16.88, 0.00, 77,
        3.3244);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0002'), 22.73, 9.09, 13.64, 22.73, 31.82, 0.00, 22,
        3.3185000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0042'), 30.77, 15.38, 7.69, 7.69, 15.38, 23.08, 13,
        3.3074);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0005'), 7.14, 17.86, 30.95, 29.76, 10.71, 3.57, 84,
        3.2972);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0007'), 13.48, 16.85, 19.10, 34.83, 11.24, 4.49, 89,
        3.2694);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0005'), 8.90, 22.51, 31.41, 15.18, 15.18, 6.81, 191,
        3.2563);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0005'), 5.33, 25.00, 31.97, 23.77, 8.20, 5.74, 244,
        3.2176);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0028'), 8.70, 20.29, 34.78, 15.94, 18.84, 1.45, 69,
        3.2028);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0002'), 19.84, 15.87, 23.02, 15.08, 20.63, 5.56, 126,
        3.1746999999999996);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0003'), 10.93, 21.31, 30.05, 21.86, 10.93, 4.92, 183,
        3.1531000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0006'), 11.92, 21.85, 27.15, 22.52, 12.58, 3.97, 151,
        3.1387);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0019'), 22.97, 27.03, 12.16, 6.76, 16.22, 14.86, 74,
        3.1081);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0027'), 21.03, 13.10, 29.37, 18.25, 11.90, 6.35, 252,
        3.0594);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0005'), 11.76, 23.53, 29.41, 17.65, 17.65, 0.00, 17,
        3.0589999999999997);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0003'), 9.09, 18.79, 39.39, 26.67, 6.06, 0.00, 165,
        3.0181999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BZ0001'), 0.00, 0.00, 100.00, 0.00, 0.00, 0.00, 1, 3.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0050'), 25.00, 37.50, 0.00, 12.50, 0.00, 25.00, 8, 3.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0013'), 28.47, 13.17, 16.01, 21.00, 20.64, 0.71, 281,
        2.943);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BH0003'), 15.44, 23.54, 32.66, 16.71, 8.61, 3.04, 395,
        2.8863);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0001'), 27.33, 19.77, 16.86, 15.12, 18.31, 2.62, 344,
        2.852);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0048'), 30.00, 16.67, 13.33, 26.67, 6.67, 6.67, 30,
        2.8338);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0011'), 10.00, 60.00, 10.00, 0.00, 0.00, 20.00, 10,
        2.8);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0019'), 30.41, 17.97, 21.20, 11.98, 17.05, 1.38, 217,
        2.714);;
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0001'), 21.77, 33.58, 27.31, 15.13, 1.48, 0.74, 271,
        2.4322);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0032'), 31.91, 28.72, 17.02, 12.77, 8.51, 1.06, 94,
        2.404);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0012'), 51.69, 15.25, 10.59, 4.66, 10.59, 7.20, 236,
        2.2875);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0007'), 41.67, 25.00, 12.50, 10.42, 6.25, 4.17, 48,
        2.2712);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0033'), 40.00, 24.00, 20.00, 6.00, 6.00, 4.00, 50,
        2.26);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BH0002'), 42.22, 22.22, 20.00, 2.22, 11.11, 2.22, 45,
        2.2441);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0006'), 40.74, 29.63, 14.81, 3.70, 3.70, 7.41, 27,
        2.2218999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0013'), 48.00, 20.00, 8.00, 20.00, 4.00, 0.00, 25,
        2.12);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0002'), 34.71, 36.36, 19.42, 4.96, 0.83, 3.72, 242,
        2.12);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0049'), 0.00, 100.00, 0.00, 0.00, 0.00, 0.00, 1, 2.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0014'), 28.07, 54.39, 15.79, 0.00, 1.75, 0.00, 57,
        1.9297);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0024'), 61.54, 15.38, 7.69, 7.69, 7.69, 0.00, 13,
        1.8458);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0003'), 69.70, 18.18, 0.00, 3.03, 0.00, 9.09, 33,
        1.7272);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0037'), 76.19, 2.38, 5.95, 7.14, 7.14, 1.19, 84, 1.702);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0009'), 68.42, 21.05, 0.00, 5.26, 0.00, 5.26, 19,
        1.6312);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0045'), 67.27, 18.18, 3.64, 7.27, 3.64, 0.00, 55,
        1.6182999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0054'), 57.14, 42.86, 0.00, 0.00, 0.00, 0.00, 7,
        1.4286);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0023'), 72.73, 22.73, 0.00, 0.00, 4.55, 0.00, 22,
        1.4094);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0018'), 81.16, 14.01, 3.86, 0.97, 0.00, 0.00, 207,
        1.2464);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0001'), 96.12, 0.97, 0.00, 0.49, 0.49, 1.94, 206,
        1.1411);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0007'), 90.71, 6.56, 2.73, 0.00, 0.00, 0.00, 183,
        1.1201999999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0003'), 97.27, 0.00, 0.45, 0.45, 0.00, 1.82, 220,
        1.1134);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0005'), 98.03, 0.00, 0.00, 0.00, 0.00, 1.97, 152,
        1.0985);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0006'), 98.33, 0.83, 0.00, 0.00, 0.00, 0.83, 120,
        1.0497);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0002'), 97.96, 1.36, 0.00, 0.00, 0.00, 0.68, 147,
        1.0475999999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0007'), 99.20, 0.00, 0.80, 0.00, 0.00, 0.00, 125,
        1.016);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0004'), 99.32, 0.68, 0.00, 0.00, 0.00, 0.00, 148,
        1.0068);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0008'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 13, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BX0001'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 309, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0052'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 31, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0029'), 0, 0, 0, 0, 0, 0, 0, 0.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0003'), 0, 0, 0, 0, 0, 0, 0, 0.0);

INSERT INTO public.answer_type (answer_type_id, name)
VALUES (5, 'DROPDOWN');

insert into public.questionnaire (questionnaire_id, title, description, date_of_creation)
values (69, 'Úvodný dotazník', 'úvodný dotazník pre základnú predikciu študentov UNIZA', '2024-06-26 07:43:18.729131');

insert into public.questionnaire_section (section_id, questionnaire_id, section_title)
values (61, 69, 'Základné informácie');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title)
values (62, 69, 'Známky z povinných predmetov');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title)
values (63, 69, 'Oblasti záujmov');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title)
values (64, 69, 'Voľnočasové aktivity');

INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (105, 61, 1, 1, 'Meno', false, 'question_meno');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (106, 61, 1, 2, 'Priezvisko', false, 'question_priezvisko');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (107, 61, 1, 3, 'Ročník v škole', false, 'question_rocnik');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (108, 61, 5, 4, 'Fakulta', false, 'question_fakulta');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (109, 61, 5, 5, 'Odbor', false, 'question_odbor');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (110, 62, 5, 1, 'Informatika 1', false, 'question_informatika1');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (111, 62, 5, 2, 'Informatika 2', false, 'question_informatika2');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (112, 62, 5, 3, 'Matematická analýza 1', false, 'question_matematicka_analyza_1');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (113, 62, 5, 4, 'Pravdepodobnosť a štatistika', false, 'question_pravdepodobnost_a_statistika');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (114, 62, 5, 5, 'Modelovanie a simulácia', false, 'question_modelovanie_a_simulacia');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (115, 63, 2, 1, 'Matematika', false, 'question_matematika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (116, 63, 2, 2, 'Dizajn', false, 'question_dizajn_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (117, 63, 2, 3, 'Hárdver', false, 'question_hardver_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (118, 63, 2, 4, 'Testovanie', false, 'question_testovanie_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (119, 63, 2, 5, 'Logika', false, 'question_logika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (120, 63, 2, 6, 'Ekonomika', false, 'question_ekonomika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (121, 63, 2, 7, 'Siete', false, 'question_siete_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (122, 63, 2, 8, 'Jazyky', false, 'question_jazyky_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (123, 63, 2, 9, 'Programovanie', false, 'question_programovanie_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (124, 63, 2, 10, 'Manažment', false, 'question_manazment_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (125, 63, 2, 11, 'Dáta', false, 'question_data_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (126, 63, 2, 12, 'Fyzická aktivita', false, 'question_fyzicka_aktivita_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title,
                             optional, question_identifier)
VALUES (127, 64, 4, 1, 'Voľnočasové aktivity', false, 'question_two');

CREATE SEQUENCE subject_grade_correlation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

create table public.subject_grade_correlation
(
    first_subject  integer,
    second_subject integer,
    correlation    double precision    not null,
    id             integer primary key not null default nextval('subject_grade_correlation_id_seq'::regclass),
    foreign key (first_subject) references public.subject (subject_id)
        match simple on update no action on delete no action,
    foreign key (second_subject) references public.subject (subject_id)
        match simple on update no action on delete no action
);

INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 89, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 90, 0.03826682455661278);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 92, -0.02709510464671677);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 91, -0.02936716804199381);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 94, -0.030142110244715213);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 98, 0.03553684277307609);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 99, 0.03813336055800914);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 100, 0.01433880597332955);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 101, -0.0528468519990133);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 105, -0.02461132466079115);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 110, 0.02532079568053233);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 112, -0.031123050111317385);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 117, 0.02682961049581364);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 127, -0.09638451060863304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 128, 0.02111509515457636);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 129, -0.026567102941711614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 114, -0.6);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 111, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 147, -0.008214930368702054);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 148, -0.02211788674281554);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 149, -0.01607546891483633);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 150, 0.03624837829493869);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 103, 0.7);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 154, 0.09967947488688635);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 169, 0.021401947616770712);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 95, 0.2);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 127, 0.3);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 149, -0.2);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (89, 115, -1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 154, -0.4);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 129, 0.5);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 110, 0.8);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 111, -0.7);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 100, 0.9);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 148, -1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 89, 0.03826682455661278);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 90, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 92, 0.04112693353145285);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 91, 0.00024706585590422725);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 95, -0.015042491575122304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 94, 0.027679661062465374);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 98, 0.03311494859904338);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 99, 0.061834895110284206);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 100, 0.03544702427314111);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 101, -0.0017174499610896582);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 103, 0.017718921896322078);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 105, -0.008673372425814964);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 110, -0.011972169345199816);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 111, 0.011571736819023683);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 112, 0.03336599585429054);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 114, -0.0012744488916041122);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 115, -0.05990318887817419);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 117, 0.10757804929921908);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 127, -0.03753719007337353);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 128, 0.00899718792913378);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 129, 0.014012311451131416);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 114, 0.2);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 147, -0.005406395430805226);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 148, -0.07393768198196932);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 149, 0.040158639665483144);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 150, -0.020768150846734994);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 154, -0.020203072221092452);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (90, 169, 0.052307509375808255);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 89, -0.02709510464671677);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 90, 0.04112693353145285);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 92, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 91, 0.0542725537281143);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 95, -0.025649704632363924);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 94, 0.019435205836368024);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 98, -0.040447768665872776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 99, 0.03459922237844916);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 101, -0.05093893107442262);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 103, 0.017492503810119804);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 105, -0.03291882905214925);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 111, 0.02671245752230301);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 112, -0.03476883995093298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 115, 0.04167193691439548);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 117, -0.016589169683287205);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 128, -0.03302187807252146);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 147, 0.055306062683062776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 148, 0.1709004567911334);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 150, 0.015792386099607647);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 154, 0.004963942246928699);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (92, 169, 0.023881082457858298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 89, -0.02936716804199381);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 90, 0.00024706585590422725);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 92, 0.0542725537281143);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 91, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 95, 0.03654463188687411);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 94, 0.014933965736710013);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 98, -0.0039671575690624515);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 99, 0.03472770625987408);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 100, 0.009142348952415379);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 101, 0.006444334374404247);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 103, -0.01986539673388952);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 105, 0.025633514100253225);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 110, -0.03755809790542678);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 112, -0.03235804111725775);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 114, -0.035880003259443606);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 115, 0.008570551932138055);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 117, -0.03711926414319685);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 127, 0.012191882405152737);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 128, 0.011652540141170304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 129, 0.02342339126440065);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 147, -0.017486601079024822);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 149, -0.02840245455320249);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 150, -0.06355015863920614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (91, 169, -0.007431473031847822);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 89, 0.0280811032948066);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 90, -0.015042491575122304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 92, -0.025649704632363924);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 91, 0.03654463188687411);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 95, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 94, -0.03720079169142529);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 98, 0.02381496663967938);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 99, 0.006543869439212815);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 100, -0.0757539465574432);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 101, 0.006949888652921325);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 103, 0.004288839864973147);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 105, 0.03289839252465824);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 110, 0.0010032622429836165);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 111, 0.06792094019558843);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 112, 0.05771558690810576);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 114, -0.053742603083804845);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 115, -0.050157511310758955);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 117, -0.018406789656558762);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 127, -0.003214305240451573);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 128, 0.03568682765232552);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 129, 0.04382818495641486);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 147, 0.05664915630639602);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 148, 0.008858639603981899);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 149, 0.005560263674405874);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 150, 0.061546421188749076);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 154, 0.03725155201193982);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (95, 169, -0.04140681615181018);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 89, -0.030142110244715213);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 90, 0.027679661062465374);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 92, 0.019435205836368024);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 91, 0.014933965736710013);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 95, -0.03720079169142529);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 94, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 98, 0.0018677227142526451);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 99, -0.05272085816298114);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 100, -0.02649625772708581);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 101, -0.05002686777158499);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 103, -0.03312280918333819);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 105, -0.008870970751164357);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 110, 0.019198059399957404);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 111, 0.033291185402822665);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 112, 0.09273195683681817);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 114, 0.015365613594360353);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 115, 0.028380921374309517);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 117, 0.11047266469041957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 127, 0.010466143314548778);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 128, 0.025397104527325583);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 129, 0.004175213804057231);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 147, 0.0658197592223672);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 148, -0.06124114656842414);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 149, 0.10291393256947776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 150, -0.08323934851155261);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 154, 0.04084255625264228);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (94, 169, 0.008637959064392568);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 89, 0.03553684277307609);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 90, 0.03311494859904338);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 92, -0.040447768665872776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 91, -0.0039671575690624515);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 95, 0.02381496663967938);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 94, 0.0018677227142526451);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 98, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 99, 0.006727152582182051);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 100, -0.014422887122965954);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 101, 0.028851372395345687);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 103, 0.03648132122420298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 105, -0.02694849726307339);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 110, 0.15263306020881642);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 111, 0.05202458595248073);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 112, 0.017797756989573837);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 114, -0.004963466417862592);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 115, -0.03066497028438584);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 117, 0.012886678432519307);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 127, 0.012750592393244364);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 128, -0.04614471619038345);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 129, -0.04587528710822522);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 147, 0.02165914829163559);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 148, 0.002980300416495643);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 149, -0.05480418315656328);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 150, -0.008706847493355456);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 154, 0.0013971358367875762);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (98, 169, -0.051949573807845296);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 89, 0.03813336055800914);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 90, 0.061834895110284206);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 92, 0.03459922237844916);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 91, 0.03472770625987408);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 95, 0.006543869439212815);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 94, -0.05272085816298114);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 98, 0.006727152582182051);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 99, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 100, 0.042715587823687326);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 101, -0.023306815850686464);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 103, 0.015627880547993134);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 105, -0.005475571607573211);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 110, -0.007407041433319151);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 111, 0.02537377974900371);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 112, 0.02785077788252344);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 114, -0.0075454059702948885);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 115, -0.03389674563766029);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 117, -0.00691943743075019);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 127, 0.07001575238571334);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 128, -0.009829872911169409);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 129, 0.09106144820603485);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 147, -0.0496588862894899);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 148, 0.0031660386076270064);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 149, -0.006934498887017066);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 150, -0.03954181904910483);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 154, -0.05763872999764547);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (99, 169, 0.08563401187393516);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 89, 0.01433880597332955);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 90, 0.03544702427314111);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 92, 0.03767129738524125);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 91, 0.009142348952415379);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 95, -0.0757539465574432);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 94, -0.02649625772708581);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 98, -0.014422887122965954);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 99, 0.042715587823687326);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 100, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 101, 0.09910470776013519);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 103, 0.025183186362007365);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 105, -0.013710247703898826);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 110, -0.043198024714360614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 111, 0.016663055637877927);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 112, -0.060539376385771865);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 114, 0.03427563962236257);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 115, 0.047896360248227195);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 117, -0.010217617399930583);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 127, 0.03671532523940551);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 128, 0.04650140211564046);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 129, -0.04422698721159858);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 147, 0.04178407922765229);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 148, -0.061032740902295816);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 149, -0.05455205241481897);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 150, 0.07669906863026904);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 154, 0.039731761882175476);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (100, 169, -0.04684139695812868);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 89, -0.0528468519990133);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 90, -0.0017174499610896582);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 92, -0.05093893107442262);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 91, 0.006444334374404247);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 95, 0.006949888652921325);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 94, -0.05002686777158499);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 98, 0.028851372395345687);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 99, -0.023306815850686464);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 100, 0.09910470776013519);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 101, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 103, -0.04175877248634507);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 105, -0.014331687402776608);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 110, -0.07927939047380939);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 111, 0.013864020923445415);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 112, 0.01928543446433772);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 114, -0.0015314929499458546);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 115, 0.05629925664580851);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 117, 0.0022814310308548517);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 127, -0.011496293593170998);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 128, -0.0017973003729252965);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 129, 0.04901186560656042);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 147, -0.07104603446800829);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 148, 0.02005555283463022);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 149, 0.041584915601088436);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 150, 0.04837646949493096);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 154, -0.02332008823628629);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (101, 169, -0.06790266071983274);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 89, -0.0013507384289578764);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 90, 0.017718921896322078);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 92, 0.017492503810119804);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 91, -0.01986539673388952);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 95, 0.004288839864973147);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 94, -0.03312280918333819);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 98, 0.03648132122420298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 99, 0.015627880547993134);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 100, 0.025183186362007365);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 101, -0.04175877248634507);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 103, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 105, 0.03183300894558527);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 110, -0.013674426189568118);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 111, -0.04668765204283975);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 112, -0.005039479767129375);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 114, -0.031751297912969836);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 115, 0.01936273870152207);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 117, 0.009688984376693768);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 127, -0.07595779955961914);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 128, 0.008787953082353042);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 129, 0.025534037265285615);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 147, -0.08139116689332711);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 148, -0.023689417961155698);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 149, -0.06343320113175388);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 150, -0.0700455235776471);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 154, -0.003094001558056828);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (103, 169, -0.0020433603142967272);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 89, -0.02461132466079115);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 90, -0.008673372425814964);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 92, -0.03291882905214925);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 91, 0.025633514100253225);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 95, 0.03289839252465824);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 94, -0.008870970751164357);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 98, -0.02694849726307339);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 99, -0.005475571607573211);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 100, -0.013710247703898826);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 101, -0.014331687402776608);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 103, 0.03183300894558527);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 105, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 110, -0.0460626290874204);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 111, 0.030212853188459888);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 112, -0.03688516912610167);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 114, -0.028353627562187466);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 115, -0.009228437945444642);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 117, 0.05588343878088943);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 127, -0.03904423832385793);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 128, -0.02841584161923439);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 129, -0.03248339375749095);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 147, -0.07328254517952823);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 148, 0.04183350820281416);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 149, 0.0369000514010301);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 150, 0.01821853917756726);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 154, 0.060948761271584724);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (105, 169, -0.02144632963922996);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 89, 0.02532079568053233);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 90, -0.011972169345199816);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 92, 0.04374569462032354);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 91, -0.03755809790542678);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 95, 0.0010032622429836165);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 94, 0.019198059399957404);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 98, 0.15263306020881642);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 99, -0.007407041433319151);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 100, -0.043198024714360614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 101, -0.07927939047380939);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 103, -0.013674426189568118);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 105, -0.0460626290874204);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 110, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 111, 0.00808945438657382);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 112, -0.011644587226793682);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 114, 0.06860842117396423);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 115, -0.006279185247164262);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 117, 0.009444424923346496);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 127, 0.05871906019865205);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 128, 0.0025394353604574057);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 129, -0.012669188847334338);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 147, 0.07729011418650511);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 148, -0.08143312804174653);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 149, 0.037921446466494965);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 150, 0.003688414159376476);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 154, -0.01565004997204141);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (110, 169, 0.01922914764400532);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 89, -0.03262908292953918);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 90, 0.011571736819023683);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 92, 0.02671245752230301);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 91, -0.00910587875620738);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 95, 0.06792094019558843);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 94, 0.033291185402822665);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 98, 0.05202458595248073);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 99, 0.02537377974900371);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 100, 0.016663055637877927);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 101, 0.013864020923445415);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 103, -0.04668765204283975);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 105, 0.030212853188459888);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 110, 0.00808945438657382);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 111, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 112, -0.00848645364634227);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 114, -0.046041042955977565);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 115, -0.045564488967801346);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 117, 0.05255978907387606);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 127, 0.03479156816993457);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 128, 0.027707993782823608);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 129, -0.02260656784796875);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 147, 0.10080422383926303);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 148, -0.07233064304460284);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 149, 0.05750130756011588);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 150, 0.004966408411008841);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 154, -0.032519702315360374);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (111, 169, 0.008344565452998711);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 89, -0.031123050111317385);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 90, 0.03336599585429054);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 92, -0.03476883995093298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 91, -0.03235804111725775);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 95, 0.05771558690810576);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 94, 0.09273195683681817);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 98, 0.017797756989573837);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 99, 0.02785077788252344);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 100, -0.060539376385771865);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 101, 0.01928543446433772);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 103, -0.005039479767129375);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 105, -0.03688516912610167);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 110, -0.011644587226793682);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 111, -0.00848645364634227);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 112, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 114, 0.019728146971925604);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 115, -0.006214639300118572);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 117, -0.03556835315048128);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 127, -0.01453072129293221);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 128, -0.02252166107541251);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 129, 0.03168216924475062);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 147, 0.007987002246539456);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 148, 0.02874488363809613);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 149, -0.008641034392062373);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 150, 0.07155710194564653);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 154, 0.050416440597216276);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (112, 169, 0.00015744281190606567);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 89, 0.036738412439871033);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 90, -0.0012744488916041122);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 92, 0.004270415066217616);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 91, -0.035880003259443606);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 95, -0.053742603083804845);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 94, 0.015365613594360353);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 98, -0.004963466417862592);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 99, -0.0075454059702948885);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 100, 0.03427563962236257);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 101, -0.0015314929499458546);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 103, -0.031751297912969836);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 105, -0.028353627562187466);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 110, 0.06860842117396423);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 111, -0.046041042955977565);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 112, 0.019728146971925604);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 114, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 115, 0.05381985793571712);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 117, 0.06933779449391093);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 127, 0.021792343838718052);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 128, -0.009885245750285293);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 129, 0.04158958576541402);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 147, -0.09451494088833336);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 148, -0.08268615712964504);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 149, -0.057139921330587366);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 150, 0.00411012177510957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 154, -0.015638725741161184);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (114, 169, 0.03401382286233791);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 89, -0.056670222446053006);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 90, -0.05990318887817419);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 92, 0.04167193691439548);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 91, 0.008570551932138055);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 95, -0.050157511310758955);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 94, 0.028380921374309517);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 98, -0.03066497028438584);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 99, -0.03389674563766029);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 100, 0.047896360248227195);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 101, 0.05629925664580851);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 103, 0.01936273870152207);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 105, -0.009228437945444642);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 110, -0.006279185247164262);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 111, -0.045564488967801346);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 112, -0.006214639300118572);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 114, 0.05381985793571712);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 115, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 117, -0.012530795253553429);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 127, -0.032786870529041556);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 128, -0.00024076943917600388);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 129, -0.03353673378248949);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 147, 0.06176691455615775);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 148, 0.03542304513167534);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 149, 0.04451295927815279);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 150, -0.048596075598043804);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 154, -0.011301740270072311);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (115, 169, 0.08976624793282177);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 89, 0.02682961049581364);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 90, 0.10757804929921908);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 92, -0.016589169683287205);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 91, -0.03711926414319685);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 95, -0.018406789656558762);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 94, 0.11047266469041957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 98, 0.012886678432519307);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 99, -0.00691943743075019);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 100, -0.010217617399930583);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 101, 0.0022814310308548517);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 103, 0.009688984376693768);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 105, 0.05588343878088943);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 110, 0.009444424923346496);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 111, 0.05255978907387606);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 112, -0.03556835315048128);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 114, 0.06933779449391093);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 115, -0.012530795253553429);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 117, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 127, 0.007967234710701872);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 128, 0.07631890929793479);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 129, 0.034359913535145094);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 147, 0.028179329230381342);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 148, -0.02756483881060153);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 149, -0.01945440098857673);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 150, -0.145210730917976);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 154, 0.07977404355225001);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (117, 169, -0.03789036766770491);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 89, -0.09638451060863304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 90, -0.03753719007337353);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 92, 0.05185312712156384);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 91, 0.012191882405152737);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 95, -0.003214305240451573);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 94, 0.010466143314548778);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 98, 0.012750592393244364);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 99, 0.07001575238571334);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 100, 0.03671532523940551);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 101, -0.011496293593170998);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 103, -0.07595779955961914);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 105, -0.03904423832385793);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 110, 0.05871906019865205);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 111, 0.03479156816993457);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 112, -0.01453072129293221);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 114, 0.021792343838718052);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 115, -0.032786870529041556);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 117, 0.007967234710701872);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 127, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 128, 0.004698553794833548);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 129, 0.00835865469619378);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 147, 0.05466858128144139);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 148, -0.0033670156957843716);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 149, -0.044805077875104474);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 150, 0.06487675289470249);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 154, -0.06051015354622761);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (127, 169, -0.06527829422195129);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 89, 0.02111509515457636);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 90, 0.00899718792913378);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 92, -0.03302187807252146);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 91, 0.011652540141170304);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 95, 0.03568682765232552);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 94, 0.025397104527325583);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 98, -0.04614471619038345);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 99, -0.009829872911169409);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 100, 0.04650140211564046);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 101, -0.0017973003729252965);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 103, 0.008787953082353042);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 105, -0.02841584161923439);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 110, 0.0025394353604574057);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 111, 0.027707993782823608);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 112, -0.02252166107541251);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 114, -0.009885245750285293);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 115, -0.00024076943917600388);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 117, 0.07631890929793479);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 127, 0.004698553794833548);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 128, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 129, 0.07439195401657672);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 147, -0.075177437441814);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 148, 0.0630515230505254);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 149, 0.04582120606991595);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 150, 0.04433857011992887);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 154, 0.007580843860171407);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (128, 169, -0.0027074629196020715);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 89, -0.026567102941711614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 90, 0.014012311451131416);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 92, 0.022518491744979413);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 91, 0.02342339126440065);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 95, 0.04382818495641486);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 94, 0.004175213804057231);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 98, -0.04587528710822522);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 99, 0.09106144820603485);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 100, -0.04422698721159858);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 101, 0.04901186560656042);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 103, 0.025534037265285615);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 105, -0.03248339375749095);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 110, -0.012669188847334338);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 111, -0.02260656784796875);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 112, 0.03168216924475062);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 114, 0.04158958576541402);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 115, -0.03353673378248949);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 117, 0.034359913535145094);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 127, 0.00835865469619378);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 128, 0.07439195401657672);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 129, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 147, -0.09101422267809957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 148, -0.05231546664612163);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 149, -0.014998651534472272);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 150, -0.02715275935024331);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 154, 0.036897546245200474);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (129, 169, -0.148892199517563);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 89, -0.008214930368702054);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 90, -0.005406395430805226);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 92, 0.055306062683062776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 91, -0.017486601079024822);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 95, 0.05664915630639602);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 94, 0.0658197592223672);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 98, 0.02165914829163559);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 99, -0.0496588862894899);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 100, 0.04178407922765229);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 101, -0.07104603446800829);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 103, -0.08139116689332711);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 105, -0.07328254517952823);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 110, 0.07729011418650511);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 111, 0.10080422383926303);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 112, 0.007987002246539456);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 114, -0.09451494088833336);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 115, 0.06176691455615775);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 117, 0.028179329230381342);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 127, 0.05466858128144139);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 128, -0.075177437441814);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 129, -0.09101422267809957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 147, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 148, -0.053825296210327764);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 149, 0.017664547497501168);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 150, 0.06725233422374591);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 154, -0.029669500871293372);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (147, 169, 0.062063376234094275);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 89, -0.02211788674281554);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 90, -0.07393768198196932);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 92, 0.1709004567911334);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 91, 0.05483145972645912);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 95, 0.008858639603981899);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 94, -0.06124114656842414);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 98, 0.002980300416495643);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 99, 0.0031660386076270064);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 100, -0.061032740902295816);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 101, 0.02005555283463022);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 103, -0.023689417961155698);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 105, 0.04183350820281416);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 110, -0.08143312804174653);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 111, -0.07233064304460284);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 112, 0.02874488363809613);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 114, -0.08268615712964504);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 115, 0.03542304513167534);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 117, -0.02756483881060153);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 127, -0.0033670156957843716);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 128, 0.0630515230505254);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 129, -0.05231546664612163);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 147, -0.053825296210327764);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 148, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 149, -0.03415499457431179);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 150, 0.01615775129001179);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 154, -0.02518657997149516);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (148, 169, 0.1711286435982699);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 89, -0.01607546891483633);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 90, 0.040158639665483144);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 92, 0.04017555744873516);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 91, -0.02840245455320249);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 95, 0.005560263674405874);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 94, 0.10291393256947776);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 98, -0.05480418315656328);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 99, -0.006934498887017066);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 100, -0.05455205241481897);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 101, 0.041584915601088436);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 103, -0.06343320113175388);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 105, 0.0369000514010301);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 110, 0.037921446466494965);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 111, 0.05750130756011588);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 112, -0.008641034392062373);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 114, -0.057139921330587366);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 115, 0.04451295927815279);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 117, -0.01945440098857673);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 127, -0.044805077875104474);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 128, 0.04582120606991595);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 129, -0.014998651534472272);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 147, 0.017664547497501168);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 148, -0.03415499457431179);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 149, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 150, -0.030365800008713903);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 154, 0.07866419906403992);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (149, 169, 0.006105226334737056);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 89, 0.03624837829493869);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 90, -0.020768150846734994);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 92, 0.015792386099607647);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 91, -0.06355015863920614);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 95, 0.061546421188749076);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 94, -0.08323934851155261);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 98, -0.008706847493355456);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 99, -0.03954181904910483);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 100, 0.07669906863026904);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 101, 0.04837646949493096);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 103, -0.0700455235776471);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 105, 0.01821853917756726);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 110, 0.003688414159376476);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 111, 0.004966408411008841);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 112, 0.07155710194564653);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 114, 0.00411012177510957);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 115, -0.048596075598043804);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 117, -0.145210730917976);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 127, 0.06487675289470249);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 128, 0.04433857011992887);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 129, -0.02715275935024331);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 147, 0.06725233422374591);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 148, 0.01615775129001179);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 149, -0.030365800008713903);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 150, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 154, 0.022152432794412237);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (150, 169, 0.021225825597264106);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 89, 0.09967947488688635);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 90, -0.020203072221092452);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 92, 0.004963942246928699);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 91, -0.016453775811983623);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 95, 0.03725155201193982);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 94, 0.04084255625264228);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 98, 0.0013971358367875762);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 99, -0.05763872999764547);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 100, 0.039731761882175476);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 101, -0.02332008823628629);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 103, -0.003094001558056828);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 105, 0.060948761271584724);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 110, -0.01565004997204141);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 111, -0.032519702315360374);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 112, 0.050416440597216276);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 114, -0.015638725741161184);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 115, -0.011301740270072311);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 117, 0.07977404355225001);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 127, -0.06051015354622761);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 128, 0.007580843860171407);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 129, 0.036897546245200474);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 147, -0.029669500871293372);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 148, -0.02518657997149516);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 149, 0.07866419906403992);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 150, 0.022152432794412237);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 154, 1);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (154, 169, -0.07317711019495152);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 89, 0.021401947616770712);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 90, 0.052307509375808255);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 92, 0.023881082457858298);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 91, -0.007431473031847822);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 95, -0.04140681615181018);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 94, 0.008637959064392568);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 98, -0.051949573807845296);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 99, 0.08563401187393516);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 100, -0.04684139695812868);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 101, -0.06790266071983274);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 103, -0.0020433603142967272);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 105, -0.02144632963922996);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 110, 0.01922914764400532);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 111, 0.008344565452998711);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 112, 0.00015744281190606567);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 114, 0.03401382286233791);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 115, 0.08976624793282177);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 117, -0.03789036766770491);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 127, -0.06527829422195129);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 128, -0.0027074629196020715);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 129, -0.148892199517563);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 147, 0.062063376234094275);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 148, 0.1711286435982699);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 149, 0.006105226334737056);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 150, 0.021225825597264106);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 154, -0.07317711019495152);
INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)
VALUES (169, 169, 1);