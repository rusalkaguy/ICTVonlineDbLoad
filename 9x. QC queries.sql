--
-- check that node counts line up with delta counts
--
declare @msl int; set @msl=(select MAX(msl_release_num) from taxonomy_node)
select 'TARGET MSL: ',@msl



-- ***************************************************************************
-- stats on MSL and MSL-1
-- ***************************************************************************
select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	p.msl_release_num as prev_msl, dx.prev_tags, dx.msl_release_num as msl, dx.next_tags, n.msl_release_num as next_msl
	, COUNT(case when dx.is_hidden=0 then 1 end) as [viz_count]
	, COUNT(case when dx.is_hidden=1 then 1 end) as [hidden_count]
	, COUNT(dx.is_hidden) as [total_count]
	, [notes and errors]= case	
		when prev_tags='Renamed,' then case	
			when COUNT(case when dx.is_hidden=1 then 1 end)=1 then 'OK: Tree root node is hidden and renamed'
			else 'ERROR: Only the tree root node can be hidden and renamed'
			end
		when prev_tags in ('Merged,', 'Moved,','Renamed,Moved,') and COUNT(case when dx.is_hidden=1 then 1 end)>0 then 'ERROR: only visible nodes '+prev_tags
		when prev_tags IS NULL and next_tags IS NULL and COUNT(case when dx.is_hidden=0 then 1 end)>0 then 'ERROR: only hidden nodes can disapear/appear w/o delta links'
		else ''
	end
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id
left outer join taxonomy_node n on n.taxnode_id=dx.next_id
where (dx.msl_release_num = @msl or p.msl_release_num=(@msl-1)) and dx.is_deleted=0
--and dx.is_hidden=0 -- no deltas between hidden nodes
group by p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
order by p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 

select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	p.msl_release_num as prev_msl, dx.prev_tags, dx.msl_release_num as msl, dx.next_tags, n.msl_release_num as next_msl
	, COUNT(case when dx.is_hidden=0 then 1 end) as [viz_count]
	, COUNT(case when dx.is_hidden=1 then 1 end) as [hidden_count]
	, COUNT(dx.is_hidden) as [total_count]
	, [notes and errors]= case	
		when prev_tags='Renamed,' then case	
			when next_tags='Renamed,' AND COUNT(case when dx.is_hidden=1 then 1 end)=1 then 'OK: Tree root node is hidden and renamed'
			when COUNT(case when dx.is_hidden=1 then 1 end)>0 then 'ERROR: Only the tree root node can be hidden and renamed'
			else ''
			end
		when prev_tags in ('Merged,', 'Moved,','Renamed,Moved,') and COUNT(case when dx.is_hidden=1 then 1 end)>0 then 'ERROR: only visible nodes '+prev_tags
		when prev_tags IS NULL and next_tags IS NULL and COUNT(case when dx.is_hidden=0 then 1 end)>0 then 'ERROR: only hidden nodes can disapear/appear w/o delta links'
		else ''
	end
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id
left outer join taxonomy_node n on n.taxnode_id=dx.next_id
where dx.msl_release_num = (@msl-1) and dx.is_deleted=0
--and dx.is_hidden=0 -- no deltas between hidden nodes
group by p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 

-- ***************************************************************************
-- report problem taxa - summary
-- ***************************************************************************


-- disappear w/o delta node
select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	'ERROR: MSL'+rtrim(dx.msl_release_num)+' tax DISappears with out a delta record' as [error_summary: DISappear w/o delta]
	, p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
	, COUNT(*) as [count]
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id and p.is_deleted=0
left outer join taxonomy_node n on n.taxnode_id=dx.next_id and n.is_deleted=0
where dx.msl_release_num = (select max(msl_release_num)-1 from taxonomy_toc) and dx.is_deleted=0
and dx.is_hidden=0 -- no deltas between hidden nodes
and n.msl_release_num is null and dx.next_tags is null
group by p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
order by dx.msl_release_num desc--, dx.ictv_id desc

-- appear w/o delta node
select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	'ERROR: MSL'+rtrim( dx.msl_release_num)+' tax APPEARS with out a delta record' as [error_summary: APPEAR w/o delta]
	, p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
	, COUNT(*) as [count]
from taxonomy_node_dx dx 
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id and p.is_deleted=0
left outer join taxonomy_node n on n.taxnode_id=dx.next_id and n.is_deleted=0
where dx.msl_release_num = (select max(msl_release_num) from taxonomy_toc) and dx.is_deleted=0
and dx.is_hidden=0 -- no deltas between hidden nodes
and p.msl_release_num is null and dx.prev_tags is null
group by p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
order by dx.msl_release_num desc--, dx.ictv_id desc

