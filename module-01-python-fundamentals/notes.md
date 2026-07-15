# Module 01 — Python Fundamentals: Complete Theory Notes

---

## 1. What is Python?

Python is a high-level, interpreted, dynamically-typed programming language.

- High-level: You write human-readable code. Python handles memory, types, and machine instructions.
- Interpreted: Code runs line-by-line (no compilation). Great for ML experimentation.
- Dynamically-typed: No type declarations. Python infers types at runtime.

Why ML Engineers use Python:
  NumPy, Pandas, Scikit-learn, TensorFlow, PyTorch are all Python-first.
  Fast prototyping — perfect for experiments.
  FastAPI makes serving models easy.

---

## 2. Variables and the Python Memory Model

```
x = 42
```
Python creates an OBJECT in memory (value=42, type=int).
`x` is just a REFERENCE (pointer) to that object.

```
x ─────────────→ [ Object: int | value=42 | ref_count=1 ]
```

If you do y = x, both point to the SAME object:
```
x ─────────────→ [ Object: int | value=42 | ref_count=2 ]
y ─────────────→ ↑
```

---

## 3. Core Data Types

| Type      | Example          | Mutable? | Use Case                 |
|-----------|------------------|----------|--------------------------|
| int       | 42               | No       | Counts, IDs              |
| float     | 3.14             | No       | Probabilities, scores    |
| str       | "accident"       | No       | Labels, text             |
| bool      | True             | No       | Flags, conditions        |
| list      | [1, 2, 3]        | YES      | Ordered changeable data  |
| tuple     | (1, 2, 3)        | No       | Fixed data (coordinates) |
| set       | {1, 2, 3}        | YES      | Unique values            |
| dict      | {"key": val}     | YES      | Key-value mappings       |
| NoneType  | None             | No       | Missing / optional       |

---

## 4. Mutable vs Immutable — Most Important Concept

RULE:
  Immutable: Value cannot change. A new object is created instead.
  Mutable:   Value changes in-place. Same object is modified.

Example of the MUTABLE TRAP:
```python
features = [45.0, 0.8, 120]
copy_features = features          # Both point to SAME list!
copy_features.append(None)
# features is NOW [45.0, 0.8, 120, None] — SURPRISE!

# FIX: use .copy()
safe_copy = features.copy()
```

Real Analogy:
  Immutable = A printed receipt. Cannot change it.
  Mutable   = A whiteboard. Anyone with access can change it.

---

## 5. f-strings (Python 3.6+)

```python
model_name = "RandomForest"
accuracy = 0.9247
report = f"Model: {model_name} | Accuracy: {accuracy:.2%}"
# "Model: RandomForest | Accuracy: 92.47%"
```

---

## 6. List Comprehensions — Pythonic Way

```python
# Traditional loop
high_risk = []
for score in risk_scores:
    if score > 0.7:
        high_risk.append(score)

# List comprehension
high_risk = [score for score in risk_scores if score > 0.7]

# Dict comprehension
feature_names = ["speed", "weather", "light"]
feature_map = {name: i for i, name in enumerate(feature_names)}
# {"speed": 0, "weather": 1, "light": 2}
```

---

## 7. Generators — Memory Efficient Processing

A generator YIELDS values one at a time instead of returning all at once.

WHY IT EXISTS:
  Processing 10 million accident records — you cannot load all into RAM.

```python
# MEMORY EXPENSIVE — loads ALL records
def load_all(filepath):
    with open(filepath) as f:
        return f.readlines()   # 10M lines in RAM!

# MEMORY EFFICIENT — yields one at a time
def stream_records(filepath):
    with open(filepath) as f:
        for line in f:
            yield line          # One record at a time
```

Visual:
  load_all    → [rec1, rec2, ..., rec10M] → RAM explodes!
  stream      → rec1 → process → rec2 → process → ...  OK

---

## 8. Decorators — Add Behavior Without Changing Code

```python
import time
import functools

def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        print(f"{func.__name__} took {elapsed:.4f}s")
        return result
    return wrapper

@timer
def train_model(data):
    time.sleep(0.1)
    return "model_trained"
```

Real Analogy:
  A decorator is like a security guard at a building.
  You do not change the building. You add a guard who does
  something before/after you enter.

---

## 9. OOP — Classes for ML Engineering

```python
from dataclasses import dataclass
from typing import Optional

@dataclass
class AccidentRecord:
    accident_id: int
    severity: str
    speed_limit: float
    casualties: int
    latitude: Optional[float] = None

    def is_fatal(self) -> bool:
        return self.severity == "Fatal"

    def risk_category(self) -> str:
        if self.casualties >= 3:
            return "High"
        elif self.casualties >= 1:
            return "Medium"
        return "Low"
```

---

## 10. Type Hints — Production Python

```python
from typing import List, Dict, Optional, Tuple

def preprocess_features(
    records: List[Dict[str, float]],
    target_column: str = "severity",
    drop_nulls: bool = True
) -> Tuple[List[List[float]], List[str]]:
    ...
```

Type hints:
  - Make code self-documenting
  - Enable IDE autocomplete
  - Allow static analysis (mypy)
  - Required by FastAPI and Pydantic

---

## 11. Error Handling — Never Crash in Production

```python
class InvalidFeatureError(ValueError):
    pass

def validate_speed(speed: float) -> float:
    if speed < 0 or speed > 200:
        raise InvalidFeatureError(
            f"Speed {speed} is outside valid range [0, 200]"
        )
    return speed

try:
    validate_speed(250)
except InvalidFeatureError as e:
    print(f"Validation failed: {e}")
```

---

## 12. Pythonic Checklist

GOOD (Pythonic):
  - List/dict comprehensions instead of loops
  - Generators for large data
  - Type hints everywhere
  - Functions with single responsibility
  - Specific exception types in try/except

BAD (Not Pythonic):
  - for i in range(len(items)) — use enumerate()
  - Bare except: — always catch specific exceptions
  - Magic numbers (60, 0.7) — use named constants
  - Huge monolithic functions
