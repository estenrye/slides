-- Create a new table called '[test]' in schema '[dbo]'
-- Drop the table if it already exists
IF OBJECT_ID('[dbo].[test]', 'U') IS NOT NULL
DROP TABLE [dbo].[test]
GO
-- Create the table in the specified schema
CREATE TABLE [dbo].[test]
(
    [Id] INT NOT NULL PRIMARY KEY, -- Primary Key column
    [name] NVARCHAR(50) NOT NULL,
    [value] NVARCHAR(50) NOT NULL
    -- Specify more columns here
);
GO

-- Insert rows into table 'test' in schema '[dbo]'
INSERT INTO [dbo].[test]
( -- Columns to insert data into
 Id, name, value
)
VALUES
( -- First row: values for the columns in the list above
 1, N'hello', N'world'
),
( -- Second row: values for the columns in the list above
 2, N'nice',N'day'
)
-- Add more rows here
GO