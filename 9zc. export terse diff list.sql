-- brief delta list
declare @msl int; set @msl = (select max(msl_release_num) from taxonomy_node)
declare @prev_msl int; set @prev_msl = (@msl-1)
select 'TARGET MSLs', [current]=@msl, [prev]=@prev_msl, [excel_tab_name]='Deltas MSL'+rtrim(@prev_msl)+' v '+rtrim(@msl)

select 
	isnull(rtrim(prev.left_idx),'') as sort_old
	,isnull(plevel.name,'') as old_level
	,isnull(prev.lineage,'') as old_lineage
	, delta.tag_csv as change
	, isnull(delta.proposal,'') as proposal
	, isnull(dlevel.name,'') as new_level, isnull(dx.lineage,'') as new_lineage, isnull(dx.left_idx,'') as sort_new
from taxonomy_node_delta delta 
left outer join taxonomy_node dx on delta.new_taxid = dx.taxnode_id
left outer join taxonomy_level dlevel on dlevel.id = dx.level_id
left outer join taxonomy_node prev on prev.taxnode_id = delta.prev_taxid
left outer join taxonomy_level plevel on plevel.id = prev.level_id
where (dx.msl_release_num = @msl and delta.tag_csv <> '')
or (prev.msl_release_num = (@msl-1) and delta.is_deleted =1)
order by dx.left_idx, prev.left_idx


