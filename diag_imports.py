
import sys
results = []

# Test 1: flask
try:
    import flask
    results.append(f"flask: {flask.__version__}")
except Exception as e:
    results.append(f"flask ERROR: {e}")

# Test 2: flask_sqlalchemy
try:
    import flask_sqlalchemy
    results.append("flask_sqlalchemy ok")
except Exception as e:
    results.append(f"flask_sqlalchemy ERROR: {e}")

# Test 3: flask_cors
try:
    import flask_cors
    results.append("flask_cors ok")
except Exception as e:
    results.append(f"flask_cors ERROR: {e}")

for r in results:
    print(r)
