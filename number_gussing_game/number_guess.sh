#!/bin/bash

# PostgreSQL command with default parameters
PSQL="psql --username=freecodecamp --dbname=number_guessing -t --no-align -c"

# Prompt user for their username
echo "Enter your username:"
read USER_NAME

# Retrieve user data from the database based on the username
USER_DATA=$($PSQL "SELECT * FROM users WHERE user_name = '$USER_NAME'")

# Generate a random number between 1 and 1000
RAND=$(($(($RANDOM % 1001))+1))

# Initialize the number of tries
TRIES=0

# Check if the user is new or returning
if [[ -z $USER_DATA ]]; then
    # If the user is new, insert their data into the database
    INSERT_RESULT=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME')")
    
    # Retrieve the user's ID
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")

    # Display a welcome message for new users
    echo "Welcome, $USER_NAME! It looks like this is your first time here."
    
    # Set a flag to identify new users
    NEW_USER=1
else    
    # If the user is returning, extract relevant data from the retrieved string
    IFS='|' read USER_ID USER_NAME BEST_GAME_GUESSES GAMES_NUMBER <<< "$USER_DATA"

    # Display a welcome back message for returning users
    echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_NUMBER games, and your best game took $BEST_GAME_GUESSES guesses."
fi

# Prompt the user to guess the secret number
echo "Guess the secret number between 1 and 1000:"

# Main game loop
while [ true ]; do
    # Read user input
    read USER_INPUT
    # Increment the number of tries
    TRIES=$(($TRIES+1))
    
    # Check if the user input is a valid integer
    if [[ $USER_INPUT =~ ^[0-9]+$ ]]; then
        # Compare the user's input with the random number
        if [[ $USER_INPUT -lt $RAND ]]; then
            echo "It's higher than that, guess again:"
        elif [[ $USER_INPUT -gt $RAND ]]; then
            echo "It's lower than that, guess again:"
        elif [[ $USER_INPUT -eq $RAND ]]; then
            # Break out of the loop if the guess is correct
            break
        fi
    else
        # Notify the user if the input is not a valid integer
        echo "That is not an integer, guess again:"
    fi
done

# Update user data based on the game outcome
if [[ $NEW_USER -eq 1 ]]; then
    # If the user is new, set initial game data
    GAMES_NUMBER=1
    BEST_GAME_GUESSES=$TRIES
else
    # If the user is returning, update game data if necessary
    if [[ $TRIES -lt $BEST_GAME_GUESSES ]]; then
        BEST_GAME_GUESSES=$TRIES
    fi
    GAMES_NUMBER=$(($GAMES_NUMBER+1))
fi

# Update user data in the database
UPDATE_RESULT=$($PSQL "UPDATE users SET games_number = $GAMES_NUMBER, best_game_guesses = $BEST_GAME_GUESSES WHERE user_id = $USER_ID")

# Display the game outcome
if [[ $UPDATE_RESULT == "UPDATE 1" ]]; then
    echo "You guessed it in $TRIES tries. The secret number was $RAND. Nice job!"
else
    echo "Error while updating data."
fi
