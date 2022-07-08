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

--
-- Name: acts_as_xapian_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acts_as_xapian_jobs (
    id integer NOT NULL,
    model character varying NOT NULL,
    model_id integer NOT NULL,
    action character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: acts_as_xapian_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.acts_as_xapian_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acts_as_xapian_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.acts_as_xapian_jobs_id_seq OWNED BY public.acts_as_xapian_jobs.id;


--
-- Name: announcement_dismissals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcement_dismissals (
    id integer NOT NULL,
    announcement_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: announcement_dismissals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcement_dismissals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcement_dismissals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcement_dismissals_id_seq OWNED BY public.announcement_dismissals.id;


--
-- Name: announcement_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcement_translations (
    id integer NOT NULL,
    announcement_id integer NOT NULL,
    locale character varying,
    title character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: announcement_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcement_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcement_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcement_translations_id_seq OWNED BY public.announcement_translations.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    id integer NOT NULL,
    visibility character varying,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: censor_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.censor_rules (
    id integer NOT NULL,
    info_request_id integer,
    user_id integer,
    public_body_id integer,
    text text NOT NULL,
    replacement text NOT NULL,
    last_edit_editor character varying NOT NULL,
    last_edit_comment text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    regexp boolean
);


--
-- Name: censor_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.censor_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: censor_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.censor_rules_id_seq OWNED BY public.censor_rules.id;


--
-- Name: citations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.citations (
    id bigint NOT NULL,
    user_id bigint,
    citable_type character varying,
    citable_id bigint,
    source_url character varying,
    type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: citations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.citations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: citations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.citations_id_seq OWNED BY public.citations.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    info_request_id integer,
    body text NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale text DEFAULT ''::text NOT NULL,
    attention_requested boolean DEFAULT false NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: dataset_key_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_key_sets (
    id bigint NOT NULL,
    resource_type character varying,
    resource_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_key_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_key_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_key_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_key_sets_id_seq OWNED BY public.dataset_key_sets.id;


--
-- Name: dataset_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_keys (
    id bigint NOT NULL,
    dataset_key_set_id bigint,
    title character varying,
    format character varying,
    "order" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_keys_id_seq OWNED BY public.dataset_keys.id;


--
-- Name: dataset_value_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_value_sets (
    id bigint NOT NULL,
    resource_type character varying,
    resource_id bigint,
    dataset_key_set_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_value_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_value_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_value_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_value_sets_id_seq OWNED BY public.dataset_value_sets.id;


--
-- Name: dataset_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_values (
    id bigint NOT NULL,
    dataset_value_set_id bigint,
    dataset_key_id bigint,
    value character varying,
    notes character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_values_id_seq OWNED BY public.dataset_values.id;


--
-- Name: draft_info_request_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_info_request_batches (
    id integer NOT NULL,
    title character varying,
    body text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embargo_duration character varying
);


--
-- Name: draft_info_request_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.draft_info_request_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_info_request_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.draft_info_request_batches_id_seq OWNED BY public.draft_info_request_batches.id;


--
-- Name: draft_info_request_batches_public_bodies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_info_request_batches_public_bodies (
    draft_info_request_batch_id integer,
    public_body_id integer
);


--
-- Name: draft_info_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_info_requests (
    id integer NOT NULL,
    title character varying,
    user_id integer,
    public_body_id integer,
    body text,
    embargo_duration character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: draft_info_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.draft_info_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_info_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.draft_info_requests_id_seq OWNED BY public.draft_info_requests.id;


--
-- Name: embargo_extensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.embargo_extensions (
    id integer NOT NULL,
    embargo_id integer,
    extension_duration character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: embargo_extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.embargo_extensions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: embargo_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.embargo_extensions_id_seq OWNED BY public.embargo_extensions.id;


--
-- Name: embargoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.embargoes (
    id integer NOT NULL,
    info_request_id integer,
    publish_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embargo_duration character varying,
    expiring_notification_at timestamp without time zone
);


--
-- Name: embargoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.embargoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: embargoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.embargoes_id_seq OWNED BY public.embargoes.id;


--
-- Name: flipper_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_features (
    id integer NOT NULL,
    key character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flipper_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_features_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_features_id_seq OWNED BY public.flipper_features.id;


--
-- Name: flipper_gates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_gates (
    id integer NOT NULL,
    feature_key character varying NOT NULL,
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_gates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_gates_id_seq OWNED BY public.flipper_gates.id;


--
-- Name: foi_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.foi_attachments (
    id integer NOT NULL,
    content_type text,
    filename text,
    charset text,
    display_size text,
    url_part_number integer,
    within_rfc822_subject text,
    incoming_message_id integer,
    hexdigest character varying(32),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: foi_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.foi_attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foi_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.foi_attachments_id_seq OWNED BY public.foi_attachments.id;


--
-- Name: has_tag_string_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.has_tag_string_tags (
    id integer NOT NULL,
    model_id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    value text,
    model character varying NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: has_tag_string_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.has_tag_string_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: has_tag_string_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.has_tag_string_tags_id_seq OWNED BY public.has_tag_string_tags.id;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.holidays (
    id integer NOT NULL,
    day date,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.holidays_id_seq OWNED BY public.holidays.id;


--
-- Name: incoming_message_errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incoming_message_errors (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unique_id character varying NOT NULL,
    retry_at timestamp without time zone,
    backtrace text
);


--
-- Name: incoming_message_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incoming_message_errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incoming_message_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incoming_message_errors_id_seq OWNED BY public.incoming_message_errors.id;


--
-- Name: incoming_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incoming_messages (
    id integer NOT NULL,
    info_request_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    raw_email_id integer NOT NULL,
    cached_attachment_text_clipped text,
    cached_main_body_text_folded text,
    cached_main_body_text_unfolded text,
    subject text,
    mail_from_domain text,
    valid_to_reply_to boolean,
    last_parsed timestamp without time zone,
    mail_from text,
    sent_at timestamp without time zone,
    prominence character varying DEFAULT 'normal'::character varying NOT NULL,
    prominence_reason text
);


--
-- Name: incoming_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incoming_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incoming_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incoming_messages_id_seq OWNED BY public.incoming_messages.id;


--
-- Name: info_request_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_request_batches (
    id integer NOT NULL,
    title text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body text,
    sent_at timestamp without time zone,
    embargo_duration character varying
);


--
-- Name: info_request_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_request_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_request_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_request_batches_id_seq OWNED BY public.info_request_batches.id;


--
-- Name: info_request_batches_public_bodies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_request_batches_public_bodies (
    info_request_batch_id integer,
    public_body_id integer
);


--
-- Name: info_request_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_request_events (
    id integer NOT NULL,
    info_request_id integer NOT NULL,
    event_type text NOT NULL,
    params_yaml text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    described_state character varying,
    calculated_state character varying,
    last_described_at timestamp without time zone,
    incoming_message_id integer,
    outgoing_message_id integer,
    comment_id integer,
    updated_at timestamp without time zone
);


--
-- Name: info_request_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_request_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_request_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_request_events_id_seq OWNED BY public.info_request_events.id;


--
-- Name: info_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.info_requests (
    id integer NOT NULL,
    title text NOT NULL,
    user_id integer,
    public_body_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    described_state character varying NOT NULL,
    awaiting_description boolean DEFAULT false NOT NULL,
    prominence character varying DEFAULT 'normal'::character varying NOT NULL,
    url_title text NOT NULL,
    law_used character varying DEFAULT 'foi'::character varying NOT NULL,
    allow_new_responses_from character varying DEFAULT 'anybody'::character varying NOT NULL,
    handle_rejected_responses character varying DEFAULT 'bounce'::character varying NOT NULL,
    idhash character varying NOT NULL,
    external_user_name character varying,
    external_url character varying,
    attention_requested boolean DEFAULT false,
    comments_allowed boolean DEFAULT true NOT NULL,
    info_request_batch_id integer,
    last_public_response_at timestamp without time zone,
    reject_incoming_at_mta boolean DEFAULT false NOT NULL,
    rejected_incoming_count integer DEFAULT 0,
    date_initial_request_last_sent_at date,
    date_response_required_by date,
    date_very_overdue_after date,
    last_event_forming_initial_request_id integer,
    use_notifications boolean,
    last_event_time timestamp without time zone,
    incoming_messages_count integer DEFAULT 0,
    public_token character varying,
    CONSTRAINT info_requests_external_ck CHECK ((((user_id IS NULL) = (external_url IS NOT NULL)) AND ((external_url IS NOT NULL) OR (external_user_name IS NULL))))
);


--
-- Name: info_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_requests_id_seq OWNED BY public.info_requests.id;


--
-- Name: mail_server_log_dones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_server_log_dones (
    id integer NOT NULL,
    filename text NOT NULL,
    last_stat timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mail_server_log_dones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_server_log_dones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_server_log_dones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_server_log_dones_id_seq OWNED BY public.mail_server_log_dones.id;


--
-- Name: mail_server_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_server_logs (
    id integer NOT NULL,
    mail_server_log_done_id integer,
    info_request_id integer,
    "order" integer NOT NULL,
    line text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_status character varying
);


--
-- Name: mail_server_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_server_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_server_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_server_logs_id_seq OWNED BY public.mail_server_logs.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    info_request_event_id integer NOT NULL,
    user_id integer NOT NULL,
    frequency integer DEFAULT 0 NOT NULL,
    seen_at timestamp without time zone,
    send_after timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expired boolean DEFAULT false
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: outgoing_message_snippet_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outgoing_message_snippet_translations (
    id bigint NOT NULL,
    outgoing_message_snippet_id bigint NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying,
    body text
);


--
-- Name: outgoing_message_snippet_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.outgoing_message_snippet_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_message_snippet_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.outgoing_message_snippet_translations_id_seq OWNED BY public.outgoing_message_snippet_translations.id;


--
-- Name: outgoing_message_snippets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outgoing_message_snippets (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: outgoing_message_snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.outgoing_message_snippets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_message_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.outgoing_message_snippets_id_seq OWNED BY public.outgoing_message_snippets.id;


--
-- Name: outgoing_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outgoing_messages (
    id integer NOT NULL,
    info_request_id integer NOT NULL,
    body text NOT NULL,
    status character varying NOT NULL,
    message_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_sent_at timestamp without time zone,
    incoming_message_followup_id integer,
    what_doing character varying NOT NULL,
    prominence character varying DEFAULT 'normal'::character varying NOT NULL,
    prominence_reason text
);


--
-- Name: outgoing_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.outgoing_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.outgoing_messages_id_seq OWNED BY public.outgoing_messages.id;


--
-- Name: post_redirects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_redirects (
    id integer NOT NULL,
    token text NOT NULL,
    uri text NOT NULL,
    post_params_yaml text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email_token text NOT NULL,
    reason_params_yaml text,
    user_id integer,
    circumstance text DEFAULT 'normal'::text NOT NULL
);


--
-- Name: post_redirects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_redirects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_redirects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_redirects_id_seq OWNED BY public.post_redirects.id;


--
-- Name: pro_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pro_accounts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    default_embargo_duration character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stripe_customer_id character varying
);


--
-- Name: pro_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pro_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pro_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pro_accounts_id_seq OWNED BY public.pro_accounts.id;


--
-- Name: profile_photos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profile_photos (
    id integer NOT NULL,
    data bytea NOT NULL,
    user_id integer,
    draft boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profile_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profile_photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profile_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profile_photos_id_seq OWNED BY public.profile_photos.id;


--
-- Name: project_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_memberships (
    id bigint NOT NULL,
    project_id bigint,
    user_id bigint,
    role_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_memberships_id_seq OWNED BY public.project_memberships.id;


--
-- Name: project_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_resources (
    id bigint NOT NULL,
    project_id bigint,
    resource_type character varying,
    resource_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_resources_id_seq OWNED BY public.project_resources.id;


--
-- Name: project_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_submissions (
    id bigint NOT NULL,
    project_id bigint,
    user_id bigint,
    resource_type character varying,
    resource_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info_request_id bigint
);


--
-- Name: project_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_submissions_id_seq OWNED BY public.project_submissions.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    title character varying,
    briefing text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invite_token character varying
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: public_bodies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_bodies (
    id integer NOT NULL,
    version integer NOT NULL,
    last_edit_editor character varying NOT NULL,
    last_edit_comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    home_page text,
    api_key character varying NOT NULL,
    info_requests_count integer DEFAULT 0 NOT NULL,
    disclosure_log text,
    info_requests_successful_count integer,
    info_requests_not_held_count integer,
    info_requests_overdue_count integer,
    info_requests_visible_classified_count integer,
    info_requests_visible_count integer DEFAULT 0 NOT NULL
);


--
-- Name: public_bodies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_bodies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_bodies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_bodies_id_seq OWNED BY public.public_bodies.id;


--
-- Name: public_body_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_categories (
    id integer NOT NULL,
    category_tag text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: public_body_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_categories_id_seq OWNED BY public.public_body_categories.id;


--
-- Name: public_body_category_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_category_links (
    public_body_category_id integer NOT NULL,
    public_body_heading_id integer NOT NULL,
    category_display_order integer,
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: public_body_category_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_category_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_category_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_category_links_id_seq OWNED BY public.public_body_category_links.id;


--
-- Name: public_body_category_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_category_translations (
    id bigint NOT NULL,
    public_body_category_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title text,
    description text
);


--
-- Name: public_body_category_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_category_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_category_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_category_translations_id_seq OWNED BY public.public_body_category_translations.id;


--
-- Name: public_body_change_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_change_requests (
    id integer NOT NULL,
    user_email character varying,
    user_name character varying,
    user_id integer,
    public_body_name text,
    public_body_id integer,
    public_body_email character varying,
    source_url text,
    notes text,
    is_open boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: public_body_change_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_change_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_change_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_change_requests_id_seq OWNED BY public.public_body_change_requests.id;


--
-- Name: public_body_heading_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_heading_translations (
    id bigint NOT NULL,
    public_body_heading_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name text
);


--
-- Name: public_body_heading_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_heading_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_heading_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_heading_translations_id_seq OWNED BY public.public_body_heading_translations.id;


--
-- Name: public_body_headings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_headings (
    id integer NOT NULL,
    display_order integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: public_body_headings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_headings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_headings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_headings_id_seq OWNED BY public.public_body_headings.id;


--
-- Name: public_body_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_translations (
    id bigint NOT NULL,
    public_body_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name text,
    short_name text,
    request_email text,
    url_name text,
    notes text,
    first_letter character varying,
    publication_scheme text,
    disclosure_log text
);


--
-- Name: public_body_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_translations_id_seq OWNED BY public.public_body_translations.id;


--
-- Name: public_body_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_body_versions (
    id bigint NOT NULL,
    public_body_id integer,
    version integer,
    name text,
    short_name text,
    request_email text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_edit_editor character varying,
    last_edit_comment text,
    url_name text,
    home_page text,
    notes text,
    publication_scheme text,
    charity_number text,
    disclosure_log text
);


--
-- Name: public_body_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_body_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_body_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_body_versions_id_seq OWNED BY public.public_body_versions.id;


--
-- Name: raw_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.raw_emails (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: raw_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.raw_emails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: raw_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.raw_emails_id_seq OWNED BY public.raw_emails.id;


--
-- Name: request_classifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_classifications (
    id integer NOT NULL,
    user_id integer,
    info_request_event_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: request_classifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.request_classifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.request_classifications_id_seq OWNED BY public.request_classifications.id;


--
-- Name: request_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_summaries (
    id integer NOT NULL,
    title text,
    body text,
    public_body_names text,
    summarisable_type character varying NOT NULL,
    summarisable_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    request_created_at timestamp without time zone NOT NULL,
    request_updated_at timestamp without time zone NOT NULL
);


--
-- Name: request_summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.request_summaries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.request_summaries_id_seq OWNED BY public.request_summaries.id;


--
-- Name: request_summaries_summary_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_summaries_summary_categories (
    request_summary_id integer NOT NULL,
    request_summary_category_id integer NOT NULL
);


--
-- Name: request_summary_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_summary_categories (
    id integer NOT NULL,
    slug text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: request_summary_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.request_summary_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_summary_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.request_summary_categories_id_seq OWNED BY public.request_summary_categories.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying,
    resource_type character varying,
    resource_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: spam_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spam_addresses (
    id integer NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spam_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spam_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spam_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spam_addresses_id_seq OWNED BY public.spam_addresses.id;


--
-- Name: track_things; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track_things (
    id integer NOT NULL,
    tracking_user_id integer NOT NULL,
    track_query character varying(500) NOT NULL,
    info_request_id integer,
    tracked_user_id integer,
    public_body_id integer,
    track_medium character varying NOT NULL,
    track_type character varying DEFAULT 'internal_error'::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: track_things_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.track_things_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: track_things_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.track_things_id_seq OWNED BY public.track_things.id;


--
-- Name: track_things_sent_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track_things_sent_emails (
    id integer NOT NULL,
    track_thing_id integer NOT NULL,
    info_request_event_id integer,
    user_id integer,
    public_body_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: track_things_sent_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.track_things_sent_emails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: track_things_sent_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.track_things_sent_emails_id_seq OWNED BY public.track_things_sent_emails.id;


--
-- Name: user_info_request_sent_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_info_request_sent_alerts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    info_request_id integer NOT NULL,
    alert_type character varying NOT NULL,
    info_request_event_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: user_info_request_sent_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_info_request_sent_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_info_request_sent_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_info_request_sent_alerts_id_seq OWNED BY public.user_info_request_sent_alerts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying NOT NULL,
    name character varying NOT NULL,
    hashed_password character varying NOT NULL,
    salt character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email_confirmed boolean DEFAULT false NOT NULL,
    url_name text NOT NULL,
    last_daily_track_email timestamp without time zone DEFAULT '2000-01-01 00:00:00'::timestamp without time zone,
    ban_text text DEFAULT ''::text NOT NULL,
    about_me text DEFAULT ''::text NOT NULL,
    locale character varying,
    email_bounced_at timestamp without time zone,
    email_bounce_message text DEFAULT ''::text NOT NULL,
    no_limit boolean DEFAULT false NOT NULL,
    receive_email_alerts boolean DEFAULT true NOT NULL,
    can_make_batch_requests boolean DEFAULT false NOT NULL,
    otp_enabled boolean DEFAULT false NOT NULL,
    otp_secret_key character varying,
    otp_counter integer DEFAULT 1,
    confirmed_not_spam boolean DEFAULT false NOT NULL,
    comments_count integer DEFAULT 0 NOT NULL,
    info_requests_count integer DEFAULT 0 NOT NULL,
    track_things_count integer DEFAULT 0 NOT NULL,
    request_classifications_count integer DEFAULT 0 NOT NULL,
    public_body_change_requests_count integer DEFAULT 0 NOT NULL,
    info_request_batches_count integer DEFAULT 0 NOT NULL,
    daily_summary_hour integer,
    daily_summary_minute integer,
    closed_at timestamp without time zone,
    login_token character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
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
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_roles (
    user_id integer,
    role_id integer
);


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhooks (
    id integer NOT NULL,
    params jsonb,
    notified_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.webhooks_id_seq OWNED BY public.webhooks.id;


--
-- Name: widget_votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.widget_votes (
    id integer NOT NULL,
    cookie character varying,
    info_request_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: widget_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.widget_votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: widget_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.widget_votes_id_seq OWNED BY public.widget_votes.id;


--
-- Name: acts_as_xapian_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts_as_xapian_jobs ALTER COLUMN id SET DEFAULT nextval('public.acts_as_xapian_jobs_id_seq'::regclass);


--
-- Name: announcement_dismissals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_dismissals ALTER COLUMN id SET DEFAULT nextval('public.announcement_dismissals_id_seq'::regclass);


--
-- Name: announcement_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_translations ALTER COLUMN id SET DEFAULT nextval('public.announcement_translations_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: censor_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.censor_rules ALTER COLUMN id SET DEFAULT nextval('public.censor_rules_id_seq'::regclass);


--
-- Name: citations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citations ALTER COLUMN id SET DEFAULT nextval('public.citations_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: dataset_key_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_key_sets ALTER COLUMN id SET DEFAULT nextval('public.dataset_key_sets_id_seq'::regclass);


--
-- Name: dataset_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_keys ALTER COLUMN id SET DEFAULT nextval('public.dataset_keys_id_seq'::regclass);


--
-- Name: dataset_value_sets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_value_sets ALTER COLUMN id SET DEFAULT nextval('public.dataset_value_sets_id_seq'::regclass);


--
-- Name: dataset_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_values ALTER COLUMN id SET DEFAULT nextval('public.dataset_values_id_seq'::regclass);


--
-- Name: draft_info_request_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_info_request_batches ALTER COLUMN id SET DEFAULT nextval('public.draft_info_request_batches_id_seq'::regclass);


--
-- Name: draft_info_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_info_requests ALTER COLUMN id SET DEFAULT nextval('public.draft_info_requests_id_seq'::regclass);


--
-- Name: embargo_extensions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embargo_extensions ALTER COLUMN id SET DEFAULT nextval('public.embargo_extensions_id_seq'::regclass);


--
-- Name: embargoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embargoes ALTER COLUMN id SET DEFAULT nextval('public.embargoes_id_seq'::regclass);


--
-- Name: flipper_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features ALTER COLUMN id SET DEFAULT nextval('public.flipper_features_id_seq'::regclass);


--
-- Name: flipper_gates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates ALTER COLUMN id SET DEFAULT nextval('public.flipper_gates_id_seq'::regclass);


--
-- Name: foi_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foi_attachments ALTER COLUMN id SET DEFAULT nextval('public.foi_attachments_id_seq'::regclass);


--
-- Name: has_tag_string_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has_tag_string_tags ALTER COLUMN id SET DEFAULT nextval('public.has_tag_string_tags_id_seq'::regclass);


--
-- Name: holidays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holidays ALTER COLUMN id SET DEFAULT nextval('public.holidays_id_seq'::regclass);


--
-- Name: incoming_message_errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_message_errors ALTER COLUMN id SET DEFAULT nextval('public.incoming_message_errors_id_seq'::regclass);


--
-- Name: incoming_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_messages ALTER COLUMN id SET DEFAULT nextval('public.incoming_messages_id_seq'::regclass);


--
-- Name: info_request_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_batches ALTER COLUMN id SET DEFAULT nextval('public.info_request_batches_id_seq'::regclass);


--
-- Name: info_request_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events ALTER COLUMN id SET DEFAULT nextval('public.info_request_events_id_seq'::regclass);


--
-- Name: info_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_requests ALTER COLUMN id SET DEFAULT nextval('public.info_requests_id_seq'::regclass);


--
-- Name: mail_server_log_dones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_log_dones ALTER COLUMN id SET DEFAULT nextval('public.mail_server_log_dones_id_seq'::regclass);


--
-- Name: mail_server_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_logs ALTER COLUMN id SET DEFAULT nextval('public.mail_server_logs_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: outgoing_message_snippet_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_message_snippet_translations ALTER COLUMN id SET DEFAULT nextval('public.outgoing_message_snippet_translations_id_seq'::regclass);


--
-- Name: outgoing_message_snippets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_message_snippets ALTER COLUMN id SET DEFAULT nextval('public.outgoing_message_snippets_id_seq'::regclass);


--
-- Name: outgoing_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_messages ALTER COLUMN id SET DEFAULT nextval('public.outgoing_messages_id_seq'::regclass);


--
-- Name: post_redirects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_redirects ALTER COLUMN id SET DEFAULT nextval('public.post_redirects_id_seq'::regclass);


--
-- Name: pro_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pro_accounts ALTER COLUMN id SET DEFAULT nextval('public.pro_accounts_id_seq'::regclass);


--
-- Name: profile_photos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_photos ALTER COLUMN id SET DEFAULT nextval('public.profile_photos_id_seq'::regclass);


--
-- Name: project_memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_memberships ALTER COLUMN id SET DEFAULT nextval('public.project_memberships_id_seq'::regclass);


--
-- Name: project_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_resources ALTER COLUMN id SET DEFAULT nextval('public.project_resources_id_seq'::regclass);


--
-- Name: project_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_submissions ALTER COLUMN id SET DEFAULT nextval('public.project_submissions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: public_bodies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_bodies ALTER COLUMN id SET DEFAULT nextval('public.public_bodies_id_seq'::regclass);


--
-- Name: public_body_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_categories ALTER COLUMN id SET DEFAULT nextval('public.public_body_categories_id_seq'::regclass);


--
-- Name: public_body_category_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_category_links ALTER COLUMN id SET DEFAULT nextval('public.public_body_category_links_id_seq'::regclass);


--
-- Name: public_body_category_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_category_translations ALTER COLUMN id SET DEFAULT nextval('public.public_body_category_translations_id_seq'::regclass);


--
-- Name: public_body_change_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_change_requests ALTER COLUMN id SET DEFAULT nextval('public.public_body_change_requests_id_seq'::regclass);


--
-- Name: public_body_heading_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_heading_translations ALTER COLUMN id SET DEFAULT nextval('public.public_body_heading_translations_id_seq'::regclass);


--
-- Name: public_body_headings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_headings ALTER COLUMN id SET DEFAULT nextval('public.public_body_headings_id_seq'::regclass);


--
-- Name: public_body_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_translations ALTER COLUMN id SET DEFAULT nextval('public.public_body_translations_id_seq'::regclass);


--
-- Name: public_body_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_versions ALTER COLUMN id SET DEFAULT nextval('public.public_body_versions_id_seq'::regclass);


--
-- Name: raw_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.raw_emails ALTER COLUMN id SET DEFAULT nextval('public.raw_emails_id_seq'::regclass);


--
-- Name: request_classifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_classifications ALTER COLUMN id SET DEFAULT nextval('public.request_classifications_id_seq'::regclass);


--
-- Name: request_summaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_summaries ALTER COLUMN id SET DEFAULT nextval('public.request_summaries_id_seq'::regclass);


--
-- Name: request_summary_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_summary_categories ALTER COLUMN id SET DEFAULT nextval('public.request_summary_categories_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: spam_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spam_addresses ALTER COLUMN id SET DEFAULT nextval('public.spam_addresses_id_seq'::regclass);


--
-- Name: track_things id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things ALTER COLUMN id SET DEFAULT nextval('public.track_things_id_seq'::regclass);


--
-- Name: track_things_sent_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things_sent_emails ALTER COLUMN id SET DEFAULT nextval('public.track_things_sent_emails_id_seq'::regclass);


--
-- Name: user_info_request_sent_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_info_request_sent_alerts ALTER COLUMN id SET DEFAULT nextval('public.user_info_request_sent_alerts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: webhooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks ALTER COLUMN id SET DEFAULT nextval('public.webhooks_id_seq'::regclass);


--
-- Name: widget_votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.widget_votes ALTER COLUMN id SET DEFAULT nextval('public.widget_votes_id_seq'::regclass);


--
-- Name: acts_as_xapian_jobs acts_as_xapian_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts_as_xapian_jobs
    ADD CONSTRAINT acts_as_xapian_jobs_pkey PRIMARY KEY (id);


--
-- Name: announcement_dismissals announcement_dismissals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_dismissals
    ADD CONSTRAINT announcement_dismissals_pkey PRIMARY KEY (id);


--
-- Name: announcement_translations announcement_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_translations
    ADD CONSTRAINT announcement_translations_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: censor_rules censor_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.censor_rules
    ADD CONSTRAINT censor_rules_pkey PRIMARY KEY (id);


--
-- Name: citations citations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT citations_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: dataset_key_sets dataset_key_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_key_sets
    ADD CONSTRAINT dataset_key_sets_pkey PRIMARY KEY (id);


--
-- Name: dataset_keys dataset_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_keys
    ADD CONSTRAINT dataset_keys_pkey PRIMARY KEY (id);


--
-- Name: dataset_value_sets dataset_value_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_value_sets
    ADD CONSTRAINT dataset_value_sets_pkey PRIMARY KEY (id);


--
-- Name: dataset_values dataset_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_values
    ADD CONSTRAINT dataset_values_pkey PRIMARY KEY (id);


--
-- Name: draft_info_request_batches draft_info_request_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_info_request_batches
    ADD CONSTRAINT draft_info_request_batches_pkey PRIMARY KEY (id);


--
-- Name: draft_info_requests draft_info_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_info_requests
    ADD CONSTRAINT draft_info_requests_pkey PRIMARY KEY (id);


--
-- Name: embargo_extensions embargo_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embargo_extensions
    ADD CONSTRAINT embargo_extensions_pkey PRIMARY KEY (id);


--
-- Name: embargoes embargoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embargoes
    ADD CONSTRAINT embargoes_pkey PRIMARY KEY (id);


--
-- Name: flipper_features flipper_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features
    ADD CONSTRAINT flipper_features_pkey PRIMARY KEY (id);


--
-- Name: flipper_gates flipper_gates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates
    ADD CONSTRAINT flipper_gates_pkey PRIMARY KEY (id);


--
-- Name: foi_attachments foi_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foi_attachments
    ADD CONSTRAINT foi_attachments_pkey PRIMARY KEY (id);


--
-- Name: has_tag_string_tags has_tag_string_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has_tag_string_tags
    ADD CONSTRAINT has_tag_string_tags_pkey PRIMARY KEY (id);


--
-- Name: holidays holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: incoming_message_errors incoming_message_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_message_errors
    ADD CONSTRAINT incoming_message_errors_pkey PRIMARY KEY (id);


--
-- Name: incoming_messages incoming_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_messages
    ADD CONSTRAINT incoming_messages_pkey PRIMARY KEY (id);


--
-- Name: info_request_batches info_request_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_batches
    ADD CONSTRAINT info_request_batches_pkey PRIMARY KEY (id);


--
-- Name: info_request_events info_request_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events
    ADD CONSTRAINT info_request_events_pkey PRIMARY KEY (id);


--
-- Name: info_requests info_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_requests
    ADD CONSTRAINT info_requests_pkey PRIMARY KEY (id);


--
-- Name: mail_server_log_dones mail_server_log_dones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_log_dones
    ADD CONSTRAINT mail_server_log_dones_pkey PRIMARY KEY (id);


--
-- Name: mail_server_logs mail_server_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_logs
    ADD CONSTRAINT mail_server_logs_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: outgoing_message_snippet_translations outgoing_message_snippet_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_message_snippet_translations
    ADD CONSTRAINT outgoing_message_snippet_translations_pkey PRIMARY KEY (id);


--
-- Name: outgoing_message_snippets outgoing_message_snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_message_snippets
    ADD CONSTRAINT outgoing_message_snippets_pkey PRIMARY KEY (id);


--
-- Name: outgoing_messages outgoing_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_messages
    ADD CONSTRAINT outgoing_messages_pkey PRIMARY KEY (id);


--
-- Name: post_redirects post_redirects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_redirects
    ADD CONSTRAINT post_redirects_pkey PRIMARY KEY (id);


--
-- Name: pro_accounts pro_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pro_accounts
    ADD CONSTRAINT pro_accounts_pkey PRIMARY KEY (id);


--
-- Name: profile_photos profile_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_photos
    ADD CONSTRAINT profile_photos_pkey PRIMARY KEY (id);


--
-- Name: project_memberships project_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_memberships
    ADD CONSTRAINT project_memberships_pkey PRIMARY KEY (id);


--
-- Name: project_resources project_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_resources
    ADD CONSTRAINT project_resources_pkey PRIMARY KEY (id);


--
-- Name: project_submissions project_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_submissions
    ADD CONSTRAINT project_submissions_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: public_bodies public_bodies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_bodies
    ADD CONSTRAINT public_bodies_pkey PRIMARY KEY (id);


--
-- Name: public_body_categories public_body_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_categories
    ADD CONSTRAINT public_body_categories_pkey PRIMARY KEY (id);


--
-- Name: public_body_category_links public_body_category_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_category_links
    ADD CONSTRAINT public_body_category_links_pkey PRIMARY KEY (id);


--
-- Name: public_body_category_translations public_body_category_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_category_translations
    ADD CONSTRAINT public_body_category_translations_pkey PRIMARY KEY (id);


--
-- Name: public_body_change_requests public_body_change_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_change_requests
    ADD CONSTRAINT public_body_change_requests_pkey PRIMARY KEY (id);


--
-- Name: public_body_heading_translations public_body_heading_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_heading_translations
    ADD CONSTRAINT public_body_heading_translations_pkey PRIMARY KEY (id);


--
-- Name: public_body_headings public_body_headings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_headings
    ADD CONSTRAINT public_body_headings_pkey PRIMARY KEY (id);


--
-- Name: public_body_translations public_body_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_translations
    ADD CONSTRAINT public_body_translations_pkey PRIMARY KEY (id);


--
-- Name: public_body_versions public_body_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_versions
    ADD CONSTRAINT public_body_versions_pkey PRIMARY KEY (id);


--
-- Name: raw_emails raw_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.raw_emails
    ADD CONSTRAINT raw_emails_pkey PRIMARY KEY (id);


--
-- Name: request_classifications request_classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_classifications
    ADD CONSTRAINT request_classifications_pkey PRIMARY KEY (id);


--
-- Name: request_summaries request_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_summaries
    ADD CONSTRAINT request_summaries_pkey PRIMARY KEY (id);


--
-- Name: request_summary_categories request_summary_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_summary_categories
    ADD CONSTRAINT request_summary_categories_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: spam_addresses spam_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spam_addresses
    ADD CONSTRAINT spam_addresses_pkey PRIMARY KEY (id);


--
-- Name: track_things track_things_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things
    ADD CONSTRAINT track_things_pkey PRIMARY KEY (id);


--
-- Name: track_things_sent_emails track_things_sent_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things_sent_emails
    ADD CONSTRAINT track_things_sent_emails_pkey PRIMARY KEY (id);


--
-- Name: user_info_request_sent_alerts user_info_request_sent_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_info_request_sent_alerts
    ADD CONSTRAINT user_info_request_sent_alerts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: widget_votes widget_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.widget_votes
    ADD CONSTRAINT widget_votes_pkey PRIMARY KEY (id);


--
-- Name: by_model_and_model_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_model_and_model_id_and_name_and_value ON public.has_tag_string_tags USING btree (model, model_id, name, value);


--
-- Name: index_2846186edec8eb8d525d2665e3bb278b7ff6136d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_2846186edec8eb8d525d2665e3bb278b7ff6136d ON public.public_body_heading_translations USING btree (public_body_heading_id);


--
-- Name: index_65625b59d05596cd26f13873823704a7fdaaac1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_65625b59d05596cd26f13873823704a7fdaaac1b ON public.outgoing_message_snippet_translations USING btree (outgoing_message_snippet_id);


--
-- Name: index_7744a81e88b64be0c7f3ea33869571764231aedc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_7744a81e88b64be0c7f3ea33869571764231aedc ON public.public_body_category_translations USING btree (public_body_category_id);


--
-- Name: index_acts_as_xapian_jobs_on_model_and_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_acts_as_xapian_jobs_on_model_and_model_id ON public.acts_as_xapian_jobs USING btree (model, model_id);


--
-- Name: index_announcement_dismissals_on_announcement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announcement_dismissals_on_announcement_id ON public.announcement_dismissals USING btree (announcement_id);


--
-- Name: index_announcement_dismissals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announcement_dismissals_on_user_id ON public.announcement_dismissals USING btree (user_id);


--
-- Name: index_announcement_translations_on_announcement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announcement_translations_on_announcement_id ON public.announcement_translations USING btree (announcement_id);


--
-- Name: index_announcements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_announcements_on_user_id ON public.announcements USING btree (user_id);


--
-- Name: index_censor_rules_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_censor_rules_on_info_request_id ON public.censor_rules USING btree (info_request_id);


--
-- Name: index_censor_rules_on_public_body_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_censor_rules_on_public_body_id ON public.censor_rules USING btree (public_body_id);


--
-- Name: index_censor_rules_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_censor_rules_on_user_id ON public.censor_rules USING btree (user_id);


--
-- Name: index_citations_on_citable_type_and_citable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_citations_on_citable_type_and_citable_id ON public.citations USING btree (citable_type, citable_id);


--
-- Name: index_citations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_citations_on_user_id ON public.citations USING btree (user_id);


--
-- Name: index_dataset_key_sets_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_key_sets_on_resource_type_and_resource_id ON public.dataset_key_sets USING btree (resource_type, resource_id);


--
-- Name: index_dataset_keys_on_dataset_key_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_keys_on_dataset_key_set_id ON public.dataset_keys USING btree (dataset_key_set_id);


--
-- Name: index_dataset_value_sets_on_dataset_key_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_value_sets_on_dataset_key_set_id ON public.dataset_value_sets USING btree (dataset_key_set_id);


--
-- Name: index_dataset_value_sets_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_value_sets_on_resource_type_and_resource_id ON public.dataset_value_sets USING btree (resource_type, resource_id);


--
-- Name: index_dataset_values_on_dataset_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_values_on_dataset_key_id ON public.dataset_values USING btree (dataset_key_id);


--
-- Name: index_dataset_values_on_dataset_value_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_values_on_dataset_value_set_id ON public.dataset_values USING btree (dataset_value_set_id);


--
-- Name: index_draft_batch_body; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_batch_body ON public.draft_info_request_batches_public_bodies USING btree (public_body_id);


--
-- Name: index_draft_batch_body_and_draft; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_batch_body_and_draft ON public.draft_info_request_batches_public_bodies USING btree (draft_info_request_batch_id, public_body_id);


--
-- Name: index_draft_info_request_batches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_info_request_batches_on_user_id ON public.draft_info_request_batches USING btree (user_id);


--
-- Name: index_embargoes_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_embargoes_on_info_request_id ON public.embargoes USING btree (info_request_id);


--
-- Name: index_flipper_features_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_features_on_key ON public.flipper_features USING btree (key);


--
-- Name: index_flipper_gates_on_feature_key_and_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_gates_on_feature_key_and_key_and_value ON public.flipper_gates USING btree (feature_key, key, value);


--
-- Name: index_foi_attachments_on_incoming_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_foi_attachments_on_incoming_message_id ON public.foi_attachments USING btree (incoming_message_id);


--
-- Name: index_has_tag_string_tags_on_model_and_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_has_tag_string_tags_on_model_and_model_id ON public.has_tag_string_tags USING btree (model, model_id);


--
-- Name: index_has_tag_string_tags_on_model_id_and_name_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_has_tag_string_tags_on_model_id_and_name_and_value ON public.has_tag_string_tags USING btree (model_id, name, value);


--
-- Name: index_has_tag_string_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_has_tag_string_tags_on_name ON public.has_tag_string_tags USING btree (name);


--
-- Name: index_holidays_on_day; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_holidays_on_day ON public.holidays USING btree (day);


--
-- Name: index_incoming_message_errors_on_unique_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incoming_message_errors_on_unique_id ON public.incoming_message_errors USING btree (unique_id);


--
-- Name: index_incoming_messages_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incoming_messages_on_info_request_id ON public.incoming_messages USING btree (info_request_id);


--
-- Name: index_incoming_messages_on_raw_email_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incoming_messages_on_raw_email_id ON public.incoming_messages USING btree (raw_email_id);


--
-- Name: index_info_request_batches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_batches_on_user_id ON public.info_request_batches USING btree (user_id);


--
-- Name: index_info_request_batches_on_user_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_batches_on_user_id_and_title ON public.info_request_batches USING btree (user_id, title);


--
-- Name: index_info_request_events_on_comment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_comment_id ON public.info_request_events USING btree (comment_id);


--
-- Name: index_info_request_events_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_created_at ON public.info_request_events USING btree (created_at);


--
-- Name: index_info_request_events_on_event_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_event_type ON public.info_request_events USING btree (event_type);


--
-- Name: index_info_request_events_on_incoming_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_incoming_message_id ON public.info_request_events USING btree (incoming_message_id);


--
-- Name: index_info_request_events_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_info_request_id ON public.info_request_events USING btree (info_request_id);


--
-- Name: index_info_request_events_on_outgoing_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_request_events_on_outgoing_message_id ON public.info_request_events USING btree (outgoing_message_id);


--
-- Name: index_info_requests_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_requests_on_created_at ON public.info_requests USING btree (created_at);


--
-- Name: index_info_requests_on_info_request_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_requests_on_info_request_batch_id ON public.info_requests USING btree (info_request_batch_id);


--
-- Name: index_info_requests_on_public_body_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_requests_on_public_body_id ON public.info_requests USING btree (public_body_id);


--
-- Name: index_info_requests_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_requests_on_title ON public.info_requests USING btree (title);


--
-- Name: index_info_requests_on_url_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_info_requests_on_url_title ON public.info_requests USING btree (url_title);


--
-- Name: index_info_requests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_info_requests_on_user_id ON public.info_requests USING btree (user_id);


--
-- Name: index_mail_server_log_dones_on_last_stat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mail_server_log_dones_on_last_stat ON public.mail_server_log_dones USING btree (last_stat);


--
-- Name: index_mail_server_logs_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mail_server_logs_on_info_request_id ON public.mail_server_logs USING btree (info_request_id);


--
-- Name: index_mail_server_logs_on_mail_server_log_done_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mail_server_logs_on_mail_server_log_done_id ON public.mail_server_logs USING btree (mail_server_log_done_id);


--
-- Name: index_notifications_on_frequency; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_frequency ON public.notifications USING btree (frequency);


--
-- Name: index_notifications_on_info_request_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_info_request_event_id ON public.notifications USING btree (info_request_event_id);


--
-- Name: index_notifications_on_seen_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_seen_at ON public.notifications USING btree (seen_at);


--
-- Name: index_notifications_on_send_after; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_send_after ON public.notifications USING btree (send_after);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_outgoing_message_snippet_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_message_snippet_translations_on_locale ON public.outgoing_message_snippet_translations USING btree (locale);


--
-- Name: index_outgoing_messages_on_incoming_message_followup_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_messages_on_incoming_message_followup_id ON public.outgoing_messages USING btree (incoming_message_followup_id);


--
-- Name: index_outgoing_messages_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_messages_on_info_request_id ON public.outgoing_messages USING btree (info_request_id);


--
-- Name: index_outgoing_messages_on_what_doing; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_messages_on_what_doing ON public.outgoing_messages USING btree (what_doing);


--
-- Name: index_post_redirects_on_email_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_redirects_on_email_token ON public.post_redirects USING btree (email_token);


--
-- Name: index_post_redirects_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_redirects_on_token ON public.post_redirects USING btree (token);


--
-- Name: index_post_redirects_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_redirects_on_updated_at ON public.post_redirects USING btree (updated_at);


--
-- Name: index_post_redirects_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_redirects_on_user_id ON public.post_redirects USING btree (user_id);


--
-- Name: index_project_memberships_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_memberships_on_project_id ON public.project_memberships USING btree (project_id);


--
-- Name: index_project_memberships_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_memberships_on_role_id ON public.project_memberships USING btree (role_id);


--
-- Name: index_project_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_memberships_on_user_id ON public.project_memberships USING btree (user_id);


--
-- Name: index_project_resources_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_resources_on_project_id ON public.project_resources USING btree (project_id);


--
-- Name: index_project_resources_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_resources_on_resource_type_and_resource_id ON public.project_resources USING btree (resource_type, resource_id);


--
-- Name: index_project_submissions_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_submissions_on_info_request_id ON public.project_submissions USING btree (info_request_id);


--
-- Name: index_project_submissions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_submissions_on_project_id ON public.project_submissions USING btree (project_id);


--
-- Name: index_project_submissions_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_submissions_on_resource_type_and_resource_id ON public.project_submissions USING btree (resource_type, resource_id);


--
-- Name: index_project_submissions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_submissions_on_user_id ON public.project_submissions USING btree (user_id);


--
-- Name: index_public_body_categories_on_category_tag; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_public_body_categories_on_category_tag ON public.public_body_categories USING btree (category_tag);


--
-- Name: index_public_body_category_links_on_join_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_category_links_on_join_ids ON public.public_body_category_links USING btree (public_body_category_id, public_body_heading_id);


--
-- Name: index_public_body_category_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_category_translations_on_locale ON public.public_body_category_translations USING btree (locale);


--
-- Name: index_public_body_heading_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_heading_translations_on_locale ON public.public_body_heading_translations USING btree (locale);


--
-- Name: index_public_body_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_translations_on_locale ON public.public_body_translations USING btree (locale);


--
-- Name: index_public_body_translations_on_public_body_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_translations_on_public_body_id ON public.public_body_translations USING btree (public_body_id);


--
-- Name: index_public_body_versions_on_public_body_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_versions_on_public_body_id ON public.public_body_versions USING btree (public_body_id);


--
-- Name: index_public_body_versions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_body_versions_on_updated_at ON public.public_body_versions USING btree (updated_at);


--
-- Name: index_request_classifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_request_classifications_on_user_id ON public.request_classifications USING btree (user_id);


--
-- Name: index_request_summaries_on_summarisable; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_request_summaries_on_summarisable ON public.request_summaries USING btree (summarisable_type, summarisable_id);


--
-- Name: index_request_summaries_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_request_summaries_on_user_id ON public.request_summaries USING btree (user_id);


--
-- Name: index_request_summaries_summary_categories_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_request_summaries_summary_categories_unique ON public.request_summaries_summary_categories USING btree (request_summary_id, request_summary_category_id);


--
-- Name: index_request_summary_categories_summaries_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_request_summary_categories_summaries_unique ON public.request_summaries_summary_categories USING btree (request_summary_category_id, request_summary_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_track_things_on_tracking_user_id_and_track_query; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_track_things_on_tracking_user_id_and_track_query ON public.track_things USING btree (tracking_user_id, track_query);


--
-- Name: index_track_things_sent_emails_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_track_things_sent_emails_on_created_at ON public.track_things_sent_emails USING btree (created_at);


--
-- Name: index_track_things_sent_emails_on_info_request_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_track_things_sent_emails_on_info_request_event_id ON public.track_things_sent_emails USING btree (info_request_event_id);


--
-- Name: index_track_things_sent_emails_on_track_thing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_track_things_sent_emails_on_track_thing_id ON public.track_things_sent_emails USING btree (track_thing_id);


--
-- Name: index_user_info_request_sent_alerts_on_info_request_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_info_request_sent_alerts_on_info_request_event_id ON public.user_info_request_sent_alerts USING btree (info_request_event_id);


--
-- Name: index_users_on_url_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_url_name ON public.users USING btree (url_name);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON public.users_roles USING btree (user_id, role_id);


--
-- Name: index_widget_votes_on_info_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_widget_votes_on_info_request_id ON public.widget_votes USING btree (info_request_id);


--
-- Name: user_info_request_sent_alerts_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_info_request_sent_alerts_unique_index ON public.user_info_request_sent_alerts USING btree (user_id, info_request_id, alert_type, COALESCE(info_request_event_id, '-1'::integer));


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (lower((email)::text));


--
-- Name: users_lower_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_lower_email_index ON public.users USING btree (lower((email)::text));


--
-- Name: censor_rules fk_censor_rules_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.censor_rules
    ADD CONSTRAINT fk_censor_rules_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: censor_rules fk_censor_rules_public_body; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.censor_rules
    ADD CONSTRAINT fk_censor_rules_public_body FOREIGN KEY (public_body_id) REFERENCES public.public_bodies(id);


--
-- Name: censor_rules fk_censor_rules_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.censor_rules
    ADD CONSTRAINT fk_censor_rules_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments fk_comments_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_comments_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: comments fk_comments_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: mail_server_logs fk_exim_log_done; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_logs
    ADD CONSTRAINT fk_exim_log_done FOREIGN KEY (mail_server_log_done_id) REFERENCES public.mail_server_log_dones(id);


--
-- Name: mail_server_logs fk_exim_log_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_server_logs
    ADD CONSTRAINT fk_exim_log_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: outgoing_messages fk_incoming_message_followup_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_messages
    ADD CONSTRAINT fk_incoming_message_followup_info_request FOREIGN KEY (incoming_message_followup_id) REFERENCES public.incoming_messages(id);


--
-- Name: incoming_messages fk_incoming_messages_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_messages
    ADD CONSTRAINT fk_incoming_messages_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: incoming_messages fk_incoming_messages_raw_email; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_messages
    ADD CONSTRAINT fk_incoming_messages_raw_email FOREIGN KEY (raw_email_id) REFERENCES public.raw_emails(id);


--
-- Name: info_request_events fk_info_request_events_comment_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events
    ADD CONSTRAINT fk_info_request_events_comment_id FOREIGN KEY (comment_id) REFERENCES public.comments(id);


--
-- Name: info_request_events fk_info_request_events_incoming_message_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events
    ADD CONSTRAINT fk_info_request_events_incoming_message_id FOREIGN KEY (incoming_message_id) REFERENCES public.incoming_messages(id);


--
-- Name: info_request_events fk_info_request_events_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events
    ADD CONSTRAINT fk_info_request_events_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: info_request_events fk_info_request_events_outgoing_message_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_request_events
    ADD CONSTRAINT fk_info_request_events_outgoing_message_id FOREIGN KEY (outgoing_message_id) REFERENCES public.outgoing_messages(id);


--
-- Name: user_info_request_sent_alerts fk_info_request_sent_alerts_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_info_request_sent_alerts
    ADD CONSTRAINT fk_info_request_sent_alerts_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: user_info_request_sent_alerts fk_info_request_sent_alerts_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_info_request_sent_alerts
    ADD CONSTRAINT fk_info_request_sent_alerts_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: info_requests fk_info_requests_info_request_batch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_requests
    ADD CONSTRAINT fk_info_requests_info_request_batch FOREIGN KEY (info_request_batch_id) REFERENCES public.info_request_batches(id);


--
-- Name: info_requests fk_info_requests_public_body; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_requests
    ADD CONSTRAINT fk_info_requests_public_body FOREIGN KEY (public_body_id) REFERENCES public.public_bodies(id);


--
-- Name: info_requests fk_info_requests_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info_requests
    ADD CONSTRAINT fk_info_requests_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: outgoing_messages fk_outgoing_messages_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_messages
    ADD CONSTRAINT fk_outgoing_messages_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: post_redirects fk_post_redirects_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_redirects
    ADD CONSTRAINT fk_post_redirects_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: profile_photos fk_profile_photos_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_photos
    ADD CONSTRAINT fk_profile_photos_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: public_body_versions fk_public_body_versions_public_body; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_body_versions
    ADD CONSTRAINT fk_public_body_versions_public_body FOREIGN KEY (public_body_id) REFERENCES public.public_bodies(id);


--
-- Name: project_memberships fk_rails_18b611e244; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_memberships
    ADD CONSTRAINT fk_rails_18b611e244 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: dataset_keys fk_rails_1d7b4e0765; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_keys
    ADD CONSTRAINT fk_rails_1d7b4e0765 FOREIGN KEY (dataset_key_set_id) REFERENCES public.dataset_key_sets(id);


--
-- Name: project_memberships fk_rails_21ad77d123; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_memberships
    ADD CONSTRAINT fk_rails_21ad77d123 FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: dataset_values fk_rails_2beeca6318; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_values
    ADD CONSTRAINT fk_rails_2beeca6318 FOREIGN KEY (dataset_key_id) REFERENCES public.dataset_keys(id);


--
-- Name: announcement_translations fk_rails_308fd3ae95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_translations
    ADD CONSTRAINT fk_rails_308fd3ae95 FOREIGN KEY (announcement_id) REFERENCES public.announcements(id);


--
-- Name: dataset_values fk_rails_32de525728; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_values
    ADD CONSTRAINT fk_rails_32de525728 FOREIGN KEY (dataset_value_set_id) REFERENCES public.dataset_value_sets(id);


--
-- Name: dataset_value_sets fk_rails_76a2c7d1d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_value_sets
    ADD CONSTRAINT fk_rails_76a2c7d1d8 FOREIGN KEY (dataset_key_set_id) REFERENCES public.dataset_key_sets(id);


--
-- Name: project_memberships fk_rails_86b046ec96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_memberships
    ADD CONSTRAINT fk_rails_86b046ec96 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: announcements fk_rails_9281ffc5d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_rails_9281ffc5d6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: project_resources fk_rails_93afcb2fcc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_resources
    ADD CONSTRAINT fk_rails_93afcb2fcc FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: project_submissions fk_rails_a21d6246af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_submissions
    ADD CONSTRAINT fk_rails_a21d6246af FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: announcement_dismissals fk_rails_c290f2d124; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_dismissals
    ADD CONSTRAINT fk_rails_c290f2d124 FOREIGN KEY (announcement_id) REFERENCES public.announcements(id);


--
-- Name: announcement_dismissals fk_rails_ed56667dd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcement_dismissals
    ADD CONSTRAINT fk_rails_ed56667dd1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: citations fk_rails_f81b244ac7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.citations
    ADD CONSTRAINT fk_rails_f81b244ac7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: project_submissions fk_rails_fa232950b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_submissions
    ADD CONSTRAINT fk_rails_fa232950b0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: track_things fk_track_request_info_request; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things
    ADD CONSTRAINT fk_track_request_info_request FOREIGN KEY (info_request_id) REFERENCES public.info_requests(id);


--
-- Name: track_things_sent_emails fk_track_request_info_request_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things_sent_emails
    ADD CONSTRAINT fk_track_request_info_request_event FOREIGN KEY (info_request_event_id) REFERENCES public.info_request_events(id);


--
-- Name: track_things fk_track_request_public_body; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things
    ADD CONSTRAINT fk_track_request_public_body FOREIGN KEY (public_body_id) REFERENCES public.public_bodies(id);


--
-- Name: track_things_sent_emails fk_track_request_public_body; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things_sent_emails
    ADD CONSTRAINT fk_track_request_public_body FOREIGN KEY (public_body_id) REFERENCES public.public_bodies(id);


--
-- Name: track_things fk_track_request_tracked_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things
    ADD CONSTRAINT fk_track_request_tracked_user FOREIGN KEY (tracked_user_id) REFERENCES public.users(id);


--
-- Name: track_things fk_track_request_tracking_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things
    ADD CONSTRAINT fk_track_request_tracking_user FOREIGN KEY (tracking_user_id) REFERENCES public.users(id);


--
-- Name: track_things_sent_emails fk_track_request_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_things_sent_emails
    ADD CONSTRAINT fk_track_request_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_info_request_sent_alerts fk_user_info_request_sent_alert_info_request_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_info_request_sent_alerts
    ADD CONSTRAINT fk_user_info_request_sent_alert_info_request_event FOREIGN KEY (info_request_event_id) REFERENCES public.info_request_events(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('1'),
('10'),
('100'),
('101'),
('102'),
('103'),
('104'),
('105'),
('106'),
('107'),
('108'),
('109'),
('11'),
('110'),
('111'),
('112'),
('113'),
('114'),
('115'),
('116'),
('117'),
('118'),
('12'),
('13'),
('14'),
('15'),
('16'),
('17'),
('18'),
('2'),
('20120822145640'),
('20120910153022'),
('20120912111713'),
('20120912112036'),
('20120912112312'),
('20120912112655'),
('20120912113004'),
('20120912113720'),
('20120912114022'),
('20120912170035'),
('20120913074940'),
('20120913080807'),
('20120913081136'),
('20120913135745'),
('20120919140404'),
('20121010214348'),
('20121022031914'),
('20130731142632'),
('20130731145325'),
('20130801154033'),
('20130816150110'),
('20130822161803'),
('20130919151140'),
('20131024114346'),
('20131024152540'),
('20131101155844'),
('20131127105438'),
('20131127135622'),
('20131211152641'),
('20140325120619'),
('20140408145616'),
('20140528110536'),
('20140710094405'),
('20140716131107'),
('20140801132719'),
('20140804120601'),
('20140824191444'),
('20151006101417'),
('20151006104552'),
('20151006104739'),
('20151009162421'),
('20151020112248'),
('20151104131702'),
('20160526154304'),
('20160602143125'),
('20160602145046'),
('20160613145644'),
('20160613151127'),
('20160613151912'),
('20160613152433'),
('20160613153739'),
('20160613154616'),
('20160701155339'),
('20160907144809'),
('20161006142352'),
('20161101110656'),
('20161101151318'),
('20161116121007'),
('20161128095350'),
('20161206174634'),
('20161206175711'),
('20161206175737'),
('20161207184708'),
('20161222101600'),
('20170216101547'),
('20170227140831'),
('20170301163735'),
('20170301164705'),
('20170316170248'),
('20170323165519'),
('20170328100359'),
('20170411113908'),
('20170412141214'),
('20170412143304'),
('20170412145313'),
('20170412150729'),
('20170413135231'),
('20170414140927'),
('20170421145745'),
('20170509210708'),
('20170516120853'),
('20170516132204'),
('20170606141753'),
('20170621112453'),
('20170704143210'),
('20170717141302'),
('20170718261524'),
('20170726114401'),
('20170825150448'),
('20170914164031'),
('20170922160120'),
('20171207140915'),
('20171207140945'),
('20171222121709'),
('20180412135329'),
('20180418154555'),
('20180418154949'),
('20180418155130'),
('20180418155632'),
('20180418155850'),
('20180418155927'),
('20180418160008'),
('20180418160048'),
('20180418160204'),
('20180418160205'),
('20180418160206'),
('20180801085621'),
('20181128160243'),
('20190626153909'),
('20191211155455'),
('20200213123800'),
('20200311141432'),
('20200311141504'),
('20200314215007'),
('20200501183039'),
('20200501183049'),
('20200501183102'),
('20200501183111'),
('20200509082917'),
('20200515141039'),
('20200520073810'),
('20210114132408'),
('20210114161442'),
('20210921094059'),
('21'),
('22'),
('23'),
('24'),
('25'),
('26'),
('27'),
('28'),
('29'),
('30'),
('31'),
('32'),
('33'),
('34'),
('35'),
('36'),
('37'),
('38'),
('39'),
('4'),
('40'),
('41'),
('42'),
('43'),
('44'),
('45'),
('46'),
('47'),
('48'),
('49'),
('5'),
('50'),
('51'),
('52'),
('53'),
('54'),
('55'),
('56'),
('57'),
('58'),
('59'),
('6'),
('60'),
('61'),
('62'),
('63'),
('64'),
('65'),
('66'),
('67'),
('68'),
('69'),
('7'),
('70'),
('71'),
('72'),
('73'),
('74'),
('75'),
('76'),
('77'),
('78'),
('79'),
('8'),
('80'),
('81'),
('82'),
('83'),
('84'),
('85'),
('86'),
('87'),
('88'),
('89'),
('9'),
('90'),
('91'),
('92'),
('93'),
('94'),
('95'),
('96'),
('97'),
('98'),
('99');


