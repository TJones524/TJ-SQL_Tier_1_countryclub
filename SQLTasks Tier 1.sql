/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
From Facilities
WHERE membercost > 0.0

/* Q2: How many facilities do not charge a fee to members? */

4

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
From Facilities
WHERE membercost < monthlymaintenance * .2 AND membercost > 0.0


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT * 
FROM Facilities 
WHERE NOT facid = 0 AND NOT facid = 2 AND NOT facid = 3 AND NOT facid = 4 AND NOT facid = 6 AND NOT facid = 7 AND NOT facid = 8;

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT Facilities.name, Facilities.monthlymaintenance,
CASE WHEN Facilities.monthlymaintenance >100 THEN 'expensive'
ELSE 'cheap'
END AS cost 
FROM Facilities;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT surname, firstname
FROM Members
WHERE memid = (SELECT MAX(memid) FROM Members

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Bookings.memid, Bookings.facid, Facilities.name, Members.surname
FROM Bookings INNER JOIN Facilities ON Bookings.facid = Facilities.facid INNER JOIN  Members ON Bookings.memid = Members.memid
WHERE Facilities.name LIKE 'Tennis Court 1' OR Facilities.name LIKE 'Tennis Court 2'
ORDER NY surname

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT Facilities.name, Members.surname,  
CASE 
	WHEN Members.memid <> 0 THEN Facilities.membercost * Bookings.slots
ELSE Facilities.guestcost * Bookings.slots
END AS cost
FROM Bookings INNER JOIN Facilities ON Bookings.facid = Facilities.facid INNER JOIN  Members ON Bookings.memid = Members.memid 
WHERE Bookings.starttime LIKE '2012-09-14%' 
ORDER BY cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */



/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

def select_all_tasks(conn):
    """
    Query all rows in the tasks table
    :param conn: the Connection object
    :return:
    """
    cur = conn.cursor()
    
    query1 = """
        SELECT Facilities.name,
        SUM(CASE 
	WHEN Members.memid <> 0 THEN Facilities.membercost * Bookings.slots
ELSE Facilities.guestcost * Bookings.slots
END) AS revenue
FROM Bookings INNER JOIN Facilities ON Bookings.facid = Facilities.facid INNER JOIN  Members ON Bookings.memid = Members.memid 
GROUP BY Facilities.name
HAVING revenue < 1000
ORDER BY revenue DESC

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

 SELECT DISTINCT a.surname, a.firstname, 
        
        CASE 
	WHEN a.recommendedby >= 1 THEN (SELECT DISTINCT b.surname WHERE b.memid = a.recommendedby) 
    ELSE 'no one'
END AS recommended
FROM members a, members b 
ORDER BY b.surname DESC


/* Q12: Find the facilities with their usage by member, but not guests */

SELECT Facilities.name, Members.surname,  
SUM(CASE 
	WHEN Members.memid <> 0 THEN Bookings.slots*15
ELSE 0
END) AS usage
FROM Bookings INNER JOIN Facilities ON Bookings.facid = Facilities.facid INNER JOIN  Members ON Bookings.memid = Members.memid 
GROUP BY Members.memid, Facilities.name
ORDER BY surname

/* Q13: Find the facilities usage by month, but not guests */


SELECT Facilities.name,
SUM(CASE WHEN Bookings.starttime LIKE "2012-01%" THEN Bookings.Slots*15
ELSE 0
END) AS january,

SUM (CASE 
	WHEN Bookings.starttime LIKE "2012-02%" THEN Bookings.slots*15 
ELSE 0
END) AS february,
    

SUM (CASE 
	WHEN Bookings.starttime LIKE "2012-03%" THEN Bookings.slots*15 
ELSE 0
END) AS march,
    
SUM(CASE WHEN Bookings.starttime LIKE "2012-04%" THEN Bookings.Slots*15
ELSE 0
END) AS april,

SUM(CASE WHEN Bookings.starttime LIKE "2012-05%" THEN Bookings.Slots*15
ELSE 0
END) AS may,

SUM(CASE WHEN Bookings.starttime LIKE "2012-06%" THEN Bookings.Slots*15
ELSE 0
END) AS june,

SUM(CASE WHEN Bookings.starttime LIKE "2012-07%" THEN Bookings.Slots*15
ELSE 0
END) AS july,

SUM(CASE WHEN Bookings.starttime LIKE "2012-08%" THEN Bookings.Slots*15
ELSE 0
END) AS august,

SUM(CASE WHEN Bookings.starttime LIKE "2012-09%" THEN Bookings.Slots*15
ELSE 0
END) AS september,

SUM (CASE 
	WHEN Bookings.starttime LIKE "2012-10%" THEN Bookings.slots*15 
ELSE 0
END) AS october,
    
SUM(CASE WHEN Bookings.starttime LIKE "2012-11%" THEN Bookings.Slots*15
ELSE 0
END) AS november,

SUM(CASE WHEN Bookings.starttime LIKE "2012-12%" THEN Bookings.Slots*15
ELSE 0
END) AS december


FROM Bookings INNER JOIN Facilities ON Bookings.facid = Facilities.facid INNER JOIN  Members ON Bookings.memid = Members.memid 

GROUP BY Facilities.name