/*
* errors reported in MSL30v0
*/

--
-- Jens Kuhn
--
select taxnode_id, lineage, name, isolate_csv
from taxonomy_node
where msl_release_num = 30
and (
name in ('Xincheng anphevirus' , 'Lloviu cuevavirus')
)

select *  
from load_next_msl
where dest_target like '%Xincheng anphevirus%'
 or dest_target like '%Lloviu cuevavirus%' or src_lineage like '%Lloviu cuevavirus%'

--
-- NVarChar ONLY character detection
--
declare @ll as int; set @ll = 500
select dest_taxnode_id, isnull(dest_target, src_lineage), dest_isolates, CAST(dest_isolates as varchar(500))
	,error = (case 
		when dest_isolates like N'%ā%' then N'%ā%'
		when dest_isolates like N'%ī%' then N'%ī%' 
		when dest_isolates like N'%ē%' then N'%ē%' 
		when dest_isolates like N'%ō%' then N'%ō%' -- mancon
		when dest_isolates like N'%ĭ%' then N'%ĭ%'
		when dest_isolates like N'%ǎ%' then N'%ǎ%'
		when dest_isolates like N'%ǔ%' then N'%ǔ%'
		when dest_isolates like N'%φ%' then N'%φ%'

				else 'unknown'
		end)
from load_next_msl
where 
-- differences - excluding []'s - not sure why they cause a false positive.
left(replace(replace(dest_isolates,'[',''),']',''),@ll) not like  left(cast(replace(replace(dest_isolates,'[',''),']','') as varchar(500)),@ll)
-- known nvarchar-only characters
or dest_isolates like N'%ā%' or dest_isolates like N'%ī%' or dest_isolates like N'%ē%' or dest_isolates like N'%ō%' -- mancon
 or dest_isolates like N'%ĭ%' or dest_isolates like N'%ǎ%' or dest_isolates like N'%ǔ%' or dest_isolates like N'%φ%'

--
--
--
select * 
from load_next_msl
where dest_taxnode_id in (20153398, 20153241)
or dest_target like '%Dyoomegapapillomavirus%'

select * 
from taxonomy_node
where msl_release_num = 30 and (
	name like 'Dyoomegapapillomavirus%'
	or 
	taxnode_id in (20153241)
)

--
--
select 'taxonomy_node', * from taxonomy_node 
where msl_release_num = 30 and taxnode_id = 20150999

select 'load_next_msl', * from load_next_msl
where dest_taxnode_id = 20150999