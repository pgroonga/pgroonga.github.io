---
title: How to integrate pgroonga with Java based Spring/Hibernate
---

## Overview

There are three parts to the integration. First is notification to spring that a custom registration of functions is required. The second step is to register all desired operations with separate function names for use in Hibernate. The last step is using the functions in your HQL or JPA queries.

## Register with Spring

Under resources, in the **META-INF/services** folder create a file called **org.hibernate.boot.model.FunctionContributor** By creating this file in this location, Spring k nows to execute the class as part of bootstrapping Hibernate.
The content of the file is the fully qualified class name of a function contributor. The function contributor is what registers the customer function for use by Hibernate.

e.g.

```java
com.whonome.ec.lib.PgFunctionContributor
```

## Register Functions with Hibernate
Below is a simple use case is for selected operations of pgroonga, and did not to leverage lower level commands. As such, I only needed to create a simple registration of the operations to Hibernate as custom functions.
Hibernate document on FunctionContributor: https://docs.jboss.org/hibernate/orm/current/javadocs/org/hibernate/boot/model/FunctionContributor.html
The FunctionContributor is effectively a contract to register new functions which when encountered in HQL will be translated. 
There is a prebuilt tool for Pattern based substitution. The PatternFunction provides simple string replacement for the named function. The params passed into the function are sequentially numbered and prefixed by a question mark '*?*'.

```java
package com.whonome.ec.lib;
import org.hibernate.boot.model.FunctionContributions;
import org.hibernate.boot.model.FunctionContributor;
import org.hibernate.type.BasicType;
import org.hibernate.type.StandardBasicTypes;
public class PgFunctionContributor implements FunctionContributor {
	@Override
	public void contributeFunctions(FunctionContributions functionContributions) {
		BasicType<Boolean> resolveType = functionContributions.getTypeConfiguration().getBasicTypeRegistry().resolve(StandardBasicTypes.BOOLEAN);
		functionContributions.getFunctionRegistry().registerPattern("ecfts","?1 &@~ ?2",resolveType);
	}
}
```

## Use the function

A simple example of the HQL syntax to call the newly registered function.

```sql
select count(primaryKey) from FTX where fkEntity.fkType = :param1 and ecfts(content, :param2) = true
```

The generated SQL will look like the following:

```sql
select count(f1_0.primary_key) from ec_ftx f1_0 where f1_0.fk_entity_fk_type=? and f1_0.content &@~ ?=true
```
