# sql-assignment

 /********* A. BASIC QUERY *********/
 
-- 1. Li?t k� danh s�ch sinh vi�n s?p x?p theo th? t?:
a. id t?ng d?n
SELECT
  * FROM student
ORDER by id ASC;
b. gi?i t�nh
SELECT
    * FROM student
ORDER by gender ASC;
c. ng�y sinh T?NG D?N v� h?c b?ng GI?M D?N
SELECT
    * FROM student
ORDER by birthday ASC, scholarship DESC;

-- 2. M�n h?c c� t�n b?t ??u b?ng ch? 'T'
SELECT
    * FROM subject
WHERE name LIKE n'T%';

-- 3. Sinh vi�n c� ch? c�i cu?i c�ng trong t�n l� 'i'
SELECT
    * FROM student
WHERE name LIKE n'%i';

-- 4. Nh?ng khoa c� k� t? th? hai c?a t�n khoa c� ch?a ch? 'n'
SELECT
    * FROM faculty
WHERE name LIKE n'_n%';

-- 5. Sinh vi�n trong t�n c� t? 'Th?'
SELECT
    * FROM student
WHERE name LIKE n'%Th?%';

-- 6. Sinh vi�n c� k� t? ??u ti�n c?a t�n n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? t�n sinh vi�n
SELECT
    * FROM student
WHERE name BETWEEN n'a%' AND n'm%';

-- 7. Sinh vi�n c� h?c b?ng l?n h?n, s?p x?p theo m� khoa gi?m d?n
SELECT
    * FROM student
WHERE scholarship >100000
ORDER BY id DESC;

-- 8. Sinh vi�n c� h?c b?ng t? 150000 tr? l�n v� sinh ? H� N?i
SELECT
    * FROM student
WHERE scholarship >150000 and hometown = n'H� N?i';

-- 9. Nh?ng sinh vi�n c� ng�y sinh t? ng�y 01/01/1991 ??n ng�y 05/06/1992
SELECT
    * FROM student
WHERE birthday BETWEEN TO_DATE('01011991','DDMMYYYY') and TO_DATE('05061992','DDMMYYYY');

-- 10. Nh?ng sinh vi�n c� h?c b?ng t? 80000 ??n 150000
SELECT
    * FROM student
WHERE scholarship BETWEEN 80000 and 150000;

-- 11. Nh?ng m�n h?c c� s? ti?t l?n h?n 30 v� nh? h?n 45
SELECT
    * FROM subject
WHERE lesson_quantity BETWEEN 30 and 45;

/********* B. CALCULATION QUERY *********/

-- 1. Cho bi?t th�ng tin v? m?c h?c b?ng c?a c�c sinh vi�n, g?m: M� sinh vi�n, Gi?i t�nh, M� 
		-- khoa, M?c h?c b?ng. Trong ?�, m?c h?c b?ng s? hi?n th? l� �H?c b?ng cao� n?u gi� tr? 
		-- c?a h?c b?ng l?n h?n 500,000 v� ng??c l?i hi?n th? l� �M?c trung b�nh�.
 SELECT Id,gender,faculty_id,
Case
    when scholarship > 500000 Then 'H?c b?ng cao'
    ELSE 'M?c trung b�nh'
END as MucHocBong
FROM student;

-- 2. T�nh t?ng s? sinh vi�n c?a to�n tr??ng
SELECT
    COUNT(id) as totalStudent FROM student;
 
-- 3. T�nh t?ng s? sinh vi�n nam v� t?ng s? sinh vi�n n?.
SELECT
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'N?' then 1 else 0 end) as totalNu
    FROM student;
    
-- 4. T�nh t?ng s? sinh vi�n t?ng khoa
SELECT
    faculty_id,COUNT(id)
    FROM student
GROUP by faculty_id

-- 5. T�nh t?ng s? sinh vi�n c?a t?ng m�n h?c
SELECT
    subject_id,COUNT(student_id)
    FROM exam_management
GROUP by subject_id

-- 6. T�nh s? l??ng m�n h?c m� sinh vi�n ?� h?c
SELECT COUNT(subject_id) 
    FROM (SELECT
            subject_id FROM exam_management
        GROUP by subject_id)
;

-- 7. T?ng s? h?c b?ng c?a m?i khoa
SELECT
    faculty_id ,COUNT(scholarship)
    FROM student
GROUP by faculty_id;

-- 8. Cho bi?t h?c b?ng cao nh?t c?a m?i khoa
SELECT
    faculty_id,Max(scholarship)
    FROM student
GROUP by faculty_id

-- 9. Cho bi?t t?ng s? sinh vi�n nam v� t?ng s? sinh vi�n n? c?a m?i khoa
SELECT
    faculty_id,
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'N?' then 1 else 0 end) as totalNu
    FROM student
GROUP by faculty_id

-- 10. Cho bi?t s? l??ng sinh vi�n theo t?ng ?? tu?i
SELECT
    to_char(SYSDATE,'YYYY')-TO_char(birthday,'YYYY') as Tuoi,
    COUNT(id)
    FROM student
GROUP by to_char(birthday,'YYYY')

-- 11. Cho bi?t nh?ng n?i n�o c� �t nh?t 2 sinh vi�n ?ang theo h?c t?i tr??ng
SELECT
    hometown,COUNT(id) FROM student
GROUP BY hometown
HAVING COUNT(id)>=2;

-- 12. Cho bi?t nh?ng sinh vi�n thi l?i �t nh?t 2 l?n
SELECT
    student_id FROM exam_management
    where number_of_exam_taking>=2
