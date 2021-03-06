/****** Script for SelectTopNRows command from SSMS  ******/
SELECT mds.FileSizeMB,mds.UsedSpaceMB, mds.PercentUnusedSpace, mds.UnusedSpaceMB, MDS.DateChecked,
     mds2.*,
     mds2.FileSizeMB-mds.FileSizeMB AS FILEGROWTH,
     ( mds2.FileSizeMB-mds.FileSizeMB)/mds.FileSizeMB AS PercentGrowth,
     mds2.UsedSpaceMB-mds.UsedSpaceMB AS usedspacediff,
     mds2.PercentUnusedSpace-mds.PercentUnusedSpace AS unusedspacepercentdiff
  FROM [KareoMaintenance].[dbo].[Manage_DatabaseSpace] MDS
  INNER JOIN KareoMaintenance.dbo.Manage_DatabaseSpace AS mds2 ON MDS.DatabaseName = mds2.DatabaseName AND MDS.DBFileName = mds2.DBFileName
  WHERE mds.DBFileName='Customer_Data' AND mds.DateChecked<'5/22/2012' AND mds2.DateChecked>'5/22/2012'
  AND MDS.DatabaseName IN ('superbill_2039_prod','superbill_2379_prod','superbill_3349_prod')
  ORDER BY FILEGROWTH desc
  
  
  
  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT mds.FileSizeMB,mds.UsedSpaceMB, mds.PercentUnusedSpace, mds.UnusedSpaceMB, MDS.DateChecked,
     mds2.*,
     mds2.FileSizeMB-mds.FileSizeMB AS FILEGROWTH,
       ( mds2.FileSizeMB-mds.FileSizeMB)/mds.FileSizeMB AS PercentGrowth,
     mds2.UsedSpaceMB-mds.UsedSpaceMB AS  usedspacediff,
     mds2.PercentUnusedSpace-mds.PercentUnusedSpace AS unusedspacepercentdiff
  FROM [KareoMaintenance].[dbo].[Manage_DatabaseSpace] MDS
  INNER JOIN KareoMaintenance.dbo.Manage_DatabaseSpace AS mds2 ON MDS.DatabaseName = mds2.DatabaseName AND MDS.DBFileName = mds2.DBFileName
  WHERE mds.DBFileName='Customer_LOG' AND mds.DateChecked<'5/22/2012' AND mds2.DateChecked>'5/22/2012'
   --AND MDS.DatabaseName IN ('superbill_2039_prod','superbill_2379_prod','superbill_3349_prod')
  ORDER BY FILEGROWTH desc
