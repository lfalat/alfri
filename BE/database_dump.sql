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
    name           varchar(50)           NOT NULL
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
    title            varchar(100)           NOT NULL,
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
    name    varchar(50)           NOT NULL
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
    mark varchar(2),
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
    name             varchar(100)           NOT NULL
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
    obligation       varchar(4)           NOT NULL,
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
    name         varchar(100)           NOT NULL,
    code         varchar(50)            NOT NULL,
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
    email      varchar(100)           NOT NULL,
    first_name varchar(50)            NOT NULL,
    last_name  varchar(50)            NOT NULL,
    password   varchar(72)            NOT NULL
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

insert into public.questionnaire (questionnaire_id, title, description, date_of_creation) values (69, 'Úvodný dotazník', 'úvodný dotazník pre základnú predikciu študentov UNIZA', '2024-06-26 07:43:18.729131');

insert into public.questionnaire_section (section_id, questionnaire_id, section_title) values (61, 69, 'Základné informácie');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title) values (62, 69, 'Známky z povinných predmetov');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title) values (63, 69, 'Oblasti záujmov');
insert into public.questionnaire_section (section_id, questionnaire_id, section_title) values (64, 69, 'Voľnočasové aktivity');

INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (105, 61, 1, 1, 'Meno', false, 'question_meno');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (106, 61, 1, 2, 'Priezvisko', false, 'question_priezvisko');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (107, 61, 1, 3, 'Ročník v škole', false, 'question_rocnik');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (108, 61, 5, 4, 'Fakulta', false, 'question_fakulta');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (109, 61, 5, 5, 'Odbor', false, 'question_odbor');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (110, 62, 5, 1, 'Informatika 1', false, 'question_informatika1');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (111, 62, 5, 2, 'Informatika 2', false, 'question_informatika2');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (112, 62, 5, 3, 'Matematická analýza 1', false, 'question_matematicka_analyza_1');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (113, 62, 5, 4, 'Pravdepodobnosť a štatistika', false, 'question_pravdepodobnost_a_statistika');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (114, 62, 5, 5, 'Modelovanie a simulácia', false, 'question_modelovanie_a_simulacia');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (115, 63, 2, 1, 'Matematika', false, 'question_matematika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (116, 63, 2, 2, 'Dizajn', false, 'question_dizajn_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (117, 63, 2, 3, 'Hárdver', false, 'question_hardver_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (118, 63, 2, 4, 'Testovanie', false, 'question_testovanie_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (119, 63, 2, 5, 'Logika', false, 'question_logika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (120, 63, 2, 6, 'Ekonomika', false, 'question_ekonomika_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (121, 63, 2, 7, 'Siete', false, 'question_siete_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (122, 63, 2, 8, 'Jazyky', false, 'question_jazyky_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (123, 63, 2, 9, 'Programovanie', false, 'question_programovanie_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (124, 63, 2, 10, 'Manažment', false, 'question_manazment_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (125, 63, 2, 11, 'Dáta', false, 'question_data_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (126, 63, 2, 12, 'Fyzická aktivita', false, 'question_fyzicka_aktivita_focus');
INSERT INTO public.question (question_id, section_id, answer_type_id, position_in_questionnaire, question_title, optional, question_identifier) VALUES (127, 64, 4, 1, 'Voľnočasové aktivity', false, 'question_two');

-- newly added - not all inserts work as intended because not all of the subject codes are inserted in the subject table
ALTER TABLE subject ADD CONSTRAINT unique_code UNIQUE (code);

CREATE TABLE subject_keyword (
     keyword VARCHAR(255),
     subject_code1 VARCHAR(255),
     subject_code2 VARCHAR(255),
     subject_code3 VARCHAR(255),
     FOREIGN KEY (subject_code1) REFERENCES subject(code),
     FOREIGN KEY (subject_code2) REFERENCES subject(code),
     FOREIGN KEY (subject_code3) REFERENCES subject(code)
);

INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dát', '6UI0002', '6BI0005', '6BA0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('analýza', '6BM0004', '6UI0010', '6BA0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sietí', '6BI0053', '6BI0034', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pravdepodobnosti', '6BA0005', '6BA0015', '6UA0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('programovania', '6BM0028', '6BI0032', '6BA0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('systémy', '6BA0001', '6BI0051', '6BI0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('modelovanie', '6BE0002', '6BI0038', '6UA0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('operačného', '6BI0046', '6BI0009', '6BI0035');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('športoch', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('algoritmy', '6BA0002', '6BA0004', '6BI0042');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('aplikácií', '6BI0050', '6UI0012', '6BI0048');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sql', '6BI0005', '6BI0047', '6BI0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('grafov', '6BA0002', '6UI0006', '6UI0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komunikácie', '6BM0012', '6BI0003', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rovníc', '6BA0008', '6BA0001', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('analyzovať', '6BA0008', '6BA0007', '6BF0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kódu', '6BI0032', '6BH0003', '6BI0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podnikových', '6UM0007', '6BI0027', '6BL0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('derivácia', '6BA0006', '6BA0014', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lineárnych', '6BA0001', '6BI0043', '6BA0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieťach', '6BI0034', '6BI0027', '6BI0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('manažmentu', '6UM0008', '6BM0021', '6BM0010');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('telovýchovných', '6BT0001', '6BT0007', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tabuľky', '6UI0006', '6UI0004', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('linux', '6BI0018', '6BI0046', '6BI0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('testovanie', '6BI0032', '6BI0011', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informačné', '6UI0001', '6BA0013', '6BI0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rozhrania', '6BI0046', '6BI0051', '6BI0033');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komunikácia', '6UM0005', '6BI0035', '6BI0051');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('polia', '6BI0013', '6BA0001', '6BI0039');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lineárna', '6BA0001', '6BA0015', '6UI0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rovnice', '6BA0012', '6BA0007', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('návrh', '6BE0002', '6BI0019', '6UI0010');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lineárne', '6BI0008', '6BA0012', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('algoritmov', '6BI0041', '6BA0009', '6BA0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('siete', '6BI0053', '6BI0034', '6BI0052');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('navrhnúť', '6BM0010', '6BI0018', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('systéme', '6BI0046', '6BM0014', '6UI0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výkonnosti', '6BM0004', '6BM0027', '6BT0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pravdepodobnosť', '6BA0013', '6BA0005', '6BA0015');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('funkcia', '6BA0013', '6BA0005', '6BA0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podnikania', '6BM0003', '6BM0019', '6BM0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieťové', '6BI0034', '6BA0013', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('manažment', '6UM0008', '6BH0003', '6BJ0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lan', '6BI0026', '6BI0034', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matematická', '6BA0014', '6BA0013', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ict', '6BJ0006', '6BJ0005', '6BJ0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informatika', '6BA0013', '6BM0027', '6BJ0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('analýzu', '6UI0002', '6BH0003', '6UI0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('náhodnej', '6BA0005', '6UA0002', '6BA0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('internet', '6BI0034', '6BJ0006', '6UI0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('zariadenia', '6BI0034', '6BI0048', '6BI0052');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('protokoly', '6BI0034', '6BI0026', '6BI0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('programovanie', '6BI0051', '6BI0048', '6UI0010');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matice', '6BA0001', '6BA0013', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matematických', '6UI0006', '6BA0009', '6BA0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matematické', '6BA0009', '6UI0006', '6BA0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('premenné', '6BI0032', '6BA0005', '6BI0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('objekty', '6BI0013', '6BI0011', '6BI0032');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('športových', '6BM0025', '6BT0001', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výpočtovej', '6BA0015', '6UI0004', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('protokolov', '6BI0027', '6BI0034', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('os', '6BI0018', '6BI0027', '6BI0048');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komplexné', '6BA0001', '6BI0011', '6BA0012');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('športové', '6BT0001', '6BM0025', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ip', '6BI0028', '6BI0034', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('adries', '6BI0039', '6BI0034', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('bezpečnosti', '6BI0052', '6BI0034', '6BI0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('derivácie', '6BA0006', '6BA0013', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('spracovanie', '6BM0024', '6BA0015', '6BI0033');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ms', '6BI0006', '6UI0006', '6BM0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komponentov', '6BI0040', '6BA0003', '6UI0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('správy', '6BI0046', '6UM0004', '6BI0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('zdravému', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('hry', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('športovom', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('telesnej', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pohybovej', '6BT0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('bezpečnosť', '6BI0026', '6BI0028', '6UI0012');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('uml', '6BI0038', '6UI0010', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('projektov', '6BM0018', '6BH0003', '6BM0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('overenie', '6BI0032', '6BH0003', '6BI0033');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('architektúra', '6BI0039', '6BI0046', '6BI0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('limita', '6BA0006', '6BA0014', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('select', '6BI0005', '6BI0047', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('inštrukcie', '6BI0039', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tímovej', '6BM0027', '6BH0003', '6BM0014');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('parciálne', '6BA0006', '6BA0013', '6BA0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('zapúzdrenia', '6BI0033', '6BI0034', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieťových', '6BI0034', '6BI0027', '6BI0052');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('windows', '6BI0054', '6BI0046', '6BI0039');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('integrál', '6BA0006', '6BA0008', '6BA0014');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tlač', '6BI0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('navrhovať', '6BI0047', '6BA0007', '6BH0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informácie', '6BI0038', '6BI0057', '6BM0012');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('riadenia', '6BM0021', '6BM0010', '6BM0025');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sociológie', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('bmc', '6BM0019', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informatiky', '6BH0003', '6BA0009', '6BA0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diskrétna', '6BA0013', '6BA0008', '6BA0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieti', '6BI0052', '6BI0028', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dedičnosť', '6BI0012', '6BI0033', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('polymorfizmus', '6BI0012', '6BI0033', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komunikačné', '6BI0051', '6UM0005', '6UI0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pc', '6BI0040', '6BI0018', '6BJ0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rozhodovanie', '6BM0014', '6UM0007', '6BM0029');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('marketingu', '6BM0002', '6BM0011', '6BM0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('softvéru', '6BI0038', '6UI0010', '6UI0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ekonomických', '6BM0014', '6BM0024', '6BM0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informatike', '6BH0003', '6BA0009', '6BA0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('cyklus', '6BI0011', '6BI0032', '6BI0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ladenie', '6BI0032', '6BI0006', '6BI0041');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('protokol', '6BI0026', '6BI0027', '6BI0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diagnostika', '6BI0028', '6BI0052', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('štatistika', '6UA0002', '6BA0013', '6BM0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('štatistické', '6BM0006', '6BA0017', '6BM0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lyžovanie', '6BT0007', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ferraty', '6BT0007', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('teréne', '6BT0007', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('jazdy', '6BT0007', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('biznis', '6BM0020', '6UI0010', '6BM0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('python', '6BI0037', '6BI0021', '6BI0045');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('geodát', '6BI0024', '6BI0023', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('osm', '6BI0023', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('testovania', '6BI0055', '6UA0002', '6BI0016');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('latexu', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ekonomickej', '6UM0002', '6BM0027', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('počítačových', '6BI0034', '6BL0001', '6BI0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komponenty', '6BI0046', '6BI0018', '6BI0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('spojitosť', '6BA0006', '6BA0014', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('vzorce', '6UI0006', '6BA0006', '6UI0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('financií', '6UM0004', '6UM0007', '6BM0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('klasifikácia', '6BI0040', '6UM0004', '6BA0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('jazykové', '6BJ0003', '6BJ0004', '6BJ0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dynamické', '6BI0013', '6BI0021', '6BA0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('digitálnych', '6BI0007', '6BI0020', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('prezentuje', '6BM0027', '6BJ0007', '6UM0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('štatistických', '6BM0027', '6UA0002', '6BI0047');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('odhady', '6UA0002', '6BA0009', '6BM0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('algoritmus', '6BI0032', '6BI0033', '6BM0028');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('systémoch', '6UI0006', '6BL0001', '6BI0020');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('finančná', '6BL0001', '6UM0007', '6BM0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('hospodárenia', '6BM0017', '6BL0001', '6BM0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('smerovacích', '6BI0027', '6BI0034', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('operačných', '6BI0035', '6BI0046', '6BI0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('extrémy', '6BA0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('regresia', '6BA0015', '6UI0005', '6BA0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('visual', '6BI0006', '6BI0054', '6BI0016');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('mien', '6BI0007', '6BI0028', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dokumentov', '6UI0006', '6UM0008', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dane', '6UM0004', '6BM0027', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matíc', '6BA0001', '6BA0011', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matica', '6BA0001', '6BA0005', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informatických', '6BA0013', '6BA0009', '6BH0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('čísel', '6BA0009', '6BA0007', '6UA0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('objektového', '6BI0011', '6BI0032', '6BI0033');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('objektovej', '6BI0012', '6BI0011', '6BI0038');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('príkazov', '6BI0046', '6BI0011', '6UI0009');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tíme', '6BH0003', '6BF0001', '6UM0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výpočty', '6BA0005', '6BL0001', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výroba', '6BL0001', '6BM0014', '6UM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('literatúry', '6BI0034', '6UM0002', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('program', '6BA0013', '6BI0003', '6BI0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tlače', '6BI0001', '6UI0006', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dáta', '6BA0015', '6BF0001', '6BM0024');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('procesy', '6BA0015', '6BM0019', '6UI0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('daní', '6UM0004', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('aplikácia', '6BI0055', '6BI0047', '6BI0023');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('suffixes', '6BJ0005', '6BJ0006', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('implementovať', '6BI0026', '6BM0014', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sociológia', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('web', '6BI0024', '6BJ0006', '6BI0023');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('simulácia', '6BE0002', '6UA0003', '6BI0019');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podnikové', '6BM0003', '6BM0017', '6BI0053');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('qgis', '6BI0023', '6BI0024', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('údajových', '6UI0004', '6UI0009', '6BI0042');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('analýze', '6UI0002', '6BM0027', '6UA0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('transformácia', '6UI0005', '6BA0008', '6BA0015');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('lineárneho', '6BM0028', '6BA0010', '6BA0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('informačných', '6BH0003', '6BL0001', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('simulácie', '6BA0013', '6UA0003', '6BI0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('majetková', '6BL0001', '6UM0007', '6BM0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('architektúry', '6BI0034', '6BI0003', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komunikačných', '6BI0027', '6BI0034', '6BI0053');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('technológia', '6BI0034', '6BI0026', '6UI0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieťovej', '6BI0052', '6BI0034', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('počítačové', '6BA0013', '6BI0023', '6BI0024');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('používateľského', '6BI0046', '6BI0033', '6BI0050');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('limity', '6BA0014', '6BA0006', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('finančného', '6UM0007', '6UM0001', '6BI0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komunikácii', '6BJ0008', '6BJ0005', '6BJ0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podnikateľských', '6BM0020', '6BM0019', '6BM0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('is', '6UI0001', '6BJ0005', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podnikov', '6BM0017', '6BM0024', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('logických', '6BI0019', '6BE0001', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rozpočet', '6UM0004', '6BM0027', '6BM0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('algebry', '6BA0001', '6BI0019', '6BI0047');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('algebraické', '6BA0001', '6BA0014', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('vektory', '6BA0001', '6BA0013', '6BA0014');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('programy', '6BA0013', '6BI0011', '6BI0035');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('právne', '6BM0017', '6BH0003', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('objektové', '6BI0032', '6BI0048', '6BI0021');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pole', '6BI0032', '6BF0001', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('počítači', '6BI0003', '6BA0005', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('reprezentácia', '6BA0002', '6BI0003', '6UI0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('plán', '6BI0034', '6BL0001', '6BM0017');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ipv', '6BI0034', '6BI0026', '6BI0037');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rozhraním', '6BI0046', '6BI0033', '6BI0048');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieťová', '6BI0018', '6BI0026', '6BI0037');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('konvergencia', '6BA0011', '6BA0006', '6BA0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('derivácií', '6BA0006', '6BA0014', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('technické', '6BI0040', '6BI0001', '6BI0035');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diferenciálnych', '6BA0007', '6BA0008', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sociálne', '6BH0002', '6BM0002', '6BM0012');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('online', '6BM0002', '6BJ0008', '6BJ0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tabuliek', '6BI0006', '6UI0006', '6BI0047');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('knižnice', '6BI0047', '6BI0037', '6BI0045');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dátový', '6BI0005', '6BI0047', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('jazyk', '6UI0012', '6BI0047', '6BI0041');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('číslicových', '6BI0003', '6BI0019', '6BI0020');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('optimalizačné', '6BA0004', '6BA0010', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('obvodov', '6BI0036', '6BI0043', '6BE0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('testov', '6BI0055', '6UI0010', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('politika', '6BM0027', '6UM0002', '6BH0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('vektorového', '6BA0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('polynómy', '6BA0001', '6BA0013', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('determinantu', '6BA0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('objektovo', '6BI0011', '6BI0032', '6BI0038');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('atribúty', '6BI0032', '6BI0011', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('konštruktory', '6BI0013', '6BI0011', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('postupnosť', '6BI0011', '6BA0012', '6BA0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('asociácia', '6BI0011', '6BI0032', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('technológií', '6BI0053', '6BH0003', '6BA0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('nerovnice', '6BA0012', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('preťažovanie', '6BI0013', '6BI0032', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('plánovania', '6UM0008', '6BA0002', '6BI0057');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('programu', '6BI0012', '6BM0012', '6BI0039');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ošetrovanie', '6BI0033', '6BI0012', '6BI0013');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('internetu', '6UI0007', '6BI0034', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('ethernet', '6BI0034', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('icmpv', '6BI0034', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('náhodná', '6UA0002', '6BA0015', '6BM0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('procesora', '6BI0039', '6BA0013', '6BI0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výnimiek', '6BI0033', '6BI0013', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('integrály', '6BA0007', '6BA0006', '6BA0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tlačiarni', '6BI0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diskusia', '6BI0001', '6BH0002', '6BM0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('procesom', '6UI0010', '6BI0001', '6BM0022');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('finančné', '6UM0007', '6UM0001', '6BM0020');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kapitálu', '6UM0007', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('plánovanie', '6UM0003', '6BI0035', '6UM0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('softvérové', '6BA0010', '6BM0003', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('business', '6BM0003', '6BJ0005', '6BM0024');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tenses', '6BJ0005', '6BJ0001', '6BJ0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('geografických', '6BI0024', '6BI0023', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('geoserver', '6BI0024', '6BI0023', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dml', '6BI0005', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('java', '6BI0041', '6BI0021', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('rastrových', '6BI0024', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('office', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('libreoffice', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('latex', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kreslenie', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sadzba', '6UI0006', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('aritmetika', '6BA0001', '6BA0009', '6BI0039');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('vektorov', '6BA0001', '6BA0011', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('závislosť', '6BA0001', '6BI0012', '6UA0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('počítanie', '6BA0009', '6BA0012', '6BA0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('údajové', '6UI0009', '6BI0032', '6UI0004');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('náhodných', '6BA0005', '6BA0013', '6BA0015');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('generiká', '6BI0033', '6BI0012', '6BI0016');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('prezentácia', '6BL0001', '6BI0047', '6BM0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('tcpip', '6BI0034', '6BI0026', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('zabezpečenie', '6BI0034', '6BI0026', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('súborov', '6BI0046', '6BA0015', '6BI0034');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('premenná', '6UA0002', '6BA0013', '6BM0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('grafického', '6BI0046', '6BI0033', '6BI0050');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('operačný', '6BI0046', '6BI0018', '6BI0009');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('open', '6BI0018', '6UI0006', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('source', '6BI0018', '6UI0006', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('automatizácia', '6BI0027', '6BI0046', '6BI0055');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diferenciálneho', '6BA0006', '6BA0007', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('určitého', '6BA0006', '6BA0007', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('integrálu', '6BA0006', '6BA0007', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('numerické', '6BA0007', '6BA0004', '6BA0011');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('charakteristika', '6UM0007', '6UM0001', '6UM0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kontrola', '6BM0018', '6BH0002', '6UM0007');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sociálnej', '6BH0002', '6BU0001', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('manažéra', '6UM0008', '6BI0047', '6BM0014');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('marketing', '6BM0012', '6BM0002', '6BU0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('populárnovedeckých', '6BJ0007', '6BJ0008', '6BJ0005');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('speech', '6BJ0005', '6BJ0001', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('história', '6BI0007', '6BI0003', '6BH0002');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('procedúry', '6BI0005', '6BI0039', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('matematiky', '6BA0009', '6BA0012', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('alokácia', '6UM0007', '6BH0003', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('riadiacich', '6BI0032', '6BI0001', '6BM0010');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('logické', '6BE0001', '6BI0032', '6BI0020');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('cykly', '6BI0032', '6BI0039', '6BI0047');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diskrétne', '6BA0005', '6BA0015', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('balíčkov', '6BI0018', '6BI0012', '6BI0047');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('manažérske', '6BL0001', '6BM0025', '6BM0021');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('majetok', '6UM0001', '6BL0001', '6BM0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sieť', '6BI0034', '6BI0026', '6BI0053');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('zabezpečenia', '6BI0034', '6BI0007', '6BM0024');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('wifi', '6BI0053', '6BI0034', '6BI0026');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dns', '6BI0028', '6BI0034', '6BI0037');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('príkazový', '6BI0046', '6BI0018', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pohybu', '6BT0007', '6BF0001', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('grafickým', '6BI0046', '6BI0050', '6UI0006');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('modelovania', '6BI0001', '6BI0008', '6UA0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('vstavaných', '6BI0051', '6UI0009', '6BI0022');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pripojenie', '6BI0027', '6BI0051', '6BI0048');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('podsystém', '6BI0040', '6BI0051', '6BI0003');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('komplexných', '6BA0007', '6UA0003', '6BA0008');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('účtovníctva', '6UM0001', '6BM0004', '6BM0024');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('účtovné', '6UM0001', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('finančný', '6UM0007', '6UM0003', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('it', '6BM0018', '6UI0007', '6UI0001');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kvality', '6BM0018', '6BM0021', '6BI0027');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('výpočtové', '6BA0014', '6BI0043', '6BI0036');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('presentations', '6BJ0005', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('numbers', '6BJ0006', '6BJ0005', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('graphs', '6BJ0006', '6BJ0005', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('sociologického', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('kultúra', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('prednesenie', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('diskusie', '6BH0002', null, null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('pamäti', '6UI0004', '6BI0039', '6UI0009');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('implicitné', '6UI0004', '6BI0013', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('agregácia', '6BI0026', '6BI0013', null);
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('virtuálne', '6BI0045', '6BI0026', '6BI0052');
INSERT INTO subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('manažmente', '6UM0008', '6UM0003', null);
