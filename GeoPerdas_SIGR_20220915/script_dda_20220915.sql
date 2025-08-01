USE [GEO_SIGR_DDAD_M10]
GO

CREATE SCHEMA [sde]
GO

/****** Object:  Table [sde].[GDB_ITEMRELATIONSHIPS]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMRELATIONSHIPS](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Type] [uniqueidentifier] NOT NULL,
	[OriginID] [uniqueidentifier] NOT NULL,
	[DestID] [uniqueidentifier] NOT NULL,
	[Properties] [int] NULL,
	[Attributes] [xml] NULL,
 CONSTRAINT [R3_pk] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_ITEMRELATIONSHIPTYPES]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMRELATIONSHIPTYPES](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NOT NULL,
	[ForwardLabel] [nvarchar](226) NULL,
	[BackwardLabel] [nvarchar](226) NULL,
	[OrigItemTypeID] [uniqueidentifier] NOT NULL,
	[DestItemTypeID] [uniqueidentifier] NOT NULL,
	[IsContainment] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_ITEMS]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[GDB_ITEMS](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Type] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NULL,
	[PhysicalName] [nvarchar](226) NULL,
	[Path] [nvarchar](512) NULL,
	[Url] [nvarchar](255) NULL,
	[Properties] [int] NULL,
	[Defaults] [varbinary](max) NULL,
	[DatasetSubtype1] [int] NULL,
	[DatasetSubtype2] [int] NULL,
	[DatasetInfo1] [nvarchar](255) NULL,
	[DatasetInfo2] [nvarchar](255) NULL,
	[Definition] [xml] NULL,
	[Documentation] [xml] NULL,
	[ItemInfo] [xml] NULL,
	[Shape] [geometry] NULL,
 CONSTRAINT [R2_pk] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[GDB_ITEMTYPES]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_ITEMTYPES](
	[ObjectID] [int] NOT NULL,
	[UUID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](226) NOT NULL,
	[ParentTypeID] [uniqueidentifier] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_REPLICALOG]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_REPLICALOG](
	[ID] [int] NOT NULL,
	[ReplicaID] [int] NOT NULL,
	[Event] [int] NOT NULL,
	[ErrorCode] [int] NOT NULL,
	[LogDate] [datetime2](7) NOT NULL,
	[SourceBeginGen] [int] NOT NULL,
	[SourceEndGen] [int] NOT NULL,
	[TargetGen] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[GDB_TABLES_LAST_MODIFIED]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[GDB_TABLES_LAST_MODIFIED](
	[table_name] [nvarchar](160) NOT NULL,
	[last_modified_count] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i2]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i2](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i2_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i3]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i3](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i3_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i4]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i4](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i4_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i45]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i45](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i45_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i46]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i46](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i46_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i47]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i47](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i47_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i48]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i48](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i48_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i49]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i49](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i49_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i5]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i5](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i5_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i50]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i50](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i50_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i51]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i51](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i51_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i52]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i52](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i52_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i53]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i53](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i53_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i54]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i54](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i54_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i55]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i55](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i55_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i56]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i56](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i56_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i57]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i57](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i57_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i58]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i58](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i58_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i59]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i59](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i59_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i6]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i6](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i6_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i60]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i60](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i60_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i61]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i61](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i61_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i62]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i62](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i62_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i63]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i63](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i63_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i64]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i64](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i64_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i65]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i65](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i65_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i66]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i66](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i66_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i67]    Script Date: 15/09/2022 09:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i67](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i67_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i68]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i68](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i68_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i69]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i69](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i69_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i70]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i70](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i70_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i71]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i71](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i71_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i72]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i72](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i72_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i73]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i73](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i73_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i74]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i74](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i74_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i75]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i75](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i75_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i76]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i76](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i76_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i77]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i77](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i77_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i78]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i78](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i78_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i79]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i79](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i79_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i80]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i80](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i80_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i81]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i81](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i81_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i82]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i82](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i82_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i83]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i83](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i83_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i84]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i84](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i84_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i85]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i85](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i85_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i86]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i86](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i86_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[i87]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[i87](
	[id_type] [int] NOT NULL,
	[base_id] [int] NOT NULL,
	[num_ids] [int] NOT NULL,
	[last_id] [int] NULL,
 CONSTRAINT [i87_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC,
	[num_ids] ASC,
	[base_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_archives]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_archives](
	[archiving_regid] [int] NOT NULL,
	[history_regid] [int] NOT NULL,
	[from_date] [nvarchar](32) NOT NULL,
	[to_date] [nvarchar](32) NOT NULL,
	[archive_date] [bigint] NOT NULL,
	[archive_flags] [bigint] NOT NULL,
 CONSTRAINT [archives_pk] PRIMARY KEY CLUSTERED 
(
	[archiving_regid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_column_registry]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_column_registry](
	[database_name] [nvarchar](32) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[column_name] [nvarchar](32) NOT NULL,
	[sde_type] [int] NOT NULL,
	[column_size] [int] NULL,
	[decimal_digits] [int] NULL,
	[description] [nvarchar](65) NULL,
	[object_flags] [int] NOT NULL,
	[object_id] [int] NULL,
 CONSTRAINT [colregistry_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[table_name] ASC,
	[owner] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_dbtune]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_dbtune](
	[keyword] [nvarchar](32) NOT NULL,
	[parameter_name] [nvarchar](32) NOT NULL,
	[config_string] [nvarchar](2048) NULL,
 CONSTRAINT [dbtune_pk] PRIMARY KEY CLUSTERED 
(
	[keyword] ASC,
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_geometry_columns]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_geometry_columns](
	[f_table_catalog] [nvarchar](32) NOT NULL,
	[f_table_schema] [nvarchar](32) NOT NULL,
	[f_table_name] [sysname] NOT NULL,
	[f_geometry_column] [nvarchar](32) NOT NULL,
	[g_table_catalog] [nvarchar](32) NULL,
	[g_table_schema] [nvarchar](32) NOT NULL,
	[g_table_name] [sysname] NOT NULL,
	[storage_type] [int] NULL,
	[geometry_type] [int] NULL,
	[coord_dimension] [int] NULL,
	[max_ppr] [int] NULL,
	[srid] [int] NOT NULL,
 CONSTRAINT [geocol_pk] PRIMARY KEY CLUSTERED 
(
	[f_table_catalog] ASC,
	[f_table_schema] ASC,
	[f_table_name] ASC,
	[f_geometry_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_GEOMETRY1]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_GEOMETRY1](
	[GEOMETRY_ID] [int] NOT NULL,
	[CAD] [varbinary](max) NULL,
 CONSTRAINT [geom1_idx] PRIMARY KEY CLUSTERED 
(
	[GEOMETRY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_layer_locks]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_layer_locks](
	[sde_id] [int] NOT NULL,
	[layer_id] [int] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
	[minx] [bigint] NULL,
	[miny] [bigint] NULL,
	[maxx] [bigint] NULL,
	[maxy] [bigint] NULL,
 CONSTRAINT [layer_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[layer_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_layer_stats]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_layer_stats](
	[oid] [int] IDENTITY(1,1) NOT NULL,
	[layer_id] [int] NOT NULL,
	[version_id] [int] NULL,
	[minx] [float] NOT NULL,
	[miny] [float] NOT NULL,
	[maxx] [float] NOT NULL,
	[maxy] [float] NOT NULL,
	[minz] [float] NULL,
	[minm] [float] NULL,
	[maxz] [float] NULL,
	[maxm] [float] NULL,
	[total_features] [int] NOT NULL,
	[total_points] [int] NOT NULL,
	[last_analyzed] [datetime] NOT NULL,
 CONSTRAINT [sdelayer_stats_pk] PRIMARY KEY CLUSTERED 
(
	[oid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_layers]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_layers](
	[layer_id] [int] NOT NULL,
	[description] [nvarchar](65) NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](128) NOT NULL,
	[spatial_column] [nvarchar](128) NOT NULL,
	[eflags] [int] NOT NULL,
	[layer_mask] [int] NOT NULL,
	[gsize1] [float] NOT NULL,
	[gsize2] [float] NOT NULL,
	[gsize3] [float] NOT NULL,
	[minx] [float] NOT NULL,
	[miny] [float] NOT NULL,
	[maxx] [float] NOT NULL,
	[maxy] [float] NOT NULL,
	[minz] [float] NULL,
	[maxz] [float] NULL,
	[minm] [float] NULL,
	[maxm] [float] NULL,
	[cdate] [int] NOT NULL,
	[layer_config] [nvarchar](32) NULL,
	[optimal_array_size] [int] NULL,
	[stats_date] [int] NULL,
	[minimum_id] [int] NULL,
	[srid] [int] NOT NULL,
	[base_layer_id] [int] NOT NULL,
	[secondary_srid] [int] NULL,
 CONSTRAINT [layers_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[table_name] ASC,
	[owner] ASC,
	[spatial_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_lineages_modified]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_lineages_modified](
	[lineage_name] [bigint] NOT NULL,
	[time_last_modified] [datetime] NOT NULL,
 CONSTRAINT [lineages_mod_pk] PRIMARY KEY CLUSTERED 
(
	[lineage_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_locators]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_locators](
	[locator_id] [int] NOT NULL,
	[name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[category] [nvarchar](32) NOT NULL,
	[type] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
 CONSTRAINT [sdelocators_pk] PRIMARY KEY CLUSTERED 
(
	[locator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_logfile_pool]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_logfile_pool](
	[table_id] [int] NOT NULL,
	[sde_id] [int] NULL,
 CONSTRAINT [logfile_pool_pk] PRIMARY KEY CLUSTERED 
(
	[table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_metadata]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_metadata](
	[record_id] [int] NOT NULL,
	[object_database] [nvarchar](32) NULL,
	[object_name] [nvarchar](160) NOT NULL,
	[object_owner] [nvarchar](32) NOT NULL,
	[object_type] [int] NOT NULL,
	[class_name] [nvarchar](32) NULL,
	[property] [nvarchar](32) NULL,
	[prop_value] [nvarchar](255) NULL,
	[description] [nvarchar](65) NULL,
	[creation_date] [datetime] NOT NULL,
 CONSTRAINT [sdemetadata_pk] PRIMARY KEY CLUSTERED 
(
	[record_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_mvtables_modified]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_mvtables_modified](
	[state_id] [bigint] NOT NULL,
	[registration_id] [int] NOT NULL,
 CONSTRAINT [mvtables_modified_pk] PRIMARY KEY CLUSTERED 
(
	[state_id] ASC,
	[registration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_object_ids]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_object_ids](
	[id_type] [int] NOT NULL,
	[base_id] [bigint] NOT NULL,
	[object_type] [varchar](30) NOT NULL,
 CONSTRAINT [object_ids_pk] PRIMARY KEY CLUSTERED 
(
	[id_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_object_locks]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_object_locks](
	[sde_id] [int] NOT NULL,
	[object_id] [int] NOT NULL,
	[object_type] [int] NOT NULL,
	[application_id] [int] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [object_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[object_id] ASC,
	[object_type] ASC,
	[application_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_process_information]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_process_information](
	[sde_id] [int] NOT NULL,
	[spid] [int] NOT NULL,
	[server_id] [int] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[rcount] [int] NOT NULL,
	[wcount] [int] NOT NULL,
	[opcount] [int] NOT NULL,
	[numlocks] [int] NOT NULL,
	[fb_partial] [int] NOT NULL,
	[fb_count] [int] NOT NULL,
	[fb_fcount] [int] NOT NULL,
	[fb_kbytes] [int] NOT NULL,
	[owner] [nvarchar](30) NOT NULL,
	[direct_connect] [varchar](1) NOT NULL,
	[sysname] [nvarchar](32) NOT NULL,
	[nodename] [nvarchar](256) NOT NULL,
	[xdr_needed] [varchar](1) NOT NULL,
	[table_name] [nvarchar](95) NOT NULL,
 CONSTRAINT [process_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_raster_columns]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_raster_columns](
	[rastercolumn_id] [int] NOT NULL,
	[description] [nvarchar](65) NULL,
	[database_name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[table_name] [sysname] NOT NULL,
	[raster_column] [nvarchar](32) NOT NULL,
	[cdate] [int] NOT NULL,
	[config_keyword] [nvarchar](32) NULL,
	[minimum_id] [int] NULL,
	[base_rastercolumn_id] [int] NOT NULL,
	[rastercolumn_mask] [int] NOT NULL,
	[srid] [int] NULL,
 CONSTRAINT [rascol_pk] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC,
	[owner] ASC,
	[table_name] ASC,
	[raster_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_server_config]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_server_config](
	[prop_name] [nvarchar](32) NOT NULL,
	[char_prop_value] [nvarchar](512) NULL,
	[num_prop_value] [int] NULL,
 CONSTRAINT [server_config_pk] PRIMARY KEY CLUSTERED 
(
	[prop_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_spatial_references]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_spatial_references](
	[srid] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
	[auth_name] [nvarchar](255) NULL,
	[auth_srid] [int] NULL,
	[falsex] [float] NOT NULL,
	[falsey] [float] NOT NULL,
	[xyunits] [float] NOT NULL,
	[falsez] [float] NOT NULL,
	[zunits] [float] NOT NULL,
	[falsem] [float] NOT NULL,
	[munits] [float] NOT NULL,
	[xycluster_tol] [float] NULL,
	[zcluster_tol] [float] NULL,
	[mcluster_tol] [float] NULL,
	[object_flags] [int] NOT NULL,
	[srtext] [varchar](1024) NOT NULL,
 CONSTRAINT [spatial_ref_pk] PRIMARY KEY CLUSTERED 
(
	[srid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_state_lineages]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_state_lineages](
	[lineage_name] [bigint] NOT NULL,
	[lineage_id] [bigint] NOT NULL,
 CONSTRAINT [state_lineages_pk] PRIMARY KEY CLUSTERED 
(
	[lineage_name] ASC,
	[lineage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_state_locks]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_state_locks](
	[sde_id] [int] NOT NULL,
	[state_id] [bigint] NOT NULL,
	[autolock] [char](1) NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [state_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[state_id] ASC,
	[autolock] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_states]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_states](
	[state_id] [bigint] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[creation_time] [datetime] NOT NULL,
	[closing_time] [datetime] NULL,
	[parent_state_id] [bigint] NOT NULL,
	[lineage_name] [bigint] NOT NULL,
 CONSTRAINT [states_pk] PRIMARY KEY CLUSTERED 
(
	[state_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_table_locks]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [sde].[SDE_table_locks](
	[sde_id] [int] NOT NULL,
	[registration_id] [int] NOT NULL,
	[lock_type] [char](1) NOT NULL,
	[lock_time] [datetime] NOT NULL,
 CONSTRAINT [table_locks_pk] PRIMARY KEY CLUSTERED 
(
	[sde_id] ASC,
	[registration_id] ASC,
	[lock_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [sde].[SDE_table_registry]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_table_registry](
	[registration_id] [int] NOT NULL,
	[database_name] [nvarchar](32) NULL,
	[table_name] [sysname] NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[rowid_column] [nvarchar](32) NULL,
	[description] [nvarchar](65) NULL,
	[object_flags] [int] NOT NULL,
	[registration_date] [int] NOT NULL,
	[config_keyword] [nvarchar](32) NULL,
	[minimum_id] [int] NULL,
	[imv_view_name] [nvarchar](128) NULL,
 CONSTRAINT [registry_pk] PRIMARY KEY CLUSTERED 
(
	[registration_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_tables_modified]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_tables_modified](
	[table_name] [sysname] NOT NULL,
	[time_last_modified] [datetime] NOT NULL,
 CONSTRAINT [tables_modified_pk] PRIMARY KEY CLUSTERED 
(
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_version]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_version](
	[MAJOR] [int] NOT NULL,
	[MINOR] [int] NOT NULL,
	[BUGFIX] [int] NOT NULL,
	[DESCRIPTION] [nvarchar](96) NOT NULL,
	[RELEASE] [int] NOT NULL,
	[SDESVR_REL_LOW] [int] NOT NULL,
 CONSTRAINT [version_pk] PRIMARY KEY CLUSTERED 
(
	[MAJOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_versions]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_versions](
	[name] [nvarchar](64) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[version_id] [int] NOT NULL,
	[status] [int] NOT NULL,
	[state_id] [bigint] NOT NULL,
	[description] [nvarchar](64) NULL,
	[parent_name] [nvarchar](64) NULL,
	[parent_owner] [nvarchar](32) NULL,
	[parent_version_id] [int] NULL,
	[creation_time] [datetime] NOT NULL,
 CONSTRAINT [versions_pk] PRIMARY KEY CLUSTERED 
(
	[version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_columns]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_columns](
	[column_id] [int] IDENTITY(1,1) NOT NULL,
	[registration_id] [int] NOT NULL,
	[column_name] [nvarchar](32) NOT NULL,
	[index_id] [int] NULL,
	[minimum_id] [int] NULL,
	[config_keyword] [nvarchar](32) NULL,
	[xflags] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_index_tags]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_index_tags](
	[index_id] [int] NOT NULL,
	[tag_id] [int] IDENTITY(1,1) NOT NULL,
	[tag_name] [nvarchar](1024) NOT NULL,
	[data_type] [int] NOT NULL,
	[tag_alias] [int] NULL,
	[description] [nvarchar](64) NULL,
	[is_excluded] [int] NOT NULL,
 CONSTRAINT [xml_indextags_pk] PRIMARY KEY CLUSTERED 
(
	[index_id] ASC,
	[tag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[SDE_xml_indexes]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[SDE_xml_indexes](
	[index_id] [int] IDENTITY(1,1) NOT NULL,
	[index_name] [nvarchar](32) NOT NULL,
	[owner] [nvarchar](32) NOT NULL,
	[index_type] [int] NOT NULL,
	[description] [nvarchar](64) NULL,
 CONSTRAINT [xml_indexes_pk] PRIMARY KEY CLUSTERED 
(
	[index_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TALCPRD]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TALCPRD](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TARE]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TARE](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCABOBIT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCABOBIT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCABOFOR]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCABOFOR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCABOGEOM]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCABOGEOM](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCABOISO]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCABOISO](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCABOMAT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCABOMAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCAPELFU]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCAPELFU](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](5) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCATPT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCATPT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](6) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCLASUBCLA]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCLASUBCLA](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](4) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCLATEN]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCLATEN](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[TEN] [int] NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCONFIG]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCONFIG](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TCOR]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TCOR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[CORR] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TDIACRV]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TDIACRV](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NULL,
	[DESCR] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TESTALT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TESTALT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[ALT] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TESTESF]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TESTESF](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[ESF] [smallint] NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TESTMAT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TESTMAT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TESTR]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TESTR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TFASCON]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TFASCON](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](4) NOT NULL,
	[QUANT_FIOS] [smallint] NULL,
	[FASES] [smallint] NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TGRUTAR]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TGRUTAR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](4) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TGRUTEN]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TGRUTEN](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TINST]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TINST](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](15) NULL,
	[DESCR] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TLIG]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TLIG](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TMEIISO]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TMEIISO](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TNOROPE]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TNOROPE](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TORGENER]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TORGENER](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPIP]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPIP](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NULL,
	[DESCR] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPONNOT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPONNOT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPOS]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPOS](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPOSTOTRAN]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPOSTOTRAN](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPOTAPRT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPOTAPRT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[POT] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TPOTRTV]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TPOTRTV](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[POT] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TREGU]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TREGU](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TRELTC]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TRELTC](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TRELTP]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TRELTP](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TRESREGUL]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TRESREGUL](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](15) NULL,
	[RES_REGUL] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TSITATI]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TSITATI](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TSITCONT]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TSITCONT](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TSUBGRP]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TSUBGRP](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TTEN]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TTEN](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[TEN] [numeric](38, 8) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TTRANF]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TTRANF](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](2) NOT NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TUAR]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TUAR](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](6) NULL,
	[TIPO] [nvarchar](17) NULL,
	[ENTIDADE] [nvarchar](14) NULL,
	[DESCR] [nvarchar](254) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [sde].[TUNI]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [sde].[TUNI](
	[OBJECTID] [int] NOT NULL,
	[COD_ID] [nvarchar](3) NOT NULL,
	[UNIDADE] [nvarchar](255) NULL,
	[DESCR] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  View [sde].[dbtune]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [sde].[dbtune] as select * from GEO_SIGR_DDAD_M10.sde.SDE_dbtune
GO
/****** Object:  View [sde].[SDE_generate_guid]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[SDE_generate_guid] AS 
 SELECT '{' + CONVERT(NVARCHAR(36),newid()) + '}' as guidstr 

GO
/****** Object:  View [sde].[ST_GEOMETRY_COLUMNS]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[ST_GEOMETRY_COLUMNS] (table_schema, table_name,       column_name, type_schema, type_name,  srs_id) AS        SELECT f_table_schema, f_table_name, f_geometry_column,'dbo',       CASE geometry_type        WHEN 0 THEN 'ST_GEOMETRY'        WHEN 1 THEN 'ST_POINT'        WHEN 2 THEN 'ST_CURVE'        WHEN 3 THEN 'ST_LINESTRING'        WHEN 4 THEN 'ST_SURFACE'        WHEN 5 THEN 'ST_POLYGON'        WHEN 6 THEN 'ST_COLLECTION'        WHEN 7 THEN 'ST_MULTIPOINT'        WHEN 8 THEN 'ST_MULTICURVE'        WHEN 9 THEN 'ST_MULTISTRING'        WHEN 10 THEN 'ST_MULTISURFACE'        WHEN 11 THEN 'ST_MULTIPOLYGON'        ELSE 'ST_GEOMETRY'        END,        srid FROM GEO_SIGR_DDAD_M10.sde.SDE_geometry_columns g
GO
/****** Object:  View [sde].[ST_SPATIAL_REFERENCE_SYSTEMS]    Script Date: 15/09/2022 09:36:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [sde].[ST_SPATIAL_REFERENCE_SYSTEMS] (srs_id, x_offset,       x_scale, y_offset, y_scale, z_offset, z_scale, m_offset,        m_scale, organization,organization_coordsys_id, definition)       AS SELECT srid, falsex, xyunits, falsey, xyunits,       falsez, zunits, falsem, munits,        auth_name, auth_srid, srtext  FROM       GEO_SIGR_DDAD_M10.sde.SDE_spatial_references 
GO
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (39, N'86be548f-a4a6-4eb4-9c0c-228f2208f842', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'96be8f2d-0b0e-4ee7-ad09-b1f211937ac2', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (40, N'91163469-7f79-4b5b-849b-344eae37d62d', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'4c1a0019-b93d-45b2-aa46-e9de27d9fdfb', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (41, N'd670d669-ec51-4ff6-af1d-9b82eb65d050', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'84d1d3a4-e998-4998-a6ac-8f8f58cc0237', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (42, N'9ca91f1b-51b3-4b9f-af4c-73b7f64b892c', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'b8c32ecc-a37f-4eb8-8264-906cbe223d50', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (43, N'e9fe6cf9-e19c-489b-9a7d-01d60a238dd9', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'a8606f04-bd3b-48da-95ba-05585d2b3da1', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (44, N'acd52b26-fe39-420a-89ad-96b1310cc588', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'379c84c9-9158-4511-8293-f883ba5a895c', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (45, N'8b70a7e3-86bf-44e1-b7db-7bed0a92cbee', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'5cb61a63-a672-448e-bacf-dafeea0c3347', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (46, N'7287f673-c3f5-4e75-af0d-645f80a9a5a8', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'594a30fb-b455-4c0d-b17c-8155ffc35c97', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (47, N'b6d2d648-ebb4-4661-9fe9-fc9a5b60832d', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'd31a055c-d6d5-4544-a46c-c62e3a556f9e', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (48, N'680747da-c1ff-4d07-9ffa-bc63f53daf19', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'862b4177-ef57-4546-8c44-d34258ebe140', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (49, N'5caa04d8-ec1b-4489-be50-3135a286e26a', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'fc75950a-305b-4b78-80d7-8c7d59612ec2', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (50, N'c0345a70-abec-4b7a-be97-85aefc92cf2d', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'600d525b-0d8b-43cf-be32-b9ceebdca609', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (51, N'71937f0a-d944-4597-9865-7e7718147b54', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'51147c2c-5e49-4bfa-b05e-f97641415cf6', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (52, N'78fa201c-0e13-4d5b-8684-a06319061ce5', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'8ac36e64-5732-4b3c-b8e1-e6dc11e6db27', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (53, N'cf943bd8-e905-44a3-ba33-7a7c814e2542', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'4910a7c4-3503-4a1f-9a45-54820b67d760', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (54, N'bb07eea7-68c3-4a14-9442-a0c5cd483ec3', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'45efaa7e-f0ae-4b3d-b01f-ecde7f093877', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (55, N'1ee0a4f6-bb77-4258-a013-b4249bcb181f', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'af341d6c-4edc-4233-8dac-108d4c63b5f2', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (56, N'd99e00e8-1c39-4ed3-b237-e829526d7727', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'135a5753-dcf2-42b8-a4ac-d08f5c24c501', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (57, N'9d5f3a90-382c-48b1-897f-6dc29510e9ad', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'd8554d83-4f75-4fbd-a935-b84b4bf988cd', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (58, N'543107f5-3b23-41a5-b6df-29267da51c50', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'ab6ba2fa-56c2-438e-962f-401a6b6e9ef4', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (59, N'2f024414-c391-4f0f-a0d0-1111c65b02ed', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'a0e06e8d-f779-484c-8a8c-10be48136c4e', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (60, N'7a45db5f-da2b-47cd-a318-16e8ba484e88', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'0ce41031-273a-4229-a564-cfb5e4fa7bb5', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (61, N'2841b160-2789-4a7c-9cac-db8c772f888b', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'd7d6a237-a31e-4bd9-b3b1-04331eccf05e', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (62, N'3d68252d-a00e-431d-9c00-1c8d92a7a1bf', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'91e975e6-ffa5-4581-beb5-7e919aa10d9c', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (63, N'02a11572-78ce-4cf8-b994-74a5b253977e', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'3d8879d4-e11e-4a85-85e7-9d78ff26f676', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (64, N'deeb6ae7-99a3-4e86-877a-6a44a250518b', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'7fba925b-ae43-45df-ada5-b98cefab67b5', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (65, N'f1b9803b-2f90-4d9c-82b5-8aad68b55649', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'd743ae99-076b-418b-babb-9be3f895bed5', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (66, N'd21efd4b-2bcb-4314-b849-2600bd6ee984', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'f2c7c318-f038-447a-8e39-4f600a06a3d1', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (67, N'e9fbb11c-175f-412e-9165-afa33693675e', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'0e1848c7-60e5-4eff-af7c-9a32174f95ea', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (68, N'0417501b-83e4-449d-9224-efac6732f4e6', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'8efabbc5-e283-43b9-9489-4a3cb114a74a', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (69, N'61f850c8-d450-4df0-ac33-2a377b4b6fb4', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'0e214636-4e30-4632-93fb-e35602e33d4c', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (70, N'731ac8d6-0bf8-4e33-97aa-e5ba444faa3c', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'dc87b152-b512-49ce-8e40-0c4e3e934aed', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (71, N'b7b5778f-6ad6-4a0c-978f-bf20363ca9a2', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'b2bb7f91-8a4d-4998-834a-3b43ca286c8b', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (72, N'9ac95c40-2598-469e-825e-0152e13e1b00', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'585024cd-a587-40a5-81fa-9a2a38199f9b', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (73, N'eb6064e6-9269-42be-b49e-67a17aecf604', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'f8bfd7a9-2d33-4f91-a9a8-f923212aa751', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (74, N'5a1b1985-2033-4a34-8457-0779aa9afc2b', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'6465da6b-d718-4938-89f8-c12a3ee2aec4', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (75, N'84c99040-de3a-4971-930a-f555c93945a4', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'10bf19e4-ddc1-47aa-8527-7b510a7a8f47', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (76, N'417a92e4-7f2d-4900-9c37-143ee1daf06f', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'422050d3-4878-480d-9b4c-ae4e4a04574f', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (77, N'933bc320-a9c7-4707-8d57-575e7d7861a6', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'29265bf8-4746-40f8-b52d-80df84c201b8', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (78, N'5fe40961-e00e-4f4d-a604-ff5c2c447c4a', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'b3475c58-b010-4921-b71c-58a72f8185a3', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (79, N'519c5403-2b4c-4484-b976-ce012a3d95ef', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'401dbaab-23b8-4663-83e2-60c411758a1b', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (80, N'b0918330-4a0a-4909-b4f6-fe6f629e0167', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'0a48609a-a6a4-4f90-b65e-7fdb925fb477', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPS] ([ObjectID], [UUID], [Type], [OriginID], [DestID], [Properties], [Attributes]) VALUES (81, N'd989bc89-41e7-44b6-bdb2-460e9229af2c', N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'027c9d75-5f48-49ee-a61b-49e4f45e3cf1', 1, NULL)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (8, N'dc739a70-9b71-41e8-868c-008cf46f16d7', N'FeatureClassInGeometricNetwork', N'Spatially Manages Feature Class', N'Participates In Geometric Network', N'73718a66-afb9-4b88-a551-cffa0ae12620', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (9, N'b32b8563-0b96-4d32-92c4-086423ae9962', N'FeatureClassInNetworkDataset', N'Spatially Manages Feature Class', N'Participates In Network Dataset', N'7771fc7d-a38b-4fd3-8225-639d17e9a131', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (11, N'583a5baa-3551-41ae-8aa8-1185719f3889', N'FeatureClassInParcelFabric', N'Spatially Manages Feature Class', N'Participates In Parcel Fabric', N'a3803369-5fc2-4963-bae0-13effc09dd73', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (18, N'95c22afd-aa36-431d-b195-1779a256c6b2', N'FeatureClassInUtilityNetwork', N'Spatially Manages Feature Class', N'Participates In Utility Network', N'37672bd2-b9f3-48c1-89b5-8c43bbbb6d57', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (4, N'dc78f1ab-34e4-43ac-ba47-1c4eabd0e7c7', N'DatasetInFolder', N'Contains Dataset', N'Contained in Dataset', N'f3783e6f-65ca-4514-8315-ce3985dad3b1', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (1, N'0d10b3a7-2f64-45e6-b7ac-2fc27bf2133c', N'FolderInFolder', N'Parent Folder Of', N'Child Folder Of', N'f3783e6f-65ca-4514-8315-ce3985dad3b1', N'f3783e6f-65ca-4514-8315-ce3985dad3b1', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (12, N'5f9085e0-788f-4354-ae3c-34c83a7ea784', N'TableInParcelFabric', N'Manages Table', N'Participates In Parcel Fabric', N'a3803369-5fc2-4963-bae0-13effc09dd73', N'cd06bc3b-789d-4c51-aafa-a467912b8965', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (13, N'e79b44e3-f833-4b12-90a1-364ec4ddc43e', N'RepresentationOfFeatureClass', N'Feature Class Representation', N'Represented Feature Class', N'70737809-852c-4a03-9e22-2cecea5b9bfa', N'a300008d-0cea-4f6a-9dfa-46af829a3df2', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (14, N'8db31af1-df7c-4632-aa10-3cc44b0c6914', N'ReplicaDatasetInReplica', N'Replicated Dataset', N'Participates In Replica', N'4ed4a58e-621f-4043-95ed-850fba45fcbc', N'd98421eb-d582-4713-9484-43304d0810f6', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (16, N'cc28387c-441f-4d7c-a802-41a160317fe0', N'SyncDatasetInSyncReplica', N'Sync Dataset', N'Participates In Sync Replica', N'5b966567-fb87-4dde-938b-b4b37423539d', N'd86502f9-9758-45c6-9d23-6dd1a0107b47', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (10, N'55d2f4dc-cb17-4e32-a8c7-47591e8c71de', N'FeatureClassInTerrain', N'Spatially Manages Feature Class', N'Participates In Terrain', N'76357537-3364-48af-a4be-783c7c28b5cb', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (6, N'725badab-3452-491b-a795-55f32d67229c', N'DatasetsRelatedThrough', N'Origin Of', N'Destination Of', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (24, N'20d1f656-14ba-44cb-9a60-58d2d44f7a83', N'FeatureClassInLocationReferencingDataset', N'Spatially Manages Feature Class', N'Participates In Location Referencing Dataset', N'cc53cc54-4cca-43b7-9a9b-64dc59c999bd', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (15, N'd022de33-45bd-424c-88bf-5b1b6b957bd3', N'DatasetOfReplicaDataset', N'Replicated Dataset', N'Dataset of Replicated Dataset', N'd98421eb-d582-4713-9484-43304d0810f6', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (20, N'94cd4fc6-307e-430b-a883-5fe68cf19ae8', N'FeatureClassInTraceNetwork', N'Spatially Manages Feature Class', N'Participates In Trace Network', N'60ea40cf-2667-45e2-bdff-7f6892538fe8', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (7, N'd088b110-190b-4229-bdf7-89fddd14d1ea', N'FeatureClassInTopology', N'Spatially Manages Feature Class', N'Participates In Topology', N'767152d3-ed66-4325-8774-420d46674e07', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (23, N'7d2a7a69-abd8-4aa7-ac08-9e4ddb86289e', N'TableInParcelDataset', N'Manages Table', N'Participates In Parcel Dataset', N'ebeee2c9-fa73-4bed-ac7d-aee7d68afc80', N'cd06bc3b-789d-4c51-aafa-a467912b8965', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (17, N'79cc71c8-b7d9-4141-9014-b6373e236abb', N'DatasetOfSyncDataset', N'Replicated Dataset', N'Dataset Of Sync Dataset', N'd86502f9-9758-45c6-9d23-6dd1a0107b47', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (19, N'ccd6e1c9-9238-40d4-843f-c5dafd3d2bde', N'TableInUtilityNetwork', N'Manages Table', N'Participates In Utility Network', N'37672bd2-b9f3-48c1-89b5-8c43bbbb6d57', N'cd06bc3b-789d-4c51-aafa-a467912b8965', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (2, N'5dd0c1af-cb3d-4fea-8c51-cb3ba8d77cdb', N'ItemInFolder', N'Contains Item', N'Contained In Folder', N'f3783e6f-65ca-4514-8315-ce3985dad3b1', N'8405add5-8df8-4227-8fac-3fcade073386', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (21, N'fb166a8c-c09c-4121-9fa7-cb73406e2944', N'TableInTraceNetwork', N'Manages Table', N'Participates In Trace Network', N'60ea40cf-2667-45e2-bdff-7f6892538fe8', N'cd06bc3b-789d-4c51-aafa-a467912b8965', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (22, N'74dac6c1-a6f2-4603-88a8-d09bccfdcf21', N'FeatureClassInParcelDataset', N'Spatially Manages Feature Class', N'Participates In Parcel Dataset', N'ebeee2c9-fa73-4bed-ac7d-aee7d68afc80', N'70737809-852c-4a03-9e22-2cecea5b9bfa', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (3, N'a1633a59-46ba-4448-8706-d8abe2b2b02e', N'DatasetInFeatureDataset', N'Contains Dataset', N'Contained In FeatureDataset', N'74737149-dcb5-4257-8904-b9724e32a530', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', 1)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (5, N'17e08adb-2b31-4dcd-8fdd-df529e88f843', N'DomainInDataset', N'Contains Domain', N'Contained in Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d', N'8637f1ed-8c04-4866-a44a-1cb8288b3c63', 0)
INSERT [sde].[GDB_ITEMRELATIONSHIPTYPES] ([ObjectID], [UUID], [Name], [ForwardLabel], [BackwardLabel], [OrigItemTypeID], [DestItemTypeID], [IsContainment]) VALUES (25, N'6eedddce-64f9-4549-baad-f05a36c205ed', N'TableInLocationReferencingDataset', N'Manages Table', N'Participates In Location Referencing Dataset', N'cc53cc54-4cca-43b7-9a9b-64dc59c999bd', N'cd06bc3b-789d-4c51-aafa-a467912b8965', 0)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (1, N'bf46cb57-df2c-4ec3-b9ab-a0ca877bbb90', N'f3783e6f-65ca-4514-8315-ce3985dad3b1', N'', N'', N'\', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (2, N'61c503b6-3c4a-4a5f-a8de-34bd33dde100', N'c673fe0f-7280-404f-8532-20755dd8fc06', N'Workspace', N'WORKSPACE', N'', NULL, 0, NULL, 1, NULL, NULL, NULL, N'<DEWorkspace xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.0" xsi:type="typens:DEWorkspace"><CatalogPath>\</CatalogPath><Name /><ChildrenExpanded>false</ChildrenExpanded><WorkspaceType>esriRemoteDatabaseWorkspace</WorkspaceType><WorkspaceFactoryProgID /><ConnectionString /><ConnectionInfo xsi:nil="true" /><Domains xsi:type="typens:ArrayOfDomain" /><MajorVersion>3</MajorVersion><MinorVersion>0</MinorVersion><BugfixVersion>0</BugfixVersion></DEWorkspace>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (3, N'368d147e-7e3e-4992-a9e2-a5edec0104b3', N'dc64b6e4-dc0f-43bd-b4f5-f22385dcf055', N'DEFAULT', N'DEFAULT', N'', NULL, 1, NULL, NULL, NULL, NULL, NULL, N'<GPHistoricalMarker xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.1" xsi:type="typens:GPHistoricalMarker"><Name>DEFAULT</Name><TimeStamp xsi:type="xs:dateTime">2019-04-06T02:48:47</TimeStamp></GPHistoricalMarker>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (42, N'96be8f2d-0b0e-4ee7-ad09-b1f211937ac2', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TALCPRD', N'GEO_SIGR_DDAD_M10.SDE.TALCPRD', N'\GEO_SIGR_DDAD_M10.SDE.TALCPRD', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TALCPRD</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TALCPRD</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>42</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (43, N'4c1a0019-b93d-45b2-aa46-e9de27d9fdfb', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TARE', N'GEO_SIGR_DDAD_M10.SDE.TARE', N'\GEO_SIGR_DDAD_M10.SDE.TARE', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TARE</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TARE</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>43</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (44, N'84d1d3a4-e998-4998-a6ac-8f8f58cc0237', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCABOBIT', N'GEO_SIGR_DDAD_M10.SDE.TCABOBIT', N'\GEO_SIGR_DDAD_M10.SDE.TCABOBIT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCABOBIT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCABOBIT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>44</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (45, N'b8c32ecc-a37f-4eb8-8264-906cbe223d50', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCABOFOR', N'GEO_SIGR_DDAD_M10.SDE.TCABOFOR', N'\GEO_SIGR_DDAD_M10.SDE.TCABOFOR', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCABOFOR</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCABOFOR</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>45</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (46, N'a8606f04-bd3b-48da-95ba-05585d2b3da1', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCABOGEOM', N'GEO_SIGR_DDAD_M10.SDE.TCABOGEOM', N'\GEO_SIGR_DDAD_M10.SDE.TCABOGEOM', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCABOGEOM</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCABOGEOM</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>46</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (47, N'379c84c9-9158-4511-8293-f883ba5a895c', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCABOISO', N'GEO_SIGR_DDAD_M10.SDE.TCABOISO', N'\GEO_SIGR_DDAD_M10.SDE.TCABOISO', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCABOISO</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCABOISO</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>47</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (48, N'5cb61a63-a672-448e-bacf-dafeea0c3347', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCABOMAT', N'GEO_SIGR_DDAD_M10.SDE.TCABOMAT', N'\GEO_SIGR_DDAD_M10.SDE.TCABOMAT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCABOMAT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCABOMAT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>48</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (49, N'594a30fb-b455-4c0d-b17c-8155ffc35c97', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCAPELFU', N'GEO_SIGR_DDAD_M10.SDE.TCAPELFU', N'\GEO_SIGR_DDAD_M10.SDE.TCAPELFU', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCAPELFU</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCAPELFU</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>49</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (50, N'd31a055c-d6d5-4544-a46c-c62e3a556f9e', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCATPT', N'GEO_SIGR_DDAD_M10.SDE.TCATPT', N'\GEO_SIGR_DDAD_M10.SDE.TCATPT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCATPT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCATPT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>50</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (51, N'862b4177-ef57-4546-8c44-d34258ebe140', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCLASUBCLA', N'GEO_SIGR_DDAD_M10.SDE.TCLASUBCLA', N'\GEO_SIGR_DDAD_M10.SDE.TCLASUBCLA', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCLASUBCLA</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCLASUBCLA</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>51</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (52, N'fc75950a-305b-4b78-80d7-8c7d59612ec2', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCLATEN', N'GEO_SIGR_DDAD_M10.SDE.TCLATEN', N'\GEO_SIGR_DDAD_M10.SDE.TCLATEN', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCLATEN</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCLATEN</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>52</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (53, N'600d525b-0d8b-43cf-be32-b9ceebdca609', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCONFIG', N'GEO_SIGR_DDAD_M10.SDE.TCONFIG', N'\GEO_SIGR_DDAD_M10.SDE.TCONFIG', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCONFIG</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCONFIG</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>53</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (54, N'51147c2c-5e49-4bfa-b05e-f97641415cf6', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TCOR', N'GEO_SIGR_DDAD_M10.SDE.TCOR', N'\GEO_SIGR_DDAD_M10.SDE.TCOR', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TCOR</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TCOR</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>54</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (55, N'8ac36e64-5732-4b3c-b8e1-e6dc11e6db27', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TDIACRV', N'GEO_SIGR_DDAD_M10.SDE.TDIACRV', N'\GEO_SIGR_DDAD_M10.SDE.TDIACRV', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TDIACRV</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TDIACRV</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>55</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><AliasName>OBJECTID</AliasName><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><DomainFixed>true</DomainFixed><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><AliasName>COD_ID</AliasName><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>DESCR</Name><AliasName>DESCR</AliasName><ModelName>DESCR</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName>Tipo de Dia da Curva</AliasName><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (56, N'4910a7c4-3503-4a1f-9a45-54820b67d760', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TESTALT', N'GEO_SIGR_DDAD_M10.SDE.TESTALT', N'\GEO_SIGR_DDAD_M10.SDE.TESTALT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TESTALT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TESTALT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>56</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (57, N'45efaa7e-f0ae-4b3d-b01f-ecde7f093877', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TESTESF', N'GEO_SIGR_DDAD_M10.SDE.TESTESF', N'\GEO_SIGR_DDAD_M10.SDE.TESTESF', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TESTESF</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TESTESF</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>57</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (58, N'af341d6c-4edc-4233-8dac-108d4c63b5f2', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TESTMAT', N'GEO_SIGR_DDAD_M10.SDE.TESTMAT', N'\GEO_SIGR_DDAD_M10.SDE.TESTMAT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TESTMAT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TESTMAT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>58</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (59, N'135a5753-dcf2-42b8-a4ac-d08f5c24c501', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TESTR', N'GEO_SIGR_DDAD_M10.SDE.TESTR', N'\GEO_SIGR_DDAD_M10.SDE.TESTR', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TESTR</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TESTR</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>59</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (60, N'd8554d83-4f75-4fbd-a935-b84b4bf988cd', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TFASCON', N'GEO_SIGR_DDAD_M10.SDE.TFASCON', N'\GEO_SIGR_DDAD_M10.SDE.TFASCON', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TFASCON</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TFASCON</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>60</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (61, N'ab6ba2fa-56c2-438e-962f-401a6b6e9ef4', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TGRUTAR', N'GEO_SIGR_DDAD_M10.SDE.TGRUTAR', N'\GEO_SIGR_DDAD_M10.SDE.TGRUTAR', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TGRUTAR</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TGRUTAR</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>61</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (62, N'a0e06e8d-f779-484c-8a8c-10be48136c4e', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TGRUTEN', N'GEO_SIGR_DDAD_M10.SDE.TGRUTEN', N'\GEO_SIGR_DDAD_M10.SDE.TGRUTEN', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TGRUTEN</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TGRUTEN</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>62</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (63, N'0ce41031-273a-4229-a564-cfb5e4fa7bb5', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TINST', N'GEO_SIGR_DDAD_M10.SDE.TINST', N'\GEO_SIGR_DDAD_M10.SDE.TINST', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TINST</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TINST</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>63</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><AliasName>OBJECTID</AliasName><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><DomainFixed>true</DomainFixed><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><AliasName>COD_ID</AliasName><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>DESCR</Name><AliasName>DESCR</AliasName><ModelName>DESCR</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName>Tipo de Instalação</AliasName><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (64, N'd7d6a237-a31e-4bd9-b3b1-04331eccf05e', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TLIG', N'GEO_SIGR_DDAD_M10.SDE.TLIG', N'\GEO_SIGR_DDAD_M10.SDE.TLIG', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TLIG</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TLIG</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>64</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (65, N'91e975e6-ffa5-4581-beb5-7e919aa10d9c', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TMEIISO', N'GEO_SIGR_DDAD_M10.SDE.TMEIISO', N'\GEO_SIGR_DDAD_M10.SDE.TMEIISO', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TMEIISO</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TMEIISO</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>65</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (66, N'3d8879d4-e11e-4a85-85e7-9d78ff26f676', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TNOROPE', N'GEO_SIGR_DDAD_M10.SDE.TNOROPE', N'\GEO_SIGR_DDAD_M10.SDE.TNOROPE', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TNOROPE</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TNOROPE</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>66</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (67, N'7fba925b-ae43-45df-ada5-b98cefab67b5', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TORGENER', N'GEO_SIGR_DDAD_M10.SDE.TORGENER', N'\GEO_SIGR_DDAD_M10.SDE.TORGENER', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TORGENER</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TORGENER</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>67</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (68, N'd743ae99-076b-418b-babb-9be3f895bed5', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPIP', N'GEO_SIGR_DDAD_M10.SDE.TPIP', N'\GEO_SIGR_DDAD_M10.SDE.TPIP', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPIP</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPIP</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>68</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><AliasName>OBJECTID</AliasName><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><DomainFixed>true</DomainFixed><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><AliasName>COD_ID</AliasName><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>DESCR</Name><AliasName>DESCR</AliasName><ModelName>DESCR</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName>Tipo de Ponto de Iluminação Pública</AliasName><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (69, N'f2c7c318-f038-447a-8e39-4f600a06a3d1', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPONNOT', N'GEO_SIGR_DDAD_M10.SDE.TPONNOT', N'\GEO_SIGR_DDAD_M10.SDE.TPONNOT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPONNOT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPONNOT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>69</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (70, N'0e1848c7-60e5-4eff-af7c-9a32174f95ea', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPOS', N'GEO_SIGR_DDAD_M10.SDE.TPOS', N'\GEO_SIGR_DDAD_M10.SDE.TPOS', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPOS</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPOS</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>70</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (71, N'8efabbc5-e283-43b9-9489-4a3cb114a74a', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPOSTOTRAN', N'GEO_SIGR_DDAD_M10.SDE.TPOSTOTRAN', N'\GEO_SIGR_DDAD_M10.SDE.TPOSTOTRAN', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPOSTOTRAN</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPOSTOTRAN</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>71</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (72, N'0e214636-4e30-4632-93fb-e35602e33d4c', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPOTAPRT', N'GEO_SIGR_DDAD_M10.SDE.TPOTAPRT', N'\GEO_SIGR_DDAD_M10.SDE.TPOTAPRT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPOTAPRT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPOTAPRT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>72</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (73, N'dc87b152-b512-49ce-8e40-0c4e3e934aed', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TPOTRTV', N'GEO_SIGR_DDAD_M10.SDE.TPOTRTV', N'\GEO_SIGR_DDAD_M10.SDE.TPOTRTV', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TPOTRTV</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TPOTRTV</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>73</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (74, N'b2bb7f91-8a4d-4998-834a-3b43ca286c8b', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TREGU', N'GEO_SIGR_DDAD_M10.SDE.TREGU', N'\GEO_SIGR_DDAD_M10.SDE.TREGU', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TREGU</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TREGU</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>74</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (75, N'585024cd-a587-40a5-81fa-9a2a38199f9b', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TRELTC', N'GEO_SIGR_DDAD_M10.SDE.TRELTC', N'\GEO_SIGR_DDAD_M10.SDE.TRELTC', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TRELTC</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TRELTC</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>75</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (76, N'f8bfd7a9-2d33-4f91-a9a8-f923212aa751', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TRELTP', N'GEO_SIGR_DDAD_M10.SDE.TRELTP', N'\GEO_SIGR_DDAD_M10.SDE.TRELTP', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TRELTP</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TRELTP</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>76</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (77, N'6465da6b-d718-4938-89f8-c12a3ee2aec4', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TRESREGUL', N'GEO_SIGR_DDAD_M10.SDE.TRESREGUL', N'\GEO_SIGR_DDAD_M10.SDE.TRESREGUL', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TRESREGUL</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TRESREGUL</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>77</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><AliasName>OBJECTID</AliasName><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><DomainFixed>true</DomainFixed><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><AliasName>COD_ID</AliasName><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>RES_REGUL</Name><AliasName>RES_REGUL</AliasName><ModelName>RES_REGUL</ModelName><FieldType>esriFieldTypeDouble</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>DESCR</Name><AliasName>DESCR</AliasName><ModelName>DESCR</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName>Tipo de Resistência Regulatória</AliasName><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (78, N'10bf19e4-ddc1-47aa-8527-7b510a7a8f47', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TSITATI', N'GEO_SIGR_DDAD_M10.SDE.TSITATI', N'\GEO_SIGR_DDAD_M10.SDE.TSITATI', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TSITATI</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TSITATI</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>78</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (79, N'422050d3-4878-480d-9b4c-ae4e4a04574f', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TSITCONT', N'GEO_SIGR_DDAD_M10.SDE.TSITCONT', N'\GEO_SIGR_DDAD_M10.SDE.TSITCONT', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TSITCONT</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TSITCONT</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>79</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (80, N'29265bf8-4746-40f8-b52d-80df84c201b8', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TSUBGRP', N'GEO_SIGR_DDAD_M10.SDE.TSUBGRP', N'\GEO_SIGR_DDAD_M10.SDE.TSUBGRP', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TSUBGRP</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TSUBGRP</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>80</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (81, N'b3475c58-b010-4921-b71c-58a72f8185a3', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TTEN', N'GEO_SIGR_DDAD_M10.SDE.TTEN', N'\GEO_SIGR_DDAD_M10.SDE.TTEN', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TTEN</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TTEN</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>81</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (82, N'401dbaab-23b8-4663-83e2-60c411758a1b', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TTRANF', N'GEO_SIGR_DDAD_M10.SDE.TTRANF', N'\GEO_SIGR_DDAD_M10.SDE.TTRANF', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TTRANF</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TTRANF</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>82</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (83, N'0a48609a-a6a4-4f90-b65e-7fdb925fb477', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TUAR', N'GEO_SIGR_DDAD_M10.SDE.TUAR', N'\GEO_SIGR_DDAD_M10.SDE.TUAR', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TUAR</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TUAR</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>83</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><AliasName>OBJECTID</AliasName><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><DomainFixed>true</DomainFixed><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><AliasName>COD_ID</AliasName><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>TIPO</Name><AliasName>TIPO</AliasName><ModelName>TIPO</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>ENTIDADE</Name><AliasName>ENTIDADE</AliasName><ModelName>ENTIDADE</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>DESCR</Name><AliasName>DESCR</AliasName><ModelName>DESCR</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>true</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName>Tipo de Unidade de Adição e Retirada</AliasName><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMS] ([ObjectID], [UUID], [Type], [Name], [PhysicalName], [Path], [Url], [Properties], [Defaults], [DatasetSubtype1], [DatasetSubtype2], [DatasetInfo1], [DatasetInfo2], [Definition], [Documentation], [ItemInfo], [Shape]) VALUES (84, N'027c9d75-5f48-49ee-a61b-49e4f45e3cf1', N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'GEO_SIGR_DDAD_M10.SDE.TUNI', N'GEO_SIGR_DDAD_M10.SDE.TUNI', N'\GEO_SIGR_DDAD_M10.SDE.TUNI', N'', 1, NULL, NULL, NULL, NULL, NULL, N'<DETableInfo xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:typens="http://www.esri.com/schemas/ArcGIS/10.7" xsi:type="typens:DETableInfo"><CatalogPath>\GEO_SIGR_DDAD_M10.SDE.TUNI</CatalogPath><Name>GEO_SIGR_DDAD_M10.SDE.TUNI</Name><ChildrenExpanded>false</ChildrenExpanded><DatasetType>esriDTTable</DatasetType><DSID>84</DSID><Versioned>false</Versioned><CanVersion>true</CanVersion><ConfigurationKeyword /><RequiredGeodatabaseClientVersion>10.0</RequiredGeodatabaseClientVersion><HasOID>true</HasOID><OIDFieldName>OBJECTID</OIDFieldName><GPFieldInfoExs xsi:type="typens:ArrayOfGPFieldInfoEx"><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>OBJECTID</Name><ModelName>OBJECTID</ModelName><FieldType>esriFieldTypeOID</FieldType><IsNullable>false</IsNullable><Required>true</Required><Editable>false</Editable></GPFieldInfoEx><GPFieldInfoEx xsi:type="typens:GPFieldInfoEx"><Name>COD_ID</Name><ModelName>COD_ID</ModelName><FieldType>esriFieldTypeString</FieldType><IsNullable>false</IsNullable></GPFieldInfoEx></GPFieldInfoExs><CLSID>{7A566981-C114-11D2-8A28-006097AFF44E}</CLSID><EXTCLSID /><RelationshipClassNames xsi:type="typens:Names" /><AliasName /><ModelName /><HasGlobalID>false</HasGlobalID><GlobalIDFieldName /><RasterFieldName /><ExtensionProperties xsi:type="typens:PropertySet"><PropertyArray xsi:type="typens:ArrayOfPropertySetProperty" /></ExtensionProperties><ControllerMemberships xsi:type="typens:ArrayOfControllerMembership" /><EditorTrackingEnabled>false</EditorTrackingEnabled><CreatorFieldName /><CreatedAtFieldName /><EditorFieldName /><EditedAtFieldName /><IsTimeInUTC>true</IsTimeInUTC><ChangeTracked>false</ChangeTracked><FieldFilteringEnabled>false</FieldFilteringEnabled><FilteredFieldNames xsi:type="typens:Names" /></DETableInfo>', NULL, NULL, NULL)
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (27, N'a3803369-5fc2-4963-bae0-13effc09dd73', N'Parcel Fabric', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (32, N'c29da988-8c3e-45f7-8b5c-18e51ee7beb4', N'Range Domain', N'8637f1ed-8c04-4866-a44a-1cb8288b3c63')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (17, N'8637f1ed-8c04-4866-a44a-1cb8288b3c63', N'Domain', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (14, N'c673fe0f-7280-404f-8532-20755dd8fc06', N'Workspace', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (6, N'd4912162-3413-476e-9da4-2aefbbc16939', N'AbstractTable', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (22, N'70737809-852c-4a03-9e22-2cecea5b9bfa', N'Feature Class', N'd4912162-3413-476e-9da4-2aefbbc16939')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (15, N'dc9ef677-1aa3-45a7-8acd-303a5202d0dc', N'Workspace Extension', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (30, N'f8413dcb-2248-4935-bfe9-315f397e5110', N'Mosaic Dataset', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (1, N'8405add5-8df8-4227-8fac-3fcade073386', N'Item', N'00000000-0000-0000-0000-000000000000')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (10, N'767152d3-ed66-4325-8774-420d46674e07', N'Topology', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (19, N'd98421eb-d582-4713-9484-43304d0810f6', N'Replica Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (28, N'a300008d-0cea-4f6a-9dfa-46af829a3df2', N'Representation Class', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (11, N'e6302665-416b-44fa-be33-4e15916ba101', N'Survey Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (4, N'28da9e89-ff80-4d6d-8926-4ee2b161677d', N'Dataset', N'ffd09c28-fe70-4e25-907c-af8e8a5ec5f3')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (29, N'787bea35-4a86-494f-bb48-500b96145b58', N'Catalog Dataset', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (25, N'7771fc7d-a38b-4fd3-8225-639d17e9a131', N'Network Dataset', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (38, N'cc53cc54-4cca-43b7-9a9b-64dc59c999bd', N'Location Referencing Dataset', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (34, N'd86502f9-9758-45c6-9d23-6dd1a0107b47', N'Sync Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (7, N'b606a7e1-fa5b-439c-849c-6e9c2481537b', N'Relationship Class', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (13, N'db1b697a-3bb6-426a-98a2-6ee7a4c6aed3', N'Toolbox', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (24, N'35b601f7-45ce-4aff-adb7-7702d3839b12', N'Raster Catalog', N'd4912162-3413-476e-9da4-2aefbbc16939')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (26, N'76357537-3364-48af-a4be-783c7c28b5cb', N'Terrain', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (36, N'60ea40cf-2667-45e2-bdff-7f6892538fe8', N'Trace Network', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (18, N'4ed4a58e-621f-4043-95ed-850fba45fcbc', N'Replica', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (35, N'37672bd2-b9f3-48c1-89b5-8c43bbbb6d57', N'Utility Network', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (21, N'cd06bc3b-789d-4c51-aafa-a467912b8965', N'Table', N'd4912162-3413-476e-9da4-2aefbbc16939')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (37, N'ebeee2c9-fa73-4bed-ac7d-aee7d68afc80', N'Parcel Dataset', N'77292603-930f-475d-ae4f-b8970f42f394')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (3, N'ffd09c28-fe70-4e25-907c-af8e8a5ec5f3', N'Resource', N'8405add5-8df8-4227-8fac-3fcade073386')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (33, N'5b966567-fb87-4dde-938b-b4b37423539d', N'Sync Replica', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (16, N'77292603-930f-475d-ae4f-b8970f42f394', N'Extension Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (8, N'74737149-dcb5-4257-8904-b9724e32a530', N'Feature Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (31, N'8c368b12-a12e-4c7e-9638-c9c64e69e98f', N'Coded Value Domain', N'8637f1ed-8c04-4866-a44a-1cb8288b3c63')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (2, N'f3783e6f-65ca-4514-8315-ce3985dad3b1', N'Folder', N'8405add5-8df8-4227-8fac-3fcade073386')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (9, N'73718a66-afb9-4b88-a551-cffa0ae12620', N'Geometric Network', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (23, N'5ed667a3-9ca9-44a2-8029-d95bf23704b9', N'Raster Dataset', N'd4912162-3413-476e-9da4-2aefbbc16939')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (12, N'd5a40288-029e-4766-8c81-de3f61129371', N'Schematic Dataset', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (5, N'fbdd7dd6-4a25-40b7-9a1a-ecc3d1172447', N'Tin', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_ITEMTYPES] ([ObjectID], [UUID], [Name], [ParentTypeID]) VALUES (20, N'dc64b6e4-dc0f-43bd-b4f5-f22385dcf055', N'Historical Marker', N'28da9e89-ff80-4d6d-8926-4ee2b161677d')
INSERT [sde].[GDB_TABLES_LAST_MODIFIED] ([table_name], [last_modified_count]) VALUES (N'GDB_ITEMRELATIONSHIPS', 119)
INSERT [sde].[GDB_TABLES_LAST_MODIFIED] ([table_name], [last_modified_count]) VALUES (N'GDB_ITEMRELATIONSHIPTYPES', 25)
INSERT [sde].[GDB_TABLES_LAST_MODIFIED] ([table_name], [last_modified_count]) VALUES (N'GDB_ITEMS', 364)
INSERT [sde].[GDB_TABLES_LAST_MODIFIED] ([table_name], [last_modified_count]) VALUES (N'GDB_ITEMTYPES', 38)
INSERT [sde].[GDB_TABLES_LAST_MODIFIED] ([table_name], [last_modified_count]) VALUES (N'GDB_REPLICALOG', 0)
INSERT [sde].[i2] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 85, -1, 84)
INSERT [sde].[i3] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 82, -1, 81)
INSERT [sde].[i4] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 39, -1, 35)
INSERT [sde].[i45] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 5, -1, 5)
INSERT [sde].[i46] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 4, -1, 4)
INSERT [sde].[i47] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 155, -1, 155)
INSERT [sde].[i48] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 10, -1, 10)
INSERT [sde].[i49] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 12, -1, 12)
INSERT [sde].[i5] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 26, -1, 18)
INSERT [sde].[i50] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 19, -1, 19)
INSERT [sde].[i51] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 17, -1, 17)
INSERT [sde].[i52] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 50, -1, 50)
INSERT [sde].[i53] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 31, -1, 31)
INSERT [sde].[i54] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 41, -1, 41)
INSERT [sde].[i55] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 21, -1, 21)
INSERT [sde].[i56] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 5, -1, 5)
INSERT [sde].[i57] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 60, -1, 60)
INSERT [sde].[i58] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 5, -1, 5)
INSERT [sde].[i59] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 105, -1, 105)
INSERT [sde].[i6] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 1, -1, 1)
INSERT [sde].[i60] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 79, -1, 79)
INSERT [sde].[i61] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 13, -1, 13)
INSERT [sde].[i62] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 22, -1, 22)
INSERT [sde].[i63] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 20, -1, 20)
INSERT [sde].[i64] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 16, -1, 16)
INSERT [sde].[i65] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 5, -1, 5)
INSERT [sde].[i66] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 13, -1, 13)
INSERT [sde].[i67] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 14, -1, 14)
INSERT [sde].[i68] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 13, -1, 13)
INSERT [sde].[i69] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 4, -1, 4)
INSERT [sde].[i70] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 10, -1, 10)
INSERT [sde].[i71] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 11, -1, 11)
INSERT [sde].[i72] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 16, -1, 16)
INSERT [sde].[i73] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 10, -1, 10)
INSERT [sde].[i74] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 11, -1, 11)
INSERT [sde].[i75] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 111, -1, 111)
INSERT [sde].[i76] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 35, -1, 35)
INSERT [sde].[i77] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 6, -1, 6)
INSERT [sde].[i78] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 62, -1, 62)
INSERT [sde].[i79] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 26, -1, 26)
INSERT [sde].[i80] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 91, -1, 91)
INSERT [sde].[i81] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 4, -1, 4)
INSERT [sde].[i82] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 11, -1, 11)
INSERT [sde].[i83] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 9, -1, 9)
INSERT [sde].[i84] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 104, -1, 104)
INSERT [sde].[i85] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 8, -1, 8)
INSERT [sde].[i86] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 86, -1, 86)
INSERT [sde].[i87] ([id_type], [base_id], [num_ids], [last_id]) VALUES (2, 58, -1, 58)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'Attributes', 10, 2147483647, NULL, NULL, 132, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'DestID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'ObjectID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'OriginID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'Properties', 2, 10, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'Type', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'UUID', 12, 38, NULL, NULL, 256, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'BackwardLabel', 14, 226, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'DestItemTypeID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'ForwardLabel', 14, 226, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'IsContainment', 1, 5, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'Name', 14, 226, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'ObjectID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'OrigItemTypeID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'UUID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'DatasetInfo1', 14, 255, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'DatasetInfo2', 14, 255, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'DatasetSubtype1', 2, 10, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'DatasetSubtype2', 2, 10, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Defaults', 6, NULL, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Definition', 10, 2147483647, NULL, NULL, 132, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Documentation', 10, 2147483647, NULL, NULL, 132, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'ItemInfo', 10, 2147483647, NULL, NULL, 132, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Name', 14, 226, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'ObjectID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Path', 14, 512, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'PhysicalName', 14, 226, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Properties', 2, 10, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Shape', 8, NULL, NULL, NULL, 131076, 1)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Type', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'Url', 14, 255, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'UUID', 12, 38, NULL, NULL, 256, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMTYPES', N'SDE', N'Name', 14, 226, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMTYPES', N'SDE', N'ObjectID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMTYPES', N'SDE', N'ParentTypeID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_ITEMTYPES', N'SDE', N'UUID', 12, 38, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'ErrorCode', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'Event', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'ID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'LogDate', 7, 0, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'ReplicaID', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'SourceBeginGen', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'SourceEndGen', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'TargetGen', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_TABLES_LAST_MODIFIED', N'SDE', N'last_modified_count', 2, 10, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'GDB_TABLES_LAST_MODIFIED', N'SDE', N'table_name', 14, 160, NULL, NULL, 0, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TALCPRD', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TALCPRD', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TALCPRD', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TARE', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TARE', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TARE', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOBIT', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOBIT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOBIT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOFOR', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOFOR', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOFOR', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOGEOM', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOGEOM', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOGEOM', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOISO', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOISO', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOISO', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOMAT', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOMAT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCABOMAT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCAPELFU', N'SDE', N'COD_ID', 14, 5, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCAPELFU', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCAPELFU', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCATPT', N'SDE', N'COD_ID', 14, 6, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCATPT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCATPT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLASUBCLA', N'SDE', N'COD_ID', 14, 4, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLASUBCLA', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLASUBCLA', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLATEN', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLATEN', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLATEN', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCLATEN', N'SDE', N'TEN', 2, 10, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCONFIG', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCONFIG', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCONFIG', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCOR', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCOR', N'SDE', N'CORR', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCOR', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TCOR', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TDIACRV', N'SDE', N'COD_ID', 14, 3, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TDIACRV', N'SDE', N'DESCR', 14, 254, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TDIACRV', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTALT', N'SDE', N'ALT', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTALT', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTALT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTALT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTESF', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTESF', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTESF', N'SDE', N'ESF', 1, 5, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTESF', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTMAT', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTMAT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
GO
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTMAT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTR', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTR', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TESTR', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'COD_ID', 14, 4, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'FASES', 1, 5, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'QUANT_FIOS', 1, 5, NULL, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTAR', N'SDE', N'COD_ID', 14, 4, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTAR', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTAR', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTEN', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTEN', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TGRUTEN', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TINST', N'SDE', N'COD_ID', 14, 15, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TINST', N'SDE', N'DESCR', 14, 254, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TINST', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TLIG', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TLIG', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TLIG', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TMEIISO', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TMEIISO', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TMEIISO', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TNOROPE', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TNOROPE', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TNOROPE', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TORGENER', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TORGENER', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TORGENER', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPIP', N'SDE', N'COD_ID', 14, 2, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPIP', N'SDE', N'DESCR', 14, 254, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPIP', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPONNOT', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPONNOT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPONNOT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOS', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOS', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOS', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOSTOTRAN', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOSTOTRAN', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOSTOTRAN', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTAPRT', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTAPRT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTAPRT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTAPRT', N'SDE', N'POT', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTRTV', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTRTV', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTRTV', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TPOTRTV', N'SDE', N'POT', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TREGU', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TREGU', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TREGU', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTC', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTC', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTC', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTP', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTP', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRELTP', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRESREGUL', N'SDE', N'COD_ID', 14, 15, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRESREGUL', N'SDE', N'DESCR', 14, 254, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRESREGUL', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TRESREGUL', N'SDE', N'RES_REGUL', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITATI', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITATI', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITATI', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITCONT', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITCONT', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSITCONT', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSUBGRP', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSUBGRP', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TSUBGRP', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTEN', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTEN', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTEN', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTEN', N'SDE', N'TEN', 4, 38, 8, NULL, 4, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTRANF', N'SDE', N'COD_ID', 14, 2, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTRANF', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TTRANF', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'COD_ID', 14, 6, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'DESCR', 14, 254, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'ENTIDADE', 14, 14, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'TIPO', 14, 17, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUNI', N'SDE', N'COD_ID', 14, 3, 0, NULL, 0, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUNI', N'SDE', N'DESCR', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUNI', N'SDE', N'OBJECTID', 2, 10, NULL, NULL, 3, NULL)
INSERT [sde].[SDE_column_registry] ([database_name], [table_name], [owner], [column_name], [sde_type], [column_size], [decimal_digits], [description], [object_flags], [object_id]) VALUES (N'GEO_SIGR_DDAD_M10', N'TUNI', N'SDE', N'UNIDADE', 14, 255, 0, NULL, 4, 0)
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'I_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'MVTABLES_MODIFIED_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'MVTABLES_MODIFIED_TABLE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'STATE_LINEAGES_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'STATE_LINEAGES_TABLE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'STATES_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'STATES_TABLE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'VERSIONS_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'VERSIONS_TABLE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'XML_INDEX_TAGS_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DATA_DICTIONARY', N'XML_INDEX_TAGS_TABLE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_RASTER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_CLUSTER_XML', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_RASTER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_INDEX_XML', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_RASTER', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_ROWID', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_SHAPE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_STATEID', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_USER', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_PARTITION_XML', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'AUX_CLUSTER_COMPOSITE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'AUX_INDEX_COMPOSITE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'AUX_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_RASTER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_TO_DATE', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_CLUSTER_XML', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_RASTER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_TO_DATE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_INDEX_XML', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_RASTER', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_ROWID', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_SHAPE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_TO_DATE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_USER', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_PARTITION_XML', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BLK_CLUSTER_COMPOSITE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BLK_INDEX_COMPOSITE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BLK_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BLK_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_CLUSTER_COMPOSITE', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_CLUSTER_ID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_INDEX_COMPOSITE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_INDEX_ID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_PARTITION_COMPOSITE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_PARTITION_ID', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'BND_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'COLLATION_NAME', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'CROSS_DB_QUERY_FILTER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_CLUSTER_DELETED_AT', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_PARTITION_DELETED_AT', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'GEOM_SRID_CHECK', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'GEOMTAB_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'GEOMTAB_PK', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'GEOMTAB_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'I_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'NUM_DEFAULT_CURSORS', N'-1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'PERMISSION_CACHE_THRESHOLD', N'250')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'RAS_CLUSTER_ID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'RAS_INDEX_ID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'RAS_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'RASTER_STORAGE', N'BINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
GO
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_PARTITION_SP_FID', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'UI_TEXT', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'UNICODE_STRING', N'TRUE')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_COLUMN_STORAGE', N'DB_XML')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_DOC_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_DOC_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_DOC_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_DOC_UNCOMPRESSED_TYPE', N'BINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_CLUSTER_DOUBLE', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_CLUSTER_ID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_CLUSTER_PK', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_CLUSTER_STRING', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_CLUSTER_TAG', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_FULLTEXT_CAT', N'SDE_DEFAULT_CAT')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_FULLTEXT_LANGUAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_FULLTEXT_TIMESTAMP', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_FULLTEXT_UPDATE_METHOD', N'CHANGE_TRACKING BACKGROUND')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_INDEX_DOUBLE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_INDEX_ID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_INDEX_PK', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_INDEX_STRING', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_INDEX_TAG', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'DEFAULTS', N'XML_IDX_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'GEOGRAPHY', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'GEOGRAPHY', N'UI_TEXT', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'GEOMETRY', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'GEOMETRY', N'UI_TEXT', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'IMS_GAZETTEER', N'XML_COLUMN_STORAGE', N'SDE_XML')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LD_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LD_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LF_CLUSTER_ID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LF_CLUSTER_NAME', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LF_INDEX_ID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LF_INDEX_NAME', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'LF_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'SESSION_INDEX', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'SESSION_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'LOGFILE_DEFAULTS', N'SESSION_TEMP_TABLE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'COMMENT', N'The base system initialization parameters for NETWORK_DEFAULTS')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS', N'UI_NETWORK_TEXT', N'The network default configuration')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_CLUSTER_ROWID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_CLUSTER_ROWID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::DESC', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_CLUSTER_ROWID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
GO
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_CLUSTER_ROWID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_DEFAULTS::NETWORK', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOGRAPHY', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOGRAPHY', N'UI_NETWORK_TEXT', N'User Interface description for SQL Server GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOGRAPHY::DESC', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOGRAPHY::NETWORK', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOMETRY', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOMETRY', N'UI_NETWORK_TEXT', N'User Interface description for SQL Server GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOMETRY::DESC', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_GEOMETRY::NETWORK', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_SDEBINARY', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_SDEBINARY', N'UI_NETWORK_TEXT', N'User Interface description for SQL Server SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_SDEBINARY::DESC', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'NETWORK_SDEBINARY::NETWORK', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'SDEBINARY', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'SDEBINARY', N'UI_TEXT', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS', N'UI_TERRAIN_TEXT', N'The terrains default configuration')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_DEFAULTS::EMBEDDED', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOGRAPHY', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOGRAPHY', N'UI_TERRAIN_TEXT', N'User Interface description for SQL Server GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOGRAPHY::EMBEDDED', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
GO
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOMETRY', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOMETRY', N'UI_TERRAIN_TEXT', N'User Interface description for SQL Server GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_GEOMETRY::EMBEDDED', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_SDEBINARY', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_SDEBINARY', N'UI_TERRAIN_TEXT', N'User Interface description for SQL Server SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TERRAIN_SDEBINARY::EMBEDDED', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS', N'UI_TOPOLOGY_TEXT', N'The topology default configuration')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_CLUSTER_STATEID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_INDEX_STATEID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'A_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_CLUSTER_ROWID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_CLUSTER_SHAPE', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_CLUSTER_USER', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_INDEX_ROWID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_INDEX_SHAPE', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_INDEX_USER', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'B_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'D_CLUSTER_ALL', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'D_CLUSTER_DELETED_AT', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'D_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'D_INDEX_DELETED_AT', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'D_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_CLUSTER_FID', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_INDEX_AREA', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_INDEX_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_INDEX_LEN', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_OUT_OF_ROW', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'F_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'S_CLUSTER_ALL', N'1')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'S_CLUSTER_SP_FID', N'0')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'S_INDEX_ALL', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'S_INDEX_SP_FID', N'WITH FILLFACTOR = 75')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_DEFAULTS::DIRTYAREAS', N'S_STORAGE', N'')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOGRAPHY', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOGRAPHY', N'UI_TOPOLOGY_TEXT', N'User Interface description for SQL Server GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOGRAPHY::DIRTYAREAS', N'GEOMETRY_STORAGE', N'GEOGRAPHY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOMETRY', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOMETRY', N'UI_TOPOLOGY_TEXT', N'User Interface description for SQL Server GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_GEOMETRY::DIRTYAREAS', N'GEOMETRY_STORAGE', N'GEOMETRY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_SDEBINARY', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_SDEBINARY', N'UI_TOPOLOGY_TEXT', N'User Interface description for SQL Server SDEBINARY')
INSERT [sde].[SDE_dbtune] ([keyword], [parameter_name], [config_string]) VALUES (N'TOPOLOGY_SDEBINARY::DIRTYAREAS', N'GEOMETRY_STORAGE', N'SDEBINARY')
INSERT [sde].[SDE_geometry_columns] ([f_table_catalog], [f_table_schema], [f_table_name], [f_geometry_column], [g_table_catalog], [g_table_schema], [g_table_name], [storage_type], [geometry_type], [coord_dimension], [max_ppr], [srid]) VALUES (N'GEO_SIGR_DDAD_M10', N'SDE', N'GDB_ITEMS', N'SHAPE', N'GEO_SIGR_DDAD_M10', N'SDE', N'f1', 2, 11, 2, NULL, 1)
INSERT [sde].[SDE_layers] ([layer_id], [description], [database_name], [table_name], [owner], [spatial_column], [eflags], [layer_mask], [gsize1], [gsize2], [gsize3], [minx], [miny], [maxx], [maxy], [minz], [maxz], [minm], [maxm], [cdate], [layer_config], [optimal_array_size], [stats_date], [minimum_id], [srid], [base_layer_id], [secondary_srid]) VALUES (1, NULL, N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'SHAPE', 138674321, 0, -6, 0, 0, 9.999E+35, 9.999E+35, -9.999E+35, -9.999E+35, NULL, NULL, NULL, NULL, 1554529724, N'DATA_DICTIONARY', NULL, NULL, 1, 1, 0, NULL)
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (5, 2, N'LAYERS')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (6, 88, N'REGISTERED TABLES')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (7, 1, N'RASTER COLUMNS')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (8, 1, N'STATES')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (9, 2, N'VERSIONS')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (10, 1, N'METADATA')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (11, 1, N'LOCATORS')
INSERT [sde].[SDE_object_ids] ([id_type], [base_id], [object_type]) VALUES (12, 13, N'CONNECTIONS')
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'ALLOWSESSIONLOGFILE', NULL, 1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'ATTRBUFSIZE', NULL, 50000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'AUTH_KEY', N'arcsdeserver,101,ecp515585521,none,A3C7FE2E09FZPF002066', NULL)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'AUTOCOMMIT', NULL, 1000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'BLOBMEM', NULL, 1000000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'CONNECTIONS', NULL, 999999)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'DEFAULTPRECISION', NULL, 64)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'DISABLEDC', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'ERRLOGMODE', NULL, 7)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'HOLDLOGPOOLTABLES', NULL, 1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'INT64TYPES', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'LARGEIDBLOCK', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'LAYERAUTOLOCKING', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'LOGFILEPOOLSIZE', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXARRAYBYTES', NULL, 550000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXARRAYSIZE', NULL, 100)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXBLOBSIZE', NULL, -1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXBUFSIZE', NULL, 65536)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXDISTINCT', NULL, 512)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXGRIDSPERFEAT', NULL, 8000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXINITIALFEATS', NULL, 10000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXSTANDALONELOGS', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MAXTIMEDIFF', NULL, -1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MINBUFOBJECTS', NULL, 512)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'MINBUFSIZE', NULL, 16384)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'PROCSTATS', NULL, -1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'RASTERBUFSIZE', NULL, 204800)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'READONLY', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'SHAPEPTSBUFSIZE', NULL, 400000)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'SMALLIDBLOCK', NULL, 16)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'STATEAUTOLOCKING', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'STATECACHING', NULL, 1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'STATUS', NULL, 1)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'STREAMPOOLSIZE', NULL, 6)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'TCPKEEPALIVE', NULL, 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'TEMP', N'C:\Users\GEO0ES~1\AppData\Local\Temp\3\arc2B5F', 0)
INSERT [sde].[SDE_server_config] ([prop_name], [char_prop_value], [num_prop_value]) VALUES (N'TLMINTERVAL', NULL, 1)
INSERT [sde].[SDE_spatial_references] ([srid], [description], [auth_name], [auth_srid], [falsex], [falsey], [xyunits], [falsez], [zunits], [falsem], [munits], [xycluster_tol], [zcluster_tol], [mcluster_tol], [object_flags], [srtext]) VALUES (1, NULL, N'EPSG', 4326, -400, -400, 1000000000, -100000, 10000, -100000, 10000, 8.98315284119522E-09, 0.001, 0.001, 1, N'GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]')
INSERT [sde].[SDE_state_lineages] ([lineage_name], [lineage_id]) VALUES (0, 0)
INSERT [sde].[SDE_states] ([state_id], [owner], [creation_time], [closing_time], [parent_state_id], [lineage_name]) VALUES (0, N'sde', CAST(N'2019-04-06 02:48:38.000' AS DateTime), CAST(N'2019-04-06 02:48:38.000' AS DateTime), 0, 0)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (1, N'GEO_SIGR_DDAD_M10', N'GDB_TABLES_LAST_MODIFIED', N'SDE', NULL, NULL, 0, 1554529722, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (2, N'GEO_SIGR_DDAD_M10', N'GDB_ITEMS', N'SDE', N'OBJECTID', NULL, 4210695, 1554529722, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (3, N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPS', N'SDE', N'OBJECTID', NULL, 4194307, 1554529724, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (4, N'GEO_SIGR_DDAD_M10', N'GDB_ITEMTYPES', N'SDE', N'OBJECTID', NULL, 3, 1554529725, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (5, N'GEO_SIGR_DDAD_M10', N'GDB_ITEMRELATIONSHIPTYPES', N'SDE', N'OBJECTID', NULL, 3, 1554529726, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (6, N'GEO_SIGR_DDAD_M10', N'GDB_REPLICALOG', N'SDE', N'ID', NULL, 3, 1554529726, N'DATA_DICTIONARY', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (45, N'GEO_SIGR_DDAD_M10', N'TALCPRD', N'SDE', N'OBJECTID', NULL, 3, 1658179282, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (46, N'GEO_SIGR_DDAD_M10', N'TARE', N'SDE', N'OBJECTID', NULL, 3, 1658179284, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (47, N'GEO_SIGR_DDAD_M10', N'TCABOBIT', N'SDE', N'OBJECTID', NULL, 3, 1658179285, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (48, N'GEO_SIGR_DDAD_M10', N'TCABOFOR', N'SDE', N'OBJECTID', NULL, 3, 1658179286, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (49, N'GEO_SIGR_DDAD_M10', N'TCABOGEOM', N'SDE', N'OBJECTID', NULL, 3, 1658179287, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (50, N'GEO_SIGR_DDAD_M10', N'TCABOISO', N'SDE', N'OBJECTID', NULL, 3, 1658179288, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (51, N'GEO_SIGR_DDAD_M10', N'TCABOMAT', N'SDE', N'OBJECTID', NULL, 3, 1658179289, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (52, N'GEO_SIGR_DDAD_M10', N'TCAPELFU', N'SDE', N'OBJECTID', NULL, 3, 1658179291, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (53, N'GEO_SIGR_DDAD_M10', N'TCATPT', N'SDE', N'OBJECTID', NULL, 3, 1658179292, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (54, N'GEO_SIGR_DDAD_M10', N'TCLASUBCLA', N'SDE', N'OBJECTID', NULL, 3, 1658179293, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (55, N'GEO_SIGR_DDAD_M10', N'TCLATEN', N'SDE', N'OBJECTID', NULL, 3, 1658179295, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (56, N'GEO_SIGR_DDAD_M10', N'TCONFIG', N'SDE', N'OBJECTID', NULL, 3, 1658179296, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (57, N'GEO_SIGR_DDAD_M10', N'TCOR', N'SDE', N'OBJECTID', NULL, 3, 1658179297, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (58, N'GEO_SIGR_DDAD_M10', N'TDIACRV', N'SDE', N'OBJECTID', NULL, 3, 1658179298, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (59, N'GEO_SIGR_DDAD_M10', N'TESTALT', N'SDE', N'OBJECTID', NULL, 3, 1658179299, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (60, N'GEO_SIGR_DDAD_M10', N'TESTESF', N'SDE', N'OBJECTID', NULL, 3, 1658179300, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (61, N'GEO_SIGR_DDAD_M10', N'TESTMAT', N'SDE', N'OBJECTID', NULL, 3, 1658179301, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (62, N'GEO_SIGR_DDAD_M10', N'TESTR', N'SDE', N'OBJECTID', NULL, 3, 1658179303, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (63, N'GEO_SIGR_DDAD_M10', N'TFASCON', N'SDE', N'OBJECTID', NULL, 3, 1658179304, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (64, N'GEO_SIGR_DDAD_M10', N'TGRUTAR', N'SDE', N'OBJECTID', NULL, 3, 1658179305, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (65, N'GEO_SIGR_DDAD_M10', N'TGRUTEN', N'SDE', N'OBJECTID', NULL, 3, 1658179307, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (66, N'GEO_SIGR_DDAD_M10', N'TINST', N'SDE', N'OBJECTID', NULL, 3, 1658179308, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (67, N'GEO_SIGR_DDAD_M10', N'TLIG', N'SDE', N'OBJECTID', NULL, 3, 1658179309, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (68, N'GEO_SIGR_DDAD_M10', N'TMEIISO', N'SDE', N'OBJECTID', NULL, 3, 1658179310, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (69, N'GEO_SIGR_DDAD_M10', N'TNOROPE', N'SDE', N'OBJECTID', NULL, 3, 1658179311, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (70, N'GEO_SIGR_DDAD_M10', N'TORGENER', N'SDE', N'OBJECTID', NULL, 3, 1658179312, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (71, N'GEO_SIGR_DDAD_M10', N'TPIP', N'SDE', N'OBJECTID', NULL, 3, 1658179313, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (72, N'GEO_SIGR_DDAD_M10', N'TPONNOT', N'SDE', N'OBJECTID', NULL, 3, 1658179314, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (73, N'GEO_SIGR_DDAD_M10', N'TPOS', N'SDE', N'OBJECTID', NULL, 3, 1658179316, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (74, N'GEO_SIGR_DDAD_M10', N'TPOSTOTRAN', N'SDE', N'OBJECTID', NULL, 3, 1658179317, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (75, N'GEO_SIGR_DDAD_M10', N'TPOTAPRT', N'SDE', N'OBJECTID', NULL, 3, 1658179318, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (76, N'GEO_SIGR_DDAD_M10', N'TPOTRTV', N'SDE', N'OBJECTID', NULL, 3, 1658179319, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (77, N'GEO_SIGR_DDAD_M10', N'TREGU', N'SDE', N'OBJECTID', NULL, 3, 1658179320, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (78, N'GEO_SIGR_DDAD_M10', N'TRELTC', N'SDE', N'OBJECTID', NULL, 3, 1658179321, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (79, N'GEO_SIGR_DDAD_M10', N'TRELTP', N'SDE', N'OBJECTID', NULL, 3, 1658179323, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (80, N'GEO_SIGR_DDAD_M10', N'TRESREGUL', N'SDE', N'OBJECTID', NULL, 3, 1658179324, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (81, N'GEO_SIGR_DDAD_M10', N'TSITATI', N'SDE', N'OBJECTID', NULL, 3, 1658179325, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (82, N'GEO_SIGR_DDAD_M10', N'TSITCONT', N'SDE', N'OBJECTID', NULL, 3, 1658179326, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (83, N'GEO_SIGR_DDAD_M10', N'TSUBGRP', N'SDE', N'OBJECTID', NULL, 3, 1658179327, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (84, N'GEO_SIGR_DDAD_M10', N'TTEN', N'SDE', N'OBJECTID', NULL, 3, 1658179328, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (85, N'GEO_SIGR_DDAD_M10', N'TTRANF', N'SDE', N'OBJECTID', NULL, 3, 1658179329, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (86, N'GEO_SIGR_DDAD_M10', N'TUAR', N'SDE', N'OBJECTID', NULL, 3, 1658179330, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_table_registry] ([registration_id], [database_name], [table_name], [owner], [rowid_column], [description], [object_flags], [registration_date], [config_keyword], [minimum_id], [imv_view_name]) VALUES (87, N'GEO_SIGR_DDAD_M10', N'TUNI', N'SDE', N'OBJECTID', NULL, 3, 1658179331, N'DEFAULTS', 1, NULL)
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'HISTORICAL_ARCHIVES', CAST(N'2019-04-06 02:48:39.590' AS DateTime))
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'SDE_ARCHIVES', CAST(N'2019-04-06 02:48:39.577' AS DateTime))
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'SDE_LAYERS', CAST(N'2019-04-06 02:48:45.000' AS DateTime))
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'SDE_RASTER_COLUMNS', CAST(N'2019-04-06 02:48:39.577' AS DateTime))
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'SDE_TABLE_REGISTRY', CAST(N'2022-07-18 18:24:56.000' AS DateTime))
INSERT [sde].[SDE_tables_modified] ([table_name], [time_last_modified]) VALUES (N'SDE_XML_COLUMNS', CAST(N'2019-04-06 02:48:46.000' AS DateTime))
INSERT [sde].[SDE_version] ([MAJOR], [MINOR], [BUGFIX], [DESCRIPTION], [RELEASE], [SDESVR_REL_LOW]) VALUES (10, 4, 1, N'10.4.1 Geodatabase', 104002, 93001)
INSERT [sde].[SDE_versions] ([name], [owner], [version_id], [status], [state_id], [description], [parent_name], [parent_owner], [parent_version_id], [creation_time]) VALUES (N'DEFAULT', N'sde', 1, 1, 0, N'Instance default version.', NULL, NULL, NULL, CAST(N'2019-04-06 02:48:39.000' AS DateTime))
INSERT [sde].[TALCPRD] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado ou não aplicável')
INSERT [sde].[TALCPRD] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'A1', N'Nível de tensão A1')
INSERT [sde].[TALCPRD] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'A2', N'Nível de tensão A2')
INSERT [sde].[TALCPRD] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'A3', N'Nível de tensão A3')
INSERT [sde].[TARE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TARE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'UB', N'Urbano')
INSERT [sde].[TARE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'NU', N'Não Urbano')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'1 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'2 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'4 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'6 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'8 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'10 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'12 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'20 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'40 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'61 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'1/0 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'2/0 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'13', N'3/0 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'14', N'4/0 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'15', N'8/0 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'16', N'1,5 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'17', N'2,25 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'18', N'2,5 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'19', N'3,09 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'20', N'4 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'21', N'6 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'22', N'7,5 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'23', N'9,53 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'24', N'10 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (26, N'25', N'16 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (27, N'26', N'25 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (28, N'27', N'26 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (29, N'28', N'30 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (30, N'29', N'35 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (31, N'30', N'50 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (32, N'31', N'70 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (33, N'32', N'95 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (34, N'33', N'120 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (35, N'34', N'150 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (36, N'35', N'170 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (37, N'36', N'185 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (38, N'37', N'240 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (39, N'38', N'300 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (40, N'39', N'400 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (41, N'40', N'500 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (42, N'41', N'630 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (43, N'42', N'800 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (44, N'43', N'101,8 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (45, N'44', N'134,6 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (46, N'45', N'250 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (47, N'46', N'266,8 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (48, N'47', N'300 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (49, N'48', N'312,8 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (50, N'49', N'336,4 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (51, N'50', N'394,5 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (52, N'51', N'397,5 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (53, N'52', N'465,4 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (54, N'53', N'447 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (55, N'54', N'477 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (56, N'55', N'477,7 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (57, N'56', N'500 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (58, N'57', N'556,5 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (59, N'58', N'636 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (60, N'59', N'715,5 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (61, N'60', N'795 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (62, N'61', N'900 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (63, N'62', N'954 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (64, N'63', N'1113 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (65, N'64', N'1272 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (66, N'65', N'2000 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (67, N'66', N'5 AWG')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (68, N'67', N'600 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (69, N'68', N'750 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (70, N'69', N'11,9 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (71, N'70', N'200 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (72, N'71', N'434 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (73, N'72', N'450 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (74, N'73', N'800 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (75, N'74', N'1000 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (76, N'75', N'1x(1x10mm²+10mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (77, N'76', N'1x(1x120mm²+120mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (78, N'77', N'1x(1x120mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (79, N'78', N'1x(1x16mm²+16mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (80, N'79', N'1x(1x25mm²+25mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (81, N'80', N'1x(1x35mm²+35mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (82, N'81', N'1x(1x50mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (83, N'82', N'1x(1x6mm²+6mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (84, N'83', N'1x(1x70mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (85, N'84', N'1x(1x70mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (86, N'85', N'1x(1x8mm²+8mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (87, N'86', N'2x(1x10mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (88, N'87', N'2x(1x10mm²+10mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (89, N'88', N'2x(1x120mm²+120mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (90, N'89', N'2x(1x120mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (91, N'90', N'2x(1x16mm²+16mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (92, N'91', N'2x(1x25mm²+25mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (93, N'92', N'2x(1x35mm²+35mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (94, N'93', N'2x(1x50mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (95, N'94', N'2x(1x70mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (96, N'95', N'2x(1x8mm²+8mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (97, N'96', N'2x(1x4mm²+4mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (98, N'97', N'2x(1x6mm²+6mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (99, N'98', N'3x(1x1/0mm²+1/0mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (100, N'99', N'3x(1x10mm²+10mm²)')
GO
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (101, N'100', N'3x(1x120mm²+120mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (102, N'101', N'3x(1x120mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (103, N'102', N'3x(1x16mm²+16mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (104, N'103', N'3x(1x185mm²+185mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (105, N'104', N'3x(1x240mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (106, N'105', N'3x(1x240mm²+120mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (107, N'106', N'3x(1x25mm²+25mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (108, N'107', N'3x(1x35mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (109, N'108', N'3x(1x35mm²+35mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (110, N'109', N'3x(1x35mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (111, N'110', N'3x(1x50mm²+35mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (112, N'111', N'3x(1x50mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (113, N'112', N'3x(1x6mm²+6mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (114, N'113', N'3x(1x70mm²+50mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (115, N'114', N'3x(1x70mm²+70mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (116, N'115', N'3x(1x8mm²+8mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (117, N'116', N'3x(1x4mm²+4mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (118, N'117', N'3x(1x150mm²+150mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (119, N'118', N'3x(1x240mm²+240mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (120, N'119', N'3x(1x95mm²+95mm²)')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (121, N'120', N'4,87 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (122, N'121', N'8 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (123, N'122', N'750 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (124, N'140', N'1,09 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (125, N'150', N'3,26 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (126, N'125', N'4,5 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (128, N'141', N'5 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (129, N'148', N'6,4 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (131, N'137', N'10,4 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (132, N'139', N'63 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (133, N'149', N'106 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (134, N'138', N'160 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (135, N'126', N'253 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (136, N'151', N'315 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (137, N'127', N'380 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (138, N'128', N'507 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (139, N'136', N'914 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (140, N'129', N'1600 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (141, N'130', N'2000 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (142, N'135', N'2500 mm²')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (143, N'123', N'176,9 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (144, N'147', N'426,3 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (145, N'145', N'559,5 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (146, N'146', N'652,4 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (147, N'143', N'740,8 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (148, N'144', N'927,2 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (149, N'124', N'2250 MCM')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (150, N'131', N'5/16 “')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (151, N'132', N'3/8 “')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (152, N'133', N'1 1/2 “')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (153, N'134', N'2 “')
INSERT [sde].[TCABOBIT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (154, N'142', N'2 1/2 “')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'Singelo')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'Multiplexado Duplex')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'Multiplexado Triplex')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'Multiplexado Quadruplex')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'Interno de subestação')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'Concêntrico Monofásico')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'Concêntrico Bifásico')
INSERT [sde].[TCABOFOR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'Concêntrico Trifásico')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'Aérea Compacta')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'Aérea Concêntrica')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'Aérea Horizontal')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'Aérea Multiplex')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'Subterrânea')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'Aérea Triangular')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'Aérea Vertical')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'Submersa')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'Interna')
INSERT [sde].[TCABOGEOM] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'Em Subestação')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'Blindagem metálica')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'Coberto')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'Com alma')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'Encapado')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'EPR/PVC')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'EPR/XLPE')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'Isolado - EPR')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'Isolado - Papel impregnado')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'Isolado - PVC')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'Isolado - XLPE')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'Misto OPGW')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'Nu')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'13', N'Isolado - PE')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'14', N'Protegido - PVC')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'15', N'Protegido - EPR')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'16', N'Sem blindagem')
INSERT [sde].[TCABOISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'17', N'Protegido - XLPE')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'Aço')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'Aço aluminizado')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'Aço cobreado')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'Aço zincado')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'Alumínio')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'Alumínio com alma de aço')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'Alumínio com alma em compósito')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'Alumínio termo resistente')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'Alumínio-Liga')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'Cobre')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'Alumínio-liga termorresistente com alma de aço')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'Alumínio-liga termorresistente com alma de fibra de carbono')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'13', N'Tubo de Alumínio')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'14', N'Barra de Alumínio')
INSERT [sde].[TCABOMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'15', N'Barra de Cobre')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado ou não aplicável')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1H', N'1H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2H', N'2H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3H', N'3H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'5H', N'5H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'6K', N'6K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'8K', N'8K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'10K', N'10K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'12K', N'12K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'15K', N'15K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'20K', N'20K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'25K', N'25K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'30K', N'30K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'40K', N'40K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'50K', N'50K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'60K', N'60K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'65K', N'65K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'75K', N'75K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'80K', N'80K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'100K', N'100K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'140K', N'140K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'200K', N'200K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'LAM', N'LAMINA')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'DIR', N'ELO DIRETO')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'SC', N'S/C')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (26, N'08H', N'0,8H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (27, N'04H', N'0,4H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (28, N'05H', N'0,5H')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (29, N'100EF', N'100EF')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (30, N'10F', N'10F')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (31, N'1EF', N'1EF')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (32, N'30T', N'30T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (33, N'3K', N'3K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (34, N'40EF', N'40EF')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (35, N'5K', N'5K')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (36, N'65EF', N'65EF')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (37, N'65T', N'65T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (38, N'6T', N'6T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (39, N'80EF', N'80EF')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (40, N'80T', N'80T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (41, N'8T', N'8T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (42, N'10T', N'10T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (43, N'12T', N'12T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (44, N'15T', N'15T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (45, N'20T', N'20T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (46, N'25T', N'25T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (47, N'40T', N'40T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (48, N'50T', N'50T')
INSERT [sde].[TCAPELFU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (49, N'100T', N'100T')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'A1', N'Categoria do nível de tensão A1')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'A2', N'Categoria do nível de tensão A2')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'A3', N'Categoria do nível de tensão A3')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'A3A', N'Categoria do nível de tensão A3a')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'A4', N'Categoria do nível de tensão A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'B', N'Categoria do nível de tensão B')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'MED', N'Categoria de Medidores')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'RAM', N'Categoria de Ramais')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'REG', N'Categoria de Reguladores')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'A1-A2', N'Categoria dos segmentos de transformação A1-A2')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'A1-A3', N'Categoria dos segmentos de transformação A1-A3')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'A1-A3A', N'Categoria dos segmentos de transformação A1-A3A')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'A1-A4', N'Categoria dos segmentos de transformação A1-A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'A2-A3', N'Categoria dos segmentos de transformação A2-A3')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'A2-A3A', N'Categoria dos segmentos de transformação A2-A3a')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'A2-A4', N'Categoria dos segmentos de transformação A2-A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'A3-A3A', N'Categoria dos segmentos de transformação A3-A3a')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'A3-A4', N'Categoria dos segmentos de transformação A3-A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'A3A-A4', N'Categoria dos segmentos de transformação A3a-A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'A3A-B', N'Categoria dos segmentos de transformação A3a-B')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'A4-A4', N'Categoria dos segmentos de transformação A4-A4')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'A4-B', N'Categoria dos segmentos de transformação A4-B')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'A3-A2', N'Categoria dos segmentos de transformação A3-A2')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'A3A-A2', N'Categoria dos segmentos de transformação A3a-A2')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (26, N'A4-A2', N'Categoria dos segmentos de transformação A4-A2')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (27, N'A4-A3', N'Categoria dos segmentos de transformação A4-A3')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (28, N'A4-A3A', N'Categoria dos segmentos de transformação A4-A3a')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (29, N'B-A3A', N'Categoria dos segmentos de transformação B-A3a')
INSERT [sde].[TCATPT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (30, N'B-A4', N'Categoria dos segmentos de transformação B-A4')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'RE1', N'Residencial')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'RE2', N'Residencial baixa renda')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'RE3', N'Residencial baixa renda indígena')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'RE4', N'Residencial baixa renda quilombola')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'RE5', N'Residencial baixa renda benefício de prestação continuada da assistência social – BPC')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'RE6', N'Residencial baixa renda multifamiliar')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'IN', N'Industrial')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'CO1', N'Comercial')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'CO2', N'Serviços de transporte, exceto tração elétrica')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'CO3', N'Serviços de comunicações e telecomunicações')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'CO4', N'Associação e entidades filantrópicas')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'CO5', N'Templos religiosos')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'CO6', N'Administração condominial: iluminação e instalações de uso comum de prédio ou conjunto de edificações')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'CO7', N'Iluminação em rodovias: solicitada por quem detenha concessão ou autorização para administração em rodovias')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'CO8', N'Semáforos, radares e câmeras de monitoramento de trânsito, solicitados por quem detenha concessão ou autorização para controle de trânsito')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'CO9', N'Outros serviços e outras atividades')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'RU1', N'Agropecuária rural')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'RU1A', N'Agropecuária rural (poços de captação de água, para atender finalidades de que trata este inciso, desde que não haja comercialização da água)')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'RU1B', N'Agropecuária rural (serviço de bombeamento de água destinada à atividade de irrigação)')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'RU2', N'Agropecuária urbana')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'RU3', N'Residencial rural')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'RU4', N'Cooperativa de eletrificação rural')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'RU5', N'Agroindustrial')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'RU6', N'Serviço público de irrigação rural')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (26, N'RU7', N'Escola agrotécnica')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (27, N'RU8', N'Aquicultura')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (28, N'PP1', N'Poder público federal')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (29, N'PP2', N'Poder público estadual ou distrital')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (30, N'PP3', N'Poder público municipal')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (31, N'IP', N'Iluminação pública')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (32, N'SP1', N'Tração elétrica')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (33, N'SP2', N'Água, esgoto e saneamento')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (34, N'CPR', N'Consumo próprio pela distribuidora')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (35, N'CSPS', N'Concessionária ou Permissionária')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (36, N'CPRV', N'Consumo próprio pela distribuidora para estação de recarga de veículos elétricos')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (37, N'REBR', N'Residencial de baixa renda indígena')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (38, N'REQU', N'Residencial de baixa renda quilombola')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (39, N'REBP', N'Residencial de baixa renda benefício de prestação continuada da assistência social - BPC')
INSERT [sde].[TCLASUBCLA] ([OBJECTID], [COD_ID], [DESCR]) VALUES (40, N'REMU', N'Residencial de baixa renda multifamiliar')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (1, N'0', 0, N'Não informado')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (2, N'1', 3800, N'Classe de tensão em 3,8 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (3, N'2', 13800, N'Classe de tensão em 13,8 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (4, N'3', 14400, N'Classe de tensão em 14,4 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (5, N'4', 15000, N'Classe de tensão em 15 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (6, N'5', 20000, N'Classe de tensão em 20 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (7, N'6', 23000, N'Classe de tensão em 23 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (8, N'7', 24000, N'Classe de tensão em 24 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (9, N'8', 25000, N'Classe de tensão em 25 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (10, N'9', 34500, N'Classe de tensão em 34,5 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (11, N'10', 45400, N'Classe de tensão de 45,4 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (12, N'11', 69000, N'Classe de tensão em 69 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (13, N'12', 72500, N'Classe de tensão de 72,5 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (14, N'13', 92400, N'Classe de tensão de 92,4 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (15, N'14', 138000, N'Classe de tensão em 138 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (16, N'15', 145000, N'Classe de tensão de 145 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (17, N'16', 230000, N'Classe de tensão em 230 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (18, N'17', 242000, N'Classe de tensão de 242 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (19, N'18', 362000, N'Classe de tensão de 362 kV')
INSERT [sde].[TCLATEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (20, N'19', 36200, N'Classe de tensão em 36,2 kV')
INSERT [sde].[TCONFIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TCONFIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AN', N'Anel')
INSERT [sde].[TCONFIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'RA', N'Radial')
INSERT [sde].[TCONFIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'RT', N'Reticulado')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Não informado')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (2, N'1', CAST(25.00000000 AS Numeric(38, 8)), N'25 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (3, N'2', CAST(40.00000000 AS Numeric(38, 8)), N'40 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (4, N'3', CAST(50.00000000 AS Numeric(38, 8)), N'50 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (5, N'4', CAST(56.00000000 AS Numeric(38, 8)), N'56 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (6, N'5', CAST(60.00000000 AS Numeric(38, 8)), N'60 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (7, N'6', CAST(70.00000000 AS Numeric(38, 8)), N'70 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (8, N'7', CAST(71.60000000 AS Numeric(38, 8)), N'71,6 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (9, N'8', CAST(75.00000000 AS Numeric(38, 8)), N'75 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (10, N'9', CAST(78.70000000 AS Numeric(38, 8)), N'78,7 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (11, N'10', CAST(80.00000000 AS Numeric(38, 8)), N'80 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (12, N'11', CAST(87.50000000 AS Numeric(38, 8)), N'87,5 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (13, N'12', CAST(100.00000000 AS Numeric(38, 8)), N'100 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (14, N'13', CAST(112.00000000 AS Numeric(38, 8)), N'112 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (15, N'14', CAST(125.00000000 AS Numeric(38, 8)), N'125 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (16, N'15', CAST(125.50000000 AS Numeric(38, 8)), N'125,5 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (17, N'16', CAST(150.00000000 AS Numeric(38, 8)), N'150 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (18, N'17', CAST(160.00000000 AS Numeric(38, 8)), N'160 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (19, N'18', CAST(200.00000000 AS Numeric(38, 8)), N'200 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (20, N'19', CAST(209.00000000 AS Numeric(38, 8)), N'209 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (21, N'20', CAST(209.20000000 AS Numeric(38, 8)), N'209,2 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (22, N'21', CAST(219.00000000 AS Numeric(38, 8)), N'219 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (23, N'22', CAST(250.00000000 AS Numeric(38, 8)), N'250 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (24, N'23', CAST(280.00000000 AS Numeric(38, 8)), N'280 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (25, N'24', CAST(300.00000000 AS Numeric(38, 8)), N'300 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (26, N'25', CAST(320.00000000 AS Numeric(38, 8)), N'320 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (27, N'26', CAST(328.00000000 AS Numeric(38, 8)), N'328 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (28, N'27', CAST(400.00000000 AS Numeric(38, 8)), N'400 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (29, N'28', CAST(420.00000000 AS Numeric(38, 8)), N'420 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (30, N'29', CAST(438.00000000 AS Numeric(38, 8)), N'438 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (31, N'30', CAST(440.00000000 AS Numeric(38, 8)), N'440 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (32, N'31', CAST(450.00000000 AS Numeric(38, 8)), N'450 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (33, N'32', CAST(500.00000000 AS Numeric(38, 8)), N'500 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (34, N'33', CAST(560.00000000 AS Numeric(38, 8)), N'560 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (35, N'34', CAST(600.00000000 AS Numeric(38, 8)), N'600 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (36, N'35', CAST(630.00000000 AS Numeric(38, 8)), N'630 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (37, N'36', CAST(800.00000000 AS Numeric(38, 8)), N'800 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (38, N'37', CAST(850.00000000 AS Numeric(38, 8)), N'850 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (39, N'38', CAST(875.00000000 AS Numeric(38, 8)), N'875 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (40, N'39', CAST(1200.00000000 AS Numeric(38, 8)), N'1200 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (41, N'40', CAST(1250.00000000 AS Numeric(38, 8)), N'1250 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (42, N'41', CAST(1300.00000000 AS Numeric(38, 8)), N'1300 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (43, N'42', CAST(1600.00000000 AS Numeric(38, 8)), N'1600 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (44, N'43', CAST(1700.00000000 AS Numeric(38, 8)), N'1700 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (45, N'44', CAST(1800.00000000 AS Numeric(38, 8)), N'1800 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (46, N'45', CAST(1875.00000000 AS Numeric(38, 8)), N'1875 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (47, N'46', CAST(2000.00000000 AS Numeric(38, 8)), N'2000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (48, N'47', CAST(2100.00000000 AS Numeric(38, 8)), N'2100 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (49, N'48', CAST(2400.00000000 AS Numeric(38, 8)), N'2400 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (50, N'49', CAST(2500.00000000 AS Numeric(38, 8)), N'2500 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (51, N'50', CAST(3000.00000000 AS Numeric(38, 8)), N'3000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (52, N'51', CAST(3150.00000000 AS Numeric(38, 8)), N'3150 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (53, N'52', CAST(3500.00000000 AS Numeric(38, 8)), N'3500 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (54, N'53', CAST(10000.00000000 AS Numeric(38, 8)), N'10000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (55, N'54', CAST(12000.00000000 AS Numeric(38, 8)), N'12000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (56, N'55', CAST(16000.00000000 AS Numeric(38, 8)), N'16000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (57, N'56', CAST(20000.00000000 AS Numeric(38, 8)), N'20000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (58, N'57', CAST(25000.00000000 AS Numeric(38, 8)), N'25000 A')
INSERT [sde].[TCOR] ([OBJECTID], [COD_ID], [CORR], [DESCR]) VALUES (59, N'58', CAST(50000.00000000 AS Numeric(38, 8)), N'50000 A')
INSERT [sde].[TDIACRV] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TDIACRV] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'DU', N'Curva típica de dia útil')
INSERT [sde].[TDIACRV] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'SA', N'Curva típica de sábado')
INSERT [sde].[TDIACRV] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'DO', N'Curva típica de domingos e feriados')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Não informado ou não aplicável')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (2, N'1', CAST(4.30000000 AS Numeric(38, 8)), N'4,3 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (3, N'2', CAST(4.50000000 AS Numeric(38, 8)), N'4,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (4, N'3', CAST(5.00000000 AS Numeric(38, 8)), N'5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (5, N'4', CAST(6.00000000 AS Numeric(38, 8)), N'6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (6, N'5', CAST(7.00000000 AS Numeric(38, 8)), N'7 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (7, N'6', CAST(7.50000000 AS Numeric(38, 8)), N'7,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (8, N'7', CAST(8.00000000 AS Numeric(38, 8)), N'8 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (9, N'8', CAST(8.50000000 AS Numeric(38, 8)), N'8,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (10, N'9', CAST(9.00000000 AS Numeric(38, 8)), N'9 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (11, N'10', CAST(10.00000000 AS Numeric(38, 8)), N'10 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (12, N'11', CAST(10.50000000 AS Numeric(38, 8)), N'10,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (13, N'12', CAST(11.00000000 AS Numeric(38, 8)), N'11 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (14, N'13', CAST(12.00000000 AS Numeric(38, 8)), N'12 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (15, N'14', CAST(13.00000000 AS Numeric(38, 8)), N'13 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (16, N'15', CAST(14.00000000 AS Numeric(38, 8)), N'14 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (17, N'16', CAST(15.00000000 AS Numeric(38, 8)), N'15 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (18, N'17', CAST(16.00000000 AS Numeric(38, 8)), N'16 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (19, N'18', CAST(17.00000000 AS Numeric(38, 8)), N'17 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (20, N'19', CAST(17.50000000 AS Numeric(38, 8)), N'17,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (21, N'20', CAST(18.00000000 AS Numeric(38, 8)), N'18 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (22, N'21', CAST(19.00000000 AS Numeric(38, 8)), N'19 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (23, N'22', CAST(20.00000000 AS Numeric(38, 8)), N'20 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (24, N'23', CAST(20.50000000 AS Numeric(38, 8)), N'20,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (25, N'24', CAST(21.00000000 AS Numeric(38, 8)), N'21 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (26, N'25', CAST(21.50000000 AS Numeric(38, 8)), N'21,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (27, N'26', CAST(22.00000000 AS Numeric(38, 8)), N'22 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (28, N'27', CAST(23.00000000 AS Numeric(38, 8)), N'23 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (29, N'28', CAST(23.50000000 AS Numeric(38, 8)), N'23,5 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (30, N'29', CAST(24.00000000 AS Numeric(38, 8)), N'24 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (31, N'30', CAST(24.60000000 AS Numeric(38, 8)), N'24,6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (32, N'31', CAST(25.00000000 AS Numeric(38, 8)), N'25 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (33, N'32', CAST(26.00000000 AS Numeric(38, 8)), N'26 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (34, N'33', CAST(26.60000000 AS Numeric(38, 8)), N'26,6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (35, N'34', CAST(27.00000000 AS Numeric(38, 8)), N'27 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (36, N'35', CAST(27.60000000 AS Numeric(38, 8)), N'27,6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (37, N'36', CAST(27.70000000 AS Numeric(38, 8)), N'27,7 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (38, N'37', CAST(28.00000000 AS Numeric(38, 8)), N'28 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (39, N'38', CAST(28.60000000 AS Numeric(38, 8)), N'28,6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (40, N'39', CAST(28.70000000 AS Numeric(38, 8)), N'28,7 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (41, N'40', CAST(29.00000000 AS Numeric(38, 8)), N'29 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (42, N'41', CAST(29.60000000 AS Numeric(38, 8)), N'29,6 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (43, N'42', CAST(29.70000000 AS Numeric(38, 8)), N'29,7 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (44, N'43', CAST(30.00000000 AS Numeric(38, 8)), N'30 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (45, N'44', CAST(30.20000000 AS Numeric(38, 8)), N'30,2 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (46, N'45', CAST(31.00000000 AS Numeric(38, 8)), N'31 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (47, N'46', CAST(32.00000000 AS Numeric(38, 8)), N'32 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (48, N'47', CAST(33.00000000 AS Numeric(38, 8)), N'33 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (49, N'48', CAST(34.00000000 AS Numeric(38, 8)), N'34 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (50, N'49', CAST(35.00000000 AS Numeric(38, 8)), N'35 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (51, N'50', CAST(36.00000000 AS Numeric(38, 8)), N'36 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (52, N'51', CAST(37.00000000 AS Numeric(38, 8)), N'37 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (53, N'52', CAST(38.00000000 AS Numeric(38, 8)), N'38 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (54, N'53', CAST(39.00000000 AS Numeric(38, 8)), N'39 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (55, N'54', CAST(40.00000000 AS Numeric(38, 8)), N'40 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (56, N'55', CAST(42.00000000 AS Numeric(38, 8)), N'42 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (57, N'56', CAST(43.00000000 AS Numeric(38, 8)), N'43 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (58, N'57', CAST(44.00000000 AS Numeric(38, 8)), N'44 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (59, N'58', CAST(45.00000000 AS Numeric(38, 8)), N'45 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (60, N'59', CAST(46.00000000 AS Numeric(38, 8)), N'46 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (61, N'60', CAST(47.00000000 AS Numeric(38, 8)), N'47 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (62, N'61', CAST(48.00000000 AS Numeric(38, 8)), N'48 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (63, N'62', CAST(49.00000000 AS Numeric(38, 8)), N'49 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (64, N'63', CAST(50.00000000 AS Numeric(38, 8)), N'50 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (65, N'64', CAST(51.00000000 AS Numeric(38, 8)), N'51 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (66, N'65', CAST(52.00000000 AS Numeric(38, 8)), N'52 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (67, N'66', CAST(54.00000000 AS Numeric(38, 8)), N'54 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (68, N'67', CAST(64.00000000 AS Numeric(38, 8)), N'64 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (69, N'68', CAST(66.00000000 AS Numeric(38, 8)), N'66 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (70, N'69', CAST(84.00000000 AS Numeric(38, 8)), N'84 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (71, N'70', CAST(53.00000000 AS Numeric(38, 8)), N'53 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (72, N'71', CAST(55.00000000 AS Numeric(38, 8)), N'55 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (73, N'72', CAST(56.00000000 AS Numeric(38, 8)), N'56 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (74, N'73', CAST(57.00000000 AS Numeric(38, 8)), N'57 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (75, N'74', CAST(58.00000000 AS Numeric(38, 8)), N'58 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (76, N'75', CAST(59.00000000 AS Numeric(38, 8)), N'59 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (77, N'76', CAST(60.00000000 AS Numeric(38, 8)), N'60 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (78, N'77', CAST(61.00000000 AS Numeric(38, 8)), N'61 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (79, N'78', CAST(62.00000000 AS Numeric(38, 8)), N'62 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (80, N'79', CAST(63.00000000 AS Numeric(38, 8)), N'63 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (81, N'80', CAST(65.00000000 AS Numeric(38, 8)), N'65 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (82, N'81', CAST(67.00000000 AS Numeric(38, 8)), N'67 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (83, N'82', CAST(68.00000000 AS Numeric(38, 8)), N'68 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (84, N'83', CAST(69.00000000 AS Numeric(38, 8)), N'69 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (85, N'84', CAST(70.00000000 AS Numeric(38, 8)), N'70 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (86, N'85', CAST(71.00000000 AS Numeric(38, 8)), N'71 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (87, N'86', CAST(72.00000000 AS Numeric(38, 8)), N'72 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (88, N'87', CAST(73.00000000 AS Numeric(38, 8)), N'73 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (89, N'88', CAST(74.00000000 AS Numeric(38, 8)), N'74 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (90, N'89', CAST(75.00000000 AS Numeric(38, 8)), N'75 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (91, N'90', CAST(76.00000000 AS Numeric(38, 8)), N'76 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (92, N'91', CAST(77.00000000 AS Numeric(38, 8)), N'77 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (93, N'92', CAST(78.00000000 AS Numeric(38, 8)), N'78 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (94, N'93', CAST(79.00000000 AS Numeric(38, 8)), N'79 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (95, N'94', CAST(80.00000000 AS Numeric(38, 8)), N'80 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (96, N'95', CAST(81.00000000 AS Numeric(38, 8)), N'81 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (97, N'96', CAST(82.00000000 AS Numeric(38, 8)), N'82 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (98, N'97', CAST(83.00000000 AS Numeric(38, 8)), N'83 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (99, N'98', CAST(85.00000000 AS Numeric(38, 8)), N'85 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (100, N'99', CAST(86.00000000 AS Numeric(38, 8)), N'86 m')
GO
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (101, N'100', CAST(87.00000000 AS Numeric(38, 8)), N'87 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (102, N'101', CAST(88.00000000 AS Numeric(38, 8)), N'88 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (103, N'102', CAST(89.00000000 AS Numeric(38, 8)), N'89 m')
INSERT [sde].[TESTALT] ([OBJECTID], [COD_ID], [ALT], [DESCR]) VALUES (104, N'103', CAST(90.00000000 AS Numeric(38, 8)), N'90 m')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (1, N'0', 0, N'Não informado ou não aplicável')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (2, N'1', 50, N'50 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (3, N'2', 75, N'75 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (4, N'3', 90, N'90 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (5, N'4', 100, N'100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (6, N'5', 150, N'150 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (7, N'6', 200, N'200 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (8, N'7', 300, N'300 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (9, N'8', 400, N'400 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (10, N'9', 450, N'450 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (11, N'10', 500, N'500 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (12, N'11', 600, N'600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (13, N'12', 700, N'700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (14, N'13', 750, N'750 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (15, N'14', 800, N'800 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (16, N'15', 850, N'850 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (17, N'16', 900, N'900 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (18, N'17', 950, N'950 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (19, N'18', 1000, N'1000 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (20, N'19', 1050, N'1050 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (21, N'20', 1100, N'1100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (22, N'21', 1150, N'1150 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (23, N'22', 1200, N'1200 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (24, N'23', 1250, N'1250 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (25, N'24', 1300, N'1300 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (26, N'25', 1350, N'1350 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (27, N'26', 1400, N'1400 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (28, N'27', 1450, N'1450 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (29, N'28', 1500, N'1500 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (30, N'29', 1550, N'1550 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (31, N'30', 1600, N'1600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (32, N'31', 1650, N'1650 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (33, N'32', 1700, N'1700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (34, N'33', 1750, N'1750 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (35, N'34', 1800, N'1800 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (36, N'35', 2000, N'2000 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (37, N'36', 2400, N'2400 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (38, N'37', 2500, N'2500 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (39, N'38', 2600, N'2600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (40, N'39', 2700, N'2700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (41, N'40', 2800, N'2800 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (42, N'41', 2900, N'2900 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (43, N'42', 3000, N'3000 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (44, N'43', 3100, N'3100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (45, N'44', 3200, N'3200 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (46, N'45', 3300, N'3300 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (47, N'46', 3400, N'3400 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (48, N'47', 3500, N'3500 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (49, N'48', 3600, N'3600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (50, N'49', 3700, N'3700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (51, N'50', 3800, N'3800 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (52, N'51', 3900, N'3900 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (53, N'52', 4000, N'4000 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (54, N'53', 4100, N'4100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (55, N'54', 4200, N'4200 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (56, N'55', 4300, N'4300 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (57, N'56', 4400, N'4400 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (58, N'57', 4500, N'4500 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (59, N'58', 4600, N'4600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (60, N'59', 4700, N'4700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (61, N'60', 4800, N'4800 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (62, N'61', 4900, N'4900 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (63, N'62', 5000, N'5000 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (64, N'63', 5100, N'5100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (65, N'64', 5600, N'5600 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (66, N'65', 5700, N'5700 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (67, N'66', NULL, N'Leve (Madeira)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (68, N'67', NULL, N'Médio (Madeira)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (69, N'68', NULL, N'Pesado (Madeira)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (70, N'69', NULL, N'Extra Pesado (Madeira)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (71, N'70', NULL, N'22 (Trilho)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (72, N'71', NULL, N'32 (Trilho)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (73, N'72', NULL, N'42 (Trilho)')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (74, N'77', 250, N'250 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (75, N'73', 1900, N'1900 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (76, N'74', 2100, N'2100 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (77, N'75', 2200, N'2200 daN')
INSERT [sde].[TESTESF] ([OBJECTID], [COD_ID], [ESF], [DESCR]) VALUES (78, N'76', 2300, N'2300 daN')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado ou não aplicável')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AC', N'Aço')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'CO', N'Concreto')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'CL', N'Concreto leve')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'EC', N'Em compósito')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'FE', N'Ferro')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'CQ', N'Madeira')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'ME', N'Madeira eucalipto')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'MQ', N'Madeira quadrado')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'MT', N'Metálica')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'AV', N'Alvenaria')
INSERT [sde].[TESTMAT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'CA', N'Nista (Concreto e Aço)')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AT', N'Autoportante')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'CA', N'Cabine')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'CI', N'Circular')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'CP', N'Contra poste')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'CD', N'Curvo duplo')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'CS', N'Curvo simples')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'DT', N'Duplo T')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'ES', N'Estaiada')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'OR', N'Ornamental')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'QU', N'Quadrado')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'RE', N'Retangular')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'TO', N'Torre ou Treliça')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'TG', N'Triangular')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'TL', N'Trilho')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'TS', N'Trilho simples')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'TP', N'Trusspole')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'TU', N'Tubular')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'TQ', N'Tubular - Seção quadrada')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'H', N'H (2 colunas e Viga Central)')
INSERT [sde].[TESTR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'ST', N'Sextavado')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (1, N'0', 0, 0, N'Não informado')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (2, N'ABCN', 4, 3, N'Conexão a 4 fios com 3 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (3, N'ABC', 3, 3, N'Conexão a 3 fios com 3 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (4, N'ABN', 3, 2, N'Conexão a 3 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (5, N'BCN', 3, 2, N'Conexão a 3 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (6, N'CAN', 3, 2, N'Conexão a 3 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (7, N'AX', 3, 1, N'Conexão a 3 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (8, N'BX', 3, 1, N'Conexão a 3 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (9, N'CX', 3, 1, N'Conexão a 3 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (10, N'AB', 2, 2, N'Conexão a 2 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (11, N'BC', 2, 2, N'Conexão a 2 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (12, N'CA', 2, 2, N'Conexão a 2 fios com 2 fases')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (13, N'AN', 2, 1, N'Conexão a 2 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (14, N'BN', 2, 1, N'Conexão a 2 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (15, N'CN', 2, 1, N'Conexão a 2 fios com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (16, N'A', 1, 1, N'Conexão a 1 fio com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (17, N'B', 1, 1, N'Conexão a 1 fio com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (18, N'C', 1, 1, N'Conexão a 1 fio com 1 fase')
INSERT [sde].[TFASCON] ([OBJECTID], [COD_ID], [QUANT_FIOS], [FASES], [DESCR]) VALUES (19, N'N', 1, 0, N'Conexão a 1 fio sem fase')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'A1', N'Subgrupo A1 - tensão de fornecimento igual ou superior a 230 kV')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'A2', N'Subgrupo A2 - tensão de fornecimento de 88 kV a 138 kV')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'A3', N'Subgrupo A3 - tensão de fornecimento de 69 kV')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'A3A', N'Subgrupo A3a - tensão de fornecimento de 30 kV a 44 kV')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'A4', N'Subgrupo A4 - tensão de fornecimento de 2,3 kV a 25 kV')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'AS', N'Subgrupo AS')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'B1', N'Subgrupo B1 - residencial')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'B1BR', N'Subgrupo B1 - residencial baixa renda')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'B2RU', N'Subgrupo B2 - rural')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'B2CO', N'Subgrupo B2 - cooperativa de eletrificação rural')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'B2SP', N'Subgrupo B2 - serviço público de irrigação')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'B3', N'Subgrupo B3 - demais classes')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'B4A', N'Subgrupo B4 - iluminação pública - propriedade do poder público')
INSERT [sde].[TGRUTAR] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'B4B', N'Subgrupo B4 - iluminação pública - propriedade da distribuidora')
INSERT [sde].[TGRUTEN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TGRUTEN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AT', N'Alta Tensão')
INSERT [sde].[TGRUTEN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'MT', N'Média Tensão')
INSERT [sde].[TGRUTEN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'BT', N'Baixa Tensão')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado ou Não Aplicável')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'SE_MT', N'Subestação em tensão menor ou igual a 48 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'SE_AT', N'Subestação em tensão maior ou igual a 60 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'LD_AER_MT', N'Linha de Distribuição Aéreas em tensão menor ou igual que 48 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'LD_AER_AT', N'Linha de Distribuição Aéreas em tensão maior ou igual que 60 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'LD_SUB_MT', N'Linha de Distribuição Subterrânea ou Submersa em tensão menor ou igual que 48 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'LD_SUB_AT', N'Linha de Distribuição Subterrânea ou Submersa em tensão maior ou igual que 60 kV')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'RD_AER_URB', N'Rede de Distribuição Aérea Urbana')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'RD_AER_RUR', N'Rede de Distribuição Aérea Rural')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'RD_SUBT_URB', N'Rede de Distribuição Subterrânea Urbana')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'RD_SUBT_RUR', N'Rede de Distribuição Subterrânea Rural')
INSERT [sde].[TINST] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'RD_SUBM', N'Rede de Distribuição Submersa')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'estrela / estrela aterrado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'delta / estrela aterrado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'estrela aterrado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'estrela aterrado / estrela aterrado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'delta / estrela / aterrado')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'h simples / x simples derivação')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'delta / delta')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'fase neutro')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'fase')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'estrela / estrela aterrado / delta')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'estrela / delta')
INSERT [sde].[TLIG] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'delta')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AR', N'Ar comprimido')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'EP', N'EPOXI')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'GA', N'Gas SF6')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'GV', N'GVO (grande volume de óleo)')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'ON', N'Óleo naftenico')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'OP', N'Óleo parafinico')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'PV', N'PVO (pequeno volume de óleo)')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'SE', N'Seco')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'SO', N'Sopro')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'VC', N'Vácuo')
INSERT [sde].[TMEIISO] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'VP', N'Vapor')
INSERT [sde].[TNOROPE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TNOROPE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'A', N'Aberta')
INSERT [sde].[TNOROPE] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'F', N'Fechada')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'I', N'Energia Injetada')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'IG', N'Energia Injetada de Geração')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'FML', N'Energia Fornecida ao Mercado Livre')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'FMC', N'Energia Fornecida ao Mercado Cativo')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'FOD', N'Energia Fornecida à Outras Distribuidoras')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'FRA', N'Energia Fornecida sem Rede Associada')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'IGD', N'Energia Injetada de Geração Distribuída REN 482/2012')
INSERT [sde].[TORGENER] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'IT', N'Energia Injetada Total')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'1', N'Diodo Emissor de Luz (LED)')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'2', N'Fluorescente de Indução Magnética')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'3', N'Fluorescente Compacta')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'4', N'Halógena')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'5', N'Incandescente')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'6', N'Mista')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'7', N'Multivapores metálicos')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'8', N'Vapor de Mercúrio')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'9', N'Vapor de Sódio')
INSERT [sde].[TPIP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'10', N'Outros')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'PIS', N'Ponto interno subestação')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'PSA', N'Ponto de saída de circuito de média tensão')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'PSU', N'Ponto subterrâneo')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'POS', N'Poste')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'TOR', N'Torre')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'PSE', N'Ponto de suporte de equipamento')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'PSB', N'Ponto de suporte de barramento')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'PEC', N'Ponto de entrada de condomínio')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'PMF', N'Ponto de medição de fronteira')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'FLT', N'Fly-tap')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'PFL', N'Ponto de fim de linha')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'CXP', N'Caixa de passagem')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'PON', N'Pontalete')
INSERT [sde].[TPONNOT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'DRV', N'Derivação')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'PD', N'Próprio distribuidor')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'OD', N'Outro distribuidor')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'T', N'Transmissor')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'G', N'Gerador')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'CS', N'Consumidor')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'CO', N'Cooperativa')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'A', N'Autorizado')
INSERT [sde].[TPOS] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'O', N'Outro agente')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'CB', N'Cabine')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'E', N'Estaleiro')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'PT', N'Poste')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'PL', N'Plataforma')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'CT', N'Câmara transformadora')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'PD', N'Pedestal')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'Q', N'Quiosque')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'CC', N'Cubículo blindado')
INSERT [sde].[TPOSTOTRAN] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'CH', N'Chão de Subestação')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Não informado')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (2, N'1', CAST(3.00000000 AS Numeric(38, 8)), N'3 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (3, N'2', CAST(5.00000000 AS Numeric(38, 8)), N'5 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (4, N'3', CAST(10.00000000 AS Numeric(38, 8)), N'10 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (5, N'4', CAST(15.00000000 AS Numeric(38, 8)), N'15 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (6, N'5', CAST(20.00000000 AS Numeric(38, 8)), N'20 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (7, N'6', CAST(22.50000000 AS Numeric(38, 8)), N'22,5 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (8, N'7', CAST(25.00000000 AS Numeric(38, 8)), N'25 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (9, N'8', CAST(30.00000000 AS Numeric(38, 8)), N'30 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (10, N'9', CAST(35.00000000 AS Numeric(38, 8)), N'35 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (11, N'10', CAST(37.50000000 AS Numeric(38, 8)), N'37,5 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (12, N'11', CAST(38.10000000 AS Numeric(38, 8)), N'38,1 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (13, N'12', CAST(40.00000000 AS Numeric(38, 8)), N'40 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (14, N'13', CAST(45.00000000 AS Numeric(38, 8)), N'45 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (15, N'14', CAST(50.00000000 AS Numeric(38, 8)), N'50 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (16, N'15', CAST(60.00000000 AS Numeric(38, 8)), N'60 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (17, N'16', CAST(75.00000000 AS Numeric(38, 8)), N'75 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (18, N'17', CAST(76.20000000 AS Numeric(38, 8)), N'76,2 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (19, N'18', CAST(88.00000000 AS Numeric(38, 8)), N'88 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (20, N'19', CAST(100.00000000 AS Numeric(38, 8)), N'100 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (21, N'20', CAST(112.50000000 AS Numeric(38, 8)), N'112,5 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (22, N'21', CAST(114.30000000 AS Numeric(38, 8)), N'114,3 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (23, N'22', CAST(120.00000000 AS Numeric(38, 8)), N'120 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (24, N'23', CAST(138.00000000 AS Numeric(38, 8)), N'138 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (25, N'24', CAST(150.00000000 AS Numeric(38, 8)), N'150 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (26, N'25', CAST(167.00000000 AS Numeric(38, 8)), N'167 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (27, N'26', CAST(175.00000000 AS Numeric(38, 8)), N'175 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (28, N'27', CAST(180.00000000 AS Numeric(38, 8)), N'180 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (29, N'28', CAST(200.00000000 AS Numeric(38, 8)), N'200 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (30, N'29', CAST(207.00000000 AS Numeric(38, 8)), N'207 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (31, N'30', CAST(225.00000000 AS Numeric(38, 8)), N'225 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (32, N'31', CAST(250.00000000 AS Numeric(38, 8)), N'250 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (33, N'32', CAST(276.00000000 AS Numeric(38, 8)), N'276 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (34, N'33', CAST(288.00000000 AS Numeric(38, 8)), N'288 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (35, N'34', CAST(300.00000000 AS Numeric(38, 8)), N'300 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (36, N'35', CAST(332.00000000 AS Numeric(38, 8)), N'332 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (37, N'36', CAST(333.00000000 AS Numeric(38, 8)), N'333 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (38, N'37', CAST(400.00000000 AS Numeric(38, 8)), N'400 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (39, N'38', CAST(414.00000000 AS Numeric(38, 8)), N'414 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (40, N'39', CAST(432.00000000 AS Numeric(38, 8)), N'432 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (41, N'40', CAST(500.00000000 AS Numeric(38, 8)), N'500 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (42, N'41', CAST(509.00000000 AS Numeric(38, 8)), N'509 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (43, N'42', CAST(667.00000000 AS Numeric(38, 8)), N'667 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (44, N'43', CAST(750.00000000 AS Numeric(38, 8)), N'750 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (45, N'44', CAST(833.00000000 AS Numeric(38, 8)), N'833 kVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (46, N'45', CAST(1000.00000000 AS Numeric(38, 8)), N'1 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (47, N'46', CAST(1250.00000000 AS Numeric(38, 8)), N'1,25 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (48, N'47', CAST(1300.00000000 AS Numeric(38, 8)), N'1,3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (49, N'48', CAST(1500.00000000 AS Numeric(38, 8)), N'1,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (50, N'49', CAST(1750.00000000 AS Numeric(38, 8)), N'1,75 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (51, N'50', CAST(2000.00000000 AS Numeric(38, 8)), N'2 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (52, N'51', CAST(2250.00000000 AS Numeric(38, 8)), N'2,25 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (53, N'52', CAST(2300.00000000 AS Numeric(38, 8)), N'2,3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (54, N'53', CAST(2400.00000000 AS Numeric(38, 8)), N'2,4 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (55, N'54', CAST(2500.00000000 AS Numeric(38, 8)), N'2,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (56, N'55', CAST(2750.00000000 AS Numeric(38, 8)), N'2,75 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (57, N'56', CAST(2900.00000000 AS Numeric(38, 8)), N'2,9 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (58, N'57', CAST(3000.00000000 AS Numeric(38, 8)), N'3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (59, N'58', CAST(3125.00000000 AS Numeric(38, 8)), N'3,125 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (60, N'59', CAST(3300.00000000 AS Numeric(38, 8)), N'3,3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (61, N'60', CAST(3750.00000000 AS Numeric(38, 8)), N'3,75 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (62, N'61', CAST(4000.00000000 AS Numeric(38, 8)), N'4 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (63, N'62', CAST(4200.00000000 AS Numeric(38, 8)), N'4,2 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (64, N'63', CAST(4500.00000000 AS Numeric(38, 8)), N'4,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (65, N'64', CAST(5000.00000000 AS Numeric(38, 8)), N'5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (66, N'65', CAST(6250.00000000 AS Numeric(38, 8)), N'6,25 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (67, N'66', CAST(6500.00000000 AS Numeric(38, 8)), N'6,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (68, N'67', CAST(7000.00000000 AS Numeric(38, 8)), N'7 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (69, N'68', CAST(7500.00000000 AS Numeric(38, 8)), N'7,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (70, N'69', CAST(7800.00000000 AS Numeric(38, 8)), N'7,8 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (71, N'70', CAST(8000.00000000 AS Numeric(38, 8)), N'8 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (72, N'71', CAST(9000.00000000 AS Numeric(38, 8)), N'9 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (73, N'72', CAST(9375.00000000 AS Numeric(38, 8)), N'9,375 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (74, N'73', CAST(9600.00000000 AS Numeric(38, 8)), N'9,6 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (75, N'74', CAST(10000.00000000 AS Numeric(38, 8)), N'10 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (76, N'75', CAST(12000.00000000 AS Numeric(38, 8)), N'12 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (77, N'76', CAST(12500.00000000 AS Numeric(38, 8)), N'12,5 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (78, N'77', CAST(13300.00000000 AS Numeric(38, 8)), N'13,3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (79, N'78', CAST(15000.00000000 AS Numeric(38, 8)), N'15 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (80, N'79', CAST(16000.00000000 AS Numeric(38, 8)), N'16 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (81, N'80', CAST(18000.00000000 AS Numeric(38, 8)), N'18 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (82, N'81', CAST(18750.00000000 AS Numeric(38, 8)), N'18,75 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (83, N'82', CAST(20000.00000000 AS Numeric(38, 8)), N'20 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (84, N'83', CAST(25000.00000000 AS Numeric(38, 8)), N'25 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (85, N'84', CAST(26000.00000000 AS Numeric(38, 8)), N'26 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (86, N'85', CAST(26600.00000000 AS Numeric(38, 8)), N'26,6 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (87, N'86', CAST(28000.00000000 AS Numeric(38, 8)), N'28 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (88, N'87', CAST(30000.00000000 AS Numeric(38, 8)), N'30 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (89, N'88', CAST(32000.00000000 AS Numeric(38, 8)), N'32 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (90, N'89', CAST(33000.00000000 AS Numeric(38, 8)), N'33 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (91, N'90', CAST(33300.00000000 AS Numeric(38, 8)), N'33,3 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (92, N'91', CAST(40000.00000000 AS Numeric(38, 8)), N'40 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (93, N'92', CAST(45000.00000000 AS Numeric(38, 8)), N'45 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (94, N'93', CAST(50000.00000000 AS Numeric(38, 8)), N'50 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (95, N'94', CAST(60000.00000000 AS Numeric(38, 8)), N'60 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (96, N'95', CAST(67000.00000000 AS Numeric(38, 8)), N'67 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (97, N'96', CAST(75000.00000000 AS Numeric(38, 8)), N'75 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (98, N'97', CAST(80000.00000000 AS Numeric(38, 8)), N'80 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (99, N'98', CAST(83000.00000000 AS Numeric(38, 8)), N'83 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (100, N'99', CAST(85000.00000000 AS Numeric(38, 8)), N'85 MVA')
GO
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (101, N'100', CAST(90000.00000000 AS Numeric(38, 8)), N'90 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (102, N'101', CAST(100000.00000000 AS Numeric(38, 8)), N'100 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (103, N'102', CAST(200000.00000000 AS Numeric(38, 8)), N'200 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (104, N'103', CAST(14550000.00000000 AS Numeric(38, 8)), N'14550 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (105, N'104', CAST(17320000.00000000 AS Numeric(38, 8)), N'17320 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (106, N'105', CAST(19100000.00000000 AS Numeric(38, 8)), N'19100 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (107, N'106', CAST(41550000.00000000 AS Numeric(38, 8)), N'41550 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (108, N'107', CAST(300000.00000000 AS Numeric(38, 8)), N'300 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (109, N'108', CAST(400000.00000000 AS Numeric(38, 8)), N'400 MVA')
INSERT [sde].[TPOTAPRT] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (110, N'109', CAST(500000.00000000 AS Numeric(38, 8)), N'500 MVA')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Não informado')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (2, N'1', CAST(45.00000000 AS Numeric(38, 8)), N'45 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (3, N'2', CAST(75.00000000 AS Numeric(38, 8)), N'75 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (4, N'3', CAST(100.00000000 AS Numeric(38, 8)), N'100 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (5, N'4', CAST(150.00000000 AS Numeric(38, 8)), N'150 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (6, N'5', CAST(200.00000000 AS Numeric(38, 8)), N'200 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (7, N'6', CAST(300.00000000 AS Numeric(38, 8)), N'300 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (8, N'7', CAST(400.00000000 AS Numeric(38, 8)), N'400 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (9, N'8', CAST(450.00000000 AS Numeric(38, 8)), N'450 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (10, N'9', CAST(500.00000000 AS Numeric(38, 8)), N'500 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (11, N'10', CAST(600.00000000 AS Numeric(38, 8)), N'600 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (12, N'11', CAST(900.00000000 AS Numeric(38, 8)), N'900 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (13, N'12', CAST(1200.00000000 AS Numeric(38, 8)), N'1200 kVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (14, N'13', CAST(1512.00000000 AS Numeric(38, 8)), N'1,512 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (15, N'14', CAST(1800.00000000 AS Numeric(38, 8)), N'1,8 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (16, N'15', CAST(2016.00000000 AS Numeric(38, 8)), N'2,016 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (17, N'16', CAST(2400.00000000 AS Numeric(38, 8)), N'2,4 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (18, N'17', CAST(3000.00000000 AS Numeric(38, 8)), N'3 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (19, N'18', CAST(3600.00000000 AS Numeric(38, 8)), N'3,6 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (20, N'19', CAST(4800.00000000 AS Numeric(38, 8)), N'4,8 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (21, N'20', CAST(5400.00000000 AS Numeric(38, 8)), N'5,4 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (22, N'21', CAST(6000.00000000 AS Numeric(38, 8)), N'6 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (23, N'22', CAST(7200.00000000 AS Numeric(38, 8)), N'7,2 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (24, N'23', CAST(8400.00000000 AS Numeric(38, 8)), N'8,4 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (25, N'24', CAST(9000.00000000 AS Numeric(38, 8)), N'9 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (26, N'25', CAST(10500.00000000 AS Numeric(38, 8)), N'10,5 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (27, N'26', CAST(14000.00000000 AS Numeric(38, 8)), N'14 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (28, N'27', CAST(15000.00000000 AS Numeric(38, 8)), N'15 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (29, N'28', CAST(30000.00000000 AS Numeric(38, 8)), N'30 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (30, N'29', CAST(4500.00000000 AS Numeric(38, 8)), N'4,5 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (31, N'30', CAST(10000.00000000 AS Numeric(38, 8)), N'10 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (32, N'31', CAST(18000.00000000 AS Numeric(38, 8)), N'18 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (33, N'32', CAST(21000.00000000 AS Numeric(38, 8)), N'21 MVAr')
INSERT [sde].[TPOTRTV] ([OBJECTID], [COD_ID], [POT], [DESCR]) VALUES (34, N'33', CAST(36000.00000000 AS Numeric(38, 8)), N'36 MVAr')
INSERT [sde].[TREGU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TREGU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'M', N'Monofásico')
INSERT [sde].[TREGU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'T', N'Trifásico')
INSERT [sde].[TREGU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'DA', N'Delta aberto')
INSERT [sde].[TREGU] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'DF', N'Delta fechado')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'5X10-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'10X20-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'15X30-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'20X40-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'25X50-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'25X50X100-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'50X100-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'75X150-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'100X200-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'125X250-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'150X300-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'200X400-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'13', N'250X500-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'14', N'300X600-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'15', N'350X700-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'16', N'400X800-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'17', N'500X1000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'18', N'600X1200-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'19', N'800X1600-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'20', N'1000X2000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'21', N'2250X2500-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'22', N'5-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'23', N'10-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'24', N'15-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (26, N'25', N'20-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (27, N'26', N'25-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (28, N'27', N'30-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (29, N'28', N'40-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (30, N'29', N'50-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (31, N'30', N'60-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (32, N'31', N'75-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (33, N'32', N'100-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (34, N'33', N'150-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (35, N'34', N'200-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (36, N'35', N'250-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (37, N'36', N'300-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (38, N'37', N'350-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (39, N'38', N'400-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (40, N'39', N'500-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (41, N'40', N'600-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (42, N'41', N'800-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (43, N'42', N'1000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (44, N'43', N'1200-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (45, N'44', N'1250-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (46, N'45', N'1500-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (47, N'46', N'1600-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (48, N'47', N'2000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (49, N'48', N'2500-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (50, N'49', N'3000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (51, N'50', N'4000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (52, N'51', N'5000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (53, N'52', N'6000-5 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (54, N'53', N'100-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (55, N'54', N'150-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (56, N'55', N'200-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (57, N'56', N'219-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (58, N'57', N'250-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (59, N'58', N'300-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (60, N'59', N'438-0,2 A')
INSERT [sde].[TRELTC] ([OBJECTID], [COD_ID], [DESCR]) VALUES (61, N'60', N'2000x1200-5 A')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'1', N'138/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'2', N'69/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'3', N'34,5/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'4', N'25/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'5', N'24900:240 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'6', N'23/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'7', N'14400:127 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'8', N'14400:124 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'9', N'14400:120 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (11, N'10', N'14,4/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (12, N'11', N'13800:127 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (13, N'12', N'13800:124 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (14, N'13', N'13800:120 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (15, N'14', N'13800:118 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (16, N'15', N'13,8/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (17, N'16', N'7600:120 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (18, N'17', N'7,6/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (19, N'18', N'92/√3 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (20, N'19', N'34,5 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (21, N'20', N'25 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (22, N'21', N'23 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (23, N'22', N'14,4 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (24, N'23', N'13,8 kV / 115 V / 115/√3 V')
INSERT [sde].[TRELTP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (25, N'24', N'7,6 kV / 115 V / 115/√3 V')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Cabos com resistências não previstas.')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (2, N'AL6AWG', CAST(2.46900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 6 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (3, N'AL4AWG', CAST(1.55100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 4 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (4, N'AL3AWG', CAST(1.22900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 3 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (5, N'AL2AWG', CAST(0.97500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 2 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (6, N'AL1AWG', CAST(0.77400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 1 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (7, N'AL1_0AWG', CAST(0.61300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 1/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (8, N'AL2_0AWG', CAST(0.48600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 2/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (9, N'AL3_0AWG', CAST(0.38600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 3/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (10, N'AL4_0AWG', CAST(0.30600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 4/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (11, N'AL250AWG', CAST(0.25900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 250 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (12, N'AL266_8AWG', CAST(0.24500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 266,8 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (13, N'AL300AWG', CAST(0.21700000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 300 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (14, N'AL336_4AWG', CAST(0.19500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 336,4 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (15, N'AL350AWG', CAST(0.18500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 350 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (16, N'AL397_5AWG', CAST(0.16500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 397,5 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (17, N'AL450AWG', CAST(0.14500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 450 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (18, N'AL477AWG', CAST(0.13800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 477 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (19, N'AL500AWG', CAST(0.13100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 500 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (20, N'AL556_5AWG', CAST(0.11900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio (CA e CAA) - 556,5 MCM')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (21, N'ALI10MM2', CAST(3.51400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 10 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (22, N'ALI16MM2', CAST(2.17900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 16 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (23, N'ALI25MM2', CAST(1.36900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 25 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (24, N'ALI35MM2', CAST(0.99100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 35 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (25, N'ALI50MM2', CAST(0.73200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 50 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (26, N'ALI70MM2', CAST(0.50600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 70 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (27, N'ALI95MM2', CAST(0.36500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 95 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (28, N'ALI120MM2', CAST(0.28900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 120 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (29, N'ALI150MM2', CAST(0.23600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 150 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (30, N'ALI185MM2', CAST(0.18800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 185 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (31, N'ALI240MM2', CAST(0.14300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 240 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (32, N'ALI300MM2', CAST(0.11500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de alumínio cobertos e isolados - 300 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (33, N'CUM0_5MM2', CAST(40.95200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 0,5 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (34, N'CUM0_75MM2', CAST(27.87000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 0,75 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (35, N'CUM1MM2', CAST(20.59000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (36, N'CUM1_5MM2', CAST(13.76400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1,5 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (37, N'CUM2_5MM2', CAST(8.42900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 2,5 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (38, N'CUM4MM2', CAST(5.24400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 4 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (39, N'CUM6MM2', CAST(3.50400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 6 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (40, N'CUM10MM2', CAST(2.08200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 10 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (41, N'CUM16MM2', CAST(1.30800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 16 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (42, N'CUM25MM2', CAST(0.82700000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 25 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (43, N'CUM35MM2', CAST(0.59600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 35 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (44, N'CUM50MM2', CAST(0.44100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 50 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (45, N'CUM70MM2', CAST(0.30500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 70 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (46, N'CUM95MM2', CAST(0.22000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 95 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (47, N'CUM120MM2', CAST(0.17500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 120 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (48, N'CUM150MM2', CAST(0.14200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 150 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (49, N'CUM185MM2', CAST(0.11400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 185 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (50, N'CUM240MM2', CAST(0.08700000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 240 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (51, N'CUM300MM2', CAST(0.07000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 300 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (52, N'CUM400MM2', CAST(0.05600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 400 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (53, N'CUM500MM2', CAST(0.04400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 500 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (54, N'CUM630MM2', CAST(0.03600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 630 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (55, N'CUM800MM2', CAST(0.02900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 800 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (56, N'CUM1000MM2', CAST(0.02500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1000 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (57, N'CUM1200MM2', CAST(0.02200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1200 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (58, N'CUM1400MM2', CAST(0.02000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1400 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (59, N'CUM1600MM2', CAST(0.01900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1600 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (60, N'CUM1800MM2', CAST(0.01700000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 1800 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (61, N'CUM2000MM2', CAST(0.01600000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre métricos - 2000 mm2')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (62, N'CU10AWG', CAST(3.75400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 10 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (63, N'CU9AWG', CAST(2.95800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 9 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (64, N'CU8AWG', CAST(2.38900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 8 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (65, N'CU7AWG', CAST(1.82000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 7 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (66, N'CU6AWG', CAST(1.56400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 6 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (67, N'CU5AWG', CAST(1.13800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 5 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (68, N'CU4AWG', CAST(0.98400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 4 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (69, N'CU3AWG', CAST(0.78000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 3 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (70, N'CU2AWG', CAST(0.62000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 2 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (71, N'CU1AWG', CAST(0.49100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 1 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (72, N'CU1_0AWG', CAST(0.38900000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 1/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (73, N'CU2_0AWG', CAST(0.30800000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 2/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (74, N'CU3_0AWG', CAST(0.24500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 3/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (75, N'CU4_0AWG', CAST(0.19500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de cobre - 4/0 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (76, N'AZN1X3_09MM', CAST(29.14200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço zincado - 1 x 3,09 mm')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (77, N'AZN3X2_25MM', CAST(18.32500000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço zincado - 3 x 2,25 mm')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (78, N'AZN5X6MM', CAST(11.41100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço zincado - 5 x 6 mm')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (79, N'AAL7X9AWG', CAST(2.10000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 9 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (80, N'AAL7X8AWG', CAST(1.67300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 8 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (81, N'AAL7X7AWG', CAST(1.32000000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 7 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (82, N'AAL7X6AWG', CAST(1.04700000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 6 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (83, N'AAL7X5AWG', CAST(0.83300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 5 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (84, N'AAL7X10AWG', CAST(2.65100000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 7 x 10 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (85, N'AAL3X9AWG', CAST(4.87300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 9 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (86, N'AAL3X8AWG', CAST(3.88300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 8 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (87, N'AAL3X7AWG', CAST(3.06400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 7 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (88, N'AAL3X6AWG', CAST(2.43200000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 6 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (89, N'AAL3X5AWG', CAST(1.93400000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 5 AWG')
INSERT [sde].[TRESREGUL] ([OBJECTID], [COD_ID], [RES_REGUL], [DESCR]) VALUES (90, N'AAL3X10AWG', CAST(6.15300000 AS Numeric(38, 8)), N'Resistência métrica do cabo de aço aluminizado - 3 x 10 AWG')
INSERT [sde].[TSITATI] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não aplicável')
INSERT [sde].[TSITATI] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AT', N'Ativada')
INSERT [sde].[TSITATI] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'DS', N'Desativada')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'AT1', N'Existente no campo e na contabilidade')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'AT2', N'Inexistente no campo e existente na contabilidade')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'SF', N'Sobra Física')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'AL', N'Em trânsito ou almoxarifado')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'BOP', N'Baixado Operacional')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'NIM', N'Não Imobilizado')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'NOP', N'Não Operacional')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (9, N'COM', N'Componente Menor ou UAR Secundária')
INSERT [sde].[TSITCONT] ([OBJECTID], [COD_ID], [DESCR]) VALUES (10, N'RT', N'Reserva Técnica')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'A1', N'Subgrupo A1 - tensão de fornecimento igual ou superior a 230 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'A2A', N'Subgrupo A2 - tensão de fornecimento de 138 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'A2B', N'Subgrupo A2 - tensão de fornecimento de 88 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'A3', N'Subgrupo A3 - tensão de fornecimento de 69 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'A3A', N'Subgrupo A3a - tensão de fornecimento de 30 kV a 44 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'A4', N'Subgrupo A4 - tensão de fornecimento de 2,3 kV a 25 kV')
INSERT [sde].[TSUBGRP] ([OBJECTID], [COD_ID], [DESCR]) VALUES (8, N'B', N'Subgrupo B1 - residencial')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (1, N'0', CAST(0.00000000 AS Numeric(38, 8)), N'Não informado')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (2, N'1', CAST(110.00000000 AS Numeric(38, 8)), N'110 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (3, N'2', CAST(115.00000000 AS Numeric(38, 8)), N'115 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (4, N'3', CAST(120.00000000 AS Numeric(38, 8)), N'120 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (5, N'4', CAST(121.00000000 AS Numeric(38, 8)), N'121 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (6, N'5', CAST(125.00000000 AS Numeric(38, 8)), N'125 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (7, N'6', CAST(127.00000000 AS Numeric(38, 8)), N'127 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (8, N'7', CAST(208.00000000 AS Numeric(38, 8)), N'208 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (9, N'8', CAST(216.00000000 AS Numeric(38, 8)), N'216 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (10, N'9', CAST(216.50000000 AS Numeric(38, 8)), N'216,5 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (11, N'10', CAST(220.00000000 AS Numeric(38, 8)), N'220 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (12, N'11', CAST(230.00000000 AS Numeric(38, 8)), N'230 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (13, N'12', CAST(231.00000000 AS Numeric(38, 8)), N'231 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (14, N'13', CAST(240.00000000 AS Numeric(38, 8)), N'240 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (15, N'14', CAST(254.00000000 AS Numeric(38, 8)), N'254 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (16, N'15', CAST(380.00000000 AS Numeric(38, 8)), N'380 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (17, N'16', CAST(400.00000000 AS Numeric(38, 8)), N'400 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (18, N'17', CAST(440.00000000 AS Numeric(38, 8)), N'440 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (19, N'18', CAST(480.00000000 AS Numeric(38, 8)), N'480 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (20, N'19', CAST(500.00000000 AS Numeric(38, 8)), N'500 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (21, N'20', CAST(600.00000000 AS Numeric(38, 8)), N'600 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (22, N'21', CAST(750.00000000 AS Numeric(38, 8)), N'750 V')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (23, N'22', CAST(1000.00000000 AS Numeric(38, 8)), N'1 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (24, N'23', CAST(2300.00000000 AS Numeric(38, 8)), N'2,3 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (25, N'24', CAST(3200.00000000 AS Numeric(38, 8)), N'3,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (26, N'25', CAST(3600.00000000 AS Numeric(38, 8)), N'3,6 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (27, N'26', CAST(3785.00000000 AS Numeric(38, 8)), N'3,785 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (28, N'27', CAST(3800.00000000 AS Numeric(38, 8)), N'3,8 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (29, N'28', CAST(3848.00000000 AS Numeric(38, 8)), N'3,848 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (30, N'29', CAST(3985.00000000 AS Numeric(38, 8)), N'3,985 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (31, N'30', CAST(4160.00000000 AS Numeric(38, 8)), N'4,16 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (32, N'31', CAST(4200.00000000 AS Numeric(38, 8)), N'4,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (33, N'32', CAST(4207.00000000 AS Numeric(38, 8)), N'4,207 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (34, N'33', CAST(4368.00000000 AS Numeric(38, 8)), N'4,368 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (35, N'34', CAST(4560.00000000 AS Numeric(38, 8)), N'4,56 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (36, N'35', CAST(5000.00000000 AS Numeric(38, 8)), N'5 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (37, N'36', CAST(6000.00000000 AS Numeric(38, 8)), N'6 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (38, N'37', CAST(6600.00000000 AS Numeric(38, 8)), N'6,6 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (39, N'38', CAST(6930.00000000 AS Numeric(38, 8)), N'6,93 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (40, N'39', CAST(7960.00000000 AS Numeric(38, 8)), N'7,96 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (41, N'40', CAST(8670.00000000 AS Numeric(38, 8)), N'8,67 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (42, N'41', CAST(11400.00000000 AS Numeric(38, 8)), N'11,4 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (43, N'42', CAST(11900.00000000 AS Numeric(38, 8)), N'11,9 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (44, N'43', CAST(12000.00000000 AS Numeric(38, 8)), N'12 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (45, N'44', CAST(12600.00000000 AS Numeric(38, 8)), N'12,6 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (46, N'45', CAST(12700.00000000 AS Numeric(38, 8)), N'12,7 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (47, N'46', CAST(13200.00000000 AS Numeric(38, 8)), N'13,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (48, N'47', CAST(13337.00000000 AS Numeric(38, 8)), N'13,337 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (49, N'48', CAST(13530.00000000 AS Numeric(38, 8)), N'13,53 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (50, N'49', CAST(13800.00000000 AS Numeric(38, 8)), N'13,8 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (51, N'50', CAST(13860.00000000 AS Numeric(38, 8)), N'13,86 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (52, N'51', CAST(14140.00000000 AS Numeric(38, 8)), N'14,14 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (53, N'52', CAST(14190.00000000 AS Numeric(38, 8)), N'14,19 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (54, N'53', CAST(14400.00000000 AS Numeric(38, 8)), N'14,4 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (55, N'54', CAST(14835.00000000 AS Numeric(38, 8)), N'14,835 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (56, N'55', CAST(15000.00000000 AS Numeric(38, 8)), N'15 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (57, N'56', CAST(15200.00000000 AS Numeric(38, 8)), N'15,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (58, N'57', CAST(19053.00000000 AS Numeric(38, 8)), N'19,053 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (59, N'58', CAST(19919.00000000 AS Numeric(38, 8)), N'19,919 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (60, N'59', CAST(21000.00000000 AS Numeric(38, 8)), N'21 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (61, N'60', CAST(21500.00000000 AS Numeric(38, 8)), N'21,5 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (62, N'61', CAST(22000.00000000 AS Numeric(38, 8)), N'22 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (63, N'62', CAST(23000.00000000 AS Numeric(38, 8)), N'23 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (64, N'63', CAST(23100.00000000 AS Numeric(38, 8)), N'23,1 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (65, N'64', CAST(23827.00000000 AS Numeric(38, 8)), N'23,827 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (66, N'65', CAST(24000.00000000 AS Numeric(38, 8)), N'24 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (67, N'66', CAST(24200.00000000 AS Numeric(38, 8)), N'24,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (68, N'67', CAST(25000.00000000 AS Numeric(38, 8)), N'25 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (69, N'68', CAST(25800.00000000 AS Numeric(38, 8)), N'25,8 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (70, N'69', CAST(27000.00000000 AS Numeric(38, 8)), N'27 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (71, N'70', CAST(30000.00000000 AS Numeric(38, 8)), N'30 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (72, N'71', CAST(33000.00000000 AS Numeric(38, 8)), N'33 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (73, N'72', CAST(34500.00000000 AS Numeric(38, 8)), N'34,5 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (74, N'73', CAST(36000.00000000 AS Numeric(38, 8)), N'36 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (75, N'74', CAST(38000.00000000 AS Numeric(38, 8)), N'38 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (76, N'75', CAST(40000.00000000 AS Numeric(38, 8)), N'40 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (77, N'76', CAST(44000.00000000 AS Numeric(38, 8)), N'44 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (78, N'77', CAST(45000.00000000 AS Numeric(38, 8)), N'45 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (79, N'78', CAST(45400.00000000 AS Numeric(38, 8)), N'45,4 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (80, N'79', CAST(48000.00000000 AS Numeric(38, 8)), N'48 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (81, N'80', CAST(60000.00000000 AS Numeric(38, 8)), N'60 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (82, N'81', CAST(66000.00000000 AS Numeric(38, 8)), N'66 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (83, N'82', CAST(69000.00000000 AS Numeric(38, 8)), N'69 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (84, N'83', CAST(72500.00000000 AS Numeric(38, 8)), N'72,5 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (85, N'84', CAST(88000.00000000 AS Numeric(38, 8)), N'88 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (86, N'85', CAST(88200.00000000 AS Numeric(38, 8)), N'88,2 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (87, N'86', CAST(92000.00000000 AS Numeric(38, 8)), N'92 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (88, N'87', CAST(100000.00000000 AS Numeric(38, 8)), N'100 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (89, N'88', CAST(120000.00000000 AS Numeric(38, 8)), N'120 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (90, N'89', CAST(121000.00000000 AS Numeric(38, 8)), N'121 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (91, N'90', CAST(123000.00000000 AS Numeric(38, 8)), N'123 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (92, N'91', CAST(131600.00000000 AS Numeric(38, 8)), N'131,6 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (93, N'92', CAST(131630.00000000 AS Numeric(38, 8)), N'131,63 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (94, N'93', CAST(131635.00000000 AS Numeric(38, 8)), N'131,635 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (95, N'94', CAST(138000.00000000 AS Numeric(38, 8)), N'138 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (96, N'95', CAST(145000.00000000 AS Numeric(38, 8)), N'145 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (97, N'96', CAST(230000.00000000 AS Numeric(38, 8)), N'230 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (98, N'97', CAST(345000.00000000 AS Numeric(38, 8)), N'345 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (99, N'98', CAST(500000.00000000 AS Numeric(38, 8)), N'500 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (100, N'99', CAST(750000.00000000 AS Numeric(38, 8)), N'750 kV')
GO
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (101, N'100', CAST(1000000.00000000 AS Numeric(38, 8)), N'1000 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (102, N'101', CAST(245000.00000000 AS Numeric(38, 8)), N'245 kV')
INSERT [sde].[TTEN] ([OBJECTID], [COD_ID], [TEN], [DESCR]) VALUES (103, N'102', CAST(550000.00000000 AS Numeric(38, 8)), N'550 kV')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (1, N'0', N'Não informado')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (2, N'M', N'Monofásico')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (3, N'B', N'Bifásico')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (4, N'T', N'Trifásico')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (5, N'MT', N'Monofásico a três fios')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (6, N'DA', N'Delta aberto')
INSERT [sde].[TTRANF] ([OBJECTID], [COD_ID], [DESCR]) VALUES (7, N'DF', N'Delta fechado')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (1, N'125-01', N'Principal', N'EQCR', N'banco de capacitores')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (2, N'125-04', N'Não Cadastrável', NULL, N'relé de controle')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (3, N'125-05', N'Não Cadastrável', NULL, N'transformador de potencial capacitivo de classe de tensão superior a 6Kv')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (4, N'125-07', N'Não Cadastrável', NULL, N'reator de amortecimento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (5, N'125-08', N'Não Cadastrável', NULL, N'transformador de corrente')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (6, N'130-01', N'Principal', N'EQCR', N'banco de capacitores')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (7, N'130-03', N'Não Cadastrável', NULL, N'conjunto de capacitores de uma fase')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (8, N'130-04', N'Só Dados Técnicos', N'EQSE', N'disjuntor (exceto termomagnético)')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (9, N'130-08', N'Não Cadastrável', NULL, N'reator de amortecimento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (10, N'130-09', N'Não Cadastrável', NULL, N'transformador de corrente de classe de tensão superior a 6kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (11, N'130-10', N'Não Cadastrável', NULL, N'transformador de potencial de classe de tensão superior a 6kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (12, N'130-14', N'Não Cadastrável', NULL, N'dispositivo de proteção')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (13, N'135-01', N'Principal', N'BAR', N'conjunto de barramento(s) de mesmo nível de classe de tensão')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (14, N'160-01', N'Principal', N'EQSE', N'Uma chave com classe de tensão igual ou superior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (15, N'160-06', N'Principal', N'EQSE', N'Um módulo seccionador SF6 com classe de tensão igual ou superior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (16, N'160-07', N'Não Cadastrável', NULL, N'Um transformador de medida (TP ou TC) quando integrante de Módulo SF6 com classe de tensão igual ou superior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (17, N'160-14', N'Principal', N'EQSE', N'Uma chave com classe de tensão inferior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (18, N'160-15', N'Principal', N'EQSE', N'Um módulo seccionador SF6 com classe de tensão inferior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (19, N'160-16', N'Não Cadastrável', NULL, N'Um transformador de medida (TP ou TC) quando integrante de Módulo SF6 com classe de tensão inferior a 34,5kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (20, N'190-01', N'Principal', N'SEGCON', N'Uma quantidade igual ou superior a um vão (cada fase) para todos os tipos de condutores. Considera-se um vão a distância entre duas estruturas, entre duas caixas de passagem e entre uma estrutura e o ponto de entrega ao consumidor (ramal de serviço).')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (21, N'190-02', N'Não Cadastrável', NULL, N'um conjunto de cadeias de isoladores de mesma classe tensão, tipo, material e composição igual ou superior a 69 kV, em uma mesma estrutura.')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (22, N'210-01', N'Principal', N'EQSE', N'Um disjuntor')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (23, N'210-07', N'Não Cadastrável', NULL, N'Um relé de controle de disjuntor, quando integrante do Módulo SF6')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (24, N'210-09', N'Não Cadastrável', NULL, N'Uma chave tripolar integrante de módulo SF6')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (25, N'210-10', N'Não Cadastrável', NULL, N'transformador de medida (TC ou TP) quando integrante do Módulo SF6')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (26, N'255-01', N'Principal', N'PONNOT', N'Poste')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (27, N'255-02', N'Principal', N'PONNOT', N'Torre')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (28, N'265-01', N'Principal', N'PONNOT', N'estrutura suporte de equipamento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (29, N'265-02', N'Principal', N'PONNOT', N'estrutura suporte de barramento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (30, N'295-01', N'Principal', N'EQME', N'Medidor')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (31, N'295-02', N'Principal', N'EQME', N'concentrador primário')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (32, N'295-03', N'Principal', N'EQME', N'concentrador secundário')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (33, N'295-04', N'Não Cadastrável', NULL, N'módulo de medição criar')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (34, N'295-05', N'Não Cadastrável', NULL, N'módulo de telecomunicação')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (35, N'295-06', N'Secundário', N'EQME', N'módulo de display')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (36, N'295-07', N'Não Cadastrável', NULL, N'módulo de corte-religa')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (37, N'305-01', N'Não Cadastrável', NULL, N'Painel')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (38, N'305-02', N'Não Cadastrável', NULL, N'mesa de comando')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (39, N'305-03', N'Não Cadastrável', NULL, N'Cubículo')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (40, N'305-06', N'Não Cadastrável', NULL, N'transformador de potencial para tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (41, N'305-07', N'Não Cadastrável', NULL, N'transformador de corrente para tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (42, N'305-08', N'Só Dados Técnicos', N'EQSE', N'chave seccionadora de classe de tensão igual ou superior a 15 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (43, N'305-11', N'Não Cadastrável', NULL, N'relé principal')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (44, N'305-12', N'Não Cadastrável', NULL, N'regulador de tensão de potência igual ou superior a 10 kVA')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (45, N'305-16', N'Só Dados Técnicos', N'EQTRMT, EQTRAT', N'transformador de potência aparente igual ou superior a 10 kVA')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (46, N'305-33', N'Só Dados Técnicos', N'EQSE', N'disjuntor (exceto termomagnético)')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (47, N'305-35', N'Não Cadastrável', NULL, N'Medidor')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (48, N'305-40', N'Não Cadastrável', NULL, N'Reator')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (49, N'325-01', N'Principal', N'EQSE', N'protetor de rede')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (50, N'325-02', N'Não Cadastrável', NULL, N'Relé do protetor de rede')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (51, N'330-01', N'Principal', N'EQCR', N'reator (ou resistor)')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (52, N'330-07', N'Não Cadastrável', NULL, N'relé de gás')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (53, N'340-01', N'Principal', N'EQRE', N'regulador de tensão de potência igual ou superior a 69kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (54, N'340-03', N'Não Cadastrável', NULL, N'relé regulador de tensão')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (55, N'340-05', N'Não Cadastrável', NULL, N'relé de gás')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (56, N'340-09', N'Principal', N'EQRE', N'regulador de tensão inferior a 69kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (57, N'345-01', N'Principal', N'EQSE', N'Religador')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (58, N'345-02', N'Não Cadastrável', NULL, N'relé controlador de religador')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (59, N'395-01', N'Não Cadastrável', NULL, N'sistema de aterramento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (60, N'540-01', N'Principal', N'EQTRAT', N'subestação SF6')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (61, N'540-02', N'Só Dados Técnicos', N'EQSE', N'disjuntor')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (62, N'540-03', N'Só Dados Técnicos', N'EQSE', N'chave de classe de tensão igual ou superior a 15 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (63, N'540-04', N'Secundária', N'EQTRAT', N'transformador de força')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (64, N'540-05', N'Não Cadastrável', NULL, N'transformador de serviço auxiliar')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (65, N'540-06', N'Não Cadastrável', NULL, N'transformador de potencial de classe de tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (66, N'540-07', N'Não Cadastrável', NULL, N'transformador de corrente de classe de tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (67, N'540-08', N'Só Dados Técnicos', N'BAR', N'barramento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (68, N'545-01', N'Principal', N'EQTRAT, EQTRMT', N'subestação blindada')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (69, N'545-02', N'Não Cadastrável', NULL, N'transformador de serviço auxiliar')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (70, N'545-03', N'Principal', N'EQTRAT, EQTRMT', N'subestação móvel')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (71, N'545-04', N'Secundária', N'EQTRAT, EQTRMT', N'transformador de força')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (72, N'545-05', N'Não Cadastrável', NULL, N'transformador de potencial de classe de tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (73, N'545-06', N'Não Cadastrável', NULL, N'transformador de corrente de classe de tensão superior a 6 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (74, N'545-07', N'Só Dados Técnicos', N'EQSE', N'disjuntor')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (75, N'545-08', N'Só Dados Técnicos', N'EQSE', N'chave de classe de tensão igual ou superior a 15 kV')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (76, N'545-09', N'Só Dados Técnicos', N'EQSE', N'Religador')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (77, N'565-01', N'Principal', N'EQTRMT', N'transformador de distribuição')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (78, N'570-01', N'Principal', N'EQTRAT, EQTRMT', N'transformador de força ou um autotransformador')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (79, N'570-10', N'Não Cadastrável', NULL, N'relé regulador de tensão')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (80, N'575-01', N'Principal', N'EQTRM', N'conjunto de medição (TP e TC conjugados ou TP, TC e medidor conjugados)')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (81, N'575-02', N'Principal', N'EQTRM', N'transformador de potencial')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (82, N'575-03', N'Principal', N'EQTRM', N'transformador de corrente')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (83, N'575-04', N'Não Cadastrável', NULL, N'transformador de defasamento')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (84, N'575-05', N'Principal', N'EQTRM', N'transformador de potencial capacitivo')
INSERT [sde].[TUAR] ([OBJECTID], [COD_ID], [TIPO], [ENTIDADE], [DESCR]) VALUES (85, N'580-01', N'Não Cadastrável', NULL, N'transformador de serviços auxiliares')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (1, N'0', N'0', N'Não informado')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (2, N'1', N'Medidor', N'Comparador / fiscal e concentrador')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (3, N'2', N'Medidor', N'Medidor eletromecânico')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (4, N'3', N'Medidor', N'Medidor eletrônico')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (5, N'4', N'Relé', N'79 (rele de religamento)')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (6, N'5', N'Relé', N'CTPN (chave de transferência da posição de neutro)')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (7, N'6', N'Relé', N'Disparo para terra')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (8, N'7', N'Relé', N'RAI (Rele de alta impedância)')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (9, N'8', N'Sistema de Aterramento', N'Sistema de aterramento')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (10, N'9', N'Unidade Compensadora de Reativo', N'Banco de capacitor serial e paralelo')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (11, N'10', N'Unidade Compensadora de Reativo', N'Banco de capacitores paralelo')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (12, N'11', N'Unidade Compensadora de Reativo', N'Banco de capacitores serial')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (13, N'12', N'Unidade Compensadora de Reativo', N'Compensador de reativos')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (14, N'13', N'Unidade Reguladora', N'Auto booster')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (15, N'14', N'Unidade Reguladora', N'Regulador automático de tensão')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (16, N'15', N'Unidade Seccionadora', N'Abertura de jumper')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (17, N'16', N'Unidade Seccionadora', N'Chave a gás')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (18, N'17', N'Unidade Seccionadora', N'Chave a óleo')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (19, N'18', N'Unidade Seccionadora', N'Chave de transferência automática')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (20, N'19', N'Unidade Seccionadora', N'Chave faca')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (21, N'20', N'Unidade Seccionadora', N'Chave faca tripolar abertura com carga')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (22, N'21', N'Unidade Seccionadora', N'Chave faca unipolar abertura com carga')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (23, N'22', N'Unidade Seccionadora', N'Chave fusível')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (24, N'23', N'Unidade Seccionadora', N'Chave fusível abertura com carga com aterramento')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (25, N'24', N'Unidade Seccionadora', N'Chave fusível abertura sem carga')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (26, N'25', N'Unidade Seccionadora', N'Chave fusível abertura sem carga com aterramento')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (27, N'26', N'Unidade Seccionadora', N'Chave fusível lamina')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (28, N'27', N'Unidade Seccionadora', N'Chave fusível três operações')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (29, N'28', N'Unidade Seccionadora', N'Chave motorizada')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (30, N'29', N'Unidade Seccionadora', N'Disjuntor')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (31, N'30', N'Unidade Seccionadora', N'Disjuntor de interligação de barra')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (32, N'31', N'Unidade Seccionadora', N'Lamina desligadora')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (33, N'32', N'Unidade Seccionadora', N'Religador')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (34, N'33', N'Unidade Seccionadora', N'Seccionadora tripolar de subestação')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (35, N'34', N'Unidade Seccionadora', N'Seccionadora unipolar de subestação')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (36, N'35', N'Unidade Seccionadora', N'Seccionalizador')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (37, N'36', N'Unidade Seccionadora', N'Seccionalizador monofásico')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (38, N'37', N'Unidade Transformadora', N'Transformador de aterramento')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (39, N'38', N'Unidade Transformadora', N'Transformador de distribuição')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (40, N'39', N'Unidade Transformadora', N'Transformador de isolamento')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (41, N'40', N'Unidade Transformadora', N'Transformador de serviço auxiliar')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (42, N'41', N'Unidade Transformadora', N'Transformador de subestação')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (43, N'42', N'Unidade Transformadora de Medidas', N'Transformador de corrente')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (44, N'43', N'Unidade Transformadora de Medidas', N'Transformador de potencial')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (45, N'52', N'Medidor', N'Módulos de Display e/ou Corte-Religa separados do medidor')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (46, N'51', N'Unidade Compensadora de Reativo', N'Compensador de reativos rotativo')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (47, N'56', N'Unidade Compensadora de Reativo', N'Reator')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (48, N'49', N'Unidade Seccionadora', N'Chave Tipo Tandem')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (49, N'53', N'Unidade Seccionadora', N'Disjuntor em módulo de manobra SF6')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (50, N'47', N'Unidade Seccionadora', N'Seccionadora com lâmina de terra')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (51, N'48', N'Unidade Seccionadora', N'Seccionadora em módulo de manobra')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (52, N'50', N'Unidade Seccionadora', N'Seccionadora com bob red corr cc')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (53, N'45', N'Unidade Seccionadora', N'Protetor de Rede de Transformador Subterrâneo')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (54, N'46', N'Unidade Seccionadora', N'Fusível')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (55, N'54', N'Unidade Transformadora', N'Transformador de força de média tensão (MT/MT)')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (56, N'44', N'Unidade Transformadora de Medidas', N'Conjunto de Medição')
INSERT [sde].[TUNI] ([OBJECTID], [COD_ID], [UNIDADE], [DESCR]) VALUES (57, N'55', N'Unidade Transformadora de Medidas', N'Transformador de defasamento')
/****** Object:  Index [archives_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_archives] ADD  CONSTRAINT [archives_uk] UNIQUE NONCLUSTERED 
(
	[history_regid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [sdelayer_stats_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_layer_stats] ADD  CONSTRAINT [sdelayer_stats_uk] UNIQUE NONCLUSTERED 
(
	[layer_id] ASC,
	[version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [layers_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_layers] ADD  CONSTRAINT [layers_uk] UNIQUE NONCLUSTERED 
(
	[layer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [sdelocators_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_locators] ADD  CONSTRAINT [sdelocators_uk] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[owner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO
/****** Object:  Index [rascol_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_raster_columns] ADD  CONSTRAINT [rascol_uk] UNIQUE NONCLUSTERED 
(
	[rastercolumn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO
/****** Object:  Index [states_cuk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_states] ADD  CONSTRAINT [states_cuk] UNIQUE NONCLUSTERED 
(
	[parent_state_id] ASC,
	[lineage_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [registry_uk2]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_table_registry] ADD  CONSTRAINT [registry_uk2] UNIQUE NONCLUSTERED 
(
	[table_name] ASC,
	[owner] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 75) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [versions_uk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_versions] ADD  CONSTRAINT [versions_uk] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[owner] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [xml_columns_pk]    Script Date: 15/09/2022 09:36:27 ******/
