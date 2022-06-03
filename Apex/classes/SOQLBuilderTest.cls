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
            accList.add(new Account(Name = 'Misaka' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        insert accList;
    }

    @isTest
    static void testSqlGet() {
        SOQLBuilder sb = new SOQLBuilder();

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('Id !=', '00s4h00000216cAAAA');
        sb.sqlOrWhere('Id !=', '00s4h00000216cBBBB');
        sb.sqlLimit(2);
        sb.sqlOffset(1);
        sb.sqlOrderBy('Name', 'DESC');
        sb.sqlOrderBy('NumberOfEmployees', 'ASC');
        List<Account> accList = sb.sqlGet('Account');

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

        sb.sqlSelect('Id, Name');
        sb.sqlLike('Name', '%Mi%');
        sb.sqlOrLike('Name', '%saka%');
        sb.sqlLimit(3);
        List<Account> accList2 = sb.sqlGet('Account');

        List<Account> targetAccList2 = [
            SELECT
                Id,
                Name
            FROM
                Account
            WHERE
                Name LIKE '%Mi%'
            OR
                Name LIKE '%saka%'
            LIMIT 3
        ];

        System.assertEquals(targetAccList2, accList2);

        sb.sqlAllRows();
        sb.sqlSelect('COUNT(Id), Name, IsDeleted');
        sb.sqlGroupBy('Name');
        sb.sqlGroupBy('isDeleted');
        sb.sqlHaving('COUNT(Id) >', 0);
        sb.sqlHaving('Name LIKE', '%Mi%');
        sb.sqlHaving('Name', 'Misaka1');
        sb.sqlHaving('isDeleted', false);
        List<AggregateResult> accList3 = sb.sqlGet('Account');

        List<AggregateResult> targetAccList3 = [
            SELECT
                COUNT(Id),
                Name,
                IsDeleted
            FROM
                Account
            GROUP BY Name, IsDeleted
            HAVING COUNT(Id) > 0 AND Name LIKE '%Mi%' AND Name = 'Misaka1' AND isDeleted = false
            ALL ROWS
        ];

        System.assertEquals(targetAccList3, accList3);

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('BillingState', 'Tokyo');
        sb.sqlOrWhere('BillingCountry', 'Japan');
        List<Account> accList4 = sb.sqlGet('Account');

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

        sb.sqlSelect('Id, Name, NumberOfEmployees');
        sb.sqlWhereIn('Name', '\'Misaka1\', \'Misaka2\', \'Misaka3\'');
        sb.sqlWhereNotIn('NumberOfEmployees', '100, 400, 600');
        sb.sqlLimit(3);
        List<Account> accList5 = sb.sqlGet('Account');
        
        List<Account> targetAccList5 = [
            SELECT
                Id,
                Name,
                NumberOfEmployees
            FROM
                Account
            WHERE
                Name IN ('Misaka1', 'Misaka2', 'Misaka3')
            AND
                NumberOfEmployees NOT IN (100, 400, 600)
            LIMIT 3
        ];

        System.assertEquals(targetAccList5, accList5);

        Set<String> whereInParam = new Set<String>{'Misaka1', 'Misaka2', 'Misaka3'};
        Set<Integer> whereNotInParam = new Set<Integer>{100, 400, 600};
        sb.sqlSelect('Id, Name, NumberOfEmployees');
        sb.sqlWhereIn('Name', whereInParam);
        sb.sqlWhereNotIn('NumberOfEmployees', whereNotInParam);
        sb.sqlLimit(3);
        List<Account> accList6 = sb.sqlGet('Account');
        
        List<Account> targetAccList6 = [
            SELECT
                Id,
                Name,
                NumberOfEmployees
            FROM
                Account
            WHERE
                Name IN ('Misaka1', 'Misaka2', 'Misaka3')
            AND
                NumberOfEmployees NOT IN (100, 400, 600)
            LIMIT 3
        ];

        System.assertEquals(targetAccList6, accList6);
    }

    @isTest
    static void testCreateQueryStr() {
        SOQLBuilder sb = new SOQLBuilder();

        sb.sqlSelect('*');
        sb.sqlNotLike('Name', '%Mi%');
        sb.sqlOrNotLike('Name', '%koto%');
        String query = sb.sqlQuery('UserPackageLicense');

        String targetQuery = 'SELECT Id, PackageLicenseId, UserId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM UserPackageLicense WHERE (NOT Name LIKE \'%Mi%\') OR (NOT Name LIKE \'%koto%\')';
        
        System.assertEquals(targetQuery, query);

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('Name', 'Misaka7');
        sb.sqlWhere('NumberOfEmployees', 700);
        sb.sqlWhere('NumberOfEmployees <', 1000);
        sb.sqlWhere('NumberOfEmployees >', 0);
        String query2 = sb.sqlQuery('Account');

        String targetQuery2 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND NumberOfEmployees = 700 AND NumberOfEmployees < 1000 AND NumberOfEmployees > 0';

        System.assertEquals(targetQuery2, query2);

        sb.sqlSelect('Id, Name');
        sb.sqlOrWhere('Name', 'Misaka7');
        sb.sqlOrWhere('NumberOfEmployees', 700);
        sb.sqlOrWhere('NumberOfEmployees <', 1000);
        sb.sqlOrWhere('NumberOfEmployees >', 0);
        String query3 = sb.sqlQuery('Account');

        String targetQuery3 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' OR NumberOfEmployees = 700 OR NumberOfEmployees < 1000 OR NumberOfEmployees > 0';

        System.assertEquals(targetQuery3, query3);

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('Name', 'Misaka7');
        sb.sqlLike('Name', '%Mi%');
        sb.sqlLike('NumberOfEmployees', 700);
        String query4 = sb.sqlQuery('Account');

        String targetQuery4 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND Name LIKE \'%Mi%\' AND NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery4, query4);

        sb.sqlSelect('Id, Name');
        sb.sqlOrLike('Name', '%Mi%');
        sb.sqlOrLike('NumberOfEmployees', 700);
        String query5 = sb.sqlQuery('Account');

        String targetQuery5 = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%Mi%\' OR NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery5, query5);

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('Name', 'Misaka7');
        sb.sqlNotLike('Name', '%Mi%');
        sb.sqlNotLike('NumberOfEmployees', 700);
        String query6 = sb.sqlQuery('Account');

        String targetQuery6 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND (NOT Name LIKE \'%Mi%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery6, query6);

        sb.sqlSelect('Id, Name');
        sb.sqlNotLike('Name', '%Mi%');
        sb.sqlNotLike('NumberOfEmployees', 700);
        String query7 = sb.sqlQuery('Account');

        String targetQuery7 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Mi%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery7, query7);

        sb.sqlSelect('Id, Name');
        sb.sqlOrNotLike('Name', '%Mi%');
        sb.sqlOrNotLike('NumberOfEmployees', 700);
        String query8 = sb.sqlQuery('Account');

        String targetQuery8 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Mi%\') OR (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery8, query8);

        sb.sqlSelect('Id, Name');
        sb.sqlWhere('Name', 'Misaka1');
        sb.sqlWhereIn('Name', new Set<String>{'Misaka1', 'Misaka2', 'Misaka3'});
        sb.sqlWhereIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query9 = sb.sqlQuery('Account');

        String targetQuery9 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka1\' AND Name IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees IN (100, 200, 300)';

        System.assertEquals(targetQuery9, query9);

        sb.sqlStartCache();

        sb.sqlSelect('Id, Name');
        sb.sqlWhereNotIn('Name', new Set<String>{'Misaka1', 'Misaka2', 'Misaka3'});
        sb.sqlWhereNotIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query10 = sb.sqlQuery('Account');

        String targetQuery10 = 'SELECT Id, Name FROM Account WHERE Name NOT IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

        System.assertEquals(targetQuery10, query10);

        sb.sqlSelect('IsActive');
        String query11 = sb.sqlQuery('Account');

        String targetQuery11 = 'SELECT Id, Name, IsActive FROM Account WHERE Name NOT IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

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
        params.put('Name', 'Misaka10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        result = sb.sqlInsert(acc, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.sqlSelect('Id');
        sb.sqlWhere('Name', 'Misaka10091');
        List<Account> accList = sb.sqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'Misaka' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        result = sb.sqlInsert(accList2, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.sqlSelect('Id');
        sb.sqlWhere('Name', 'Sisters');
        List<Account> accList3 = sb.sqlGet('Account');
        System.assertEquals(10, accList3.size());

        // Error
        Integer level = 5;
        result = sb.sqlInsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlInsertAll() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        Account acc = new Account();
        params.put('Name', 'Misaka10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        Database.SaveResult[] srList = sb.sqlInsertAll(acc, params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        sb.sqlSelect('Id');
        sb.sqlWhere('Name', 'Misaka10091');
        List<Account> accList = sb.sqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'Misaka' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        Database.SaveResult[] srList2 = sb.sqlInsertAll(accList2, params);
        for (Database.SaveResult sr : srList2) {
            System.assertEquals(true, sr.isSuccess());
        }

        sb.sqlSelect('Id');
        sb.sqlWhere('Name', 'Sisters');
        List<Account> accList3 = sb.sqlGet('Account');
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
        sb.sqlSelect('Id');
        List<Account> accList = sb.sqlGet('Account');

        result = sb.sqlUpdate(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = sb.sqlUpdate(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Error
        Integer level = 5;
        result = sb.sqlUpdate(level, params);
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
        sb.sqlSelect('Id');
        List<Account> accList = sb.sqlGet('Account');

        Database.SaveResult[] srList = sb.sqlUpdateAll(accList[0], params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        // Multiple
        Database.SaveResult[] srList2 = sb.sqlUpdateAll(accList, params);
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
        sb.sqlSelect('Id');
        List<Account> accList = sb.sqlGet('Account');

        result = sb.sqlUpsert(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = sb.sqlUpsert(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Add one
        Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
        result = sb.sqlUpsert(newAcc, null);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.sqlSelect('Id');
        sb.sqlWhere('Name', 'Last Order');
        List<Account> accList2 = sb.sqlGet('Account');
        System.assertEquals(1, accList2.size());


        // Error
        Integer level = 5;
        result = sb.sqlUpsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlDelete() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> result = new Map<String, Object>{};

        // Single
        sb.sqlSelect('Id');
        List<Account> accList = sb.sqlGet('Account');

        result = sb.sqlDelete(accList[0]);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        accList.remove(0);
        result = sb.sqlDelete(accList);
        System.assertEquals(true, (Boolean)result.get('success'));

        sb.sqlSelect('Id, Name');
        List<Account> accList2 = sb.sqlGet('Account');
        System.assertEquals(0, accList2.size());

        // Error
        Integer level = 5;
        result = sb.sqlDelete(level);
        System.assertEquals(false, (Boolean)result.get('success'));
    }


    @isTest
    static void testSetSObjParams() {
        SOQLBuilder sb = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};

        Account sObj = new Account();
        params = new Map<String, Object>{
            'Id'=>Id.valueOf('0051s000002MvFZAA0'),
            'Name'=>'Misaka10021',
            'BillingCity'=>null,
            'NumberOfEmployees'=>1000
        };
        sb.setSObjParams(sObj, params);

        Account targetSObj = new Account();
        targetSObj.put('Id', Id.valueOf('0051s000002MvFZAA0'));
        targetSObj.put('Name', 'Misaka10021');
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