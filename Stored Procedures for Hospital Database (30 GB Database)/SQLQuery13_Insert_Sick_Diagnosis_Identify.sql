USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[InsertSickDiagnosisIdentify]    Script Date: 2/23/2017 10:46:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[InsertSickDiagnosisIdentify] @SickCode Int,@NationalCode NVARCHAR(25)
As
Begin
 IF Not EXISTS(SELECT SD.SickCode FROM SickDiagnosisIdentify SD 
                WHERE SD.SickCode = @SickCode)
  BEGIN
   INSERT INTO SickDiagnosisIdentify(SickCode,NationalCode)
    VALUES(@SickCode,@NationalCode)
  END  
End;







GO


