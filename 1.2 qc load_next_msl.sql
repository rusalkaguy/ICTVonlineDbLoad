-- *************************************************************
--
-- [load_next_msl_taxonomy]
-- 
-- data cleanups
--
-- *************************************************************

begin transaction


-- ----------------------------------------------------------------------------------
-- look for moved AND deleted species
--   get rid of the DELETE record
--   update the MOVE record with the src info from the delete.
-- ----------------------------------------------------------------------------------
SELECT 
	sd.src_taxnode_id
	, sd.src_lineage
	, sd.src_out_change
	, sd.dest_target
	, sm.src_out_change
	, sm.dest_target
FROM load_next_msl sd
JOIN load_next_msl sm on sd.src_taxnode_id = sm.src_taxnode_id
AND sd.src_out_change <> sm.src_out_change





-- remove leading/trailining spaces
update [load_next_msl] set
-- select title='1.2.1', ref_filename,
	ref_filename=ltrim(rtrim(ref_filename))
	, corrected  =  isnull(corrected+'; ','')+'removed leading/trailing spaces from proposal'
from [load_next_msl]
where ref_filename <> ltrim(rtrim(ref_filename))

-- QQQ WARNING: what about quotes in ref_filename?
update [load_next_msl] set
-- select title='1.2.2', ref_filename,
	ref_filename=replace(ref_filename,'"','')
	, corrected =  isnull(corrected+'; ','')+'removed quotes from proposal'
from [load_next_msl]
where ref_filename like '%"%'

-- check for ";" or "," in proposal names - indicates a list!
select title='1.2.3', ref_filename 
	,problem = case when ref_filename like '%;%' then '; list'
		when ref_filename like '% and %' then 'AND-separated pair'
		when ref_filename like '% and % and %' then 'AND-separated list'
		when ref_filename like '% %' then 'has spaces'
		when ref_filename like '%MISSING%' then 'MISSING'
		end
from [load_next_msl] 
where ref_filename like '%;%'  or ref_filename like '% %' or ref_filename like '%MISSING%'


-- FIX: separate AND-separated proposal pairs
/*
-- split 
update [load_next_msl_taxonomy] set
-- select proposal,
	proposal=left(proposal,patindex('% and %',proposal)-1)
	, proposal2 = substring(proposal, patindex('% and %', proposal) + len(' and ') + 1, 100)
	, corrected = isnull(corrected+'; ','')+'split proposal into (proposal,proposal2) on "% and %"'
from [load_next_msl_taxonomy]
where proposal like '% and %'
-- remove duplicates
*/

-- check line count - should be last (excel row -1) 
select 'Number of rows of data: ', COUNT(*), ' (check vs Excel file!)' from [load_next_msl]

-- check accents came over ok

select src_lineage,src_isolates
from [load_next_msl] 
where 
	src_lineage like '%í%' or src_lineage like '%í%' or src_lineage like 'Jun%n virus' -- Junín virus
or  src_lineage like '%Kalancho%'  -- Kalanchoë mosaic virus
or  src_lineage like '%Paran% virus' -- Paraná virus
or  src_isolates like 'X%nch%ng mosquito virus' -- Xincheng anphevirus / Xīnchéng mosquito virus
or  src_isolates like N'ī' or src_isolates like  N'ī'

-- correct accents -- if needed
update [load_next_msl] set 
-- select src_lineage,src_isolates,dest_target,
	src_lineage=REPLACE(REPLACE(REPLACE(src_lineage,'+¡','í'),'+½','ë'),'+í','á')
	,src_isolates=REPLACE(REPLACE(REPLACE(src_isolates,'+¡','í'),'+½','ë'),'+í','á')
	,dest_target=REPLACE(REPLACE(REPLACE(dest_target,'+¡','í'),'+½','ë'),'+í','á')
from [load_next_msl] 
where src_lineage like '%+%' or src_lineage like '%+½%' or src_lineage like '%+í%'
or    src_isolates like '%+%' or src_isolates like '%+½%' or src_isolates like '%+í%'
or    dest_target like '%+%' or dest_target like '%+½%' or dest_target like '%+í%'



-- correct smart quotes
update [load_next_msl] set 
-- select src_isolates,dest_isolates,
		src_isolates=REPLACE(replace(src_isolates,'“', '"'),'”','"')
		, dest_isolates=REPLACE(replace(dest_isolates,'“', '"'),'”','"')
		, corrected = isnull(corrected+'; ','')+'convert microsoft smartquotes to standard quotes'

from	[load_next_msl] 
where	src_isolates like '%“%' or src_isolates like '%”%'
or		dest_isolates like '%“%' or dest_isolates like '%”%'



-- correct vagrant spaces
select message='WARNING: records with spaces in dest_target at beginning or end of line (needs fixing)', *
from [load_next_msl]
where 
   rtrim(ltrim(dest_target)) <> dest_target
or rtrim(ltrim(src_lineage)) <> src_lineage
or rtrim(ltrim(src_name)) <> src_name

/*update load_next_msl set -- select
	dest_target=replace(replace(ltrim(rtrim(dest_target)),'; ',';'),' ;',';')
from load_next_msl
where dest_target like '%; %' or dest_target like '% ;%' or dest_target like ' %' or dest_target like '% '
*/
-- correct vagrant spaces
/*
select message='WARNING: records ending in as semi-colon (fixing)', dest_target
from load_next_msl
where rtrim(dest_target) like '%;' 
update load_next_msl set -- select
	dest_target=left(rtrim(dest_target),len(rtrim(dest_target))-1)
from load_next_msl
where rtrim(dest_target) like '%;' 
*/
---
-- let the user know
--
select message='DONE LOAD/QC'

--rollback transaction -- obsolete
commit transaction
