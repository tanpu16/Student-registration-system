set serveroutput on
create or replace package body project2procedurefunction as

procedure show_students is
cursor ss is select * from students;
ss_rec ss%rowtype;
begin
open ss;
fetch ss into ss_rec;
while ss%found loop
dbms_output.put_line(ss_rec.sid || ',' || ss_rec.firstname || ',' || ss_rec.lastname || ',' || ss_rec.status || ',' || ss_rec.gpa || ',' || ss_rec.email);
fetch ss into ss_rec;
end loop;
close ss;
end;

procedure show_courses is
cursor sc is select * from courses;
sc_rec sc%rowtype;
begin
open sc;
fetch sc into sc_rec;
while sc%found loop
dbms_output.put_line(sc_rec.dept_code || ',' || sc_rec.course_no || ',' || sc_rec.title);
fetch sc into sc_rec;
end loop;
close sc;
end;

procedure show_prerequisites is
cursor sp is select * from prerequisites;
sp_rec sp%rowtype;
begin
open sp;
fetch sp into sp_rec;
while sp%found loop
dbms_output.put_line(sp_rec.dept_code || ',' || sp_rec.course_no || ',' || sp_rec.pre_dept_code || ',' || sp_rec.pre_course_no);
fetch sp into sp_rec;
end loop;
close sp;
end;

procedure show_classes is
cursor scs is select * from classes;
scs_rec scs%rowtype;
begin
open scs;
fetch scs into scs_rec;
while scs%found loop
dbms_output.put_line(scs_rec.classid || ',' || scs_rec.dept_code || ',' || scs_rec.course_no || ',' || scs_rec.sect_no || ',' || scs_rec.year || ',' || scs_rec.semester || ',' || scs_rec.limit || ',' || scs_rec.class_size);
fetch scs into scs_rec;
end loop;
close scs;
end;

procedure show_enrollments is
cursor se is select * from enrollments;
se_rec se%rowtype;
begin
open se;
fetch se into se_rec;
while se%found loop
dbms_output.put_line(se_rec.sid || ',' || se_rec.classid || ',' || se_rec.lgrade);
fetch se into se_rec;
end loop;
close se;
end;

procedure show_logs is
cursor sl is select * from logs;
sl_rec sl%rowtype;
begin
open sl;
fetch sl into sl_rec;
while sl%found loop
dbms_output.put_line(sl_rec.logid || ',' || sl_rec.who || ',' || sl_rec.time || ',' || sl_rec.table_name || ',' || sl_rec.operation || ',' || sl_rec.key_value);
fetch sl into sl_rec;
end loop;
close sl;
end;

procedure add_student
(student_id in char,first_name in varchar2,last_name in varchar2,student_status in varchar2,student_gpa in number, student_email in varchar2) is
begin
add_stud_sid:=student_id;
insert into students values(student_id,first_name,last_name,student_status,student_gpa,student_email);
commit;
end;

procedure studentclass_info(student_id in char) as

s_sid students.sid%type;
s_fname students.firstname%type;
s_lname students.lastname%type;
s_status students.status%type;
c_classid classes.classid%type;
c_courseid varchar2(7);
c_title courses.title%type;
flag1 number;
flag2 number;
p1_classid classes.classid%type;
a1 sys_refcursor;

begin
        select count(*) into flag1 from students where sid = student_id;
        if(flag1=0) then
                raise_application_error(-20001,'The sid is invalid.');
        end if;

        select count(classid) into flag2 from enrollments where sid = student_id;
        if(flag2=0) then
                raise_application_error(-20002,'The student has not taken any course.');
        end if;

                select sid,firstname,lastname,status into s_sid,s_fname,s_lname,s_status from students where sid = student_id;
        dbms_output.put_line(s_sid || ',' || s_fname ||',' || s_lname || ',' || s_status);

                open a1 for SELECT cl.classid, concat(cl.dept_code, cl.course_no) as courseid, c2.title
                FROM classes cl, enrollments e, courses c2, students s
                WHERE s.sid=student_id AND s.sid=e.sid AND e.classid = cl.classid AND cl.course_no = c2.course_no;
                loop
                        fetch a1 into c_classid,c_courseid,c_title;
                        exit when a1%notfound;
                        dbms_output.put_line(c_classid || ',' || c_courseid || ',' || c_title);
                end loop;
                close a1;

end;


procedure prerequisite_info(departmentcode in varchar2,coursenumber in number) as

no_prereq exception;
flag number:=1;
cursor c1 is select pre_dept_code,pre_course_no from prerequisites where dept_code = departmentcode and course_no=coursenumber;
c1_rec c1%rowtype;

