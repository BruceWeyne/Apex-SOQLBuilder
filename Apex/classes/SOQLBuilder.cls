/******************************************************************************************************
* This file is part of the Apex SOQLBuilder project, released under the MIT License.                 *
* See LICENSE file or go to https://github.com/BruceWeyne/Apex-SOQLBuilder for full license details. *
******************************************************************************************************/

/**
 * Author  : BruceWeyne, Taku H.F.
 * Purpose : Model feature to handle DML Operation of sObject
*/

/**
 * /////////////////////////////
 *  Example for use of "SQL Construction" Methods
 * /////////////////////////////
 * SOQLBuilder sb = new SOQLBuilder();
 * sb.sqlSelect('Id');
 * sb.sqlSelect('Name'); // Also can be used like "sb.sqlSelect('Id, Name')" in a line
 * sb.sqlWhere('IsDeleted', false);
 * sb.sqlLike('Name', '%John%'); // In this case, "WHERE" clause will be concatenated with "AND"
 * sb.sqlOrderBy('Name DESC');
 * sb.sqlLimit(300);
 * sb.sqlOffset(100);
 * List<Account> acc = sb.sqlGet('Account'); // Query constructed above ends up executed here, and it returns data of List<sObject> type
 *
 * Scripts above is completely the same as following,
 * List<Account> acc = [SELECT Id, Name From Account WHERE IsDeleted = false AND Name LIKE '%John%' ORDER BY Name DESC LIMIT 300 OFFSET 100];
 */

public class SOQLBuilder {
    private List<Map<String, Object>> sqlWhereMapList;
    private List<Map<String, Object>> sqlOrWhereMapList;
    private List<Map<String, Object>> sqlLikeMapList;
    private List<Map<String, Object>> sqlOrLikeMapList;
    private List<Map<String, Object>> sqlNotLikeMapList;
    private List<Map<String, Object>> sqlOrNotLikeMapList;
    private List<Map<String, Object>> sqlHavingMapList;
    private Map<String, Object> sqlWhereInMap;
    private Map<String, Object> sqlWhereNotInMap;
    private Map<String, String> sqlOrderbyMap;
    private Set<String> sqlFieldSet;
    private Set<String> sqlGroupbySet;
    private Integer sqlLimitVal;
    private Integer sqlOffsetVal;
    private Boolean sqlIsAllRows;
    private Boolean sqlIsCache;
    private Boolean sqlDebugWhenExecuted;

    // Constructor
    public SOQLBuilder() {
        this.clear();
        sqlDebugWhenExecuted = false; // true: Query is debugged on the Developer Console's Log EVERY TIME executed | false: Not debugged
    }

    /**
     * Initialize common variables
     * @return void
     * [NOTE] Use this method to construct query from the start
     */
    public void clear() {
        sqlFieldSet         = new Set<String>();
        sqlWhereMapList     = new List<Map<String, Object>>{};
        sqlOrWhereMapList   = new List<Map<String, Object>>{};
        sqlLikeMapList      = new List<Map<String, Object>>{};
        sqlOrLikeMapList    = new List<Map<String, Object>>{};
        sqlNotLikeMapList   = new List<Map<String, Object>>{};
        sqlOrNotLikeMapList = new List<Map<String, Object>>{};
        sqlHavingMapList    = new List<Map<String, Object>>{};
        sqlWhereInMap       = new Map<String, Object>{};
        sqlWhereNotInMap    = new Map<String, Object>{};
        sqlOrderbyMap       = new Map<String, String>{};
        sqlGroupbySet       = new Set<String>();
        sqlLimitVal         = null;
        sqlOffsetVal        = null;
        sqlIsAllRows        = null;
        sqlIsCache          = false;
    }

    /**
     * SQL SELECT Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name] --- It is possible to get all fields of a sObject when set "*"
     * @return void
     * [NOTE] Also can call this method more than once to select multiple fields
     */
    public void sqlSelect(String fieldName) {
        if (fieldName == '*') {  // Other previous fields will be removed when "*" is set
            sqlFieldSet.clear();
            sqlFieldSet.add(fieldName);
        } else if (!sqlFieldSet.contains('*')) { // New field can only be set without "*" in current field Set
            sqlFieldSet.add(fieldName);
        }
    }

