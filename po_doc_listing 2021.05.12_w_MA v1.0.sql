
/************************************************************************************************************************
Purpose:  Extracts purchase orders for all client departments to be used as a research file in Excel.
Author:   Janet Antunez
Date:     May 2020
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

/* Formatted on 4/12/2020 2:48:37 PM (QP5 v5.326) */
SELECT distinct --poc2.doc_dept_cd, poc2.doc_cd, poc2.doc_id
    --DOC_CREA_USID, doc_crea_dt
    poc2.doc_dept_cd AS "Department"
    , poc2.doc_cd as "Doc Code"
    , poc2.doc_id as "Doc ID"
    , poc2.doc_vers_no as "Version"
    , poc2.curr_bfy as "Budget FY"
    --, poh.agree_vend_ln_no as "MA Vendor Line No"
    --, poc2.curr_fy as "FY"
    --, poc2.curr_per as "Period"
    --, TRUNC(poc2.doc_crea_dt) as "Date Created"
    --, TRUNC(poc2.doc_last_dt) as "Last Updated"
    --, poc2.doc_func_cd as "Function Code"
    --, dfc.doc_func_nm as "Function"
    --, poc2.doc_phase_cd as "Phase Code"
    --, dpc.doc_phase_nm as "Phase"
    , poh.doc_nm as "Document Name"
    , poc2.vend_cust_cd AS "Vendor Code"
    , vc.lgl_nm as "Vendor Name"
    , poc2.doc_comm_ln_no as "Comm Line"
    --, poc2.doc_comm_no as "Commodity No"
    --, poc2.comm_cd as "Commodity Code"
    , poc2.comm_dscr as "Comm Description"
    --, poc2.cl_dscr AS "Line Description"
    , poc2.qty as "Qty Ordered"
    , ROUND(poc2.qty - poc2.rcvd_qty,2) as "Qty Balance"
    , poc2.itm_tot_am as "Line Amount"
    , ROUND(poc2.itm_tot_am - poc2.rfed_am,2) AS "Balance"
    , poc2.rcvd_qty as "Received Qty"
    , POC2.invd_qty as "Invoiced Qty"
    , poc2.pd_qty as "Paid Qty"
    , ROUND(poc2.pd_qty / nullif(poc2.qty,0),2)*100 AS "Qty Percent Paid"
    --, ROUND(poc2.rfed_am / nullif(poc2.itm_tot_am,0),2) AS "Amount Percent Paid"
    , poc2.unit_meas_cd as "UOM"
    , poc2.unit_price as "Unit Price"
    , poc2.tax_tot_am as "Tax Amount"
    --, poc2.invd_cntrc_am as "Invoiced Amt"
    --, CASE WHEN poc2.invd_fnl_fl = '1'  THEN 'Yes' ELSE NULL END AS "Invoiced Final"
    --, poc2.rcvd_cntrc_am as "Received Amt"
    --, CASE WHEN poc2.rcvd_fnl_fl = '1' THEN 'Yes' ELSE NULL END AS "Received Final"
    --, poc2.pd_cntrc_am as "Paid Amt"
    --, poc2.rfed_am as "Referenced Amount"
    --, poc2.mtch_ind as "Match Indicator"
    --, mi.cvl_mtch_ind_dv as "Match Type"
    , CASE WHEN poc2.pd_fnl_fl = '1' THEN 'Yes' ELSE NULL END AS "Paid Final"
    --discount info available
    , poc2.disc_1_pc AS "Discount 1 %", poc2.disc_1_dy AS "Days_1", poc2.disc_alw_1_fl "Disc Alw_1"
    --LSBE Info 1
    --, poc2.vend_cust_cd_1 AS "Vendor ID 1", poc2.lgl_nm_1 "Legal Name_1" --, unit_meas_cd_1, qty_1, unit_price_1, ext_am_1, disc_pc_1, disc_dy_1, net_per_1, dlvr_dt_1, 
    , CASE WHEN poc2.lsbe_vend_fl_1 = '1' THEN 'Yes' ELSE NULL END AS "LSBE Vendor" --, lsbe_pref_am_1, net_am_1
    --LSBE Info 2
    --, poc2.vend_cust_cd_2 AS "Vendor ID 2", poc2.lgl_nm_2 "Legal Name 2"--, unit_meas_cd_2, qty_2, unit_price_2, ext_am_2, disc_pc_2, disc_dy_2, net_per_2, dlvr_dt_2, 
    --, poc2.lsbe_vend_fl_2 AS "LSBE Vendor Flag_2" --, lsbe_pref_am_2, net_am_2
    --LSBE Info 3
    --, poc2.vend_cust_cd_3 AS "Vendor ID 3", poc2.lgl_nm_3 "Legal Name_3" --, unit_meas_cd_3, qty_3, unit_price_3, ext_am_3, disc_pc_3, disc_dy_3, net_per_3, dlvr_dt_3, 
    --, poc2.lsbe_vend_fl_3 AS "LSBE Vendor Flag 3"--, lsbe_pref_am_3, net_am_3
    --, poc2.bill_loc_cd, poc2.bill_loc_nm, poc2.bill_ad_1, poc2.bill_ad_2, poc2.bill_city, poc2.bill_st, poc2.bill_pstl_cd
    --, poc2.ship_loc_cd, poc2.ship_loc_nm, poc2.ship_ad_1, poc2.ship_ad_2, poc2.ship_city, poc2.ship_st, poc2.ship_pstl_cd
    , poh.agree_doc_id as "MA ID"
    , poh.agree_vers_no as "MA Version"
    , mah.efbgn_dt as "MA Start"
    , mah.efend_dt as "MA End"
    --, mah.rqstr_nm as "MA Requester"
    , mah.issr_nm as "MA Issuer"
    , poh.doc_last_usid AS "PO Last User ID"
    , poh.doc_last_dt as "PO Last Update"
