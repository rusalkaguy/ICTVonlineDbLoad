--
-- fix order Halopanivirales ?
--  
-- it was original a "new family" but with stuff filled in for src*, so it got 
-- implemented partly as "new" partly as "move". Crossed the wires, and didn't get delta'ed right. 
--
-- Delta builder keys off in_target, which shouldn't be set for a "new", so unset
-- and rebuild deltas.
-- 
update taxonomy_node set in_target = NULL where in_target is not NULL and in_notes='ICTV MSL Release 36 2020 Changes.1.col_mapped.xls; sort=113438' and name='Simuloviridae'
GO
EXEC [dbo].[rebuild_delta_nodes] NULL -- MSL36 1m47s (genome-ws-02)
GO
-- QC with "9x.QC_deltas.sql"

select * from load_next_msl_35 where _dest_taxon_name='Halopanivirales'

select * from taxonomy_node_dx where name = 'Simuloviridae' order by msl_releasE_num
select * from taxonomy_node_dx where name = 'Halopanivirales' order by msl_releasE_num
select * from load_next_msl where  _dest_taxon_name='Simuloviridae'

select in_change, in_target, in_notes, out_change, out_target, out_notes, * from taxonomy_node where name in ('Halopanivirales')
union 
select in_change, in_target, in_notes, out_change, out_target, out_notes, * from taxonomy_node where name ='Simuloviridae' or taxnode_id in (0) or parent_id in (202008706,202011859)
order by msl_release_num, left_idx

