"""
Module 01 - Python Fundamentals: Exercises + Solutions
=======================================================
Domain: Accident Risk Analysis Dataset

MENTOR REVIEW NOTES are written inline.
Read EVERY comment. Understand EVERY line.
If you cannot explain a line — you do not own it yet.
"""


# ==========================================================
# EXERCISE 1 - Data Cleaning Filter  [Beginner]
# ==========================================================
"""
PROBLEM:
  Filter invalid speed limits from: [60, None, -5, 30, 250, 70, None, 80, 120, -1]
  Invalid = None, negative, or > 200

YOUR ATTEMPT HAD THESE BUGS:
  BUG 1: Used | (bitwise OR) instead of 'or' (boolean OR)
         item==None | item<0 → Python evaluates None|item FIRST → CRASH
  BUG 2: Comparing None < 0 raises TypeError in Python
  BUG 3: Used >= 200 which wrongly excludes speed limit of 200
  BUG 4: Imported numpy and pandas — NOT needed for a simple list filter
  BUG 5: Used == None instead of 'is not None'
         None is a singleton. Always use 'is' or 'is not' with None.
"""

raw_speeds = [60, None, -5, 30, 250, 70, None, 80, 120, -1]

# ── CORRECT SOLUTION ──────────────────────────────────────

def clean_speeds(speeds: list) -> list:
    """
    Return only valid speed limits.
    Valid range: 0 <= speed <= 200
    Uses ONE list comprehension as required.
    """
    # Check 'is not None' FIRST — short-circuit evaluation
    # If s is None, Python stops and does not evaluate s >= 0 (avoids TypeError)
    return [s for s in speeds if s is not None and 0 <= s <= 200]


cleaned = clean_speeds(raw_speeds)
removed = len(raw_speeds) - len(cleaned)

print("=== EXERCISE 1 ===")
print(f"Cleaned: {cleaned}")
print(f"Removed: {removed} invalid records")

# INTERVIEW POINT: Why 'is not None' and not '!= None'?
# None is a SINGLETON in Python. There is only ONE None object in memory.
# 'is' checks identity (same object). '==' calls __eq__ which can be overridden.
# PEP 8 (Python style guide) explicitly says: use 'is None' / 'is not None'


# ==========================================================
# EXERCISE 2 - Frequency Counter  [Beginner]
# ==========================================================
"""
YOUR ATTEMPT WAS MOSTLY CORRECT — but had one critical mistake:
  BUG: You named your dict 'map'
  'map' is a Python built-in function (map(func, iterable))
  Naming a variable 'map' DESTROYS the built-in for the rest of the file.
  Never shadow built-ins: map, list, dict, type, id, input, print, etc.

WHAT YOU GOT RIGHT:
  freq.get(item, 0) + 1  ← PERFECT pattern for frequency counting
  This is EXACTLY how experienced engineers do it.

WHAT WAS MISSING: parts b, c, d
"""

accidents = ["Fatal", "Serious", "Slight", "Fatal", "Slight",
             "Fatal", "Serious", "Slight", "Fatal", "Slight"]

# ── CORRECT SOLUTION ──────────────────────────────────────

print("\n=== EXERCISE 2 ===")

# Part a — Manual frequency count (no imports)
freq = {}  # <-- renamed from 'map' to 'freq' (descriptive + not a builtin)
for item in accidents:
    freq[item] = freq.get(item, 0) + 1
print("Manual dict:", freq)

# Part b — With Counter (import from standard library)
from collections import Counter
counter = Counter(accidents)
print("Counter result:", dict(counter))
# Both give the same result — Counter is cleaner for this exact use case

# Part c — Most common severity
most_common = max(freq, key=freq.get)
# max() iterates over keys, uses freq.get as the comparison function
# So it finds the key with the highest value
print(f"Most common: {most_common}")

# Part d — Percentage breakdown
total = len(accidents)
for severity, count in freq.items():
    pct = round(count / total * 100, 1)
    print(f"  {severity}: {count} ({pct}%)")

# INTERVIEW POINT: What is the time complexity of freq.get()?
# O(1) average — dict lookup uses a hash table, not linear search.
# This is WHY dicts are used for counting, not lists.


# ==========================================================
# EXERCISE 3 - Record Transformer  [Intermediate]
# ==========================================================
"""
YOUR ATTEMPT WAS WRONG APPROACH:
  You used sklearn OneHotEncoder and pandas DataFrame.
  This exercise is asking for PURE PYTHON logic — functions, dicts, conditions.

  The problem: A senior engineer reading your code sees
  "they reached for ML tools instead of writing basic functions."
  That signals you don't yet own the fundamentals.

  The rule: Master the tool BEFORE using the library that wraps it.

KEY CONCEPT: {**record, "key": value}
  This creates a NEW dict by unpacking all fields from 'record'
  and adding a new key. It does NOT modify the original.
  This is how you add fields immutably in Python.
"""

