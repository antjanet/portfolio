/************************************************************************************************************************
Purpose:  Extracts pay policy records for the cost-of-living increases negotiated with labor unions.
Author:   Janet Antunez
Date:     12/19/2017
Comments:
Date        Author          Comment
--------    ------------    -------------------------------------------------------------------------------------------

************************************************************************************************************************/

SELECT
      paypol_cd
    , 'blank' as paychart_cd        --Value: blank 
    , grde_cd
    , step_cd
    , 'blank' as pay_progrsn_cd     --Value:  blank
    , pay_typ_cd                    --Value: '099'
    , am_bas_id                     --Value: 'P','H'
    , home_dept_cd                  --3.11 Upgrade, new field
    , home_unit_cd                  --3.11 Upgrade, new field
    , union_loc_cd                  --3.11 Upgrade, new field
    , effective_dt
    , NULL AS "New EFFECTIVE_DT"
    , expiration_dt
    , NULL AS "New EXPIRATION_DT"
    , pay_rt_am
    , NULL AS "New PAY_RT_AM"
    , NULL AS "Rate Incrase Old vs New (%)"
    , substr(sal_sched,1,1) AS "SAL_TABLE"
    , substr(sal_sched,2,3) AS "SCHEDULE"
    , NULL AS "New SCHEDULE"
    /* G Grid Salary Table Values */
    --, substr(sal_sched,5,1) AS "LVL" --G Grid Value
    --, substr(pprt_level,1,2) AS "GRID_STEP" --G Grid Value
    --, substr(pprt_level,4,2) AS "LVL_ABOVE" --G Grid Value
    /* Non-G Grid Salary Table Values */
    , 'blank' AS "LVL"              --Non-G Grid Value: set to blank  
    , 'blank' AS "GRID_STEP"        --Non-G Frid Value: set to blank
    , 'blank' AS "LVL_ABOVE"        --Non-G Grid Value: set to blank  
    , SUBSTR(paypol_cd,1,4) AS "Title"
    , SUBSTR(paypol_cd,5,1) AS "Sub-Title"
    , last_update_dt
    , last_update_userid
    , last_update_cmnt
    , NULL AS "Different Schedule?"
    , NULL AS "Expired?" 
    , NULL AS "Current Mthly Rate (Sched)"
    , NULL AS "Current Calc Mthly Rate"
    , NULL AS "Rate Diff (%)"
    , NULL AS "Rate Diff ($)"
    , NULL AS "New Monthly Rate (Sched)"
    , NULL AS "New Calc Monthly Rate"
    , NULL AS "Rate Diff (%)"
    , NULL AS "Rate Diff ($)"
    , NULL AS "Rate Inc Old vs New (Calc)"
    , NULL AS "Rate Inc Old vs New (Sched)"
    , NULL AS "Rate Inc Old vs New"
    , NULL AS "Notes"
FROM o_hrmuser.pay_policy_rate
WHERE
    expiration_dt = TO_DATE('12/31/9999','mm/dd/yyyy')
    AND sal_sched NOT LIKE 'G%'
    --AND sal_sched LIKE 'G%'
    AND grde_cd <> 'NOPAY'
    AND paypol_cd NOT IN ('NOPAY','NOPYF') 
    AND paypol_cd IN
                     (SELECT sttl2.paypol_cd
                      FROM (SELECT sttl1.paypol_cd, ROW_NUMBER() OVER(PARTITION BY paypol_cd, union_loc_cd, expiration_dt ORDER BY expiration_dt desc) AS record
                            FROM o_hrmuser.sub_title sttl1
                             WHERE
                             /* COLA Effective 03/01/2018: sttl1.union_loc_cd IN('860','861','862','863','864','865','866','867','869','905','906','907') --SC 1% increase effective 3/1/18
                             /* COLA Effective 01/01/2018: 991(1203) */
                             /* COLA Effective 04/01/2018: 131(3),  323(11), 324(9660)/980(14218), 325(222), 401(27), 501(3), 311(2,190), 312(880), 703(180), 996(11454), 997(233), 998(16010, 999(812) */   
                             /* sttl1.union_loc_cd IN ('131','132','301','323','324','980','325','331','401','411','412','421','501','502','511','512','603','604','614','621','631','632','721','724','821'
                             ,'105','111','112','121','122','201','211','221','981','222','983','311','312','341','342','431','432','711','722','723','729','982','731','732','777','811','321','703'
                             ,'725','801','802','912','994','995','996','997','998','999','002','022') */
                             --sttl1.union_loc_cd IN ('311','312','725','801','821')
                             --sttl1.union_loc_cd IN ('323','721','724','802','421','321','802','821')
                             sttl1.union_loc_cd = 803
                             --sttl1.paypol_cd LIKE '0838%'
                            ) sttl2
                      WHERE sttl2.record = 1 
                      /* AND 
                      --(paypol_cd LIKE '1055%' OR paypol_cd LIKE '1113%')
                      (paypol_cd LIKE '0437%' OR paypol_cd LIKE '0778%' OR paypol_cd LIKE '0792%' OR paypol_cd LIKE '0781%' OR paypol_cd LIKE '9216%' OR paypol_cd LIKE '0425%' OR paypol_cd LIKE '0783%')
                      */
                     ) 
ORDER BY
    paypol_cd, grde_cd, step_cd
    , expiration_dt desc
