import java.sql.*;
import oracle.jdbc.*;
import java.io.*;
import oracle.jdbc.pool.OracleDataSource;
import java.lang.Object.*;
import java.util.*;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;

public class UserInterface1{


public static void main(String args[]) throws SQLException{

int option=0,subOption=0, courseno,pre_courseno,section,year,limit,class_size,logid;
String sid,fname,lname,dept,gpa,email,status,classid,title,pre_dept,sem;
boolean flag1=true;
boolean flag2=true;


Connection conn = null;

try{
        OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:ACAD111");

        Scanner in = new Scanner(System.in);

                /*
        System.out.println("Enter username to connect to database");
        String username = in.next();
        System.out.println("Enter password to connect to database");
        String password = in.next();
                */

        try{
                conn = ds.getConnection("ptanpur1","dadsgift16");
        }
        catch(Exception e){

                System.out.println("wrong !!! username or password. Please check.");
                return;
        }


        while(flag1 == true){
        flag2=true;
        System.out.println("\nPlease select any option to perform action on specific table");
        System.out.println("\n1.Students\n 2.Courses\n 3.Prerequisites\n 4.Classes\n 5.Enrollments\n 6.Logs\n 0.exit\n");
        option=in.nextInt();
        switch(option){
                case 1:
                        while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Students\n 2.Add Student\n 3.Delete Student\n 4.Show student's class info \n 0. exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                        CallableStatement cs1 = conn.prepareCall("begin ? := project2procedurefunction.getstudents(); end;");
                                        cs1.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs1.execute();
                                        ResultSet rs1=(ResultSet)cs1.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("sid\tfirstname\tlastname\tstatus\tgpa\temail\n");
                                        System.out.println("************************************************************");
                                        while(rs1.next()){
                                        System.out.println(rs1.getString(1) + "\t" + rs1.getString(2) + "\t" + rs1.getString(3) +"\t"+ rs1.getString(4) + "\t" + rs1.getDouble(5) + "\t" + rs1.getString(6));
                                        System.out.println();
                                        }
                                        cs1.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter student details to insert");
                                                                                System.out.println("Enter sid:");
                                                                                sid=in.next();
                                                                                System.out.println("Enter first name:");
                                                                                fname=in.next();
                                                                                System.out.println("Enter last name:");
                                                                                lname=in.next();
                                                                                System.out.println("Enter status('freshman', 'sophomore', 'junior', 'senior', 'graduate'):");
                                                                                status=in.next();
                                                                                System.out.println("Enter gpa between 0 and 4:");
                                                                                gpa=in.next();
                                                                                System.out.println("Enter email:");
                                                                                email=in.next();

                                                                                CallableStatement cs7 = conn.prepareCall("begin project2procedurefunction.add_student(?,?,?,?,?,?); end;");
                                                                                cs7.setString(1, sid);
                                                                                cs7.setString(2, fname);
                                                                                cs7.setString(3, lname);
                                                                                cs7.setString(4, status);
                                                                                cs7.setString(5, gpa);
                                                                                cs7.setString(6, email);

                                                                                cs7.execute();
                                                                                System.out.println("\nStudent Added");
                                                                                cs7.close();
                                                                                break;
                                case 3:
                                        System.out.println("Please enter sid :");
                                                                                sid = in.next();
                                                                                CallableStatement cs13 = conn.prepareCall("begin project2procedurefunction.j_delete_student(?,?); end;");
                                                                                cs13.setString(1,sid);
                                                                                cs13.registerOutParameter(2, java.sql.Types.VARCHAR);
                                                                                cs13.execute();

                                                                                String mmsg4 = ((OracleCallableStatement)cs13).getString(2);

                                                                                if(mmsg4 != null)
                                                                                {
                                                                                                System.out.println(mmsg4);
                                                                                }
                                                                                else
                                                                                {
                                                                                                System.out.println("Student deleted successfully");
                                                                                }
                                                                                cs13.close();
                                                                                break;
                                        case 4:
                                                        System.out.println("Please enter student sid :");
                                                        sid = in.next();
                                                                                CallableStatement cs8 = conn.prepareCall("begin project2procedurefunction.j_studentclass_info(?,?,?); end;");
                                                                                cs8.setString(1, sid);
                                                                                cs8.registerOutParameter(2, java.sql.Types.VARCHAR);
                                                                                cs8.registerOutParameter(3, OracleTypes.CURSOR); //REF CURSOR
                                                                                cs8.execute();
                                                                                ResultSet rs8 = null;
                                                                                String mmsg1 = null;

                                                                                rs8 = ((OracleCallableStatement)cs8).getCursor(3);
                                                                                mmsg1 = ((OracleCallableStatement)cs8).getString(2);

                                                                                if(mmsg1 != null)
                                                                                {
                                                                                        System.out.println(mmsg1);
                                                                                }
                                                                                else
                                                                                {
                                                                                                System.out.printf("sid\tfirstname\tlastname\tstatus\tclassid\tcourseid\ttitle\n");
                                                                                                System.out.println("************************************************************");
                                                                                                while(rs8.next()){
                                                                                                System.out.print(rs8.getString(1) + "\t" + rs8.getString(2) + "\t" + rs8.getString(3) +"\t"+ rs8.getString(4) + "\t" + rs8.getString(5) + "\t" + rs8.getString(6)+ "\t" + rs8.getString(7));
                                                                                                System.out.println();
                                                                                                }
                                                                                }

                                                                                cs8.close();
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;
                case 2:
                        while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Courses\n 2.Add course\n 3.Delete course\n 0. exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                        CallableStatement cs2 = conn.prepareCall("begin ? := project2procedurefunction.getcourses(); end;");
                                        cs2.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs2.execute();
                                        ResultSet rs2=(ResultSet)cs2.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("dept_code\tcourse_no\ttitle\n");
                                        System.out.println("************************************************************");
                                        while(rs2.next()){
                                        System.out.println(rs2.getString(1) + "\t" + rs2.getString(2) + "\t" + rs2.getString(3));
                                        System.out.println();
                                        }
                                        cs2.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter course details to insert");
                                                                                System.out.println("Enter dept_code:");
                                                                                dept=in.next();
                                                                                System.out.println("Enter course_no:");
                                                                                courseno=in.nextInt();
                                                                                System.out.println("Enter title:");
                                                                                title=in.next();

                                                                                PreparedStatement insert = conn.prepareStatement("insert into courses values(?,?,?)");
                                                                                insert.setString(1, dept);
                                                                                insert.setInt(2, courseno);
                                                                                insert.setString(3, title);

                                                                                insert.executeUpdate();
                                                                                System.out.println("\nCourse Added");
                                                                                break;
                                case 3:
                                                                                System.out.println("Please enter course details to Delete");
                                                                                System.out.println("Enter dept_code:");
                                                                                dept=in.next();
                                                                                System.out.println("Enter course_no:");
                                                                                courseno=in.nextInt();
                                                                                PreparedStatement delete = conn.prepareStatement("delete from courses where dept_code=? and course_no=?");
                                                                                delete.setString(1, dept);
                                                                                delete.setInt(2, courseno);

                                                                                delete.executeUpdate();
                                                                                System.out.println("\nCourse deleted");
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;
                case 3:
                        while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Prerequisites\n 2.Add Prerequisite\n 3.Delete Prerequisites\n 4.Show Prerequisites info for a course\n 0.exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                       CallableStatement cs3 = conn.prepareCall("begin ? := project2procedurefunction.getprereq(); end;");
                                        cs3.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs3.execute();
                                        ResultSet rs3=(ResultSet)cs3.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("dept_code\tcourse_no\t pre_dept_code\t pre_course_no\n");
                                        System.out.println("************************************************************");
                                        while(rs3.next()){
                                        System.out.println(rs3.getString(1) + "\t" + rs3.getString(2) + "\t" + rs3.getString(3) + "\t" + rs3.getString(4));
                                        System.out.println();
                                        }
                                        cs3.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter course details to insert");
                                                                                System.out.println("Enter dept_code:");
                                                                                dept=in.next();
                                                                                System.out.println("Enter course_no:");
                                                                                courseno=in.nextInt();
                                                                                System.out.println("Enter pre_dept_code:");
                                                                                pre_dept=in.next();
                                                                                System.out.println("Enter pre_course_no:");
                                                                                pre_courseno=in.nextInt();

                                                                                PreparedStatement insert = conn.prepareStatement("insert into prerequisites values(?,?,?,?)");
                                                                                insert.setString(1, dept);
                                                                                insert.setInt(2, courseno);
                                                                                insert.setString(3, pre_dept);
                                                                                insert.setInt(4, pre_courseno);

                                                                                insert.executeUpdate();
                                                                                System.out.println("\nprerequisite Added");
                                                                                break;
                                case 3:
                                                                                System.out.println("Please enter prerequisite details to Delete");
                                                                                System.out.println("Enter dept_code:");
                                                                                dept=in.next();
                                                                                System.out.println("Enter course_no:");
                                                                                courseno=in.nextInt();
                                                                                System.out.println("Enter pre_dept_code:");
                                                                                pre_dept=in.next();
                                                                                System.out.println("Enter pre_course_no:");
                                                                                pre_courseno=in.nextInt();
                                                                                PreparedStatement delete = conn.prepareStatement("delete from prerequisites where dept_code=? and course_no=? and pre_dept_code=? and pre_course_no=? ");
                                                                                delete.setString(1, dept);
                                                                                delete.setInt(2, courseno);
                                                                                delete.setString(3, pre_dept);
                                                                                delete.setInt(4, pre_courseno);

                                                                                delete.executeUpdate();
                                                                                System.out.println("\nprerequisite deleted");
                                                                                break;
                                                                case 4 :
                                                                                System.out.println("Please enter dept code :");
                                                                                dept = in.next();
                                                                                System.out.println("Please enter course number :");
                                                                                courseno = in.nextInt();
                                                                                CallableStatement cs9 = conn.prepareCall("begin project2procedurefunction.j_prerequisite_info(?,?,?,?); end;");
                                                                                cs9.setString(1,dept);

                                                                                cs9.setInt(2,courseno);
                                                                                cs9.registerOutParameter(3, OracleTypes.CURSOR); //REF CURSOR
                                                                                cs9.registerOutParameter(4, java.sql.Types.VARCHAR);
                                                                                cs9.execute();
                                                                                ResultSet rs9 = null;
                                                                                String mmsg9 = null;

                                                                                rs9 = ((OracleCallableStatement)cs9).getCursor(3);
                                                                                mmsg9 = ((OracleCallableStatement)cs9).getString(4);


                                                                                if(mmsg9 != null)
                                                                                {
                                                                                                System.out.println("No Prerequisite");
                                                                                }
                                                                                else
                                                                                {
                                                                                                System.out.printf("prerequisite courses\n");
                                                                                                System.out.println("*****************************************");
                                                                                                while(rs9.next()){
                                                                                                System.out.print(rs9.getString(1));
                                                                                                System.out.println();
                                                                                                }
                                                                                }
                                                                                cs9.close();
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;
                case 4:
                                                while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Classes\n 2.Add Class\n 3.Delete Class\n 4.Show class info\n 0.exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                        CallableStatement cs4 = conn.prepareCall("begin ? := project2procedurefunction.getclasses(); end;");
                                        cs4.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs4.execute();
                                        ResultSet rs4=(ResultSet)cs4.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("classid\tdept_code\tcourse_no\tsect_no\tyear\tsemester\tlimit\tclass_size\n");
                                        System.out.println("************************************************************");
                                        while(rs4.next()){
                                        System.out.println(rs4.getString(1) + "\t" + rs4.getString(2) + "\t" + rs4.getString(3) + "\t" + rs4.getString(4) + "\t" + rs4.getString(5) + "\t" + rs4.getString(6) + "\t" + rs4.getString(7) + "\t" + rs4.getString(8));
                                        System.out.println();
                                        }
                                        cs4.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter class details to insert");
                                                                                System.out.println("Enter classid:");
                                                                                classid=in.next();
                                                                                System.out.println("Enter dept_code:");
                                                                                dept=in.next();
                                                                                System.out.println("Enter course_no:");
                                                                                courseno=in.nextInt();
                                                                                System.out.println("Enter sect_no:");
                                                                                section=in.nextInt();
                                                                                System.out.println("Enter year:");
                                                                                year=in.nextInt();
                                                                                System.out.println("Enter semester:");
                                                                                sem=in.next();
                                                                                System.out.println("Enter limit:");
                                                                                limit=in.nextInt();
                                                                                System.out.println("Enter class_size:");
                                                                                class_size=in.nextInt();

                                                                                PreparedStatement insert = conn.prepareStatement("insert into classes values(?,?,?,?,?,?,?,?)");
                                                                                insert.setString(1, classid);
                                                                                insert.setString(2, dept);
                                                                                insert.setInt(3, courseno);
                                                                                insert.setInt(4, section);
                                                                                insert.setInt(5, year);
                                                                                insert.setString(6, sem);
                                                                                insert.setInt(7, limit);
                                                                                insert.setInt(8, class_size);

                                                                                insert.executeUpdate();
                                                                                System.out.println("\nClass Added");
                                                                                break;
                                case 3:
                                                                                System.out.println("Please enter class details to Delete");
                                                                                System.out.println("Enter classid:");
                                                                                classid=in.next();

                                                                                PreparedStatement delete = conn.prepareStatement("delete from classes where classid=?");
                                                                                delete.setString(1, classid);

                                                                                delete.executeUpdate();
                                                                                System.out.println("\nclass deleted");
                                                                                break;
                                                                case 4 :
                                                                                System.out.println("Please enter classid :");
                                                                                classid = in.next();
                                                                                CallableStatement cs10 = conn.prepareCall("begin project2procedurefunction.j_class_info(?,?,?); end;");
                                                                                cs10.setString(1, classid);
                                                                                cs10.registerOutParameter(2, java.sql.Types.VARCHAR);
                                                                                cs10.registerOutParameter(3, OracleTypes.CURSOR); //REF CURSOR
                                                                                cs10.execute();
                                                                                ResultSet rs10 = null;
                                                                                String mmsg10 = null;

                                                                                rs10 = ((OracleCallableStatement)cs10).getCursor(3);
                                                                                mmsg10 = ((OracleCallableStatement)cs10).getString(2);

                                                                                if(mmsg10 != null)
                                                                                {
                                                                                        System.out.println(mmsg10);
                                                                                }
                                                                                else if(rs10 !=null)
                                                                                {
                                                                                                System.out.printf("classid\ttitle\tsemester\tyear\tsid\tfirstname\tlastname\n");
                                                                                                System.out.println("************************************************************");
                                                                                                while(rs10.next()){
                                                                                                System.out.print(rs10.getString(1) + "\t" + rs10.getString(2) + "\t" + rs10.getString(3) +"\t"+ rs10.getString(4) + "\t" + rs10.getString(5) + "\t" + rs10.getString(6)+ "\t" + rs10.getString(7));
                                                                                                System.out.println();
                                                                                                }
                                                                                }
                                                                                cs10.close();
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;
                case 5:
                                                while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Enrollments\n 2.Enroll student\n 3.Drop student from class\n 0.exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                        CallableStatement cs5 = conn.prepareCall("begin ? := project2procedurefunction.getenrollment(); end;");
                                        cs5.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs5.execute();
                                        ResultSet rs5=(ResultSet)cs5.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("sid\tclassid\tlgrade\n");
                                        System.out.println("************************************************************");
                                        while(rs5.next()){
                                        System.out.println(rs5.getString(1) + "\t" + rs5.getString(2) + "\t" + rs5.getString(3));
                                        System.out.println();
                                        }
                                        cs5.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter sid :");
                                                                                sid = in.next();
                                                                                System.out.println("Please enter classid :");
                                                                                classid = in.next();
                                                                                CallableStatement cs11 = conn.prepareCall("begin project2procedurefunction.j_enrollment(?,?,?); end;");
                                                                                cs11.setString(1,sid);
                                                                                cs11.setString(2,classid);
                                                                                cs11.registerOutParameter(3, java.sql.Types.VARCHAR);
                                                                                cs11.execute();

                                                                                String mmsg3 = null;

                                                                                mmsg3 = ((OracleCallableStatement)cs11).getString(3);

                                                                                if(mmsg3 != null)
                                                                                {
                                                                                                System.out.println(mmsg3);
                                                                                }
                                                                                else
                                                                                {
                                                                                                System.out.println("Student Enroll suceesfully!");
                                                                                }
                                                                                cs11.close();
                                                                                break;
                                case 3:
                                                                                System.out.println("Please enter sid :");
                                                                                sid = in.next();
                                                                                System.out.println("Please enter classid :");
                                                                                classid = in.next();
                                                                                CallableStatement cs12 = conn.prepareCall("begin project2procedurefunction.j_drop_student_from_class(?,?,?,?,?); end;");
                                                                                cs12.setString(1,sid);
                                                                                cs12.setString(2,classid);
                                                                                cs12.registerOutParameter(3, java.sql.Types.VARCHAR);
                                                                                cs12.registerOutParameter(4, java.sql.Types.VARCHAR);
                                                                                cs12.registerOutParameter(5, java.sql.Types.VARCHAR);
                                                                                cs12.execute();

                                                                                String msg1 = null;
                                                                                String msg2 = null;
                                                                                String msg3 = null;

                                                                                msg1 = ((OracleCallableStatement)cs12).getString(3);
                                                                                msg2 = ((OracleCallableStatement)cs12).getString(4);
                                                                                msg3 = ((OracleCallableStatement)cs12).getString(5);

                                                                                if(msg1 != null)
                                                                                {
                                                                                                System.out.println(msg1);
                                                                                }
                                                                                else
                                                                                {
                                                                                                System.out.println("Student drop suceesfully from class!");
                                                                                                if(msg2 != null)
                                                                                                {
                                                                                                                                System.out.println(msg2);
                                                                                                }
                                                                                                if(msg3 != null)
                                                                                                {
                                                                                                                                System.out.println(msg3);
                                                                                                }
                                                                                }
                                                                                cs12.close();
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;

                case 6:
                        while(flag2 == true){
                        System.out.println("\nWhich Action you want to perform?");
                        System.out.println(" 1.Display Logs\n 2.Delete log\n 0. exit\n");
                        subOption=in.nextInt();
                        switch(subOption){
                                case 1:
                                        CallableStatement cs6 = conn.prepareCall("begin ? := project2procedurefunction.getlogs(); end;");
                                        cs6.registerOutParameter(1, OracleTypes.CURSOR);

                                        cs6.execute();
                                        ResultSet rs6=(ResultSet)cs6.getObject(1);
                                        System.out.println("************************************************************");
                                        System.out.printf("logid\twho\ttime\ttable_name\toperation\tkey_value\n");
                                        System.out.println("************************************************************");
                                        while(rs6.next()){
                                        System.out.println(rs6.getString(1) + "\t" + rs6.getString(2) + "\t" + rs6.getString(3) + "\t" + rs6.getString(4) + "\t" + rs6.getString(5) + "\t" + rs6.getString(6));
                                        System.out.println();
                                        }
                                        cs6.close();
                                        break;
                                case 2:
                                                                                System.out.println("Please enter log details to Delete");
                                                                                System.out.println("Enter logid:");
                                                                                logid=in.nextInt();
                                                                                PreparedStatement delete = conn.prepareStatement("delete from logs where logid=?");
                                                                                delete.setInt(1, logid);

                                                                                delete.executeUpdate();
                                                                                System.out.println("\nlog deleted");
                                                                                break;
                                case 0:
                                        flag2=false;
                                        break;
                                default:
                                        System.out.println("Invalid option!");
                                        break;
                        }
                        }
                        break;
                case 0:
                        flag1=false;
                        break;
                default:
                                System.out.println("Invalid option!");
                                break;
                }
        }

}
catch (SQLException ex)
{
        ex.printStackTrace();
        System.out.println ("\n*** SQLException caught ***\n");
}
catch(Exception e){
        e.printStackTrace();
        System.out.println ("\n*** other Exception caught ***\n");
}
finally{
        if(conn != null)
        {
                try{
                        conn.close();
                }
                catch(Exception e){
                        e.printStackTrace();
                }
        }
}

}

}
