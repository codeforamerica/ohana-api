--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: blog_post_attachments_file_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.blog_post_attachments_file_type AS ENUM (
    'image',
    'video',
    'audio'
);


--
-- Name: post_approval_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.post_approval_statuses AS ENUM (
    'pending',
    'approved',
    'denied'
);


--
-- Name: fill_search_vector_for_location(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fill_search_vector_for_location() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
          declare
            location_organization record;
            location_services_keywords record;
            location_services_description record;
            location_services_name record;
            service_categories record;

          begin
            select name into location_organization from organizations where id = new.organization_id;

            select string_agg(keywords, ' ') as keywords into location_services_keywords from services where location_id = new.id;
            select description into location_services_description from services where location_id = new.id;
            select name into location_services_name from services where location_id = new.id;

            select string_agg(categories.name, ' ') as name into service_categories from locations
            JOIN services ON services.location_id = new.id
            JOIN categories_services ON categories_services.service_id = services.id
            JOIN categories ON categories.id = categories_services.category_id;

            new.tsv_body :=
              setweight(to_tsvector('pg_catalog.english', coalesce(new.name, '')), 'B')                  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'A')                ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_organization.name, '')), 'B')        ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_description.description, '')), 'A')  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_name.name, '')), 'B')  ||
              setweight(to_tsvector('pg_catalog.english', coalesce(location_services_keywords.keywords, '')), 'B') ||
              setweight(to_tsvector('pg_catalog.english', coalesce(service_categories.name, '')), 'A');

            return new;
          end
          $$;


