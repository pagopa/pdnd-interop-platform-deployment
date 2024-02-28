CREATE TABLE IF NOT EXISTS "${applicationSchema}".events (
    sequence_num BIGSERIAL NOT NULL,

    stream_id UUID NOT NULL,
    version BIGINT NOT NULL,

    type TEXT NOT NULL,
    event_version INT NOT NULL,
    data BYTEA NOT NULL,

    log_date TIMESTAMPTZ NOT NULL DEFAULT now(),

    PRIMARY KEY (sequence_num),
    UNIQUE (stream_id, version)
);