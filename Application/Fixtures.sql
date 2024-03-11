

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


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.landing_pages DISABLE TRIGGER ALL;



ALTER TABLE public.landing_pages ENABLE TRIGGER ALL;


ALTER TABLE public.paragraph_ctas DISABLE TRIGGER ALL;



ALTER TABLE public.paragraph_ctas ENABLE TRIGGER ALL;


ALTER TABLE public.paragraph_quotes DISABLE TRIGGER ALL;



ALTER TABLE public.paragraph_quotes ENABLE TRIGGER ALL;


ALTER TABLE public.projects DISABLE TRIGGER ALL;

INSERT INTO public.projects (id, project_type, participants) VALUES ('e767f087-d1b9-42ea-898e-c2a2bf39999e', 'project_type_ongoing', '2');
INSERT INTO public.projects (id, project_type, participants) VALUES ('429177d7-f425-4c5e-b379-5e1a0f72bfb5', 'project_type_not_started', '3');
INSERT INTO public.projects (id, project_type, participants) VALUES ('84825fa3-2cce-4b4a-872b-81fe554e2076', 'project_type_not_started', '2');
INSERT INTO public.projects (id, project_type, participants) VALUES ('687e32f5-8e8b-4a6d-b4a7-ead9d8a39f91', 'project_type_finished', '2');


ALTER TABLE public.projects ENABLE TRIGGER ALL;


ALTER TABLE public.users DISABLE TRIGGER ALL;



ALTER TABLE public.users ENABLE TRIGGER ALL;