raw_data = [
    {"id": 1, "severity": "Fatal",   "speed": 80,  "casualties": 3},
    {"id": 2, "severity": "Slight",  "speed": 30,  "casualties": 0},
    {"id": 3, "severity": "Serious", "speed": 60,  "casualties": 1},
    {"id": 4, "severity": "Fatal",   "speed": 120, "casualties": 5},
    {"id": 5, "severity": "Slight",  "speed": 50,  "casualties": 0},
]

# ── CORRECT SOLUTION ──────────────────────────────────────

def get_risk_level(record: dict) -> str:
    """
    Determine risk level from a single accident record.
    Order of conditions MATTERS — check most severe first.
    """
    # Critical: Fatal AND high casualties
    if record["severity"] == "Fatal" and record["casualties"] >= 3:
        return "Critical"
    # High: Fatal OR very high speed
    elif record["severity"] == "Fatal" or record["speed"] >= 100:
        return "High"
    # Medium: any casualties
    elif record["casualties"] >= 1:
        return "Medium"
    # Low: everything else
    else:
        return "Low"


def transform_records(records: list) -> list:
    """
    Add 'risk_level' to each record WITHOUT modifying the originals.
    Uses dict unpacking: {**record, "risk_level": ...}
    """
    return [
        {**record, "risk_level": get_risk_level(record)}
        for record in records
    ]


print("\n=== EXERCISE 3 ===")
transformed = transform_records(raw_data)

for r in transformed:
    print(f"  ID {r['id']}: severity={r['severity']}, risk={r['risk_level']}")

# Part c — Count Critical or High
high_risk_count = sum(
    1 for r in transformed
    if r["risk_level"] in {"Critical", "High"}
)
print(f"Critical or High: {high_risk_count}")

# Verify originals are untouched
print(f"Original still clean: {'risk_level' not in raw_data[0]}")

# INTERVIEW POINT: Why {**record, "key": val} instead of record.copy()?
# Both work for shallow copies. The dict unpacking syntax is more Pythonic
# for creating a modified copy in a single expression (great in comprehensions).


# ==========================================================
# EXERCISE 4 - Generator Pipeline  [Intermediate]
# ==========================================================
"""
NEW CONCEPT: generator function with 'yield'

A generator function uses 'yield' instead of 'return'.
When called, it returns a generator OBJECT (not the values).
Values are produced ONE AT A TIME when you call next() or iterate.

WHY THIS MATTERS IN PRODUCTION:
  generate_accidents(10_000_000) — does NOT create 10M dicts in RAM.
  It creates ONE dict at a time, processes it, discards it.
  This is how real ETL pipelines work.
"""

import random

# ── CORRECT SOLUTION ──────────────────────────────────────

def generate_accidents(n: int):
    """
    Generator: yields n fake accident records one at a time.
    Each record is a dict with id, speed, severity.
    """
    severities = ["Fatal", "Serious", "Slight"]

    for i in range(n):
        yield {
            "id": i + 1,
            "speed": random.randint(20, 130),
            "severity": random.choice(severities)
        }
    # When the loop ends, the generator is 'exhausted'
    # Next call to next() raises StopIteration


def filter_fatal(records):
    """
    Generator: takes ANY iterable of records,
    yields only the fatal ones.
    This is a 'generator pipeline' pattern.
    """
    for record in records:
        if record["severity"] == "Fatal":
            yield record


print("\n=== EXERCISE 4 ===")

# Chain: generate 1000 → filter fatal → count
# NOTHING is stored in memory — it streams record by record
fatal_count = sum(1 for _ in filter_fatal(generate_accidents(1000)))
print(f"Fatal accidents in 1000 generated: {fatal_count}")

# VISUAL of what happens in memory:
# generate_accidents(1000)  → produces 1 dict
#                           ↓ (immediately passed to)
# filter_fatal(...)         → checks if Fatal, yields or discards
#                           ↓
# sum(...)                  → increments counter
#
# At any moment, only 1 record exists in memory. Not 1000.

# INTERVIEW POINT: Can you reuse a generator?
gen = generate_accidents(5)
list1 = list(gen)   # Consumes the generator
list2 = list(gen)   # list2 is [] — generator is exhausted!
print(f"Generator exhaustion: list2 = {list2}  (empty, as expected)")


