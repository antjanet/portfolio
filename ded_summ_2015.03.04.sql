************************************************************************************************************************
Purpose:  Generate listing of deduction summaries for retirement plan enrollees.
Author:   Janet Antunez
Date:     March 4, 2015
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT 
    dept.home_dept_cd AS "Dept"
  , a.employee_id  AS "EmpID"
  --, a.internal_empl_id AS "Int_EmpID"
  , a.empl_last_nm || ', ' || a.empl_first_nm || ' ' || a.empl_middle_nm AS "Name"
  , TRUNC((SYSDATE-birth_dt)/365) AS "Current Age"
  , b.CLDR_YR AS "Year"
  , b.CATG_CD AS "Catg"
  , catg_desc.catg_long_dd
  , b.DED_MO_01_AM AS "Ded1"  , b.DED_MO_02_AM AS "Ded2"  , b.DED_MO_03_AM AS "Ded3"  , b.DED_MO_04_AM AS "Ded4"  , b.DED_MO_05_AM AS "Ded5"  , b.DED_MO_06_AM AS "Ded6"  , b.DED_MO_07_AM AS "Ded7"  , b.DED_MO_08_AM AS "Ded8"  , b.DED_MO_09_AM AS "Ded9"  , b.DED_MO_10_AM AS "Ded10"  , b.DED_MO_11_AM AS "Ded11"  , b.DED_MO_12_AM AS "Ded12"
  , Sum(b.DED_MO_01_AM + b.DED_MO_02_AM + b.DED_MO_03_AM + b.DED_MO_04_AM + b.DED_MO_05_AM + b.DED_MO_06_AM
      + b.DED_MO_07_AM + b.DED_MO_08_AM + b.DED_MO_09_AM + b.DED_MO_10_AM + b.DED_MO_11_AM + b.DED_MO_12_AM) AS "YTD_Ded"
  , b.SB_GRSS_01_MO_AM AS "SubGrs1"  , b.SB_GRSS_02_MO_AM AS "SubGrs2"  , b.SB_GRSS_03_MO_AM AS "SubGrs3"  , b.SB_GRSS_04_MO_AM AS "SubGrs4"  , b.SB_GRSS_05_MO_AM AS "SubGrs5"  , b.SB_GRSS_06_MO_AM AS "SubGrs6"  , b.SB_GRSS_07_MO_AM AS "SubGrs7"  , b.SB_GRSS_08_MO_AM AS "SubGrs8"  , b.SB_GRSS_09_MO_AM AS "SubGrs9"  , b.SB_GRSS_10_MO_AM AS "SubGrs10"  , b.SB_GRSS_11_MO_AM AS "SubGrs11"  , b.SB_GRSS_12_MO_AM AS "SubGrs12"
  , Sum(b.SB_GRSS_01_MO_AM + b.SB_GRSS_02_MO_AM + b.SB_GRSS_03_MO_AM + b.SB_GRSS_04_MO_AM + b.SB_GRSS_05_MO_AM + b.SB_GRSS_06_MO_AM
      + b.SB_GRSS_07_MO_AM + b.SB_GRSS_08_MO_AM + b.SB_GRSS_09_MO_AM + b.SB_GRSS_10_MO_AM + b.SB_GRSS_11_MO_AM + b.SB_GRSS_12_MO_AM) AS "YTD_SubGrs"
FROM 
    o_hrmuser.empl a
    , o_hrmuser.ded_summ b
    , (SELECT DISTINCT d.internal_empl_id, d.home_dept_cd
       FROM   o_hrmuser.empl_asgnmt d
       WHERE appointment_id = ' '
        AND expiration_dt = To_Date('12/31/9999','mm/dd/yyyy')
       ) dept
    , (SELECT catg_cd, catg_long_dd
       FROM o_hrmuser.evnt_categ
       WHERE expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
    ) catg_desc
