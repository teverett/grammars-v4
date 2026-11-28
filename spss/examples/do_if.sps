DO IF (age < 18).
COMPUTE ageGroup = 1.
ELSE IF (age < 65).
COMPUTE ageGroup = 2.
ELSE.
COMPUTE ageGroup = 3.
END IF.
