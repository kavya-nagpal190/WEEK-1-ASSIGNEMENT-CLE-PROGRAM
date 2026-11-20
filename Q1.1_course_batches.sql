-- Q1.1  Create, Load, Update and Roll Back the Course Batches Table
DROP TABLE IF EXISTS course_batches;

CREATE TABLE course_batches (
    batch_id    INT          PRIMARY KEY,
    subject_id  VARCHAR(5)   NOT NULL,
    batch_name  VARCHAR(40)  NOT NULL,
    start_date  DATE         NOT NULL,
    capacity    INT          CHECK (capacity > 0),
    trainer     VARCHAR(40)  NULL,
    status      VARCHAR(10)  DEFAULT 'Planned'
);

-- Insert the initial batches
INSERT INTO course_batches (batch_id, subject_id, batch_name, start_date, capacity, trainer)
VALUES (1, 'S01', 'SQL Morning Batch',      '2026-04-01', 30, NULL),
       (2, 'S02', 'Python Weekend Batch',   '2026-04-05', 25, 'Ritu Sharma'),
       (3, 'S03', 'Visualization Evening',  '2026-05-10', 20, NULL),
       (4, 'S01', 'SQL Evening Batch',      '2026-03-20', 30, 'Amit Bansal');

-- This insert should fail because capacity must be greater than zero
BEGIN TRY
    INSERT INTO course_batches (batch_id, subject_id, batch_name, start_date, capacity)
    VALUES (5, 'S04', 'Stats Crash Course', '2026-04-15', 0);
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER()  AS error_number,
           ERROR_MESSAGE() AS error_message;      -- error 547 (CHECK constraint)
END CATCH;

-- Assign trainers
UPDATE course_batches SET trainer = 'Neha Joshi'  WHERE batch_id = 1;
UPDATE course_batches SET trainer = 'Ritu Sharma' WHERE batch_id = 3;

-- Delete inside a transaction and roll it back
BEGIN TRANSACTION;
    DELETE FROM course_batches WHERE status = 'Planned';
    SELECT COUNT(*) AS rows_after_delete FROM course_batches;     -- 0 rows
ROLLBACK TRANSACTION;
SELECT COUNT(*) AS rows_after_rollback FROM course_batches;       -- 4 rows are back

-- Open batches starting on or before 2026-04-01
UPDATE course_batches
SET    status = 'Open'
WHERE  start_date <= '2026-04-01';

-- Final result
SELECT * FROM course_batches ORDER BY batch_id;
GO
