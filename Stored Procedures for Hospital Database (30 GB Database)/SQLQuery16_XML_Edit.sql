USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[XMLEdit]    Script Date: 2/23/2017 10:48:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[XMLEdit]
	@Type INT,
	@XmlCaptionCode INT,
	@Where NVARCHAR(MAX),
	@TempTableName NVARCHAR(50),
	@OrderBy NVARCHAR(MAX),
	@KRatioAction BIT
AS
BEGIN
    IF EXISTS(
           SELECT *
           FROM   sys.tables AS t
           WHERE  t.name LIKE '%'+@TempTableName+'%'
       )
    BEGIN
        EXEC ('DROP TABLE '+@TempTableName);
    END  
    
    IF EXISTS(
           SELECT *
           FROM   sys.tables AS t
           WHERE  t.name LIKE '%'+@TempTableName+'TempSrv%'
       )
    BEGIN
        EXEC ('DROP TABLE '+@TempTableName+'TempSrv');
    END
    
    IF EXISTS(
           SELECT *
           FROM   sys.tables AS t
           WHERE  t.name LIKE '%'+@TempTableName+'TempDrg%'
       )
    BEGIN
        EXEC ('DROP TABLE '+@TempTableName+'TempDrg');
    END 
    
    
    IF (@Type=1)
    BEGIN
        EXEC (
                 'SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+
                 ') AS RowNum,LSV.*  
			   ,CASE 
					WHEN '+@KRatioAction+
                 '= 1 THEN ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice ,0) +
							 ISNULL(LSV.FullTimeGeographicprice ,0)
							,-1
						 )
					ELSE ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice*LSV.KRatio ,0) +
							 ISNULL(LSV.FullTimeGeographicprice*LSV.KRatio ,0)
							,-1
						 )
			   END                           AS AllPrice
			  INTO '+@TempTableName+
                 '
              FROM  AllParaOpSrvDetailView LSV
			               WHERE  LSV.XMLCaptionCode ='+@XmlCaptionCode+@Where
             )
    END
    ELSE 
    IF (@Type=0)
    BEGIN
        EXEC (
                 'SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+
                 ') AS RowNum, LSV.* , ROUND(LSV.SickValue + LSV.Bimvalue,0) AS AllPrice
						INTO '+@TempTableName+
                 '
				FROM   DrugReciptInfoView LSV
				WHERE  1 = 1 '+@Where
             )
    END
    ELSE 
    IF (@Type=-1)
    BEGIN
        EXEC (
                 'SELECT LSV.*  
			   ,CASE 
					WHEN '+@KRatioAction+
                 '=1 THEN ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice ,0) +
							 ISNULL(LSV.FullTimeGeographicprice ,0)
							,-1
						 )
					ELSE ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice*LSV.KRatio ,0) +
							 ISNULL(LSV.FullTimeGeographicprice*LSV.KRatio ,0)
							,-1
						 )
			   END                           AS AllPrice
			   INTO '+@TempTableName+'TempSrv '+
                 ' FROM  AllParaOpSrvDetailView LSV
			               WHERE LSV.DrgTag<>0 AND LSV.XMLCaptionCode = '+@XmlCaptionCode 
                +@Where
             )
        
        EXEC (
                 'SELECT LSV.*
			INTO '+@TempTableName+'TempDrg '+
                 ' FROM   DrgTagInSrvXmlForNiroMosalah LSV WHERE  1 = 1 AND LSV.FileCode IN (SELECT FileCode From ' 
                +@TempTableName+'TempSrv )'
             )
        
        EXEC (
                 'SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+
                 ') AS RowNum,X.* INTO '+@TempTableName+
                 ' FROM 
		(SELECT * FROM '+@TempTableName+
                 'TempSrv 
			UNION ALL 
		SELECT * FROM '+@TempTableName+'TempDrg ) X'
             )
    END
    ELSE 
    IF @Type=-2
    BEGIN
        EXEC (
                 'SELECT LSV.* , ROUND(LSV.SickValue + LSV.Bimvalue,0) AS AllPrice 
					INTO '+@TempTableName+
                 'TempDrg 
				FROM   DrugReciptInfoView LSV
				WHERE  1 = 1 '+@Where
             )  
        
        EXEC (
                 'SELECT LSV.*  
			   ,CASE 
					WHEN '+@KRatioAction+
                 '=1 THEN ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice ,0) +
							 ISNULL(LSV.FullTimeGeographicprice ,0)
							,-1
						 )
					ELSE ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice*LSV.KRatio ,0) +
							 ISNULL(LSV.FullTimeGeographicprice*LSV.KRatio ,0)
							,-1
						 )
			   END                           AS AllPrice
			   INTO '+@TempTableName+'TempSrv '+
                 ' FROM  AllParaOpSrvDetailView LSV
			               WHERE LSV.FileCode IN (SELECT FileCode FROM '+@TempTableName+'TempDrg)
								AND LSV.OpServiceCode = 902020 '
                +@Where
             )
    END
    ELSE 
    IF @Type=-3
    BEGIN
    
    EXEC (
                 'SELECT LSV.*  
			   ,CASE 
					WHEN '+@KRatioAction+
                 '=1 THEN ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice ,0) +
							 ISNULL(LSV.FullTimeGeographicprice ,0)
							,-1
						 )
					ELSE ROUND(
							 LSV.BimPrice +
							 ISNULL(LSV.FullTimePrice*LSV.KRatio ,0) +
							 ISNULL(LSV.FullTimeGeographicprice*LSV.KRatio ,0)
							,-1
						 )
			   END                           AS AllPrice
			   INTO '+@TempTableName+'TempSrv '+
                 ' FROM  AllParaOpSrvDetailView LSV
			               WHERE 1 = 1 AND LSV.XMLCaptionCode = '+@XmlCaptionCode + @Where
             ) 
             
        EXEC (
                 'SELECT LSV.* , ROUND(LSV.SickValue + LSV.Bimvalue,0) AS AllPrice 
					INTO '+@TempTableName+'TempDrg 
				FROM   DrugReciptInfoView LSV
				WHERE  LSV.FileCode IN (SELECT FileCode From ' 
                +@TempTableName+'TempSrv )'
             )  
        
          							 
        
        EXEC (
                 'SELECT ROW_NUMBER() OVER (ORDER BY '+@OrderBy+
                 ') AS RowNum, X.* INTO '+@TempTableName+
                 ' FROM 
		(SELECT * FROM '+@TempTableName+
                 'TempDrg
			UNION ALL 
		SELECT * FROM '+@TempTableName+'TempSrv  ) X'
             )
    END
    
    EXEC (
             ' CREATE CLUSTERED INDEX [ClusteredIndex-20160120-114238] ON [dbo].['
            +@TempTableName+']'+
             ' ( [RowNum] ASC , '+@OrderBy+') '
         )
END;

GO


