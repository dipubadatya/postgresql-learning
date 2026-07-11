-- =====================================================
-- Topic: INSERT
-- Description:
-- INSERT is used to add new records into a table.
-- =====================================================

INSERT INTO person (name, age)
VALUES
('John',22),
('Alice',25),
('Bob',30);

-- View inserted data
SELECT * FROM person;