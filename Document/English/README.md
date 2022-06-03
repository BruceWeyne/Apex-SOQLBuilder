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
SOQLBuilder sb = new SOQLBuilder(); // Any variable names is possible, "sb" on this case here
```

# SQL Construction Method
Variety of methods can be used after generating the class instance, which are generically named as the "SQL Construction Method" here.  
Those methods are used for getting records from sObject.

## SELECT Construction Method
```apex
sb.sqlSelect(fieldName);
```

Example for use
```apex
sb.sqlSelect('Id, Name, IsActive');

// or in another way,

sb.sqlSelect('Id');
sb.sqlSelect('Name');
sb.sqlSelect('IsActive');

// The following SELECT clause will be reserved for its generation when the method is called like above.
// SELECT Id, Name, IsActive
```

## WHERE Construction Method
```apex
sb.sqlWhere(fieldName, fieldValue);
```

Example for use - 1
```apex
sb.sqlWhere('Id', '00s4h00000216cCDXW');

// The following WHERE clause will be reserved for its generation when the method is called like above.
// WHERE Id = '00s4h00000216cCDXW'
```

```apex
sb.sqlWhere('Id !=', '00s4h00000216cCDXW');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// WHERE Id != '00s4h00000216cCDXW'
```

Example for use - 2
```apex
sb.sqlWhere('Name', 'Mikoto Misaka');
sb.sqlWhere('IsActive', true);

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name = 'Mikoto Misaka' AND IsActive = true
```

## OR WHERE Construction Method
```apex
sb.sqlOrWhere(fieldName, fieldValue);
```

Example for use
```
sb.sqlWhere('Name', 'Mikoto Misaka');
sb.sqlOrWhere('IsActive', false);
sb.sqlOrWhere('Email !=', 'kuroko.shirai@tokiwa.ac.jp');

// WHERE Name = 'Mikoto Misaka' OR IsActive = false OR Email != 'kuroko.shirai@tokiwa.ac.jp'
```

## LIKE Construction Method
```apex
sb.sqlLike(fieldName, fieldValue);
```

Example for use - 1
```apex
sb.sqlLike('Name', '%Misaka%');

// The following LIKE clause will be reserved for its generation when the method is called like above.
// WHERE Name LIKE %Misaka%;
```

Example for use - 2
```apex
sb.sqlLike('Name', '%Misaka%');
sb.sqlLike('Name', '%koto%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE Name LIKE %Misaka% AND LIKE %koto%;
```

## OR LIKE Construction Method
```apex
sb.sqlOrLike(fieldName, fieldValue);
```

Example for use
```apex
sb.sqlLike('Name', '%Misaka%');
sb.sqlOrLike('Name', '%koto%');

// WHERE Name LIKE %Misaka% OR LIKE %koto%;
```

## NOT LIKE Construction Method
```apex
sb.sqlNotLike(fieldName, fieldValue);
```

Example for use - 1
```apex
sb.sqlNotLike('Name', '%Shirai%');

// The following NOT LIKE clause will be reserved for its generation when the method is called like above.
// WHERE NOT Name LIKE %Shirai%;
```

Example for use - 2
```apex
sb.sqlNotLike('Name', '%Shirai%');
sb.sqlNotLike('Name', '%Kuro%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// WHERE (NOT Name LIKE %Shirai%) AND (NOT LIKE %Kuro%);
```

## OR NOT LIKE Construction Method
```apex
sb.sqlOrNotLike(fieldName, fieldValue);
```

Example for use
```apex
sb.sqlLike('Name', '%Misaka%');
sb.sqlOrNotLike('Name', '%Shirai%');

// WHERE Name LIKE %Misaka% OR (NOT LIKE %Shirai%);
```

## WHERE IN Construction Method
```apex
sb.sqlWhereIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
sb.sqlWhereIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
sb.sqlWhereIn('Id', param);

// The following WHERE IN clause will be reserved for its generation when the method is called like above.
// WHERE Id IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## WHERE NOT IN Construction Method
```apex
sb.sqlWhereNotIn(fieldName, fieldValue); // fieldValue is also possible as Set type
```

Example for use
```apex
sb.sqlWhereNotIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // Escape handling is necessary when String type

// or more specifically,

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
sb.sqlWhereNotIn('Id', param);

// The following WHERE NOT IN clause will be reserved for its generation when the method is called like above.
// WHERE Id NOT IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## LIMIT Construction Method
```apex
sb.sqlLimit(limitValue);
```

Example for use
```apex
sb.sqlLimit(300);

// The following LIMIT clause will be reserved for its generation when the method is called like above.
// LIMIT 300
```

## OFFSET Construction Method
```apex
sb.sqlOffset(offsetValue);
```

```apex
sb.sqlOffset(100);

// The following OFFSET clause will be reserved for its generation when the method is called like above.
// OFFSET 100
```

## ORDER BY Construction Method
```apex
sb.sqlOrderBy(fieldName, sortCondition);
```

Example for use
```apex
sb.sqlOrderBy('Name', 'DESC');
sb.sqlOrderBy('Id', 'ASC');

// The following OEDER BY clause will be reserved for its generation when the method is called like above.
// ORDER BY Name DESC, Id ASC
```

## GROUP BY Construction Method
```apex
sb.sqlGroupBy(fieldName);
```

Example for use - 1
```apex
sb.sqlGroupBy('Name');
sb.sqlGroupBy('IsActive');

// The following GROUP BY clause will be reserved for its generation when the method is called like above.
// GROUP BY Name, IsActive;
```

Example for use - 2
```apex
sb.sqlSelect('COUNT(Id), IsActive');
sb.sqlGroupBy('IsActive');
List<AggregateResult> userGroup = sb.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), IsActive FROM User GROUP BY IsActive];
```

## HAVING Construction Method
```apex
sb.sqlHaving(fieldName, fieldValue);
```

Example for use - 1
```apex
sb.sqlHaving('COUNT(Id)', 3);

