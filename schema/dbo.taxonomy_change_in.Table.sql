USE [ICTVonlnie34]
GO
/****** Object:  Table [dbo].[taxonomy_change_in]    Script Date: 4/24/2020 3:40:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[taxonomy_change_in](
	[change] [varchar](10) NOT NULL,
	[notes] [text] NULL,
 CONSTRAINT [PK_taxonomy_in_change] PRIMARY KEY CLUSTERED 
(
	[change] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
