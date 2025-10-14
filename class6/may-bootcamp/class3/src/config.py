import os

variable_which_i_wont_use = "this is a variable which i wont use"


class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv("DB_LINK")
    #SQLALCHEMY_DATABASE_URI = "postgresql://postgres:admin123456@student-portal-tfdb.cgh22wq6k3xy.us-east-1.rds.amazonaws.com:5432/ECS_SP"
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
