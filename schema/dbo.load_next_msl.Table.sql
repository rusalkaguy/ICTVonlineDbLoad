USE [ICTVonline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[load_next_msl](
	[filename] [nvarchar](200) NOT NULL,
	[sort] [float] NULL,
	[isWrong] [nvarchar](500) NULL,
	[proposal_abbrev] [varchar](100) NULL,
	[proposal] [varchar](100) NOT NULL,
	[spreadsheet] [varchar](100) NULL,
	[srcRealm] [varchar](100) NULL,
	[srcSubRealm] [varchar](100) NULL,
	[srcKingdom] [varchar](100) NULL,
	[srcSubkingdom] [varchar](100) NULL,
	[srcPhylum] [varchar](100) NULL,
	[srcSubphylum] [varchar](100) NULL,
	[srcClass] [varchar](100) NULL,
	[srcSubclass] [varchar](100) NULL,
	[srcHigherTaxon] [varchar](100) NULL,
	[srcOrder] [varchar](100) NULL,
	[srcSubOrder] [varchar](100) NULL,
	[srcFamily] [varchar](100) NULL,
	[srcSubfamily] [varchar](100) NULL,
	[srcGenus] [varchar](100) NULL,
	[srcSubGenus] [varchar](100) NULL,
	[srcSpecies] [varchar](100) NULL,
	[empty1] [varchar](1) NULL,
	[realm] [varchar](100) NULL,
	[subrealm] [varchar](100) NULL,
	[kingdom] [varchar](100) NULL,
	[subkingdom] [varchar](100) NULL,
	[phylum] [varchar](100) NULL,
	[subphylum] [varchar](100) NULL,
	[class] [varchar](100) NULL,
	[subclass] [varchar](100) NULL,
	[order] [varchar](100) NULL,
	[suborder] [varchar](100) NULL,
	[family] [varchar](100) NULL,
	[subfamily] [varchar](100) NULL,
	[genus] [varchar](100) NULL,
	[subgenus] [varchar](100) NULL,
	[species] [varchar](100) NULL,
	[isType] [varchar](10) NULL,
	[exemplarAccessions] [varchar](5000) NULL,
	[exemplarRefSeq] [varchar](5000) NULL,
	[exemplarName] [nvarchar](4000) NULL,
	[exemplarIsolate] [nvarchar](500) NULL,
	[isComplete] [varchar](100) NULL,
	[Abbrev] [nvarchar](100) NULL,
	[molecule] [nvarchar](100) NULL,
	[change] [nvarchar](100) NULL,
	[rank] [nvarchar](100) NULL,
	[comments] [nvarchar](1000) NULL,
	[_action] [nvarchar](200) NULL,
	[_src_taxon_name]  AS (Trim(isnull([srcSpecies],isnull([srcSubGenus],isnull([srcGenus],isnull([srcSubFamily],isnull([srcFamily],isnull([srcSubOrder],isnull([srcOrder],isnull([srcSubClass],isnull([srcClass],isnull([srcSubPhylum],isnull([srcPhylum],isnull([srcSubKingdom],isnull([srcKingdom],isnull([srcSubRealm],[srcRealm])))))))))))))))) PERSISTED,
	[_src_taxon_rank]  AS (case when [srcSpecies] IS NOT NULL then 'species' when [srcsubgenus] IS NOT NULL then 'subgenus' when [srcgenus] IS NOT NULL then 'genus' when [srcsubfamily] IS NOT NULL then 'subfamily' when [srcfamily] IS NOT NULL then 'family' when [srcSubOrder] IS NOT NULL then 'suborder' when [srcOrder] IS NOT NULL then 'order' when [srcSubClass] IS NOT NULL then 'subclass' when [srcClass] IS NOT NULL then 'class' when [srcSubPhylum] IS NOT NULL then 'subphylum' when [srcPhylum] IS NOT NULL then 'phylum' when [srcSubKingdom] IS NOT NULL then 'subkingdom' when [srcKingdom] IS NOT NULL then 'kingdom' when [srcSubRealm] IS NOT NULL then 'subrealm' when [srcRealm] IS NOT NULL then 'realm'  end) PERSISTED,
	[_src_lineage]  AS (substring((((((((((((((isnull(';'+[srcRealm],'')+isnull(';'+[srcSubRealm],''))+isnull(';'+[srckingdom],''))+isnull(';'+[srcSubkingdom],''))+isnull(';'+[srcphylum],''))+isnull(';'+[srcsubphylum],''))+isnull(';'+[srcClass],''))+isnull(';'+[srcsubclass],''))+isnull(';'+[srcorder],''))+isnull(';'+[srcsuborder],''))+isnull(';'+[srcfamily],''))+isnull(';'+[srcsubfamily],''))+isnull(';'+[srcgenus],''))+isnull(';'+[srcsubgenus],''))+isnull(';'+[srcspecies],''),(2),(2000))) PERSISTED,
	[_dest_taxon_name]  AS (Trim(isnull([Species],isnull([subGenus],isnull([Genus],isnull([SubFamily],isnull([Family],isnull([subOrder],isnull([order],isnull([subclass],isnull([class],isnull([subphylum],isnull([phylum],isnull([subkingdom],isnull([kingdom],isnull([subrealm],[realm])))))))))))))))) PERSISTED,
	[_dest_taxon_rank]  AS (case when [Species] IS NOT NULL then 'species' when [subgenus] IS NOT NULL then 'subgenus' when [genus] IS NOT NULL then 'genus' when [subfamily] IS NOT NULL then 'subfamily' when [family] IS NOT NULL then 'family' when [suborder] IS NOT NULL then 'suborder' when [order] IS NOT NULL then 'order' when [subclass] IS NOT NULL then 'subclass' when [class] IS NOT NULL then 'class' when [subphylum] IS NOT NULL then 'subphylum' when [phylum] IS NOT NULL then 'phylum' when [subkingdom] IS NOT NULL then 'subkingdom' when [kingdom] IS NOT NULL then 'kingdom' when [subrealm] IS NOT NULL then 'subrealm' when [realm] IS NOT NULL then 'realm'  end) PERSISTED,
	[_dest_lineage]  AS (substring((((((((((((((isnull(';'+[realm],'')+isnull(';'+[subrealm],''))+isnull(';'+[kingdom],''))+isnull(';'+[subkingdom],''))+isnull(';'+[phylum],''))+isnull(';'+[subphylum],''))+isnull(';'+[class],''))+isnull(';'+[subclass],''))+isnull(';'+[order],''))+isnull(';'+[suborder],''))+isnull(';'+[family],''))+isnull(';'+[subfamily],''))+isnull(';'+[genus],''))+isnull(';'+[subgenus],''))+isnull(';'+[species],''),(2),(2000))) PERSISTED,
	[_dest_parent_name]  AS (rtrim(ltrim(reverse(substring(replace(reverse((((((((((((((isnull(';'+[realm],'')+isnull(';'+[subrealm],''))+isnull(';'+[kingdom],''))+isnull(';'+[subkingdom],''))+isnull(';'+[phylum],''))+isnull(';'+[subphylum],''))+isnull(';'+[class],''))+isnull(';'+[subclass],''))+isnull(';'+[order],''))+isnull(';'+[suborder],''))+isnull(';'+[family],''))+isnull(';'+[subfamily],''))+isnull(';'+[genus],''))+isnull(';'+[subgenus],''))+isnull(';'+[species],'')),';',replicate(' ',(1000))),(500),(1500)))))) PERSISTED,
	[prev_taxnode_id] [int] NULL,
	[dest_tree_id] [int] NULL,
	[dest_msl_release_num] [int] NULL,
	[dest_taxnode_id] [int] NULL,
	[dest_ictv_id] [int] NULL,
	[dest_parent_id] [int] NULL,
	[dest_level_id] [int] NULL,
	[isDone] [nvarchar](500) NULL
) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE NONCLUSTERED INDEX [IX_load_next_msl-dest_parent_name] ON [dbo].[load_next_msl]
(
	[_dest_parent_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE NONCLUSTERED INDEX [IX_load_next_msl-dest_taxon_name] ON [dbo].[load_next_msl]
(
	[_dest_taxon_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE NONCLUSTERED INDEX [IX_load_next_msl-src_taxon_name] ON [dbo].[load_next_msl]
(
	[_src_taxon_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[load_next_msl] ADD  CONSTRAINT [DF_load_next_msl__msl_release_num]  DEFAULT ((36)) FOR [dest_msl_release_num]
GO
