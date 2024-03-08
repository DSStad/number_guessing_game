#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~~ Number Guessing Game ~~~~\n"
RANDOM_NUM=$(shuf -i 1-1000 -n 1)

echo "Enter your username:"
read USERNAME

FIND_USER=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

if [[ -z $FIND_USER ]]
then
  # insert new user with first game_played
  INSERT_NEW_USER=$($PSQL "INSERT INTO users (username, games_played) VALUES ('$USERNAME', 1)")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # get games_played and best_game from username
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
  # add to games_played
  UPDATE_GAMES=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
  # get best game score
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
  # welcome message
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
# read GUESS
GUESS_COUNT=0

# if [[ ! $GUESS =~ ^[0-9]+$ ]]
#   then
#   echo "That is not an interger, guess again:"
# fi

until false 
do
  read GUESS
  GUESS_COUNT=$((GUESS_COUNT + 1))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"

  elif [[ $GUESS -eq $RANDOM_NUM ]]
  then

    if [[ $GUESS_COUNT -lt $BEST_GAME || -z $BEST_GAME ]]
    then 
    UPDATE_BEST_GAME_GUESS_COUNT=$($PSQL "UPDATE users SET best_game = $GUESS_COUNT WHERE username = '$USERNAME'")
    fi 

    echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUM. Nice job!"

    break

  elif [[ $GUESS -lt $RANDOM_NUM ]]
  then 
    # read -p "It's higher than that, guess again:" GUESS
    echo "It's higher than that, guess again:"
    continue

  elif [[ $GUESS -gt $RANDOM_NUM ]]
  then 
    # read -p "It's lower than that, guess again:" GUESS
    echo "It's lower than that, guess again:"
    continue
  # else 
    # if [[ ! $GUESS =~ ^[0-9]+$ ]]
    # then
    # echo "That is not an interger, guess again:"
    # fi
  fi
  
done



