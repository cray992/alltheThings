UPDATE clearinghouseresponse
set reviewedflag = 1
where filereceivedate < '1/1/2007' and reviewedflag = 0 and practiceid > 0