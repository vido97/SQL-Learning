/*
	Task 1: please retrieve consumer complaints that happened (Data_received) on 2012-01-01, 2012-02-01, 2012-03-01, 2012-04-01 or 2012-05-01, using function ‘IN’.
*/
Select * FROM cfpb_complaints_2500 WHERE Data_received IN (20120101, 20120201, 20120301, 20120401,20120501);

/*
	Task 2:  please retrieve the records relating to the company Bank of America, in which the issue is related to ATM (string includes ATM).
*/
SELECT * FROM cfpb_complaints_2500 WHERE company ="Bank of America" AND Issue regexp "ATM";
SELECT * FROM cfpb_complaints_2500 WHERE Company = 'Bank of America' AND Issue LIKE '%ATM%';

/*
	Task 3: please retrieve the records relating to the company Bank of America, in which the issue is related to ATM or theft.
*/
SELECT * FROM cfpb_complaints_2500 WHERE company ="Bank of America" AND Issue regexp "ATM|theft";

/*
	Task 4: please retrieve the top 3 companies that have most issues relating to ATM.
*/
SELECT company, COUNT(*) AS freq
FROM cfpb_complaints_2500 
where issue REGEXP "ATM"
GROUP BY company
ORDER BY freq desc
LIMIT 3;

/*
	Task 5: please retrieve the records in which Issue includes 7 characters.
*/
SELECT * FROM cfpb_complaints_2500 WHERE LENGTH (issue) = 7;
SELECT * FROM cfpb_complaints_2500 WHERE issue LIKE "_______";
/*
	Task 6: please retrieve the records in which Issue are related to loan, saving or credit (please use regexp function)
*/
SELECT * FROM cfpb_complaints_2500 WHERE issue REGEXP "loan|saving|credit";
/*
	Task 7: please list the names of companies that are included in the dataset. No duplicated names should be returned.
*/
SELECT DISTINCT company FROM cfpb_complaints_2500;
/*
	Task 8: please produce a list of different products (column “products”) and count their frequencies respectively.
*/
SELECT Product , COUNT(Product) AS frequency FROM cfpb_complaints_2500 GROUP BY Product;
SELECT Product , COUNT(*) AS frequency FROM cfpb_complaints_2500 GROUP BY Product;
/*
	Task 9: please list different ways of submitting a complaint (Submitted via) and count their respective frequencies.
*/
SELECT DISTINCT Submitted_via , COUNT(Submitted_via) AS frequency FROM cfpb_complaints_2500 GROUP BY Submitted_via;
SELECT DISTINCT Submitted_via , COUNT(*) AS frequency FROM cfpb_complaints_2500 GROUP BY Submitted_via;
/*
/*
	Task 10: please retrieve the first 5 characters as well as last 5 characters of issue, respectively.
*/
SELECT issue, LEFT (Issue,5), RIGHT (issue,5) FROM cfpb_complaints_2500;
/*
	Task 11: please return the last two words of Issue
*/
SELECT issue,SUBSTRING_INDEX (issue," ",-2) FROM cfpb_complaints_2500;
/*
	Task 12: Please return a new column by replacing the word “fee” to be “cost” in the column Issue, only showing the records in which the Issue includes the word “fee”.
*/
SELECT REPLACE (issue,"fee","cost") FROM cfpb_complaints_2500 WHERE issue REGEXP "fee";
/*
The following questions are based on the exploring the table [tripadvisor_data_for_handson_assignment_ONLY]. 
Please import the file [tripadvisor_data_for_handson_assignment_ONLY.sql] to your database and perform your analysis.

	Task 13: Please count the number of words for the title of each review.
*/
SELECT title,LENGTH(title) FROM tripadvisor_data_for_handson_assignment_ONLY; -- get amount of characters
SELECT title,LENGTH(REPLACE(title," ","")) FROM tripadvisor_data_for_handson_assignment_ONLY; -- amount of characters without space
-- LENGTH(title)- LENGTH(REPLACE(title," ","")) = amount of space
-- amount of spcae + 1 = amount of words
SELECT title,LENGTH(title)- LENGTH(REPLACE(title," ","")) +1 AS number_of_words FROM tripadvisor_data_for_handson_assignment_ONLY;
/*
	Task 14: Please find French reviews in the table. 
As we know, être, avoir, je, de are popular French words. If one of the above-mentioned French words appears at the review, we say it is a French review. 
Please identify those French reviews based on the column title. No need to consider punctuation, like [ de.].
*/
SELECT title FROM tripadvisor_data_for_handson_assignment_ONLY WHERE title REGEXP ("être|avoir|je|de");

