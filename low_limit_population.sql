/************************************************************************************************************************
Purpose:  Identify retirement plan enrolles in the low limit plans. 
Author:   Janet Antunez
Date:     April 2013
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT employee_id, ll.*
FROM empl a, (
SELECT distinct (internal_empl_id)
--, dedtyp_cd
, min(effective_dt) AS "From"
, max(expiration_dt) AS "To"
FROM 
    ded_parm
WHERE
    dedtyp_cd IN (
    'ED009','ED001','ED010','ED002','ED056','ED050','ED051' --County Non-Represented
    ,'ED044','ED038','ED045','ED039' --Superior Courts Non-Represented Employees
    ,'ED080','ED074','ED081','ED075' --LACERA Non-Represented 
    )
    --AND effective_dt between to_date('12/16/2016','mm/dd/yyyy') and to_date('12/15/2017','mm/dd/yyyy')
    AND ovrd_ded_pc > 0
    --AND expiration_dt = to_date('12/31/9999','mm/dd/yyyy')
    AND (effective_dt <= to_date('12/31/2018','mm/dd/yyyy') AND expiration_dt >= to_date('12/31/2017','mm/dd/yyyy'))
GROUP BY internal_empl_id
ORDER BY 1) ll
WHERE a.internal_empl_id = ll.internal_empl_id
ORDER BY employee_id
