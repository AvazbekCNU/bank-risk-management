CREATE DATABASE risk_management;
USE risk_management;
select * from Customers;
select * from Transactions;
select * from Risk_Events;

-- High Loan Amount & Low Credit Score
SELECT customer_id, name, credit_score, loan_amount, loan_status
FROM Customers
WHERE credit_score < 600 AND loan_amount > 10000
ORDER BY loan_amount DESC;

-- flagged transactions
SELECT t.transaction_id, t.customer_id, c.name, t.amount, t.transaction_date
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
WHERE t.fraud_flag = 1
ORDER BY t.amount DESC;

-- High Impact, Unresolved Risk Events
SELECT event_id, event_type, impact_amount, event_date
FROM Risk_Events
WHERE risk_category = 'Operational' AND resolved = 0
ORDER BY impact_amount DESC;

-- Total Transactions and Fraud Count
SELECT c.customer_id, c.name, COUNT(t.transaction_id) AS total_transactions,
       SUM(t.fraud_flag) AS fraud_count
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
ORDER BY fraud_count DESC;

-- Percentage of Resolved Risk Events
SELECT risk_category,
       COUNT(CASE WHEN resolved = 1 THEN 1 END) AS resolved_events,
       COUNT(*) AS total_events,
       ROUND((COUNT(CASE WHEN resolved = 1 THEN 1 END) / COUNT(*)) * 100, 2) AS resolution_rate
FROM Risk_Events
GROUP BY risk_category;