begin
        select count(*) into flag from prerequisites where dept_code=departmentcode and course_no=coursenumber;
        if(flag=0) then
        raise no_prereq;
        end if;

        open c1;
        fetch c1 into c1_rec;
        while c1%found loop
        dbms_output.put_line(c1_rec.pre_dept_code || c1_rec.pre_course_no);
        fetch c1 into c1_rec;
        end loop;
        close c1;
        prerequisite_info(c1_rec.pre_dept_code,c1_rec.pre_course_no);

        exception
        when no_prereq then
                dbms_output.put_line('');
end;

procedure class_info(s_classid in char) as

flag number:=0;
flag1 number:=0;
c_title courses.title%type;
c_id classes.classid%type;
c_semester classes.semester%type;
c_year classes.year%type;
s_sid students.sid%type;
s_fname students.firstname%type;
s_lname students.lastname%type;
a1 sys_refcursor;

begin
        select count(*) into flag from classes where classid = s_classid;
        if(flag=0) then
                raise_application_error(-20003,'The cid is invalid');
        end if;

        select count(*) into flag1 from enrollments where classid = s_classid;
        if(flag1=0) then
                raise_application_error(-20004,'No student is enrolled in the class.');
        end if;

        select c1.classid,c1.semester,c1.year,c2.title into c_id,c_semester,c_year,c_title from classes c1,courses c2 where classid = s_classid and c1.dept_code = c2.dept_code and c1.course_no = c2.course_no;
        dbms_output.put_line(c_id || ',' || c_title ||',' || c_semester || ',' || c_year);

        open a1 for SELECT s.sid,firstname,lastname
        FROM classes cl, enrollments e, students s
        WHERE cl.classid = s_classid AND cl.classid = e.classid AND e.sid=s.sid;
        loop
                fetch a1 into s_sid,s_fname,s_lname;
                exit when a1%notfound;
                dbms_output.put_line(s_sid || ',' || s_fname || ',' || s_lname);
        end loop;
        close a1;

end;



procedure enrollment(student_id in char,c_classid in char) as

flag1 NUMBER:=1;
flag2 NUMBER:=1;
isavailable NUMBER:=1;
flag3 NUMBER:=0;
sem classes.semester%type;
yr classes.year%type;
flag4 NUMBER:=0;
count_var number:=0;
d_deptcode classes.dept_code%type;
c_courseno classes.course_no%type;
sc1_deptcode classes.dept_code%type;
sc1_courseno classes.course_no%type;
sc2_cid classes.classid%type;
e_lgrade enrollments.lgrade%type;
pre_count NUMBER:=1;
sc1 sys_refcursor;
sc2 sys_refcursor;
cursor c1 is select classid from enrollments where sid=student_id;
c1_rec c1%rowtype;

BEGIN
select count(*) into flag1 from students where sid=student_id;
if(flag1=0)then
        RAISE_APPLICATION_ERROR(-20004,'sid not found');
end if;

select count(*) into flag2 from classes where classid=c_classid;
if(flag2=0)then
        RAISE_APPLICATION_ERROR(-20005,'The classid is invalid.');
end if;

select (limit-class_size) into isavailable from classes where classid=c_classid;
if(isavailable = 0) then
        RAISE_APPLICATION_ERROR(-20006,'The class is full.');
end if;

select count(*) into flag3 from enrollments where sid=student_id and classid=c_classid;
if(flag3=1) then
        RAISE_APPLICATION_ERROR(-20007,'The student is already in this class');
end if;

open c1;
fetch c1 into c1_rec;
while c1%found loop
select count(*) into flag4 from classes where classid=c1_rec.classid and semester='Fall' and year=2020;
if(flag4!=0) then
count_var:=count_var+1;
end if;
fetch c1 into c1_rec;
end loop;
close c1;

if(count_var=3)then
RAISE_APPLICATION_ERROR(-20008,'You are overloaded.');
end if;

select dept_code, course_no into d_deptcode, c_courseno from classes where classid=c_classid;

select count(*) into pre_count from prerequisites where dept_code=d_deptcode and course_no=c_courseno;

if(pre_count=0) then
                stud_enroll_id:=student_id;
                class_enroll_id:=c_classid;
        insert into enrollments values(student_id,c_classid,null);
        commit;
        return;
end if;

