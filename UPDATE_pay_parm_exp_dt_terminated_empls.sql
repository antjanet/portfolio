/************************************************************************************************************************
Purpose:  DML SQL for updating the expiration date of pay parameters of terminated employees.
          The expiration date should ideally be set to one day before the effective date of the termination.

Author:   Janet Antunez

Date:     Wednesday, June 3, 2013

Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------


************************************************************************************************************************/
UPDATE o_hrmupser.pay_parm
SET expiration_dt = (
                      SELECT a.effective_dt - 1
                      FROM o_hrmuser.empl_asgnmt a, o_hrmuser.pay_parm b
                      WHERE a.internal_empl_id = b.internal_empl_id
                        AND a.appointment_id = b.appointment_id
                        AND a.effective_dt BETWEEN b.effective_dt AND b.expiration_dt
                        AND a.emplmt_sta_cd <> 'A'
                        AND a.union_loc_cd IN ('611','612')
                        AND b.evnt_cd = '209'
                    )
