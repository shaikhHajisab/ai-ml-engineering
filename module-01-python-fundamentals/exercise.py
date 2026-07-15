"""
Module 01 - Python Fundamentals: Exercises
===========================================
Set a timer. Attempt WITHOUT notes first.
Only refer to notes.md if truly stuck.
Domain: Accident Risk Analysis Dataset
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
