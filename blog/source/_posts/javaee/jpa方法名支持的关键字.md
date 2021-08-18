---
title: jpa方法名支持的关键字
categories:
  - [javaee]
site: javaee
date: 2021-08-18 11:19:52
---

| 关键字            | 例子                                                    | jpql                                                       |
| ----------------- | ------------------------------------------------------- | ---------------------------------------------------------- |
| Distinct          | findDistinctByLastnameAndFirstname                      | select distinct ... where x.lastname=?1 and x.firstname=?2 |
| And               | findByFirstnameAndLastname                              | ... where x.firstname=?1 and x.lastname=?2                 |
| Or                | findByFirstNameOrLastname                               | ... where x.firstname=?1 and x.lastname=?2                 |
| Is,Equals         | findByFirstname,findByFirstnameIs,findByFirstnameEquals | ... where x.firstname=?1                                   |
| Between           | findByStartDateBetween                                  | ... where x.startDate between ?1 and ?2                    |
| LessThan          | findByAgeLessThan                                       | ... where x.age <?1                                        |
| LessThanEqual     | findByAgeLessThanEqual                                  | ... where x.age?=?1                                        |
| GreaterThan       | findByAgeGreaterThan                                    | ... where x.age>?1                                         |
| After             | findByStartDateAfter                                    | ... where x.startDate >?1                                  |
| Before            | findByStartDateBefore                                   | ... where x.startDate<?1                                   |
| IsNull,Null       | findByAge(Is)Null                                       | ... where x.age is null                                    |
| IsNotNull,NotNull | findByAge(Is)NotNull                                    | ... where x.age not null                                   |
| Like              | findByFirstnameLike                                     | ... where x.firstname like?1                               |
| NotLike           | findByFirstnameNotLike                                  | ... where x.firstname not like ?1                          |
| StartingWith      | findByFirstnameStartingWith                             | … where x.firstname like ?1` (参数后面加%）                |
| EndingWith        | findByFirstnameEndingWith                               | `… where x.firstname like ?1` （参数前面加%）              |
| Containing        | findByFirstnameContaining                               | `… where x.firstname like ?1` （参数前后加%）              |
| OrderBy           | findByAgeOrderByLastnameDesc                            | … where x.age = ?1 order by x.lastname desc                |
| Not               | findByLastnameNot                                       | … where x.lastname <> ?1                                   |
| In                | findByAgeIn(Collection//<Age//> ages)                   | … where x.age in ?1                                        |
| NotIn             | findByAgeNotIn(Collection<Age> ages)                    | … where x.age not in ?1                                    |
| True              | findByActiveTrue                                        | … where x.active = true                                    |
| False             | findByActiveFalse()                                     | … where x.active = false                                   |
| IgnoreCase        | findByFirstnameIgnoreCase                               | … where UPPER(x.firstname) = UPPER(?1)                     |
