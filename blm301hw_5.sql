#Q1A: Departmanı Research olan çalışanları listeleyen sorgu.
SELECT Fname,Lname,Address
FROM (EMPLOYEE JOIN DEPARTMENT ON Dno=Dnumber)
WHERE Dname='Research';

#Q1B: (mysql'de ve postgresql'de) çalışmadı
SELECT Fname, Lname, Address
FROM (EMPLOYEE NATURAL JOIN
(DEPARTMENT AS DEPT (Dname, Dno, Mssn, Msdate)))
WHERE Dname='Research';

#Q8B: Çalışanın ve çalışan kişinin super visor'ının soy ismini listeleyen sorgu
SELECT E.Lname AS Employee_name,
S.Lname AS Supervisor_name
FROM (EMPLOYEE AS E LEFT OUTER JOIN EMPLOYEE AS S
ON E.Super_ssn=S.Ssn);

#Q2A: Stafford ' da yürütülen projelerin Proje numarası,Departman Numarası,Departmanın müdürünün soyismi müdürün adresi ve doğum gününü listeleyen sorgu
SELECT Pnumber, Dnum, Lname, Address, Bdate
FROM ((PROJECT JOIN DEPARTMENT ON Dnum=Dnumber) JOIN EMPLOYEE ON Mgr_ssn=Ssn)
WHERE Plocation='Stafford';

#Q8C: Çalışanın ve çalışan kişinin super visor'ının soy ismini listeleyen sorgu (+= LEFT OUTER JOIN işlemini yapıyor mysql de ve postgresql de çalışmadı)
SELECT E.Lname, S.Lname
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.Super_ssn = S.Ssn;

#Q19: EMPLOYEE Tablosundaki çalışanların toplam maaşlarını,maximum maaşı,minimum maaşı ve ortalama maaşı listeleyen sorgu
SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary)
FROM EMPLOYEE;

#Q20: 'Research' Departmanındaki çalışanların toplam maaşlarını,maximum maaşı,minimum maaşı ve ortalama maaşı listeleyen sorgu
SELECT SUM(Salary), MAX(Salary), MIN(Salary), AVG(Salary)
FROM (EMPLOYEE JOIN DEPARTMENT ON Dno=Dnumber)
WHERE Dname='Research';

#Q21: EMPLOYEE Tablosundaki kayıt(çalışan) sayısı.
SELECT COUNT(*)
FROM EMPLOYEE;

#Q22: Research Departmanında çalışan kişi sayısı.
SELECT COUNT(*)
FROM EMPLOYEE, DEPARTMENT
WHERE DNO=DNUMBER AND DNAME='Research';

#Q23: EMPLOYEE Tablosundaki tekrar etmeyen(benzersiz) Salary kayıtlarının sayısını listeleyen sorgu.
SELECT COUNT(DISTINCT Salary)
FROM EMPLOYEE;

#Q5: En az 2 akrabaya sahip olan çalışanların soyismini ve ismini listeleyen sorgu.
SELECT Lname, Fname
FROM EMPLOYEE
WHERE ( SELECT COUNT(*)
FROM DEPENDENT
WHERE Ssn=Essn ) >= 2;

#Q24: Her departmanın numarasını, departmanda çalışan kişi sayısını ve departmandaki çalışanların ortalama maaşını listeleyen sorgu
SELECT Dno, COUNT(*), AVG(Salary)
FROM EMPLOYEE
GROUP BY Dno;

#Q25: Her projenin numarasını , ismini ve projede çalışan kişi saysını listeleyen sorgu
SELECT Pnumber, Pname, COUNT(*)
FROM PROJECT, WORKS_ON
WHERE Pnumber=Pno
GROUP BY Pnumber, Pname;

#Q26: 2'den fazla çalışanı olan projelerin numarasını ismini ve çalışan sayısını listeleyen sorgu
SELECT Pnumber, Pname, COUNT(*)
FROM PROJECT, WORKS_ON
WHERE Pnumber=Pno
GROUP BY Pnumber, Pname
HAVING COUNT(*) > 2;

#Q27: 5 numaralı departmanın katıldığı projelerin numarasını,ismini ve çalışan sayısını listeleyen sorgu
SELECT Pnumber, Pname, COUNT(*)
FROM PROJECT, WORKS_ON, EMPLOYEE
WHERE Pnumber=Pno AND Ssn=Essn AND Dno=5
GROUP BY Pnumber, Pname;

#Q28: Dnumber=Dno eşit ve O çalışanın Maaşı 40000 den büyükse ve employeede bir Dno numarasından en az 5 tane varsa toplam kaç kişinin 40000 den fazla maaş aldığını listleyen sorgu
#(HAVING COUNT(*)>3 derseniz 5 numaralı dno 4 tane olduğu için sorgu 2 tane 40000 den fazla maaş alan olduğunu döndürür (43000 ve 55000)
#Bu durumda hiç bir dno da 5 ten fazla çalışan olmadığı için aradada and operatörleri olduğu 2. and operatörünün sağ tarafındaki sorgu sağlanmadığından dolayı bir veri çıktısı alamayız
SELECT Dnumber, Count(*)
FROM DEPARTMENT, EMPLOYEE
WHERE Dnumber=Dno AND Salary>40000 AND
( SELECT Dno
FROM EMPLOYEE
GROUP BY Dno
HAVING COUNT(*) > 5);