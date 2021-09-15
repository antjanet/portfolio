/************************************************************************************************************************
Purpose:  Data cleanse leav_evnt_type table in eHR. Delete rows from the leav_evnt_type table where the evevnt code is a pay event.
          Only "leave" events should be stored in this table.

Author:   Janet Antunez

Date:     April 3, 2013

Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------
04/03/13    J.Antunez         Record count to be deleted is 3,977

************************************************************************************************************************/
/* Selects the records to be deleted. Used for reconciliation */
SELECT *
FROM o_hrmuser.leav_evnt_type
WHERE leav_evnt_cd LIKE 'P%'
ORDER BY 2;

/* Displays the record count to be deleted; should match the record count from the prior SELECT statement. Also used for reconciliation. */
SELECT Count(ROWNUM)
FROM o_hrmuser.leav_evnt_type
WHERE leav_evnt_cd LIKE 'P%';

/* Delete the records where the event code begins with 'P'; these are the pay events. */
DELETE FROM o_hrmuser.leav_evnt_type
WHERE leav_evnt_cd LIKE 'P%';

--COMMIT;
