# sql-assignment

 /********* A. BASIC QUERY *********/
 
-- 1. Li?t kê danh sách sinh viên s?p x?p theo th? t?:
a. id t?ng d?n
SELECT
  * FROM student
ORDER by id ASC;
b. gi?i tính
SELECT
    * FROM student
ORDER by gender ASC;
c. ngày sinh T?NG D?N và h?c b?ng GI?M D?N
SELECT
    * FROM student
ORDER by birthday ASC, scholarship DESC;

-- 2. Môn h?c có tên b?t ??u b?ng ch? 'T'
SELECT
    * FROM subject
WHERE name LIKE n'T%';

-- 3. Sinh viên có ch? cái cu?i cùng trong tên là 'i'
SELECT
    * FROM student
WHERE name LIKE n'%i';

-- 4. Nh?ng khoa có ký t? th? hai c?a tên khoa có ch?a ch? 'n'
SELECT
    * FROM faculty
WHERE name LIKE n'_n%';

-- 5. Sinh viên trong tên có t? 'Th?'
SELECT
    * FROM student
WHERE name LIKE n'%Th?%';

-- 6. Sinh viên có ký t? ??u tiên c?a tên n?m trong kho?ng t? 'a' ??n 'm', s?p x?p theo h? tên sinh viên
SELECT
    * FROM student
WHERE name BETWEEN n'a%' AND n'm%';

-- 7. Sinh viên có h?c b?ng l?n h?n, s?p x?p theo mã khoa gi?m d?n
SELECT
    * FROM student
WHERE scholarship >100000
ORDER BY id DESC;

-- 8. Sinh viên có h?c b?ng t? 150000 tr? lên và sinh ? Hà N?i
SELECT
    * FROM student
WHERE scholarship >150000 and hometown = n'Hà N?i';

-- 9. Nh?ng sinh viên có ngày sinh t? ngày 01/01/1991 ??n ngày 05/06/1992
SELECT
    * FROM student
WHERE birthday BETWEEN TO_DATE('01011991','DDMMYYYY') and TO_DATE('05061992','DDMMYYYY');

-- 10. Nh?ng sinh viên có h?c b?ng t? 80000 ??n 150000
SELECT
    * FROM student
WHERE scholarship BETWEEN 80000 and 150000;

-- 11. Nh?ng môn h?c có s? ti?t l?n h?n 30 và nh? h?n 45
SELECT
    * FROM subject
WHERE lesson_quantity BETWEEN 30 and 45;

/********* B. CALCULATION QUERY *********/

-- 1. Cho bi?t thông tin v? m?c h?c b?ng c?a các sinh viên, g?m: Mã sinh viên, Gi?i tính, Mã 
		-- khoa, M?c h?c b?ng. Trong ?ó, m?c h?c b?ng s? hi?n th? là “H?c b?ng cao” n?u giá tr? 
		-- c?a h?c b?ng l?n h?n 500,000 và ng??c l?i hi?n th? là “M?c trung bình”.
 SELECT Id,gender,faculty_id,
Case
    when scholarship > 500000 Then 'H?c b?ng cao'
    ELSE 'M?c trung bình'
END as MucHocBong
FROM student;

-- 2. Tính t?ng s? sinh viên c?a toàn tr??ng
SELECT
    COUNT(id) as totalStudent FROM student;
 
-- 3. Tính t?ng s? sinh viên nam và t?ng s? sinh viên n?.
SELECT
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'N?' then 1 else 0 end) as totalNu
    FROM student;
    
-- 4. Tính t?ng s? sinh viên t?ng khoa
SELECT
    faculty_id,COUNT(id)
    FROM student
GROUP by faculty_id

-- 5. Tính t?ng s? sinh viên c?a t?ng môn h?c
SELECT
    subject_id,COUNT(student_id)
    FROM exam_management
GROUP by subject_id

-- 6. Tính s? l??ng môn h?c mà sinh viên ?ã h?c
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

-- 9. Cho bi?t t?ng s? sinh viên nam và t?ng s? sinh viên n? c?a m?i khoa
SELECT
    faculty_id,
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'N?' then 1 else 0 end) as totalNu
    FROM student
GROUP by faculty_id

-- 10. Cho bi?t s? l??ng sinh viên theo t?ng ?? tu?i
SELECT
    to_char(SYSDATE,'YYYY')-TO_char(birthday,'YYYY') as Tuoi,
    COUNT(id)
    FROM student
GROUP by to_char(birthday,'YYYY')

-- 11. Cho bi?t nh?ng n?i nào có ít nh?t 2 sinh viên ?ang theo h?c t?i tr??ng
SELECT
    hometown,COUNT(id) FROM student
GROUP BY hometown
HAVING COUNT(id)>=2;

