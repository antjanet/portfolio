/************************************************************************************************************************
Purpose:  Provide a report the Chief Executive Office of retirement plan enrollees in Plan E who are active employees.
Author:   Janet Antunez
Date:     December 16, 2016
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT
    b.home_dept_cd AS "Home Dept"
  , d.dept_nm AS "Dept Description"
  --, a.internal_empl_id
  , a.employee_id AS "Employee ID"
  , a.empl_last_nm || ', ' || a.empl_first_nm || ' ' || a.empl_middle_nm AS "Employee Name"
  , b.emplmt_sta_cd AS "Employee Status"
  , b.effective_dt AS "Job Eff Date"
  , b.expiration_dt AS "Job Exp Date"
  , b.title_cd AS "Title Code"
  , b.sub_title_cd AS "Sub Title Code"
  , b.step_cd AS "Step Code"
  , c.dedplan_cd AS "Deduction Plan Code"
  , e.dpln_long_dd AS "Ded Plan Description"
  , c.effective_dt AS "Deduction Eff Date"
  , c.expiration_dt AS "Deduction Exp Date"
FROM
  o_hrmuser.empl a
  , o_hrmuser.empl_asgnmt b
  , o_hrmuser.ded_parm c
  , o_hrmuser.r_dept d
  , o_hrmuser.ded_plan e
WHERE
  a.internal_empl_id = b.internal_empl_id
  AND b.internal_empl_id = c.internal_empl_id
  AND b.expiration_dt = To_Date('12/31/9999','mm/dd/yyyy')
  AND b.emplmt_sta_cd = 'A'
  AND b.appointment_id = ' '
  --AND c.effective_dt BETWEEN b.effective_dt AND b.expiration_dt
  AND c.expiration_dt BETWEEN b.effective_dt AND b.expiration_dt
  AND c.expiration_dt = To_Date('12/31/9999','mm/dd/yyyy')
  --AND c.dedplan_cd IN ('AR080','AR082','AR084','AR086','ER080','ER082','ER084','ER086')
  AND c.dedplan_cd IN ('ER080','ER084')
  AND b.home_dept_cd = d.dept_cd
  AND c.dedplan_cd = e.dedplan_cd
  AND c.effective_dt BETWEEN e.effective_dt AND e.expiration_dt
ORDER BY
  b.home_dept_cd, a.employee_id
