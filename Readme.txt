A data set, Cricket.csv contains 3,932 results of cricket matches from 1971 to 2017. Columns (variables) in the data set are listed in Exhibit 1, below.

EXHIBIT 1		
Scorecard	 	Index number
Team 1 	 	Host team.
Team 2	 	Visiting team 
Winner	 	Winning team
Margin	 	Margin for winning team (in either wickets or runs)
Ground		The name of the ground where the game was played.
Match date		The date on which the game was played.
 
The data set needs to be carefully cleaned and prepared. There are several considerations: 
o	Subset the data to include only matches where India is the host team or visiting team.
o	Extract the year of the match from the date of the match. 
o	There may be one or more matches that were played over more than a single day.
o	Some matches have no result, ties, or blanks in the Winner column.
o	Deal with the arrangement of the teams. India appears as Team 1 when it is the host and as Team 2 as the visitor. This may present a challenge to transform the file so that the win/loss record of India can be accurately counted.

Metrics:
1.	Overall, how many matches did India play in the data set?
a.	How many matches did India win? How many were lost? What is India's winning percentage?
b.	Did India tend to win a greater percentage of its matches when it was the home team? What was India's winning percentage when it was the home team versus the visiting team?
c.	Over the years, did India's winning percentage tend to increase, decrease, or stay about the same. 

2.	Create a table showing the win/loss numbers for India by opponent. 
a.	Sort the table by number of matches played with the opponent.
b.	What are the top three opponents in terms of number of matches that India won? How did India fare against these three teams?
c.	Which teams have the highest winning percentage?
