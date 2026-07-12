-- =====================================================
-- Topic: String Functions
-- Description:
-- String functions manipulate and transform
-- text/varchar data stored in PostgreSQL.
--
-- ┌──────────────┬──────────────────────────────────────┐
-- │   Function   │ Description                          │
-- ├──────────────┼──────────────────────────────────────┤
-- │ UPPER()      │ Convert to UPPERCASE                 │
-- │ LOWER()      │ Convert to lowercase                 │
-- │ INITCAP()    │ Capitalize First Letter Each Word    │
-- │ LENGTH()     │ Count number of characters           │
-- │ TRIM()       │ Remove spaces both sides             │
-- │ LTRIM()      │ Remove spaces left side only         │
-- │ RTRIM()      │ Remove spaces right side only        │
-- │ CONCAT()     │ Join strings together                │
-- │ CONCAT_WS()  │ Join strings with a separator        │
-- │ SUBSTRING()  │ Extract part of a string             │
-- │ LEFT()       │ Extract N chars from left            │
-- │ RIGHT()      │ Extract N chars from right           │
-- │ REPLACE()    │ Replace part of a string             │
-- │ POSITION()   │ Find position of character           │
-- │ REVERSE()    │ Reverse the string                   │
-- │ SPLIT_PART() │ Split string, get specific part      │
-- └──────────────┴──────────────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 1. UPPER() → Convert text to ALL UPPERCASE
-- -------------------------------------------------------
SELECT name, UPPER(name) AS upper_name
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────────┐
-- │     name      │  upper_name   │
-- ├───────────────┼───────────────┤
-- │ Alice Johnson │ ALICE JOHNSON │
-- │ Bob Smith     │ BOB SMITH     │
-- │ Charlie Brown │ CHARLIE BROWN │
-- └───────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 2. LOWER() → Convert text to all lowercase
-- -------------------------------------------------------
SELECT name, LOWER(name) AS lower_name
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────────┐
-- │     name      │  lower_name   │
-- ├───────────────┼───────────────┤
-- │ Alice Johnson │ alice johnson │
-- │ Bob Smith     │ bob smith     │
-- │ Charlie Brown │ charlie brown │
-- └───────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 3. INITCAP() → Capitalize First Letter of Every Word
-- -------------------------------------------------------
SELECT INITCAP('hello world postgresql') AS result;

-- =====================================================
-- Output:
-- ┌──────────────────────┐
-- │        result        │
-- ├──────────────────────┤
-- │ Hello World Postgresql│
-- └──────────────────────┘
-- =====================================================

-- Fix names that are stored in wrong case
SELECT INITCAP(LOWER('ALICE JOHNSON')) AS fixed_name;

-- =====================================================
-- Output:
-- ┌───────────────┐
-- │  fixed_name   │
-- ├───────────────┤
-- │ Alice Johnson │
-- └───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 4. LENGTH() → Returns number of characters in string
--    Spaces are also counted
-- -------------------------------------------------------
SELECT name, LENGTH(name) AS name_length
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┐
-- │     name      │ name_length │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │     13      │
-- │ Bob Smith     │      9      │
-- │ Charlie Brown │     13      │
-- │ Diana Prince  │     12      │
-- └───────────────┴─────────────┘
-- =====================================================

-- Find employees with name longer than 11 characters
SELECT name, LENGTH(name) AS name_length
FROM employee
WHERE LENGTH(name) > 11;

-- =====================================================
-- Output:
-- ┌───────────────┬─────────────┐
-- │     name      │ name_length │
-- ├───────────────┼─────────────┤
-- │ Alice Johnson │     13      │
-- │ Charlie Brown │     13      │
-- │ Diana Prince  │     12      │
-- │ Julia Roberts │     13      │
-- └───────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 5. TRIM()  → Remove spaces from BOTH sides
--    LTRIM() → Remove spaces from LEFT side only
--    RTRIM() → Remove spaces from RIGHT side only
-- -------------------------------------------------------
SELECT TRIM('   Hello World   ')  AS trimmed;
SELECT LTRIM('   Hello World   ') AS left_trimmed;
SELECT RTRIM('   Hello World   ') AS right_trimmed;

-- =====================================================
-- Output:
-- ┌─────────────────┐
-- │    trimmed      │
-- ├─────────────────┤
-- │  Hello World    │  ← no spaces on either side
-- └─────────────────┘
-- ┌───────────────────┐
-- │   left_trimmed    │
-- ├───────────────────┤
-- │  Hello World      │  ← left spaces removed only
-- └───────────────────┘
-- ┌───────────────────┐
-- │   right_trimmed   │
-- ├───────────────────┤
-- │     Hello World   │  ← right spaces removed only
-- └───────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 6. CONCAT() → Join two or more strings
--    NULL is treated as empty string
-- -------------------------------------------------------
SELECT CONCAT(name, ' works in ', department) AS info
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────────────────────────┐
-- │               info                │
-- ├───────────────────────────────────┤
-- │ Alice Johnson works in Engineering│
-- │ Bob Smith works in Marketing      │
-- │ Charlie Brown works in Engineering│
-- └───────────────────────────────────┘
-- =====================================================