# ==========================================================
# EXERCISE 5 - Class Design  [Intermediate]
# ==========================================================
"""
NEW CONCEPTS:
  @property  — access a method like an attribute (no parentheses needed)
  __repr__   — what Python shows when you type the object in a REPL
  __len__    — lets you call len() on your custom object
  __init__   — constructor, runs when you create an instance
"""

# ── CORRECT SOLUTION ──────────────────────────────────────

class AccidentDataset:
    """
    A container for a collection of accident records.
    Demonstrates OOP patterns used in real ML codebases.
    """

    def __init__(self, records: list):
        # Store records privately (convention: _ prefix = internal)
        self._records = records

    @property
    def total_count(self) -> int:
        """
        @property makes this accessible as dataset.total_count
        instead of dataset.total_count() — no parentheses needed.
        """
        return len(self._records)

    def get_by_severity(self, severity: str) -> list:
        """Return all records matching the given severity."""
        return [r for r in self._records if r["severity"] == severity]

    def summary(self) -> dict:
        """Return a statistical summary of the dataset."""
        total = len(self._records)
        if total == 0:
            return {}

        speeds = [r["speed"] for r in self._records]

        return {
            "total": total,
            "fatal_count": sum(1 for r in self._records if r["severity"] == "Fatal"),
            "serious_count": sum(1 for r in self._records if r["severity"] == "Serious"),
            "slight_count": sum(1 for r in self._records if r["severity"] == "Slight"),
            "avg_speed": round(sum(speeds) / len(speeds), 2),
        }

    def __repr__(self) -> str:
        """
        __repr__ is shown in the REPL and in logs.
        Should be unambiguous — enough info to recreate the object.
        """
        return f"AccidentDataset(n={len(self._records)})"

    def __len__(self) -> int:
        """
        Allows: len(dataset) — feels natural to the user.
        """
        return len(self._records)


print("\n=== EXERCISE 5 ===")
dataset = AccidentDataset(raw_data)

print(dataset)                              # Uses __repr__
print(f"len(dataset) = {len(dataset)}")     # Uses __len__
print(f"total_count = {dataset.total_count}")  # Uses @property (no parentheses)
print(f"Fatal records: {dataset.get_by_severity('Fatal')}")
print(f"Summary: {dataset.summary()}")

# INTERVIEW POINT: What is the difference between __repr__ and __str__?
# __repr__ → for developers, shown in REPL, used in logging
# __str__  → for end users, used in print()
# If only __repr__ is defined, Python uses it for both.


# ==========================================================
# EXERCISE 6 - Decorator Chain  [Advanced]
# ==========================================================
"""
KEY CONCEPTS:
  - A decorator is a function that WRAPS another function
  - @functools.wraps preserves the wrapped function's metadata
    (name, docstring). Without it, func.__name__ returns 'wrapper'.
  - Stacking decorators: @logger on top of @timer
    This means: logger wraps the timer-wrapped function
    Execution order: logger → timer → actual function → timer → logger
"""

import time
import functools

# ── CORRECT SOLUTION ──────────────────────────────────────

def timer(func):
    """Decorator: measures and prints execution time."""
    @functools.wraps(func)   # <-- ALWAYS include this!
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)  # calls the real function
        elapsed = time.perf_counter() - start
        print(f"  [TIMER] {func.__name__} took {elapsed:.6f}s")
        return result
    return wrapper


def logger(func):
    """Decorator: logs function name and arguments before calling."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        args_str = ", ".join(str(a) for a in args)
        kwargs_str = ", ".join(f"{k}={v}" for k, v in kwargs.items())
        all_args = ", ".join(filter(None, [args_str, kwargs_str]))
        print(f"  [LOGGER] Calling {func.__name__}({all_args})")
        result = func(*args, **kwargs)
        print(f"  [LOGGER] {func.__name__} returned: {result}")
        return result
    return wrapper


@logger   # Applied SECOND (outer layer)
@timer    # Applied FIRST (inner layer)
def analyze_batch(records: list, threshold: float = 0.7) -> int:
    """Count records with risk score above threshold."""
    # Simple risk score: speed / 120 + 0.2 if fatal
    def score(r):
        return r["speed"] / 120 + (0.2 if r["severity"] == "Fatal" else 0)
    return sum(1 for r in records if score(r) > threshold)


print("\n=== EXERCISE 6 ===")
result = analyze_batch(raw_data, threshold=0.7)
print(f"  Records above threshold: {result}")

# CALL STACK EXPLANATION:
# analyze_batch(raw_data, 0.7)
#   → logger.wrapper is called first (outer)
#     → logs the call
#     → calls timer.wrapper (inner)
#       → starts timer
#       → calls REAL analyze_batch
#       → stops timer, prints time
#     → returns result
#   → logger logs the return value
#   → returns result to caller


# ==========================================================
# EXERCISE 7 - Mutable Trap Debug  [Advanced]
# ==========================================================
"""
THE BUG: mutable default argument

