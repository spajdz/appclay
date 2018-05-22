from flask import Flask, render_template, jsonify, make_response, request
from flaskext.mysql import MySQL
import sys
import pyexcel as pe 

app = Flask(__name__)

# app.config['MYSQL_DATABASE_USER'] = 'sql10239032'
# app.config['MYSQL_DATABASE_PASSWORD'] = 'X7WqIrwTgI'
# app.config['MYSQL_DATABASE_DB'] = 'sql10239032'
# app.config['MYSQL_DATABASE_HOST'] = 'sql10.freesqldatabase.com'

# app.config['MYSQL_DATABASE_USER'] = 'epiz_22122370'
# app.config['MYSQL_DATABASE_PASSWORD'] = '877666828'
# app.config['MYSQL_DATABASE_DB'] = 'epiz_22122370_clay'
# app.config['MYSQL_DATABASE_HOST'] = 'sql100.epizy.com'


# app.config['MYSQL_DATABASE_USER'] = 'dbclay'
# app.config['MYSQL_DATABASE_PASSWORD'] = 'dbclay123'
# app.config['MYSQL_DATABASE_DB'] = 'dbclay'
# app.config['MYSQL_DATABASE_HOST'] = 'db4free.net'

app.config['MYSQL_DATABASE_USER'] = 'bdclay'
app.config['MYSQL_DATABASE_PASSWORD'] = 'bdclay123'
app.config['MYSQL_DATABASE_DB'] = 'bdclay'
app.config['MYSQL_DATABASE_HOST'] = 'db4free.net'


mysql = MySQL()
mysql.init_app(app)

if mysql.connect():
    conn = mysql.connect()
    cursor = conn.cursor()

@app.route('/')
def index():
    return render_template('upload.html')


@app.route('/upload', methods=['GET', 'POST'])
def upload():

	if request.method == 'POST' and 'excel' in request.files:
                filename = request.files['excel'].filename

                extension = filename.split(".")[1]
                content = request.files['excel'].read()
             
                sheet = pe.get_sheet(file_type=extension, file_content=content)

                sheet.name_columns_by_row(0)

                data_sheet = sheet.to_array()

                cont = 0
                for r in data_sheet:
                    if cont != 0:
                        cursor.callproc('sp_insertRecord',(r[0],r[1], r[2], r[3], r[4] if r[4] else 0, r[5] if r[5] else 0, r[6] if r[6] else 0))
                        data = cursor.fetchall()
                        conn.commit()
                    cont += 1
                query = "SELECT * FROM cartola ORDER BY fecha DESC"
                if cursor.execute(query):
                    movimientos = cursor.fetchall()
                    # return jsonify(movimientos)
                    return render_template('upload.html',proccess='true' , filename=filename,movimientos=movimientos)
                else:
                    return render_template('upload.html',proccess='true' , filename=filename,err_sql='true')
                
	return render_template('upload.html')

if __name__ == "__main__":
	app.run()
