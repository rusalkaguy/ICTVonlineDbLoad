-- -----------------------------------------------------------------------------
--
-- build deltas from in_out changes + {name, lineage, is_ref} changes
--
-- -----------------------------------------------------------------------------

-- MSL35 1m05s (genome-ws-02)
-- MSL34 3m50s
-- MSL33 0m24s
EXEC [dbo].[rebuild_delta_nodes] NULL -- hits latest MSL automatically.

-- MSL35 0m03s (genome-ws-02)
-- MSL34 0m07s
-- MSL33 0m07s
exec [dbo].[rebuild_node_merge_split]