In Python, default argument values are evaluated ONCE
when the function is DEFINED — not each time it is called.

So 'defaults={"weather": "Clear", "light": "Daylight"}'
creates ONE dict object at function definition time.
All calls to the function SHARE this same dict object.

When result["weather"] = "Rain" modifies the dict,
it modifies the SHARED default object.
The NEXT call to the function sees the modified dict!
"""

print("\n=== EXERCISE 7 ===")

# ── BUGGY CODE (do NOT run in production) ────────────────
def add_default_features_BUGGY(record, defaults={"weather": "Clear", "light": "Daylight"}):
    record.update(defaults)
    return record

# ── THE FIX ───────────────────────────────────────────────
def add_default_features(record: dict, defaults: dict = None) -> dict:
    """
    FIX 1: Use None as the default, create a new dict inside the function.
    FIX 2: Don't modify the original record — return a new dict.

    The golden rule: NEVER use mutable objects as default arguments.
    Use None instead, then create the mutable inside the function body.
    """
    if defaults is None:
        defaults = {"weather": "Clear", "light": "Daylight"}

    # Create a NEW dict — don't modify the original record
    return {**record, **defaults}


records = [
    {"id": 1, "severity": "Fatal"},
    {"id": 2, "severity": "Slight"},
]

for rec in records:
    result = add_default_features(rec)
    result["weather"] = "Rain"   # Only modifies THIS result, not the default
    print(f"  Result: {result}")
    print(f"  Original: {rec}")  # Original is untouched

# MEMORY DIAGRAM:
#
# BUGGY VERSION:
#   Function definition → creates ONE dict: {"weather": "Clear", "light": "Daylight"}
#   Call 1: result modifies defaults → {"weather": "Rain", "light": "Daylight"}
#   Call 2: sees the ALREADY MODIFIED defaults dict!
#
# FIXED VERSION:
#   Function definition → defaults=None (None is immutable, safe!)
#   Call 1: creates NEW dict {"weather": "Clear"...}, modifies result
#   Call 2: creates ANOTHER NEW dict {"weather": "Clear"...}, fresh every time

# INTERVIEW POINT: Is there EVER a valid reason to use a mutable default?
# Yes! Caching (memoization):
def expensive_compute_CACHED(n: int, cache: dict = {}) -> int:
    """Using mutable default intentionally as a persistent cache."""
    if n not in cache:
        cache[n] = n * n   # Store result
    return cache[n]
# The shared dict is used as a simple cache across calls.
# This is intentional but should be documented clearly.


# ==========================================================
# SELF-EVALUATION CHECKLIST
# ==========================================================
"""
After studying these solutions, ask yourself WITHOUT looking:

[ ] Can I explain WHY generators save memory?
[ ] Can I explain mutable vs immutable from first principles?
[ ] Can I write a decorator from scratch without notes?
[ ] Can I design a class with properties and dunder methods?
[ ] Can I spot the mutable default argument bug by sight?
[ ] Can I use list/dict comprehensions naturally?
[ ] Can I explain why 'is not None' instead of '!= None'?
[ ] Can I explain what {**record, "key": val} does in memory?
[ ] Can I explain decorator execution order with a call stack?

If YES to all - you are ready for interview_questions.md
"""

# ---------------------------------------------------------
# EXERCISE 1 - Data Cleaning Filter  [Beginner]
# ---------------------------------------------------------
"""
You receive speed limits. Some are invalid: None, negative, >200.

raw_speeds = [60, None, -5, 30, 250, 70, None, 80, 120, -1]

Task:
  a) Write clean_speeds(speeds: list) -> list
     Remove invalid values in ONE list comprehension line.
  b) Print cleaned list and count of removed records.

Expected:
  Cleaned: [60, 30, 70, 80, 120]
  Removed: 5 invalid records
"""

raw_speeds = [60, None, -5, 30, 250, 70, None, 80, 120, -1]

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 2 - Frequency Counter  [Beginner]
# ---------------------------------------------------------
"""
accidents = ["Fatal","Serious","Slight","Fatal","Slight",
             "Fatal","Serious","Slight","Fatal","Slight"]

