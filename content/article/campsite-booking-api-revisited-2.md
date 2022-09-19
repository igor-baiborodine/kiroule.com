---
title: "Campsite Booking API : Revisited 2"
date: 2022-09-01T07:53:35-04:00

categories: [Java, Write-Up]
tags: [Java 17, Concurrency, Integration Test, GitHub Actions]
toc: false
series: "Campsite Booking API"
author: "Igor Baiborodine"
---

It has been almost a year and a half since I published the
article ["Campsite Booking API: Revisited"](/article/campsite-booking-api-revisited/). During this time, I kept the
project up-to-date and implemented numerous improvements. So, in this article, which is
the second part of
the series ["Campsite Booking API"](/series/campsite-booking-api/), I describe in detail what was achieved and how.

<!--more-->

This project iteration, already the third one, mainly consists of code enhancements. So now, let's take a closer look at
it in the order in which they were added. The source code is
available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v4.3.0).

{{< toc >}}

### Tests with JUnit 5 in BDD style

When this project was started, unit and integration tests were implemented using JUnit 4
with [AssertJ](https://assertj.github.io/doc/), [Mockito](https://site.mockito.org/), and the
[Act-Arrange-Assert](https://docs.microsoft.com/en-us/visualstudio/test/unit-test-basics?view=vs-2022#write-your-tests)(AAA)
pattern. Let's demonstrate it using the **Calculator** class as an example:

```java
public class Calculator {
  public int add(int op1, int op2) {
    return op1 + op2;
  }
  public int subtract(int op1, int op2) {
    return op1 - op2;
  }
  public int multiply(int op1, int op2) {
    return op1 * op2;
  }
  public int divide(int op1, int op2) {
    return op1 / op2;
  }
}
```

And unit tests with JUnit 4 and AAA approach for the above class might look like this:

```java
public class CalculatorTest {
  private Calculator calculator = new Calculator();
  private Integer op1;
  private Integer op2;

  @Before
  public void setUp() {
    op1 = null;
    op2 = null;
  }

  @Test
  public void multiply_twoPositiveOperands_correctPositiveResult() {
    // Arrange
    op1 = 6;
    op2 = 3;
    // Act
    int result = calculator.multiply(op1, op2);
    // Assert
    assertThat(result).isEqualTo(18);
  }

  @Test(expected = ArithmeticException.class)
  public void divide_secondOperandZero_arithmeticException() {
    // Arrange
    op1 = 6;
    op2 = 0;
    // Act
    calculator.divide(op1, op2);
    // Assert
    // ArithmeticException thrown
  }
}
```

These are the above unit tests re-written with JUnit 5 in BDD style:

```java
class CalculatorTest {
  Calculator calculator = new Calculator();
  Integer op1;
  Integer op2;
  Integer result;

  @BeforeEach
  void setUp() {
    op1 = null;
    op2 = null;
    result = null;
  }

  @Nested
  class Multiply {
    @BeforeEach
    void setUp() {
      // executes before each test within this nested class
    }

    @Test
    void twoPositiveOperands_correctPositiveResult() {
      given_twoOperands(6, 3);
      when_multiply();
      then_assertResult(18);
    }

    private void when_multiply() {
      result = calculator.multiply(op1, op2);
    }
  }

  @Nested
  class Divide {
    @Test
    void secondOperandZero_arithmeticException() {
      given_twoOperands(6, 0);
      when_divide_then_assertExceptionThrown(ArithmeticException.class);
    }

    @Test
    void twoPositiveOperands_correctPositiveResult() {
      given_twoOperands(6, 3);
      when_divide();
      then_assertResult(2);
    }

    private void when_divide() {
      result = calculator.divide(op1, op2);
    }

    private void when_divide_then_assertExceptionThrown(Class<? extends Exception> exception) {
      assertThrows(exception, () -> calculator.divide(op1, op2));
    }
  }

  private void given_twoOperands(int op1, int op2) {
    this.op1 = op1;
    this.op2 = op2;
  }

  private void then_assertResult(int expected) {
    assertThat(result).isEqualTo(expected);
  }
}
```

So, comparing these two implementations, you can see that the JUnit 5/BDD implementation differs from the previous one
in the following:

- All tests related to a particular method were encapsulated in a nested class annotated with the JUnit 5 `@Nested`
  annotation. Consequently, the `Act` part, that is to say, the name of the method under test, was removed from the
  names of the test methods.
- In test methods, following the [BDD](https://en.wikipedia.org/wiki/Behavior-driven_development) approach,
  the `Arrange`, `Act`, and `Assert` sections were encapsulated in methods prefixed with `given_`
  , `when_`, and `then_`, respectively, where these new methods can be declared either at the parent test class level or
  in nested test classes.
- The `@Before` annotation was replaced with the `@BeforeEach`. A method annotated with `@BeforeEach` and declared in a
  nested test class will be executed before each test in that class but after the `@BeforeEach` methods from the parent
  test class.

I think, writing tests in the BDD style improves the code's overall readability and makes the tests' purpose and
flow clearer. In addition, it provides an excellent opportunity for code reuse.

Previously, with JUnit 4, I used the **methodName_stateUnderTest_expectedBehavior** convention for naming test methods,
for instance, `divide_secondOperandZero_arithmeticException` as in the test implementation example above. With JUnit 5,
the **methodName** part was removed due to grouping all related tests inside a nested class. 

Next, because the `camelCase` naming approach is harder to read for complex method names, I switched
to the `underscore_case`, additionally applying this to nested test class names. Following the BDD style, I explicitly
prefixed the **state_under_test** and **expected_behaviour** parts with `given_` and `then_`, respectively.

To improve the display of test reports, JUnit 5 introduced new annotations such as `@DisplayName` and
`@DisplayNameGeneration`. So, for example, it may suffice to annotate a test class with the `@DisplayNameGeneration(
ReplaceUnderscores.class)` to display the `given_second_operand_zero_then_arithmetic_exception` method as `given second
operand zero then arithmetic exception`.

To further improve readability, I wanted to add a comma after the **given** part to display the method name like
this: `given second operand zero, then arithmetic exception`. To do this, I used a double underscore to separate the
**given** and **then** parts and implemented the
following [CustomReplaceUnderscoresDisplayNameGenerator](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/test/java/com/kiroule/campsite/booking/api/CustomReplaceUnderscoresDisplayNameGenerator.java)
class:

```java
public class CustomReplaceUnderscoresDisplayNameGenerator
    extends DisplayNameGenerator.ReplaceUnderscores {

  @Override
  public String generateDisplayNameForMethod(Class<?> testClass, Method testMethod) {
    String methodName = testMethod.getName()
        .replace("__", ", ").replace("_", " ");

    if (testMethod.getAnnotation(DisplayNamePrefix.class) != null) {
      methodName = String.format("%s, %s", 
          testMethod.getAnnotation(DisplayNamePrefix.class).value(), methodName);
    }
    return methodName;
  }
}
```

While working on
the [integration tests](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/test/java/com/kiroule/campsite/booking/api/repository/BookingRepositoryTestIT.java)
for the `findForDateRange` method in
the [BookingRepository.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/repository/BookingRepository.java)
class, I wanted to better visualize the requested date ranges versus the start and end dates of an existing booking. For
example, a method named `given_booking_dates_before_range_startDate__then_no_booking_found` must be shown with the prefix
`SE|-|----|-|--` in the test results report, where the letters `S` and `D` stands for the start and end dates of the
existing booking, and two `|-|` indicate the start and end of the requested date range:

Since special characters such as hyphen(`-`) and pipe(`|`) are not allowed in method names in Java, I came up with the
idea of implementing
the [DisplayNamePrefix.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/test/java/com/kiroule/campsite/booking/api/DisplayNamePrefix.java)
annotation, which works in conjunction with the `CustomReplaceUnderscoresDisplayNameGenerator.java` class. Thus, in order
to display a prefix in the test results, the test method must be annotated with `@DisplayNamePrefix`, given that the
test class is annotated with the `@DisplayNameGeneration(CustomReplaceUnderscoresDisplayNameGenerator.class)`:

```java
@Test
@DisplayNamePrefix("SE|-|----|-|--")
void given_booking_dates_before_range_start_date__then_no_booking_found() {
  given_existingBooking(1, 2);

  when_findBookingsForDateRange(3, 4);

  then_assertNoBookingFoundForDateRange();
}
```

![IntelliJ Test Results with Display Name Prefix](intellij-test-results-with-display-name-prefix.png)

For more details, please check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/a022aef07bcecca0f4ae26971dadfd515b100e8a).

### var Syntax for Local Variables

With the release of Java 10, it became possible to declare local variables using the new `var` keyword. When using `var`
, you no longer need to declare the type of the variable explicitly, as this implies that its type will be inferred from
context. So, for instance, we have the following pre-Java 10 variable declaration:

```java
SomeClassWithVeryVeryLongName myVar = new SomeClassWithVeryVeryLongName(); 
```

With Java 10, it can be declared as follows:

```java
var myVar = new SomeClassWithVeryVeryLongName(); 
```

So I did not miss the opportunity to simplify the code and make it a little more readable using this new var syntax.
For more details, please check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/e3038dce72f4ec816065ccc9a81f78665ac181e5).

### Java 17

The previous iteration of this project was based on Java **11** LTS. But since Oracle released Java **17**, the next
Long-Term Support version, in September 2021, I decided to upgrade the project to the latest Java LTS.

This upgrade was relatively simple and involved updating the `java.version` property
in [pom.xml](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/pom.xml) file from `11` to `17`.
Unfortunately, this caused some of the project's dependencies to become incompatible, and as a result, I updated all of
the project's dependencies, including Spring Boot, up to the latest versions.

Because of Java 17, I also had to upgrade the base image in
the [Dockerfile](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/Dockerfile) from `openjdk:11-jre-slim`
to `azul/zulu-openjdk-debian:17-jre`, and  `distribution` and `java-version` properties in GitHub
Actions' [workflows](https://github.com/igor-baiborodine/campsite-booking/tree/v4.3.0/.github/workflows).

### Campsite Table, API v2

The original implementation was based on the assumption that there was only one campsite available for booking.
Therefore, the domain model contained only one class, **Booking**. This time I decided to enhance the
solution with multiple campsites available for booking to choose from. Consequently, a
new [Campsite.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/model/Campsite.java)
domain class has been added to the model, which now looks like in the UML class diagram below:

![Domain Model Diagram](domain-model-diagram.png)

The above class diagram can be converted to the following physical data model for the MySQL database:

![Data Model Diagram](data-model-diagram.png)

The inception of the new domain class required the implementation of the corresponding service and repository classes,
namely [CampsiteServiceImpl.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/service/CampsiteServiceImpl.java)
and [CampsiteRepositoryImpl.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/repository/CampsiteRepository.java)
.

Hence, it also affected the REST API by introducing breaking changes. First, a new `campsiteId` field was added to
the [BookingDto.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/contract/v2/model/BookingDto.java)
API model class. Previously, only two parameters, the `start_date` and `end_date` had to be passed to
the `getVacantDates` endpoint in the API contract. So secondly, with multiple campsites to choose from, a new third
parameter, `campsite_id`, was added to this
endpoint [signature](https://github.com/igor-baiborodine/campsite-booking/blob/0ac063c5d6bb3c947035c60cf09df8d6980589a1/src/main/java/com/kiroule/campsite/booking/api/contract/v2/BookingApiContractV2.java#L31)
. Due to these breaking changes, I had to upgrade the API version from **v1** to **v2**.

### findForDateRange Method without Pessimistic Read Locking

In the initial implementation,
the [createBooking](https://github.com/igor-baiborodine/campsite-booking/blob/fc8ae1cacb3dedbe387d9e397b3cb536b458353b/src/main/java/com/kiroule/campsite/booking/api/service/BookingServiceImpl.java#L62)
method in the **BookingServiceImpl** class used
the [findVacantDays](https://github.com/igor-baiborodine/campsite-booking/blob/fc8ae1cacb3dedbe387d9e397b3cb536b458353b/src/main/java/com/kiroule/campsite/booking/api/service/BookingServiceImpl.java#L34)
method from the same class to get available booking dates and validate them before creating a new booking. Then,
the `findVacantDays` method, in turn, invoked
the [findForDateRange](https://github.com/igor-baiborodine/campsite-booking/blob/fc8ae1cacb3dedbe387d9e397b3cb536b458353b/src/main/java/com/kiroule/campsite/booking/api/repository/BookingRepository.java#L47)
method in the **BookingRepository** class to get vacant dates. That is, in fact,
the [getVacantDates](https://github.com/igor-baiborodine/campsite-booking/blob/fc8ae1cacb3dedbe387d9e397b3cb536b458353b/src/main/java/com/kiroule/campsite/booking/api/contract/v2/BookingApiContractV2.java#L31)
and [addBooking](https://github.com/igor-baiborodine/campsite-booking/blob/fc8ae1cacb3dedbe387d9e397b3cb536b458353b/src/main/java/com/kiroule/campsite/booking/api/contract/v2/BookingApiContractV2.java#L42)
endpoints shared the same service method to execute incoming requests.

And given that the `findForDateRange` method was implemented using the `@Lock(LockModeType.PESSIMISTIC_READ)`
annotation, concurrent requests to the `getVacantDates` and `addBooking` endpoints may fail due to
the `CannotAcquireLockException` that occurs when a transaction cannot obtain a pessimistic lock.

The solution to this problem is to have two different methods for finding bookings for the date range in the
**BookingRepository** class, one without any locking mechanism used by the `getVacantDates` endpoint and the other
with pessimistic locking for the `addBooking` endpoint. In addition, the `LockModeType` value for the new method with
pessimistic locking was updated to the `PESSIMISTIC_WRITE` to acquire an exclusive lock because when using
the `PESSIMISTIC_READ` on a transaction initiated by the `createBooking` method in the **BookingServiceImpl**
class, JPA will implicitly convert the pessimistic read lock to an exclusive lock, `PESSIMISTIC_WRITE`
or `PESSIMISTIC_FORCE_INCREMENT`, when a new `Booking` entity is flushed to the database.

```java
public interface BookingRepository extends CrudRepository<Booking, Long> {

  String FIND_FOR_DATE_RANGE = "select b from Booking b "
      + "where ((b.startDate < ?1 and ?2 < b.endDate) "
      + "or (?1 < b.endDate and b.endDate <= ?2) "
      + "or (?1 <= b.startDate and b.startDate <=?2)) "
      + "and b.active = true "
      + "and b.campsite.id = ?3";

  Optional<Booking> findByUuid(UUID uuid);

  @Query(FIND_FOR_DATE_RANGE)
  List<Booking> findForDateRange(LocalDate startDate, LocalDate endDate, Long campsiteId);

  @Lock(LockModeType.PESSIMISTIC_WRITE)
  @QueryHints({@QueryHint(name = "javax.persistence.lock.timeout", value ="100")})
  @Query(FIND_FOR_DATE_RANGE)
  List<Booking> findForDateRangeWithPessimisticWriteLocking(LocalDate startDate, LocalDate endDate, Long campsiteId);
}
```

### New Implementation of findForDateRangeWithPessimisticWriteLocking Method

Back then, while working on the initial implementation of this project, I
chose [H2](https://www.h2database.com/html/main.html) as an in-memory DB for developing integration tests or running the
API without an external database. The H2 served well for these purposes except for the case of concurrent creation of
bookings with the same start and end dates. Unlike MySQL, concurrent requests to the `addBooking` endpoint with the same
start and end date and camping ID were successful when using H2.

The expected result should be only one booking created, and other concurrent requests should return a `400 Bad Request`
response when sending simultaneous requests to create a booking as in the example below, for instance:

```json
{
   "id":2,
   "version":0,
   "campsiteId":1,
   "uuid":"ea2e2f8f-749d-4497-b0ec-0da4bf437800",
   "email":"john.smith.3@email.com",
   "fullName":"John Smith 3",
   "startDate":"2022-09-16",
   "endDate":"2022-09-17",
   "active":true,
   "_links":{
      "self":{
         "href":"http://localhost/v2/booking/ea2e2f8f-749d-4497-b0ec-0da4bf437800"
      }
   }
}
{
   "status":"BAD_REQUEST",
   "timestamp":"2022-08-30T02:52:19.10936",
   "message":"No vacant dates available from 2022-09-16 to 2022-09-17"
}
{
   "status":"BAD_REQUEST",
   "timestamp":"2022-08-30T02:52:19.210229",
   "message":"No vacant dates available from 2022-09-16 to 2022-09-17"
}
```

Evidently, the pessimistic locking in the `findForDateRangeWithPessimisticWriteLocking` method works well when using
MySQL, but somehow it doesn't work at all with the H2 database. So, while researching this issue, I came across
an informative article by Andrey
Zahariev-Stoev: ["Handling Pessimistic Locking with JPA on Oracle, MySQL, PostgreSQL, Apache Derby and H2"](https://blog.mimacom.com/handling-pessimistic-locking-jpa-oracle-mysql-postgresql-derbi-h2/)
. In this article, he explains in great detail the problem of concurrent database transactions and how they relate to
exclusive pessimistic locking. In addition, he offers several suggestions for implementing pessimistic locking when
using the [Java Persistence API (JPA)](https://docs.oracle.com/javaee/6/tutorial/doc/bnbpz.html) with various RDBMS
vendors.

It turned out that the H2 database does not provide full support for handling the `LockTimeoutException` and setting
lock timeout for a single transaction; therefore, I replaced H2 with [Apache Derby](https://db.apache.org/derby/) as the
in-memory DB. Consequently, I re-implemented the `findForDateRangeWithPessimisticWriteLocking` method, which was moved
from the **BookingRepository** class to the [**CustomizedBookingRepository**](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/repository/CustomizedBookingRepositoryImpl.java)
, and added a new [**BookingServiceImplConcurrentTestIT**](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/test/java/com/kiroule/campsite/booking/api/service/BookingServiceImplConcurrentTestIT.java)
class with integration tests for optimistic and pessimistic locking. All these code modifications were inspired
by ["Testing Pessimistic Locking Handling with Spring Boot and JPA"](https://blog.mimacom.com/testing-pessimistic-locking-handling-spring-boot-jpa/)
, another great article by Andrey Zahariev-Stoev, and are based on the source code from the corresponding
GitHub [repository](https://github.com/andistoev/testing-pessimistic-locking-handling-spring-boot-jpa-mysql).

As you can see, the new implementation of the `findForDateRangeWithPessimisticWriteLocking` method differs from the old
one in that it no longer uses annotations to set the query string, the type of lock mode, and the lock timeout. Instead,
the query object is created explicitly with the provided query string, parameters, and the lock mode using the JPA's
**Query** interface. The lock timeout is set through the appropriate custom repository context, either
[**MysqlCustomizedRepositoryContextImpl**](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/repository/context/DerbyCustomizedRepositoryContextImpl.java) 
or [**DerbyCustomizedRepositoryContextImpl**](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/main/java/com/kiroule/campsite/booking/api/repository/context/MysqlCustomizedRepositoryContextImpl.java) class.

```java
@Override
public List<Booking> findForDateRangeWithPessimisticWriteLocking(
    LocalDate startDate, LocalDate endDate, Long campsiteId) {

  log.info("Lock timeout before executing query[{}]", 
        customizedRepositoryContext.getLockTimeout());

  Query query = customizedRepositoryContext.getEntityManager()
      .createQuery(FIND_FOR_DATE_RANGE)
      .setParameter(1, startDate)
      .setParameter(2, endDate)
      .setParameter(3, campsiteId)
      .setLockMode(PESSIMISTIC_WRITE);

  customizedRepositoryContext.setLockTimeout(
      queryProperties.getFindForDateRangeWithPessimisticWriteLockingLockTimeoutInMs());

  List<Booking> bookings = query.getResultList();
  log.info("Lock timeout after executing query[{}]", 
        customizedRepositoryContext.getLockTimeout());

  return bookings;
}
```

For more details, please check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/7fb89a927a3ef6575e4eb74843b0957b800a2bf6).

### TOC Generator GitHub Actions

Recently, while working on my other pet project,
the [Bilberry Hugo theme](https://github.com/Lednerb/bilberry-hugo-theme), I discovered a pretty useful GitHub Actions
workflow for generating README's table of contents(TOC). So, instead of manually creating and maintaining a TOC,
the [TOC Generator](https://github.com/marketplace/actions/toc-generator) workflow will generate a TOC and a
corresponding commit for it if your README.md file has TOC-related changes.

So, to implement this feature, I had to do two things. First, I added the `readme-toc.yml` workflow to
the `.github/workflows` directory. Please note that it's triggered only for pull requests.

```yaml
name: Generate README TOC

on:
  pull_request:
    branches: "*"

jobs:
  generateTOC:
    name: Generate TOC
    runs-on: ubuntu-latest
    steps:
      - uses: technote-space/toc-generator@v4
```

Secondly, I replaced the manually created table of contents in README with the following markdown:

```markdown
<!-- START doctoc -->
<!-- END doctoc -->
```

Continue reading the series ["Campsite Booking API"](/series/campsite-booking-api/):
{{< series "Campsite Booking API" >}}