-- accents
--
-- check accents
--
select title, msl_release_num, status_msg, count(*) as [count]
from (
	select 'accent_check:' as title 
		, msl_release_num, taxnode_id, name
		, status_msg = case 
			when name like 'Jun%n%virus%' or name like 'Amapar%virus%' then case when name like '%í%' then 'OK: í' else 'ERROR: í missing' end
			when name like 'Sabi%virus%' or name like 'Paran%virus%' then case when name like '%á%' then 'OK: á' else 'ERROR: á missing' end
			when name like 'Kalancho%virus%' then case when name like '%ë%' then 'OK: ë' else 'ERROR: ë missing' end
			when isolate_csv like 'M_ji_ng %'  then case when isolate_csv like N'%ā%' then N'OK: ā' else N'ERROR: ā missing' end
			when isolate_csv like 'X_nch_ng %' then case when isolate_csv like N'%ī%' then N'OK: ī' else N'ERROR: ī missing' end
			when isolate_csv like 'L_sh_ %'    then case when isolate_csv like N'%ĭ%ì%' then N'OK: ĭ & ì ' else N'ERROR: ĭ and/or ì missing' end
			when isolate_csv like 'T_ch_ng %'  then case when isolate_csv like N'%ǎ%' then N'OK: ǎ' else N'ERROR: ǎ missing' end
			when isolate_csv like 'W_nzh_u %'  then case when isolate_csv like N'%ē%ō%' then N'OK: ē & ō' else N'ERROR: ē and/or ō missing' end
			when isolate_csv like 'S_nxi %'	then case when isolate_csv like N'%ā%' then N'OK: ā' else N'ERROR: ā missing' end
			else 'error: unknown target'
			end		
	from taxonomy_node
	where msl_release_num in (@msl) --, @msl-1)
	and (
		-- taxon names
		name like 'Jun%n%virus%' or name like 'Amapar%virus%' or name like '%í%'
		or name like 'Sabi%virus%' or name like 'Paran%virus%' or name like '%á%'
		or name like 'Kalancho%virus%' or name like '%ë%'
		-- isolate names
		or isolate_csv like 'M_ji_ng %'
		or isolate_csv like 'X_nch_ng %'
		or isolate_csv like 'L_sh_ %'
		or isolate_csv like 'T_ch_ng %'
		or isolate_csv like 'W_nzh_u %'
		or isolate_csv like 'S_nxi %'
		or isolate_csv like 'W_nzh_u %'
	)
) as src 
group by title, msl_release_num, status_msg
order by msl_release_num desc

-- ***************************************************************************
-- report problem taxa - details
-- ***************************************************************************

select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	'ERROR DETAIL: MSL'+rtrim(@msl-1)+' tax DISappears with out a delta record' as [error_detail: DISappears with out a delta record]
	, p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
	, dx.taxnode_id, dx.ictv_id, lvl.name, dx.lineage
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id and p.is_deleted=0
left outer join taxonomy_node n on n.taxnode_id=dx.next_id and n.is_deleted=0
left outer join taxonomy_level lvl on lvl.id = dx.level_id
where dx.msl_release_num = (@msl-1) and dx.is_deleted=0 
and dx.is_hidden=0 -- no deltas between hidden nodes
and n.msl_release_num is null and dx.next_tags is null
order by dx.left_idx

select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	'ERROR DETAIL: MSL'+rtrim(dx.msl_release_num)+' tax APPEARS with out a delta record' as [error_detail: APPEARS with out a delta record]
	, p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
	, dx.taxnode_id, dx.ictv_id, lvl.name, dx.lineage
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id and p.is_deleted=0
left outer join taxonomy_node n on n.taxnode_id=dx.next_id and n.is_deleted=0
left outer join taxonomy_level lvl on lvl.id = dx.level_id
where dx.msl_release_num = (select max(msl_release_num) from taxonomy_toc) and dx.is_deleted=0
and dx.is_hidden=0 -- no deltas between hidden nodes
and p.msl_release_num is null and dx.prev_tags is null
order by dx.msl_release_num desc, dx.ictv_id desc

select --p.msl_release_num, dx.prev_id, dx.msl_release_num, dx.taxnode_id, dx.next_id, n.msl_release_num 
	'ERROR DETAIL: MSL'+rtrim(@msl)+' taxa HIDDEN and RENAMED' as [error_details: HIDDEN and RENAMED]
	, p.msl_release_num, dx.prev_tags, dx.msl_release_num, dx.next_tags, n.msl_release_num 
	, dx.taxnode_id, dx.ictv_id, lvl.name, dx.lineage
from taxonomy_node_dx dx
left outer join taxonomy_node p on p.taxnode_id=dx.prev_id and p.is_deleted=0
left outer join taxonomy_node n on n.taxnode_id=dx.next_id and n.is_deleted=0
left outer join taxonomy_level lvl on lvl.id = dx.level_id
where dx.msl_release_num = (@msl) and dx.is_deleted=0
and dx.is_hidden=1 and (prev_tags like '%Renamed%' or next_tags like '%Renamed%') -- no deltas between hidden nodes
and dx.tree_id <> dx.taxnode_id -- trees are hidden, but DO have deltas
order by dx.left_idx

