"""
Module 01 - Python Fundamentals: Practice File
===============================================
INSTRUCTIONS:
  - Read each task description carefully.
  - Write YOUR code in the space provided.
  - Do NOT look at answers first - try yourself.
  - Run this file: python practice.py

Domain: Accident Risk Analysis
"""

# ---------------------------------------------------------
# TASK 1: Variables and Data Types
# ---------------------------------------------------------
# Create variables for one accident record:
#   accident_id  (integer)
#   severity     (string: "Fatal", "Serious", or "Slight")
#   speed_limit  (float, in km/h)
#   is_rainy     (boolean)
#   casualties   (integer)
#
# Then print each value with its type.
# Example: "accident_id = 1001 | type = <class 'int'>"
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 2: List Operations
# ---------------------------------------------------------
severity_labels = ["Fatal", "Serious", "Slight", "Fatal",
                   "Slight", "Fatal", "Serious"]

# 2a. Print the number of accidents.
# 2b. Print the first and last label.
# 2c. Print how many are "Fatal" (use .count())
# 2d. Create a list of UNIQUE severities (use set + list).
# 2e. Sort the unique list alphabetically.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 3: Dictionary
# ---------------------------------------------------------
# Create a dictionary for accident record #2045.
# Fields: id, severity, speed_limit, weather, hour_of_day, casualties
#
# 3a. Access the weather field safely with .get() and a default.
# 3b. Add a new field: road_type = "Single carriageway"
# 3c. Print all keys and values in a formatted way.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 4: List Comprehension
# ---------------------------------------------------------
speed_limits = [30, 60, 70, 60, 50, 120, 80, 30, 100, 70]

# 4a. New list of speed limits ABOVE 60 km/h.
# 4b. New list normalized to [0,1] (divide each by max).
# 4c. Dict mapping each speed to category:
#     <= 30: "Low"  |  <= 60: "Medium"  |  > 60: "High"
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 5: Function with Type Hints
# ---------------------------------------------------------
# Write: calculate_risk_score(speed, weather, hour) -> float
#
# Rules:
#   Base score = speed / 120.0
#   Add 0.2 if weather is "Rain" or "Fog"
#   Add 0.15 if hour < 6 or hour >= 22 (nighttime)
#   Clamp final score to max 1.0
#
# Add type hints and a docstring. Test with 3 inputs.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 6: Generator
# ---------------------------------------------------------
sample_records = [
    {"id": 1, "severity": "Fatal",   "speed": 80},
    {"id": 2, "severity": "Slight",  "speed": 30},
    {"id": 3, "severity": "Serious", "speed": 60},
]

# Write: stream_accidents(records) - yields one dict at a time.
# Then consume the generator in a for loop and print each record.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 7: Decorator
# ---------------------------------------------------------
# Write a decorator: validate_input
#   - Prints "Validating inputs..." before function runs
#   - Prints "Validation passed. Running function..." after
#   - Then calls the actual function and returns its result
#
# Apply it to calculate_risk_score from Task 5.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 8: Class (OOP)
# ---------------------------------------------------------
# Create class: AccidentRecord
#
# Attributes (in __init__):
#   accident_id: int
#   severity: str
#   speed_limit: float
#   casualties: int
#
# Methods:
#   is_fatal() -> bool
#   summary() -> str (returns a formatted description)
#
# Create 2 instances and call all methods.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 9: Error Handling
# ---------------------------------------------------------
# Write: validate_casualties(count: int) -> int
# Raise ValueError if count is negative.
# Test with valid and invalid inputs.
# Catch the error gracefully and print a helpful message.
#
# YOUR CODE HERE:




# ---------------------------------------------------------
# TASK 10: Putting It All Together
# ---------------------------------------------------------
# Write: process_accident_batch(records: list) -> dict
#
# Returns summary dict with:
#   "total": count
#   "fatal_count": number fatal
#   "avg_speed": average speed
#   "high_risk": list of IDs with score > 0.7
#
# Test with sample_records + 2 more you create.
#
# YOUR CODE HERE:
