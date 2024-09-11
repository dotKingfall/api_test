from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import sqlite3

ensure_table_creation = '''CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, hobbies TEXT, age INTEGER)'''

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

cnn = None
arrow = None

@app.get("/")
async def root():
    return {"value": "Rest assured, the API is running smoothly."}

@app.get("/list")
async def fetch_user_list():
    cnn = await connect_db()
    arrow = cnn.cursor()
    arrow.execute(ensure_table_creation)
    
    res = []
    for row in arrow.execute("SELECT * FROM users"):
        res.append(
            {
                "id": row[0],
                "fname": "{}".format(row[1]),
                "lname": "{}".format(row[2]),
                "hobbies": "{}".format(row[3]),
                "age": row[4]
            }
        )
        
    cnn.close()
    print("Data sent successfully.")
    return res    
    
@app.post("/add")
async def create_user(id, fname, lname, hobbies, age):
    cnn = await connect_db()
    arrow = cnn.cursor()
    arrow.execute(ensure_table_creation)
    
    arrow.execute("INSERT INTO users VALUES ({0}, '{1}', '{2}', '{3}', {4})".format(id, fname, lname, hobbies, age))
    cnn.commit()
    cnn.close()
    print("You added data successfully.")
    return {"res": 0}
    
@app.put("/updt")
async def update_user(id, fname_new, lname_new, hobbies_new, age_new):
    cnn = await connect_db()
    arrow = cnn.cursor()
    arrow.execute(ensure_table_creation)
    
    arrow.execute("UPDATE users SET fname = '{}', lname = '{}', hobbies = '{}', age = {} WHERE id = {};"
                  .format(fname_new, lname_new, hobbies_new, age_new, id))
    cnn.commit()
    cnn.close()
    print("You updated data successfully.")
    return {"res": 0}
    
@app.delete("/del")
async def delete_user(id):
    cnn = await connect_db()
    arrow = cnn.cursor()
    arrow.execute(ensure_table_creation)
    
    arrow.execute("DELETE FROM users WHERE id = {};".format(id))
    cnn.commit()
    cnn.close()
    print("You deleted data successfully.")
    return {"res": 0}


async def connect_db():    
    try:
        connetion = sqlite3.connect("user.db")
        print("Successfully connected database.")
        return connetion
    
    except sqlite3.Error as error:
        print("Error,", error)
        connetion.close()