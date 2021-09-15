/************************************************************************************************************************
Purpose:    Identify deferred compensation plan participants who exceeded the "Annual Additions" Limit for each of the
            calendar years beginning with 2010 to the present. The "Annual Additions" limit may vary from one calendar
            year to the next.

Author:     Janet Antunez

Date:       Thursday, December 11, 2014

Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------
12/12/2014  J.Antunez         Provide list to Parsek
**12/27/2016  J.Antunez       The results of this query are insufficient to determine the actual Annual Additions YTD amount for 
                            those participants enrolled in the age 50+ catch-up contribution plans. For these participants, 
                            the Catch-up Contributions amount must be subtracted. This amount may vary each calendar year.
05/01/2017  J.Antunez         Parsek modified query to include a flag to identify participants enrolled in the Savings 50+ plans
12/13/2017  J.Antunez         First run I performed this calendar year.
06/26/2018  J.Antunez         No employees are in excess.
7/27/2018   J.Antunez         One participant is nearing the annual additions limit. However, the participant's elections are at 0%.
                            This participant will continue to appear in the results of this query. It was also reported to DHR. 
                            Unless the contributions begin again, the employee's contributions will remain the same for the remaining calendar year.
09/25/2018  J.Antunez         Two employees approaching limit: 543134 ($55015.40) and 629850 ($54069.64). Both are over age 50.

************************************************************************************************************************/
select employee_id, demo.internal_empl_id, name, home_dept_cd, cldr_yr, flag , catg_group, ytd_contribution from --05/01/17 Added by Parsek Halburian
(SELECT a.employee_id, a.internal_empl_id
        , a.empl_last_nm || ', ' || a.empl_first_nm || ' ' || a.empl_middle_nm AS NAME
        , dept.home_dept_cd
        , cldr_yr
        , dsum.catg_group
        , SUM (ytd_by_catg) ytd_contribution
    FROM o_hrmuser.empl a,
         (SELECT DISTINCT d.internal_empl_id, d.home_dept_cd
          FROM   o_hrmuser.empl_asgnmt d
          WHERE appointment_id = ' '
          AND expiration_dt = To_Date('12/31/9999','mm/dd/yyyy')
         ) dept,
         (SELECT internal_empl_id,
                 cldr_yr,
                 DECODE (catg_cd,
                         /* Formula 5 (SVANN) Deduction Categories Included */
                         'EPSVG', 'ANNL_ADD',
                         'ESVGT', 'ANNL_ADD',
                         'SVGAD', 'ANNL_ADD', /* YTD inluded in both SVANN and SVAA Formulas, neither formula has a payday amount for this category */
                         /* After-Tax Employee Savings Plan Deduction Categories */
                         'EASVG', 'ANNL_ADD', /* SVAA Formula */
                         /* Pre-Tax Employer Deduction Categories */
                         'RSAVG', 'ANNL_ADD', /* SVAA Formula */
                         /* After-Tax Deduction Categories to Retirement Plans */
                         'AARET', 'ANNL_ADD',
                         'ABRET', 'ANNL_ADD',
                         'AR300', 'ANNL_ADD',
                         'AR302', 'ANNL_ADD',
                         'AR304', 'ANNL_ADD',
                         'AR305', 'ANNL_ADD', --JUDGES RETIREMENT SYSTEM II PEPRA AFTER-TAX
                         'AR306', 'ANNL_ADD',
                         'AR308', 'ANNL_ADD',
                         'AR309', 'ANNL_ADD', --BACK RETIREMENT JUDGES II PEPRA AFTER-TAX
                         'ARADJ', 'ANNL_ADD', /* SVAA Formula */
                         'ARRAN', 'ANNL_ADD', /* SVAA Formula */
                         'ARRAS', 'ANNL_ADD', /* SVAA Formula */
                         'ARRBN', 'ANNL_ADD', /* SVAA Formula */
                         'ARRBS', 'ANNL_ADD', /* SVAA Formula */
                         'ARRCN', 'ANNL_ADD', /* SVAA Formula */
                         'ARRCS', 'ANNL_ADD', /* SVAA Formula */ --AFTER-TAX RETIREMENT PLAN C SAFETY
                         'ARRDN', 'ANNL_ADD', /* SVAA Formula */
                         'ARREN', 'ANNL_ADD', /* SVAA Formula */
                         'ARRGN', 'ANNL_ADD'  /* SVAA Formula */ --AFTER-TAX REGULAR RETIREMENT PLAN G
                         )
                    catg_group,
                   ded_1st_qtr_am
                 + ded_2nd_qtr_am
                 + ded_3rd_qtr_am
                 + ded_4th_qtr_am
                    ytd_by_catg
            FROM o_hrmuser.ded_summ
           WHERE cldr_yr = &cldr_yr AND
                 catg_cd IN ('EPSVG','ESVGT','SVGAD','EASVG','RSAVG','AARET','ABRET','AR300','AR302','AR304','AR305','AR306',
                                 'AR308','AR309','ARADJ','ARRAN','ARRAS','ARRBN','ARRBS','ARRCN','ARRCS','ARRDN','ARREN','ARRGN')
                                 ) dsum
   WHERE a.internal_empl_id = dsum.internal_empl_id
    AND dsum.internal_empl_id = dept.internal_empl_id
    --AND a.employee_id in (283792, 248274)
--HAVING SUM (ytd_by_catg) > 49000 --2009, 2010, 2011, age 50+ catch-up contributions limit is $5,500
--HAVING SUM (ytd_by_catg) > 50000 --2012, age 50+ catch-up contributions limit is $5,500
--HAVING SUM (ytd_by_catg) > 51000 --2013, age 50+ catch-up contributions limit is $5,500
--HAVING SUM (ytd_by_catg) > 52000 --2014, age 50+ catch-up contributions limit is $5,500
--HAVING SUM (ytd_by_catg) > 53000 --2015, age 50+ catch-up contributions limit is $6,000
--HAVING SUM (ytd_by_catg) > 53000 --2016, age 50+ catch-up contributions limit is $6,000
--HAVING SUM (ytd_by_catg) > 54000 --2017, age 50+ catch-up contributions limit is $6,000
HAVING SUM (ytd_by_catg) > 54000   --55000 2018, age 50+ catch-up contributions limit is $6,000
GROUP BY a.employee_id, a.internal_empl_id, dsum.cldr_yr, dsum.catg_group
        , a.empl_last_nm, a.empl_first_nm, a.empl_middle_nm
        , dept.home_dept_cd ) demo
/* Logic below was added on 05/01/17 by Parsek Halburian */
/* J.Antunez: only drawback to including the logic below is that an employee must have an active ded_parm in order for the flag to display correctly.
   Otherwise, if an employee is terminated, but has/had an excesss while on a 50+ plan, the flag will be 0. */
left join
        (select internal_empl_id, sum( decode (dedtyp_cd, 'ED005',1,'ED006',1,'ED042',1,'ED043',1,'ED079',1,'ED078',1,0)) as flag from o_hrmuser.ded_parm where dedtyp_cd like 'ED0%' and expiration_dt = to_date('12/31/9999','mm/dd/yyyy') /*and internal_empl_id in ('0000037665','0000053439') */group by internal_empl_id order by 1) flag
on 
demo.internal_empl_id = flag.internal_empl_id     
ORDER BY
    employee_id, cldr_yr
