# Run ETLs in Spark
ssh kp-sam.santella@las-pdx-hdat-01.kareoprod.ent
cd Hadoop-import
bin/run_etl.py spark etl/hive/ar_etl.hive
