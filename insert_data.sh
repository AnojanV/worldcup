#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
 do
  if [[ $YEAR != "year" ]]
   then
     echo $YEAR

     #Get winner team ID
     WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
     echo $WINNER

     #If found echo winner ID
     if [[ -n $WINNER_ID ]]
      then
      echo $WINNER_ID
     fi

     #If not found, then insert winner into teams table
     if [[ -z $WINNER_ID ]]
      then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
       then
       echo Inserted $WINNER into Teams table!
      fi

      #Get new team ID for winner
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo $WINNER_ID 
     fi

     #Get opponent team ID
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
     echo $OPPONENT

     #If found echo opponent ID
     if [[ -n $OPP_ID ]]
      then
      echo $OPP_ID
     fi

     #If not found, then insert opponent into teams table
     if [[ -z $OPP_ID ]]
     then
     INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
     if [[ $INSERT_OPP_RESULT == 'INSERT 0 1' ]]
      then 
      echo Inserted $OPPONENT into teams table!
     fi

     #Get new team ID for opponent
     OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
     echo $OPP_ID
     fi

     #Insert into games table
     INSERT_RESULT=$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES('$YEAR','$WINNER_ID','$OPP_ID','$WINNER_GOALS','$OPPONENT_GOALS','$ROUND')")
     if [[ $INSERT_RESULT == 'INSERT 0 1' ]]
      then
      echo Inserted $YEAR,$WINNER_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS,$ROUND into year column!
     fi

 echo -e "\n ~~next input~~ \n"
 fi
 done