-- accents 
select 'accent_check NAME:' as details
	, msl_release_num, taxnode_id, name
	, [status] = case 
		when name like 'Jun%n%virus%' or name like 'Amapar%virus%' then case when name like '%í%' then 'OK: í' else 'ERROR: í missing' end
		when name like 'Sabi%virus%' or name like 'Paran%virus%' then case when name like '%á%' then 'OK: á' else 'ERROR: á missing' end
		when name like 'Kalancho%virus%' then case when name like '%ë%' then 'OK: ë' else 'ERROR: ë missing' end
		else 'error: unknown target'
		end		
from taxonomy_node 
where msl_release_num in (@msl, @msl-1)
and (
	name like 'Jun%n%virus%' or name like 'Amapar%virus%' or name like '%í%'
	or name like 'Sabi%virus%' or name like 'Paran%virus%' or name like '%á%'
	or name like 'Kalancho%virus%' or name like '%ë%')
order by msl_release_num desc

-- declare @msl int; set @msl=(select MAX(msl_release_num) from taxonomy_node)
select 'accent_check ISOLATE:' as details
	, msl_release_num, taxnode_id, name, isolate_csv
	, [status] = case 
		when isolate_csv like 'M_ji_ng %'  then case when isolate_csv like N'%ā%' then N'OK: ā' else N'ERROR: ā missing' end
		when isolate_csv like 'X_nch_ng %' then case when isolate_csv like N'%ī%' then N'OK: ī' else N'ERROR: ī missing' end
		when isolate_csv like 'L_sh_ %'    then case when isolate_csv like N'%ĭ%ì%' then N'OK: ĭ & ì ' else N'ERROR: ĭ and/or ì missing' end
		when isolate_csv like 'T_ch_ng %'  then case when isolate_csv like N'%ǎ%' then N'OK: ǎ' else N'ERROR: ǎ missing' end
		when isolate_csv like 'W_nzh_u %'  then case when isolate_csv like N'%ē%ō%' then N'OK: ē & ō' else N'ERROR: ē and/or ō missing' end
		when isolate_csv like 'S_nxi %'	then case when isolate_csv like N'%ā%' then N'OK: ā' else N'ERROR: ā missing' end
		else 'error: unknown target'
		end		
from taxonomy_node 
where msl_release_num in (@msl, @msl-1)
and (
	   isolate_csv like 'M_ji_ng %'
	or isolate_csv like 'X_nch_ng %'
	or isolate_csv like 'L_sh_ %'
	or isolate_csv like 'T_ch_ng %'
	or isolate_csv like 'W_nzh_u %'
	or isolate_csv like 'S_nxi %'
	or isolate_csv like 'W_nzh_u %'
)
order by msl_release_num desc


select * from load_next_msl_33 where _dest_taxon_name = 'Peropuvirus'
select * from taxonomy_node where lineage ='Negarnaviricota;Haploviricotina;Monjiviricetes;Mononegavirales;Artoviridae;Peropuvirus' or taxnode_id in (20171582)
select * from taxonomy_node_delta where prev_taxid in (20171582,2018158) or new_taxid in (20171582,2018158) 

-- ===========================================================================
-- update out_target in prev MSL for things whose lineage has changed at a higher rank
-- ===========================================================================

select report='proposed change to taxonomy_node.out_target:',
	taxonomy_node.taxnode_id, taxonomy_node.lineage, taxonomy_node.out_change, taxonomy_node.out_target
	,'>>>'
	,ld._src_lineage, ld._action, ld._dest_lineage
	,'>>>'
	,nn.taxnode_id, nn.lineage,
	-- UPDATE taxonomy_node SET
	out_target = nn.lineage
from taxonomy_node
join load_next_msl_34a ld on  taxonomy_node.taxnode_id=ld.prev_taxnode_id
join taxonomy_node nn on nn.taxnode_id=ld.dest_taxnode_id
where taxonomy_node.out_target <> nn.lineage

exec rebuild_delta_nodes NULL

-- look for missing delta nodes based on updated lineages
select 
	d.prev_taxid, d.new_taxid, d.tag_csv
	,'|||'
	,pn.taxnode_id, pn.lineage, pn.out_change, pn.out_target
	,'>>>'
	,ld._src_lineage, ld._action, ld._dest_lineage
	,'>>>'
	,nn.taxnode_id, nn.lineage
from load_next_msl_33 ld
join taxonomy_node pn on pn.taxnode_id=ld.prev_taxnode_id
join taxonomy_node nn on nn.taxnode_id=ld.dest_taxnode_id
left outer join taxonomy_node_delta d on d.prev_taxid = ld.prev_taxnode_id
where d.new_taxid is null