--Task 15: Run the following command to create a table representing customers’ comment:
create table Con_comment (Consumer_comment varchar(1000));
insert into Con_comment values ('first sentence. second sentece. third sentence.');
insert into Con_comment values ('first sentence. second sentece. third sentence.');

--Please write one query to get the following result
SELECT SUBSTRING_INDEX (Consumer_comment,".",1) AS sen1, 
SUBSTRING_INDEX ((SUBSTRING_INDEX(Consumer_comment,".",2)),".",-1) AS sen2, 
SUBSTRING_INDEX (Consumer_comment,".",-2) AS sen3
FROM Con_comment;
 
--	If we want to save the result to be a new table of ‘Comment_sentence’, what command should be used?
CREATE TABLE Comment_sentence AS SELECT SUBSTRING_INDEX (Consumer_comment,".",1) AS sen1,  SUBSTRING_INDEX ((SUBSTRING_INDEX(Consumer_comment,".",2)),".",-1) AS sen2, SUBSTRING_INDEX (Consumer_comment,".",-2) AS sen3
FROM Con_comment;

/*
	Advance tasks - Task 16: 
A fake review detection project: We would like to develop something to detect fake reviews online. However, the first thing we need to do is to obtain a sample of fake reviews so that we can analyze their characteristics. We know that fake reviews with exactly the same content may be submitted to different hotels. 
-	To make it simple, we thereafter only focus on and analyze review title, instead of review content.
You need to use ‘count(*)’ function to do the following tasks.
*/
--	Please detect which review title has been most often used by users in the database, and please order the results by the frequency of titles in a descending way. 
SELECT title, COUNT(*) AS review_fequency FROM tripadvisor_data_for_handson_assignment_ONLY GROUP BY title ORDER BY review_fequency desc;

--	Please detect which review title has been most often used by users in the database if the difference in the use of capital character matters, and please order the results by the frequency of repeated titles in a descending way. 
select binary title, count(*) from tripadvisor_data_for_handson_assignment_ONLY group BY binary title 
order by count(*) desc

--	Let’s assume that the use of punctuations, like ‘.’ and ‘!’ is not important, redo the above analysis by dropping the punctuations ‘.’ and ‘!’ from the titles. 
SELECT upper(title), COUNT(*) AS review_fequency FROM tripadvisor_data_for_handson_assignment_ONLY where title not REGEXP ("."|"!")
GROUP BY title ORDER BY review_fequency DESC;

select binary replace(replace(title, '!', ''), '.', ''), count(*) from tripadvisor_data_for_handson_assignment_ONLY
group by binary replace(replace(title, '!', ''), '.', '') order by count(*) desc;


--	What is the most popular last word used in the titles, ONLY consider those review titles that have at least 2 words? 
SELECT SUBSTRING_INDEX (title," ",-1) AS popular_last_word, COUNT(*) AS freq FROM tripadvisor_data_for_handson_assignment_ONLY WHERE (LENGTH(title)- LENGTH(REPLACE(title," ",""))) +1 >=2
GROUP BY SUBSTRING_INDEX(title, ' ', -1) order by count(*) DESC;

select SUBSTRING_INDEX(title, ' ', -1), count(*) from tripadvisor_data_for_handson_assignment_ONLY where (length(title) - length(replace(title, ' ', ''))) > 0 group by SUBSTRING_INDEX(title, ' ', -1) order by count(*) DESC;
