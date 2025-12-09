#models.py

from datetime import datetime
from marshmallow_sqlalchemy import fields
from config import db, ma

#Trail Table
class Trail(db.Model):
    __tablename__ = "Trail"
    __table_args__ = {"schema": "CW2"}

    trail_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    trail_name = db.Column(db.String(100), nullable=False)
    trail_description = db.Column(db.String)
    difficulty = db.Column(db.String(50))
    city = db.Column(db.String(100))
    state = db.Column(db.String(100))
    country = db.Column(db.String(100))
    length = db.Column(db.Float)
    route_type = db.Column(db.String(50))
    date_created = db.Column(db.DateTime, default=datetime.now)
    trailowner_id = db.Column(db.Integer, nullable=False)

    # Relationship to Points
    points = db.relationship(
        'TrailLocationPoint',
        backref='trail',
        cascade='all, delete-orphan',
        order_by='TrailLocationPoint.trail_sequence'
    )

#Location Point Table
class TrailLocationPoint(db.Model):
    __tablename__ = "TrailLocationPoint"
    __table_args__ = {"schema": "CW2"}

    traillocationpoint_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    trail_latitude = db.Column(db.Float, nullable=False)
    trail_longitude = db.Column(db.Float, nullable=False)
    trail_sequence = db.Column(db.Integer, nullable=False)

    trail_id = db.Column(db.Integer, db.ForeignKey('CW2.Trail.trail_id'), nullable=False)

#schemas
class TrailLocationPointSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = TrailLocationPoint
        load_instance = True
        sqla_session = db.session
        include_fk = True 
    
   
    trail_id = ma.auto_field(dump_only=True)

class TrailSchema(ma.SQLAlchemyAutoSchema):
    points = fields.Nested(TrailLocationPointSchema, many=True)

    class Meta:
        model = Trail
        load_instance = True
        sqla_session = db.session
        include_relationships = True

trail_schema = TrailSchema()
trails_schema = TrailSchema(many=True)