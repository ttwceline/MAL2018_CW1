#users.py
from flask import abort
from config import db
from models import Users, user_schema, users_schema

def read_all():
    users = Users.query.all()
    return users_schema.dump(users)

def create(body):
    user_id = body.get("user_id")
    existing_user = Users.query.filter(Users.user_id == user_id).one_or_none()

    if existing_user is None:
        new_user = user_schema.load(body, session=db.session)
        db.session.add(new_user)
        db.session.commit()
        return user_schema.dump(new_user), 201
    else:
        abort(409, f"User with ID {user_id} already exists")
