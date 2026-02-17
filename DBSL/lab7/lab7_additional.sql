SET
    SERVEROUTPUT ON;

-- Usage of IF-THEN
-- 1. Write a PL/SQL block to find out if a year is a leap year.
DECLARE v_year NUMBER := & year;

BEGIN IF (MOD(v_year, 400) = 0)
OR (
    MOD(v_year, 4) = 0
    AND MOD(v_year, 100) != 0
) THEN DBMS_OUTPUT.PUT_LINE(v_year || ' is a Leap Year.');

ELSE DBMS_OUTPUT.PUT_LINE(v_year || ' is NOT a Leap Year.');

END IF;

END;

/ -- 2. You went to a video store and rented DVD that is due in 3 days from the rental date. Input the rental date, rental month and rental  year. Calculate  and print the  return date, return month, and return year.
DECLARE v_day NUMBER := & day;

v_month NUMBER := & month;

v_year NUMBER := & year;

v_rent_date DATE;

v_return_date DATE;

BEGIN -- Construct rental date
v_rent_date := TO_DATE(
    v_day || '-' || v_month || '-' || v_year,
    'DD-MM-YYYY'
);

-- Add 3 days
v_return_date := v_rent_date + 3;

-- Display return date
DBMS_OUTPUT.PUT_LINE(
    'Return Date: ' || TO_CHAR(v_return_date, 'DD')
);

DBMS_OUTPUT.PUT_LINE(
    'Return Month: ' || TO_CHAR(v_return_date, 'MM')
);

DBMS_OUTPUT.PUT_LINE(
    'Return Year: ' || TO_CHAR(v_return_date, 'YYYY')
);

END;

/ -- Simple LOOP
-- 3. Write a simple loop such that message is displayed when a loop exceeds a particular value.
DECLARE v_counter NUMBER := 1;

BEGIN LOOP DBMS_OUTPUT.PUT_LINE('Counter = ' || v_counter);

v_counter := v_counter + 1;

IF v_counter > 5 THEN DBMS_OUTPUT.PUT_LINE('Loop exceeded the limit.');

EXIT;

END IF;

END LOOP;

END;

/ -- 4. Write a PL/SQL block to print all odd numbers between 1 and 10.
BEGIN FOR i IN 1..10 LOOP IF MOD(i, 2) != 0 THEN DBMS_OUTPUT.PUT_LINE(i);

END IF;

END LOOP;

END;

/ -- Usage of WHILE
-- 5. Write a PL/SQL block to reverse a given string.
DECLARE v_str VARCHAR2(100) := '&input_string';

v_reverse VARCHAR2(100) := '';

i NUMBER;

BEGIN FOR i IN REVERSE 1..LENGTH(v_str) LOOP v_reverse := v_reverse || SUBSTR(v_str, i, 1);

END LOOP;

DBMS_OUTPUT.PUT_LINE('Original String: ' || v_str);

DBMS_OUTPUT.PUT_LINE('Reversed String: ' || v_reverse);

END;

/ -- Usage of FOR
-- 6. Write a PL/SQL block of code for inverting a number 5639 or 9365.
DECLARE v_num NUMBER := & number;

v_reverse NUMBER := 0;

v_digit NUMBER;

BEGIN WHILE v_num > 0 LOOP v_digit := MOD(v_num, 10);

v_reverse := v_reverse * 10 + v_digit;

v_num := TRUNC(v_num / 10);

END LOOP;

DBMS_OUTPUT.PUT_LINE('Reversed Number: ' || v_reverse);

END;

/ -- Usage of GOTO
/* 7. Write a PL/SQL block of code to achieve the following: if the price of Product 'p00001' is less than 4000, then change the price to 4000. The Price change has to be recorded in the old_price_table along with Product_no and the date on which the price was last changed. Tables involved:
 Product_master(product_no, sell_price) 
 Old_price_table(product_no,date_change, Old_price)
 */
DECLARE v_price Product_master.sell_price % TYPE;

BEGIN -- Fetch current price
SELECT
    sell_price INTO v_price
FROM
    Product_master
WHERE
    product_no = 'p00001';

IF v_price < 4000 THEN
INSERT INTO
    Old_price_table
VALUES
    ('p00001', SYSDATE, v_price);

UPDATE
    Product_master
SET
    sell_price = 4000
WHERE
    product_no = 'p00001';

COMMIT;

DBMS_OUTPUT.PUT_LINE('Price updated to 4000.');

ELSE DBMS_OUTPUT.PUT_LINE('No change required.');

END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Product not found.');

END;

/ -- Exception
-- 8. Write a PL/SQL block that asks the user to input first number, second number and an arithmetic operator (+, -, *, /). If the operator is invalid, throw and handle a user-defined exception. If the second number is zero and the operator is /, handle the ZERO_DIVIDE predefined server exception.
DECLARE v_num1 NUMBER := & first_number;

v_num2 NUMBER := & second_number;

v_op CHAR(1) := '&operator';

v_result NUMBER;

invalid_operator EXCEPTION;

BEGIN IF v_op = '+' THEN v_result := v_num1 + v_num2;

ELSIF v_op = '-' THEN v_result := v_num1 - v_num2;

ELSIF v_op = '*' THEN v_result := v_num1 * v_num2;

ELSIF v_op = '/' THEN v_result := v_num1 / v_num2;

ELSE RAISE invalid_operator;

END IF;

DBMS_OUTPUT.PUT_LINE('Result = ' || v_result);

EXCEPTION
WHEN invalid_operator THEN DBMS_OUTPUT.PUT_LINE('Error: Invalid Operator Entered.');

WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('Error: Division by zero is not allowed.');

WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected Error Occurred.');

END;

/