--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
$_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    location_id integer,
    address_1 text,
    city text,
    state_province text,
    postal_code text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country character varying NOT NULL,
    address_2 character varying
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    super_admin boolean DEFAULT false
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: api_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_applications (
    id integer NOT NULL,
    user_id integer,
    name text,
    main_url text,
    callback_url text,
    api_token text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: api_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_applications_id_seq OWNED BY public.api_applications.id;


--
-- Name: blog_post_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_post_attachments (
    id integer NOT NULL,
    file_type public.blog_post_attachments_file_type,
    file_url character varying,
    file_legend character varying,
    "order" integer,
    blog_post_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blog_post_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_post_attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_post_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_post_attachments_id_seq OWNED BY public.blog_post_attachments.id;


--
-- Name: blog_post_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_post_images (
    id integer NOT NULL,
    local_identifier character varying,
    remote_url character varying,
    organization_id integer,
    image character varying
);


--
-- Name: blog_post_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_post_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_post_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_post_images_id_seq OWNED BY public.blog_post_images.id;


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_posts (
    id integer NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    posted_at timestamp without time zone NOT NULL,
    is_published boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer,
    user_id integer,
    images json
);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_posts_id_seq OWNED BY public.blog_posts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text,
    taxonomy_id text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    ancestry character varying
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: categories_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories_services (
    category_id integer NOT NULL,
    service_id integer NOT NULL
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    location_id integer,
    name text,
    title text,
    email text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    department character varying,
    organization_id integer,
    service_id integer
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    title character varying NOT NULL,
    body text,
    posted_at timestamp without time zone NOT NULL,
    starting_at timestamp without time zone,
    ending_at timestamp without time zone,
    street_1 character varying NOT NULL,
    street_2 character varying,
    city character varying NOT NULL,
    state_abbr character varying,
    zip character varying,
    phone character varying,
    external_url character varying,
    is_featured boolean DEFAULT false,
    organization_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    is_all_day boolean
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendly_id_slugs_id_seq OWNED BY public.friendly_id_slugs.id;


--
-- Name: holiday_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.holiday_schedules (
    id integer NOT NULL,
    location_id integer,
    service_id integer,
    closed boolean NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    opens_at time without time zone,
    closes_at time without time zone
);


--
-- Name: holiday_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.holiday_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: holiday_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.holiday_schedules_id_seq OWNED BY public.holiday_schedules.id;


--
-- Name: jwt_blacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jwt_blacklist (
    id integer NOT NULL,
    jti character varying NOT NULL,
    exp timestamp without time zone NOT NULL
);


--
-- Name: jwt_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jwt_blacklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jwt_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jwt_blacklist_id_seq OWNED BY public.jwt_blacklist.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    organization_id integer,
    accessibility text,
    admin_emails text,
    description text,
    latitude double precision,
    longitude double precision,
    languages text[] DEFAULT '{}'::text[],
    name text,
    short_desc text,
    transportation text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tsv_body tsvector,
    alternate_name character varying,
    virtual boolean DEFAULT false,
    active boolean DEFAULT true,
    website character varying,
    email character varying,
    is_primary boolean
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: mail_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_addresses (
    id integer NOT NULL,
    location_id integer,
    attention text,
    address_1 text,
    city text,
    state_province text,
    postal_code text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country character varying NOT NULL,
    address_2 character varying
);


--
-- Name: mail_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_addresses_id_seq OWNED BY public.mail_addresses.id;


--
-- Name: org_profile_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.org_profile_images (
    id integer NOT NULL,
    local_identifier character varying,
    remote_url character varying,
    organization_id integer,
    image character varying
);


--
-- Name: org_profile_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.org_profile_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: org_profile_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.org_profile_images_id_seq OWNED BY public.org_profile_images.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    alternate_name character varying,
    date_incorporated date,
    description text NOT NULL,
    email character varying,
    legal_status character varying,
    tax_id character varying,
    tax_status character varying,
    website character varying,
    funding_sources character varying[] DEFAULT '{}'::character varying[],
    accreditations character varying[] DEFAULT '{}'::character varying[],
    licenses character varying[] DEFAULT '{}'::character varying[],
    twitter character varying,
    facebook character varying,
    linkedin character varying,
    logo_url text,
    rank integer,
    approval_status public.post_approval_statuses,
    is_published boolean DEFAULT false,
    user_id integer,
    image character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: phones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phones (
    id integer NOT NULL,
    location_id integer,
    number text,
    department text,
    extension text,
    vanity_number text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    number_type character varying,
    country_prefix character varying,
    contact_id integer,
    organization_id integer,
    service_id integer
);


--
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phones_id_seq OWNED BY public.phones.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programs (
    id integer NOT NULL,
    organization_id integer,
    name character varying,
    alternate_name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programs_id_seq OWNED BY public.programs.id;


--
-- Name: regular_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regular_schedules (
    id integer NOT NULL,
    weekday integer,
    opens_at time without time zone,
    closes_at time without time zone,
    service_id integer,
    location_id integer
);


--
-- Name: regular_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regular_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regular_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regular_schedules_id_seq OWNED BY public.regular_schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id integer NOT NULL,
    location_id integer,
    audience text,
    description text NOT NULL,
    eligibility text,
    fees text,
    application_process text,
    name text,
    wait_time text,
    funding_sources text,
    service_areas text,
    keywords text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    accepted_payments character varying[] DEFAULT '{}'::character varying[],
    alternate_name character varying,
    email character varying,
    languages character varying[] DEFAULT '{}'::character varying[],
    required_documents character varying[] DEFAULT '{}'::character varying[],
    status character varying DEFAULT 'active'::character varying NOT NULL,
    website character varying,
    program_id integer,
    interpretation_services text
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: api_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_applications ALTER COLUMN id SET DEFAULT nextval('public.api_applications_id_seq'::regclass);


--
-- Name: blog_post_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_attachments ALTER COLUMN id SET DEFAULT nextval('public.blog_post_attachments_id_seq'::regclass);


--
-- Name: blog_post_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_images ALTER COLUMN id SET DEFAULT nextval('public.blog_post_images_id_seq'::regclass);


--
-- Name: blog_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts ALTER COLUMN id SET DEFAULT nextval('public.blog_posts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('public.friendly_id_slugs_id_seq'::regclass);


--
-- Name: holiday_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holiday_schedules ALTER COLUMN id SET DEFAULT nextval('public.holiday_schedules_id_seq'::regclass);


--
-- Name: jwt_blacklist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jwt_blacklist ALTER COLUMN id SET DEFAULT nextval('public.jwt_blacklist_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: mail_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_addresses ALTER COLUMN id SET DEFAULT nextval('public.mail_addresses_id_seq'::regclass);


--
-- Name: org_profile_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_profile_images ALTER COLUMN id SET DEFAULT nextval('public.org_profile_images_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: phones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phones ALTER COLUMN id SET DEFAULT nextval('public.phones_id_seq'::regclass);


--
-- Name: programs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs ALTER COLUMN id SET DEFAULT nextval('public.programs_id_seq'::regclass);


--
-- Name: regular_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_schedules ALTER COLUMN id SET DEFAULT nextval('public.regular_schedules_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: api_applications api_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_applications
    ADD CONSTRAINT api_applications_pkey PRIMARY KEY (id);


--
-- Name: blog_post_attachments blog_post_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_attachments
    ADD CONSTRAINT blog_post_attachments_pkey PRIMARY KEY (id);


--
-- Name: blog_post_images blog_post_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_images
    ADD CONSTRAINT blog_post_images_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: holiday_schedules holiday_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holiday_schedules
    ADD CONSTRAINT holiday_schedules_pkey PRIMARY KEY (id);


--
-- Name: jwt_blacklist jwt_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jwt_blacklist
    ADD CONSTRAINT jwt_blacklist_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mail_addresses mail_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_addresses
    ADD CONSTRAINT mail_addresses_pkey PRIMARY KEY (id);


--
-- Name: org_profile_images org_profile_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.org_profile_images
    ADD CONSTRAINT org_profile_images_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: regular_schedules regular_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regular_schedules
    ADD CONSTRAINT regular_schedules_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: categories_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX categories_name ON public.categories USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: index_addresses_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_location_id ON public.addresses USING btree (location_id);


--
-- Name: index_admins_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_confirmation_token ON public.admins USING btree (confirmation_token);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_api_applications_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_api_applications_on_api_token ON public.api_applications USING btree (api_token);


--
-- Name: index_api_applications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_applications_on_user_id ON public.api_applications USING btree (user_id);


--
-- Name: index_blog_post_images_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blog_post_images_on_organization_id ON public.blog_post_images USING btree (organization_id);


--
-- Name: index_categories_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_ancestry ON public.categories USING btree (ancestry);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_slug ON public.categories USING btree (slug);


--
-- Name: index_categories_services_on_category_id_and_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_services_on_category_id_and_service_id ON public.categories_services USING btree (category_id, service_id);


--
-- Name: index_categories_services_on_service_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_services_on_service_id_and_category_id ON public.categories_services USING btree (service_id, category_id);


--
-- Name: index_contacts_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_location_id ON public.contacts USING btree (location_id);


--
-- Name: index_contacts_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_organization_id ON public.contacts USING btree (organization_id);


--
-- Name: index_contacts_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_service_id ON public.contacts USING btree (service_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON public.friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_holiday_schedules_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_holiday_schedules_on_location_id ON public.holiday_schedules USING btree (location_id);


--
-- Name: index_holiday_schedules_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_holiday_schedules_on_service_id ON public.holiday_schedules USING btree (service_id);


--
-- Name: index_jwt_blacklist_on_jti; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jwt_blacklist_on_jti ON public.jwt_blacklist USING btree (jti);


--
-- Name: index_locations_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_active ON public.locations USING btree (active);


--
-- Name: index_locations_on_languages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_languages ON public.locations USING gin (languages);


--
-- Name: index_locations_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_latitude_and_longitude ON public.locations USING btree (latitude, longitude);


--
-- Name: index_locations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_organization_id ON public.locations USING btree (organization_id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_slug ON public.locations USING btree (slug);


--
-- Name: index_locations_on_tsv_body; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_tsv_body ON public.locations USING gin (tsv_body);


--
-- Name: index_mail_addresses_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mail_addresses_on_location_id ON public.mail_addresses USING btree (location_id);


--
-- Name: index_org_profile_images_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_org_profile_images_on_organization_id ON public.org_profile_images USING btree (organization_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_phones_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phones_on_contact_id ON public.phones USING btree (contact_id);


--
-- Name: index_phones_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phones_on_location_id ON public.phones USING btree (location_id);


--
-- Name: index_phones_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phones_on_organization_id ON public.phones USING btree (organization_id);


--
-- Name: index_phones_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phones_on_service_id ON public.phones USING btree (service_id);


--
-- Name: index_programs_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_programs_on_organization_id ON public.programs USING btree (organization_id);


--
-- Name: index_regular_schedules_on_closes_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regular_schedules_on_closes_at ON public.regular_schedules USING btree (closes_at);


--
-- Name: index_regular_schedules_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regular_schedules_on_location_id ON public.regular_schedules USING btree (location_id);


--
-- Name: index_regular_schedules_on_opens_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regular_schedules_on_opens_at ON public.regular_schedules USING btree (opens_at);


--
-- Name: index_regular_schedules_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regular_schedules_on_service_id ON public.regular_schedules USING btree (service_id);


--
-- Name: index_regular_schedules_on_weekday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regular_schedules_on_weekday ON public.regular_schedules USING btree (weekday);


--
-- Name: index_services_on_languages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_languages ON public.services USING gin (languages);


--
-- Name: index_services_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_location_id ON public.services USING btree (location_id);


--
-- Name: index_services_on_program_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_program_id ON public.services USING btree (program_id);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: locations_admin_emails; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_admin_emails ON public.locations USING gin (to_tsvector('english'::regconfig, admin_emails));


--
-- Name: locations_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_description ON public.locations USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: locations_email_with_varchar_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_email_with_varchar_pattern_ops ON public.locations USING btree (email varchar_pattern_ops);


--
-- Name: locations_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_name ON public.locations USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: locations_website_with_varchar_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_website_with_varchar_pattern_ops ON public.locations USING btree (website varchar_pattern_ops);


--
-- Name: organizations_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organizations_name ON public.organizations USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: services_service_areas; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX services_service_areas ON public.services USING gin (to_tsvector('english'::regconfig, service_areas));


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: locations locations_search_content_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER locations_search_content_trigger BEFORE INSERT OR UPDATE ON public.locations FOR EACH ROW EXECUTE PROCEDURE public.fill_search_vector_for_location();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20140328034023');

INSERT INTO schema_migrations (version) VALUES ('20140328034531');

INSERT INTO schema_migrations (version) VALUES ('20140328034754');

INSERT INTO schema_migrations (version) VALUES ('20140328035528');

INSERT INTO schema_migrations (version) VALUES ('20140328041648');

INSERT INTO schema_migrations (version) VALUES ('20140328041859');

INSERT INTO schema_migrations (version) VALUES ('20140328042108');

INSERT INTO schema_migrations (version) VALUES ('20140328042218');

INSERT INTO schema_migrations (version) VALUES ('20140328042359');

INSERT INTO schema_migrations (version) VALUES ('20140328043104');

INSERT INTO schema_migrations (version) VALUES ('20140328044447');

INSERT INTO schema_migrations (version) VALUES ('20140328052427');

INSERT INTO schema_migrations (version) VALUES ('20140402222453');

INSERT INTO schema_migrations (version) VALUES ('20140404220233');

INSERT INTO schema_migrations (version) VALUES ('20140424182454');

INSERT INTO schema_migrations (version) VALUES ('20140505011725');

INSERT INTO schema_migrations (version) VALUES ('20140508030435');

INSERT INTO schema_migrations (version) VALUES ('20140508030926');

INSERT INTO schema_migrations (version) VALUES ('20140508031024');

INSERT INTO schema_migrations (version) VALUES ('20140508194831');

INSERT INTO schema_migrations (version) VALUES ('20140522153640');

INSERT INTO schema_migrations (version) VALUES ('20140629181523');

INSERT INTO schema_migrations (version) VALUES ('20140630171418');

INSERT INTO schema_migrations (version) VALUES ('20140829154350');

INSERT INTO schema_migrations (version) VALUES ('20140909031145');

INSERT INTO schema_migrations (version) VALUES ('20140929221750');

INSERT INTO schema_migrations (version) VALUES ('20141007144757');

INSERT INTO schema_migrations (version) VALUES ('20141009185459');

INSERT INTO schema_migrations (version) VALUES ('20141009204519');

INSERT INTO schema_migrations (version) VALUES ('20141010031124');

INSERT INTO schema_migrations (version) VALUES ('20141010155451');

INSERT INTO schema_migrations (version) VALUES ('20141010171020');

INSERT INTO schema_migrations (version) VALUES ('20141010171817');

INSERT INTO schema_migrations (version) VALUES ('20141017154640');

INSERT INTO schema_migrations (version) VALUES ('20141021195019');

INSERT INTO schema_migrations (version) VALUES ('20141023040419');

INSERT INTO schema_migrations (version) VALUES ('20141024022657');

INSERT INTO schema_migrations (version) VALUES ('20141024025404');

INSERT INTO schema_migrations (version) VALUES ('20141027154101');

INSERT INTO schema_migrations (version) VALUES ('20141029170109');

INSERT INTO schema_migrations (version) VALUES ('20141030012617');

INSERT INTO schema_migrations (version) VALUES ('20141030204742');

INSERT INTO schema_migrations (version) VALUES ('20141106215928');

INSERT INTO schema_migrations (version) VALUES ('20141107161835');

INSERT INTO schema_migrations (version) VALUES ('20141108042551');

INSERT INTO schema_migrations (version) VALUES ('20141108183056');

INSERT INTO schema_migrations (version) VALUES ('20141108194838');

INSERT INTO schema_migrations (version) VALUES ('20141108214741');

INSERT INTO schema_migrations (version) VALUES ('20141109021540');

INSERT INTO schema_migrations (version) VALUES ('20141109022202');

INSERT INTO schema_migrations (version) VALUES ('20141118132537');

INSERT INTO schema_migrations (version) VALUES ('20141208165502');

INSERT INTO schema_migrations (version) VALUES ('20150107163352');

INSERT INTO schema_migrations (version) VALUES ('20150314204202');

INSERT INTO schema_migrations (version) VALUES ('20150315202808');

INSERT INTO schema_migrations (version) VALUES ('20170918140125');

INSERT INTO schema_migrations (version) VALUES ('20171006185226');

INSERT INTO schema_migrations (version) VALUES ('20171009145426');

INSERT INTO schema_migrations (version) VALUES ('20171009150504');

INSERT INTO schema_migrations (version) VALUES ('20171009151406');

INSERT INTO schema_migrations (version) VALUES ('20171205203638');

INSERT INTO schema_migrations (version) VALUES ('20171207182758');

INSERT INTO schema_migrations (version) VALUES ('20190208161625');

INSERT INTO schema_migrations (version) VALUES ('20190212183539');

INSERT INTO schema_migrations (version) VALUES ('20190212192737');

INSERT INTO schema_migrations (version) VALUES ('20190212192738');

INSERT INTO schema_migrations (version) VALUES ('20190212192739');

INSERT INTO schema_migrations (version) VALUES ('20190212192740');

INSERT INTO schema_migrations (version) VALUES ('20190212192741');

INSERT INTO schema_migrations (version) VALUES ('20190212192742');

INSERT INTO schema_migrations (version) VALUES ('20190213195623');

INSERT INTO schema_migrations (version) VALUES ('20190214025226');

INSERT INTO schema_migrations (version) VALUES ('20190214195002');

INSERT INTO schema_migrations (version) VALUES ('20190216165413');

INSERT INTO schema_migrations (version) VALUES ('20190217161912');

INSERT INTO schema_migrations (version) VALUES ('20190225184420');

INSERT INTO schema_migrations (version) VALUES ('20190402131619');

INSERT INTO schema_migrations (version) VALUES ('20190404161038');

INSERT INTO schema_migrations (version) VALUES ('20190416173721');

INSERT INTO schema_migrations (version) VALUES ('20190419004705');

INSERT INTO schema_migrations (version) VALUES ('20190419021724');

INSERT INTO schema_migrations (version) VALUES ('20190423025801');

INSERT INTO schema_migrations (version) VALUES ('20190423030019');

INSERT INTO schema_migrations (version) VALUES ('20190426030916');

INSERT INTO schema_migrations (version) VALUES ('20190426032218');

INSERT INTO schema_migrations (version) VALUES ('20190501022752');

INSERT INTO schema_migrations (version) VALUES ('20190501144552');

