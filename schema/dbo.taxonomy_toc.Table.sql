USE [ICTVonlnie34]
GO
/****** Object:  Table [dbo].[taxonomy_toc]    Script Date: 4/24/2020 3:40:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[taxonomy_toc](
	[tree_id] [int] NOT NULL,
	[msl_release_num] [int] NULL,
 CONSTRAINT [IX_taxonomy_toc-tree_id] UNIQUE NONCLUSTERED 
(
	[tree_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [PK_taxonomy_toc] UNIQUE NONCLUSTERED 
(
	[tree_id] ASC,
	[msl_release_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
