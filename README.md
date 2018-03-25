# portArc

README contains instruction for the security components usage - This first part is simply compiled from an email which discusses the key components:

First, here is the insert line you would need to put a user into the system:
 
insert into users (firstname, lastname, email, username, accounttype, expire_date)
values ('Joe', 'Smith', 'Joe.Smith@sas.com', 'josmit', 'Application', '2020-01-01 00:00:00');
 
There are two fields I am leaving out - middlename and password.  You may need middlenames to prevent overlap, or you could treat middlename as a comment.  Up to you.  Could also add cols as desired.  For multiple users, you would put a for loop around the actual value parts in parentheses.  Like this:
 
insert into users (firstname, lastname, email, username, accounttype, expire_date)
values
<FOR loop code could go here as you iterate through a list of users>
('Joe', 'Smith', 'Joe.Smith@company.com', 'josmit', 'Application', '2020-01-01 00:00:00'),
('Joe', 'Willy', 'Joe.Willy@company.com', 'jowill', 'Application', '2020-01-01 00:00:00'),
('Joe', 'Joe', 'Joe.Joe@company.com', 'jojoe', 'Application', '2020-01-01 00:00:00');
 
Second note - usage of crytohelp class...not sure if you have had a chance to compile and play with the class that generates the pkey.txt file, but this is what I have been running from the command line to generate the file:
 
java -cp .:./ssoext/* ssoext.cryptohelp josmit /home/someone
 
This would be running it within a directory that contains the directory "ssoext".  Within the ssoext dir, the cryptohelp class would exist.  In the case above, I am generating a gz parameter base on the userid josmit.  I am telling the class to place the pkey.txt file into the "/home/chbutl".  I rewrote the class to use any path (Windows/UNIX independent) but it should be the full path referenced.
 
Also - I tested it with a launcher (Linux Mint feature) that is launching a link to this:
 
http://localhost:8080/portes/loginProcess.do?gz=47-5-148-230-250-122-202-38-96-220-235-8-45-156-180-210-81-183-225-128-171-135-53-153-117-139-112-156-203-240-107-14-120-133-130-22-155-229-154-232-238-159-218-109-37-200-95-186-217-62-150-116-117-248-222-86-16-98-101-51-129-179
 
Obviously, replace localhost:8080 with the correct hostname and ports.

ADDENDUM TO THE SECOND HALF OF INSTRUCTIONS:

Included in the repo is now a batch file and zipfile with the ssoext folder.  The Portes2Login.bat is self explanatory and provides environment variables that point to specific directories: one for the location of the pkey.txt file and the other for the classpaths/ssoext.crytohelp class.  However, I left the original instructions/description of the authentication piece inluded in the README to provide further insight to the innerworkings of the code.
