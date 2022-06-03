Apex SOQLBuilder
===

Salesforce Apex Class for DML operations with extensity

# Introduction
Development of Apex class needs to describe Salesforce's unique language called [SOQL](https://developer.salesforce.com/docs/atlas.ja-jp.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_sosl_intro.htm) to handle DML operations for sObjects. More conditions to filter sObject records to get, query becomes longer and more redundant, which makes it difficult to describe dynamic query.  
On this occasion, SOQLBuilder class has been defiened to solve this problem. The concept of MVC framework is consulted for this class that incorporates a part of features of Model. The goal is to realize the way of SOQL query description with more simplisity, readability, variability and availability.

Document: https://github.com/BruceWeyne/Apex-SOQLBuilder/tree/main/Document/English

# はじめに
Apex での sObject の DML 操作は [SOQL](https://developer.salesforce.com/docs/atlas.ja-jp.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_sosl_intro.htm) と呼ばれる Salesforce 独自の言語が必要となり、開発において都度クエリを記述する必要がある。クエリの絞り込みが多くなるにつれてコードは冗長化し、動的なクエリの記述は難しくなる。  
この課題を解決する目的として、SOQLBuilder クラスを定義することにした。このクラスは、フレームワークの概念である MVC を参考にして、「モデル」機能の一部の動作を模倣するものである。これにより、SOQL クエリを直書きするよりも簡略的で可読性、可変性、可用性の高い記法の実現を目指している。

ドキュメント: https://github.com/BruceWeyne/Apex-SOQLBuilder/tree/main/Document/Japanese


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

# 使用方法サンプル
## 例1
```apex
sb.sqlSelect('Id');
sb.sqlSelect('Name');
sb.sqlSelect('Alias');
List<User> user = sb.sqlGet('User');
```

または

```apex
sb.sqlSelect('Id, Name, Alias');
List<User> user = sb.sqlGet('User');
```

上記のメソッドコールは下記の処理と同様

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

## 例2
```apex
sb.sqlSelect('*');
sb.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = sb.sqlGet('Account');
```

または

```apex
sb.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = sb.sqlGet('Account');
```

上記のメソッドコールは下記の処理と同様

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
        ...., // 省略
        LastModifiedDate,
        CreatedById
    FROM
        Account
    WHERE
        Id = '00s4h00000216cCDXW'
];
```

## 例3
```apex
sb.sqlSelect('Id, Name');

for (Integer i = 0; i < 100; i++) {
    sb.sqlOrWhere('Name', 'Misaka' + i);
}

List<Account> accList = sb.sqlGet('Account');
```

上記のメソッドコールは下記の処理と同様

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

## 例4
```apex
SOQLBuilder sb = new SOQLBuilder();

RestRequest req = RestContext.request; // Rest API Context

// API リクエストボディの取得, キー: sObject フィールド名 / 値: sObject フィールドの値
Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.ToString());

// パラメータの検証（省略）
***

// Name キーの値を取得
String accName = (String)params.get('Name');

// 該当の Name を持つレコードを取得
sb.sqlSelect('Id');
sb.sqlWhere('Name', accName);
List<Account> accList = sb.sqlGet('Account');

// DML 操作
Map<String, Object> result = sb.sqlUpdate(accList, params); // Just simply assign "params" variable

// 結果の検証
if (! (Boolean)result.get('success') ) { // 失敗の場合
    Exceptiopn e = (Exceptiopn)result.get('error');
    System.debug(e.getMessage());
    return;
}
```