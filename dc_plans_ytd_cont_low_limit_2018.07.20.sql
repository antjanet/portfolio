/************************************************************************************************************************
Purpose:    Report of employees contributing to the various Deferred Compensation Plans. Requested by CEO for Board of Supervisors.

Author:     Janet Antunez

Date:       Tuesday, November 28, 2017

Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------
11/29/17     J.Antunez         Exclude military leave categories EHZNM, RHZNM, ESVGM, RSAVM, EPSPM, and RPSPM
9/12/18     J. Antunez        Separate after-tax Savings Plan contributions and potentially other categories.

************************************************************************************************************************/
SELECT a.employee_id AS "Employee ID"
        , UPPER(a.empl_last_nm) || ', ' || UPPER(a.empl_first_nm) || ' ' || UPPER(a.empl_middle_nm) AS "Employee Name"
        , a.birth_dt AS "Date of Birth"
        , TRUNC(((To_Date('12/31/2016','MM/DD/YYYY')-birth_dt)/365)) AS "Age as of 12/31/2016"
        , dept.home_dept_cd AS "Department Code"
        , rd.dept_nm_up AS "Department Name"
        --, dsum.cldr_yr
        , SUM(hzn_ee) hzn_ee
        , SUM(hzn_er) hzn_er
        , SUM(hzn_ee) + SUM(hzn_er) hzn_total
        , SUM(sav_ee) sav_ee
        , SUM(sav_af_ee) sav_af_ee
        , SUM(sav_er) sav_er
        , SUM(sav_ee) + SUM(sav_er) + SUM(sav_af_ee) sav_total
        , SUM(psp_ee) psp_ee
        , SUM(psp_er) psp_er
        , SUM(psp_ee) + SUM(psp_er) psp_total
        , low_limit.dedtyp_cd, low_limit.latest_eff_dt, low_limit.expiration_dt
    FROM o_hrmuser.empl a,
         (SELECT DISTINCT d.internal_empl_id, d.home_dept_cd
          FROM   o_hrmuser.empl_asgnmt d
          WHERE appointment_id = ' '
          AND expiration_dt = To_Date('12/31/9999','mm/dd/yyyy')
         ) dept,
         r_dept rd,
         (SELECT internal_empl_id, cldr_yr,
                 CASE WHEN catg_cd IN ('EHZNA','EHZNR','EHZNT','HZNAD') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS HZN_EE,
                 CASE WHEN catg_cd IN ('RHZNA','RHZNR') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS HZN_ER,
                 CASE WHEN catg_cd IN (--'EASVG',
                                                    'EPSVG','ESVGT','SVGAD') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS SAV_EE,
                 CASE WHEN catg_cd IN ('EASVG') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS SAV_AF_EE,
                 CASE WHEN catg_cd IN ('RSAVG','RSAVM') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS SAV_ER,
                 CASE WHEN catg_cd IN ('EPSP','EPSPV','PSPAD') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS PSP_EE,
                 CASE WHEN catg_cd IN ('RPSP') THEN ded_1st_qtr_am + ded_2nd_qtr_am + ded_3rd_qtr_am + ded_4th_qtr_am END AS PSP_ER
            FROM o_hrmuser.ded_summ
           WHERE cldr_yr = '2017'
                 ) dsum,
          (SELECT distinct internal_empl_id, dedtyp_cd, max(effective_dt) AS latest_eff_dt, expiration_dt
            FROM ded_parm
            WHERE dedtyp_cd IN (
                'ED001','ED002','ED009','ED010' --County Non-Represented
                ,'ED044','ED038','ED045','ED039' --Superior Courts Non-Represented Employees
                ,'ED080','ED074','ED081','ED075' --LACERA Non-Represented 
                                )
            AND effective_dt between to_date('12/16/2016','mm/dd/yyyy') and to_date('12/15/2017','mm/dd/yyyy')
            AND ovrd_ded_pc > 0
            GROUP BY internal_empl_id, expiration_dt, dedtyp_cd
            ORDER BY 1,2) low_limit
   WHERE a.internal_empl_id = dsum.internal_empl_id
    AND dsum.internal_empl_id = dept.internal_empl_id
    AND rd.dept_cd = dept.home_dept_cd
    AND dsum.internal_empl_id = low_limit.internal_empl_id
--HAVING (sum(hzn_er) > sum(hzn_ee) AND sum(hzn_ee) = 0) OR (sum(sav_er) > sum(sav_ee) AND sum(sav_ee) = 0)
HAVING (sum(hzn_ee) > 0) OR (sum(sav_ee) > 0) OR (sum(psp_ee)>0)
GROUP BY a.employee_id, a.empl_last_nm, a.empl_first_nm, a.empl_middle_nm, a.birth_dt, dept.home_dept_cd, rd.dept_nm_up, low_limit.dedtyp_cd, low_limit.latest_eff_dt, low_limit.expiration_dt--dsum.cldr_yr
ORDER BY a.employee_id
