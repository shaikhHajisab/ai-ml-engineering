# Module 01 - Interview Questions: Python Fundamentals

## How to Use This File

1. Read each question
2. Close this file and answer OUT LOUD (simulates an interview)
3. Then open and compare your answer
4. Grade yourself: Full | Partial | Missed

---

## SECTION 1 - Core Python Concepts

### Q1. What is the difference between mutable and immutable objects?

What they are testing: Memory model, bug prevention awareness.

Answer:
  Immutable: Cannot be changed after creation. New object is created.
  Examples: int, float, str, tuple, frozenset

  Mutable: Can be modified in-place. Same object is updated.
  Examples: list, dict, set, custom class instances

```python
x = "accident"
x = x.upper()   # New string object created, x now points to it

features = [1.0, 2.0]
copy = features
copy.append(3.0)
# features is ALSO [1.0, 2.0, 3.0] - same object was modified!
```

Production relevance:
  Mutable default arguments are one of the most common Python bugs.
  Always use None as default for mutable types.

---

### Q2. What is the difference between == and is?

  == checks VALUE equality (do they have the same value?)
  is checks IDENTITY (are they the SAME object in memory?)

```python
a = [1, 2, 3]
b = [1, 2, 3]
a == b   # True  - same value
a is b   # False - different objects

c = a
a is c   # True  - same object
```

Rule: None comparisons ALWAYS use is, never ==
```python
if value is None:    # Correct
if value == None:    # Wrong
```

---

### Q3. Explain Python's Global Interpreter Lock (GIL).

The GIL is a mutex that allows only ONE thread to execute Python
bytecode at a time, even on multi-core machines.

Why it exists:
  CPython's memory management (reference counting) is not thread-safe.
  The GIL prevents race conditions.

Impact:
  - threading does NOT give true parallelism for CPU-bound tasks
  - For I/O-bound tasks (network, disk) threads still help
  - For CPU-bound ML tasks, use multiprocessing (separate GILs)

```python
# I/O bound  -> threading OK
# CPU bound  -> use multiprocessing or joblib
from joblib import Parallel, delayed  # Used inside sklearn
```

---

### Q4. What are generators? How do they differ from lists?

A generator produces values LAZILY - one at a time, only when needed.

| Feature   | List                 | Generator              |
|-----------|----------------------|------------------------|
| Memory    | All values stored    | Only current value     |
| Reusable  | Yes                  | No (exhausted once)    |
| Syntax    | [x for x in ...]    | (x for x in ...) or yield |

```python
squares_list = [x**2 for x in range(10_000_000)]   # RAM heavy!
squares_gen  = (x**2 for x in range(10_000_000))   # Lazy, safe

next(squares_gen)   # 0
next(squares_gen)   # 1
```

In ML: PyTorch DataLoader uses generators for streaming training batches.

---

### Q5. What is a decorator and why is it useful?

A decorator wraps a function to add behavior without modifying it.

```python
import functools
def logger(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"{func.__name__} completed")
        return result
    return wrapper
```

Real-world ML uses:
  @timer        - profile training time
  @retry        - retry failed API calls (rate limits)
  @validate     - validate input data types before prediction
  @app.get()    - FastAPI route decorators

---

## SECTION 2 - OOP Questions

### Q6. What is the difference between __init__ and __new__?

  __new__  creates the object (allocates memory). Called first.
  __init__ initializes the object (sets attributes). Called after.

99% of the time you only override __init__.

---

### Q7. Explain class variable vs instance variable.

```python
class Model:
    algorithm = "RandomForest"    # Class var - shared by ALL instances

    def __init__(self, n_estimators):
        self.n_estimators = n_estimators   # Instance var - unique per instance

m1 = Model(100)
m2 = Model(200)
m1.n_estimators   # 100
m2.n_estimators   # 200
Model.algorithm   # "RandomForest" - shared
```

Danger: Mutable class variables - modifying via one instance affects all.

---

