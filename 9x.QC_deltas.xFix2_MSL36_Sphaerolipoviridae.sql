/*
* update the notes to give the unique "sort" key in the source document
*
* taxonomy_node.in_notes/out_notes = load_next_msl.filename + '; sort=' load_next_msl.sort
* 
*/


--
-- fix family Sphaerolipoviridae ?
--  
-- it was original a "new family" but with stuff filled in for src*, so it got 
-- implemented partly as "new" partly as "move". Crossed the wires, and didn't get delta'ed right. 
--
-- Delta builder keys off in_target, which shouldn't be set for a "new", so unset
-- and rebuild deltas.
-- 
update taxonomy_node set in_target = NULL where in_target is not NULL and in_notes='ICTV MSL Release 36 2020 Changes.1.col_mapped.xls; sort=92052' and name='Matshushitaviridae'
GO
EXEC [dbo].[rebuild_delta_nodes] NULL -- MSL36 1m47s (genome-ws-02)
GO
-- QC with "9x.QC_deltas.sql"

select* from load_next_msl_35 where _dest_taxon_name='Sphaerolipoviridae'

select * from taxonomy_node_dx where taxnode_id = 202011533 order by msl_releasE_num
select * from load_next_msl where dest_taxnode_id = 202011533

select in_change, in_target, in_notes, out_change, out_target, out_notes, * from taxonomy_node where name in ('Sphaerolipoviridae', 'Halopanivirales')
union 
select in_change, in_target, in_notes, out_change, out_target, out_notes, * from taxonomy_node where name ='Matshushitaviridae' or taxnode_id in (202008706) or parent_id in (201905054, 202011533, 202005054)
order by msl_release_num, left_idx

