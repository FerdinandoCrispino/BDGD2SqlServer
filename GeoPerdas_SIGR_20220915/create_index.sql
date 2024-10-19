CREATE INDEX idx_eqme_uc_ug_pac ON sde.EQME (UC_UG, PAC);
CREATE INDEX idx_ucmt_dist_sub_pncon ON sde.UCMT (DIST, SUB, PN_CON);
CREATE INDEX idx_ucmt_cod_id ON sde.UCMT (COD_ID);
CREATE INDEX idx_ucmt_pac ON sde.UCMT (PAC);
CREATE INDEX idx_ucmt_ctmt ON sde.UCMT (CTMT);
CREATE INDEX idx_ucmt_ten_forn ON sde.UCMT (TEN_FORN);