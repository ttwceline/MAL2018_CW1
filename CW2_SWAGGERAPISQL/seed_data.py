#seed_data.py
from config import app, db
from models import User

#Data from Assignment
REQUIRED_USERS = [
    {"user_id": 1, "username": "Ada Lovelace", "email": "grace@plymouth.ac.uk", "role": "user"},
    {"user_id": 2, "username": "Tim Berners-Lee", "email": "tim@plymouth.ac.uk", "role": "admin"},
    {"user_id": 3, "username": "Ada Lovelace", "email": "ada@plymouth.ac.uk", "role": "user"}
]

# ... rest of the script remains the same ...

with app.app_context():
    # Create the tables if they don't exist
    db.create_all()
    
    print("Checking for required users...")
    for data in REQUIRED_USERS:
        existing = User.query.get(data["user_id"])
        if not existing:
            print(f"Adding {data['username']}...")
            new_user = User(
                user_id=data["user_id"],
                username=data["username"],
                email=data["email"],
                role=data["role"]
            )
            db.session.add(new_user)
        else:
            print(f"User {data['username']} already exists.")
            
    db.session.commit()
    print("Database seeding complete!")
