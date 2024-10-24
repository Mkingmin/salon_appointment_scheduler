#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
    echo -e "Welcome to My Salon, how can I help you?\n"

    echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
    1) PRC cut;;
    2) PRC color;;
    3) PRC perm;;
    4) PRC style;;
    5) PRC trim;;
    *) MAIN_MENU ;;
    esac
}

PRC() {
    SERVICE=$1
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$SERVICE'")

    #get phone number
    echo -e "\n What's your phone number?"
    read CUSTOMER_PHONE
    GET_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #check phone against records
    #if no record ask for name
    if [[ -z $GET_CUSTOMER_NAME ]]; then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers (name , phone) VALUES ('$CUSTOMER_NAME' , '$CUSTOMER_PHONE')")
        echo -e "\nWhat time would you like your $(echo $SERVICE | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
        read SERVICE_TIME
        #get custmer id
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        #insert appointment (for cut)
        INSERT_APPOINTMENT_CUT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
        #message to confirm apt type and time
        echo -e "\nI have put you down for a $(echo $SERVICE | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."

    else
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
        echo -e "\nWhat time would you like your $(echo $SERVICE | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
        read SERVICE_TIME
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        INSERT_APPOINTMENT_CUT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
        echo -e "\nI have put you down for a $(echo $SERVICE | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."

    fi

}

MAIN_MENU