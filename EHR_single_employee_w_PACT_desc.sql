/************************************************************************************************************************
Purpose:  Execute this query to analyze a single employee's job and personnel action history.
Author:   Janet Antunez
Date:     April 2013
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT employee_id, empl_last_nm, empl_first_nm, empl_middle_nm, home_unit_cd, doc_typ, doc_id, home_dept_cd AS "HM DPT", appointment_id AS "JOB ID"
    , es.emplmt_sta_cd STATUS, es.title_cd TITLE
    , t.titl_long_dd as "TITL DESC"
    , sub_title_cd SUBTITLE
    , step_cd, job_appt_dt JAD, appointment_dt as "APPT DT"  
    , CASE WHEN es.component_action = '0' THEN 'Undo'
           WHEN es.component_action = '1' THEN 'Update'
           WHEN es.component_action = '2' THEN 'Delete'
      END AS ACTION
    , es.pers_actn_cd AS "PACT", pa.pact_long_dd, es.effective_dt EFFECTIVE, es.expiration_dt AS EXPIRATION
    , doc_last_dt, doc_last_usid --es.*
FROM o_hrmuser.esmt_doc_hdr es
    , o_hrmuser.personnel_action pa
    , o_hrmuser.title t
WHERE 
    es.pers_actn_cd = pa.pers_actn_cd
    AND es.title_cd = t.title_cd
    AND es.effective_dt BETWEEN pa.effective_dt AND pa.expiration_dt
    AND es.effective_dt BETWEEN t.effective_dt AND t.expiration_dt 
    AND es.doc_phase_cd = '3' AND employee_id = '654552'
    --AND empl_last_nm = ''
    --AND es.employee_id = 164110 
    --AND es.component_action <> '1'
ORDER BY es.employee_id, es.doc_last_dt, es.effective_dt
