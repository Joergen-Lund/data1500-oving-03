-- Oppgave 1
SELECT 
    s.* 
FROM 
    studenter s
LEFT JOIN 
    emneregistreringer er ON s.student_id = er.student_id
WHERE
    er.student_id IS NULL;


-- Oppgave 2
SELECT
    e.*
FROM
    emner e
LEFT JOIN
    emneregistreringer er ON e.emne_id = er.emne_id
WHERE
    er.emne_id IS NULL;


-- Oppgave 3
SELECT 
    CONCAT(fornavn, ' ', etternavn) AS navn, emne_navn AS emne, karakter
FROM (
    SELECT
        s.*,
        er.emne_id,
        er.karakter,
        e.emne_navn,
        RANK() OVER (PARTITION BY er.emne_id ORDER BY er.karakter) AS rank_nr
    FROM
        studenter s
    JOIN 
        emneregistreringer er ON s.student_id = er.student_id
    JOIN 
        emner e ON er.emne_id = e.emne_id
) ranked_data
WHERE
    rank_nr = 1;
    

-- Oppgave 4
SELECT 
    CONCAT(fornavn, ' ', etternavn) AS navn, 
    program_navn AS program, 
    COUNT(er.emne_id) AS antall_emner
FROM 
    studenter s
JOIN
    programmer p ON s.program_id = p.program_id
JOIN
    emneregistreringer er ON s.student_id = er.student_id
GROUP BY 
    s.student_id, p.program_navn;


-- Oppgave 5 MÅ SJEKKES
SELECT
    s.*
FROM 
    studenter s
LEFT JOIN 
    emneregistreringer er ON s.student_id = er.student_id
WHERE
    er.emne_id = 1 AND er.emne_id = 2;
