#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

declare A arr 

# psql --username=freecodecamp --dbname=worldcup -t -c "truncate teams RESTART IDENTITY cascade"
# psql --username=freecodecamp --dbname=worldcup -t -c "truncate games RESTART IDENTITY cascade"

$($PSQL "truncate teams RESTART IDENTITY cascade")  
$($PSQL "truncate games RESTART IDENTITY cascade")  

while IFS="," read -r rec1 rec2 rec3 rec4 rec5 rec6
do

  if ! [[ " ${arr[*]} " =~ "$rec3" ]]; then
    arr+=("$rec3")
    # psql --username=freecodecamp --dbname=worldcup -t -c "insert into teams (name) values ('$rec3')"
     echo "$($PSQL "insert into teams (name) values ('$rec3')")"  
    # echo meow2
  fi
  if ! [[ " ${arr[*]} " =~ "$rec4" ]]; then
    arr+=("$rec4")
    # psql --username=freecodecamp --dbname=worldcup -t -c "insert into teams (name) values ('$rec4')"
    echo "$($PSQL "insert into teams (name) values ('$rec4')")" 
    # echo meow1
  fi
  winner=$($PSQL "select team_id from teams where name = '$rec3'")
  opponent=$($PSQL "select team_id from teams where name = '$rec4'")
  # winner=$(psql --username=freecodecamp --dbname=worldcup -t -c "select team_id from teams where name = '$rec3'")
  # opponent=$(psql --username=freecodecamp --dbname=worldcup -t -c "select team_id from teams where name = '$rec4'")

echo winner $winner
echo opponent $opponent
  # psql --username=freecodecamp --dbname=worldcup -t -c "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals ) values ('$rec1', '$rec2', '$winner', '$opponent', '$rec5', '$rec6')"
  echo "$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals ) values ('$rec1', '$rec2', '$winner', '$opponent', '$rec5', '$rec6')")"

 
done < <(tail -n +2 games.csv)
# done < <(cut -d "," -f3,4 games.csv | tail -n +2)

exit 0
