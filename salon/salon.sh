#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU() {
    # show the main menu first
    SERVICES=$($PSQL "SELECT * FROM services;")
    echo -e "\n$1"
    echo "$SERVICES" | while read SERVICES_ID BAR SERVICES_NAME
    do
        echo "$SERVICES_ID) $SERVICES_NAME"
    done;

    read SERVICE_ID_SELECTED;
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
    SELECTED_SERVICE_NAME=$(echo $SELECTED_SERVICE_NAME | sed 's/ //g')


    if [[ -z $SELECTED_SERVICE_NAME ]]
    then
        MAIN_MENU "I could not find that service. What would you like today?"
    else
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        read CUSTOMER_ID BAR CUSTOMER_NAME <<< $($PSQL "SELECT customer_id, name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

        # If new customer
        if [[ -z $CUSTOMER_ID ]]
        then
            echo "I don't have a record for that phone number, what's your name?"
            read CUSTOMER_NAME

            # insert customer
            INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE');")

            CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        fi

        echo -e "\nWhat time would you like your $SELECTED_SERVICE_NAME, $CUSTOMER_NAME?"
        read SERVICE_TIME

        # appointment
        APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

        echo "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


    fi
}

MAIN_MENU "Welcome to My Salon, how can I help you?\n"