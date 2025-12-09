# test_db.py
from config import db, app
from sqlalchemy import text

# Push the context so we can use the app's configuration
with app.app_context():
    try:
        # Try to run a simple query
        db.session.execute(text("SELECT 1"))
        print("✅ SUCCESS: Connected to the database!")
    except Exception as e:
        print("❌ FAILED: Could not connect.")
        print(e)