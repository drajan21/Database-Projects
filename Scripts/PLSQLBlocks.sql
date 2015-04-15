--PROCEDURE TO UPDATE PASSWORD
CREATE OR REPLACE PROCEDURE UPDATE_PASSWORD 
(p_customerid IN customer.customerid%TYPE,
p_password IN  customer.password%TYPE)
IS

v_firstname customer.firstname%TYPE;
v_lastname  customer.lastname%TYPE;

BEGIN
  SELECT firstname, lastname INTO v_firstname, v_lastname FROM customer WHERE customerid = p_customerid;
  
  UPDATE customer
  SET password = p_password
  WHERE customerid = p_customerid;
  
  DBMS_OUTPUT.PUT_LINE('Password upated for Customer ' || v_firstname || ' ' || v_lastname);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('Customer : ' || p_customerid ||' does not exist');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Could not perform action');
END;


--PROCEDURE TO UPDATE ORDER STATUS
CREATE OR REPLACE PROCEDURE UPDATE_ORDER_STATUS 
(p_orderid IN orders.orderid%TYPE,
 p_status IN  status.statusvalue%TYPE)
IS

v_statusid status.statusid%TYPE;
v_statusname status.statusvalue%TYPE;
BEGIN
  SELECT statusid INTO v_statusid FROM status WHERE statusvalue LIKE p_status;
  SELECT statusvalue INTO v_statusname FROM  status
  WHERE statusid = (SELECT statusid FROM orders WHERE orderid = p_orderid);
  
  UPDATE orders
  SET statusid = v_statusid
  WHERE orderid = p_orderid;
  
  DBMS_OUTPUT.PUT_LINE('Status updated for order ' || p_orderid || ' from '|| v_statusname || ' to '|| p_status);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE('Status: '|| p_status ||' does not exist');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Could not perform action');
END;

--PROCEDURE TO CALCULATE THE DAILY SALES TOTAL
CREATE OR REPLACE FUNCTION DAILY_SALES_TOTAL
(f_orderdate IN orders.orderdate%TYPE,
 f_sitename IN site.sitename%TYPE)
RETURN NUMBER

IS

v_total NUMBER(10,2) := 0;

BEGIN
  SELECT sum(quantity * unit_price) INTO v_total
  FROM order_product op
  JOIN orders o ON o.orderid = op.orderid 
  WHERE to_char(o.orderdate,'DD-MON-YY') LIKE to_char(f_orderdate,'DD-MON-YY') AND 
  o.siteid = (SELECT siteid FROM site WHERE sitename LIKE lower(f_sitename))
  AND o.statusid <> 1
  group by to_char(o.orderdate,'DD-MM-YY')
  ;
    
  RETURN v_total;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;


--PROCEDURE TO CALCULATE DAILY PROFIT
CREATE OR REPLACE FUNCTION DAILY_PROFIT
(f_orderdate IN orders.orderdate%TYPE,
 f_sitename IN site.sitename%TYPE)
RETURN NUMBER

IS
v_profit NUMBER(10,2) := 0;
v_total_cost NUMBER(10,2) := 0;
v_total_sales NUMBER(10,2) := 0;

BEGIN

  SELECT SUM(quantity * unitcost) INTO v_total_cost
  FROM po_item po
  JOIN purchaseorder p ON p.purchaseorderid = po.purchaseorderid
  JOIN orders o ON o.orderid = p.orderid
  WHERE o.statusid <> 1 AND
  to_char(orderdate,'DD-MON-YY') LIKE to_char(f_orderdate,'DD-MON-YY') AND 
  siteid = (SELECT siteid FROM site WHERE sitename LIKE lower(f_sitename))
  GROUP BY to_char(orderdate,'DD-MON-YY');
  
  v_total_sales := DAILY_SALES_TOTAL(f_orderdate,f_sitename);
  v_profit := v_total_sales - v_total_cost;
  
  RETURN v_profit;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;


--QUERY FOR wildcat.ca FOR TOP 10
SELECT productid,total,title FROM
(
    SELECT o.productid ,SUM(o.quantity) AS total,p.title FROM order_product o
    JOIN orders od ON od.orderid = o.orderid
    JOIN product p ON p.productid = o.productid
    WHERE od.siteid = 1
    GROUP BY o.productid,p.title
    ORDER BY total DESC
)WHERE ROWNUM <= 10;

--QUERY FOR wildcat.com FOR TOP 10
SELECT productid,total,title FROM
(
    SELECT o.productid ,SUM(o.quantity) AS total,p.title FROM order_product o
    JOIN orders od ON od.orderid = o.orderid
    JOIN product p ON p.productid = o.productid
    WHERE od.siteid = 2
    GROUP BY o.productid,p.title
    ORDER BY total DESC
)WHERE ROWNUM <= 10;


--QUERY FOR wildcat.ca
SELECT SUM((unit_price * quantity)), to_char(o.orderdate,'DD-MON-YY')
FROM ORDER_PRODUCT op
JOIN orders o ON o.orderid = op.orderid
WHERE o.siteid = 1
AND o.statusid <> 1
GROUP BY to_char(o.orderdate,'DD-MON-YY')
ORDER BY to_char(o.orderdate,'DD-MON-YY') asc


--QUERY FOR wildcat.com
SELECT SUM(unit_price * quantity), to_char(o.orderdate,'DD-MON-YY')
FROM ORDER_PRODUCT op
JOIN orders o ON o.orderid = op.orderid
WHERE o.siteid = 2
AND o.statusid <> 1
GROUP BY to_char(o.orderdate,'DD-MON-YY')
ORDER BY to_char(o.orderdate,'DD-MON-YY') asc