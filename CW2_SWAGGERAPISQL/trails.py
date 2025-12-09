# trails.py

from flask import abort, make_response
from config import db
from models import Trail, TrailLocationPoint, trail_schema, trails_schema

#1. GET
def read_all():
    #All trails are read and ordered by date created
    trails = Trail.query.order_by(Trail.date_created).all()
    return trails_schema.dump(trails)

#2. POST
def create(body):
    """
    Creates a new trail.
    """
    try:
        #Trail data is loaded from trail_id
        new_trail = trail_schema.load(body, session=db.session)
        
        #Commit to database
        db.session.add(new_trail)
        db.session.commit()
        
        return trail_schema.dump(new_trail), 201

    except Exception as e:
        print(f"Error creating trail: {e}")
        abort(400, f"Failed to create trail. Error: {str(e)}")

#3. GET
def read_one(trail_id):
    #Trail is found through trail_id
    trail = Trail.query.filter(Trail.trail_id == trail_id).one_or_none()

    if trail is not None:
        return trail_schema.dump(trail)
    else:
        abort(404, f"Trail with id {trail_id} not found")

#4. PUT
def update(trail_id, body):
    #Changes data to updated data through chosen trail_id
    existing_trail = Trail.query.filter(Trail.trail_id == trail_id).one_or_none()

    if existing_trail:
        update_trail = trail_schema.load(body, session=db.session) 
        
        #Update fields
        existing_trail.trail_name = update_trail.trail_name
        existing_trail.trail_description = update_trail.trail_description
        existing_trail.difficulty = update_trail.difficulty
        existing_trail.city = update_trail.city
        existing_trail.state = update_trail.state
        existing_trail.country = update_trail.country
        existing_trail.length = update_trail.length
        existing_trail.route_type = update_trail.route_type
        existing_trail.trailowner_id = update_trail.trailowner_id
        
        db.session.merge(existing_trail)
        db.session.commit()
        
        return trail_schema.dump(existing_trail), 200
    else:
        abort(404, f"Trail with id {trail_id} not found")

#5. DELETE 
def delete(trail_id):
    #Trail deletion by submitted trail_id
    existing_trail = Trail.query.filter(Trail.trail_id == trail_id).one_or_none()

    if existing_trail:
        db.session.delete(existing_trail)
        db.session.commit()
        return make_response(f"Trail {trail_id} successfully deleted", 204)
    else:
        abort(404, f"Trail with id {trail_id} not found")