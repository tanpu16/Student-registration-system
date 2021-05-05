create or replace trigger t_after_enroll
after insert on enrollments
for each row
begin
        update classes set class_size = class_size+1 where classid=:new.classid;
        insert into logs values(log_number.nextval,user,sysdate,'enrollments','insert', :new.sid || ',' || :new.classid);
        exception
                when no_data_found then
                        null;
end;
/

create or replace trigger t_after_add_student
after insert on students
for each row
begin
insert into logs values(log_number.nextval, user, sysdate, 'students', 'insert', :new.sid);
end;
/

create or replace trigger t_before_delete_student
before delete on students
for each row
begin
delete from enrollments where enrollments.sid = :old.sid;
exception
        when no_data_found then
                null;
end;
/

create or replace trigger log_entry_after_delete_stud
after delete on students
for each row
begin
insert into logs values(log_number.nextval,user,sysdate,'students','delete', :old.sid);
end;
/

create or replace trigger t_after_delete_enroll
after delete on enrollments
for each row
begin
        update classes set class_size = class_size-1 where classid=:old.classid;
        insert into logs values(log_number.nextval,user,sysdate,'enrollments','delete', :old.sid);
        exception
                when no_data_found then
                        null;
end;
/

create or replace trigger t_before_delete_class
before delete on classes
for each row
begin
delete from enrollments where enrollments.classid = :old.classid;
exception
        when no_data_found then
                null;
end;
/

show errors
	