Document
===

# Index
- [Call class to generate instance](#call-class-to-generate-instance)
- [SOQL Construction Method (Get records)](#sql-construction-method)
    - [SELECT Construction Method](#select-construction-method)
    - [WHERE Construction Method](#where-construction-method)
    - [OR WHERE Construction Method](#or-where-construction-method)
    - [LIKE Construction Method](#like-construction-method)
    - [OR LIKE Construction Method](#or-like-construction-method)
    - [NOT LIKE Construction Method](#not-like-construction-method)
    - [OR NOT LIKE Construction Method](#or-not-like-construction-method)
    - [WHERE IN Construction Method](#where-in-construction-method)
    - [WHERE NOT IN Construction Method](#where-not-in-construction-method)
    - [LIMIT Construction Method](#limit-construction-method)
    - [OFFSET Construction Method](#offset-construction-method)
    - [ORDER BY Construction Method](#order-by-construction-method)
    - [GROUP BY Construction Method](#group-by-construction-method)
    - [HAVING Construction Method](#having-construction-method)
    - [SOQL Construction Cache Method](#sql-construction-cache-method)
    - [SOQL Construction Initialize Method](#sql-construction-initialize-method)
    - [★Execute Query By SOQL Construction Method](#execute-query-by-sql-construction-method)
    - [★Generate Query By SOQL Construction Method](#generate-query-by-sql-construction-method)
- [DML Operation Method (Operate records)](#dml-operation-method)
    - [Insert Handling Method](#insert-handling-method)
    - [Insert All Handling Method](#insert-all-handling-method)
    - [Update Handling Method](#update-handling-method)
    - [Update All Handling Method](#update-all-handling-method)
    - [Upsert Handling Method](#upsert-handling-method)
    - [Delete Handling Method](#delete-handling-method)

# Call class to generate instance
```apex
SOQLBuilder bld = new SOQLBuilder(); // Any variable names is possible, "bld" on this case here
```

# SOQL Construction Method
Variety of methods can be used after generating the class instance, which are generically named as the "SOQL Construction Method" here.  
Those methods are used for getting records from sObject.

## SELECT Construction Method
```apex
bld.soqlSelect(fieldName);
```

Example for use
```apex
bld.soqlSelect('Id, Name, IsActive');

// or in another way,

bld.soqlSelect('Id');
bld.soqlSelect('Name');
bld.soqlSelect('IsActive');

// The following SELECT clause will be reserved for its generation when the method is called like above.
// SELECT Id, Name, IsActive
```

## WHERE Construction Method
```apex
bld.soqlWhere(fieldName, fieldValue);
```

Example for use - 1
```apex
bld.soqlWhere('Id', '00s4h00000216cCDXW');

// The following WHERE clause will be reserved for its generation when the method is called like above.
// WHERE Id = '00s4h00000216cCDXW'
```

```apex
bld.soqlWhere('Id !=', '00s4h00000216cCDXW');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// WHERE Id != '00s4h00000216cCDXW'
```

Example for use - 2
```apex
bld.soqlWhere('Name', 'Mikoto Misaka');
bld.soqlWhere('IsActive', true);

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name = 'Mikoto Misaka' AND IsActive = true
```

## OR WHERE Construction Method
```apex
bld.soqlOrWhere(fieldName, fieldValue);
```

Example for use
```
bld.soqlWhere('Name', 'Mikoto Misaka');
bld.soqlOrWhere('IsActive', false);
bld.soqlOrWhere('Email !=', 'kuroko.shirai@tokiwa.ac.jp');

// WHERE Name = 'Mikoto Misaka' OR IsActive = false OR Email != 'kuroko.shirai@tokiwa.ac.jp'
```

## LIKE Construction Method
```apex
bld.soqlLike(fieldName, fieldValue);
```

Example for use - 1
```apex
bld.soqlLike('Name', '%Misaka%');

// The following LIKE clause will be reserved for its generation when the method is called like above.
// WHERE Name LIKE %Misaka%;
```

Example for use - 2
```apex
bld.soqlLike('Name', '%Misaka%');
bld.soqlLike('Name', '%koto%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name LIKE %Misaka% AND LIKE %koto%;
```

## OR LIKE Construction Method
```apex
bld.soqlOrLike(fieldName, fieldValue);
```

Example for use
```apex
bld.soqlLike('Name', '%Misaka%');
bld.soqlOrLike('Name', '%koto%');

// WHERE Name LIKE %Misaka% OR LIKE %koto%;
```

## NOT LIKE Construction Method
```apex
bld.soqlNotLike(fieldName, fieldValue);
```

Example for use - 1
```apex
bld.soqlNotLike('Name', '%Shirai%');

// The following NOT LIKE clause will be reserved for its generation when the method is called like above.
// WHERE NOT Name LIKE %Shirai%;
```

Example for use - 2
```apex
bld.soqlNotLike('Name', '%Shirai%');
bld.soqlNotLike('Name', '%Kuro%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE (NOT Name LIKE %Shirai%) AND (NOT LIKE %Kuro%);
```

## OR NOT LIKE Construction Method
```apex
bld.soqlOrNotLike(fieldName, fieldValue);
```

Example for use
```apex
bld.soqlLike('Name', '%Misaka%');
bld.soqlOrNotLike('Name', '%Shirai%');

// WHERE Name LIKE %Misaka% OR (NOT LIKE %Shirai%);
```

## WHERE IN Construction Method
```apex
bld.soqlWhereIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
bld.soqlWhereIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
bld.soqlWhereIn('Id', param);

// The following WHERE IN clause will be reserved for its generation when the method is called like above.
// WHERE Id IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## WHERE NOT IN Construction Method
```apex
bld.soqlWhereNotIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
bld.soqlWhereNotIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
bld.soqlWhereNotIn('Id', param);

// The following WHERE NOT IN clause will be reserved for its generation when the method is called like above.
// WHERE Id NOT IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## LIMIT Construction Method
```apex
bld.soqlLimit(limitValue);
```

Example for use
```apex
bld.soqlLimit(300);

// The following LIMIT clause will be reserved for its generation when the method is called like above.
// LIMIT 300
```

## OFFSET Construction Method
```apex
bld.soqlOffset(offsetValue);
```

```apex
bld.soqlOffset(100);

// The following OFFSET clause will be reserved for its generation when the method is called like above.
// OFFSET 100
```

## ORDER BY Construction Method
```apex
bld.soqlOrderBy(fieldName, sortCondition);
```

Example for use
```apex
bld.soqlOrderBy('Name', 'DESC');
bld.soqlOrderBy('Id', 'ASC');

// The following OEDER BY clause will be reserved for its generation when the method is called like above.
// ORDER BY Name DESC, Id ASC
```

## GROUP BY Construction Method
```apex
bld.soqlGroupBy(fieldName);
```

Example for use - 1
```apex
bld.soqlGroupBy('Name');
bld.soqlGroupBy('IsActive');

// The following GROUP BY clause will be reserved for its generation when the method is called like above.
// GROUP BY Name, IsActive;
```

Example for use - 2
```apex
bld.soqlSelect('COUNT(Id), IsActive');
bld.soqlGroupBy('IsActive');
List<AggregateResult> userGroup = bld.soqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), IsActive FROM User GROUP BY IsActive];
```

## HAVING Construction Method
```apex
bld.soqlHaving(fieldName, fieldValue);
```

Example for use - 1
```apex
bld.soqlHaving('COUNT(Id)', 3);

// The following HAVING clause will be reserved for its generation when the method is called like above.
// HAVING COUNT(Id) = 3
```

```apex
bld.soqlHaving('Name LIKE', '%Misaka%');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// HAVING Name LIKE '%Misaka%'
```

Example for use - 2
```apex
bld.soqlHaving('COUNT(Id) >', 3);
bld.soqlHaving('Name LIKE', '%Misaka%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// HAVING COUNT(Id) > 3 AND Name = '%Misaka%'
```

Example for use - 3
```apex
bld.soqlSelect('COUNT(Id), Name, IsActive');
bld.soqlGroupBy('IsActive');
bld.soqlHaving('COUNT(Id) >', 3);
bld.soqlHaving('Name LIKE', '%Misaka%');
List<AggregateResult> userGroup = bld.soqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), Name, IsActive FROM User GROUP BY IsActive HAVING COUNT(Id) > 3 AND Name = '%Misaka%'];
```

## ALL ROWS Construction Method
```apex
bld.soqlAllRows();
```

Example for use
```apex
bld.soqlAllRows();
bld.soqlSelect('Id, Name, IsDeleted');
bld.soqlWhere('IsDeleted', true);
List<User> userList = bld.soqlGet('User');

// The method call like above is exactly the same thing as following.
// List<User> userList = [SELECT Id, Name, IsDeleted FROM User WHERE IsDeleted = true ALL ROWS];
```

## SOQL Construction Cache Method
```apex
bld.soqlStartCache();
```
Feature of SOQL Construction Method can be switched to keep query from initializing even after it is called by sqlGet or sqlQuery method.  
Please call clear method to reset this feature and initialze query.

Example for use
```apex
bld.soqlStartCache(); // Start keeping query cache

bld.soqlSelect('Id, Name');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

bld.soqlSelect('IsActive');
bld.soqlWhere('IsActive', true);
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive = true];

bld.clear(); // Reset and initialize here

bld.soqlSelect('IsDeleted');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT IsDeleted FROM User];
```

## SOQL Construction Initialize Method
```apex
bld.clear();
```
Reset query and initialize all features of SOQL Construction methods.  
This method is also called in the constructor.  
Generally, please use this method with sqlStartCache method.  

Example for use
```apex
bld.soqlStartCache(); // Start keeping query cache

bld.soqlSelect('Id, Name');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

bld.clear(); // Reset and initialize here

bld.soqlSelect('IsDeleted');
List<Account> accList = bld.soqlGet('Account'); // List<Account> accList = [SELECT IsDeleted FROM Account];
```

## ★Execute Query By SOQL Construction Method
The SOQL Construction Method is only to reserve for generation of query, and the constructed query by the method is not executed on its own.  
This sqlGet method just executes the query by the SOQL Construction Method and returns the list of sObject records.

```apex
bld.soqlGet(sObjectName);
```

Example for use
```apex
List<Account> accList = bld.soqlGet('Account');

// The method call like above is exactly the same thing as following.
// The "*" is only a literal expression for the example, and actual query selects all fields of a sObjects.
// List<Account> queryList = [SELECT * FROM Account];
```

## ★Generate Query By SOQL Construction Method
As is the same with the sqlGet method, this sqlQuery method just generates query by the SOQL Construction Method and returns generated query itself of STRING type.  
NOTE: This method does not execute query!

```apex
bld.soqlQuery(sObjectName);
```

Example for use
```apex
bld.soqlSelect('Id, Name');
bld.soqlWhere('NumberOfEmployees >', 100);
String query = bld.soqlQuery('Account');

// The method call like above is exactly the same thing as following.
// String query = 'SELECT Id, Name FROM Account WHERE NumberOfEmployees > 100';
```

# DML Operation Method
Those following methods is used for DML operations of sObject record.

## Insert Handling Method
```apex
bld.soqlInsert(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

Account acc = new Account();

params.put('Name', 'Misaka10091');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 10091);

result = bld.soqlInsert(acc, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = bld.soqlInsert(acc, params);

if ((Boolean)result.get('success')) {
    // Some process

} else {
    Exception e = (Exception)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

## Insert All Handling Method
Handling bulk insert is possible also by sqlInsert method above, but this sqlInsertAll method can complete the DML operation for the rest of sObject records even if some fail. The feature of this method utilizes "Database.insert()" method with the 2nd argument assigned false.

```apex
bld.soqlInsertAll(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
List<Database.SaveResult> srList = new List<Database.SaveResult>();

List<Account> accList = new List<Account>();
for (Integer i = 0; i < 10; i++) {
    accList.add(new Account());
}

params.put('Name', 'Misaka10091');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 10091);

srList = bld.soqlInsertAll(accList, params);
```

Example for use - 2
```apex
srList = bld.soqlInsertAll(acc, params);

for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Some process

    } else {
        for(Database.Error err : sr.getErrors()) {
            System.debug(err.getMessage());
            System.debug(err.getStatusCode());
            System.debug(err.getFields());
        }
    }
}
```

## Update Handling Method
```apex
bld.soqlUpdate(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

bld.soqlSelect('Id');
List<Account> accList = bld.soqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

result = bld.soqlUpdate(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = bld.soqlUpdate(acc, params);

if ((Boolean)result.get('success')) {
    // Some process

} else {
    Exception e = (Exception)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

## Update All Handling Method
Handling bulk update is possible also by sqlUpdate method above, but this sqlUpdateAll method can complete the DML operation for the rest of sObject records even if some fail. The feature of this method utilizes "Database.update()" method with the 2nd argument assigned false.

```apex
bld.soqlUpdateAll(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
List<Database.SaveResult> srList = new List<Database.SaveResult>();

bld.soqlSelect('Id');
List<Account> accList = bld.soqlGet('Account');

params.put('Name', 'Misaka10091');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 10091);

srList = bld.soqlUpdateAll(accList, params);
```

Example for use - 2
```apex
srList = bld.soqlUpdateAll(acc, params);

for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Some process

    } else {
        for(Database.Error err : sr.getErrors()) {
            System.debug(err.getMessage());
            System.debug(err.getStatusCode());
            System.debug(err.getFields());
        }
    }
}
```

## Upsert Handling Method
```apex
bld.soqlUpsert(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

bld.soqlSelect('Id');
List<Account> accList = bld.soqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
accList.add(newAcc);

result = bld.soqlUpsert(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = bld.soqlUpsert(acc, params);

if ((Boolean)result.get('success')) {
    // Some process

} else {
    Exception e = (Exception)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

## Delete Handling Method
```apex
bld.soqlDelete(sObjectCollection);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|

Example for use - 1
```apexapex
Map<String, Object> result = new Map<String, Object>{};

bld.soqlSelect('Id');
List<Account> accList = bld.soqlGet('Account');

result = bld.soqlDelete(accList);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = bld.soqlDelete(acc);

if ((Boolean)result.get('success')) {
    // Some process

} else {
    Exception e = (Exception)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

# Reuse of the SOQL Construction Method
There are two ways to use those methods more than once at one transaction.

## 1. Generate new instance every time getting sObject records.
```apex
SOQLBuilder mdl_1 = new SOQLBuilder(); // mdl_1 to generate new instance
mdl_1.sqlSelect('Id, Name');
List<User> user = mdl_1.sqlGet('User');

SOQLBuilder mdl_2 = new SOQLBuilder(); // mdl_2 to generate new instance
mdl_2.sqlSelect('Id, Name');
mdl_2.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl_2.sqlGet('Account');

SOQLBuilder mdl_3 = new SOQLBuilder(); // mdl_3 to generate new instance
mdl_3.sqlSelect('Id, Name');
mdl_3.sqlLimit(20);
List<Contact> con = mdl_3.sqlGet('Contact');
```

However, the way above is very useless because too many variables increase to manage them.  
The SOQL Construction Method basically initializes itself after sqlGet / sqlQuery method is called like below, and it is no need to regenerate new instance many times.

## 2. Query will be initialized after sqlGet / sqlQuery method is called
```apex
SOQLBuilder bld = new SOQLBuilder(); // bld to generate instance, only once here

bld.soqlSelect('Id, Name');
List<User> user = bld.soqlGet('User'); // Query is also initialized here

bld.soqlSelect('Id, Name');
bld.soqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = bld.soqlGet('Account'); // Query is also initialized here

bld.soqlSelect('Id, Name');
bld.soqlLimit(20);
List<Contact> con = bld.soqlGet('Contact'); // Query is also initialized here
```