-- 12. Cho bi?t nh?ng sinh viên thi l?i ít nh?t 2 l?n
SELECT
    student_id FROM exam_management
    where number_of_exam_taking>=2
GROUP BY student_id

-- 13. Cho bi?t nh?ng sinh viên nam có ?i?m trung bình l?n 1 trên 7.0 
SELECT
    student_id,AVG(mark) FROM exam_management
    where student_id in (SELECT id FROM student
                        WHERE gender =n'Nam')
        and number_of_exam_taking=1
GROUP BY student_id
HAVING AVG(mark)>7.0;

-- 14. Cho bi?t danh sách các sinh viên r?t ít nh?t 2 môn ? l?n thi 1 (r?t môn là ?i?m thi c?a môn không quá 4 ?i?m)
SELECT
    student_id,COUNT(mark) FROM exam_management
    where number_of_exam_taking=1 and mark<4
GROUP BY student_id
HAVING COUNT(mark)>=2;

-- 15. Cho bi?t danh sách nh?ng khoa có nhi?u h?n 2 sinh viên nam
SELECT
    faculty_id,COUNT(gender) FROM student
    where gender=n'Nam'
GROUP BY faculty_id
HAVING COUNT(gender)>2;

-- 16. Cho bi?t nh?ng khoa có 2 sinh viên ??t h?c b?ng t? 200000 ??n 300000
SELECT
    faculty_id,COUNT(id) FROM student
    where scholarship BETWEEN 200000 and 300000
GROUP BY faculty_id
HAVING COUNT(id)=2;

-- 17. Cho bi?t sinh viên nào có h?c b?ng cao nh?t
SELECT
    * FROM student
    where scholarship = (Select Max(scholarship) FROM student)
    
/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có n?i sinh ? Hà N?i và sinh vào tháng 02
SELECT
    * FROM student
    where TO_CHAR(birthday,'MM') = '02'

-- 2. Sinh viên có tu?i l?n h?n 20
SELECT
    * FROM student
    where TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(birthday,'YYYY') > '20'

3. Sinh viên sinh vào mùa xuân n?m 1990
SELECT
    * FROM student
    where TO_CHAR(birthday,'YYYY') = '1990' and TO_CHAR(birthday,'MM')<'4';

/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên c?a khoa ANH V?N và khoa V?T LÝ
SELECT
    student.id,student.name,student.birthday,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where faculty.name = n'Anh - V?n' or faculty.name =n'V?t lý'

-- 2. Nh?ng sinh viên nam c?a khoa ANH V?N và khoa TIN H?C
SELECT
    student.id,student.name,student.birthday,student.gender,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where (faculty.name = n'Anh - V?n' or faculty.name =n'Tin h?c')
    and student.gender=n'Nam';
    
-- 3. Cho bi?t sinh viên nào có ?i?m thi l?n 1 môn c? s? d? li?u cao nh?t
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
                                    
-- 4. Cho bi?t sinh viên khoa anh v?n có tu?i l?n nh?t.                                    
SELECT * FROM student
    where student.birthday= (SELECT
                                Min(student.birthday) FROM student
                            INNER JOIN faculty on student.faculty_id =faculty.id
                            WHERE faculty.name = n'Anh - V?n')
                            
-- 5. Cho bi?t khoa nào có ?ông sinh viên nh?t
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
-- 6. Cho bi?t khoa nào có ?ông n? nh?t
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        Where gender= n'N?'
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
 -- 7. Cho bi?t nh?ng sinh viên ??t ?i?m cao nh?t trong t?ng môn
SELECT student.id,student.name FROM exam_management
INNER JOIN student on student.id=exam_management.student_id
where (exam_management.subject_id,exam_management.mark) in (SELECT
                        subject_id, Max(mark) FROM exam_management
                        GROUP by subject_id)
  
 -- 8. Cho bi?t nh?ng khoa không có sinh viên h?c
SELECT * FROM faculty
where faculty.id in (SELECT faculty_id FROM (SELECT
                   faculty_id,COUNT(id) as totalStudent FROM student
                GROUP by faculty_id)
                where totalStudent<1)

-- 9. Cho bi?t sinh viên ch?a thi môn c? s? d? li?u
SELECT * FROM student
where id not in (SELECT student_id FROM exam_management
                where subject_id = (SELECT id FROM subject
                                     where name =  n'C? s? d? li?u')

                GROUP BY student_id)
                
-- 10. Cho bi?t sinh viên nào không thi l?n 1 mà có d? thi l?n 2    
SELECT * FROM student
where id in (SELECT student_id FROM exam_management
            where number_of_exam_taking=2 and student_id not in(SELECT student_id FROM exam_management
                                                                where number_of_exam_taking=1
                                                                GROUP BY student_id)
            GROUP BY student_id);
