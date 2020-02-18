
/***ADD Columns Cancelled and CancellationDate to disallow access to cancelled accounts*/
ALTER TABLE CUSTOMER 
ADD Cancelled BIT NULL
CONSTRAINT DF_Customer_Cancelled
DEFAULT 0 WITH VALUES

ALTER TABLE Customer ADD CancellationDate DATETIME NULL

/********************************************/
/*PENDING CANCELLED CUSTOMERS - SET Cancelled bit to 1*/
