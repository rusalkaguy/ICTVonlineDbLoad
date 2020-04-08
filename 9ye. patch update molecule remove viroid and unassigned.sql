BEGIN TRANSACTION -- SQL update molecule ID from MSL

/*
[Unassigned=>NULL]
*/
update taxonomy_node set molecule_id = NULL where taxnode_id in (
 20180081 -- family	Unassigned	NULL	NULL	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae
,20185056 -- genus	Unassigned	overrides	dsDNA	Sphaerolipoviridae;Alphasphaerolipovirus
,20185061 -- genus	Unassigned	overrides	dsDNA	Sphaerolipoviridae;Betasphaerolipovirus
,20185063 -- genus	Unassigned	overrides	dsDNA	Sphaerolipoviridae;Gammasphaerolipovirus
)
and molecule_id = (select id from taxonomy_molecule where abbrev='Unassigned')

/*
[Viroid -> ssRNA]

*/
update taxonomy_node set molecule_id = (select id from taxonomy_molecule where abbrev='ssRNA') where taxnode_id in (
 20182645 -- family	Viroid	NULL	NULL	Avsunviroidae 
,20184496 -- family	Viroid	NULL	NULL	Pospiviroidae
)
and molecule_id = (select id from taxonomy_molecule where abbrev='Viroid')

/* 
 inher_molecule_id = NULL
 -- 
 -- trigger is failing to cleanup after parent's molecule_id was set to null
 --
 */
update taxonomy_node set 
--select inher_molecule_id, lineage ,
	inher_molecule_id = NULL 
from taxonomy_node
where taxnode_id in (
20180081,-- family	NULL	NULL	NULL	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae
20180082,-- genus	ssRNA(-)	overrides	Unassigned	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae;Herbevirus
20180088,--	genus	ssRNA(-)	overrides	Unassigned	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae;Orthobunyavirus
20186220,--	genus	ssRNA(-)	overrides	Unassigned	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae;Shangavirus
20180178--	genus	ssRNA(+/-)	overrides	Unassigned	Negarnaviricota;Polyploviricotina;Ellioviricetes;Bunyavirales;Peribunyaviridae;Tospovirus
) and inher_molecule_id =(select id from taxonomy_molecule where abbrev='Unassigned')


commit transaction

begin transaction

--
-- clean push molecule ID's up the tree and remove duplicates. 
-- 
exec sp_simplify_molecule_id_settings 
exec sp_simplify_molecule_id_settings 
exec sp_simplify_molecule_id_settings 
exec sp_simplify_molecule_id_settings 

--
-- re-export to compare
--
select species, inher_molecule 
from taxonomy_node_names
where tree_id=20180000 --dbo.udf_getTreeID(NULL)
and level_id=600
--and name = 'Chaetoceros diatodnavirus 1' 
order by left_idx

 rollback transaction