open sc1 for select pre_dept_code, pre_course_no from prerequisites
where dept_code=d_deptcode and course_no=c_courseno;
fetch sc1 into sc1_deptcode, sc1_courseno;
    open sc2 for select classid from classes where dept_code=sc1_deptcode and course_no=sc1_courseno;
    fetch sc2 into sc2_cid;
        select lgrade into e_lgrade from enrollments where classid=sc2_cid and sid=student_id;
        if(e_lgrade > 'C') then
                RAISE_APPLICATION_ERROR(-20009,'Prerequisite courses have not been completed.');
        elsif(e_lgrade <= 'C') then
                                stud_enroll_id:=student_id;
                                class_enroll_id:=c_classid;
                insert into enrollments values(student_id,c_classid,null);
                commit;
                return;
        end if;
    close sc2;
close sc1;

exception
        when NO_DATA_FOUND then
                RAISE_APPLICATION_ERROR(-20010,'Prerequisite courses have not been completed.');

end;


procedure drop_student_from_class(student_id in char,c_classid in char) as
flag1 NUMBER:=1;
flag2 NUMBER:=1;
flag3 NUMBER:=1;
flag4 NUMBER:=0;
class_count number:=0;
isavailable NUMBER:=1;
deptcode classes.dept_code%type;
courseno classes.course_no%type;
p_deptcode classes.dept_code%type;
p_courseno classes.course_no%type;
cid classes.classid%type;
e_lgrade number;
sc1 sys_refcursor;
sc2 sys_refcursor;

cursor c1 is select classid from enrollments where sid=student_id;
c1_rec c1%rowtype;

begin
select count(*) into flag1 from students where sid=student_id;
if(flag1=0)then
RAISE_APPLICATION_ERROR(-20011,'The sid is invalid.');
end if;

select count(*) into flag2 from classes where classid=c_classid;
if(flag2=0)then
RAISE_APPLICATION_ERROR(-20012,'The classid is invalid.');
end if;

select count(*) into flag3 from enrollments where sid=student_id and classid=c_classid;
if(flag3=0) then
RAISE_APPLICATION_ERROR(-20013,'The student is not enrolled in the class.');
end if;

select dept_code, course_no into p_deptcode, p_courseno from classes where classid=c_classid;
open sc1 for select dept_code, course_no from prerequisites
where pre_dept_code=p_deptcode and pre_course_no=p_courseno;
fetch sc1 into deptcode, courseno;
    open sc2 for select classid from classes where dept_code=deptcode and course_no=courseno;
    fetch sc2 into cid;
    select count(*) into e_lgrade from enrollments where classid=cid and sid=student_id;
    if(e_lgrade!=0) then
                RAISE_APPLICATION_ERROR(-20014,'The drop is not permitted because another class the student registered uses it as a prerequisite.');
    end if;
    close sc2;
close sc1;

stud_enroll_id:=student_id;
class_enroll_id:=c_classid;

delete from enrollments where sid=student_id and classid=c_classid;
commit;
dbms_output.put_line('Student dropped from the class.');

open c1;
fetch c1 into c1_rec;
while c1%found loop
select count(*) into flag4 from classes where classid=c1_rec.classid and semester='Fall' and year=2020;
if(flag4!=0) then
class_count:=class_count+1;
end if;
fetch c1 into c1_rec;
end loop;
close c1;

if(class_count=0) then
dbms_output.put_line('This student is enrolled in no class.');
end if;

select class_size into isavailable from classes where classid=c_classid;
if(isavailable=0) then
dbms_output.put_line('The class now has no students.');
end if;
end;


PROCEDURE delete_student(student_id in char) AS
flag NUMBER:=1;
BEGIN

select count(*) into flag from students where sid=student_id;
if(flag=0)then
RAISE_APPLICATION_ERROR(-20019,'The sid is invalid.');
end if;
del_stud_sid:=student_id;
delete from students where sid=student_id ;
commit;
dbms_output.put_line('Student deleted.');
END;


/**************************************************************************************************************
Procedures/functions to use in java/jdbc
***************************************************************************************************************/



function getstudents return refcur is
gs refcur;
begin
open gs for select * from students;
return gs;
end;

function getcourses return refcur is
gc refcur;
begin
open gc for select * from courses;
return gc;
end;

function getenrollment return refcur is
gs refcur;
begin
open gs for select * from enrollments;
return gs;
end;

function getclasses return refcur is
gs refcur;
begin
open gs for select * from classes;
return gs;
end;

function getprereq return refcur is
gs refcur;
begin
open gs for select * from prerequisites;
return gs;
end;

function getlogs return refcur is
gs refcur;
begin
open gs for select * from logs;
return gs;
end;



procedure j_studentclass_info(student_id in char, show_message OUT varchar2, sc_recordset OUT SYS_REFCURSOR) as

flag1 number := 1;
flag2 number := 1;
msg varchar2(500) := '';