    /**
     * SQL WHERE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlWhere(String fieldName, Object fieldValue) {
        Map<String, Object> sqlWhereMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // fieldName key will only be added when valid
            sqlWhereMap.put(fieldName, fieldValue);
            sqlWhereMapList.add(sqlWhereMap);
        }
    }

    /**
     * SQL OR WHERE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "OR"
     */
    public void sqlOrWhere(String fieldName, Object fieldValue) {
        Map<String, Object> sqlOrWhereMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // fieldName key will only be added when valid
            sqlOrWhereMap.put(fieldName, fieldValue);
            sqlOrWhereMapList.add(sqlOrWhereMap);
        }
    }

    /**
     * SQL LIKE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlLike(String fieldName, Object fieldValue) {
        Map<String, Object> sqlLikeMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // fieldName key will only be added when valid
            sqlLikeMap.put(fieldName, fieldValue);
            sqlLikeMapList.add(sqlLikeMap);
        }
    }

    /**
     * SQL OR LIKE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "OR"
     */
    public void sqlOrLike(String fieldName, Object fieldValue) {
        Map<String, Object> sqlOrLikeMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // fieldName key will only be added when valid
            sqlOrLikeMap.put(fieldName, fieldValue);
            sqlOrLikeMapList.add(sqlOrLikeMap);
        }
    }

    /**
     * SQL NOT LIKE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlNotLike(String fieldName, Object fieldValue) {
        Map<String, Object> sqlNotLikeMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // fieldName key will only be added when valid
            sqlNotLikeMap.put(fieldName, fieldValue);
            sqlNotLikeMapList.add(sqlNotLikeMap);
        }
    }

    /**
     * SQL OR NOT LIKE Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "OR"
     */
    public void sqlOrNotLike(String fieldName, Object fieldValue) {
        Map<String, Object> sqlOrNotLikeMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // // fieldName key will only be added when valid
            sqlOrNotLikeMap.put(fieldName, fieldValue);
            sqlOrNotLikeMapList.add(sqlOrNotLikeMap);
        }
    }

    /**
     * SQL WHERE IN Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlWhereIn(String fieldName, Object fieldValue) {
        if (String.isNotBlank(fieldName)) { // // fieldName key will only be added when valid
            sqlWhereInMap.put(fieldName, fieldValue);
        }
    }

    /**
     * SQL WHERE NOT IN Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlWhereNotIn(String fieldName, Object fieldValue) {
        if (String.isNotBlank(fieldName)) { // // fieldName key will only be added when valid
            sqlWhereNotInMap.put(fieldName, fieldValue);
        }
    }

    /**
     * SQL LIMIT Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {Integer} limitVal [Maximum number of rows to get sObject records]
     * @return void
     *[NOTE] Condition will be override when this meheod is called more than once
     */
    public void sqlLimit(Integer limitVal) {
        if (limitVal != null) {
            sqlLimitVal = limitVal;
        }
    }

    /**
     * SQL LIMIT Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {Integer} offsetVal [Start number of record row position to get sObject records]
     * @return void
     *[NOTE] Condition will be override when this meheod is called more than once
     */
    public void sqlOffset(Integer offsetVal) {
        if (offsetVal != null) {
            sqlOffsetVal = offsetVal;
        }
    }

    /**
     * SQL WHERE IN Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {String} sortName [Sort Type] ASC, DESC, NULLS FIRST, NULLS LAST
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by comma ","
     */
    public void sqlOrderBy(String fieldName, String sortName) {
        if (String.isNotBlank(fieldName)) { // // fieldName key will only be added when valid
            sqlOrderbyMap.put(fieldName, sortName);
        }
    }

    /**
     * SQL GROUP BY Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} orderbyStr [sObject Field Name]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by comma ","
     */
    public void sqlGroupBy(String fieldName) {
        if (String.isNotBlank(fieldName)) { // 値が有効な値の場合のみ追加
            sqlGroupbySet.add(fieldName);
        }
    }


    /**
     * SQL HAVING Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param {String} fieldName [sObject Field Name]
     * @param {Object} fieldValue [sObject Field Value]
     * @return void
     * [NOTE] Also can call this method more than once to add more conditions, which are concatinated by "AND"
     */
    public void sqlHaving(String fieldName, Object fieldValue) {
        Map<String, Object> sqlHavingMap = new Map<String, Object>{};
        if (String.isNotBlank(fieldName)) { // // fieldName key will only be added when valid
            sqlHavingMap.put(fieldName, fieldValue);
            sqlHavingMapList.add(sqlHavingMap);
        }
    }

    /**
     * SQL ALL ROWS Construction :To be used with "sqlGet" or "sqlQuery" method
     * @param NONE
     * @return void
     * [NOTE] "ALL ROWS" sentence will be added when this method is just called
     */
    public void sqlAllRows() {
        sqlIsAllRows = true;
    }

    /**
     * Keep SQL Construction after query is executed
     * @param NONE
     * @return void
     * [NOTE] SQL Construction cache will be kept after this method is just called
     * [NOTE] Call "clear" method to stop this cache feature
     */
    public void sqlStartCache() {
        sqlIsCache = true;
    }

    /**
     * Query Execution Method for SQL Construction
     * @param {String} sObjectName [sObject Name]
     * @return List<sObject> LIST of sObject records
     * [NOTE] Also can call this method singly, which EXECUTEs simple query such as "SELECT * FROM [sObject]"
     * [NOTE] Actual executtion of query is carried out by "getSObjRecords" method
     */
    public List<sObject> sqlGet(String sObjectName) {
        Map<String, Object> queryParams = this.createQueryParams(); // Create parameters for query construction
        List<sObject> sObjList = this.getSObjRecords(sObjectName, queryParams); // Query is executed the very here
        if (!sqlIsCache) { // SQL Construction will be initialized when sqlIsCache is false
            this.clear();
        }
        return sObjList;
    }

    /**
     * Simple Query Return Method
     * @param {String} sObjectName [sObject Name]
     * @return {String} STRING of query created with SQL Construction
     * [NOTE] Also can call this method singly, which CREATEs simple query such as "SELECT * FROM [sObject]"
     */
    public String sqlQuery(String sObjectName) {
        Map<String, Object> queryParams = this.createQueryParams(); // Create parameters for query construction
        String queryStr = this.createQueryStr(sObjectName, queryParams); // Create query itself with SQL Construction
        if (!sqlIsCache) { // SQL Construction will be initialized when sqlIsCache is false
            this.clear();
        }
        return queryStr;
    }

    /**
     * Create Parameters to construct SQL sentence
     * @return {Map<String, Object>} Parameters to construct SQL sentence
     */
    public Map<String, Object> createQueryParams() {
        Map<String, Object> queryParams = new Map<String, Object>{}; // Initialize query parameters
        if (!sqlFieldSet.isEmpty() && !sqlFieldSet.contains('*')) { // SELECT Sentence
            queryParams.put('field', sqlFieldSet);
        }
        if (!sqlWhereMapList.isEmpty()) { // WHERE clause
            queryParams.put('where', sqlWhereMapList);
        }
        if (!sqlOrWhereMapList.isEmpty()) { // OR WHERE clause
            queryParams.put('or_where', sqlOrWhereMapList);
        }
        if (!sqlLikeMapList.isEmpty()) { // LIKE clause
            queryParams.put('like', sqlLikeMapList);
        }
        if (!sqlOrLikeMapList.isEmpty()) { // OR LIKE clause
            queryParams.put('or_like', sqlOrLikeMapList);
        }
        if (!sqlNotLikeMapList.isEmpty()) { // NOT LIKE clause
            queryParams.put('not_like', sqlNotLikeMapList);
        }
        if (!sqlOrNotLikeMapList.isEmpty()) { // OR NOT LIKE clause
            queryParams.put('or_not_like', sqlOrNotLikeMapList);
        }
        if (!sqlWhereInMap.isEmpty()) { // WHERE IN clause
            queryParams.put('where_in', sqlWhereInMap);
        }
        if (!sqlWhereNotInMap.isEmpty()) { // WHERE NOT IN clause
            queryParams.put('where_not_in', sqlWhereNotInMap);
        }
        if (sqlLimitVal != null) { // LIMIT clause
            queryParams.put('limit', sqlLimitVal);
        }
        if (sqlOffsetVal != null) { // OFFSET clause
            queryParams.put('offset', sqlOffsetVal);
        }
        if (!sqlOrderbyMap.isEmpty()) { // ORDER BY clause
            queryParams.put('order_by', sqlOrderbyMap);
        }
        if (!sqlGroupbySet.isEmpty()) { // GROUP BY clause
            queryParams.put('group_by', sqlGroupbySet);
        }
        if (!sqlHavingMapList.isEmpty()) { // HAVING clause
            queryParams.put('having', sqlHavingMapList);
        }
        if (sqlIsAllRows != null) { // ALL ROWS clause
            queryParams.put('all_rows', sqlIsAllRows);
        }
        // Return Query Parameters
        return queryParams;
    }

    /**
     * Query Execution Method to get sObject records
     * @param {String} sObjectName [sObject Name]
     * @param {Map<String, Object>} params [Parameters] nullable
     * [Parameter keys] field, where, limit, offset, order_by, group_by, etc.
     * [NOTE] All fields will be selected when field key is not set or "*" is set
     * [NOTE] Example of parameters
     * {
            field: ['field-1', 'field-2', 'field-3', ...],
            where: {
                id: 'a0s1s000001QOmWAAW',
                Name: 'A project'
                isActive: true
            },
            limit: 3
        }
     * @return List<sObject> LIST of sObject records
     *
     */
    public List<sObject> getSObjRecords(String sObjectName, Map<String, Object> params) {
        // Create query sentence
        String queryStr = this.createQueryStr(sObjectName, params);
        if (sqlDebugWhenExecuted) {
            System.debug('[Query] ' + queryStr);
        }
        // Execute query
        List<sObject> sObjList = Database.query(queryStr);
        // Return list of sObject records
        return sObjList;
    }

    /**
     * Create SQL query sentence method
     * @param {String} sObjectName [sObject Name]
     * @param {Map<String, Object>} params [Parameters] nullable
     * [Parameter keys] field, where, limit, offset, order_by, group_by, etc.
     * [NOTE] All fields will be selected when field key is not set or "*" is set
     * [NOTE] Example of parameters
     * {
            field: ['field-1', 'field-2', 'field-3', ...],
            where: {
                id: 'a0s1s000001QOmWAAW',
                Name: 'A project'
                isActive: true
            },
            limit: 3
        }
     * @return {String} Query sentence created with parameters
     *
     */
    public String createQueryStr(String sObjectName, Map<String, Object> params) {
        // Define and initialize variables
        String fieldStr      = '';
        String whereStr      = '';
        String orWhereStr    = '';
        String likeStr       = '';
        String orLikeStr     = '';
        String notLikeStr    = '';
        String orNotLikeStr  = '';
        String whereInStr    = '';
        String whereNotInStr = '';
        String limitStr      = '';
        String offsetStr     = '';
        String orderbyStr    = '';
        String groupbyStr    = '';
        String havingStr     = '';
        String allRowsStr    = '';
        Set<String> fieldSet;
        Integer i;
        Integer j;
        // Create SELECT field clause
        if (params != null && params.containsKey('field')) { // When field key is set
            fieldSet = (Set<String>)params.get('field');
        } else { // Select all fields when field key is not set
            fieldSet = this.getSObjFields(sObjectName);
        }
        i = 0;
        for (String fieldName : fieldSet) {
            if (i != 0) { // concatinate by comma "," when multiple fields are set
                fieldStr += ', ';
            }
            fieldStr += fieldName;
            i++;
        }
        // Create WHERE clause
        if (params != null && params.containsKey('where')) {
            whereStr += ' WHERE ';
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('where');
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    Object conditionVal = conditions.get(key);
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        whereStr += ' AND ';
                    }
                    if (this.checkEndsWithOperators(key)) { // When key contains a comparative operator
                        if (conditionVal instanceof String) { // When value is String type
                            whereStr += key + ' ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            whereStr += key + ' ' + castedStr;
                        }
                    } else { // When key does not contain any comparative operators
                        if (conditionVal instanceof String) { // When value is String type
                            whereStr += key + ' = ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            whereStr += key + ' = ' + castedStr;
                        }
                    }
                }
                i++;
            }
        }
        // Create OR WHERE clause
        if (params != null && params.containsKey('or_where')) {
            if (params.containsKey('where')) { // concatinate by "OR" when "WHERE" clause already exists
                orWhereStr += ' OR ';
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                orWhereStr += ' WHERE ';
            }
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('or_where');
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    Object conditionVal = conditions.get(key);
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        orWhereStr += ' OR ';
                    }
                    if (this.checkEndsWithOperators(key)) { // When key contains a comparative operator
                        if (conditionVal instanceof String) { // When value is String type
                            orWhereStr += key + ' ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            orWhereStr += key + ' ' + castedStr;
                        }
                    } else { // When key does not contain any comparative operators
                        if (conditionVal instanceof String) { // When value is String type
                            orWhereStr += key + ' = ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            orWhereStr += key + ' = ' + castedStr;
                        }
                    }
                }
                i++;
            }
        }
        // Create LIKE clause
        if (params != null && params.containsKey('like')) {
            if (
                params.containsKey('where')
                || params.containsKey('or_where')
                || params.containsKey('where_in')
                || params.containsKey('where_not_in')
            ) { // concatinate by "AND" when "WHERE" clause already exists
                likeStr += ' AND ';
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                likeStr += ' WHERE ';
            }
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('like');
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        likeStr += ' AND ';
                    }
                    if (conditions.get(key) instanceof String) { // When value is String type
                        likeStr += key + ' LIKE ' + '\'' + conditions.get(key) + '\'';
                    } else { // When value is other type
                        likeStr += key + ' LIKE ' + conditions.get(key);
                    }
                }
                i++;
            }
        }
        // Create OR LIKE clause
        if (params != null && params.containsKey('or_like')) {
            if (
                params.containsKey('where')
                || params.containsKey('or_where')
                || params.containsKey('where_in')
                || params.containsKey('where_not_in')
                || params.containsKey('like')
            ) { // concatinate by "OR" when "WHERE" clause already exists
                orLikeStr += ' OR ';
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                orLikeStr += ' WHERE ';
            }
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('or_like');
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        orLikeStr += ' OR ';
                    }
                    if (conditions.get(key) instanceof String) { // When value is String type
                        orLikeStr += key + ' LIKE ' + '\'' + conditions.get(key) + '\'';
                    } else { // When value is other type
                        orLikeStr += key + ' LIKE ' + conditions.get(key);
                    }
                }
                i++;
            }
        }
        // 類似否定検索条件の設定
        if (params != null && params.containsKey('not_like')) {
            Boolean isPlural = false;
            if (
                params.containsKey('where')
                || params.containsKey('or_where')
                || params.containsKey('where_in')
                || params.containsKey('where_not_in')
                || params.containsKey('like')
                || params.containsKey('or_like')
            ) { // concatinate by "AND" when "WHERE" clause already exists
                notLikeStr += ' AND ';
                isPlural = true;
            } else if (params.containsKey('or_not_like')) {
                notLikeStr += ' WHERE ';
                isPlural = true;
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                notLikeStr += ' WHERE ';
            }
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('not_like');
            Integer listSize = conditionsList.size();
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        notLikeStr += ' AND ';
                    }
                    if (isPlural || listSize > 1) { // Enclose each condition in parantheses when multiple conditions
                        notLikeStr += '(';
                    }
                    if (conditions.get(key) instanceof String) { // When value is String type
                        notLikeStr += 'NOT ' + key + ' LIKE ' + '\'' + conditions.get(key) + '\'';
                    } else { // When value is other type
                        notLikeStr += 'NOT ' + key + ' LIKE ' + conditions.get(key);
                    }
                    if (isPlural || listSize > 1) { // Enclose each condition in parantheses when multiple conditions
                        notLikeStr += ')';
                    }
                }
                i++;
            }
        }
        // Create OR NOT LIKE clause
        if (params != null && params.containsKey('or_not_like')) {
            Boolean isPlural = false;
            if (
                params.containsKey('where')
                || params.containsKey('or_where')
                || params.containsKey('where_in')
                || params.containsKey('where_not_in')
                || params.containsKey('like')
                || params.containsKey('or_like')
                || params.containsKey('not_like')
            ) { // concatinate by "OR" when "WHERE" clause already exists
                orNotLikeStr += ' OR ';
                isPlural = true;
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                orNotLikeStr += ' WHERE ';
            }
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('or_not_like');
            Integer listSize = conditionsList.size();
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    if (i != 0) { // concatinate by "OR" when multiple conditions are set
                        orNotLikeStr += ' OR ';
                    }
                    if (isPlural || listSize > 1) { // Enclose each condition in parantheses when multiple conditions
                        orNotLikeStr += '(';
                    }
                    if (conditions.get(key) instanceof String) { // When value is String type
                        orNotLikeStr += 'NOT ' + key + ' LIKE ' + '\'' + conditions.get(key) + '\'';
                    } else { // When value is other type
                        orNotLikeStr += 'NOT ' + key + ' LIKE ' + conditions.get(key);
                    }
                    if (isPlural || listSize > 1) { // Enclose each condition in parantheses when multiple conditions
                        orNotLikeStr += ')';
                    }
                }
                i++;
            }
        }
        // Create WHERE IN clause
        if (params != null && params.containsKey('where_in')) {
            if (params.containsKey('where') || params.containsKey('or_where')) { // concatinate by "AND" when "WHERE" clause already exists
                whereInStr += ' AND ';
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                whereInStr += ' WHERE ';
            }
            i = 0;
            Map<String, Object> conditions = (Map<String, Object>)params.get('where_in');
            Set<String> keys = conditions.keySet(); // Get keys
            for (String key : keys) {
                j = 0;
                Object conditionVal = conditions.get(key);
                if (i != 0) { // concatinate by "AND" when multiple conditions are set
                    whereInStr += ' AND ';
                }
                if (conditionVal instanceof String) { // When value is String type
                    whereInStr += key + ' IN (' + conditionVal + ')';
                } else if (conditionVal instanceof Set<String>) { // When Set<String> type
                    whereInStr += key + ' IN (';
                    for (String eachStr : (Set<String>)conditionVal) {
                        if (j != 0) { // concatinate by comma "," when multiple conditions are set
                            whereInStr += ', ';
                        }
                        whereInStr += '\'' + eachStr + '\'';
                        j++;
                    }
                    whereInStr += ')';
                } else { // When NOT Set<String> type
                    Set<String> castedSet = this.convertToSetTypeStr(conditionVal);
                    whereInStr += key + ' IN (';
                    for (String eachStr : castedSet) {
                        if (j != 0) { // concatinate by comma "," when multiple conditions are set
                            whereInStr += ', ';
                        }
                        whereInStr += eachStr;
                        j++;
                    }
                    whereInStr += ')';
                }
                i++;
            }
        }
        // Create WHERE NOT IN clause
        if (params != null && params.containsKey('where_not_in')) {
            if (params.containsKey('where') || params.containsKey('or_where') || params.containsKey('where_in')) { // concatinate by "AND" when "WHERE" clause already exists
                whereNotInStr += ' AND ';
            } else { // Start with "WHERE" when "WHERE" clause does not exist
                whereNotInStr += ' WHERE ';
            }
            i = 0;
            Map<String, Object> conditions = (Map<String, Object>)params.get('where_not_in');
            Set<String> keys = conditions.keySet(); // Get keys
            for (String key : keys) {
                j = 0;
                Object conditionVal = conditions.get(key);
                if (i != 0) { // concatinate by "AND" when multiple conditions are set
                    whereNotInStr += ' AND ';
                }
                if (conditionVal instanceof String) { // When value is String type
                    whereNotInStr += key + ' NOT IN (' + conditionVal + ')';
                } else if (conditionVal instanceof Set<String>) { //When Set<String> type
                    whereNotInStr += key + ' NOT IN (';
                    for (String eachStr : (Set<String>)conditionVal) {
                        if (j != 0) { // concatinate by comma "," when multiple conditions are set
                            whereNotInStr += ', ';
                        }
                        whereNotInStr += '\'' + eachStr + '\'';
                        j++;
                    }
                    whereNotInStr += ')';
                } else { // When NOT Set<String> type
                    Set<String> castedSet = this.convertToSetTypeStr(conditionVal);
                    whereNotInStr += key + ' NOT IN (';
                    for (String eachStr : castedSet) {
                        if (j != 0) { // concatinate by comma "," when multiple conditions are set
                            whereNotInStr += ', ';
                        }
                        whereNotInStr += eachStr;
                        j++;
                    }
                    whereNotInStr += ')';
                }
                i++;
            }
        }
        // Create LIMIT clause
        if (params != null && params.containsKey('limit')) {
            limitStr += ' LIMIT ';
            limitStr += String.valueOf(params.get('limit'));
        }
        // Create OFFET clause
        if (params != null && params.containsKey('offset')) {
            offsetStr += ' OFFSET ';
            offsetStr += String.valueOf(params.get('offset'));
        }
        // Create ORDER BY clause
        if (params != null && params.containsKey('order_by')) {
            Map<String, String> conditions = (Map<String, String>)params.get('order_by');
            orderbyStr += ' ORDER BY ';
            i = 0;
            Set<String> keys = conditions.keySet(); // Get keys
            for (String key : keys) {
                if (i != 0) { // concatinate by comma "," when multiple conditions are set
                    orderbyStr += ', ';
                }
                orderbyStr += key + ' ' + conditions.get(key);
                i++;
            }
        }
        // Create GROUP BY clause
        if (params != null && params.containsKey('group_by')) {
            Set<String> conditions = (Set<String>)params.get('group_by');
            groupbyStr += ' GROUP BY ';
            i = 0;
            for (String fieldName : conditions) {
                if (i != 0) { // concatinate by comma "," when multiple conditions are set
                    groupbyStr += ', ';
                }
                groupbyStr += fieldName;
                i++;
            }
        }
        // Create HAVING clause
        if (params != null && params.containsKey('having')) {
            havingStr += ' HAVING ';
            i = 0;
            List<Map<String, Object>> conditionsList = (List<Map<String, Object>>)params.get('having');
            for (Map<String, Object> conditions : conditionsList) {
                Set<String> keys = conditions.keySet(); // Get keys
                for (String key : keys) {
                    Object conditionVal = conditions.get(key);
                    if (i != 0) { // concatinate by "AND" when multiple conditions are set
                        havingStr += ' AND ';
                    }
                    if (this.checkEndsWithOperators(key)) { // When key contains a comparative operator
                        if (conditionVal instanceof String) { // When value is String type
                            havingStr += key + ' ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            havingStr += key + ' ' + castedStr;
                        }
                    } else { // When key does not contain any comparative operators
                        if (conditionVal instanceof String) { // When value is String type
                            havingStr += key + ' = ' + '\'' + conditionVal + '\'';
                        } else { // When value is other type
                            String castedStr = (String)JSON.deserialize(JSON.serialize(conditionVal), String.class); // Cast type of value to String type with keeping its data structure
                            havingStr += key + ' = ' + castedStr;
                        }
                    }
                }
                i++;
            }
        }
        // Create ALL ROWS clause
        if (params != null && params.containsKey('all_rows')) {
            Boolean isAllRows = (Boolean)params.get('all_rows');
            allRowsStr += isAllRows ? ' ALL ROWS' : '';
        }
        // Finally, create query sentence
        String queryStr = 'SELECT '
                        + fieldStr
                        + ' FROM '
                        + sObjectName
                        + whereStr
                        + orWhereStr
                        + whereInStr
                        + whereNotInStr
                        + likeStr
                        + orLikeStr
                        + notLikeStr
                        + orNotLikeStr
                        + orderbyStr
                        + groupbyStr
                        + havingStr
                        + limitStr
                        + offsetStr
                        + allRowsStr
        ;
        // Return query sentence
        return queryStr;
    }

    /**
     * Get all sObject field name
     * @param {String} sObjectName [sObject Name]
     * @return {Set<String>} ['field-1', 'field-2', 'field-3', ...]
     */
    public Set<String> getSObjFields(String sObjectName) {
        Set<String> fieldSet = new Set<String>();
        // Get sObject information
        Schema.SObjectType sObjectInfo = Schema.getGlobalDescribe().get(sObjectName);
        // Get describe information from sObject information
        Schema.DescribeSObjectResult sObjectDescr = sObjectInfo.getDescribe();
        // Get all field Map information
        Map<String, Schema.SObjectField> sObjfieldMap = sObjectDescr.fields.getMap();
        // Get all field name from field Map information
        for (Schema.SObjectField sObjfieldInfo : sObjfieldMap.values()) {
            fieldSet.add(sObjfieldInfo.getDescribe().getName()); // API name
        }
        return fieldSet;
    }

    /**
     * Check if a key contains a comparative operator
     * @param {String} keyName [Key Name]
     * @return Boolean
     */
    private Boolean checkEndsWithOperators(String keyName) {
        if (keyName.endsWith(' !=')) {
            return true;
        } else if (keyName.endsWith(' <') || keyName.endsWith(' <=')) {
            return true;
        } else if (keyName.endsWith(' >') || keyName.endsWith(' >=')) {
            return true;
        } else if (keyName.endsWith(' LIKE')) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Convert Set<***> type to Set<String> type
     * @param {Object} setVal [Value of Set<***> type]
     * @return Set<String>
     */
    public Set<String> convertToSetTypeStr(Object setVal) {
        if (setVal instanceof Set<String>) { // When String type
            return (Set<String>)setVal;
        } else if (setVal instanceof Set<Integer>) { // When Integer type
            Set<Integer> castedSetVal = (Set<Integer>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Double>) { // When Double type
            Set<Double> castedSetVal = (Set<Double>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Long>) { // When Long type
            Set<Long> castedSetVal = (Set<Long>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Decimal>) { // When Decimal type
            Set<Decimal> castedSetVal = (Set<Decimal>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Boolean>) { // When Boolean type
            Set<Boolean> castedSetVal = (Set<Boolean>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Date>) { // When Date type
            Set<Date> castedSetVal = (Set<Date>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Datetime>) { // When Datetime type
            Set<Datetime> castedSetVal = (Set<Datetime>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else if (setVal instanceof Set<Id>) { // When Id type
            Set<Id> castedSetVal = (Set<Id>)setVal;
            return (Set<String>)JSON.deserialize(JSON.serialize(castedSetVal), Set<String>.class);
        } else {
            return new Set<String>();
        }
    }

    /**
     * Insert sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {Map<String, Object>} success: Boolean for status of success, error: error objects like DmlException type when error occurs
     */
    public Map<String, Object> sqlInsert(Object sObjCollection, Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>{'success'=>true, 'error'=>null};
        try {
            if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
                List<sObject> sObjList = (List<sObject>)sObjCollection;
                if (params != null) {
                    for (sObject eachObj : sObjList) {
                        this.setSObjParams(eachObj, params);
                    }
                }
                // Execute insert
                insert sObjList;
            } else if (sObjCollection instanceof sObject) { // When sObject type
                sObject sObj = (sOBject)sObjCollection;
                if (params != null) {
                    this.setSObjParams(sObj, params);
                }
                // Execute insert
                insert sObj;
            } else { // When others: Error
                throw new DmlException('1st arg must be sObject or List<sObject> type');
            }
            return resultMap;
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('error', e);
            return resultMap;
        }
    }

    /**
     * Insert all sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {List<Database.SaveResult>}
     */
    public List<Database.SaveResult> sqlInsertAll(Object sObjCollection, Map<String, Object> params) {
        Boolean allOrNone = false;
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
            List<sObject> sObjList = (List<sObject>)sObjCollection;
            if (params != null) {
                for (sObject eachObj : sObjList) {
                    this.setSObjParams(eachObj, params);
                }
            }
            // Execute insert
            srList = Database.insert(sObjList, allOrNone);
        } else if (sObjCollection instanceof sObject) { // When sObject type
            sObject sObj = (sOBject)sObjCollection;
            if (params != null) {
                this.setSObjParams(sObj, params);
            }
            // Execute insert
            srList.add(Database.insert(sObj, allOrNone));
        }
        return srList;
    }

    /**
     * Update sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {Map<String, Object>} success: Boolean for status of success, error: error objects like DmlException type when error occurs
     */
    public Map<String, Object> sqlUpdate(Object sObjCollection, Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>{'success'=>true, 'error'=>null};
        try {
            if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
                List<sObject> sObjList = (List<sObject>)sObjCollection;
                if (params != null) {
                    for (sObject eachObj : sObjList) {
                        this.setSObjParams(eachObj, params);
                    }
                }
                // Execute update
                update sObjList;
            } else if (sObjCollection instanceof sObject) { // When sObject type
                sObject sObj = (sOBject)sObjCollection;
                if (params != null) {
                    this.setSObjParams(sObj, params);
                }
                // Execute update
                update sObj;
            } else { // When others: Error
                throw new DmlException('1st arg must be sObject or List<sObject> type');
            }
            return resultMap;
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('error', e);
            return resultMap;
        }
    }


    /**
     * Update all sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {List<Database.SaveResult>}
     */
    public List<Database.SaveResult> sqlUpdateAll(Object sObjCollection, Map<String, Object> params) {
        Boolean allOrNone = false;
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
            List<sObject> sObjList = (List<sObject>)sObjCollection;
            if (params != null) {
                for (sObject eachObj : sObjList) {
                    this.setSObjParams(eachObj, params);
                }
            }
            // Execute update
            srList = Database.update(sObjList, allOrNone);
        } else if (sObjCollection instanceof sObject) { // When sObject type
            sObject sObj = (sOBject)sObjCollection;
            if (params != null) {
                this.setSObjParams(sObj, params);
            }
            // Execute update
            srList.add(Database.update(sObj, allOrNone));
        }
        return srList;
    }

    /**
     * Upsert sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {Map<String, Object>} success: Boolean for status of success, error: error objects like DmlException type when error occurs
     */
    public Map<String, Object> sqlUpsert(Object sObjCollection, Map<String, Object> params) {
        Map<String, Object> resultMap = new Map<String, Object>{'success'=>true, 'error'=>null};
        try {
            if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
                List<sObject> sObjList = (List<sObject>)sObjCollection;
                if (params != null) {
                    for (sObject eachObj : sObjList) {
                        this.setSObjParams(eachObj, params);
                    }
                }
                // Execute upsert
                upsert sObjList;
            } else if (sObjCollection instanceof sObject) { // When sObject type
                sObject sObj = (sOBject)sObjCollection;
                if (params != null) {
                    this.setSObjParams(sObj, params);
                }
                // Execute upsert
                upsert sObj;
            } else { // When others: Error
                throw new DmlException('1st arg must be sObject or List<sObject> type');
            }
            return resultMap;
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('error', e);
            return resultMap;
        }
    }

    /**
     * Delete sObject records
     * @param {Object} sObjCollection [sObject or List<sObject> type]
     * @param {Map<String, Object>} params [Parameters for field/value of sObject]
     * @return {Map<String, Object>} success: Boolean for status of success, error: error objects like DmlException type when error occurs
     */
    public Map<String, Object> sqlDelete(Object sObjCollection) {
        Map<String, Object> resultMap = new Map<String, Object>{'success'=>true, 'error'=>null};
        try {
            if (sObjCollection instanceof List<sObject>) { // When List<sObject> type
                List<sObject> sObjList = (List<sObject>)sObjCollection;
                // Execute delete
                delete sObjList;
            } else if (sObjCollection instanceof sObject) { // When sObject type
                sObject sObj = (sOBject)sObjCollection;
                // Execute delete
                delete sObj;
            } else { // When others: Error
                throw new DmlException('1st arg must be sObject or List<sObject> type');
            }
            return resultMap;
        } catch (Exception e) {
            resultMap.put('success', false);
            resultMap.put('error', e);
            return resultMap;
        }
    }

    /**
     * Set parameters for insert, update, upsert
     * @param {sObject} sObj [sObject Record]
     * @param {Map<String, Object>} params [Parameters]
     * @return void
     * Execute insert/update/upsert for the sObject record after this method is called
     * [Example for use]
     * SOQLBuilder sb = new SOQLBuilder();
     * Account acc = new Account();
     * Map<String, Object> param = new Map<String, Object>{'Name' => 'Misaka', 'BillingCity' => 'Academic city', 'BillingCountry' => 'Japan', 'BillingState' => 'Tokyo', 'NumberOfEmployees' => 100};
     * sb.setSObjParams(acc, param);
     */
    public void setSObjParams(sObject sObj, Map<String, Object> params) {
        Object eachParam;
        Set<String> keys = params.keySet(); // Get keys
        for (String key : keys) {
            // 各パラメータのデータ型を校正
            eachParam = params.get(key);
            if (eachParam instanceof Id) { // Id type
                String interVal = String.valueOf(eachParam);
                Id castedVal = Id.valueOf(interVal);
                sObj.put(key, castedVal);
            } else if (eachParam instanceof String) { // When value is String type
                String castedVal = String.valueOf(eachParam);
                sObj.put(key, castedVal);
            } else if (eachParam instanceof Integer) { // Integer type
                Integer castedVal = Integer.valueOf(eachParam);
                sObj.put(key, castedVal);
            } else if (eachParam instanceof Double) { // Double type
                Double castedVal = Double.valueOf(eachParam);
                sObj.put(key, castedVal);
            // } else if (eachParam instanceof Long) { // Long type
            //     String interVal = String.valueOf(eachParam);
            //     Long castedVal = Long.valueOf(interVal);
            //     sObj.put(key, castedVal);
            // } else if (eachParam instanceof Decimal) { // Decimal type
            //     String interVal = String.valueOf(eachParam);
            //     Decimal castedVal = Decimal.valueOf(interVal);
            //     sObj.put(key, castedVal);
            } else if (eachParam instanceof Boolean) { // Boolean type
                Boolean castedVal = Boolean.valueOf(eachParam);
                sObj.put(key, castedVal);
            } else if (eachParam instanceof Date) { // Date type
                Date castedVal = Date.valueOf(eachParam);
                sObj.put(key, castedVal);
            } else if (eachParam instanceof Datetime) { // Datetime type
                Datetime castedVal = Datetime.valueOf(eachParam);
                sObj.put(key, castedVal);
            } else { // nullの場合
                sObj.put(key, eachParam);
            }
        }
    }


} // End of the class