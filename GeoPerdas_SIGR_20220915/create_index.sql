CREATE INDEX idx_eqme_uc_ug_pac ON sde.EQME (UC_UG, PAC);
CREATE INDEX idx_ucmt_dist_sub_pncon ON sde.UCMT (DIST, SUB, PN_CON);
CREATE INDEX idx_ucmt_cod_id ON sde.UCMT (COD_ID);
CREATE INDEX idx_ucmt_pac ON sde.UCMT (PAC);
CREATE INDEX idx_ucmt_ctmt ON sde.UCMT (CTMT);
CREATE INDEX idx_ucmt_ten_forn ON sde.UCMT (TEN_FORN);
CREATE INDEX idx_ponnot_cod_id ON sde.PONNOT (COD_ID);
CREATE INDEX idx_ucbt_pac ON sde.UCBT (PAC);
CREATE INDEX idx_ssdbt_pac1 ON sde.SSDBT (PAC_1);
CREATE INDEX idx_ssdbt_pac2 ON sde.SSDBT (PAC_2);
CREATE INDEX idx_ssdmt_pac1 ON sde.SSDMT (PAC_1);
CREATE INDEX idx_ssdmt_pac2 ON sde.SSDMT (PAC_2);
CREATE INDEX idx_ramlig_pac1 ON sde.RAMLIG (PAC_1);
CREATE INDEX idx_ramlig_pac2 ON sde.RAMLIG (PAC_2)
CREATE INDEX idx_rm_pac1_pac2 ON sde.ramlig(PAC_1, PAC_2);
CREATE INDEX idx_pn_pac1_pac2 ON sde.SSDBT(PAC_1, PAC_2);
CREATE INDEX idx_uc_point_x ON sde.ucbt(POINT_X,POINT_Y );
CREATE INDEX idx_uc_ceg ON sde.ucbt(ceg);
CREATE INDEX idx_ug_ceg ON sde.ugbt(ceg);