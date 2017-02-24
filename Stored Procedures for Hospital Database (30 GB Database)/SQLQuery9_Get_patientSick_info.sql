USE [hospital]
GO

/****** Object:  StoredProcedure [dbo].[GetPatientSickInfo]    Script Date: 2/23/2017 10:44:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GetPatientSickInfo]
	@FileCode INT,
	@dgFirstDiag INT,
	@dgEndDiag INT,
	@BillBim BIT,
	@iscBimRep   INT,
	@InfoType VARCHAR(6)
AS
BEGIN
		
  IF(@InfoType='Common')
    BEGIN
         		 
     SELECT 
     A.FileCode,
     GETDATE() AS LNow,
     (SELECT TOP 1  s.Name  FROM   AllocBed sb   INNER JOIN Sections s ON  s.SectionCode = sb.SectionCode  WHERE  sb.FileCode = @FileCode ORDER BY   sb.AllocTime ) AS SectionName,
      (Select Top 1 ICD10Code  From SickDiag   Where FileCode = A.FileCode And   DiagTimeCode =  @dgFirstDiag  Order By DiagTime) As FirstDiagCode, 
      (Select Top 1 ICD10Code  From SickDiag   Where FileCode = A.FileCode AND   DiagTimeCode = @dgEndDiag  Order By DiagTime) As EndDiagCode ,
     ( Select Top 1 SckCostFooterCmm From GLPrintComm) SckCostFooterCmm,
       CompBim.CompBimName,
     (SELECT   top 1 h.EvaluationDegree FROM hosps h INNER JOIN Citys c on h.citycode = c.citycode) AS EvaluationDegree,
     (SELECT  top 1 c.Name FROM hosps h INNER JOIN Citys c on h.citycode = c.citycode) AS CityName,
       substring( dbo.Fdate (SB.ExpireBookTime),0,11 ) ExpireBookTime ,
      
       
      ( SELECT TOP 1 d.FName + SPACE(1) + d.LName AS DoctorName  
                    FROM OpSurg AS os INNER JOIN SickOp AS so ON so.OperCode = os.OperCode 
       						   INNER JOIN SckOEtr AS soe ON soe.EnterORoomCode = so.EnterORoomCode 
       						   INNER JOIN doctors AS d ON d.DoctorCode = os.DoctorCode
         WHERE soe.Filecode =  A.FileCode
         ORDER BY so.JaRatio) AS JaDocName,
         
         (Select top 1 IsoCode From ISOCodes Where IsoTypeCode =@iscBimRep ) AS IsoCode,
       sb.KRatio,
       sb.BimOpRatio,
       SB.BimBookNo,
       SB.BimName,
       BG.BimGroupName,
       SB.BimOpRatio , 
       SB.BimDepRatio,
       SB.EmissionPlace, 
       SB.Serial,
       SB.LastDepartment,
       SB.LastBimCode  BimCode,
       B.HospRatio,
       SckDoc.DoctorName ,
 		SckDoc.SpecialityName,
 		SckDoc.Id,
       s.SickCode,
       A.State,
       a.ADMTime,
       AEV.DischargeTime ExitTime,
       substring( dbo.Fdate (a.ADMTime),12,8 )  AdmTimeTime,
       substring( dbo.Fdate (a.ADMTime),0,11 ) AdmTimeDate,
       
       AT.AdmitType + '('+ CureType + ')' AdmitType,
       S.Sh_Id,
       S.ShPlace,
       S.I_Id,
        substring( dbo.Fdate (S.BirthDate),0,11 )  BirthDate,
        ms.MaritalType  Marrid,
       CT.CureType,
       S.FName,
       S.LName,
       S.FatherName,
       St.SexType Sex,
       S.NationalCode,
       SS.SickState,
       AEV.RemoveCause,
       substring( dbo.Fdate (AEV.DischargeTime),12,8 )  ExitTimeTime,
       substring( dbo.Fdate (AEV.DischargeTime),0,11 ) ExitTimeDate,
       SEV.SectionName AS LastSectionName,
       f.FolderCode,
       null compositionUID
	  
FROM   Adm                   A
      INNER JOIN AdmitExitsView        AEV ON A.FileCode = AEV.FileCode
      INNER JOIN AdmType               AT ON  A.AdmitTypeCode = AT.AdmitTypeCode
      INNER JOIN MaritalStatus AS ms ON ms.MaritalCode=a.Marrid
      INNER JOIN Sicks                 S ON S.SickCode = A.SickCode
      INNER JOIN SexType          st ON st.SexTypeCode=s.Sex
      INNER JOIN SckState              SS ON SS.SickStateCode = A.[State]
      INNER JOIN Curetype              CT ON CT.CureTypeCode = A.CureTypeCode
      INNER JOIN SectionsView SEV ON SEV.SectionCode = A.SectionCode 
      INNER JOIN LastBimView  SB  ON sb.FileCode=A.FileCode
      INNER JOIN Bims B ON B.BimCode=sb.LastBimCode    
      INNER JOIN BimGroup BG ON    B.BimGroupCode =  BG.BimGroupCode
      LEFT JOIN  Folders  F ON F.AdmitTypeCode = A.AdmitTypeCode And F.SickCode = A.SickCode
    
      OUTER APPLY
	(
		SELECT
 		D.FName + +D.LName As DoctorName ,
 		Spc.SpecialityName,
 		D.id
		From 
		SckDoct sc  INNER JOIN 
		Doctors D  ON d.DoctorCode=sc.DoctorCode
		INNER JOIN Specials spc ON spc.SpecialityCode = D.SpecialityCode
		WHERE sc.FileCode= A.FileCode
		AND  sc.EndTime IS NULL
	) AS SckDoc
	
	  OUTER APPLY
	(
		SELECT TOP 1 
 		bc.BimName AS CompBimName
		FROM 
		CompBimTreaty AS cbt
		INNER JOIN bims bc ON bc.BimCode = cbt.BimCode
		WHERE cbt.FileCode= A.FileCode
		AND cbt.CompBimState = 2 
				
	) AS CompBim
	
WHERE  A.FileCode=@FileCode
  
    END
   ELSE
     	BEGIN
   			IF (@BillBim=1) 
              BEGIN
               SELECT 
				SO.OpID As OperCode 
				,GR.RowNO                    AS RowNO 
				,ISNULL(SO.NationalCode ,SO.OpCode) OpCode 
				,SO.OpCode               AS GlobalCode 
				, SO.JaProfessionalUnit  AS JaUnit 
				,(SO.BiProfessionalUnit)     BiUnit 
				,SO.IsGlobal                         
				FROM   PatientOpInfo sO                  
				LEFT JOIN GlOpRows GR ON GR.OpCode = sO.OpCode 
				WHERE  SO.FileCode = @FileCode    
				AND SO.BimOpRatio>0          
				AND (SO.JaPrice  <>0)        
				ORDER BY SO.OpID   
              END
              ELSE
              BEGIN
               SELECT 
				SO.OpID As OperCode 
				,GR.RowNO                    AS RowNO 
				,ISNULL(SO.NationalCode ,SO.OpCode) OpCode 
				,SO.OpCode               AS GlobalCode 
				, SO.JaProfessionalUnit  AS JaUnit 
				,(SO.BiProfessionalUnit)     BiUnit 
				,SO.IsGlobal                         
				FROM   PatientOpInfo sO                  
				LEFT JOIN GlOpRows GR ON GR.OpCode = sO.OpCode 
				WHERE  SO.FileCode = @FileCode    
				AND (SO.JaPrice  <>0)        
				ORDER BY SO.OpID   
            	
              	
              END		
				
				          
		END 
  
  
      		 	     
    
END




GO