begin
        select count(*) into flag1 from students where sid = student_id;
        select count(classid) into flag2 from enrollments where sid = student_id;

                if(flag1=0) then
                msg := 'The sid is invalid.';
                                show_message := msg;
                elsif(flag2=0 and flag1 != 0) then
                                msg := 'The student has not taken any course.';
                                show_message := msg;
                else
                                open sc_recordset for SELECT s.sid,s.firstname,s.lastname,s.status,cl.classid, concat(cl.dept_code, cl.course_no) as courseid, c2.title FROM classes cl, enrollments e, courses c2, students s WHERE s.sid=student_id AND s.sid=e.sid AND e.classid = cl.classid AND cl.course_no = c2.course_no;
                end if;

end;


procedure j_prerequisite_info(departmentcode in varchar2,coursenumber in number, p_recordset OUT SYS_REFCURSOR,show_message OUT varchar2) as

flag1 number := 1;
msg varchar2(500) := '';

begin

        select count(*) into flag1 from prerequisites where dept_code = departmentcode AND course_no = coursenumber;

        if(flag1=0) then
                msg := 'No prerequisite';
                show_message := msg;
        else
                OPEN p_recordset FOR SELECT concat(pre_dept_code, pre_course_no) FROM prerequisites CONNECT BY PRIOR pre_dept_code = dept_code AND PRIOR pre_course_no = course_no START WITH dept_code = departmentcode AND course_no = coursenumber;
        end if;
end;


procedure j_class_info(s_classid in char, show_message OUT varchar2, c_recordset OUT SYS_REFCURSOR) as
flag number:=1;
flag1 number:=1;
msg varchar2(500) := '';

begin
        select count(*) into flag from classes where classid = s_classid;
                select count(*) into flag1 from enrollments where classid = s_classid;

        if(flag=0) then
                msg := 'The cid is invalid';
                                show_message := msg;
        elsif(flag1=0 and flag !=0) then
                                msg := 'No student is enrolled in the class.';
                                show_message := msg;
                else
                        open c_recordset for select c1.classid, c2.title, c1.semester, c1.year, e.sid, s.firstname, s.lastname from classes c1 INNER JOIN courses c2 ON c1.dept_code = c2.dept_code AND c1.course_no = c2.course_no INNER JOIN enrollments e ON e.classid = c1.classid INNER JOIN students s ON s.sid = e.sid WHERE c1.classid = s_classid;

                end if;

end;



procedure j_enrollment(student_id in char,c_classid in char, show_message OUT varchar2) as

flag1 NUMBER:=1;
flag2 NUMBER:=1;
isavailable NUMBER:=1;
flag3 NUMBER:=0;
sem classes.semester%type;
yr classes.year%type;
flag4 NUMBER:=0;
count_var number:=0;
d_deptcode classes.dept_code%type;
c_courseno classes.course_no%type;
sc1_deptcode classes.dept_code%type;
sc1_courseno classes.course_no%type;
sc2_cid classes.classid%type;
e_lgrade enrollments.lgrade%type;
pre_count NUMBER:=1;
sc1 sys_refcursor;
sc2 sys_refcursor;
cursor c1 is select classid from enrollments where sid=student_id;
c1_rec c1%rowtype;
msg varchar2(500) := '';

BEGIN
select count(*) into flag1 from students where sid=student_id;
select count(*) into flag2 from classes where classid=c_classid;

if(flag1=0)then
        msg := 'sid not found';
                show_message := msg;
                return;
elsif(flag2=0 and flag1 !=0)then
        msg := 'The classid is invalid.';
                show_message := msg;
                return;
end if;

select (limit-class_size) into isavailable from classes where classid=c_classid;
if(isavailable = 0) then
        msg := 'The class is full.';
                show_message := msg;
                return;
end if;


select count(*) into flag3 from enrollments where sid=student_id and classid=c_classid;

if(flag3=1) then
        msg := 'The student is already in this class';
                show_message := msg;
                return;
end if;

open c1;
fetch c1 into c1_rec;
while c1%found loop
select count(*) into flag4 from classes where classid=c1_rec.classid and semester='Fall' and year=2020;
if(flag4!=0) then
count_var:=count_var+1;
end if;
fetch c1 into c1_rec;
end loop;
close c1;

if(count_var=3)then
        msg := 'You are overloaded.';
                show_message := msg;
                return;
