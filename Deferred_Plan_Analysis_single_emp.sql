/************************************************************************************************************************
Purpose:  Series of queries to execute when analyzing a single employee's retirement plan enrollments and contributions. 
          Used to determine errors with contributions and compensation. 
Author:   Janet Antunez
Date:     April 3, 2013
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/
-- Determines employee's eligibility for the various retirement plans
SELECT
    employee_id, empl_last_nm, empl_first_nm
    , b.*
    --b.home_dept_cd, b.appointment_id, b.effective_dt, b.expiration_dt,
    --b.pers_actn_cd, b.orig_pers_actn_cd,
    --b.title_cd, b.sub_title_cd, b.step_cd, b.union_loc_cd, b.last_update_dt, b.last_update_userid
FROM o_hrmuser.empl a
  , o_hrmuser.empl_asgnmt b
WHERE
  a.internal_empl_id = b.internal_empl_id
  --AND b.emplmt_sta_cd NOT IN ('A','L')
  --AND b.expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
  --AND b.effective_dt > to_date('03/01/2017','mm/dd/yyyy')
  --AND a.empl_last_nm LIKE 'A%'
  --AND a.employee_id = 227616
   AND employee_id =239994
ORDER BY
  expiration_dt DESC
  , effective_dt 
  , appointment_id NULLS FIRST;

-- Determines employee's enrollments
SELECT employee_id
  --, TRUNC(((To_Date('12/31/2011','MM/DD/YYYY')-birth_dt)/365)) AS "Age"
  , TRUNC((sysdate-birth_dt)/365) AS "Current Age"
  , b.appointment_id  , b.dedtyp_cd  , c.dedt_long_dd  , b.effective_dt  , b.expiration_dt  , b.ovrd_ded_am  , b.ovrd_ded_pc  , b.last_update_dt  , b.last_update_userid
FROM o_hrmuser.empl a
  , o_hrmuser.ded_parm b
  , o_hrmuser.ded_type c
WHERE
  a.internal_empl_id = b.internal_empl_id
  --AND c.expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
  AND b.effective_dt between c.effective_dt and c.expiration_dt
  AND c.dedtyp_cd = b.dedtyp_cd
  --AND (
  AND (b.dedtyp_cd LIKE 'ED%' OR b.dedtyp_cd LIKE 'ER35%')
  AND employee_id = 610303
  AND appointment_id = ' ' 
  /* */
  --AND b.dedtyp_cd = 'ER352' 
  --AND ovrd_ded_pc <> 0
  --AND b.internal_empl_id IN ('0000053497','0000105530')
  --AND b.appointment_id = ' '
ORDER BY employee_id,
    --, effective_dt
    expiration_dt DESC--, effective_dt desc
    --dedtyp_cd, effective_dt desc
;

-- Determines employee's summary of deductions by month
SELECT employee_id 
      , TRUNC((sysdate-birth_dt)/365) AS "Current Age"
      , b.*
      , catg_desc.*
FROM o_hrmuser.empl a
  , o_hrmuser.ded_summ b
  , (SELECT --dedtyp_cd, dedt_long_dd, dedt_short_dd, 
            DISTINCT catg_cd
            ---, ben_typ_cls_cd, ben_typ_sub_cls_cd
FROM o_hrmuser.ded_type
--WHERE
    --expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
  --  dedtyp_cd LIKE 'ER%'
--ORDER BY dedtyp_cd
    ) catg_desc
WHERE
  a.internal_empl_id = b.internal_empl_id
  AND (b.catg_cd LIKE '%HZN%' OR b.catg_cd LIKE '%S%VG%' OR b.catg_cd LIKE '%PS%') AND NOT b.catg_cd = 'RFSVG'
  AND b.catg_cd = catg_desc.catg_cd
  --IN ('EHZNR','RHZNR')
  --AND cldr_yr = '2014'
  AND employee_id = 610303
ORDER BY
    a.employee_id
    , b.cldr_yr
    , b.catg_cd
;

-- Determine's employee's goal deductions if any
SELECT a.employee_id, b.*
FROM
  o_hrmuser.empl a
  , o_hrmuser.ded_goal b
WHERE
  a.internal_empl_id = b.internal_empl_id
  AND a.employee_id = 232776
  AND b.dedtyp_cd LIKE 'ED%'
  --AND b.goal_tot_to_dt_am > 10000
  --AND effective_dt > to_date('12/31/2015','mm/dd/yyyy')
  --AND expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
ORDER BY
    a.employee_id
    , b.expiration_dt desc
    , b.effective_dt desc
    , b.dedtyp_cd
  ;