### Q8. What are *args and **kwargs?

  *args   captures extra positional arguments as a tuple
  **kwargs captures extra keyword arguments as a dict

```python
def train(model, X, y, **kwargs):
    return model.fit(X, y, **kwargs)

train(rf, X_train, y_train, epochs=10, verbose=True)
```

---

## SECTION 3 - Performance & Memory

### Q9. Time complexity of in operator?

| Structure | in check | Reason        |
|-----------|----------|---------------|
| list      | O(n)     | Linear scan   |
| set       | O(1) avg | Hash table    |
| dict      | O(1) avg | Hash on keys  |

ML Impact:
```python
valid_weathers = {"Rain", "Clear", "Fog", "Snow"}   # Set, not list!
if weather in valid_weathers:   # O(1) not O(n)
```

---

### Q10. Shallow copy vs deep copy?

```python
import copy

original = {"id": 1, "features": [0.8, 0.3]}

shallow = original.copy()
shallow["features"].append(0.7)
# original["features"] also modified!  BUG!

deep = copy.deepcopy(original)
deep["features"].append(0.9)
# original["features"] is safe  CORRECT
```

---

## SECTION 4 - FAANG / Hard Questions

### Q11. Python passes by reference or by value?

Neither. Python uses pass-by-object-reference (pass by assignment).

  - The reference is passed by value
  - Reassigning the parameter does NOT affect the caller
  - Mutating a mutable object DOES affect the caller

```python
def modify(items):
    items.append(99)     # Caller SEES this change
    items = [1, 2, 3]   # Caller does NOT see this

data = [10, 20]
modify(data)
print(data)   # [10, 20, 99]
```

---

### Q12. What is a closure?

A function that REMEMBERS variables from its enclosing scope,
even after that scope has finished.

```python
def make_risk_filter(threshold: float):
    def filter_records(records):
        return [r for r in records if r["score"] > threshold]
    return filter_records   # threshold is "closed over"

high_risk_filter   = make_risk_filter(0.8)
medium_risk_filter = make_risk_filter(0.5)
```

Used in: decorators, callbacks, factory patterns.

---

## SECTION 5 - The Mutable Default Argument Trap

### Q13. What is the mutable default argument trap?

```python
# BUGGY:
def append_feature(record, features=[]):
    features.append(record["speed"])
    return features

append_feature({"speed": 60})   # [60]
append_feature({"speed": 80})   # [60, 80]  BUG!

# FIX:
def append_feature(record, features=None):
    if features is None:
        features = []
    features.append(record["speed"])
    return features
```

Why: Default argument objects are created ONCE when the function
is defined, not each time it is called.

---

## SECTION 6 - Production Python

### Q14. What are type hints and why do companies require them?

```python
def load_data(filepath: str, n_rows: int = None) -> pd.DataFrame:
    ...
```

Why companies require them:
  - Self-documenting code
  - IDE autocomplete
  - mypy catches bugs before runtime
  - Required by FastAPI (auto-generates API docs)
  - Pydantic uses them for data validation

---

### Q15. Difference between @staticmethod, @classmethod, instance method?

| Type            | self? | cls?  | Use case           |
|-----------------|-------|-------|--------------------|
| Instance method | YES   | No    | Most methods       |
| @classmethod    | No    | YES   | Factory methods    |
| @staticmethod   | No    | No    | Utility functions  |

---

## Scenario Questions

S1. Processing a 50GB CSV on 8GB RAM machine. What Python concepts do you use?

S2. Teammate wrote function with mutable default argument. Bug in production.
    Walk me through diagnosing it.

S3. Prediction API validates 20 input fields per request.
    What Python features keep this clean and maintainable?

S4. Design a Python class to represent an ML experiment tracking
    hyperparameters, metrics, and artifacts.

---

## Coding Questions (Write in 10 minutes)

C1. Flatten a nested list to any depth without any imports.

C2. Implement your own Counter using only a dictionary.

C3. Write a context manager that logs when a model starts/finishes training.

C4. Write a decorator that retries a function N times on exception with delay.
