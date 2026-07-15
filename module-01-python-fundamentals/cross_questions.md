# Module 01 - Cross Questions: Python Deep Dives

These are follow-up questions an experienced interviewer asks
AFTER your initial answer. These separate candidates who memorized
from those who truly understand.

---

## After "What is a generator?"

CQ1. Show me step-by-step what happens when Python executes
     next() on a generator with a yield inside a loop.

CQ2. What happens when a generator is exhausted?
     What exception does Python raise? How do you handle it?

CQ3. Can you send values INTO a generator?
     What is generator.send() used for?

CQ4. If I do list(my_generator), does it defeat the purpose?

CQ5. You have two generators: stream_records() and filter_fatal().
     How do you chain them efficiently? What is this pattern called?

---

## After "What is a decorator?"

CQ6. If I stack two decorators, which executes first?
     Draw the call stack.

CQ7. Why do you use @functools.wraps(func)?
     What breaks without it?

CQ8. Can a decorator accept arguments itself?
     Show me a decorator factory.

CQ9. What is the difference between a class-based decorator
     and a function-based decorator? When do you prefer each?

CQ10. Your decorator adds 3ms latency to every prediction.
      How do you profile this? What would you do?

---

## After "Mutable vs Immutable"

CQ11. You said integers are immutable. But x = 5; x += 1 changes x.
      What actually happens in memory?

CQ12. Python interns small integers (-5 to 256).
      What does this mean and why does it matter?

CQ13. If a = (1, 2, [3, 4]), is this tuple immutable?
      Can I change it?

CQ14. When you copy a list with list.copy(), is it shallow or deep?
      In what situation does this cause a bug?

---

## After "Explain OOP in Python"

CQ15. What is the difference between composition and inheritance?
      Which do Google engineers prefer and why?

CQ16. What is the Method Resolution Order (MRO)?
      How does Python resolve which method to call in multiple inheritance?

CQ17. Your AccidentRecord class has 50 attributes and you are creating
      5 million instances. Memory is running out. How do you fix this?
      (Expected answer: __slots__)

CQ18. What does __repr__ vs __str__ do?
      Which is used in logging and which in print()?

---

## After "What are type hints?"

CQ19. Type hints are optional and not enforced at runtime.
      Why do they still matter in production?

CQ20. What is the difference between List[int] (typing module)
      and list[int] (Python 3.9+)?

CQ21. How does FastAPI use type hints to validate incoming data?
      Explain the connection to Pydantic.

---

## After "Python memory management"

CQ22. What is the difference between del x and x = None?
      Does either immediately free memory?

CQ23. Your ML training script runs 8 hours. After 6 hours,
      memory suddenly spikes. What are your first 3 debugging steps?

CQ24. When would you use weakref? How does it relate to the GC?

---

## Synthesis Questions (After All Topics)

SQ1. Design a Python module structure for an ML pipeline.
     What classes, functions, and patterns would you use?
     Walk me through your design decisions.

SQ2. Your team has 5 ML engineers writing Python in different styles.
     How do you enforce consistency?
     What tools and conventions do you introduce?

SQ3. A junior engineer submitted this PR:
```python
def process(data, cache={}):
    if data["id"] not in cache:
        cache[data["id"]] = expensive_compute(data)
    return cache[data["id"]]
```
What do you say in code review?
Is there a case where this is actually intentional?

SQ4. FAANG interview: Implement a thread-safe LRU cache in Python
     from scratch. Where do you start?

---

## Self-Assessment After Each Session

Rate yourself 1-5:

| Topic                    | Self-Rating | Notes |
|--------------------------|-------------|-------|
| Mutable vs Immutable     | /5          |       |
| Generators               | /5          |       |
| Decorators               | /5          |       |
| OOP and Classes          | /5          |       |
| Type Hints               | /5          |       |
| Memory Model             | /5          |       |
| Error Handling           | /5          |       |
| List/Dict Comprehensions | /5          |       |

Target: All 5/5 before moving to Module 02 (NumPy)
