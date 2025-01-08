# Credit Card Financial Dashboard

## Table of Contents
1. [Introduction](#introduction)
2. [Dashboards Overview](#dashboards-overview)
   - [Credit Card Transaction Report](#credit-card-transaction-report)
   - [Credit Card Customer Report](#credit-card-customer-report)
3. [DAX Queries](#dax-queries)

---

## Introduction
The Credit Card Financial Dashboard project showcases comprehensive insights into credit card transactions and customer behaviors. It consists of two distinct dashboards, each focused on different aspects of financial and customer data.

---

## Dashboards Overview

### Credit Card Transaction Report
This dashboard provides insights into the revenue generated through various transaction aspects with weekly slicing capabilities. Key components include:

#### Visualizations:
1. **Bar Charts**:
   - Revenue by Expenditure Type
   - Revenue by Customer Education
   - Revenue by Customer Job
   - Revenue by Card Type
   - Revenue by Usage (Swipe, Online, Chip)

2. **Line and Column Chart**:
   - Quarterly Revenue (Column)
   - Transactional Count (Line)

3. **Matrix**:
   - Total Revenue, Total Interest Earned, and Total Annual Fees against Card Category/Type

4. **Cards**:
   - Total Revenue
   - Total Interest Earned
   - Total Transaction Amount
   - Transaction Count

#### Slicers:
- Quarters
- Week Start Date
- Gender
- Customer Income Type (Low, Medium, High)
- Card Type

---

### Credit Card Customer Report
This dashboard focuses on revenue generation by gender, with a distinct color scheme for male and female categories. Key components include:

#### Visualizations:
1. **Stacked Bar Charts**:
   - Revenue by Income Type by Gender
   - Revenue by Customer Education Level by Gender
   - Revenue by Customer Marital Status by Gender
   - Revenue by Dependent Count by Gender
   - Revenue by Age Group by Gender
   - Revenue by States by Gender

2. **Line Chart**:
   - Revenue by Gender

3. **Matrix**:
   - Total Revenue, Total Transaction Amount, and Income against Customer Job

4. **Cards**:
   - Total Revenue
   - Total Interest
   - Total Income
   - CSS (Customer Satisfaction Score - Average)

#### Slicers:
- Quarters
- Week Start Date
- Gender
- Customer Income Type (Low, Medium, High)
- Card Type

---

## DAX Queries

### Previous Week Revenue
```DAX
Previous_week_revenue = CALCULATE(
    SUM(credit_card[Revenue]),
    FILTER(
        ALL(credit_card), credit_card[weeknum] = MAX(credit_card[weeknum]) -1
    )
)

### Current Week Revenue
```DAX
Current_week_revenue = CALCULATE(
    SUM(credit_card[Revenue]),
    FILTER(
        ALL(credit_card), credit_card[weeknum] = MAX(credit_card[weeknum])
    )
)

### Week Over Week Revenue
```DAX
WOW_Revenue = DIVIDE(
    ([Current_week_revenue] - [Previous_week_revenue]), 
    [Previous_week_revenue]
)

### Week Over Week Revenue
```DAX
AgeGroup = SWITCH(TRUE(),
    customer[Customer_Age] < 30, "20-30",
    customer[Customer_Age] >= 30 && customer[Customer_Age] < 40, "30-40",
    customer[Customer_Age] >= 40 && customer[Customer_Age] < 50, "40-50",
    customer[Customer_Age] >= 50 && customer[Customer_Age] < 60, "50-60",
    customer[Customer_Age] >= 60, "60+",
    "unknown"
)

### Income Group
```DAX
Income_Group = SWITCH(TRUE(),
    customer[Income] < 35000, "Low",
    customer[Income] >= 35000 && customer[Income] < 70000, "Medium",
    customer[Income] >= 70000, "High",
    "unknown"
)



