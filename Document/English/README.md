Document
===

Read the Sample of usage section first, and refer to others for actual use.

# Index
- [Call class to generate instance](#call-class-to-generate-instance)
- [SQL Construction Method (Get records)](#sql-construction-method)
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
    - [SQL Construction Cache Method](#sql-construction-cache-method)
    - [SQL Construction Initialize Method](#sql-construction-initialize-method)
    - [★Execute Query By SQL Construction Method](#execute-query-by-sql-construction-method)
    - [★Generate Query By SQL Construction Method](#generate-query-by-sql-construction-method)
- [DML Operation Method (Operate records)](#dml-operation-method)
    - [Insert Handling Method](#insert-handling-method)
    - [Insert All Handling Method](#insert-all-handling-method)
    - [Update Handling Method](#update-handling-method)
    - [Update All Handling Method](#update-all-handling-method)
    - [Upsert Handling Method](#upsert-handling-method)
    - [Delete Handling Method](#delete-handling-method)
- [Sample of usage](#sample-of-usage)
    - [Sample 1](#sample-1)
    - [Sample 2](#sample-2)
    - [Sample 3](#sample-3)
    - [Sample 4](#sample-4)

# Call class to generate instance
```apex
SObjectModel mdl = new SObjectModel(); // Any variable names is possible, "mdl" on this case here
```

# SQL Construction Method
Variety of methods can be used after generating the class instance, which are generically named as the "SQL Construction Method" here.  
Those methods are used for getting records from sObject.

## SELECT Construction Method
```apex
mdl.sqlSelect(fieldName);
```

Example for use
```apex
mdl.sqlSelect('Id, Name, IsActive');

// or in another way,

mdl.sqlSelect('Id');
mdl.sqlSelect('Name');
mdl.sqlSelect('IsActive');

// The following SELECT clause will be reserved for its generation when the method is called like above.
// SELECT Id, Name, IsActive
```

## WHERE Construction Method
```apex
mdl.sqlWhere(fieldName, fieldValue);
```

Example for use - 1
```apex
mdl.sqlWhere('Id', '00s4h00000216cCDXW');

// The following WHERE clause will be reserved for its generation when the method is called like above.
// WHERE Id = '00s4h00000216cCDXW'
```

```apex
mdl.sqlWhere('Id !=', '00s4h00000216cCDXW');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// WHERE Id != '00s4h00000216cCDXW'
```

Example for use - 2
```apex
mdl.sqlWhere('Name', 'Mikoto Misaka');
mdl.sqlWhere('IsActive', true);

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name = 'Mikoto Misaka' AND IsActive = true
```

## OR WHERE Construction Method
```apex
mdl.sqlOrWhere(fieldName, fieldValue);
```

Example for use
```
mdl.sqlWhere('Name', 'Mikoto Misaka');
mdl.sqlOrWhere('IsActive', false);
mdl.sqlOrWhere('Email !=', 'kuroko.shirai@tokiwa.ac.jp');

// WHERE Name = 'Mikoto Misaka' OR IsActive = false OR Email != 'kuroko.shirai@tokiwa.ac.jp'
```

## LIKE Construction Method
```apex
mdl.sqlLike(fieldName, fieldValue);
```

Example for use - 1
```apex
mdl.sqlLike('Name', '%Misaka%');

// The following LIKE clause will be reserved for its generation when the method is called like above.
// WHERE Name LIKE %Misaka%;
```

Example for use - 2
```apex
mdl.sqlLike('Name', '%Misaka%');
mdl.sqlLike('Name', '%koto%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name LIKE %Misaka% AND LIKE %koto%;
```

## OR LIKE Construction Method
```apex
mdl.sqlOrLike(fieldName, fieldValue);
```

Example for use
```apex
mdl.sqlLike('Name', '%Misaka%');
mdl.sqlOrLike('Name', '%koto%');

// WHERE Name LIKE %Misaka% OR LIKE %koto%;
```

## NOT LIKE Construction Method
```apex
mdl.sqlNotLike(fieldName, fieldValue);
```

Example for use - 1
```apex
mdl.sqlNotLike('Name', '%Shirai%');

// The following NOT LIKE clause will be reserved for its generation when the method is called like above.
// WHERE NOT Name LIKE %Shirai%;
```

Example for use - 2
```apex
mdl.sqlNotLike('Name', '%Shirai%');
mdl.sqlNotLike('Name', '%Kuro%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE (NOT Name LIKE %Shirai%) AND (NOT LIKE %Kuro%);
```

## OR NOT LIKE Construction Method
```apex
mdl.sqlOrNotLike(fieldName, fieldValue);
```

Example for use
```apex
mdl.sqlLike('Name', '%Misaka%');
mdl.sqlOrNotLike('Name', '%Shirai%');

// WHERE Name LIKE %Misaka% OR (NOT LIKE %Shirai%);
```

## WHERE IN Construction Method
```apex
mdl.sqlWhereIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
mdl.sqlWhereIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
mdl.sqlWhereIn('Id', param);

// The following WHERE IN clause will be reserved for its generation when the method is called like above.
// WHERE Id IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## WHERE NOT IN Construction Method
```apex
mdl.sqlWhereNotIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
mdl.sqlWhereNotIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
mdl.sqlWhereNotIn('Id', param);

// The following WHERE NOT IN clause will be reserved for its generation when the method is called like above.
// WHERE Id NOT IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## LIMIT Construction Method
```apex
mdl.sqlLimit(limitValue);
```

Example for use
```apex
mdl.sqlLimit(300);

// The following LIMIT clause will be reserved for its generation when the method is called like above.
// LIMIT 300
```

## OFFSET Construction Method
```apex
mdl.sqlOffset(offsetValue);
```

```apex
mdl.sqlOffset(100);

// The following OFFSET clause will be reserved for its generation when the method is called like above.
// OFFSET 100
```

## ORDER BY Construction Method
```apex
mdl.sqlOrderBy(fieldName, sortCondition);
```

Example for use
```apex
mdl.sqlOrderBy('Name', 'DESC');
mdl.sqlOrderBy('Id', 'ASC');

// The following OEDER BY clause will be reserved for its generation when the method is called like above.
// ORDER BY Name DESC, Id ASC
```

## GROUP BY Construction Method
```apex
mdl.sqlGroupBy(fieldName);
```

Example for use - 1
```apex
mdl.sqlGroupBy('Name');
mdl.sqlGroupBy('IsActive');

// The following GROUP BY clause will be reserved for its generation when the method is called like above.
// GROUP BY Name, IsActive;
```

Example for use - 2
```apex
mdl.sqlSelect('COUNT(Id), IsActive');
mdl.sqlGroupBy('IsActive');
List<AggregateResult> userGroup = mdl.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), IsActive FROM User GROUP BY IsActive];
```

## HAVING Construction Method
```apex
mdl.sqlHaving(fieldName, fieldValue);
```

Example for use - 1
```apex
mdl.sqlHaving('COUNT(Id)', 3);

// The following HAVING clause will be reserved for its generation when the method is called like above.
// HAVING COUNT(Id) = 3
```

```apex
mdl.sqlHaving('Name LIKE', '%Misaka%');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// HAVING Name LIKE '%Misaka%'
```

Example for use - 2
```apex
mdl.sqlHaving('COUNT(Id) >', 3);
mdl.sqlHaving('Name LIKE', '%Misaka%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// HAVING COUNT(Id) > 3 AND Name = '%Misaka%'
```

Example for use - 3
```apex
mdl.sqlSelect('COUNT(Id), Name, IsActive');
mdl.sqlGroupBy('IsActive');
mdl.sqlHaving('COUNT(Id) >', 3);
mdl.sqlHaving('Name LIKE', '%Misaka%');
List<AggregateResult> userGroup = mdl.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), Name, IsActive FROM User GROUP BY IsActive HAVING COUNT(Id) > 3 AND Name = '%Misaka%'];
```

## ALL ROWS Construction Method
```apex
mdl.sqlAllRows();
```

Example for use
```apex
mdl.sqlAllRows();
mdl.sqlSelect('Id, Name, IsDeleted');
mdl.sqlWhere('IsDeleted', true);
List<User> userList = mdl.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<User> userList = [SELECT Id, Name, IsDeleted FROM User WHERE IsDeleted = true ALL ROWS];
```

## SQL Construction Cache Method
```apex
mdl.sqlStartCache();
```
Feature of SQL Construction Method can be switched to keep query from initializing even after it is called by sqlGet or sqlQuery method.  
Please call clear method to reset this feature and initialze query.

Example for use
```apex
mdl.sqlStartCache(); // Start keeping query cache

mdl.sqlSelect('Id, Name');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

mdl.sqlSelect('IsActive');
mdl.sqlWhere('IsActive', true);
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive = true];

mdl.clear(); // Reset and initialize here

mdl.sqlSelect('IsDeleted');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT IsDeleted FROM User];
```

## SQL Construction Initialize Method
```apex
mdl.clear();
```
Reset query and initialize all features of SQL Construction methods.  
This method is also called in the constructor.  
Generally, please use this method with sqlStartCache method.  

Example for use
```apex
mdl.sqlStartCache(); // Start keeping query cache

mdl.sqlSelect('Id, Name');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

mdl.clear(); // Reset and initialize here

mdl.sqlSelect('IsDeleted');
List<Account> accList = mdl.sqlGet('Account'); // List<Account> accList = [SELECT IsDeleted FROM Account];
```

## ★Execute Query By SQL Construction Method
The SQL Construction Method is only to reserve for generation of query, and the constructed query by the method is not executed on its own.  
This sqlGet method just executes the query by the SQL Construction Method and returns the list of sObject records.

```apex
mdl.sqlGet(sObjectName);
```

Example for use
```apex
List<Account> accList = mdl.sqlGet('Account');

// The method call like above is exactly the same thing as following.
// The "*" is only a literal expression for the example, and actual query selects all fields of a sObjects.
// List<Account> queryList = [SELECT * FROM Account];
```

## ★Generate Query By SQL Construction Method
As is the same with the sqlGet method, this sqlQuery method just generates query by the SQL Construction Method and returns generated query itself of STRING type.  
NOTE: This method does not execute query!

```apex
mdl.sqlQuery(sObjectName);
```

Example for use
```apex
mdl.sqlSelect('Id, Name');
mdl.sqlWhere('NumberOfEmployees >', 100);
String query = mdl.sqlQuery('Account');

// The method call like above is exactly the same thing as following.
// String query = 'SELECT Id, Name FROM Account WHERE NumberOfEmployees > 100';
```

# DML Operation Method
Those following methods is used for DML operations of sObject record.

## Insert Handling Method
```apex
mdl.sqlInsert(sObjectCollection, params);
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

result = mdl.sqlInsert(acc, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = mdl.sqlInsert(acc, params);

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
mdl.sqlInsertAll(sObjectCollection, params);
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

srList = mdl.sqlInsertAll(accList, params);
```

Example for use - 2
```apex
srList = mdl.sqlInsertAll(acc, params);

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
mdl.sqlUpdate(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

mdl.sqlSelect('Id');
List<Account> accList = mdl.sqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

result = mdl.sqlUpdate(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = mdl.sqlUpdate(acc, params);

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
mdl.sqlUpdateAll(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
List<Database.SaveResult> srList = new List<Database.SaveResult>();

mdl.sqlSelect('Id');
List<Account> accList = mdl.sqlGet('Account');

params.put('Name', 'Misaka10091');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 10091);

srList = mdl.sqlUpdateAll(accList, params);
```

Example for use - 2
```apex
srList = mdl.sqlUpdateAll(acc, params);

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
mdl.sqlUpsert(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

mdl.sqlSelect('Id');
List<Account> accList = mdl.sqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
accList.add(newAcc);

result = mdl.sqlUpsert(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = mdl.sqlUpsert(acc, params);

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
mdl.sqlDelete(sObjectCollection);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|

Example for use - 1
```apexapex
Map<String, Object> result = new Map<String, Object>{};

mdl.sqlSelect('Id');
List<Account> accList = mdl.sqlGet('Account');

result = mdl.sqlDelete(accList);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = mdl.sqlDelete(acc);

if ((Boolean)result.get('success')) {
    // Some process

} else {
    Exception e = (Exception)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

# Sample of usage
## Sample 1
```apex
mdl.sqlSelect('Id');
mdl.sqlSelect('Name');
mdl.sqlSelect('Alias');
List<User> user = mdl.sqlGet('User');
```

Or in another way,

```apex
mdl.sqlSelect('Id, Name, Alias');
List<User> user = mdl.sqlGet('User');
```

The method call like above is exactly the same thing as following.

```apex
List<User> user = [
    SELECT
        Id,
        Name,
        Alias
    FROM
        User
];
```

## Sample 2
```apex
mdl.sqlSelect('*');
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = mdl.sqlGet('Account');
```

Or in another way,

```apex
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = mdl.sqlGet('Account');
```

The method call like above is exactly the same thing as following.

```apex
List<Account> accList = [
    SELECT
        Id,
        Name,
        AccountNumber,
        AccountSource,
        AnnualRevenue,
        BillingAddress,
        BillingCity,
        BillingCountry,
        BillingCountryCode,
        BillingGeocodeAccuracy,
        BillingLatitude,
        BillingLongitude,
        BillingPostalCode,
        BillingState,
        BillingStateCode,
        BillingStreet,
        ChannelProgramName,
        ChannelProgramLevelName,
        CleanStatus,
        ConnectionReceivedId,
        ConnectionSentId,
        Description,
        DunsNumber,
        Fax,
        HasOptedOutOfEmail,
        Industry,
        IsCustomerPortal,
        IsDeleted,
        IsPartner,
        IsPersonAccount,
        Jigsaw,
        LastActivityDate,
        LastReferencedDate,
        LastViewedDate,
        MasterRecordId,
        NaicsCode,
        NaicsDesc,
        NumberOfEmployees,
        OperatingHoursId,
        OwnerId,
        Ownership,
        ParentId,
        PersonIndividualId,
        Phone,
        ...., // abbr.
        LastModifiedDate,
        CreatedById
    FROM
        Account
    WHERE
        Id = '00s4h00000216cCDXW'
];
```

## Sample 3
```apex
mdl.sqlSelect('Id, Name');

for (Integer i = 0; i < 100; i++) {
    mdl.sqlOrWhere('Name', 'Misaka' + i);
}

List<Account> accList = mdl.sqlGet('Account');
```

The method call like above is exactly the same thing as following.

```apex
List<Account> accList = [
    SELECT
        Id,
        Name
    FROM
        Account
    WHERE
        Name = 'Misaka0' OR Id = 'Misaka1' OR Id = 'Misaka2' OR Id = 'Misaka3' ...  OR Id = 'Misaka99'
];
```

## Sample 4
```apex
SObjectModel mdl = new SObjectModel();

RestRequest req = RestContext.request; // Rest API Context

// Get API request body, key: sObject field name / value: sObject field value
Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.ToString());

// Some verifying process (abbr.)
***

// Get Name
String accName = (String)params.get('Name');

// Get sObject record of the Name
mdl.sqlSelect('Id');
mdl.sqlWhere('Name', accName);
List<Account> accList = mdl.sqlGet('Account');

// DML Operation
Map<String, Object> result = mdl.sqlUpdate(accList, params); // Just simply assign "params" variable

// Verify result
if (! (Boolean)result.get('success') ) { // When failed
    Exceptiopn e = (Exceptiopn)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

# Reuse of the SQL Construction Method
There are two ways to use those methods more than once at one transaction.

## 1. Generate new instance every time getting sObject records.
```apex
SObjectModel mdl_1 = new SObjectModel(); // mdl_1 to generate new instance
mdl_1.sqlSelect('Id, Name');
List<User> user = mdl_1.sqlGet('User');

SObjectModel mdl_2 = new SObjectModel(); // mdl_2 to generate new instance
mdl_2.sqlSelect('Id, Name');
mdl_2.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl_2.sqlGet('Account');

SObjectModel mdl_3 = new SObjectModel(); // mdl_3 to generate new instance
mdl_3.sqlSelect('Id, Name');
mdl_3.sqlLimit(20);
List<Contact> con = mdl_3.sqlGet('Contact');
```

However, the way above is very useless because too many variables increase to manage them.  
The SQL Construction Method basically initializes itself after sqlGet / sqlQuery method is called like below, and it is no need to regenerate new instance many times.

## 2. Query will be initialized after sqlGet / sqlQuery method is called
```apex
SObjectModel mdl = new SObjectModel(); // mdl to generate instance, only once here

mdl.sqlSelect('Id, Name');
List<User> user = mdl.sqlGet('User'); // Query is also initialized here

mdl.sqlSelect('Id, Name');
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl.sqlGet('Account'); // Query is also initialized here

mdl.sqlSelect('Id, Name');
mdl.sqlLimit(20);
List<Contact> con = mdl.sqlGet('Contact'); // Query is also initialized here
```