-- CONCAT with NULL → NULL is ignored
SELECT CONCAT('Hello', NULL, 'World') AS result;

-- =====================================================
-- Output:
-- ┌────────────┐
-- │   result   │
-- ├────────────┤
-- │ HelloWorld │
-- └────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 7. CONCAT_WS(separator, val1, val2 ...) 
--    Concat With Separator
--    NULL values are SKIPPED automatically
-- -------------------------------------------------------
SELECT CONCAT_WS(' | ', name, department, status) AS employee_card
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────────────────────────┐
-- │          employee_card          │
-- ├─────────────────────────────────┤
-- │ Alice Johnson | Engineering | active   │
-- │ Bob Smith | Marketing | active         │
-- │ Diana Prince | HR | inactive           │
-- └─────────────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 8. SUBSTRING(string, start, length)
--    Extract part of a string
--    Position counting starts from 1
-- -------------------------------------------------------
SELECT SUBSTRING('PostgreSQL', 1, 8) AS result;

-- =====================================================
-- Output:
-- ┌──────────┐
-- │  result  │
-- ├──────────┤
-- │ PostgreS │
-- └──────────┘
-- =====================================================

-- Extract first 5 characters of each name
SELECT name, SUBSTRING(name, 1, 5) AS short_name
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┐
-- │     name      │ short_name │
-- ├───────────────┼────────────┤
-- │ Alice Johnson │   Alice    │
-- │ Bob Smith     │   Bob S    │
-- │ Charlie Brown │   Charl    │
-- │ Diana Prince  │   Diana    │
-- └───────────────┴────────────┘
-- =====================================================

-- Extract domain from email using POSITION + SUBSTRING
SELECT email,
       SUBSTRING(email, POSITION('@' IN email) + 1) AS domain
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────────────┬─────────────┐
-- │         email         │   domain    │
-- ├───────────────────────┼─────────────┤
-- │ alice@company.com     │ company.com │
-- │ bob@company.com       │ company.com │
-- └───────────────────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 9. LEFT(string, n)  → Get first N characters from left
--    RIGHT(string, n) → Get last N characters from right
-- -------------------------------------------------------
SELECT LEFT('PostgreSQL', 4)  AS left_result;
SELECT RIGHT('PostgreSQL', 3) AS right_result;

-- =====================================================
-- Output:
-- ┌─────────────┐    ┌──────────────┐
-- │ left_result │    │ right_result │
-- ├─────────────┤    ├──────────────┤
-- │    Post     │    │     SQL      │
-- └─────────────┘    └──────────────┘
-- =====================================================

-- Short department code (first 3 letters)
SELECT department,
       LEFT(department, 3)  AS dept_code,
       RIGHT(department, 3) AS dept_end
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────┬───────────┬──────────┐
-- │ department  │ dept_code │ dept_end │
-- ├─────────────┼───────────┼──────────┤
-- │ Engineering │    Eng    │   ing    │
-- │ Marketing   │    Mar    │   ing    │
-- │ HR          │    HR     │    HR    │
-- └─────────────┴───────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 10. REPLACE(string, old_text, new_text)
--     Replace part of string with new text
-- -------------------------------------------------------
SELECT REPLACE('Hello World', 'World', 'PostgreSQL') AS result;

-- =====================================================
-- Output:
-- ┌───────────────────┐
-- │      result       │
-- ├───────────────────┤
-- │ Hello PostgreSQL  │
-- └───────────────────┘
-- =====================================================

-- Replace email domain
SELECT email,
       REPLACE(email, '@company.com', '@newdomain.com') AS new_email
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────────────┬──────────────────────────┐
-- │         email         │         new_email         │
-- ├───────────────────────┼──────────────────────────┤
-- │ alice@company.com     │ alice@newdomain.com       │
-- │ bob@company.com       │ bob@newdomain.com         │
-- │ charlie@company.com   │ charlie@newdomain.com     │
-- └───────────────────────┴──────────────────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 11. POSITION(substring IN string)
--     Returns position of first match
--     Returns 0 if not found
-- -------------------------------------------------------
SELECT POSITION('@' IN 'alice@company.com') AS at_position;

-- =====================================================
-- Output:
-- ┌─────────────┐
-- │ at_position │
-- ├─────────────┤
-- │      6      │  ← @ is at position 6
-- └─────────────┘
-- =====================================================

