-- Query BigQuery: Tabel Analisis Gabungan
SELECT
  tr.transaction_id,
  tr.date,
  cb.branch_id,
  cb.branch_name,
  cb.kota,
  cb.provinsi,
  cb.rating AS rating_cabang,
  tr.customer_name,
  tr.product_id,
  pr.product_name,
  tr.price AS actual_price,
  tr.discount_percentage,

  CASE
    WHEN tr.price <= 50000 THEN 10
    WHEN tr.price <= 100000 THEN 15
    WHEN tr.price <= 300000 THEN 20
    WHEN tr.price <= 500000 THEN 25
    ELSE 30
  END AS persentase_gross_laba,

  ROUND(tr.price * (1 - tr.discount_percentage / 100), 2) AS nett_sales,

  ROUND((tr.price * (1 - tr.discount_percentage / 100)) * (
    CASE
      WHEN tr.price <= 50000 THEN 0.10
      WHEN tr.price <= 100000 THEN 0.15
      WHEN tr.price <= 300000 THEN 0.20
      WHEN tr.price <= 500000 THEN 0.25
      ELSE 0.30
    END
  ), 2) AS nett_profit,

  tr.rating AS rating_transaksi

FROM `Rakamin_KF_Analytics.kimia_farma.kf_final_transaction` AS tr
JOIN `Rakamin_KF_Analytics.kimia_farma.kf_kantor_cabang` AS cb
  ON tr.branch_id = cb.branch_id
JOIN `Rakamin_KF_Analytics.kimia_farma.kf_product` AS pr
  ON tr.product_id = pr.product_id;
