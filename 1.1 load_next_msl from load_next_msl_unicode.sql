--use ICTVonline
/* =================================================================================
 * 
 * Populate "load_next_msl" from "load_next_msl_uncode" 
 * which was populated from Excel > Save As > Unicode.txt
 * via MSSQL > Tasks > Import...
 * 
 * ================================================================================= */

-- clear out table 
print 'TRUNCATE [load_next_msl]'
TRUNCATE TABLE [load_next_msl]
GO

print 'convert empty >>> NULL'
update load_next_msl_unicode set [dest_target name or lineage with ;'s] =null			where [dest_target name or lineage with ;'s]=''
update load_next_msl_unicode set src_name =null				where src_name in ('' ,'NULL')
update load_next_msl_unicode set src_isolates =null			where src_isolates=''
update load_next_msl_unicode set src_is_type =null			where src_is_type=''
update load_next_msl_unicode set src_level = null			where src_level =''
update load_next_msl_unicode set src_ncbi_accessions =null	where src_ncbi_accessions=''
update load_next_msl_unicode set src_abbrevs =null			where src_abbrevs=''
update load_next_msl_unicode set src_out_change =null		where src_out_change=''
update load_next_msl_unicode set dest_in_change =null		where dest_in_change=''
update load_next_msl_unicode set dest_isolates =null		where dest_isolates=''
update load_next_msl_unicode set dest_ncbi_accessions =null where dest_ncbi_accessions=''
update load_next_msl_unicode set dest_abbrevs =null			where dest_abbrevs=''
update load_next_msl_unicode set dest_molecule =null		where dest_molecule=''
update load_next_msl_unicode set dest_level = null			where dest_level =''
update load_next_msl_unicode set dest_is_type = null		where dest_is_type =''
--
-- full column names safer
--
print 'Move rows from [load_next_msl_unicode] >> [load_next_msl]'
--INSERT INTO [load_next_msl] SELECT * FROM [load_next_msl_unicode]
INSERT INTO [dbo].[load_next_msl]
           ([src_tree_id]
           ,[src_msl_release_num]
           ,[src_left_idx]
           ,[src_taxnode_id]
           ,[src_ictv_id]
           ,[src_is_hidden]
           ,[src_lineage]
           ,[src_level]
           ,[src_name]
           ,[src_is_type]
           ,[src_isolates]
           ,[src_ncbi_accessions]
           ,[src_abbrevs]
           ,[src_molecule]
           ,[dest_in_change]
           ,[src_out_change]
           ,[dest_target]
           ,[orig_ref_filename]
           ,[ref_filename]
           ,[ref_notes]
           ,[ref_problems]
           ,[dest_level]
           ,[dest_is_type]
           ,[dest_is_hidden]
           ,[dest_isolates]
           ,[dest_ncbi_accessions]
           ,[dest_abbrevs]
           ,[dest_molecule]
           ,[dest_msl_release_num]
           ,[dest_tree_id]
           ,[dest_taxnode_id]
           ,[edit_comments])
SELECT [src_tree_id]
      ,[src_msl_release_num]
      ,[src_left_idx]
      ,[src_taxnode_id]
      ,[src_ictv_id]
      ,[src_is_hidden]
      ,[src_lineage]
      ,[src_level]
      ,[src_name]
      ,[src_is_type]
      ,[src_isolates]
      ,[src_ncbi_accessions]
      ,[src_abbrevs]
      ,[src_molecule]
      ,[dest_in_change]
      ,[src_out_change]
      ,[dest_target name or lineage with ;'s]
      ,[old_ref_filename]
      ,[ref_filename]
      ,[ref_notes]
      ,[ref_problems]
      ,[dest_level]
      ,[dest_is_type]
      ,[dest_is_hidden]
      ,[dest_isolates]
      ,[dest_ncbi_accessions]
      ,[dest_Abbrevs]
      ,[dest_molecule]
      ,[dest_ msl_release_num]
      ,[dest_ tree_id]
      ,[dest_ taxnode_id]
      ,[edit_comments Data Entry Notes]
  FROM [dbo].[load_next_msl_unicode]
GO

--DROP TABLE [load_next_msl_unicode]

/* ================================================
 *
 * cleanup load
 *
 * =============================================== */


 PRINT 'remove blank lines'
delete  -- select *
from [load_next_msl] 
where src_name is null 
AND src_lineage is null
AND dest_in_change is null
AND src_out_change is null
AND dest_target is null