-- Find space position in each name
SELECT name,
       POSITION(' ' IN name) AS space_at
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬──────────┐
-- │     name      │ space_at │
-- ├───────────────┼──────────┤
-- │ Alice Johnson │    6     │
-- │ Bob Smith     │    4     │
-- │ Charlie Brown │    8     │
-- │ Diana Prince  │    6     │
-- └───────────────┴──────────┘
-- =====================================================


-- -------------------------------------------------------
-- 12. REVERSE() → Reverse all characters in a string
-- -------------------------------------------------------
SELECT REVERSE('PostgreSQL') AS result;

-- =====================================================
-- Output:
-- ┌────────────┐
-- │   result   │
-- ├────────────┤
-- │ LQSertsoP  │
-- └────────────┘
-- =====================================================

SELECT name, REVERSE(name) AS reversed
FROM employee
LIMIT 3;

-- =====================================================
-- Output:
-- ┌───────────────┬───────────────┐
-- │     name      │   reversed    │
-- ├───────────────┼───────────────┤
-- │ Alice Johnson │ nosnhoJ ecilA │
-- │ Bob Smith     │ htimS boB     │
-- │ Charlie Brown │ nworB eilrahC │
-- └───────────────┴───────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 13. SPLIT_PART(string, delimiter, part_number)
--     Splits string by delimiter and returns the Nth part
-- -------------------------------------------------------
SELECT SPLIT_PART('Alice Johnson', ' ', 1) AS first_name;
SELECT SPLIT_PART('Alice Johnson', ' ', 2) AS last_name;

-- =====================================================
-- Output:
-- ┌────────────┐    ┌───────────┐
-- │ first_name │    │ last_name │
-- ├────────────┤    ├───────────┤
-- │   Alice    │    │  Johnson  │
-- └────────────┘    └───────────┘
-- =====================================================

-- Split all employee names into first and last name
SELECT
    name,
    SPLIT_PART(name, ' ', 1) AS first_name,
    SPLIT_PART(name, ' ', 2) AS last_name
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────┬────────────┬───────────┐
-- │     name      │ first_name │ last_name │
-- ├───────────────┼────────────┼───────────┤
-- │ Alice Johnson │   Alice    │  Johnson  │
-- │ Bob Smith     │    Bob     │   Smith   │
-- │ Charlie Brown │  Charlie   │   Brown   │
-- │ Diana Prince  │   Diana    │  Prince   │
-- │ Edward King   │   Edward   │   King    │
-- └───────────────┴────────────┴───────────┘
-- =====================================================

-- Split email into username and domain
SELECT
    email,
    SPLIT_PART(email, '@', 1) AS username,
    SPLIT_PART(email, '@', 2) AS domain
FROM employee;

-- =====================================================
-- Output:
-- ┌───────────────────────┬──────────┬─────────────┐
-- │         email         │ username │    domain   │
-- ├───────────────────────┼──────────┼─────────────┤
-- │ alice@company.com     │  alice   │ company.com │
-- │ bob@company.com       │   bob    │ company.com │
-- │ charlie@company.com   │ charlie  │ company.com │
-- └───────────────────────┴──────────┴─────────────┘
-- =====================================================


-- -------------------------------------------------------
-- 14. Combining Multiple String Functions Together
-- -------------------------------------------------------

-- Create a formatted employee profile string
SELECT
    CONCAT_WS(' | ',
        UPPER(SPLIT_PART(name, ' ', 1)),
        INITCAP(department),
        CONCAT('$', salary)
    ) AS employee_profile
FROM employee;

-- =====================================================
-- Output:
-- ┌─────────────────────────────────┐
-- │         employee_profile        │
-- ├─────────────────────────────────┤
-- │ ALICE | Engineering | $85000.00 │
-- │ BOB | Marketing | $60000.00     │
-- │ CHARLIE | Engineering | $90000  │
-- └─────────────────────────────────┘
-- =====================================================

-- Find employees whose email username matches first name
SELECT name, email
FROM employee
WHERE LOWER(SPLIT_PART(name, ' ', 1)) = SPLIT_PART(email, '@', 1);

-- =====================================================
-- Output: (all match in our dataset)
-- ┌───────────────┬───────────────────────┐
-- │     name      │         email         │
-- ├───────────────┼───────────────────────┤
-- │ Alice Johnson │ alice@company.com     │
-- │ Bob Smith     │ bob@company.com       │
-- │ Charlie Brown │ charlie@company.com   │
-- │ Diana Prince  │ diana@company.com     │
-- │ Edward King   │ edward@company.com    │
-- └───────────────┴───────────────────────┘
-- =====================================================