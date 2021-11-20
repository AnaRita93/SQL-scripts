'''
TESTDOME SQL Regional Sales Comparison 

https://www.testdome.com/questions/sql/regional-sales-comparison/36141

Management requires a comparative region sales analysis report. Write a query that returns:
- The region name.
- Average sales per employee for the region (Average sales = Total sales made for the region / Number of employees in the region).
- The difference between the average sales of the region with the highest average sales, and the average sales per employee for the region (average sales to be calculated as explained above).
A region with no sales should be also returned. Use 0 for average sales per employee for such a region when calculating the 2nd and the 3rd column.

'''

with avg_table as(
  
SELECT regions.name
     
  --   , SUM(sales.amount)*1.00/NULLIF(COUNT(employees.id),0) as average
  
     , CASE WHEN SUM(IFNULL(sales.amount,0)) = 0 THEN 0
                            
            ELSE SUM(IFNULL(sales.amount,0))*1.00/COUNT(DISTINCT employees.id)
  
            END as average
             
     
FROM regions

LEFT JOIN states ON regions.id = states.regionId
                            
LEFT JOIN employees ON states.id = employees.stateId

LEFT JOIN sales ON sales.employeeId = employees.id
           

GROUP BY regions.name )

, max_avg as (SELECT max(average) as max FROM avg_table)
                     

SELECT avg_table.name
                     
     , avg_table.average
                     
     , max_avg.max - avg_table.average as difference

FROM avg_table, max_avg

ORDER BY average DESC;

