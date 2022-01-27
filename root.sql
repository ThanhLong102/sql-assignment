# sql-assignment

 /********* A. BASIC QUERY *********/
 
-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
a. id tăng dần
SELECT
  * FROM student
ORDER by id ASC;
b. giới tính
SELECT
    * FROM student
ORDER by gender ASC;
c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
SELECT
    * FROM student
ORDER by birthday ASC, scholarship DESC;

-- 2. Môn học có tên bắt đầu bằng chữ 'T'
SELECT
    * FROM subject
WHERE name LIKE n'T%';

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
SELECT
    * FROM student
WHERE name LIKE n'%i';

-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
SELECT
    * FROM faculty
WHERE name LIKE n'_n%';

-- 5. Sinh viên trong tên có từ 'Thị'
SELECT
    * FROM student
WHERE name LIKE n'%Thị%';

-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
SELECT
    * FROM student
WHERE name BETWEEN n'a%' AND n'm%';

-- 7. Sinh viên có học bổng lớn hơn, sắp xếp theo mã khoa giảm dần
SELECT
    * FROM student
WHERE scholarship >100000
ORDER BY id DESC;

-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
SELECT
    * FROM student
WHERE scholarship >150000 and hometown = n'Hà Nội';

-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
SELECT
    * FROM student
WHERE birthday BETWEEN TO_DATE('01011991','DDMMYYYY') and TO_DATE('05061992','DDMMYYYY');

-- 10. Những sinh viên có học bổng từ 80000 đến 150000
SELECT
    * FROM student
WHERE scholarship BETWEEN 80000 and 150000;

-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
SELECT
    * FROM subject
WHERE lesson_quantity BETWEEN 30 and 45;

/********* B. CALCULATION QUERY *********/

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
 SELECT Id,gender,faculty_id,
Case
    when scholarship > 500000 Then 'Học bổng cao'
    ELSE 'Mức trung bình'
END as MucHocBong
FROM student;

-- 2. Tính tổng số sinh viên của toàn trường
SELECT
    COUNT(id) as totalStudent FROM student;
 
-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
SELECT
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'Nữ' then 1 else 0 end) as totalNu
    FROM student;
    
-- 4. Tính tổng số sinh viên từng khoa
SELECT
    faculty_id,COUNT(id)
    FROM student
GROUP by faculty_id

-- 5. Tính tổng số sinh viên của từng môn học
SELECT
    subject_id,COUNT(student_id)
    FROM exam_management
GROUP by subject_id

-- 6. Tính số lượng môn học mà sinh viên đã học
SELECT COUNT(subject_id) 
    FROM (SELECT
            subject_id FROM exam_management
        GROUP by subject_id)
;

-- 7. Tổng số học bổng của mỗi khoa
SELECT
    faculty_id ,COUNT(scholarship)
    FROM student
GROUP by faculty_id;

-- 8. Cho biết học bổng cao nhất của mỗi khoa
SELECT
    faculty_id,Max(scholarship)
    FROM student
GROUP by faculty_id

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
SELECT
    faculty_id,
    SUM(CASE When gender=n'Nam' then 1 else 0 end) as totalNam,
    SUM(CASE When gender=n'Nữ' then 1 else 0 end) as totalNu
    FROM student
GROUP by faculty_id

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
SELECT
    to_char(SYSDATE,'YYYY')-TO_char(birthday,'YYYY') as Tuoi,
    COUNT(id)
    FROM student
GROUP by to_char(birthday,'YYYY')

-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
SELECT
    hometown,COUNT(id) FROM student
GROUP BY hometown
HAVING COUNT(id)>=2;

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
SELECT
    student_id FROM exam_management
    where number_of_exam_taking>=2
GROUP BY student_id

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 
SELECT
    student_id,AVG(mark) FROM exam_management
    where student_id in (SELECT id FROM student
                        WHERE gender =n'Nam')
        and number_of_exam_taking=1
GROUP BY student_id
HAVING AVG(mark)>7.0;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
SELECT
    student_id,COUNT(mark) FROM exam_management
    where number_of_exam_taking=1 and mark<4
