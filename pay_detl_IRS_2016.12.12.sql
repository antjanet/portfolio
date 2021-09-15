/************************************************************************************************************************
Purpose:  Provide pay details of sample population to the IRS for payroll audit.
Author:   Janet Antunez
Date:     December 12, 2012
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT employee_id,
  b.title_cd AS title, b.sub_title_cd AS subtitle,
  b.appointment_id AS appt_id,
  b.chk_dt,
  b.effective_dt,
  b.doc_cd,
  b.doc_dept_cd,
  b.doc_id,
  event_desc.*,
  b.cntrct_py_am,
  b.input_am,
  b.pay_rt_am,
  b.last_update_dt, b.last_update_userid
FROM 
    o_hrmuser.empl a
    , o_hrmuser.pay_detl b
    , (SELECT evnt_typ_cd, evnt_long_dd, evnt_short_dd
       FROM o_hrmuser.evnt_type
       WHERE expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
      ) event_desc
WHERE
    a.internal_empl_id = b.internal_empl_id
    AND b.evnt_typ_cd = event_desc.evnt_typ_cd(+)
    AND chk_dt BETWEEN to_date('01/01/2017','mm/dd/yyyy') AND to_date('01/31/2017','mm/dd/yyyy')
    AND employee_id = --enter employee sample list here
ORDER BY employee_id, b.chk_dt, b.evnt_typ_cd, b.input_am