GROUP BY student_id

-- 13. Cho bi?t nh?ng sinh vi�n nam c� ?i?m trung b�nh l?n 1 tr�n 7.0 
SELECT
    student_id,AVG(mark) FROM exam_management
    where student_id in (SELECT id FROM student
                        WHERE gender =n'Nam')
        and number_of_exam_taking=1
GROUP BY student_id
HAVING AVG(mark)>7.0;

-- 14. Cho bi?t danh s�ch c�c sinh vi�n r?t �t nh?t 2 m�n ? l?n thi 1 (r?t m�n l� ?i?m thi c?a m�n kh�ng qu� 4 ?i?m)
SELECT
    student_id,COUNT(mark) FROM exam_management
    where number_of_exam_taking=1 and mark<4
GROUP BY student_id
HAVING COUNT(mark)>=2;

-- 15. Cho bi?t danh s�ch nh?ng khoa c� nhi?u h?n 2 sinh vi�n nam
SELECT
    faculty_id,COUNT(gender) FROM student
    where gender=n'Nam'
GROUP BY faculty_id
HAVING COUNT(gender)>2;

-- 16. Cho bi?t nh?ng khoa c� 2 sinh vi�n ??t h?c b?ng t? 200000 ??n 300000
SELECT
    faculty_id,COUNT(id) FROM student
    where scholarship BETWEEN 200000 and 300000
GROUP BY faculty_id
HAVING COUNT(id)=2;

-- 17. Cho bi?t sinh vi�n n�o c� h?c b?ng cao nh?t
SELECT
    * FROM student
    where scholarship = (Select Max(scholarship) FROM student)
    
/********* C. DATE/TIME QUERY *********/

-- 1. Sinh vi�n c� n?i sinh ? H� N?i v� sinh v�o th�ng 02
SELECT
    * FROM student
    where TO_CHAR(birthday,'MM') = '02'

-- 2. Sinh vi�n c� tu?i l?n h?n 20
SELECT
    * FROM student
    where TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(birthday,'YYYY') > '20'

3. Sinh vi�n sinh v�o m�a xu�n n?m 1990
SELECT
    * FROM student
    where TO_CHAR(birthday,'YYYY') = '1990' and TO_CHAR(birthday,'MM')<'4';

/********* D. JOIN QUERY *********/

-- 1. Danh s�ch c�c sinh vi�n c?a khoa ANH V?N v� khoa V?T L�
SELECT
    student.id,student.name,student.birthday,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where faculty.name = n'Anh - V?n' or faculty.name =n'V?t l�'

-- 2. Nh?ng sinh vi�n nam c?a khoa ANH V?N v� khoa TIN H?C
SELECT
    student.id,student.name,student.birthday,student.gender,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where (faculty.name = n'Anh - V?n' or faculty.name =n'Tin h?c')
    and student.gender=n'Nam';
    
-- 3. Cho bi?t sinh vi�n n�o c� ?i?m thi l?n 1 m�n c? s? d? li?u cao nh?t
SELECT
    student.id,student.name,subject.name,exam_management.mark FROM exam_management
INNER JOIN student on student.id= exam_management.student_id
INNER JOIN subject on subject.id=exam_management.subject_id
Where subject.name = n'C? s? d? li?u' and exam_management.number_of_exam_taking =1
    and exam_management.mark = (SELECT
                                    Max(exam_management.mark) FROM exam_management
                                INNER JOIN subject on subject.id=exam_management.subject_id
                                Where subject.name = n'C? s? d? li?u' 
                                    and exam_management.number_of_exam_taking =1)
                                    
-- 4. Cho bi?t sinh vi�n khoa anh v?n c� tu?i l?n nh?t.                                    
SELECT * FROM student
    where student.birthday= (SELECT
                                Min(student.birthday) FROM student
                            INNER JOIN faculty on student.faculty_id =faculty.id
                            WHERE faculty.name = n'Anh - V?n')
                            
-- 5. Cho bi?t khoa n�o c� ?�ng sinh vi�n nh?t
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
-- 6. Cho bi?t khoa n�o c� ?�ng n? nh?t
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        Where gender= n'N?'
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
 -- 7. Cho bi?t nh?ng sinh vi�n ??t ?i?m cao nh?t trong t?ng m�n
SELECT student.id,student.name FROM exam_management
INNER JOIN student on student.id=exam_management.student_id
where (exam_management.subject_id,exam_management.mark) in (SELECT
                        subject_id, Max(mark) FROM exam_management
                        GROUP by subject_id)
  
 -- 8. Cho bi?t nh?ng khoa kh�ng c� sinh vi�n h?c
SELECT * FROM faculty
where faculty.id in (SELECT faculty_id FROM (SELECT
                   faculty_id,COUNT(id) as totalStudent FROM student
                GROUP by faculty_id)
                where totalStudent<1)

-- 9. Cho bi?t sinh vi�n ch?a thi m�n c? s? d? li?u
SELECT * FROM student
where id not in (SELECT student_id FROM exam_management
                where subject_id = (SELECT id FROM subject
                                     where name =  n'C? s? d? li?u')

                GROUP BY student_id)
                
-- 10. Cho bi?t sinh vi�n n�o kh�ng thi l?n 1 m� c� d? thi l?n 2    
SELECT * FROM student
where id in (SELECT student_id FROM exam_management
            where number_of_exam_taking=2 and student_id not in(SELECT student_id FROM exam_management
                                                                where number_of_exam_taking=1
                                                                GROUP BY student_id)
            GROUP BY student_id);
