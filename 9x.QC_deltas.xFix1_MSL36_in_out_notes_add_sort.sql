/*
* update the notes to give the unique "sort" key in the source document
*
* taxonomy_node.in_notes/out_notes = load_next_msl.filename + '; sort=' load_next_msl.sort
* 
*/

--
-- add "sort" field to taxonomy_node.in_notes
--
select in_notes from taxonomy_node where msl_release_num = 36 and in_notes is not null

--
-- UPDATE in_notes
--
update taxonomy_node set
	--select taxnode_id, lineage, in_notes,'>>>',src.sort, src._action,
	in_notes=in_notes + '; sort='+rtrim(src.sort)
from taxonomy_node 
join load_next_msl src on src.dest_taxnode_id = taxonomy_node.taxnode_id
where src._action  in ('new','split')
and taxonomy_node.in_notes not like '%; sort=%'
--order by src._action, src.sort

--
-- UPDATE out_notes
--
update taxonomy_node set
	--select taxnode_id, lineage, out_notes,'>>>',src.sort, src._action,
	out_notes=src.filename + '; sort='+rtrim(src.sort)
from taxonomy_node 
join load_next_msl src on src.prev_taxnode_id = taxonomy_node.taxnode_id
where src._action NOT in ('new','split')
and taxonomy_node.out_notes not like '%; sort=%'
--order by src._action, src.sort