// The following HAVING clause will be reserved for its generation when the method is called like above.
// HAVING COUNT(Id) = 3
```

```apex
sb.sqlHaving('Name LIKE', '%Misaka%');

// Comparative operators can be contained into keys of the 1st argument, which needs to add space between them.
// HAVING Name LIKE '%Misaka%'
```

Example for use - 2
```apex
sb.sqlHaving('COUNT(Id) >', 3);
sb.sqlHaving('Name LIKE', '%Misaka%');

// Conditions will be concatinated by "AND" when the method is called more than once.
// HAVING COUNT(Id) > 3 AND Name = '%Misaka%'
```

Example for use - 3
```apex
sb.sqlSelect('COUNT(Id), Name, IsActive');
sb.sqlGroupBy('IsActive');
sb.sqlHaving('COUNT(Id) >', 3);
sb.sqlHaving('Name LIKE', '%Misaka%');
List<AggregateResult> userGroup = sb.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<AggregateResult> userGroup = [SELECT COUNT(Id), Name, IsActive FROM User GROUP BY IsActive HAVING COUNT(Id) > 3 AND Name = '%Misaka%'];
```

## ALL ROWS Construction Method
```apex
sb.sqlAllRows();
```

Example for use
```apex
sb.sqlAllRows();
sb.sqlSelect('Id, Name, IsDeleted');
sb.sqlWhere('IsDeleted', true);
List<User> userList = sb.sqlGet('User');

// The method call like above is exactly the same thing as following.
// List<User> userList = [SELECT Id, Name, IsDeleted FROM User WHERE IsDeleted = true ALL ROWS];
```

## SQL Construction Cache Method
```apex
sb.sqlStartCache();
```
Feature of SQL Construction Method can be switched to keep query from initializing even after it is called by sqlGet or sqlQuery method.  
Please call clear method to reset this feature and initialze query.

Example for use
```apex
sb.sqlStartCache(); // Start keeping query cache

sb.sqlSelect('Id, Name');
List<User> userList = sb.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

sb.sqlSelect('IsActive');
sb.sqlWhere('IsActive', true);
List<User> userList = sb.sqlGet('User'); // List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive = true];

sb.clear(); // Reset and initialize here

sb.sqlSelect('IsDeleted');
List<User> userList = sb.sqlGet('User'); // List<User> userList = [SELECT IsDeleted FROM User];
```

## SQL Construction Initialize Method
```apex
sb.clear();
```
Reset query and initialize all features of SQL Construction methods.  
This method is also called in the constructor.  
Generally, please use this method with sqlStartCache method.  

Example for use
```apex
sb.sqlStartCache(); // Start keeping query cache

sb.sqlSelect('Id, Name');
List<User> userList = sb.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

sb.clear(); // Reset and initialize here

sb.sqlSelect('IsDeleted');
List<Account> accList = sb.sqlGet('Account'); // List<Account> accList = [SELECT IsDeleted FROM Account];
```

## ★Execute Query By SQL Construction Method
The SQL Construction Method is only to reserve for generation of query, and the constructed query by the method is not executed on its own.  
This sqlGet method just executes the query by the SQL Construction Method and returns the list of sObject records.

```apex
sb.sqlGet(sObjectName);
```

Example for use
```apex
List<Account> accList = sb.sqlGet('Account');

