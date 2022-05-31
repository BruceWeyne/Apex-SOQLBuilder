Apex SObjectModel
===

Salesforce Apex Class for DML operations with extensity

# Introduction
Development of Apex class needs to describe Salesforce's unique language called [SOQL](https://developer.salesforce.com/docs/atlas.ja-jp.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_sosl_intro.htm) to handle DML operations for sObjects. More conditions to filter sObject records to get, query becomes longer and more redundant, which makes it difficult to describe dynamic query.  
On this occasion, SObjectModel class has been defiened to solve this problem. The concept of MVC framework is consulted for this class that incorporates a part of features of Model. The goal is to realize the way of SOQL query description with more simplisity, readability, variability and availability.

Document: https://github.com/BruceWeyne/Apex-SObjectModel/tree/main/Document/English

# はじめに
Apex での sObject の DML 操作は [SOQL](https://developer.salesforce.com/docs/atlas.ja-jp.soql_sosl.meta/soql_sosl/sforce_api_calls_soql_sosl_intro.htm) と呼ばれる Salesforce 独自の言語が必要となり、開発において都度クエリを記述する必要がある。クエリの絞り込みが多くなるにつれてコードは冗長化し、動的なクエリの記述は難しくなる。  
この課題を解決する目的として、SObjectModel クラスを定義することにした。このクラスは、フレームワークの概念である MVC を参考にして、「モデル」機能の一部の動作を模倣するものである。これにより、SOQL クエリを直書きするよりも簡略的で可読性、可変性、可用性の高い記法の実現を目指している。

ドキュメント: https://github.com/BruceWeyne/Apex-SObjectModel/tree/main/Document/Japanese