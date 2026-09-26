# Smart Fitness Centre Database (MySQL)

A relational database for a fitness centre, built for a second-year Data and Distributed Systems module. Many gyms still manage memberships, trainer schedules, diet plans and payments with separate records, which leads to errors and missed renewals. This project brings all of that into one structured MySQL database, with role-based access so trainers and members only see the data they need.

## Requirements
**Functional**
- Register and manage member details
- Store trainer details and experience, and assign trainers to members
- Record the fitness plans each member follows (monthly and annual memberships)
- Record training sessions and personalised nutrition plans
- Record payments and their status, and support reporting queries

**Non-functional**
- Data integrity through constraints (PK, FK, NOT NULL, CHECK)
- Fast retrieval of member information
- Able to grow with more members, trainers and plans
- Restricted access to data through user roles

## Design process
1. Gathered requirements for a typical fitness centre
2. Identified entities and relationships and drew an ER diagram
3. Normalised the data from UNF through 1NF and 2NF to **3NF** (for example, splitting members and plans into a separate `MemberPlan` table)
4. Implemented and tested the schema in **MySQL Workbench**

## ER diagram
```mermaid
erDiagram
    TRAINER ||--o{ MEMBER : "trains"
    TRAINER ||--o{ SESSION : "runs"
    MEMBER ||--o{ SESSION : "attends"
    MEMBER ||--o{ MEMBERPLAN : "follows"
    PLAN ||--o{ MEMBERPLAN : "is assigned in"
    MEMBER ||--o{ NUTRITION : "has"
    MEMBER ||--o{ PAYMENT : "makes"

    TRAINER {
        varchar TrainerID PK
        varchar TrainerName
        int Experience
        varchar TrainerContact
        date TrainerJoinDate
    }
    MEMBER {
        varchar MemberID PK
        varchar MemberName
        int Age
        char Gender
        varchar MemberContact
        varchar MembershipType
        date JoinDate
        varchar TrainerID FK
    }
    PLAN {
        varchar PlanID PK
        varchar PlanName
        decimal Price
    }
    MEMBERPLAN {
        varchar MemberPlanID PK
        varchar MemberID FK
        varchar PlanID FK
    }
    SESSION {
        varchar SessionID PK
        varchar MemberID FK
        varchar TrainerID FK
        date SessionDate
        varchar SessionType
    }
    NUTRITION {
        varchar NutritionPlanID PK
        varchar MemberID FK
        varchar DietDetails
        date StartDate
        date EndDate
    }
    PAYMENT {
        varchar PaymentID PK
        varchar MemberID FK
        decimal Amount
        varchar Method
        date PayDate
        varchar PayStatus
    }
```

## Constraints
Primary and foreign keys on every table, `NOT NULL` on all required fields, and `CHECK` rules: price and payment amount must be positive, age must be over 12, and gender is limited to M, F or O.

## Security – role-based access control
| Role | Can read | Demo user |
|---|---|---|
| `trainer_role` | Members, sessions, nutrition plans | `trainer1` |
| `member_role` | Payments, plans, member plans, sessions, trainers | `member1` |

## Example queries
The script includes queries for each role, using `JOIN`s:
- **Trainer:** their assigned members, their sessions, and their members' nutrition plans
- **Member:** their payment history, their plans and prices, their sessions, and their trainer's details

## How to run
Requires **MySQL 8.0.16+** (for roles and `CHECK` constraints). Open `smart_fitness_db.sql` in MySQL Workbench and run the whole script, or:
```bash
mysql -u root -p < smart_fitness_db.sql
```

## Future improvements
- Add an `Equipment` table to track machines and maintenance schedules
- Add session times and trainer specialisations
- Make contact numbers `UNIQUE` and add an administrator role with full access

## Tech stack
MySQL 8, MySQL Workbench, SQL (DDL, DML, JOINs, roles and privileges)
