USE AdventureWorks2022
GO

--In this example, the function removes spaces from both ends of the string, resulting in
SELECT TRIM('   Trim example: with extra leading and trailing spaces   ') AS TrimResult

--As with SQL Server 2017, trimming spaces remains the default functionality.
SELECT TRIM('    Naveen, C# Corner MVP!    ') AS DefaultTrimResult

--For example, if you want to remove specific punctuation marks or whitespace, you can use.
SELECT TRIM('.,! ' FROM '...Naveen, C# Corner MVP!') AS NoiseCharTrimResult

--In certain scenarios, it is beneficial to remove only leading characters. The LEADING keyword allows this precise control.
SELECT TRIM(LEADING '.,! ' FROM '...Naveen, C# Corner MVP!!!') AS LeadingTrimResult

--Similarly, if you need to remove trailing characters from a string, the TRAILING keyword comes into play.
SELECT TRIM(TRAILING '.,! ' FROM '...Naveen, C# Corner MVP!!!') AS TrailingTrimResult

--To emulate LTRIM, which removes leading spaces, you can do the following
SELECT TRIM(LEADING ' ' FROM '    Hello, World!    ') AS EmulateLTRIMResult
SELECT TRIM(TRAILING ' ' FROM '    Hello, World!    ') AS EmulateRTRIMResult