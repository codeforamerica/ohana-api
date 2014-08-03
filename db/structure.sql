--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: fill_search_vector_for_location(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION fill_search_vector_for_location() RETURNS trigger
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    location_id integer,
    street text,
    city text,
    state text,
    zip text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    super_admin boolean DEFAULT false
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: api_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE api_applications (
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

CREATE SEQUENCE api_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_applications_id_seq OWNED BY api_applications.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name text,
    oe_id text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    ancestry character varying(255)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_services; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories_services (
    category_id integer NOT NULL,
    service_id integer NOT NULL
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    location_id integer,
    name text,
    title text,
    email text,
    fax text,
    phone text,
    extension text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: faxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE faxes (
    id integer NOT NULL,
    location_id integer,
    number text,
    department text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: faxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faxes_id_seq OWNED BY faxes.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    organization_id integer,
    accessibility text,
    admin_emails text,
    description text,
    emails text,
    hours text,
    latitude double precision,
    longitude double precision,
    languages text,
    name text,
    short_desc text,
    transportation text,
    urls text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tsv_body tsvector,
    last_changes text,
    last_changed_id integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: mail_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mail_addresses (
    id integer NOT NULL,
    location_id integer,
    attention text,
    street text,
    city text,
    state text,
    zip text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: mail_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mail_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mail_addresses_id_seq OWNED BY mail_addresses.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name text,
    urls text,
    slug text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: phones; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phones (
    id integer NOT NULL,
    location_id integer,
    number text,
    department text,
    extension text,
    vanity_number text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    number_type character varying(255),
    last_changes text,
    last_changed_id integer
);


--
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phones_id_seq OWNED BY phones.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: services; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE services (
    id integer NOT NULL,
    location_id integer,
    audience text,
    description text,
    eligibility text,
    fees text,
    how_to_apply text,
    name text,
    short_desc text,
    urls text,
    wait text,
    funding_sources text,
    service_areas text,
    keywords text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_changes text,
    last_changed_id integer
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE services_id_seq OWNED BY services.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_applications ALTER COLUMN id SET DEFAULT nextval('api_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faxes ALTER COLUMN id SET DEFAULT nextval('faxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mail_addresses ALTER COLUMN id SET DEFAULT nextval('mail_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phones ALTER COLUMN id SET DEFAULT nextval('phones_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY services ALTER COLUMN id SET DEFAULT nextval('services_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: api_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY api_applications
    ADD CONSTRAINT api_applications_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: faxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY faxes
    ADD CONSTRAINT faxes_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mail_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mail_addresses
    ADD CONSTRAINT mail_addresses_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: phones_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- Name: services_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: categories_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX categories_name ON categories USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: index_addresses_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_location_id ON addresses USING btree (location_id);


--
-- Name: index_admins_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_confirmation_token ON admins USING btree (confirmation_token);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_api_applications_on_api_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_api_applications_on_api_token ON api_applications USING btree (api_token);


--
-- Name: index_api_applications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_api_applications_on_user_id ON api_applications USING btree (user_id);


--
-- Name: index_categories_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_ancestry ON categories USING btree (ancestry);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_categories_services_on_category_id_and_service_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_services_on_category_id_and_service_id ON categories_services USING btree (category_id, service_id);


--
-- Name: index_categories_services_on_service_id_and_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_services_on_service_id_and_category_id ON categories_services USING btree (service_id, category_id);


--
-- Name: index_contacts_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_location_id ON contacts USING btree (location_id);


--
-- Name: index_faxes_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_faxes_on_location_id ON faxes USING btree (location_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_locations_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_latitude_and_longitude ON locations USING btree (latitude, longitude);


--
-- Name: index_locations_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_organization_id ON locations USING btree (organization_id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_locations_on_slug ON locations USING btree (slug);


--
-- Name: index_locations_on_tsv_body; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_tsv_body ON locations USING gin (tsv_body);


--
-- Name: index_mail_addresses_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mail_addresses_on_location_id ON mail_addresses USING btree (location_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_organizations_on_slug ON organizations USING btree (slug);


--
-- Name: index_phones_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_phones_on_location_id ON phones USING btree (location_id);


--
-- Name: index_services_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_services_on_location_id ON services USING btree (location_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: locations_admin_emails; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_admin_emails ON locations USING gin (to_tsvector('english'::regconfig, admin_emails));


--
-- Name: locations_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_description ON locations USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: locations_emails; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_emails ON locations USING gin (to_tsvector('english'::regconfig, emails));


--
-- Name: locations_languages; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_languages ON locations USING gin (to_tsvector('english'::regconfig, languages));


--
-- Name: locations_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_name ON locations USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: locations_urls; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX locations_urls ON locations USING gin (to_tsvector('english'::regconfig, urls));


--
-- Name: organizations_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_name ON organizations USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: locations_search_content_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER locations_search_content_trigger BEFORE INSERT OR UPDATE ON locations FOR EACH ROW EXECUTE PROCEDURE fill_search_vector_for_location();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20140801162236');

INSERT INTO schema_migrations (version) VALUES ('20140801185705');

