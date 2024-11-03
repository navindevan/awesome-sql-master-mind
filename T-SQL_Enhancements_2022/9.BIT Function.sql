USE AdventureWorks2022
GO

CREATE TABLE dbo.Employee (
  EmployeeId   int IDENTITY PRIMARY KEY,
  FirstName    varchar(50),
  LastName     varchar(50),
  AccessLevels tinyint,  -- Store access levels or permissions across 8 single-bit values (0 or 1) in a single byte (0-255)
  ColorCode    tinyint   -- Store RGB color components in 3 bits (Red, Green, Blue) in a single byte (0-255)
);


INSERT INTO dbo.Employee (FirstName, LastName, AccessLevels, ColorCode) VALUES
  ('Naveen', 'Kumar', 0x01, 0x07),
  ('Shaukat', 'Salim', 0x23, 0x16),
  ('Gaurav', 'Sharma', 0x3C, 0x3C),
  ('Pranav', 'Jujaray', 0x1A, 0x32),
  ('Mohan', 'B', 0xFF, 0xFF);
  

SELECT 
  FirstName,
  AccessLevels,
  AccessLevelCount = BIT_COUNT(AccessLevels)
FROM  dbo.Employee;

SELECT 
  FirstName,
  AccessLevels,
  ReadPermission = GET_BIT(AccessLevels, 0),
  WritePermission = GET_BIT(AccessLevels, 1),
  ExecutePermission = GET_BIT(AccessLevels, 2),
  DeletePermission = GET_BIT(AccessLevels, 3),
  AdminPermission = GET_BIT(AccessLevels, 4)
FROM dbo.Employee;


SELECT 
  FirstName,
  ColorCode,
  RedComponent   = RIGHT_SHIFT(ColorCode, 6),
  GreenComponent = (ColorCode & 0x30) >> 4,
  BlueComponent  = ColorCode & 0x0F
FROM dbo.Employee;