WHERE
    a.internal_empl_id = b.internal_empl_id
    AND b.internal_empl_id = dept.internal_empl_id
    AND catg_desc.catg_cd = b.catg_cd
    AND a.employee_id IN (
    /* 2016 Forecast */
    --11/30th insert employee list here
    )
    AND b.cldr_yr = '2016'
    AND b.catg_cd IN (
    /* Additional Categories for Complete Analysis */
    'EFSVG','EHZNA','EHZNM','EHZNR','EHZNT','EPSP','EPSPM','EPSPV','ESVGM','HZNAD','PFSVG','PSPAD','RFSVG','RHZNA','RHZNM','RHZNR','RPSP','RPSPM',
    /* Formula 5 (SVANN) Deduction Categories Included */
    'EPSVG', --PRE-TAX SAVINGS PLAN
    'ESVGT', --SAVINGS TERMINATION PLAN
    'SVGAD', --SAVINGS PLAN ADJUSTMENT
    /* After-Tax Employee Savings Plan Deduction Categories */
    'EASVG', --AFTER-TAX SAVINGS PLAN
    /* Pre-Tax Employer Deduction Categories */
    'RSAVG', --SAVINGS PLAN SUBSIDY
    /* After-Tax Deduction Categories to Retirement Plans */
    'AARET', --AFTER-TAX ADDITIONAL RETIREMENT
    'ABRET', --AFTER-TAX BACK RETIREMENT
    'AR300', --JUDGES RETIREMENT SYSTEM I AFTER-TAX
    'AR302', --JUDGES RETIREMENT SYSTEM II AFTER-TAX
    'AR304', --JUDGES RETIREMENT SYSTEM II AFTER-TAX, CAP
    'AR305', --JUDGES RETIREMENT SYSTEM II PEPRA AFTER-TAX
    'AR306', --BACK RETIREMENT JUDGES I AFTER-TAX
    'AR308', --BACK RETIREMENT JUDGES II AFTER-TAX
    'AR309', --BACK RETIREMENT JUDGES II PEPRA AFTER-TAX
    'ARADJ', --AFTER-TAX RETIREMENT ADJUSTMENT
    'ARRAN', --AFTER-TAX REGULAR RETIREMENT PLAN A
    'ARRAS', --AFTER-TAX RETIREMENT PLAN A SAFETY
    'ARRBN', --AFTER-TAX REGULAR RETIREMENT PLAN B
    'ARRBS', --AFTER-TAX RETIREMENT PLAN B SAFETY
    'ARRCN', --AFTER-TAX REGULAR RETIREMENT PLAN C
    'ARRCS', --AFTER-TAX RETIREMENT PLAN C SAFETY
    'ARRDN', --AFTER-TAX REGULAR RETIREMENT PLAN D
    'ARREN', --AFTER-TAX REGULAR RETIREMENT PLAN E
    'ARRGN' --AFTER-TAX REGULAR RETIREMENT PLAN G
    )
GROUP BY
    dept.home_dept_cd
    , a.employee_id
    , a.internal_empl_id
    , a.empl_last_nm
    , a.empl_first_nm
    , a.empl_middle_nm
    , a.birth_dt
    , b.CLDR_YR
    , b.CATG_CD
    , catg_desc.catg_long_dd
    , b.DED_MO_01_AM, b.DED_MO_02_AM, b.DED_MO_03_AM, b.DED_MO_04_AM, b.DED_MO_05_AM, b.DED_MO_06_AM, b.DED_MO_07_AM, b.DED_MO_08_AM, b.DED_MO_09_AM, b.DED_MO_10_AM, b.DED_MO_11_AM, b.DED_MO_12_AM
    , b.SB_GRSS_01_MO_AM, b.SB_GRSS_02_MO_AM, b.SB_GRSS_03_MO_AM, b.SB_GRSS_04_MO_AM, b.SB_GRSS_05_MO_AM, b.SB_GRSS_06_MO_AM, b.SB_GRSS_07_MO_AM, b.SB_GRSS_08_MO_AM, b.SB_GRSS_09_MO_AM, b.SB_GRSS_10_MO_AM, b.SB_GRSS_11_MO_AM, b.SB_GRSS_12_MO_AM
ORDER BY
    a.employee_id, b.cldr_yr, b.catg_cd