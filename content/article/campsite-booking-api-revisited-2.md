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
pattern. Let's demonstrate it using the `Calculator.java` class as an example:

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
following [CustomReplaceUnderscoresDisplayNameGenerator.java](https://github.com/igor-baiborodine/campsite-booking/blob/v4.3.0/src/test/java/com/kiroule/campsite/booking/api/CustomReplaceUnderscoresDisplayNameGenerator.java)
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
Therefore, the domain model contained only one entity class, **Booking.java**. This time I decided to improve the
solution with multiple campsites available for booking to choose from. Consequently, a new **Campsite.java** entity has 
been added to the domain model, which now looks like in the UML class diagram below:

![Domain Model Diagram](domain-model-diagram.png)

![Data Model Diagram](data-model-diagram.png)

### Apache Derby Instead of H2

### findForDateRange Method without Pessimistic Write Locking

### Integration Tests for Concurrent Booking Create/Update

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