end if;

        select dept_code, course_no into d_deptcode, c_courseno from classes where classid=c_classid;
        select count(*) into pre_count from prerequisites where dept_code=d_deptcode and course_no=c_courseno;

        if(pre_count=0) then
                        stud_enroll_id:=student_id;
                        class_enroll_id:=c_classid;
                        insert into enrollments values(student_id,c_classid,null);
                        commit;
                        return;
        end if;

        open sc1 for select pre_dept_code, pre_course_no from prerequisites
        where dept_code=d_deptcode and course_no=c_courseno;
        fetch sc1 into sc1_deptcode, sc1_courseno;
                open sc2 for select classid from classes where dept_code=sc1_deptcode and course_no=sc1_courseno;
                fetch sc2 into sc2_cid;
                        select lgrade into e_lgrade from enrollments where classid=sc2_cid and sid=student_id;
                        if(e_lgrade > 'C' and flag2!=0 and flag1 !=0) then
                                        msg := 'Prerequisite courses have not been completed.';
                                        show_message := msg;
                                        return;
                        elsif(e_lgrade <= 'C') then
                                        stud_enroll_id:=student_id;
                                        class_enroll_id:=c_classid;
                                        insert into enrollments values(student_id,c_classid,null);
                                        commit;
                                        return;
                        end if;
                close sc2;
        close sc1;

        exception
                when no_data_found then
                        msg := 'Prerequisite courses have not been completed.';
                        show_message := msg;
end;


procedure j_drop_student_from_class(student_id in char,c_classid in char, show_message1 OUT varchar2, show_message2 OUT varchar2, show_message3 OUT varchar2) as
flag1 NUMBER:=1;
flag2 NUMBER:=1;
flag3 NUMBER:=1;
flag4 NUMBER:=0;
class_count number:=0;
isavailable NUMBER:=1;
deptcode classes.dept_code%type;
courseno classes.course_no%type;
p_deptcode classes.dept_code%type;
p_courseno classes.course_no%type;
cid classes.classid%type;
e_lgrade number;
sc1 sys_refcursor;
sc2 sys_refcursor;
msg1 varchar2(500) := '';
msg2 varchar2(500) := '';
msg3 varchar2(500) := '';

cursor c1 is select classid from enrollments where sid=student_id;
c1_rec c1%rowtype;

begin
select count(*) into flag1 from students where sid=student_id;

select count(*) into flag2 from classes where classid=c_classid;


if(flag1=0)then
        msg1 := 'The sid is invalid.';
                show_message1 := msg1;
elsif(flag2=0 and flag1 !=0)then
        msg1 := 'The classid is invalid.';
                show_message1 := msg1;
else
        select count(*) into flag3 from enrollments where sid=student_id and classid=c_classid;

        select dept_code, course_no into p_deptcode, p_courseno from classes where classid=c_classid;
        open sc1 for select dept_code, course_no from prerequisites
        where pre_dept_code=p_deptcode and pre_course_no=p_courseno;
        fetch sc1 into deptcode, courseno;
    open sc2 for select classid from classes where dept_code=deptcode and course_no=courseno;
    fetch sc2 into cid;
    select count(*) into e_lgrade from enrollments where classid=cid and sid=student_id;
    close sc2;
        close sc1;

        if(flag3=0 and flag2!=0 and flag1 !=0) then
                msg1 := 'The student is not enrolled in the class.';
                                show_message1 := msg1;
        elsif(e_lgrade!=0 and flag2!=0 and flag1 !=0) then
                msg1 := 'The drop is not permitted because another class uses it as a prerequisite.';
                                show_message1 := msg1;
        else
                stud_enroll_id:=student_id;
                class_enroll_id:=c_classid;

                delete from enrollments where sid=student_id and classid=c_classid;
                commit;

                open c1;
                fetch c1 into c1_rec;
                while c1%found loop
                        select count(*) into flag4 from classes where classid=c1_rec.classid and semester='Fall' and year=2020;
                        if(flag4!=0) then
                        class_count:=class_count+1;
                        end if;
                fetch c1 into c1_rec;
                end loop;
                close c1;

                if(class_count=0) then
                                        msg2 := 'This student is enrolled in no class.';
                                        show_message2 := msg2;
                end if;

                select class_size into isavailable from classes where classid=c_classid;

                if(isavailable=0) then
                                        msg3 := 'The class now has no students.';
                                        show_message3 := msg3;
                end if;

        end if;
end if;
end;


procedure j_delete_student(student_id in char, show_message OUT varchar2) as
flag NUMBER:=1;
msg varchar2(500);

begin
select count(*) into flag from students where sid=student_id;

if(flag=0)then
        msg := 'The sid is invalid.';
        show_message := msg;
else
        del_stud_sid:=student_id;
        delete from students where sid=student_id ;
        commit;
end if;
end;

end;
/
show errors
