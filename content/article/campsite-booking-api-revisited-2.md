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
[Act-Arrange-Assert](https://docs.microsoft.com/en-us/visualstudio/test/unit-test-basics?view=vs-2022#write-your-tests) (AAA)
pattern. Let's demonstrate it using the **Calculator.java** class as an example:

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
  public void twoPositiveOperands_multiply_correctPositiveResult() {
    // arrange
    op1 = 6;
    op2 = 3;
    // act
    int result = calculator.multiply(op1, op2);
    // assert
    assertThat(result).isEqualTo(18);
  }

  @Test(expected = ArithmeticException.class)
  public void secondOperandZero_divide_arithmeticException() {
    // arrange
    op1 = 6;
    op2 = 0;
    // act
    calculator.divide(op1, op2);
    // assert
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
  class Multiply{
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

For more details, please check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/a022aef07bcecca0f4ae26971dadfd515b100e8a).

### var Syntax for Local Variables

With the release of Java 10, it became possible to declare local variables using the new `var` keyword. When using `var`
, you no longer need to declare the type of the variable explicitly, as this implies that its type will be inferred from
context. So, for instance, we have the following pre-Java 10 variable declaration:

```java
SomeClassWithVeryVeryLongName myVar=new SomeClassWithVeryVeryLongName(); 
```

With Java 10, it can be declared as follows:

```java
var myVar=new SomeClassWithVeryVeryLongName(); 
```

And I took the opportunity to profit from this new feature to simplify the code and make it a little more readable. For
more details, please check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/e3038dce72f4ec816065ccc9a81f78665ac181e5).

### Java 17

### Campsite Table, API v2

### Apache Derby Instead of H2

### findForDateRange Method without Pessimistic Write Locking

### Integration Tests for Concurrent Booking Create/Update

### README TOC GitHub Action

Continue reading the series ["Campsite Booking API"](/series/campsite-booking-api/):
{{< series "Campsite Booking API" >}}
