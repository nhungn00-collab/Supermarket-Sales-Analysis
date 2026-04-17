CREATE DATABASE MARKET_SALES
--1.Liệt kê tổng doanh thu (Total Revenue = Unit Price * Quantity) theo từng chi nhánh và thành phố. Kết quả cần hiển thị Branch, City, Total Revenue.
select Branch, City, 
sum(Unit_price * [Quantity]) as 'Total Revenue'
from [dbo].[Dataset - supermarket_sales]
Group by [Branch], [City]
Order By [Branch], [City];

--2.Tìm 5 sản phẩm có tổng số lượng bán ra nhiều nhất. Kết quả cần hiển thị Product line, Total Quantity Sold
select TOP 5
Product_line,
SUM(Quantity) AS Total_Quantity_Sold
FROM [Dataset - supermarket_sales]
GROUP BY Product_line
ORDER BY Total_Quantity_Sold DESC;

--3.Tính tỷ lệ phần trăm doanh thu của từng phương thức thanh toán so với tổng doanh thu toàn bộ cửa hàng.
select Payment,
SUM(Unit_price * Quantity) AS Payment_Revenue,
ROUND(SUM(Unit_price * Quantity) * 100.0 /(SELECT SUM(Unit_price * Quantity) FROM [dbo].[Dataset - supermarket_sales]),2) AS Revenue_Percentage
FROM [dbo].[Dataset - supermarket_sales]
GROUP BY Payment;

--4.Xác định ngày có doanh thu cao nhất và thấp nhất trong toàn bộ dữ liệu. Hiển thị kết quả theo dạng Date, Total Revenue.
WITH DailyRevenue AS (
    SELECT
        [Date],
        SUM([Unit_price] * Quantity) AS Total_Revenue
    FROM [dbo].[Dataset - supermarket_sales]
    GROUP BY [Date]
)
SELECT
    [Date],
    Total_Revenue
FROM DailyRevenue
WHERE Total_Revenue = (SELECT MAX(Total_Revenue) FROM DailyRevenue)
   OR Total_Revenue = (SELECT MIN(Total_Revenue) FROM DailyRevenue)
ORDER BY Total_Revenue DESC;

--5.Tìm nhóm khách hàng có giá trị trung bình trên mỗi hóa đơn (Average Order Value = Total Revenue / Số lượng hóa đơn) cao nhất. Hiển thị Customer Type, Average Order Value.
WITH CustomerAOV AS (
    SELECT
        Customer_type,
        SUM(Unit_price * Quantity) AS Total_Revenue,
        COUNT(DISTINCT Invoice_ID) AS Total_Invoices
    FROM [Dataset - supermarket_sales]
    GROUP BY Customer_type
)
SELECT TOP 1
    Customer_type,
    CAST(Total_Revenue / Total_Invoices AS DECIMAL(10,2)) AS Average_Order_Value
FROM CustomerAOV
ORDER BY Average_Order_Value DESC;