/************************************************************************************************************************
Purpose:  Extract listing of eployees and their deduction details for the retirement plans listed.
Author:   Janet Antunez
Date:     09/16/2014
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/
SELECT b.doc_id, a.employee_id, b.effective_dt, b.dedtyp_cd, b.ded_am, b.subj_gross_am, b.last_update_dt, b.last_update_userid
FROM 
    o_hrmuser.empl a
    , o_hrmuser.ded_detl b
WHERE   
    a.internal_empl_id = b.internal_empl_id 
    AND dedtyp_cd IN (
    'ED001','ED002','ED003','ED004','ED005','ED006',
    'ED038','ED039','ED040','ED041','ED042','ED043',
    'ED074','ED075','ED076','ED077','ED078','ED079','ED007','ED008',
    'RD001','RD002','RD003','RD004','RD005','RD006',
    'RD038','RD039','RD040','RD041','RD042','RD043',
    'RD074','RD075','RD076','RD077','RD078','RD079','RD007','RD008')
    AND effective_dt = TO_DATE('06/30/2011','MM/DD/YYYY')
    --AND effective_dt BETWEEN TO_DATE('07/01/2011','MM/DD/YYYY') AND TO_DATE('07/31/2011','MM/DD/YYYY')
ORDER BY
    doc_id
    , employee_id
    , b.effective_dt
