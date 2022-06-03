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
        SOQLBuilder mdl = new SOQLBuilder();

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('Id !=', '00s4h00000216cAAAA');
        mdl.sqlOrWhere('Id !=', '00s4h00000216cBBBB');
        mdl.sqlLimit(2);
        mdl.sqlOffset(1);
        mdl.sqlOrderBy('Name', 'DESC');
        mdl.sqlOrderBy('NumberOfEmployees', 'ASC');
        List<Account> accList = mdl.sqlGet('Account');

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

        mdl.sqlSelect('Id, Name');
        mdl.sqlLike('Name', '%Mi%');
        mdl.sqlOrLike('Name', '%saka%');
        mdl.sqlLimit(3);
        List<Account> accList2 = mdl.sqlGet('Account');

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

        mdl.sqlAllRows();
        mdl.sqlSelect('COUNT(Id), Name, IsDeleted');
        mdl.sqlGroupBy('Name');
        mdl.sqlGroupBy('isDeleted');
        mdl.sqlHaving('COUNT(Id) >', 0);
        mdl.sqlHaving('Name LIKE', '%Mi%');
        mdl.sqlHaving('Name', 'Misaka1');
        mdl.sqlHaving('isDeleted', false);
        List<AggregateResult> accList3 = mdl.sqlGet('Account');

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

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('BillingState', 'Tokyo');
        mdl.sqlOrWhere('BillingCountry', 'Japan');
        List<Account> accList4 = mdl.sqlGet('Account');

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

        mdl.sqlSelect('Id, Name, NumberOfEmployees');
        mdl.sqlWhereIn('Name', '\'Misaka1\', \'Misaka2\', \'Misaka3\'');
        mdl.sqlWhereNotIn('NumberOfEmployees', '100, 400, 600');
        mdl.sqlLimit(3);
        List<Account> accList5 = mdl.sqlGet('Account');
        
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
        mdl.sqlSelect('Id, Name, NumberOfEmployees');
        mdl.sqlWhereIn('Name', whereInParam);
        mdl.sqlWhereNotIn('NumberOfEmployees', whereNotInParam);
        mdl.sqlLimit(3);
        List<Account> accList6 = mdl.sqlGet('Account');
        
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
        SOQLBuilder mdl = new SOQLBuilder();

        mdl.sqlSelect('*');
        mdl.sqlNotLike('Name', '%Mi%');
        mdl.sqlOrNotLike('Name', '%koto%');
        String query = mdl.sqlQuery('UserPackageLicense');

        String targetQuery = 'SELECT Id, PackageLicenseId, UserId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM UserPackageLicense WHERE (NOT Name LIKE \'%Mi%\') OR (NOT Name LIKE \'%koto%\')';
        
        System.assertEquals(targetQuery, query);

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('Name', 'Misaka7');
        mdl.sqlWhere('NumberOfEmployees', 700);
        mdl.sqlWhere('NumberOfEmployees <', 1000);
        mdl.sqlWhere('NumberOfEmployees >', 0);
        String query2 = mdl.sqlQuery('Account');

        String targetQuery2 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND NumberOfEmployees = 700 AND NumberOfEmployees < 1000 AND NumberOfEmployees > 0';

        System.assertEquals(targetQuery2, query2);

        mdl.sqlSelect('Id, Name');
        mdl.sqlOrWhere('Name', 'Misaka7');
        mdl.sqlOrWhere('NumberOfEmployees', 700);
        mdl.sqlOrWhere('NumberOfEmployees <', 1000);
        mdl.sqlOrWhere('NumberOfEmployees >', 0);
        String query3 = mdl.sqlQuery('Account');

        String targetQuery3 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' OR NumberOfEmployees = 700 OR NumberOfEmployees < 1000 OR NumberOfEmployees > 0';

        System.assertEquals(targetQuery3, query3);

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('Name', 'Misaka7');
        mdl.sqlLike('Name', '%Mi%');
        mdl.sqlLike('NumberOfEmployees', 700);
        String query4 = mdl.sqlQuery('Account');

        String targetQuery4 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND Name LIKE \'%Mi%\' AND NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery4, query4);

        mdl.sqlSelect('Id, Name');
        mdl.sqlOrLike('Name', '%Mi%');
        mdl.sqlOrLike('NumberOfEmployees', 700);
        String query5 = mdl.sqlQuery('Account');

        String targetQuery5 = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%Mi%\' OR NumberOfEmployees LIKE 700';

        System.assertEquals(targetQuery5, query5);

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('Name', 'Misaka7');
        mdl.sqlNotLike('Name', '%Mi%');
        mdl.sqlNotLike('NumberOfEmployees', 700);
        String query6 = mdl.sqlQuery('Account');

        String targetQuery6 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka7\' AND (NOT Name LIKE \'%Mi%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery6, query6);

        mdl.sqlSelect('Id, Name');
        mdl.sqlNotLike('Name', '%Mi%');
        mdl.sqlNotLike('NumberOfEmployees', 700);
        String query7 = mdl.sqlQuery('Account');

        String targetQuery7 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Mi%\') AND (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery7, query7);

        mdl.sqlSelect('Id, Name');
        mdl.sqlOrNotLike('Name', '%Mi%');
        mdl.sqlOrNotLike('NumberOfEmployees', 700);
        String query8 = mdl.sqlQuery('Account');

        String targetQuery8 = 'SELECT Id, Name FROM Account WHERE (NOT Name LIKE \'%Mi%\') OR (NOT NumberOfEmployees LIKE 700)';

        System.assertEquals(targetQuery8, query8);

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhere('Name', 'Misaka1');
        mdl.sqlWhereIn('Name', new Set<String>{'Misaka1', 'Misaka2', 'Misaka3'});
        mdl.sqlWhereIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query9 = mdl.sqlQuery('Account');

        String targetQuery9 = 'SELECT Id, Name FROM Account WHERE Name = \'Misaka1\' AND Name IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees IN (100, 200, 300)';

        System.assertEquals(targetQuery9, query9);

        mdl.sqlStartCache();

        mdl.sqlSelect('Id, Name');
        mdl.sqlWhereNotIn('Name', new Set<String>{'Misaka1', 'Misaka2', 'Misaka3'});
        mdl.sqlWhereNotIn('NumberOfEmployees', new Set<Integer>{100, 200, 300});
        String query10 = mdl.sqlQuery('Account');

        String targetQuery10 = 'SELECT Id, Name FROM Account WHERE Name NOT IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

        System.assertEquals(targetQuery10, query10);

        mdl.sqlSelect('IsActive');
        String query11 = mdl.sqlQuery('Account');

        String targetQuery11 = 'SELECT Id, Name, IsActive FROM Account WHERE Name NOT IN (\'Misaka1\', \'Misaka2\', \'Misaka3\') AND NumberOfEmployees NOT IN (100, 200, 300)';

        System.assertEquals(targetQuery11, query11);

        mdl.clear();
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

        SOQLBuilder mdl = new SOQLBuilder();

        Object targetSetString    = mdl.convertToSetTypeStr(setString);
        Object targetSetInteger   = mdl.convertToSetTypeStr(setInteger);
        Object targetSetDouble    = mdl.convertToSetTypeStr(setDouble);
        Object targetSetLong      = mdl.convertToSetTypeStr(setLong);
        Object targetSetDecimal   = mdl.convertToSetTypeStr(setDecimal);
        Object targetSetBoolean   = mdl.convertToSetTypeStr(setBoolean);
        Object targetSetDate      = mdl.convertToSetTypeStr(setDate);
        Object targetSetDatetime  = mdl.convertToSetTypeStr(setDatetime);
        Object targetSetId        = mdl.convertToSetTypeStr(setId);
        Object targetInvalidInput = mdl.convertToSetTypeStr(invalidInput);

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
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        Account acc = new Account();
        params.put('Name', 'Misaka10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        result = mdl.sqlInsert(acc, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        mdl.sqlSelect('Id');
        mdl.sqlWhere('Name', 'Misaka10091');
        List<Account> accList = mdl.sqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'Misaka' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        result = mdl.sqlInsert(accList2, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        mdl.sqlSelect('Id');
        mdl.sqlWhere('Name', 'Sisters');
        List<Account> accList3 = mdl.sqlGet('Account');
        System.assertEquals(10, accList3.size());

        // Error
        Integer level = 5;
        result = mdl.sqlInsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlInsertAll() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        Account acc = new Account();
        params.put('Name', 'Misaka10091');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 10091);

        // Single
        Database.SaveResult[] srList = mdl.sqlInsertAll(acc, params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        mdl.sqlSelect('Id');
        mdl.sqlWhere('Name', 'Misaka10091');
        List<Account> accList = mdl.sqlGet('Account');
        System.assertEquals(1, accList.size());

        // Multiple
        List<Account> accList2 = new List<Account>();
        for(Integer i = 10000; i < 10010; i++) {
            accList2.add(new Account(Name = 'Misaka' + i, BillingCity = 'Academic city', BillingCountry = 'Japan', BillingState = 'Tokyo', NumberOfEmployees = i*100));
        }
        params.put('Name', 'Sisters');
        Database.SaveResult[] srList2 = mdl.sqlInsertAll(accList2, params);
        for (Database.SaveResult sr : srList2) {
            System.assertEquals(true, sr.isSuccess());
        }

        mdl.sqlSelect('Id');
        mdl.sqlWhere('Name', 'Sisters');
        List<Account> accList3 = mdl.sqlGet('Account');
        System.assertEquals(10, accList3.size());
    }

    @isTest
    static void testSqlUpdate() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        mdl.sqlSelect('Id');
        List<Account> accList = mdl.sqlGet('Account');

        result = mdl.sqlUpdate(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = mdl.sqlUpdate(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Error
        Integer level = 5;
        result = mdl.sqlUpdate(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlUpdateAll() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        mdl.sqlSelect('Id');
        List<Account> accList = mdl.sqlGet('Account');

        Database.SaveResult[] srList = mdl.sqlUpdateAll(accList[0], params);
        for (Database.SaveResult sr : srList) {
            System.assertEquals(true, sr.isSuccess());
        }

        // Multiple
        Database.SaveResult[] srList2 = mdl.sqlUpdateAll(accList, params);
        for (Database.SaveResult sr : srList2) {
            System.assertEquals(true, sr.isSuccess());
        }
    }

    @isTest
    static void testSqlUpsert() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};
        Map<String, Object> result = new Map<String, Object>{};

        params.put('Name', 'Sisters');
        params.put('BillingCity', 'Academic city');
        params.put('BillingCountry', 'Japan');
        params.put('BillingState', 'Tokyo');
        params.put('NumberOfEmployees', 20001);

        // Single
        mdl.sqlSelect('Id');
        List<Account> accList = mdl.sqlGet('Account');

        result = mdl.sqlUpsert(accList[0], params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        result = mdl.sqlUpsert(accList, params);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Add one
        Account newAcc = new Account(Name = 'Last Order', BillingCity = 'Academic city');
        result = mdl.sqlUpsert(newAcc, null);
        System.assertEquals(true, (Boolean)result.get('success'));

        mdl.sqlSelect('Id');
        mdl.sqlWhere('Name', 'Last Order');
        List<Account> accList2 = mdl.sqlGet('Account');
        System.assertEquals(1, accList2.size());


        // Error
        Integer level = 5;
        result = mdl.sqlUpsert(level, params);
        System.assertEquals(false, (Boolean)result.get('success'));
    }

    @isTest
    static void testSqlDelete() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> result = new Map<String, Object>{};

        // Single
        mdl.sqlSelect('Id');
        List<Account> accList = mdl.sqlGet('Account');

        result = mdl.sqlDelete(accList[0]);
        System.assertEquals(true, (Boolean)result.get('success'));

        // Multiple
        accList.remove(0);
        result = mdl.sqlDelete(accList);
        System.assertEquals(true, (Boolean)result.get('success'));

        mdl.sqlSelect('Id, Name');
        List<Account> accList2 = mdl.sqlGet('Account');
        System.assertEquals(0, accList2.size());

        // Error
        Integer level = 5;
        result = mdl.sqlDelete(level);
        System.assertEquals(false, (Boolean)result.get('success'));
    }


    @isTest
    static void testSetSObjParams() {
        SOQLBuilder mdl = new SOQLBuilder();
        Map<String, Object> params = new Map<String, Object>{};

        Account sObj = new Account();
        params = new Map<String, Object>{
            'Id'=>Id.valueOf('0051s000002MvFZAA0'),
            'Name'=>'Misaka10021',
            'BillingCity'=>null,
            'NumberOfEmployees'=>1000
        };
        mdl.setSObjParams(sObj, params);

        Account targetSObj = new Account();
        targetSObj.put('Id', Id.valueOf('0051s000002MvFZAA0'));
        targetSObj.put('Name', 'Misaka10021');
        targetSObj.put('BillingCity', null);
        targetSObj.put('NumberOfEmployees', 1000);
 
        System.assertEquals(targetSObj, sObj);

        mdl.clear();

        Asset sObj2 = new Asset();
        params = new Map<String, Object>{
            'Quantity'=>Double.valueOf('3.14159')
        };
        mdl.setSObjParams(sObj2, params);

        Asset targetSObj2 = new Asset();
        targetSObj2.put('Quantity', Double.valueOf('3.14159'));

        System.assertEquals(targetSObj2, sObj2);

        mdl.clear();

        User sObj3 = new User();
        params = new Map<String, Object>{
            'IsActive'=>Boolean.valueOf('true')
        };
        mdl.setSObjParams(sObj3, params);

        User targetSObj3 = new User();
        targetSObj3.put('IsActive', Boolean.valueOf('true'));

        System.assertEquals(targetSObj3, sObj3);

        mdl.clear();

        Holiday sObj4 = new Holiday();
        params = new Map<String, Object>{
            'ActivityDate'=>Date.today()
        };
        mdl.setSObjParams(sObj4, params);

        Holiday targetSObj4 = new Holiday();
        targetSObj4.put('ActivityDate', Date.today());

        System.assertEquals(targetSObj4, sObj4);

        mdl.clear();

        Datetime dt5 = Datetime.now();
        Task sObj5 = new Task();
        params = new Map<String, Object>{
            'ReminderDateTime'=>dt5
        };
        mdl.setSObjParams(sObj5, params);

        Task targetSObj5 = new Task();
        targetSObj5.put('ReminderDateTime', dt5);

        System.assertEquals(targetSObj5, sObj5);
    }


} // End of the class