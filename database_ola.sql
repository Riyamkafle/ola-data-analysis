create Database Ola;
use Ola;


-- 1. Retrieve all successful bookings:

create View Successful_Bookings As
Select * from bookings
where Booking_Status = 'Success';
SELECT * FROM Successful_Bookings; -- to see the output as a grid view we have to run this command {SELECT * FROM Successful_Bookings;}

-- 2. Find the average ride distance for each vehicle type:
create view  Ride_Distance_For_Each_Vehicle_Type as
Select Vehicle_Type, AVG(Ride_Distance)
As avg_distance from bookings 
group by Vehicle_Type; 

-- 3. Get the total number of cancelled rides by customers:
create view number_of_cancelled_ides_by_customers AS
select  Vehicle_Type, count(*) AS Canceled_Count from bookings where Booking_status='Canceled by Customer'
group by Vehicle_Type
UNION ALL 
select 'total' as vehicle_Type, count(*) AS Canceled_Count from bookings
where Booking_Status = 'Canceled by Customer' ;


-- 4. List the top 5 customers who booked the highest number of rides:
create View Top_5_Customers as 
select Customer_ID, 
count(Booking_ID) AS Tottal_Rides,
max(Date) AS Fisrt_Bookings,
min(Date) AS Last_Bookings
from bookings 
group by Customer_ID
order by Tottal_Rides desc
LIMIT 5;
select  * from Top_5_Customers;

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
create View Rides_cancelled_by_drivers_P_C_ISSUES as
select Canceled_Rides_by_Driver AS Cancellation_Reason,
count(*) AS Tottal_Cancellations 
from bookings
where Canceled_Rides_by_Driver is not null 
group by Canceled_Rides_by_Driver 
order by Tottal_Cancellations desc ; 

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
create view MAX_MIN_DRIVER_RATINGS as
select  Vehicle_Type,
max(Driver_Ratings) AS max_Ratings, 
MIN(Driver_Ratings) AS Min_Ratings
from bookings
group by Vehicle_Type
order by Vehicle_Type DESC ;

-- 7. Retrieve all rides where payment was made using UPI:
Create View all_rides_payement as
SELECT 
    Payment_Method,
    COUNT(*) AS Total_Used,
    ROUND(
        (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings)),
        2
    ) AS Percentage_Used
FROM bookings
GROUP BY Payment_Method;

-- 8. Find the average customer rating per vehicle type:
create View average_customer_rating as
select Vehicle_Type,
round(avg(Customer_Rating), 2) AS Average_Rating
from bookings
group by Vehicle_Type
order by Average_Rating desc;

-- 9. Calculate the total booking value of rides completed successfully:
Create View rides_completed_Sucessfully as 
select Booking_Status,
count(*) as Successfully_Booked 
from bookings
where Booking_Status = 'Success';

-- 10. List all incomplete rides along with the reason:
create View Incomplete_rides_with_reasons as 
SELECT 
    Booking_ID,
    COALESCE(Incomplete_Rides_Reason, 'No Reason Provided') AS Reason,
    COUNT(*) OVER (PARTITION BY Incomplete_Rides_Reason) AS Number_of_Rides
FROM 
    bookings
WHERE 
    Incomplete_Rides = 'yes'
ORDER BY 
    Number_of_Rides DESC;