FROM (SELECT poc1.*, ROW_NUMBER () OVER (PARTITION BY doc_dept_cd, doc_cd, doc_id, doc_comm_ln_no ORDER BY doc_vers_no DESC) AS record
      FROM o_advuser.po_doc_comm poc1
      ) poc2
    , o_advuser.po_doc_hdr poh
    , o_advuser.ma_doc_hdr mah
    , o_advuser.cvl_doc_func_cd dfc
    , o_advuser.cvl_doc_phase_cd dpc
    , o_advuser.cvl_mtch_ind mi
    , o_advuser.r_vend_cust vc
WHERE
    poh.doc_cd = poc2.doc_cd
    AND poh.doc_id = poc2.doc_id
    AND poh.doc_dept_cd = poc2.doc_dept_cd
    AND poh.doc_vers_no = poc2.doc_vers_no
    AND poh.doc_func_cd = poc2.doc_func_cd
    AND poh.doc_phase_cd = poc2.doc_phase_cd
    AND poh.agree_doc_id = mah.doc_id
    AND poh.agree_vers_no = mah.doc_vers_no
    AND dfc.doc_func_cd = poc2.doc_func_cd
    AND dpc.doc_phase_cd = poc2.doc_phase_cd
    AND mi.cvl_mtch_ind_sv = poc2.mtch_ind
    AND vc.vend_cust_cd = poc2.vend_cust_cd
    AND poc2.record = 1
    --AND poc2.doc_dept_cd IN ('AD','AN','AR','AO','CB','IB','OE','RE','CF','IO','NW','EB','AM','AU','AW','BH','CA','CC','HM','ME','MV','NH','PD','RP','RT')
    AND poc2.doc_dept_cd = 'AN'
    --AND poc2.vend_cust_cd = '034769'
    --AND poh.doc_cd = 'DO'
    --AND poh.doc_id = '21034285' --Medico-Gardena
    --AND poc2.comm_cd = '32525'
    AND poc2.curr_bfy IN ('2019','2020','2021')
    --AND DOC_CREA_USID = 'e521076'
    --AND doc_crea_dt between to_date('11/17/19','mm/dd/yy') and to_date('11/16/20','mm/dd/yy')
    --, poc2.curr_fy as "FY"
    --, poc2.curr_per as "Period"
    --AND vc.lgl_nm LIKE '%LENTZ%'
    AND poh.doc_cd <> 'CBDL'
ORDER BY  
poc2.curr_bfy, poc2.doc_dept_cd, poc2.doc_cd, poc2.doc_id, poc2.doc_comm_ln_no
