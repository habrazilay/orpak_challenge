from flask import Flask, jsonify
import os
import psycopg2
from psycopg2 import pool
import logging

# Configure Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Flask App
app = Flask(__name__)

# Initialize Database Connection Pool
try:
    db_pool = psycopg2.pool.SimpleConnectionPool(
        1, 10,  # Min and Max connections
        dbname=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        host=os.environ['DB_HOST'],
        port=os.environ['DB_PORT']
    )
    if db_pool:
        logger.info("Database connection pool created successfully.")
except Exception as e:
    logger.error(f"Error creating database connection pool: {e}")
    db_pool = None

@app.route('/')
def home():
    if not db_pool:
        return jsonify({"error": "Database connection pool not initialized"}), 500
    
    try:
        conn = db_pool.getconn()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        db_version = cur.fetchone()
        db_pool.putconn(conn)  # Return connection to the pool
        return jsonify({"message": "Connected to database", "version": db_version})
    except Exception as e:
        logger.error(f"Error querying database: {e}")
        return jsonify({"error": "Failed to query database"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
