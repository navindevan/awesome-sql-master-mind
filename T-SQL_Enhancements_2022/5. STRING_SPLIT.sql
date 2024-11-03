USE AdventureWorks2022
GO

--Syntax: STRING_SPLIT (string , separator);
--string: The string to be split.
--separator: The character used to separate the string into parts.

--Example:
SELECT value FROM STRING_SPLIT('STRING_SPLIT,New,SQL,Server,2022,Enhancement', ',')

--New Ordinal Enhancement

--Syntax: STRING_SPLIT (string , separator [,enable_ordinal]);
--enable_ordinal: A bit flag (0 or 1) that specifies whether to include the ordinal column in the output.
--When set to 1, the result set includes both the value and the ordinal position of each element in the string.

SELECT value, ordinal FROM STRING_SPLIT('STRING_SPLIT,New,SQL,Server,2022,Enhancement', ',', 1)