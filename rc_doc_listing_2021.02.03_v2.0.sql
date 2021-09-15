/*
Purpose:    List receivers processed to make payments for annual/monthly orders

Author:     Janet Antunez

Date:       10/06/2020

Notes:
Date        Name        Description
--------    ----------- ------------------------------------------------------
11/29/20    Janet Antunez   Added Commodity Line Info
*/

SELECT h.rf_doc_dept_cd AS "Department", h.rf_doc_cd AS "PO Code", h.rf_doc_id AS "PO Document ID", c.vend_cust_cd AS "Vendor ID", v.vend_cust_lgl_nm AS "Vendor Name"
    , h.doc_cd AS "Document Code", h.doc_id AS "RC Doc ID", h.doc_vers_no AS "Version No" --, h.doc_dept_cd
    , h.doc_crea_dt AS "Created" --, h.doc_phase_cd
    , dpc.doc_phase_nm as "Phase", h.doc_bfy as "Budget FY", h.doc_nm AS "Document Name"
    , doc_comm_ln_no as "Doc Line No"--, doc_comm_no AS "Commodity No", comm_dscr as "Commodity Description"
    , rf_doc_comm_ln_no as "PO Commodity Line No", cl_dscr as "CL Description"
    , unit_meas_cd as "UOM", po_qty AS "Qty Ordered"
    --, tot_qty_rem_recv
    , qty AS "Qty Received", qty_rjct AS "Qty Rejected", tot_recv AS "Total Received"
    , unit_price AS "Unit Price", po_tax_tot_am AS "PO Total Tax", po_itm_tot_am as "PO Item Total", reas as "Reason", addl_cmnt AS "Comment"--, c.dscr_ext as "Extended Desc"
    --, bill_loc_cd AS "Billing Location Code", bill_loc_nm AS "Billing Location Name", bill_ad_1 AS "Billing Address Line 1"
    --, ship_loc_cd AS "Shipping Location Code", ship_loc_nm AS "Shipping Location Name", ship_ad_1 as "Shipping Address Line 1"
    , h.recv_by_cd AS "Receiver ID", h.recv_by_nm AS "Receiver Name"
    , h.doc_last_usid as "Document Last User ID"
FROM advuser.rc_doc_hdr h
    , advuser.rc_doc_vend v
    , advuser.rc_doc_comm c
    , o_advuser.cvl_doc_phase_cd dpc
WHERE 
    h.rf_doc_cd = v.rf_doc_cd AND h.rf_doc_cd = c.rf_doc_cd
    AND h.rf_doc_dept_cd = v.rf_doc_dept_cd AND h.rf_doc_dept_cd = c.rf_doc_dept_cd
    AND h.rf_doc_id = v.rf_doc_id AND h.rf_doc_id = c.rf_doc_id
    AND h.doc_id = v.doc_id AND h.doc_id = c.doc_id
    AND h.doc_vers_no = v.doc_vers_no AND h.doc_vers_no = c.doc_vers_no
    AND v.vend_cust_cd = c.vend_cust_cd
    AND dpc.doc_phase_cd = h.doc_phase_cd
    AND h.doc_dept_cd in ('AD','AN','AR','AO','CB','IB','OE','RE','CF','IO','NW','EB','AM','AU','AW','BH','CA','CC','HM','ME','MV','NH','PD','RP','RT')
    --AND h.rf_doc_id = '20005319'
    AND h.CURR_bfy IN ('2020','2021')
       AND h.doc_phase_cd = '3' --Final
    /****************************************** 
    Document Phases
    0   No Phase
    1   Draft
    2   Pending
    3   Final
    5   Historical (Final)
    6   Conflict Draft
    7   Template
    **************************************/
    --AND h.recv_by_cd IN ('e451457')
    --AND h.doc_crea_dt BETWEEN to_date('12/29/20','mm/dd/yy') AND to_date('12/30/20','mm/dd/yy')  
ORDER BY 
    h.rf_doc_dept_cd, h.rf_doc_cd, h.rf_doc_id, h.doc_id, h.doc_vers_no, c.doc_comm_ln_no