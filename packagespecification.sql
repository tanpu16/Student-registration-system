create or replace package project2procedurefunction as
	stud_enroll_id students.sid%type;
	class_enroll_id classes.classid%type;
	del_stud_sid students.sid%type;
	add_stud_sid students.sid%type;
	stud_fname students.firstname%type;
	stud_lname students.lastname%type;
	stud_status students.status%type;
	stud_gpa students.gpa%type;
	stud_email students.email%type;
	dept_code courses.dept_code%type;
	course_no courses.course_no%type;
	class_id classes.classid%type;
	log_id logs.logid%type;
	type  refcur is ref cursor;
	
	procedure show_students;
	procedure show_courses;
	procedure show_prerequisites;
	procedure show_classes;
	procedure show_enrollments;
	procedure show_logs;
	procedure add_student(student_id in char,first_name in varchar2,last_name in varchar2,student_status in varchar2,student_gpa in number, student_email in varchar2);
	procedure studentclass_info(student_id in char);
	procedure prerequisite_info(departmentcode in varchar2,coursenumber in number);
	procedure class_info(s_classid in char);
	procedure enrollment(student_id in char,c_classid in char);
	procedure drop_student_from_class(student_id in char,c_classid in char);
	procedure delete_student(student_id in char);
	
	/* Procedures/functions to use in java/jdbc*/
		
	function getstudents return refcur;
	function getcourses return refcur;
    function getenrollment return refcur;
    function getclasses return refcur;
    function getprereq return refcur;
    function getlogs return refcur;

	procedure j_studentclass_info(student_id in char, show_message OUT varchar2, sc_recordset OUT SYS_REFCURSOR);
	procedure j_prerequisite_info(departmentcode in varchar2,coursenumber in number, p_recordset OUT SYS_REFCURSOR,show_message OUT varchar2);
	procedure j_class_info(s_classid in char, show_message OUT varchar2, c_recordset OUT SYS_REFCURSOR);
	procedure j_enrollment(student_id in char,c_classid in char, show_message OUT varchar2);
	procedure j_drop_student_from_class(student_id in char,c_classid in char, show_message1 OUT varchar2, show_message2 OUT varchar2, show_message3 OUT varchar2);
	procedure j_delete_student(student_id in char, show_message OUT varchar2);
	
end;
/