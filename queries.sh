#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT avg(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT round(avg(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "select avg(winner_goals+opponent_goals) from games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "select winner_goals from games group by winner_goals order by winner_goals desc limit 1")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "select count(*) from (select winner_goals from games where winner_goals > 2) as foo")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "select name  from teams where team_id = (select winner_id from games where round='Final' and year='2018')")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo  "$($PSQL "select name from teams where team_id in ((select opponent_id from games where year='2014' and round='Eighth-Final' ) union (select winner_id from games where year='2014' and round='Eighth-Final')) order by name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "select name from teams where team_id in (select distinct winner_id from games) order by name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "select year, name from games inner join teams on winner_id=team_id where round = 'Final' order by name desc")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "select name from teams where name like '%Co%'")"
