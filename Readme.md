## 1 What is PostgreSQL?
PostgreSQL হলো একটি পাওয়ারফুল, ওপেন-সোর্স রিলেশনাল ডাটাবেজ ম্যানেজমেন্ট সিস্টেম (RDBMS), যার মাধ্যমে ডাটা সংরক্ষণ, ম্যানেজ এবং রিট্রিভ করা যায়।

এখানে ডাটাগুলো রো (row) এবং কলাম (column) ভিত্তিক টেবিলে সংগঠিত থাকে এবং ডাটার ম্যানিপুলেশন করা হয় SQL (Structured Query Language) ব্যবহার করে।

PostgreSQL-এর বৈশিষ্ট্যসমূহ:
- Open-source এবং Completely free

- ACID Compliant — ডাটা নিরাপদ ও নির্ভরযোগ্য

- Advanced SQL Support — কমপ্লেক্স কুয়েরি, জয়েন, সাব-কুয়েরি ইত্যাদি

- JSON Support — স্ট্রাকচারড ও আনস্ট্রাকচারড ডাটা স্টোর করা যায়

- Extensibility — নিজের ফাংশন, ডেটা টাইপ বা অপারেটর ডিফাইন করা যায়

## 2 Explain the Primary Key and Foreign Key concepts in PostgreSQL.

 Primary Key (প্রাইমারি কি) কী?
Primary Key হলো একটি টেবিলের এমন একটি কলাম (বা কলামসমূহ), যেটা প্রতিটি রেকর্ডকে ইউনিকভাবে চিহ্নিত করে।

এই কী এর ভ্যালু কখনো null বা ডুপ্লিকেট হতে পারে না।

এক টেবিলে শুধুমাত্র একটি প্রাইমারি কি থাকতে পারে।

 উদাহরণ:

```sql
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region TEXT
);
```
এখানে renger_id হলো প্রাইমারি কি, যার মাধ্যমে প্রতিটি স্টুডেন্টকে আলাদা করে চেনা যায়।

Foreign Key (ফরেন কি) কী?
Foreign Key হলো এমন একটি কলাম, যা অন্য একটি টেবিলের Primary Key-এর সাথে সম্পর্ক তৈরি করে।

এটি মূলত দুইটি টেবিলের মধ্যে relationship বা link তৈরি করে।

ফরেন কি ব্যবহারের ফলে ডাটার integrity ও consistency নিশ্চিত করা যায়।

 উদাহরণ:

```sql
CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    sighting_time TIMESTAMP,
    location TEXT,
    notes TEXT
);
```
এখানে ranger_id হলো ফরেন কি, যা rangers টেবিলের ranger_id এর সাথে কানেক্টেড। 

## 3 What is the significance of the JOIN operation, and how does it work in PostgreSQL?

JOIN অপারেশনের গুরুত্ব (Significance of JOIN):
JOIN হলো একটি SQL অপারেশন যা ব্যবহার করা হয় একাধিক টেবিলের ডেটাকে একসাথে যুক্ত করে রিলেশন তৈরির জন্য।
এটি তখন প্রয়োজন হয় যখন আমরা এমন একটি কুয়েরি করতে চাই যেখানে ভিন্ন ভিন্ন টেবিল থেকে সম্পর্কযুক্ত ডেটা আনতে হয়।

🧠 PostgreSQL-এ JOIN কীভাবে কাজ করে?
PostgreSQL-এ JOIN অপারেশন দুই বা ততোধিক টেবিলকে কোমন কলাম বা রিলেশনশিপের ভিত্তিতে যুক্ত করে।
JOIN অপারেশনের মাধ্যমে আমরা একাধিক টেবিল থেকে একসাথে তথ্য আনতে পারি, যেমন:

```sql

SELECT 
  employees.name, departments.department_name
FROM 
  employees
JOIN 
  departments ON employees.department_id = departments.id;
  ```
উপরের কুয়েরিতে, employees এবং departments টেবিল দুটিকে department_id কলামের মাধ্যমে যুক্ত করা হয়েছে।

- JOIN-এর প্রকারভেদ (Types of JOIN):
JOIN টাইপ	ব্যাখ্যা
INNER JOIN	কেবল তখনই রেজাল্ট দেয় যখন দুই টেবিলেই ম্যাচিং ডেটা থাকে
LEFT JOIN	বাম পাশের টেবিলের সব ডেটা, আর ডান পাশে যদি না মেলে তাহলে NULL
RIGHT JOIN	ডান পাশের টেবিলের সব ডেটা, আর বাম পাশে না মেলে তাহলে NULL
FULL JOIN	দুই টেবিলের সব ডেটা, মিলে বা না মিলে—NULL দিয়ে পূরণ করে
CROSS JOIN	দুই টেবিলের প্রতিটি রো একে অপরের সাথে কম্বিনেশন করে (কার্টেসিয়ান প্রোডাক্ট)

## 4 What are the LIMIT and OFFSET clauses used for?
 LIMIT এবং OFFSET কী?
LIMIT এবং OFFSET হলো SQL-এর দুটি ক্লজ (clause) — যা মূলত pagination বা পৃষ্ঠায় বিভক্ত করে ডেটা দেখানোর জন্য ব্যবহার করা হয়।

 LIMIT কী করে?
LIMIT নির্ধারণ করে — একটি কুয়েরি চালানোর পর সর্বোচ্চ কতটি রো (row) রিটার্ন হবে।

 উদাহরণ:
```sql

SELECT * FROM users LIMIT 5;

```
এই কুয়েরি users টেবিল থেকে সর্বোচ্চ ৫টি রো রিটার্ন করবে।
 OFFSET কী করে?
OFFSET দিয়ে আমরা বলতে পারি — শুরুর দিকে কতটি রো স্কিপ করে তারপর ডেটা দেখাবে।

 উদাহরণ:
```sql
SELECT * FROM users LIMIT 5 OFFSET 10;
```
এই কুয়েরি users টেবিল থেকে প্রথম ১০টি রো বাদ দিয়ে পরবর্তী ৫টি রো রিটার্ন করবে।

## 5 Explain the GROUP BY clause and its role in aggregation operations.

Aggregate Functions in PostgreSQL
COUNT()  কতটি রেকর্ড আছে তা গুনে
```sql


SELECT COUNT(*) FROM orders;
```
 এটি orders টেবিলে মোট কতটি রো আছে তা দেখাবে।

2️ SUM()  সব মানের যোগফল বের করে
```sql


SELECT SUM(amount) FROM orders;
```
 এটি amount কলামের সব মান যোগ করে মোট টাকা দেখাবে।

3️ AVG()  গড় (average) হিসাব করে
```sql


SELECT AVG(amount) FROM orders;
```
 এটি amount কলামের গড় মান দেখাবে (সব মানের যোগফল ÷ মোট রো সংখ্যা)।

 একসাথে গ্রুপ করে অ্যাগ্রিগেশন:
তুমি যদি প্রতিটি গ্রাহক অনুযায়ী মোট, গড় বা সংখ্যা জানতে চাও, তাহলে GROUP BY এর সাথে ব্যবহার করো।

উদাহরণ:
```sql
SELECT customer, COUNT(*) AS total_orders,
       SUM(amount) AS total_amount,
       AVG(amount) AS average_amount
FROM orders
GROUP BY customer;
```
🟢 এই কুয়েরি দেখাবে:

প্রতিটি customer কতটি অর্ডার দিয়েছে,

কত টাকা অর্ডার করেছে মোট,

এবং গড় অর্ডার কত ছিল।


