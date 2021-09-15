/************************************************************************************************************************
Purpose:  Generate listing of invoice information for internal analysis of all client departments.
Author:   Janet Antunez
Date:     12/01/2020
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/
SELECT
      b.rf_doc_dept_Cd as "PO Dept Code", b.rf_doc_cd as "PO Doc Code", b.rf_doc_id as "PO ID", A.DOC_iD As "Invoice Doc ID", A.DOC_PHASE_CD as "Phase Code", a.doc_vers_no aS "Doc Version"
    , a.doc_bfy as "BFY"
    , a.vend_cust_cd AS "Vendor Code" --also in b
    , vn.lgl_nm AS "Vendor Name"
    --, b.reas --If added, results should be 'MONTHLY' 
    , a.vend_inv_no AS "Invoice Number" --also in b
    , a.inv_dt AS "Invoice Date"
    , svc_frm_dt as "Service From Date", svc_to_dt as "Service To Date"
    , b.comm_cd as "Comm Code"
    , b.cl_dscr AS "Commodity Description"
    , b.rf_doc_comm_ln_no AS "Line No"
    , b.qty AS "Invoice Qty"
    , b.po_qty - b.qty AS "Qty Balance"
    , b.unit_price AS "Unit Price"
    , b.price AS "Total Price"
    , b.tax_tot_am AS "Tax Amount"
    , b.itm_tot_am  AS "Total Amount"
    , reas as "Reason", addl_cmnt as "Addtl Comment", chk_dscr as "Check Description", b.dscr_ext as "Extended Desc"
    --, b.po_itm_tot_am - itm_tot_am AS "PO Balance Amount"
    --, a.doc_id --also in b
FROM 
    o_advuser.in_doc_hdr a
    , o_advuser.in_doc_comm b
    ,(SELECT vend_cust_cd, lgl_nm
      FROM advuser.r_vend_cust
    ) vn
WHERE
    a.vend_inv_no = b.vend_inv_no
    AND a.vend_cust_cd = b.vend_cust_cd
    AND a.doc_vers_no = b.doc_vers_no
    AND a.doc_id = b.doc_id
    --AND a.rf_doc_id = b.rf_doc_id
    AND a.vend_cust_cd = vn.vend_cust_cd
    AND b.rf_doc_dept_cd IN ('AD','AN','AR','AO','CB','IB','OE','RE','CF','IO','NW','EB','AM','AU','AW','BH','CA','CC','HM','ME','MV','NH','PD','RP','RT')
    and a.doc_bfy in ('2020','2021')
ORDER BY
    b.rf_doc_dept_cd, b.rf_doc_cd, b.rf_doc_id, b.doc_id, b.doc_vers_no
    , a.inv_dt
    , a.vend_inv_no
    , b.doc_comm_ln_no