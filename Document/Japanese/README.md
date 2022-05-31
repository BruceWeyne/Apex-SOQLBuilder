ドキュメント
===

まず使用方法サンプルのセクションを一読し、実際に使用する際に他のセクションを参照してください。

# 目次
- [クラスの呼び出し（インスタンスの生成）](#クラスの呼び出しインスタンスの生成)
- [SQL 構文メソッド（レコード取得）](#SQL-構文メソッド)
    - [SELECT 構文メソッド](#SELECT-構文メソッド)
    - [WHERE 構文メソッド](#WHERE-構文メソッド)
    - [OR WHERE 構文メソッド](#OR-WHERE-構文メソッド)
    - [LIKE 構文メソッド](#LIKE-構文メソッド)
    - [OR LIKE 構文メソッド](#OR-LIKE-構文メソッド)
    - [NOT LIKE 構文メソッド](#NOT-LIKE-構文メソッド)
    - [OR NOT LIKE 構文メソッド](#OR-NOT-LIKE-構文メソッド)
    - [WHERE IN 構文メソッド](#WHERE-IN-構文メソッド)
    - [WHERE NOT IN 構文メソッド](#WHERE-NOT-IN-構文メソッド)
    - [LIMIT 構文メソッド](#LIMIT-構文メソッド)
    - [OFFSET 構文メソッド](#OFFSET-構文メソッド)
    - [ORDER BY 構文メソッド](#ORDER-BY-構文メソッド)
    - [GROUP BY 構文メソッド](#GROUP-BY-構文メソッド)
    - [HAVING 構文メソッド](#HAVING-構文メソッド)
    - [SQL 構文キャッシュメソッド](#SQL-構文キャッシュメソッド)
    - [SQL 構文の初期化メソッド](#SQL-構文の初期化メソッド)
    - [★SQL 構文の実行（レコードの取得）メソッド](#SQL-構文の実行レコードの取得メソッド)
    - [★SQL 構文のクエリ生成メソッド](#SQL-構文のクエリ生成メソッド)
- [DML 操作メソッド（レコード操作）](#DML-操作メソッド)
    - [Insert（挿入）処理](#insert挿入処理)
    - [Insert All（一括挿入）処理](#Insert-All一括挿入処理)
    - [Update（更新）処理](#update更新処理)
    - [Update All（一括更新）処理](#Update-All一括更新処理)
    - [Upsert（更新 / 挿入）処理](#upsert更新--挿入処理)
    - [Delete（削除）処理](#delete削除処理)
- [使用方法サンプル](#使用方法サンプル)
    - [例1](#例1)
    - [例2](#例2)
    - [例3](#例3)
    - [例4](#例4)

# クラスの呼び出し（インスタンスの生成）
```apex
SObjectModel mdl = new SObjectModel(); // 変数名は任意、ここでは mdl
```

# SQL 構文メソッド
インスタンス生成後に使用できるメソッドとして、「SQL 構文メソッド」を用意した。  
これらは、sObject からレコードを取得するためのメソッドである。

## SELECT 構文メソッド
```apex
mdl.sqlSelect(fieldName);
```

使用例
```apex
mdl.sqlSelect('Id, Name, IsActive');

// または

mdl.sqlSelect('Id');
mdl.sqlSelect('Name');
mdl.sqlSelect('IsActive');

// 上記のようにメソッドをコールすると、以下の SELECT 句の生成が予約される
// SELECT Id, Name, IsActive
```

## WHERE 構文メソッド
```apex
mdl.sqlWhere(fieldName, fieldValue);
```

使用例 - 1
```apex
mdl.sqlWhere('Id', '00s4h00000216cCDXW');

// 上記のようにメソッドをコールすると、以下の WHERE 句の生成が予約される
// WHERE Id = '00s4h00000216cCDXW'
```

```apex
mdl.sqlWhere('Id !=', '00s4h00000216cCDXW');

// キー名に比較演算子を含めることも可能（キー名と比較演算子の間にスペース必須）
// WHERE Id != '00s4h00000216cCDXW'
```

使用例 - 2
```apex
mdl.sqlWhere('Name', '御坂 美琴');
mdl.sqlWhere('IsActive', true);

// 複数回コールすると AND 接続となる
// WHERE Name = '御坂 美琴' AND IsActive = true
```

## OR WHERE 構文メソッド
```apex
mdl.sqlOrWhere(fieldName, fieldValue);
```

使用例
```apex
mdl.sqlWhere('Name', '御坂 美琴');
mdl.sqlOrWhere('IsActive', false);
mdl.sqlOrWhere('Email !=', 'kuroko.shirai@tokiwa.ac.jp');

// WHERE Name = '御坂 美琴' OR IsActive = false OR Email != 'kuroko.shirai@tokiwa.ac.jp'
```

## LIKE 構文メソッド
```apex
mdl.sqlLike(fieldName, fieldValue);
```

使用例 - 1
```apex
mdl.sqlLike('Name', '%御坂%');

// 上記のようにメソッドをコールすると、以下の LIKE 句の生成が予約される
// WHERE Name LIKE %御坂%;
```

使用例 - 2
```apex
mdl.sqlLike('Name', '%御坂%');
mdl.sqlLike('Name', '%琴%');

// 複数回コールすると AND 接続となる
// WHERE Name LIKE %御坂% AND LIKE %琴%;
```

## OR LIKE 構文メソッド
```apex
mdl.sqlOrLike(fieldName, fieldValue);
```

使用例
```apex
mdl.sqlLike('Name', '%御坂%');
mdl.sqlOrLike('Name', '%琴%');

// WHERE Name LIKE %御坂% OR LIKE %琴%;
```

## NOT LIKE 構文メソッド
```apex
mdl.sqlNotLike(fieldName, fieldValue);
```

使用例 - 1
```apex
mdl.sqlNotLike('Name', '%白井%');

// 上記のようにメソッドをコールすると、以下の NOT LIKE 句の生成が予約される
// WHERE NOT Name LIKE %白井%;
```

使用例 - 2
```apex
mdl.sqlNotLike('Name', '%白井%');
mdl.sqlNotLike('Name', '%黒%');

// 複数回コールすると AND 接続となる
// WHERE (NOT Name LIKE %白井%) AND (NOT LIKE %黒%);
```

## OR NOT LIKE 構文メソッド
```apex
mdl.sqlOrNotLike(fieldName, fieldValue);
```

使用例
```apex
mdl.sqlLike('Name', '%御坂%');
mdl.sqlOrNotLike('Name', '%白井%');

// WHERE Name LIKE %御坂% OR (NOT LIKE %白井%);
```

## WHERE IN 構文メソッド
```apex
mdl.sqlWhereIn(fieldName, fieldValue); // fieldValue は Set 型でも可
```

使用例
```apex
mdl.sqlWhereIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // String 型の値の場合はエスケープ必要

// または

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
mdl.sqlWhereIn('Id', param);

// 上記のようにメソッドをコールすると、以下の WHERE IN 句の生成が予約される
// WHERE Id IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## WHERE NOT IN 構文メソッド
```apex
mdl.sqlWhereNotIn(fieldName, fieldValue); // fieldValue は Set 型でも可
```

使用例
```apex
mdl.sqlWhereNotIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // String 型の値の場合はエスケープ必要

// または

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
mdl.sqlWhereNotIn('Id', param);

// 上記のようにメソッドをコールすると、以下の WHERE NOT IN 句の生成が予約される
// WHERE Id NOT IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## LIMIT 構文メソッド
```apex
mdl.sqlLimit(limitValue);
```

使用例
```apex
mdl.sqlLimit(300);

// 上記のようにメソッドをコールすると、以下の LIMIT 句の生成が予約される
// LIMIT 300
```

## OFFSET 構文メソッド
```apex
mdl.sqlOffset(offsetValue);
```

```apex
mdl.sqlOffset(100);

// 上記のようにメソッドをコールすると、以下の OFFSET 句の生成が予約される
// OFFSET 100
```

## ORDER BY 構文メソッド
```apex
mdl.sqlOrderBy(fieldName, sortCondition);
```

使用例
```apex
mdl.sqlOrderBy('Name', 'DESC');
mdl.sqlOrderBy('Id', 'ASC');

// 上記のようにメソッドをコールすると、以下の OEDER BY 句の生成が予約される
// ORDER BY Name DESC, Id ASC
```

## GROUP BY 構文メソッド
```apex
mdl.sqlGroupBy(fieldName);
```

使用例 - 1
```apex
mdl.sqlGroupBy('Name');
mdl.sqlGroupBy('IsActive');

// 上記のようにメソッドをコールすると、以下の GROUP BY 句の生成が予約される
// GROUP BY Name, IsActive;
```

使用例 - 2
```apex
mdl.sqlSelect('COUNT(Id), IsActive');
mdl.sqlGroupBy('IsActive');
List<AggregateResult> userGroup = mdl.sqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<AggregateResult> userGroup = [SELECT COUNT(Id), IsActive FROM User GROUP BY IsActive];
```

## HAVING 構文メソッド
```apex
mdl.sqlHaving(fieldName, fieldValue);
```

使用例 - 1
```apex
mdl.sqlHaving('COUNT(Id)', 3);

// 上記のようにメソッドをコールすると、以下の HAVING 句の生成が予約される
// HAVING COUNT(Id) = 3
```

```apex
mdl.sqlHaving('Name LIKE', '%御坂%');

// キー名に比較演算子を含めることも可能（キー名と比較演算子の間にスペース必須）
// HAVING Name LIKE '%御坂%'
```

使用例 - 2
```apex
mdl.sqlHaving('COUNT(Id) >', 3);
mdl.sqlHaving('Name LIKE', '%御坂%');

// 複数回コールすると AND 接続となる
// HAVING COUNT(Id) > 3 AND Name = '%御坂%'
```

使用例 - 3
```apex
mdl.sqlSelect('COUNT(Id), Name, IsActive');
mdl.sqlGroupBy('IsActive');
mdl.sqlHaving('COUNT(Id) >', 3);
mdl.sqlHaving('Name LIKE', '%御坂%');
List<AggregateResult> userGroup = mdl.sqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<AggregateResult> userGroup = [SELECT COUNT(Id), Name, IsActive FROM User GROUP BY IsActive HAVING COUNT(Id) > 3 AND Name = '%御坂%'];
```

## ALL ROWS 構文メソッド
```apex
mdl.sqlAllRows();
```

使用例
```apex
mdl.sqlAllRows();
mdl.sqlSelect('Id, Name, IsDeleted');
mdl.sqlWhere('IsDeleted', true);
List<User> userList = mdl.sqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<User> userList = [SELECT Id, Name, IsDeleted FROM User WHERE IsDeleted = true ALL ROWS];
```

## SQL 構文キャッシュメソッド
```apex
mdl.sqlStartCache();
```
sqlGet, sqlQuery メソッドがコールされても、クエリを初期化せず保持する設定に切り替えられる。  
リセットする場合は clear メソッドをコールする。

使用例
```apex
mdl.sqlStartCache(); // クエリキャッシュの保持スタート

mdl.sqlSelect('Id, Name');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

mdl.sqlSelect('IsActive');
mdl.sqlWhere('IsActive', true);
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive = true];

mdl.clear(); // ここでリセット

mdl.sqlSelect('IsDeleted');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT IsDeleted FROM User];
```

## SQL 構文の初期化メソッド
```apex
mdl.clear();
```
クエリのリセットメソッド。  
コンストラクタでもこのメソッドを呼び出している。  
sqlStartCache メソッドと共に用いる。  

使用例
```apex
mdl.sqlStartCache(); // クエリキャッシュの保持スタート

mdl.sqlSelect('Id, Name');
List<User> userList = mdl.sqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

mdl.clear(); // ここでリセット

mdl.sqlSelect('IsDeleted');
List<Account> accList = mdl.sqlGet('Account'); // List<Account> accList = [SELECT IsDeleted FROM Account];
```

## ★SQL 構文の実行（レコードの取得）メソッド
上述までの SQL 構文メソッドは SQL クエリ構築のための予約であり、それ単体ではクエリは実行されない。  
この sqlGet メソッドを最後にコールすることで、SQL 構文メソッドにより構築されたクエリが実行され、レコードのリストが返却される。

```apex
mdl.sqlGet(sObjectName);
```

使用例
```apex
List<Account> accList = mdl.sqlGet('Account');

// 上記のメソッドコールは下記の処理と同様
// 「*」はこの例における便宜上で、実際はすべてのフィールドが羅列される
// List<Account> queryList = [SELECT * FROM Account];
```

## ★SQL 構文のクエリ生成メソッド
sqlGet メソッドと同様に、この sqlQuery メソッドを最後にコールすることで、SQL 構文メソッドにより構築されたクエリが生成され、そのクエリ文字列が返却される。<注意> このメソッドではクエリは実行されない！

```apex
mdl.sqlQuery(sObjectName);
```

使用例
```apex
mdl.sqlSelect('Id, Name');
mdl.sqlWhere('NumberOfEmployees >', 100);
String query = mdl.sqlQuery('Account');

// 上記のメソッドコールは下記の処理と同様
// String query = 'SELECT Id, Name FROM Account WHERE NumberOfEmployees > 100';
```

# DML 操作メソッド
sObject のレコードを操作するメソッド。

## Insert（挿入）処理
```apex
mdl.sqlInsert(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容|

使用例 - 1
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

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Insert All（一括挿入）処理
上述の sqlInsert メソッドでも一括で挿入する処理は可能だが、このメソッドでは一部のレコードが失敗しても、残りのレコードに対して DML 操作を正常に完了できる。基盤の機能は Database.insert() の第二引数が false の場合を活用している。

```apex
mdl.sqlInsertAll(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容|

使用例 - 1
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

使用例 - 2
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

## Update（更新）処理
```apex
mdl.sqlUpdate(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容|

使用例 - 1
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

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Update All（一括更新）処理
上述の sqlUpdate メソッドでも一括で更新する処理は可能だが、このメソッドでは一部のレコードが失敗しても、残りのレコードに対して DML 操作を正常に完了できる。基盤の機能は Database.update() の第二引数が false の場合を活用している。

```apex
mdl.sqlUpdateAll(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容, Null許容|

使用例 - 1
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

使用例 - 2
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

## Upsert（更新 / 挿入）処理
```apex
mdl.sqlUpsert(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容, Null 値許容|

使用例 - 1
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

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Delete（削除）処理
```apex
mdl.sqlDelete(sObjectCollection);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|

使用例 - 1
```apex
Map<String, Object> result = new Map<String, Object>{};

mdl.sqlSelect('Id');
List<Account> accList = mdl.sqlGet('Account');

result = mdl.sqlDelete(accList);

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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


# 使用方法サンプル
## 例1
```apex
mdl.sqlSelect('Id');
mdl.sqlSelect('Name');
mdl.sqlSelect('Alias');
List<User> user = mdl.sqlGet('User');
```

または

```apex
mdl.sqlSelect('Id, Name, Alias');
List<User> user = mdl.sqlGet('User');
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
mdl.sqlSelect('*');
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = mdl.sqlGet('Account');
```

または

```apex
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> accList = mdl.sqlGet('Account');
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
mdl.sqlSelect('Id, Name');

for (Integer i = 0; i < 100; i++) {
    mdl.sqlOrWhere('Name', 'Misaka' + i);
}

List<Account> accList = mdl.sqlGet('Account');
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
SObjectModel mdl = new SObjectModel();

RestRequest req = RestContext.request; // Rest API Context

// API リクエストボディの取得, キー: sObject フィールド名 / 値: sObject フィールドの値
Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.ToString());

// パラメータの検証（省略）
***

// Name キーの値を取得
String accName = (String)params.get('Name');

// 該当の Name を持つレコードを取得
mdl.sqlSelect('Id');
mdl.sqlWhere('Name', accName);
List<Account> accList = mdl.sqlGet('Account');

// DML 操作
Map<String, Object> result = mdl.sqlUpdate(accList, params); // Just simply assign "params" variable

// 結果の検証
if (! (Boolean)result.get('success') ) { // 失敗の場合
    Exceptiopn e = (Exceptiopn)result.get('error');
    System.debug(e.getMessage());
    return;
}
```

# 「SQL 構文メソッド」の再利用
一度の処理で複数の sObject 操作を行う場合、大きく分けて 2 つの方法がある。
## ① 各 sObject の処理ごとにクラスを呼び出す
```apex
SObjectModel mdl_1 = new SObjectModel(); // mdl_1 インスタンスの生成
mdl_1.sqlSelect('Id, Name');
List<User> user = mdl_1.sqlGet('User');

SObjectModel mdl_2 = new SObjectModel(); // mdl_2 インスタンスの生成
mdl_2.sqlSelect('Id, Name');
mdl_2.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl_2.sqlGet('Account');

SObjectModel mdl_3 = new SObjectModel(); // mdl_3 インスタンスの生成
mdl_3.sqlSelect('Id, Name');
mdl_3.sqlLimit(20);
List<Contact> con = mdl_3.sqlGet('Contact');
```

しかし、これでは変数の管理で不利な面もある。  
SQL 構文メソッドは、クエリが実行される度に初期化されるので、インスタンスの再生成は不要である。

## ② sqlGet, sqlQuery メソッドのコール後はクエリが初期化される
```apex
SObjectModel mdl = new SObjectModel(); // mdl インスタンスの生成（ここで1度だけ）

mdl.sqlSelect('Id, Name');
List<User> user = mdl.sqlGet('User'); // ここでクエリも初期化

mdl.sqlSelect('Id, Name');
mdl.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl.sqlGet('Account'); // ここでクエリも初期化

mdl.sqlSelect('Id, Name');
mdl.sqlLimit(20);
List<Contact> con = mdl.sqlGet('Contact'); // ここでクエリも初期化
```