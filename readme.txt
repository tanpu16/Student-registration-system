Name : Priyanka Prakash Tanpure

It contains below files:

- packagespecification.sql		//package specification
- packagebody.sql			//package body
- triggers.sql				// triggers
- sequence.sql				//sequence
- UserInterface1.java			//java code - menu driven

Command to compile:

1. Login to sql.
SQL > start sequence
SQL > start triggers
SQL > start packagespecification
SQL > start packagebody

Execute the procedure studentclass_info from sql (same format for all other procedures)

SQL > execute project2procedurefunction.studentclass_info('B001');


command to compile and run the java code
javac -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar UserInterface1.java			//Compile java program
java -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar UserInterface1.java                      //Run java code