CREATE TABLE STATUS 
(
  STATUSID NUMBER(20, 0) NOT NULL 
, STATUSVALUE VARCHAR2(50) NOT NULL 
, CONSTRAINT STATUS_PK PRIMARY KEY (STATUSID)
);


CREATE TABLE SITE 
(
  SITEID NUMERIC NOT NULL 
, SITENAME VARCHAR2(100) NOT NULL 
, CONSTRAINT SITE_PK PRIMARY KEY (SITEID)
);



CREATE TABLE PRODUCTCATEGORY 
(
  PRODUCTCATEGORYID NUMERIC NOT NULL 
, PRODUCTCATEGORYNAME VARCHAR2(100) NOT NULL 
, CONSTRAINT PRODUCTCATEGORY_PK PRIMARY KEY (PRODUCTCATEGORYID)
);


CREATE TABLE CUSTOMER 
(
  CUSTOMERID NUMBER(20, 0) NOT NULL 
, FIRSTNAME VARCHAR2(500) 
, LASTNAME VARCHAR2(500) 
, EMAIL VARCHAR2(500)  
, USERNAME VARCHAR2(500)  
, PASSWORD VARCHAR2(500)  
, ACCOUNTCREATIONDATE DATE  
, PHONENO VARCHAR2(50)
, CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTOMERID)
);

CREATE TABLE SHIPPINGADDRESS 
(
  SHIPPINGID NUMBER(20, 0) NOT NULL 
, ADDRESS VARCHAR2(500)  
, CITY VARCHAR2(500)  
, STATE VARCHAR2(500)  
, ZIPCODE VARCHAR2(500)  
, COUNTRY VARCHAR2(500)  
, CUSTOMERID NUMBER(20, 0)
,CONSTRAINT SHIPPINGADDRESS_CUSTOMER_FK1 FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMER (CUSTOMERID) 
, CONSTRAINT SHIPPINGADDRESS_PK PRIMARY KEY (SHIPPINGID)
);


CREATE TABLE PAYMENTTYPE 
(
  PAYMENTTYPEID NUMERIC NOT NULL  
, ADDRESS VARCHAR2(500) 
, CITY VARCHAR2(500) 
, STATE VARCHAR2(500) 
, ZIPCODE VARCHAR2(50) 
, COUNTRY VARCHAR2(500) 
, CUSTOMERID NUMERIC 
, CONSTRAINT PAYMENTTYPE_PK PRIMARY KEY (PAYMENTTYPEID)
, CONSTRAINT PAYMENTTYPE_FK1 FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMER(CUSTOMERID)
);


CREATE TABLE ORDERS 
(
  ORDERID NUMERIC NOT NULL 
, SITEID NUMERIC 
, ORDERDATE DATE DEFAULT sysdate 
, STATUSID NUMERIC 
, PAYMENTTYPEID NUMERIC 
, SHIPPINGID NUMERIC 
, CUSTOMERID NUMERIC 
, CONSTRAINT ORDERS_PK PRIMARY KEY (ORDERID)
, CONSTRAINT ORDERS_FK1 FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMER (CUSTOMERID)
, CONSTRAINT ORDERS_FK2 FOREIGN KEY (SHIPPINGID) REFERENCES SHIPPINGADDRESS(SHIPPINGID)
, CONSTRAINT ORDERS_FK3 FOREIGN KEY (PAYMENTTYPEID) REFERENCES PAYMENTTYPE (PAYMENTTYPEID)
, CONSTRAINT ORDERS_FK4 FOREIGN KEY (STATUSID) REFERENCES STATUS(STATUSID)
, CONSTRAINT ORDERS_SITE_FK1 FOREIGN KEY (SITEID) REFERENCES SITE (SITEID)
);


CREATE TABLE PRODUCT 
(
  PRODUCTID NUMERIC NOT NULL 
, MANUFACTURER VARCHAR2(500) 
, FINISH VARCHAR2(500) 
, DESCRIPTION VARCHAR2(500) 
, TITLE VARCHAR2(500) 
, PRODUCTCATEGORYID NUMERIC 
, PRODUCTNUM VARCHAR2(500)
, CONSTRAINT PRODUCT_PK PRIMARY KEY (PRODUCTID)
, CONSTRAINT PRODUCT_PRODUCTCATEGORY_FK1 FOREIGN KEY (PRODUCTCATEGORYID) REFERENCES PRODUCTCATEGORY(PRODUCTCATEGORYID 
)
);


CREATE TABLE ORDER_PRODUCT 
(
  ORDERID NUMERIC NOT NULL 
, UNIQUEID NUMERIC
, PRODUCTID NUMERIC NOT NULL 
, QUANTITY NUMERIC 
, UNIT_PRICE NUMBER(8,2)
, TOTAL_TAX NUMBER(8,5)
, CONSTRAINT ORDER_PRODUCT_PK PRIMARY KEY (UNIQUEID) 
, CONSTRAINT ORDER_PRODUCT_FK1 FOREIGN KEY (ORDERID) REFERENCES ORDERS (ORDERID)
, CONSTRAINT ORDER_PRODUCT_FK2 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID)
);


CREATE TABLE VENDOR 
(
  VENDORID NUMERIC NOT NULL 
, VENDORNAME VARCHAR2(500) NOT NULL 
, CONSTRAINT VENDOR_PK PRIMARY KEY (VENDORID)  
);

CREATE TABLE PURCHASEORDER 
(
  PURCHASEORDERID NUMERIC NOT NULL 
, PURCHASEDATE DATE DEFAULT sysdate 
, ORDERID NUMERIC 
, STATUSID NUMERIC
, VENDORID NUMERIC 
, CONSTRAINT PURCHASEORDER_PK PRIMARY KEY (PURCHASEORDERID)
, CONSTRAINT PURCHASEORDER_FK1 FOREIGN KEY (ORDERID) REFERENCES ORDERS (ORDERID)
, CONSTRAINT PURCHASEORDER_STATUS_FK1 FOREIGN KEY (STATUSID) REFERENCES STATUS (STATUSID)
);

CREATE TABLE PO_ITEM 
(
  PRODUCTID NUMERIC NOT NULL 
, UNITCOST NUMBER(10, 2)  
, PURCHASEORDERID NUMERIC 
, QUANTITY NUMERIC 
, PO_ITEM_ID NUMERIC NOT NULL 
, CONSTRAINT PO_ITEM_PK PRIMARY KEY (PO_ITEM_ID)
, CONSTRAINT PO_ITEM_PURCHASEORDER_FK1 FOREIGN KEY (PURCHASEORDERID) REFERENCES PURCHASEORDER (PURCHASEORDERID)
, CONSTRAINT PRODUCT_VENDOR_FK1 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT(PRODUCTID)
) ;