// The method call like above is exactly the same thing as following.
// The "*" is only a literal expression for the example, and actual query selects all fields of a sObjects.
// List<Account> queryList = [SELECT * FROM Account];
```

## ★Generate Query By SQL Construction Method
As is the same with the sqlGet method, this sqlQuery method just generates query by the SQL Construction Method and returns generated query itself of STRING type.  
NOTE: This method does not execute query!

```apex
sb.sqlQuery(sObjectName);
```

Example for use
```apex
sb.sqlSelect('Id, Name');
sb.sqlWhere('NumberOfEmployees >', 100);
String query = sb.sqlQuery('Account');

// The method call like above is exactly the same thing as following.
// String query = 'SELECT Id, Name FROM Account WHERE NumberOfEmployees > 100';
```

# DML Operation Method
Those following methods is used for DML operations of sObject record.

## Insert Handling Method
```apex
sb.sqlInsert(sObjectCollection, params);
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

result = sb.sqlInsert(acc, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = sb.sqlInsert(acc, params);

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
sb.sqlInsertAll(sObjectCollection, params);
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

srList = sb.sqlInsertAll(accList, params);
```

Example for use - 2
```apex
srList = sb.sqlInsertAll(acc, params);

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
sb.sqlUpdate(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

sb.sqlSelect('Id');
List<Account> accList = sb.sqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

result = sb.sqlUpdate(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = sb.sqlUpdate(acc, params);

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
sb.sqlUpdateAll(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
List<Database.SaveResult> srList = new List<Database.SaveResult>();

sb.sqlSelect('Id');
List<Account> accList = sb.sqlGet('Account');

params.put('Name', 'Misaka10091');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 10091);

srList = sb.sqlUpdateAll(accList, params);
```

Example for use - 2
```apex
srList = sb.sqlUpdateAll(acc, params);

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
sb.sqlUpsert(sObjectCollection, params);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|
|2nd|params|Map<String, Object>|Assignment of sObject field and its value, Nullable|

Example for use - 1
```apex
Map<String, Object> params = new Map<String, Object>{};
Map<String, Object> result = new Map<String, Object>{};

sb.sqlSelect('Id');
List<Account> accList = sb.sqlGet('Account');

params.put('Name', 'Sisters');
params.put('BillingCity', 'Academic city');
params.put('BillingCountry', 'Japan');
params.put('BillingState', 'Tokyo');
params.put('NumberOfEmployees', 20001);

Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
accList.add(newAcc);

result = sb.sqlUpsert(accList, params);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = sb.sqlUpsert(acc, params);

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
sb.sqlDelete(sObjectCollection);
```

|Arg.|Name|Type|Note|
|-|-|-|-|
|1st|sObjectCollection|sObject / List\<sObject>|sObject or List of sObjects|

Example for use - 1
```apexapex
Map<String, Object> result = new Map<String, Object>{};

sb.sqlSelect('Id');
List<Account> accList = sb.sqlGet('Account');

result = sb.sqlDelete(accList);

// Value of the "result" variable when successful
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

Example for use - 2
```apex
result = sb.sqlDelete(acc);

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
sb.sqlSelect('Id');
sb.sqlSelect('Name');
sb.sqlSelect('Alias');
List<User> user = sb.sqlGet('User');
```

Or in another way,

```apex
sb.sqlSelect('Id, Name, Alias');
List<User> user = sb.sqlGet('User');
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
sb.sqlSelect('*');
sb.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = sb.sqlGet('Account');
```

Or in another way,

```apex
sb.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = sb.sqlGet('Account');
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
sb.sqlSelect('Id, Name');

for (Integer i = 0; i < 100; i++) {
    sb.sqlOrWhere('Name', 'Misaka' + i);
}

List<Account> accList = sb.sqlGet('Account');
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
SOQLBuilder sb = new SOQLBuilder();

RestRequest req = RestContext.request; // Rest API Context

// Get API request body, key: sObject field name / value: sObject field value
Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.ToString());

// Some verifying process (abbr.)
***

// Get Name
String accName = (String)params.get('Name');

// Get sObject record of the Name
sb.sqlSelect('Id');
sb.sqlWhere('Name', accName);
List<Account> accList = sb.sqlGet('Account');

// DML Operation
Map<String, Object> result = sb.sqlUpdate(accList, params); // Just simply assign "params" variable

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
The SQL Construction Method basically initializes itself after sqlGet / sqlQuery method is called like below, and it is no need to regenerate new instance many times.

## 2. Query will be initialized after sqlGet / sqlQuery method is called
```apex
SOQLBuilder sb = new SOQLBuilder(); // sb to generate instance, only once here

sb.sqlSelect('Id, Name');
List<User> user = sb.sqlGet('User'); // Query is also initialized here

sb.sqlSelect('Id, Name');
sb.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = sb.sqlGet('Account'); // Query is also initialized here

sb.sqlSelect('Id, Name');
sb.sqlLimit(20);
List<Contact> con = sb.sqlGet('Contact'); // Query is also initialized here
```