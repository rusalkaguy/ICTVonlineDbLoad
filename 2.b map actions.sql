--
-- set load_new_msl.prev_taxnode_id and dest_taxnode_id, dest_ictv_id
--

--
-- MAP acton
--
update load_next_msl set 
    -- select distinct [change], [rank], 
	_action =(case 
		when [change] like '%as type%' then (('_ERROR: isType abolished in MSL36): ')+[change]) 
		when [change] like 'abolish%' then 'abolish' 
		when [change] like '%merge%' then 'merge' 
		when [change] like 'new%' then 'new' 
		when [change] like 'Create new%' then 'new' 
		when [change] like 'family%assigned%' then 'move' 
		when [change] like '%move%rename%' and cast(_src_taxon_name as varbinary(500))= cast(_dest_taxon_name as varbinary(500)) then '_ERROR: move-rename, but src_taxon=dest_taxon='+_src_taxon_name +'; sort='+rtrim(sort)
		when [change] like '%move%rename%' then 'move' 
		when [change] like '%move%' then 'move' 
		when [change] like 'species assign%' then 'move' 
		when [change] like 'assign%' then 'move' 
		when [change] like '%rename%' then 'rename'
		when [change] like 'split%' then 'split' 
		when [change] like 'promote%' then 'promote'
		else '_ERROR:'+[change]+'; sort='+rtrim(sort)
	end)
-- select * 
from load_next_msl src


-- 
-- QC mapping ERRORS
--
select [ERRORS]=_action, * 
from load_next_msl 
where _action is null or _action like '%error%'
order by sort



-- summarize after cleanup
select report='action summary', filename, dest_msl_release_num, _action, row_ct=count(*), max_taxid=max(dest_taxnode_id) 
from load_next_msl 
group by filename, dest_msl_release_num, _action
order by filename, dest_msl_release_num, _action

select report='action summary', filename, dest_msl_release_num, _action='all', row_ct=count(*), max_taxid=max(dest_taxnode_id) 
from load_next_msl 
group by filename, dest_msl_release_num
order by filename, dest_msl_release_num

select 
	report='QC change vocabulary'
	, filename
	,src.dest_msl_release_num
	, src.change, rank
	-- counts
	,row_ct=count(*) 
	, _action_legal = -- check against official vocab 
	(case when (
		select change from taxonomy_change_in where change=src._action
		union all
		select change from taxonomy_change_out where change=src._action
		) is not null then 'yes' else '!!NO!!' end) 
	-- fix up _action
	,_action
from load_next_msl src
group by filename, dest_msl_release_num, change, rank, _action
order by _action_legal



