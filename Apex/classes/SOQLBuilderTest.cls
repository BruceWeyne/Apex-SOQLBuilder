/******************************************************************************************************
* This file is part of the Apex SOQLBuilder project, released under the MIT License.                 *
* See LICENSE file or go to https://github.com/BruceWeyne/Apex-SOQLBuilder for full license details. *
******************************************************************************************************/

/**
 * Author  : BruceWeyne, Taku H.F.
 * Purpose : Unit test for SOQLBuilder class
*/
@isTest
public class SOQLBuilderTest {

    @testSetup
    static void setUpMethod() {
        // Create dummy records for Account
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 3; i++) {
            accList.add(new Account(Name = 'John' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        insert accList;
    }

    @isTest
    static void testSqlGet() {
        SOQLBuilder sb = new SOQLBuilder();

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('Id !=', '00s4h00000216cAAAA');
        sb.soqlOrWhere('Id !=', '00s4h00000216cBBBB');
        sb.soqlLimit(2);
        sb.soqlOffset(1);
        sb.soqlOrderBy('Name', 'DESC');
        sb.soqlOrderBy('NumberOfEmployees', 'ASC');
        List<Account> accList = sb.soqlGet('Account');

        List<Account> targetAccList = [
            SELECT
                Id,
                Name
            FROM
                Account
            WHERE
                Id != '00s4h00000216cAAAA'
            OR
                Id != '00s4h00000216cBBBB'
            ORDER BY Name DESC, NumberOfEmployees ASC
            LIMIT 2
            OFFSET 1
        ];

        System.assertEquals(targetAccList, accList);

        sb.soqlSelect('Id, Name');
        sb.soqlLike('Name', '%Jo%');
        sb.soqlOrLike('Name', '%hn%');
        sb.soqlLimit(3);
        List<Account> accList2 = sb.soqlGet('Account');

        List<Account> targetAccList2 = [
            SELECT
                Id,
                Name
            FROM
                Account
            WHERE
                Name LIKE '%Jo%'
            OR
                Name LIKE '%hn%'
            LIMIT 3
        ];

        System.assertEquals(targetAccList2, accList2);

        sb.soqlAllRows();
        sb.soqlSelect('COUNT(Id), Name, IsDeleted');
        sb.soqlGroupBy('Name');
        sb.soqlGroupBy('isDeleted');
        sb.soqlHaving('COUNT(Id) >', 0);
        sb.soqlHaving('Name LIKE', '%Jo%');
        sb.soqlHaving('Name', 'John1');
        sb.soqlHaving('isDeleted', false);
        List<AggregateResult> accList3 = sb.soqlGet('Account');

        List<AggregateResult> targetAccList3 = [
            SELECT
                COUNT(Id),
                Name,
                IsDeleted
            FROM
                Account
            GROUP BY Name, IsDeleted
            HAVING COUNT(Id) > 0 AND Name LIKE '%Jo%' AND Name = 'John1' AND isDeleted = false
            ALL ROWS
        ];

        System.assertEquals(targetAccList3, accList3);

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('BillingState', 'Tokyo');
        sb.soqlOrWhere('BillingCountry', 'Japan');
        List<Account> accList4 = sb.soqlGet('Account');

        List<Account> targetAccList4 = [
            SELECT
                Id,
                Name
            FROM
                Account
            WHERE
                BillingState = 'Tokyo'
            OR
                BillingCountry = 'Japan'
        ];

        System.assertEquals(targetAccList4, accList4);

        sb.soqlSelect('Id, Name, NumberOfEmployees');
        sb.soqlWhereIn('Name', '\'John1\', \'John2\', \'John3\'');
        sb.soqlWhereNotIn('NumberOfEmployees', '100, 400, 600');
        sb.soqlLimit(3);
        List<Account> accList5 = sb.soqlGet('Account');
        
        List<Account> targetAccList5 = [
            SELECT
                Id,
                Name,
                NumberOfEmployees
            FROM
                Account
            WHERE
                Name IN ('John1', 'John2', 'John3')
            AND
                NumberOfEmployees NOT IN (100, 400, 600)
            LIMIT 3
        ];

        System.assertEquals(targetAccList5, accList5);

        Set<String> whereInParam = new Set<String>{'John1', 'John2', 'John3'};
        Set<Integer> whereNotInParam = new Set<Integer>{100, 400, 600};
        sb.soqlSelect('Id, Name, NumberOfEmployees');
        sb.soqlWhereIn('Name', whereInParam);
        sb.soqlWhereNotIn('NumberOfEmployees', whereNotInParam);
        sb.soqlLimit(3);
        List<Account> accList6 = sb.soqlGet('Account');
        
        List<Account> targetAccList6 = [
            SELECT
                Id,
                Name,
                NumberOfEmployees
            FROM
                Account
            WHERE
                Name IN ('John1', 'John2', 'John3')
            AND
                NumberOfEmployees NOT IN (100, 400, 600)
            LIMIT 3
        ];

        System.assertEquals(targetAccList6, accList6);
    }

    @isTest
    static void testCreateQueryStr() {
        SOQLBuilder sb = new SOQLBuilder();

        sb.soqlSelect('*');
        sb.soqlNotLike('Name', '%Jo%');
        sb.soqlOrNotLike('Name', '%hn%');
        String query = sb.soqlQuery('UserPackageLicense');

        String targetQuery = 'SELECT Id, PackageLicenseId, UserId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM UserPackageLicense WHERE (NOT Name LIKE \'%Jo%\') OR (NOT Name LIKE \'%hn%\')';
        
        System.assertEquals(targetQuery, query);

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('Name', 'John7');
        sb.soqlWhere('NumberOfEmployees', 700);
        sb.soqlWhere('NumberOfEmployees <', 1000);
        sb.soqlWhere('NumberOfEmployees >', 0);
        String query2 = sb.soqlQuery('Account');

        String targetQuery2 = 'SELECT Id, Name FROM Account WHERE Name = \'John7\' AND NumberOfEmployees = 700 AND NumberOfEmployees < 1000 AND NumberOfEmployees > 0';

        System.assertEquals(targetQuery2, query2);

        sb.soqlSelect('Id, Name');
        sb.soqlOrWhere('Name', 'John7');
        sb.soqlOrWhere('NumberOfEmployees', 700);
        sb.soqlOrWhere('NumberOfEmployees <', 1000);
        sb.soqlOrWhere('NumberOfEmployees >', 0);
        String query3 = sb.soqlQuery('Account');

        String targetQuery3 = 'SELECT Id, Name FROM Account WHERE Name = \'John7\' OR NumberOfEmployees = 700 OR NumberOfEmployees < 1000 OR NumberOfEmployees > 0';

        System.assertEquals(targetQuery3, query3);

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('Name', 'John7');
        sb.soqlLike('Name', '%Jo%');
        sb.soqlLike('NumberOfEmployees', 700);
        String query4 = sb.soqlQuery('Account');

        String targetQuery4 = 'SELECT Id, Name FROM Account WHERE Name = \'John7\' AND Name LIKE \'%Jo%\' AND NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery4, query4);

        sb.soqlSelect('Id, Name');
        sb.soqlOrLike('Name', '%Jo%');
        sb.soqlOrLike('NumberOfEmployees', 700);
        String query5 = sb.soqlQuery('Account');

        String targetQuery5 = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%Jo%\' OR NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery5, query5);

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('Name', 'John7');
        sb.soqlNotLike('Name', '%Jo%');
        sb.soqlNotLike('NumberOfEmployees', 700);
        String query6 = sb.soqlQuery('Account');

        String targetQuery6 = 'SELECT Id, Name FROM Account WHERE Name = \'John7\' AND (NOT Name LIKE \'%Jo%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery6, query6);

        sb.soqlSelect('Id, Name');
        sb.soqlNotLike('Name', '%Jo%');
        sb.soqlNotLike('NumberOfEmployees', 700);
        String query7 = sb.soqlQuery('Account');

        String targetQuery7 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Jo%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery7, query7);

        sb.soqlSelect('Id, Name');
        sb.soqlOrNotLike('Name', '%Jo%');
        sb.soqlOrNotLike('NumberOfEmployees', 700);
        String query8 = sb.soqlQuery('Account');

        String targetQuery8 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Jo%\') OR (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery8, query8);

        sb.soqlSelect('Id, Name');
        sb.soqlWhere('Name', 'John1');
        sb.soqlWhereIn('Name', new Set<String>{'John1', 'John2', 'John3'});
        sb.soqlWhereIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query9 = sb.soqlQuery('Account');

        String targetQuery9 = 'SELECT Id, Name FROM Account WHERE Name = \'John1\' AND Name IN (\'John1\', \'John2\', \'John3\') AND NumberOfEmployees IN (100, 200, 300)';

        System.assertEquals(targetQuery9, query9);

        sb.soqlStartCache();

        sb.soqlSelect('Id, Name');
        sb.soqlWhereNotIn('Name', new Set<String>{'John1', 'John2', 'John3'});
        sb.soqlWhereNotIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query10 = sb.soqlQuery('Account');

        String targetQuery10 = 'SELECT Id, Name FROM Account WHERE Name NOT IN (\'John1\', \'John2\', \'John3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

        System.assertEquals(targetQuery10, query10);

        sb.soqlSelect('IsActive');
        String query11 = sb.soqlQuery('Account');

        String targetQuery11 = 'SELECT Id, Name, IsActive FROM Account WHERE Name NOT IN (\'John1\', \'John2\', \'John3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

        System.assertEquals(targetQuery11, query11);

        sb.clear();
    }

    @isTest
    static void testConvertToSetTypeStr() {
        Set<String> setString     = new Set<String>();
        Set<Integer> setInteger   = new Set<Integer>();
        Set<Double> setDouble     = new Set<Double>();
        Set<Long> setLong         = new Set<Long>();
        Set<Decimal> setDecimal   = new Set<Decimal>();
        Set<Boolean> setBoolean   = new Set<Boolean>();
        Set<Date> setDate         = new Set<Date>();
        Set<Datetime> setDatetime = new Set<Datetime>();
        Set<Id> setId             = new Set<Id>();
        Object invalidInput       = null;

        SOQLBuilder sb = new SOQLBuilder();

        Object targetSetString    = sb.convertToSetTypeStr(setString);
        Object targetSetInteger   = sb.convertToSetTypeStr(setInteger);
        Object targetSetDouble    = sb.convertToSetTypeStr(setDouble);
        Object targetSetLong      = sb.convertToSetTypeStr(setLong);
        Object targetSetDecimal   = sb.convertToSetTypeStr(setDecimal);
        Object targetSetBoolean   = sb.convertToSetTypeStr(setBoolean);
        Object targetSetDate      = sb.convertToSetTypeStr(setDate);
        Object targetSetDatetime  = sb.convertToSetTypeStr(setDatetime);
        Object targetSetId        = sb.convertToSetTypeStr(setId);
        Object targetInvalidInput = sb.convertToSetTypeStr(invalidInput);

        System.assert(targetSetString instanceof Set<String>);
        System.assert(targetSetInteger instanceof Set<String>);
        System.assert(targetSetDouble instanceof Set<String>);
        System.assert(targetSetLong instanceof Set<String>);
        System.assert(targetSetDecimal instanceof Set<String>);
        System.assert(targetSetBoolean instanceof Set<String>);
        System.assert(targetSetDate instanceof Set<String>);
        System.assert(targetSetDatetime instanceof Set<String>);
        System.assert(targetSetId instanceof Set<String>);
        System.assert(targetInvalidInput instanceof Set<String>);
    }

    @isTest
    static void testSqlInsert() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        Account acc = new Account();
        params.put('Name', 'John10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        result = sb.soqlInsert(acc, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.soqlSelect('Id');
        sb.soqlWhere('Name', 'John10091');
        List<Account> accList = sb.soqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'John' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        result = sb.soqlInsert(accList2, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.soqlSelect('Id');
        sb.soqlWhere('Name', 'Sisters');
        List<Account> accList3 = sb.soqlGet('Account');
        System.assertEquals(10, accList3.size());

        // Error
        Integer level = 5;
        result = sb.soqlInsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlInsertAll() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        Account acc = new Account();
        params.put('Name', 'John10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        Database.SaveResult[] srList = sb.soqlInsertAll(acc, params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        sb.soqlSelect('Id');
        sb.soqlWhere('Name', 'John10091');
        List<Account> accList = sb.soqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'John' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        Database.SaveResult[] srList2 = sb.soqlInsertAll(accList2, params);
        for (Database.SaveResult sr : srList2) {
            System.assertEquals(true, sr.isSuccess());
        }

        sb.soqlSelect('Id');
        sb.soqlWhere('Name', 'Sisters');
        List<Account> accList3 = sb.soqlGet('Account');
        System.assertEquals(10, accList3.size());
    }

    @isTest
    static void testSqlUpdate() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        sb.soqlSelect('Id');
        List<Account> accList = sb.soqlGet('Account');

        result = sb.soqlUpdate(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = sb.soqlUpdate(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Error
        Integer level = 5;
        result = sb.soqlUpdate(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlUpdateAll() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        sb.soqlSelect('Id');
        List<Account> accList = sb.soqlGet('Account');

        Database.SaveResult[] srList = sb.soqlUpdateAll(accList[0], params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        // Multiple
        Database.SaveResult[] srList2 = sb.soqlUpdateAll(accList, params);
        for (Database.SaveResult sr : srList2) {
            System.assertEquals(true, sr.isSuccess());
        }
    }

    @isTest
    static void testSqlUpsert() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        sb.soqlSelect('Id');
        List<Account> accList = sb.soqlGet('Account');

        result = sb.soqlUpsert(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = sb.soqlUpsert(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Add one
        Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
        result = sb.soqlUpsert(newAcc, null);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.soqlSelect('Id');
        sb.soqlWhere('Name', 'Last Order');
        List<Account> accList2 = sb.soqlGet('Account');
        System.assertEquals(1, accList2.size());


        // Error
        Integer level = 5;
        result = sb.soqlUpsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlDelete() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> result = new Map<String, Object>{};

        // Single
        sb.soqlSelect('Id');
        List<Account> accList = sb.soqlGet('Account');

        result = sb.soqlDelete(accList[0]);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        accList.remove(0);
        result = sb.soqlDelete(accList);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.soqlSelect('Id, Name');
        List<Account> accList2 = sb.soqlGet('Account');
        System.assertEquals(0, accList2.size());

        // Error
        Integer level = 5;
        result = sb.soqlDelete(level);
        System.assertEquals(false, (Boolean)result.get('success'));
    }


    @isTest
    static void testSetSObjParams() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};

        Account sObj = new Account();
        params = new Map<String, Object>{
            'Id'=>Id.valueOf('0051s000002MvFZAA0'),
            'Name'=>'John10021',
            'BillingCity'=>null,
            'NumberOfEmployees'=>1000
        };
        sb.setSObjParams(sObj, params);

        Account targetSObj = new Account();
        targetSObj.put('Id', Id.valueOf('0051s000002MvFZAA0'));
        targetSObj.put('Name', 'John10021');
        targetSObj.put('BillingCity', null);
        targetSObj.put('NumberOfEmployees', 1000);
 
        System.assertEquals(targetSObj, sObj);

        sb.clear();

        Asset sObj2 = new Asset();
        params = new Map<String, Object>{
            'Quantity'=>Double.valueOf('3.14159')
        };
        sb.setSObjParams(sObj2, params);

        Asset targetSObj2 = new Asset();
        targetSObj2.put('Quantity', Double.valueOf('3.14159'));

        System.assertEquals(targetSObj2, sObj2);

        sb.clear();

        User sObj3 = new User();
        params = new Map<String, Object>{
            'IsActive'=>Boolean.valueOf('true')
        };
        sb.setSObjParams(sObj3, params);

        User targetSObj3 = new User();
        targetSObj3.put('IsActive', Boolean.valueOf('true'));

        System.assertEquals(targetSObj3, sObj3);

        sb.clear();

        Holiday sObj4 = new Holiday();
        params = new Map<String, Object>{
            'ActivityDate'=>Date.today()
        };
        sb.setSObjParams(sObj4, params);

        Holiday targetSObj4 = new Holiday();
        targetSObj4.put('ActivityDate', Date.today());

        System.assertEquals(targetSObj4, sObj4);

        sb.clear();

        Datetime dt5 = Datetime.now();
        Task sObj5 = new Task();
        params = new Map<String, Object>{
            'ReminderDateTime'=>dt5
        };
        sb.setSObjParams(sObj5, params);

        Task targetSObj5 = new Task();
        targetSObj5.put('ReminderDateTime', dt5);

        System.assertEquals(targetSObj5, sObj5);
    }


} // End of the class