GROUP BY student_id
HAVING COUNT(mark)>=2;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
SELECT
    faculty_id,COUNT(gender) FROM student
    where gender=n'Nam'
GROUP BY faculty_id
HAVING COUNT(gender)>2;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
SELECT
    faculty_id,COUNT(id) FROM student
    where scholarship BETWEEN 200000 and 300000
GROUP BY faculty_id
HAVING COUNT(id)=2;

-- 17. Cho biết sinh viên nào có học bổng cao nhất
SELECT
    * FROM student
    where scholarship = (Select Max(scholarship) FROM student)
    
/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
SELECT
    * FROM student
    where TO_CHAR(birthday,'MM') = '02'

-- 2. Sinh viên có tuổi lớn hơn 20
SELECT
    * FROM student
    where TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(birthday,'YYYY') > '20'

3. Sinh viên sinh vào mùa xuân năm 1990
SELECT
    * FROM student
    where TO_CHAR(birthday,'YYYY') = '1990' and TO_CHAR(birthday,'MM')<'4';

/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
SELECT
    student.id,student.name,student.birthday,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where faculty.name = n'Anh - Văn' or faculty.name =n'Vật lý'

-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
SELECT
    student.id,student.name,student.birthday,student.gender,faculty.name FROM student
INNER JOIN faculty on faculty.id= student.faculty_id
where (faculty.name = n'Anh - Văn' or faculty.name =n'Tin học')
    and student.gender=n'Nam';
    
-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
SELECT
    student.id,student.name,subject.name,exam_management.mark FROM exam_management
INNER JOIN student on student.id= exam_management.student_id
INNER JOIN subject on subject.id=exam_management.subject_id
Where subject.name = n'Cơ sở dữ liệu' and exam_management.number_of_exam_taking =1
    and exam_management.mark = (SELECT
                                    Max(exam_management.mark) FROM exam_management
                                INNER JOIN subject on subject.id=exam_management.subject_id
                                Where subject.name = n'Cơ sở dữ liệu' 
                                    and exam_management.number_of_exam_taking =1)
                                    
-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.                                    
SELECT * FROM student
    where student.birthday= (SELECT
                                Min(student.birthday) FROM student
                            INNER JOIN faculty on student.faculty_id =faculty.id
                            WHERE faculty.name = n'Anh - Văn')
                            
-- 5. Cho biết khoa nào có đông sinh viên nhất
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
-- 6. Cho biết khoa nào có đông nữ nhất
SELECT
    * FROM faculty
Where id=(SELECT faculty_id From (SELECT faculty_id FROM student
                        Where gender= n'Nữ'
                        GROUP by faculty_id
                        ORDER By COUNT(id) DESC)
        where ROWNUM<2)
        
 -- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
SELECT student.id,student.name FROM exam_management
INNER JOIN student on student.id=exam_management.student_id
where (exam_management.subject_id,exam_management.mark) in (SELECT
                        subject_id, Max(mark) FROM exam_management
                        GROUP by subject_id)
  
 -- 8. Cho biết những khoa không có sinh viên học
SELECT * FROM faculty
where faculty.id in (SELECT faculty_id FROM (SELECT
                   faculty_id,COUNT(id) as totalStudent FROM student
                GROUP by faculty_id)
                where totalStudent<1)

-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
SELECT * FROM student
where id not in (SELECT student_id FROM exam_management
                where subject_id = (SELECT id FROM subject
                                     where name =  n'Cơ sở dữ liệu')

                GROUP BY student_id)
                
-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2    
SELECT
    *
FROM
    student
WHERE
    id IN (
        SELECT
            student_id
        FROM
            exam_management
        WHERE
                number_of_exam_taking = 2
            AND student_id NOT IN (
                SELECT
                    student_id
                FROM
                    exam_management
                WHERE
                    number_of_exam_taking = 1
                GROUP BY
                    student_id
            )
        GROUP BY
            student_id
    );
