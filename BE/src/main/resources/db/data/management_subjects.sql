-- Management Study Program (ID = 4) - New Subjects Import
-- This script imports subjects for the Management bachelor's study program
-- Some subjects already exist in the database and will only be mapped to the new study program

-- First, ensure the study program exists


-- study program subjects mappings

-- Year 1, Winter Semester
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 88, 'Pov.', 1, true);  -- ApAlg
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 89, 'Pov.', 1, true);  -- InfM1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 90, 'Pov.', 1, true);  -- MPZ
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 91, 'Pov.', 1, true);  -- VET
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 92, 'Pov.', 1, true);  -- Mž1

-- Year 1, Summer Semester (L)
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 93, 'Pov.', 1, false);  -- SZP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 94, 'Pov.', 1, false);  -- InfM2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 95, 'Pov.', 1, false);  -- Mtg
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 96, 'Pov.', 1, false);  -- OM
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 97, 'Pov.', 1, false);  -- POE

-- Year 2, Winter Semester (Z)
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 22, 'Pov.', 2, true);  -- MatA1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 98, 'Pov.', 2, true);  -- ManPsych
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 99, 'Pov.', 2, true);  -- FÚ
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 78, 'Pov.', 2, true);  -- PF

-- Year 2, Summer Semester (L)
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 49, 'Pov.', 2, false);  -- Soc
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 46, 'Pov.', 2, false);  -- SF
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 100, 'Pov.', 2, false);  -- MnŠ
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 101, 'Pov.', 2, false);  -- MiE

-- Year 3, Winter Semester (Z)
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 102, 'Pov.', 3, true);  -- CJB1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 103, 'Pov.', 3, true);  -- IMS
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 104, 'Pov.', 3, true);  -- MLZ1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 105, 'Pov.', 3, true);  -- ZVM
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 106, 'Pov.', 3, true);  -- PIS

-- Year 3, Summer Semester (L)
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 107, 'Pov.', 3, false);  -- CJB2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 80, 'Pov.', 3, false);  -- Prax
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 81, 'Pov.', 3, false);  -- BP

-- Povinne voliteľné predmety
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 108, 'P.v.', 1, true);  -- PAP1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 109, 'P.v.', 1, false);  -- PaP2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 110, 'P.v.', 2, true);  -- DM
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 111, 'P.v.', 2, true);  -- MKom
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 112, 'P.v.', 2, true);  -- RITP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 77, 'P.v.', 2, true);  -- DaR
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 113, 'P.v.', 2, false);  -- UDS
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 114, 'P.v.', 2, false);  -- FEA
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 115, 'P.v.', 2, false);  -- ŠP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 58, 'P.v.', 2, false);  -- ME
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 73, 'P.v.', 3, true);  -- ZTS
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 116, 'P.v.', 3, true);  -- AE
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 117, 'P.v.', 3, true);  -- PaC
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 118, 'P.v.', 3, false);  -- Mž2

-- Výberové predmety
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 6, 'Výb.', 1, true);  -- PCzM1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 119, 'Výb.', 1, true);  -- PIM1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 120, 'Výb.', 1, true);  -- IMG
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 36, 'Výb.', 1, true);  -- PP1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 121, 'Výb.', 1, true);  -- MŠP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 9, 'Výb.', 1, true);  -- TV1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 122, 'Výb.', 1, false);  -- MSD
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 123, 'Výb.', 1, false);  -- PIM2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 54, 'Výb.', 1, false);  -- PP2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 20, 'Výb.', 1, false);  -- TV2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 21, 'Výb.', 1, false);  -- TVS1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 57, 'Výb.', 1, false);  -- ESPD
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 30, 'Výb.', 2, true);  -- PCzM3
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 34, 'Výb.', 2, true);  -- JA1_inf
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 124, 'Výb.', 2, true);  -- JN1
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 37, 'Výb.', 2, true);  -- TV3
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 38, 'Výb.', 2, true);  -- TVS2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 125, 'Výb.', 2, false);  -- VMP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 53, 'Výb.', 2, false);  -- JA2_inf
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 126, 'Výb.', 2, false);  -- JN2
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 127, 'Výb.', 2, false);  -- SPEP
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 55, 'Výb.', 2, false);  -- TV4
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 128, 'Výb.', 3, true);  -- PŠM
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 129, 'Výb.', 3, true);  -- DS-Ac
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 69, 'Výb.', 3, true);  -- TP-PC
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 75, 'Výb.', 3, true);  -- TV5
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter) VALUES (4, 86, 'Výb.', 3, false);  -- TV6
