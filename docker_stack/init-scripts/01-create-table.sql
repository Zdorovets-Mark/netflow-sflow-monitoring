DROP TABLE IF EXISTS netflow_data CASCADE;
DROP TABLE IF EXISTS sflow_data CASCADE;

CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE netflow_data (
    stamp_inserted TIMESTAMP WITHOUT TIME ZONE,
    stamp_updated TIMESTAMP WITHOUT TIME ZONE,
    ip_src INET NOT NULL,
    ip_dst INET NOT NULL,
    port_src INTEGER,
    port_dst INTEGER,
    ip_proto SMALLINT,
    bytes BIGINT,
    packets BIGINT,

    peer_ip_src  INET NOT NULL,
    iface_in INTEGER,
    iface_out INTEGER
);
CREATE INDEX ON netflow_data (peer_ip_src, stamp_inserted DESC);
CREATE INDEX ON netflow_data (iface_in, stamp_inserted DESC);
CREATE INDEX ON netflow_data (iface_out, stamp_inserted DESC);
-- Создаём гипертаблицу TimescaleDB по полю stamp_inserted
SELECT create_hypertable('netflow_data', 'stamp_inserted', chunk_time_interval => INTERVAL '1 day');

CREATE TABLE IF NOT EXISTS sflow_data (
    stamp_inserted TIMESTAMP,
    stamp_updated TIMESTAMP,
    ip_src INET NOT NULL,
    ip_dst INET NOT NULL,
    port_src INTEGER,
    port_dst INTEGER,
    ip_proto SMALLINT,
    bytes BIGINT,
    packets BIGINT,
    sampling_rate INTEGER,

    peer_ip_src  INET NOT NULL,
    iface_in INTEGER,
    iface_out INTEGER
);

-- SELECT create_hypertable('sflow_data', 'stamp_inserted', chunk_time_interval => INTERVAL '1 day');
CREATE INDEX ON sflow_data (stamp_inserted);
CREATE INDEX ON sflow_data (peer_ip_src, stamp_inserted DESC);
CREATE INDEX ON sflow_data (iface_in, stamp_inserted DESC);
CREATE INDEX ON sflow_data (iface_out, stamp_inserted DESC);
