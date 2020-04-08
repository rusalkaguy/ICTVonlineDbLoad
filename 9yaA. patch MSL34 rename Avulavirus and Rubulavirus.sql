--
-- correct changes for  in 33->34
--
--
--•	Avulavirus SHOULD split into:
--  o	Metaavulavirus
--  o	Orthoavulavirus
--  o	Paraavulavirus
-- 
--•	Rubulavirus SHOULD split into:
--  o	Orthorubulavirus
--  o	Pararubulavirus
--
begin transaction
-- rollback transaction

select msl=msl_release_num, prev_tags, name, next_tags, * from taxonomy_node_dx where msl_release_num in (33,34) and level_id=500 and (lineage like '%Avulavirus%' or lineage like '%Rubulavirus%') order by msl,left_idx

-- ************************
-- delete taxa from MSL34
-- ************************
delete -- select *
from taxonomy_node 
where msl_release_num=34 and name in ('Avulavirus', 'Rubulavirus')

-- QC get the from
select t='from', msl_release_num, lineage from taxonomy_node where msl_release_num=33 and level_id=500 and (lineage like '%Avulavirus%' or lineage like '%Rubulavirus%') order by left_idx
select t='to',  msl_release_num, lineage, in_change, in_filename from taxonomy_node where msl_release_num=34 and level_id=500 and (lineage like '%Avulavirus%' or lineage like '%Rubulavirus%') order by left_idx

-- ************************
-- correct in_change for 34
-- ************************
update taxonomy_node set -- select in_change, in_target, in_filename, lineage,
 in_change='split', in_filename='2018.011M.A.v1.Paramyxoviridae.zip'
 , in_target='Negarnaviricota;Haploviricotina;Monjiviricetes;Mononegavirales;Paramyxoviridae;Avulavirus'
 , notes='MSL33/34: orginally annotated as new, corrected to split'
from taxonomy_node 
where msl_release_num=34 and level_id=500/*genus*/ and lineage like '%Avulavirus%' 

update taxonomy_node set -- select in_change, in_target, in_filename, lineage,
 in_change='split', in_filename='2018.011M.A.v1.Paramyxoviridae.zip'
 , in_target='Negarnaviricota;Haploviricotina;Monjiviricetes;Mononegavirales;Paramyxoviridae;Rubulavirus'
, notes='MSL33/34: orginally annotated as new, corrected to split'
from taxonomy_node 
where msl_release_num=34 and level_id=500/*genus*/ and lineage like '%Rubulavirus%' 


exec rebuild_delta_nodes 34

exec rebuild_node_merge_split

select msl=msl_release_num, * from taxonomy_node_dx where msl_release_num in (33,34) and level_id=500 and (lineage like '%Avulavirus%' or lineage like '%Rubulavirus%') order by msl,left_idx

commit transaction

-- no MSL visible changes
--ICTVonline=201851629


