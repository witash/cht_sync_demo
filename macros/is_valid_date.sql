{% macro is_valid_date(date_str) %}
    CASE 
        -- Step 1: Ensure the date is in 'YYYY-MM-DD' format
        WHEN '{{ date_str }}' ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$' THEN
            -- Step 2: Extract year, month, and day
            -- Cast each part to integers for further validation
            (CASE 
                WHEN -- Extract year, month, and day using substring
                    -- Check for invalid months or days
                    ((substring('{{ date_str }}', 6, 2))::int NOT BETWEEN 1 AND 12) 
                    OR ((substring('{{ date_str }}', 9, 2))::int < 1)
                THEN NULL
                
                WHEN -- Step 3: Check for valid day of month based on the month
                    (substring('{{ date_str }}', 6, 2) IN ('01', '03', '05', '07', '08', '10', '12')
                    AND (substring('{{ date_str }}', 9, 2))::int <= 31)
                    OR (substring('{{ date_str }}', 6, 2) IN ('04', '06', '09', '11')
                    AND (substring('{{ date_str }}', 9, 2))::int <= 30)
                THEN '{{ date_str }}'
                
                WHEN -- Step 4: Check for February (leap year or not)
                    (substring('{{ date_str }}', 6, 2) = '02')
                    THEN
                        CASE 
                            -- Handle leap years
                            WHEN (substring('{{ date_str }}', 1, 4))::int % 4 = 0
                                AND ((substring('{{ date_str }}', 1, 4))::int % 100 != 0
                                OR (substring('{{ date_str }}', 1, 4))::int % 400 = 0)
                                AND (substring('{{ date_str }}', 9, 2))::int <= 29
                            THEN date_str
                            
                            -- Not a leap year
                            WHEN (substring('{{ date_str }}', 9, 2))::int <= 28
                            THEN date_str
                            
                            ELSE NULL
                        END
                ELSE NULL
            END)
        ELSE NULL
    END
{% endmacro %}
