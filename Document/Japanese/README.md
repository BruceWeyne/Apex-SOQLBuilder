ドキュメント
===

# 目次
- [クラスの呼び出し（インスタンスの生成）](#クラスの呼び出しインスタンスの生成)
- [SOQL 構文メソッド（レコード取得）](#SOQL-構文メソッド)
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
    - [SOQL 構文キャッシュメソッド](#SOQL-構文キャッシュメソッド)
    - [SOQL 構文の初期化メソッド](#SOQL-構文の初期化メソッド)
    - [★SOQL 構文の実行（レコードの取得）メソッド](#SOQL-構文の実行レコードの取得メソッド)
    - [★SOQL 構文のクエリ生成メソッド](#SOQL-構文のクエリ生成メソッド)
- [DML 操作メソッド（レコード操作）](#DML-操作メソッド)
    - [Insert（挿入）処理](#insert挿入処理)
    - [Insert All（一括挿入）処理](#Insert-All一括挿入処理)
    - [Update（更新）処理](#update更新処理)
    - [Update All（一括更新）処理](#Update-All一括更新処理)
    - [Upsert（更新 / 挿入）処理](#upsert更新--挿入処理)
    - [Delete（削除）処理](#delete削除処理)

# クラスの呼び出し（インスタンスの生成）
```apex
SOQLBuilder bld = new SOQLBuilder(); // 変数名は任意、ここでは bld
```

# SOQL 構文メソッド
インスタンス生成後に使用できるメソッドとして、「SOQL 構文メソッド」を用意した。  
これらは、sObject からレコードを取得するためのメソッドである。

## SELECT 構文メソッド
```apex
bld.soqlSelect(fieldName);
```

使用例
```apex
bld.soqlSelect('Id, Name, IsActive');

// または

bld.soqlSelect('Id');
bld.soqlSelect('Name');
bld.soqlSelect('IsActive');

// 上記のようにメソッドをコールすると、以下の SELECT 句の生成が予約される
// SELECT Id, Name, IsActive
```

## WHERE 構文メソッド
```apex
bld.soqlWhere(fieldName, fieldValue);
```

使用例 - 1
```apex
bld.soqlWhere('Id', '00s4h00000216cCDXW');

// 上記のようにメソッドをコールすると、以下の WHERE 句の生成が予約される
// WHERE Id = '00s4h00000216cCDXW'
```

```apex
bld.soqlWhere('Id !=', '00s4h00000216cCDXW');

// キー名に比較演算子を含めることも可能（キー名と比較演算子の間にスペース必須）
// WHERE Id != '00s4h00000216cCDXW'
```

使用例 - 2
```apex
bld.soqlWhere('Name', '御坂 美琴');
bld.soqlWhere('IsActive', true);

// 複数回コールすると AND 接続となる
// WHERE Name = '御坂 美琴' AND IsActive = true
```

## OR WHERE 構文メソッド
```apex
bld.soqlOrWhere(fieldName, fieldValue);
```

使用例
```apex
bld.soqlWhere('Name', '御坂 美琴');
bld.soqlOrWhere('IsActive', false);
bld.soqlOrWhere('Email !=', 'kuroko.shirai@tokiwa.ac.jp');

// WHERE Name = '御坂 美琴' OR IsActive = false OR Email != 'kuroko.shirai@tokiwa.ac.jp'
```

## LIKE 構文メソッド
```apex
bld.soqlLike(fieldName, fieldValue);
```

使用例 - 1
```apex
bld.soqlLike('Name', '%御坂%');

// 上記のようにメソッドをコールすると、以下の LIKE 句の生成が予約される
// WHERE Name LIKE %御坂%;
```

使用例 - 2
```apex
bld.soqlLike('Name', '%御坂%');
bld.soqlLike('Name', '%琴%');

// 複数回コールすると AND 接続となる
// WHERE Name LIKE %御坂% AND LIKE %琴%;
```

## OR LIKE 構文メソッド
```apex
bld.soqlOrLike(fieldName, fieldValue);
```

使用例
```apex
bld.soqlLike('Name', '%御坂%');
bld.soqlOrLike('Name', '%琴%');

// WHERE Name LIKE %御坂% OR LIKE %琴%;
```

## NOT LIKE 構文メソッド
```apex
bld.soqlNotLike(fieldName, fieldValue);
```

使用例 - 1
```apex
bld.soqlNotLike('Name', '%白井%');

// 上記のようにメソッドをコールすると、以下の NOT LIKE 句の生成が予約される
// WHERE NOT Name LIKE %白井%;
```

使用例 - 2
```apex
bld.soqlNotLike('Name', '%白井%');
bld.soqlNotLike('Name', '%黒%');

// 複数回コールすると AND 接続となる
// WHERE (NOT Name LIKE %白井%) AND (NOT LIKE %黒%);
```

## OR NOT LIKE 構文メソッド
```apex
bld.soqlOrNotLike(fieldName, fieldValue);
```

使用例
```apex
bld.soqlLike('Name', '%御坂%');
bld.soqlOrNotLike('Name', '%白井%');

// WHERE Name LIKE %御坂% OR (NOT LIKE %白井%);
```

## WHERE IN 構文メソッド
```apex
bld.soqlWhereIn(fieldName, fieldValue); // fieldValue は Set 型でも可
```

使用例
```apex
bld.soqlWhereIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // String 型の値の場合はエスケープ必要

// または

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
bld.soqlWhereIn('Id', param);

// 上記のようにメソッドをコールすると、以下の WHERE IN 句の生成が予約される
// WHERE Id IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## WHERE NOT IN 構文メソッド
```apex
bld.soqlWhereNotIn(fieldName, fieldValue); // fieldValue は Set 型でも可
```

使用例
```apex
bld.soqlWhereNotIn('Id', '\'00s4h00000216cCDXW\', \'00s5h00000336cFSRH\', \'00s7h00000686cJYZC\''); // String 型の値の場合はエスケープ必要

// または

Set<String> param = new Set<String>{'00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC'};
bld.soqlWhereNotIn('Id', param);

// 上記のようにメソッドをコールすると、以下の WHERE NOT IN 句の生成が予約される
// WHERE Id NOT IN ('00s4h00000216cCDXW', '00s5h00000336cFSRH', '00s7h00000686cJYZC')
```

## LIMIT 構文メソッド
```apex
bld.soqlLimit(limitValue);
```

使用例
```apex
bld.soqlLimit(300);

// 上記のようにメソッドをコールすると、以下の LIMIT 句の生成が予約される
// LIMIT 300
```

## OFFSET 構文メソッド
```apex
bld.soqlOffset(offsetValue);
```

```apex
bld.soqlOffset(100);

// 上記のようにメソッドをコールすると、以下の OFFSET 句の生成が予約される
// OFFSET 100
```

## ORDER BY 構文メソッド
```apex
bld.soqlOrderBy(fieldName, sortCondition);
```

使用例
```apex
bld.soqlOrderBy('Name', 'DESC');
bld.soqlOrderBy('Id', 'ASC');

// 上記のようにメソッドをコールすると、以下の OEDER BY 句の生成が予約される
// ORDER BY Name DESC, Id ASC
```

## GROUP BY 構文メソッド
```apex
bld.soqlGroupBy(fieldName);
```

使用例 - 1
```apex
bld.soqlGroupBy('Name');
bld.soqlGroupBy('IsActive');

// 上記のようにメソッドをコールすると、以下の GROUP BY 句の生成が予約される
// GROUP BY Name, IsActive;
```

使用例 - 2
```apex
bld.soqlSelect('COUNT(Id), IsActive');
bld.soqlGroupBy('IsActive');
List<AggregateResult> userGroup = bld.soqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<AggregateResult> userGroup = [SELECT COUNT(Id), IsActive FROM User GROUP BY IsActive];
```

## HAVING 構文メソッド
```apex
bld.soqlHaving(fieldName, fieldValue);
```

使用例 - 1
```apex
bld.soqlHaving('COUNT(Id)', 3);

// 上記のようにメソッドをコールすると、以下の HAVING 句の生成が予約される
// HAVING COUNT(Id) = 3
```

```apex
bld.soqlHaving('Name LIKE', '%御坂%');

// キー名に比較演算子を含めることも可能（キー名と比較演算子の間にスペース必須）
// HAVING Name LIKE '%御坂%'
```

使用例 - 2
```apex
bld.soqlHaving('COUNT(Id) >', 3);
bld.soqlHaving('Name LIKE', '%御坂%');

// 複数回コールすると AND 接続となる
// HAVING COUNT(Id) > 3 AND Name = '%御坂%'
```

使用例 - 3
```apex
bld.soqlSelect('COUNT(Id), Name, IsActive');
bld.soqlGroupBy('IsActive');
bld.soqlHaving('COUNT(Id) >', 3);
bld.soqlHaving('Name LIKE', '%御坂%');
List<AggregateResult> userGroup = bld.soqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<AggregateResult> userGroup = [SELECT COUNT(Id), Name, IsActive FROM User GROUP BY IsActive HAVING COUNT(Id) > 3 AND Name = '%御坂%'];
```

## ALL ROWS 構文メソッド
```apex
bld.soqlAllRows();
```

使用例
```apex
bld.soqlAllRows();
bld.soqlSelect('Id, Name, IsDeleted');
bld.soqlWhere('IsDeleted', true);
List<User> userList = bld.soqlGet('User');

// 上記のメソッドコールは下記の処理と同様
// List<User> userList = [SELECT Id, Name, IsDeleted FROM User WHERE IsDeleted = true ALL ROWS];
```

## SOQL 構文キャッシュメソッド
```apex
bld.soqlStartCache();
```
sqlGet, sqlQuery メソッドがコールされても、クエリを初期化せず保持する設定に切り替えられる。  
リセットする場合は clear メソッドをコールする。

使用例
```apex
bld.soqlStartCache(); // クエリキャッシュの保持スタート

bld.soqlSelect('Id, Name');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

bld.soqlSelect('IsActive');
bld.soqlWhere('IsActive', true);
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive = true];

bld.clear(); // ここでリセット

bld.soqlSelect('IsDeleted');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT IsDeleted FROM User];
```

## SOQL 構文の初期化メソッド
```apex
bld.clear();
```
クエリのリセットメソッド。  
コンストラクタでもこのメソッドを呼び出している。  
sqlStartCache メソッドと共に用いる。  

使用例
```apex
bld.soqlStartCache(); // クエリキャッシュの保持スタート

bld.soqlSelect('Id, Name');
List<User> userList = bld.soqlGet('User'); // List<User> userList = [SELECT Id, Name FROM User];

bld.clear(); // ここでリセット

bld.soqlSelect('IsDeleted');
List<Account> accList = bld.soqlGet('Account'); // List<Account> accList = [SELECT IsDeleted FROM Account];
```

## ★SOQL 構文の実行（レコードの取得）メソッド
上述までの SOQL 構文メソッドは SOQL クエリ構築のための予約であり、それ単体ではクエリは実行されない。  
この sqlGet メソッドを最後にコールすることで、SOQL 構文メソッドにより構築されたクエリが実行され、レコードのリストが返却される。

```apex
bld.soqlGet(sObjectName);
```

使用例
```apex
List<Account> accList = bld.soqlGet('Account');

// 上記のメソッドコールは下記の処理と同様
// 「*」はこの例における便宜上で、実際はすべてのフィールドが羅列される
// List<Account> queryList = [SELECT * FROM Account];
```

## ★SOQL 構文のクエリ生成メソッド
sqlGet メソッドと同様に、この sqlQuery メソッドを最後にコールすることで、SOQL 構文メソッドにより構築されたクエリが生成され、そのクエリ文字列が返却される。<注意> このメソッドではクエリは実行されない！

```apex
bld.soqlQuery(sObjectName);
```

使用例
```apex
bld.soqlSelect('Id, Name');
bld.soqlWhere('NumberOfEmployees >', 100);
String query = bld.soqlQuery('Account');

// 上記のメソッドコールは下記の処理と同様
// String query = 'SELECT Id, Name FROM Account WHERE NumberOfEmployees > 100';
```

# DML 操作メソッド
sObject のレコードを操作するメソッド。

## Insert（挿入）処理
```apex
bld.soqlInsert(sObjectCollection, params);
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

result = bld.soqlInsert(acc, params);

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Insert All（一括挿入）処理
上述の sqlInsert メソッドでも一括で挿入する処理は可能だが、このメソッドでは一部のレコードが失敗しても、残りのレコードに対して DML 操作を正常に完了できる。基盤の機能は Database.insert() の第二引数が false の場合を活用している。

```apex
bld.soqlInsertAll(sObjectCollection, params);
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

srList = bld.soqlInsertAll(accList, params);
```

使用例 - 2
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

## Update（更新）処理
```apex
bld.soqlUpdate(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容|

使用例 - 1
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

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Update All（一括更新）処理
上述の sqlUpdate メソッドでも一括で更新する処理は可能だが、このメソッドでは一部のレコードが失敗しても、残りのレコードに対して DML 操作を正常に完了できる。基盤の機能は Database.update() の第二引数が false の場合を活用している。

```apex
bld.soqlUpdateAll(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容, Null許容|

使用例 - 1
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

使用例 - 2
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

## Upsert（更新 / 挿入）処理
```apex
bld.soqlUpsert(sObjectCollection, params);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|
|第二|params|Map<String, Object>|sObject レコードフィールドと値の対応付け, Null 許容, Null 値許容|

使用例 - 1
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

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

## Delete（削除）処理
```apex
bld.soqlDelete(sObjectCollection);
```

|引数|名称|型|説明|
|-|-|-|-|
|第一|sObjectCollection|sObject / List\<sObject>|sObject または sObject のリスト|

使用例 - 1
```apex
Map<String, Object> result = new Map<String, Object>{};

bld.soqlSelect('Id');
List<Account> accList = bld.soqlGet('Account');

result = bld.soqlDelete(accList);

// 成功時の result 値
{
    'success': true, // Boolean
    'error': null    // Exception
}
```

使用例 - 2
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

# 「SOQL 構文メソッド」の再利用
一度の処理で複数の sObject 操作を行う場合、大きく分けて 2 つの方法がある。
## ① 各 sObject の処理ごとにクラスを呼び出す
```apex
SOQLBuilder mdl_1 = new SOQLBuilder(); // mdl_1 インスタンスの生成
mdl_1.sqlSelect('Id, Name');
List<User> user = mdl_1.sqlGet('User');

SOQLBuilder mdl_2 = new SOQLBuilder(); // mdl_2 インスタンスの生成
mdl_2.sqlSelect('Id, Name');
mdl_2.sqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = mdl_2.sqlGet('Account');

SOQLBuilder mdl_3 = new SOQLBuilder(); // mdl_3 インスタンスの生成
mdl_3.sqlSelect('Id, Name');
mdl_3.sqlLimit(20);
List<Contact> con = mdl_3.sqlGet('Contact');
```

しかし、これでは変数の管理で不利な面もある。  
SOQL 構文メソッドは、クエリが実行される度に初期化されるので、インスタンスの再生成は不要である。

## ② sqlGet, sqlQuery メソッドのコール後はクエリが初期化される
```apex
SOQLBuilder bld = new SOQLBuilder(); // bld インスタンスの生成（ここで1度だけ）

bld.soqlSelect('Id, Name');
List<User> user = bld.soqlGet('User'); // ここでクエリも初期化

bld.soqlSelect('Id, Name');
bld.soqlWhere('Id', '00s4h00000216cCDXW');
List<Account> acc = bld.soqlGet('Account'); // ここでクエリも初期化

bld.soqlSelect('Id, Name');
bld.soqlLimit(20);
List<Contact> con = bld.soqlGet('Contact'); // ここでクエリも初期化
```