ALTER TABLE [sde].[SDE_xml_columns] ADD  CONSTRAINT [xml_columns_pk] PRIMARY KEY NONCLUSTERED 
(
	[column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [sde].[SDE_layer_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_object_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_state_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_table_locks] ADD  DEFAULT (getdate()) FOR [lock_time]
GO
ALTER TABLE [sde].[SDE_archives]  WITH CHECK ADD  CONSTRAINT [archives_fk1] FOREIGN KEY([archiving_regid])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_archives] CHECK CONSTRAINT [archives_fk1]
GO
ALTER TABLE [sde].[SDE_archives]  WITH CHECK ADD  CONSTRAINT [archives_fk2] FOREIGN KEY([history_regid])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_archives] CHECK CONSTRAINT [archives_fk2]
GO
ALTER TABLE [sde].[SDE_column_registry]  WITH CHECK ADD  CONSTRAINT [colregistry_fk] FOREIGN KEY([table_name], [owner], [database_name])
REFERENCES [sde].[SDE_table_registry] ([table_name], [owner], [database_name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_column_registry] CHECK CONSTRAINT [colregistry_fk]
GO
ALTER TABLE [sde].[SDE_geometry_columns]  WITH CHECK ADD  CONSTRAINT [geocol_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_geometry_columns] CHECK CONSTRAINT [geocol_fk]
GO
ALTER TABLE [sde].[SDE_layer_stats]  WITH CHECK ADD  CONSTRAINT [sdelayer_stats_fk1] FOREIGN KEY([layer_id])
REFERENCES [sde].[SDE_layers] ([layer_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_layer_stats] CHECK CONSTRAINT [sdelayer_stats_fk1]
GO
ALTER TABLE [sde].[SDE_layer_stats]  WITH CHECK ADD  CONSTRAINT [sdelayer_stats_fk2] FOREIGN KEY([version_id])
REFERENCES [sde].[SDE_versions] ([version_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_layer_stats] CHECK CONSTRAINT [sdelayer_stats_fk2]
GO
ALTER TABLE [sde].[SDE_layers]  WITH CHECK ADD  CONSTRAINT [layers_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_layers] CHECK CONSTRAINT [layers_fk]
GO
ALTER TABLE [sde].[SDE_layers]  WITH CHECK ADD  CONSTRAINT [layers_sfk] FOREIGN KEY([secondary_srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_layers] CHECK CONSTRAINT [layers_sfk]
GO
ALTER TABLE [sde].[SDE_mvtables_modified]  WITH CHECK ADD  CONSTRAINT [mvtables_modified_fk1] FOREIGN KEY([state_id])
REFERENCES [sde].[SDE_states] ([state_id])
GO
ALTER TABLE [sde].[SDE_mvtables_modified] CHECK CONSTRAINT [mvtables_modified_fk1]
GO
ALTER TABLE [sde].[SDE_mvtables_modified]  WITH CHECK ADD  CONSTRAINT [mvtables_modified_fk2] FOREIGN KEY([registration_id])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_mvtables_modified] CHECK CONSTRAINT [mvtables_modified_fk2]
GO
ALTER TABLE [sde].[SDE_raster_columns]  WITH CHECK ADD  CONSTRAINT [rascol_fk] FOREIGN KEY([srid])
REFERENCES [sde].[SDE_spatial_references] ([srid])
GO
ALTER TABLE [sde].[SDE_raster_columns] CHECK CONSTRAINT [rascol_fk]
GO
ALTER TABLE [sde].[SDE_xml_columns]  WITH CHECK ADD  CONSTRAINT [xml_columns_fk1] FOREIGN KEY([registration_id])
REFERENCES [sde].[SDE_table_registry] ([registration_id])
GO
ALTER TABLE [sde].[SDE_xml_columns] CHECK CONSTRAINT [xml_columns_fk1]
GO
ALTER TABLE [sde].[SDE_xml_columns]  WITH CHECK ADD  CONSTRAINT [xml_columns_fk2] FOREIGN KEY([index_id])
REFERENCES [sde].[SDE_xml_indexes] ([index_id])
GO
ALTER TABLE [sde].[SDE_xml_columns] CHECK CONSTRAINT [xml_columns_fk2]
GO
ALTER TABLE [sde].[SDE_xml_index_tags]  WITH CHECK ADD  CONSTRAINT [xml_indextags_fk1] FOREIGN KEY([index_id])
REFERENCES [sde].[SDE_xml_indexes] ([index_id])
ON DELETE CASCADE
GO
ALTER TABLE [sde].[SDE_xml_index_tags] CHECK CONSTRAINT [xml_indextags_fk1]
GO
ALTER TABLE [sde].[GDB_ITEMS]  WITH CHECK ADD  CONSTRAINT [g1_ck] CHECK  (([Shape].[STSrid]=(4326)))
GO
ALTER TABLE [sde].[GDB_ITEMS] CHECK CONSTRAINT [g1_ck]
GO
ALTER TABLE [sde].[SDE_spatial_references]  WITH CHECK ADD  CONSTRAINT [spatial_ref_xyunits] CHECK  (([xyunits]>=(1)))
GO
ALTER TABLE [sde].[SDE_spatial_references] CHECK CONSTRAINT [spatial_ref_xyunits]
GO
ALTER TABLE [sde].[SDE_spatial_references]  WITH CHECK ADD  CONSTRAINT [spatial_ref_zunits] CHECK  (([zunits]>=(1)))
GO
ALTER TABLE [sde].[SDE_spatial_references] CHECK CONSTRAINT [spatial_ref_zunits]
GO
ALTER TABLE [sde].[SDE_table_registry]  WITH CHECK ADD  CONSTRAINT [registry_chk] CHECK  (([database_name]=db_name()))
GO
ALTER TABLE [sde].[SDE_table_registry] CHECK CONSTRAINT [registry_chk]
GO
