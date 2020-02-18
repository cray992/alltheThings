set mapreduce.map.memory.mb 8192;

PaymentClaims = LOAD '${hive_global}.paymentclaim${staging_suffix}' USING org.apache.hive.hcatalog.pig.HCatLoader();

Eob = FOREACH PaymentClaims GENERATE com.kareo.pig.PaymentClaimEob(eobxml, partitioncustomerid, claimid);

FlatEob = FOREACH Eob GENERATE FLATTEN($$0);

UnqualifiedEob = FOREACH FlatEob GENERATE claimid as claimid, type as type, amount as amount, units as units, category as category, code as code, description as description, partitioncustomerid as partitioncustomerid;

STORE UnqualifiedEob INTO '${hive_etl}.paymentclaimeob${etl_suffix}' using org.apache.hive.hcatalog.pig.HCatStorer();