--Powershell parse csv

import-csv "npidata_pfile_20050523-20200209.csv" -delimiter ","|
select-object xxxxxxxx |
convertto-csv -notypeinformation |
out-file trimmed_npi
