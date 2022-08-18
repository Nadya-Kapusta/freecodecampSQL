#! /bin/bash

echo "Welcome to My Salon, how can I help you?
" 
count=$(psql --username=freecodecamp --dbname=salon -t -c "select count(*) from services")

for i in {1..5}
do
   echo "$i)" $(psql --username=freecodecamp --dbname=salon -t -c "select name from services where service_id = $i")
done
read SERVICE_ID_SELECTED

array=(1 2 3 4 5)

if [[ ! " ${array[*]} " =~ " ${SERVICE_ID_SELECTED} " ]]; then
   while  [[ ! " ${array[*]} " =~ " ${SERVICE_ID_SELECTED} " ]]
   do
      echo "I could not find that service. What would you like today?" 
      for i in {1..5}
      do
         echo "$i)" $(psql --username=freecodecamp --dbname=salon -t -c "select name from services where service_id = $i")
      done
      read SERVICE_ID_SELECTED
   done
fi

service_name=$(psql --username=freecodecamp --dbname=salon -t -c "select name from services where service_id = $SERVICE_ID_SELECTED")
echo ""

echo "What's your phone number?"
read CUSTOMER_PHONE

number_check=$(psql --username=freecodecamp --dbname=salon -t -c "select * from customers where phone = '$CUSTOMER_PHONE'")
if [ -z "$number_check"]; then 
   echo "I don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   psql --username=freecodecamp --dbname=salon -t -c "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
   echo "What time would you like your$service_name, $CUSTOMER_NAME?"
   read SERVICE_TIME
   
   cust_id=$(psql --username=freecodecamp --dbname=salon -t -c "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
   psql --username=freecodecamp --dbname=salon -t -c "insert into appointments (customer_id, service_id, time) values ('$cust_id', '$SERVICE_ID_SELECTED','$SERVICE_TIME')"
   echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
else 
   CUSTOMER_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "select name from customers where phone = '$CUSTOMER_PHONE'")
   echo "What time would you like your color, $CUSTOMER_NAME?"
   read SERVICE_TIME

   cust_id=$(psql --username=freecodecamp --dbname=salon -t -c "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
   psql --username=freecodecamp --dbname=salon -t -c "insert into appointments (customer_id, service_id, time) values ('$cust_id', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')"
   echo "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
fi

exit 0