Task:
  a) Count frequency WITHOUT using Counter (use dict).
  b) Solve WITH Counter and compare.
  c) Find the most common severity.
  d) Calculate percentage for each (round to 1 decimal).
"""

accidents = ["Fatal", "Serious", "Slight", "Fatal", "Slight",
             "Fatal", "Serious", "Slight", "Fatal", "Slight"]

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 3 - Record Transformer  [Intermediate]
# ---------------------------------------------------------
"""
raw_data = [
    {"id": 1, "severity": "Fatal",   "speed": 80, "casualties": 3},
    {"id": 2, "severity": "Slight",  "speed": 30, "casualties": 0},
    {"id": 3, "severity": "Serious", "speed": 60, "casualties": 1},
    {"id": 4, "severity": "Fatal",   "speed": 120,"casualties": 5},
    {"id": 5, "severity": "Slight",  "speed": 50, "casualties": 0},
]

Risk Level Rules:
  "Critical" if severity=="Fatal" AND casualties >= 3
  "High"     if severity=="Fatal" OR speed >= 100
  "Medium"   if casualties >= 1
  "Low"      otherwise

Task:
  a) Write get_risk_level(record: dict) -> str
  b) Write transform_records(records: list) -> list
     Returns new dicts with risk_level added.
     Do NOT modify original dicts!
  c) Count how many are Critical or High.
"""

raw_data = [
    {"id": 1, "severity": "Fatal",   "speed": 80, "casualties": 3},
    {"id": 2, "severity": "Slight",  "speed": 30, "casualties": 0},
    {"id": 3, "severity": "Serious", "speed": 60, "casualties": 1},
    {"id": 4, "severity": "Fatal",   "speed": 120,"casualties": 5},
    {"id": 5, "severity": "Slight",  "speed": 50, "casualties": 0},
]

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 4 - Generator Pipeline  [Intermediate]
# ---------------------------------------------------------
"""
Task:
  a) Write generator: generate_accidents(n: int)
     Yields n fake accident dicts.
     Each: {"id": i, "speed": random 20-130, "severity": random choice}
  b) Write generator: filter_fatal(records)
     Takes a generator, yields only fatal records.
  c) Chain: generate 1000 records -> filter fatal -> count.

Hint: import random
"""

import random

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 5 - Class Design  [Intermediate]
# ---------------------------------------------------------
"""
Design class: AccidentDataset

  - Accepts list of accident dicts in __init__
  - Property: total_count -> int
  - Method: get_by_severity(severity: str) -> list
  - Method: summary() -> dict with keys:
      "total", "fatal_count", "serious_count",
      "slight_count", "avg_speed"
  - __repr__: shows "AccidentDataset(n=5)"
  - __len__: returns total count

Test with raw_data from Exercise 3.
"""

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 6 - Decorator Chain  [Advanced]
# ---------------------------------------------------------
"""
Build two decorators:
  1. @timer   - measures and prints execution time
  2. @logger  - prints function name + args before calling

Apply BOTH to:
  def analyze_batch(records: list, threshold: float = 0.7) -> int:
      Returns count of records with risk score above threshold

Stack order: @logger on top of @timer on top of function.
Question: What order do they execute? Explain it.
"""

import time
import functools

# YOUR SOLUTION:




# ---------------------------------------------------------
# EXERCISE 7 - Mutable Trap Debug  [Advanced]
# ---------------------------------------------------------
"""
Find and fix the bug:

def add_default_features(record, defaults={"weather": "Clear", "light": "Daylight"}):
    record.update(defaults)
    return record

records = [
    {"id": 1, "severity": "Fatal"},
    {"id": 2, "severity": "Slight"},
]
for rec in records:
    result = add_default_features(rec)
    result["weather"] = "Rain"
    print(result)

Tasks:
  a) What is the bug?
  b) Why does it happen? (hint: mutable default argument)
  c) Fix it properly.
  d) Explain what happens in memory.
"""

# PASTE BUGGY CODE, IDENTIFY THE BUG, THEN WRITE THE FIX:




# ---------------------------------------------------------
# SELF-EVALUATION CHECKLIST
# ---------------------------------------------------------
"""
After completing all exercises, ask yourself:

[ ] Can I explain WHY generators save memory?
[ ] Can I explain mutable vs immutable from first principles?
[ ] Can I write a decorator from scratch without notes?
[ ] Can I design a class with properties and dunder methods?
[ ] Can I spot the mutable default argument bug by sight?
[ ] Can I use list/dict comprehensions naturally?

If YES to all - you are ready for interview_questions.md
"""
