import mysql.connector
from mysql.connector import Error
# https://github.com/ItzHiroW/devasc-study-team

# Angel Ruben Morales Ochoa - S5A - 23270049 - 10/03/2025


def connect():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='oracle',
            port=3306,
            database='Practica05_dbtaller_23270049'
        )
        if connection.is_connected():
            print("Conexión exitosa")
            return connection
    except Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        return None

def crear_prof(clave_prof, nombre_prof, rubrica_id, rubrica_area_conocimiento_id):
    connection = connect()
    if connection:
        try:
            cursor = connection.cursor()
            sql = ("INSERT INTO Profesor (clave_prof, nombre_prof, rubrica_id, rubrica_area_conocimiento_id) "
                   "VALUES (%s, %s, %s, %s)")
            valores = (clave_prof, nombre_prof, rubrica_id, rubrica_area_conocimiento_id)
            cursor.execute(sql, valores)
            connection.commit()
            print("Profesor creado exitosamente")
        except Error as e:
            print(f"Error al crear el Profesor: {e}")
        finally:
            cursor.close()
            connection.close()

def leer_prof():
    connection = connect()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM Profesor")
            resultados = cursor.fetchall()
            for fila in resultados:
                # Imprime: (clave_prof, nombre_prof, rubrica_id, rubrica_area_conocimiento_id)
                print(f"Clave: {fila[0]}, Nombre: {fila[1]}, Rubrica ID: {fila[2]}, Área Conocimiento ID: {fila[3]}")
        except Error as e:
            print(f"Error al leer los profesores: {e}")
        finally:
            cursor.close()
            connection.close()

def actualizar_prof(clave_prof, nuevo_nombre, nuevo_rubrica_id, nuevo_rubrica_area_conocimiento_id):
    connection = connect()
    if connection:
        try:
            cursor = connection.cursor()
            sql = ("UPDATE Profesor SET nombre_prof = %s, rubrica_id = %s, "
                   "rubrica_area_conocimiento_id = %s WHERE clave_prof = %s")
            valores = (nuevo_nombre, nuevo_rubrica_id, nuevo_rubrica_area_conocimiento_id, clave_prof)
            cursor.execute(sql, valores)
            connection.commit()
            print("Profesor actualizado exitosamente")
        except Error as e:
            print(f"Error al actualizar el Profesor: {e}")
        finally:
            cursor.close()
            connection.close()

def eliminar_prof(clave_prof):
    connection = connect()
    if connection:
        try:
            cursor = connection.cursor()
            sql = "DELETE FROM Profesor WHERE clave_prof = %s"
            valores = (clave_prof,)
            cursor.execute(sql, valores)
            connection.commit()
            print("Profesor eliminado exitosamente")
        except Error as e:
            print(f"Error al eliminar el Profesor: {e}")
        finally:
            cursor.close()
            connection.close()

# Ejemplos de uso:
crear_prof('01', 'Néstor Antonio Morales Navarro', 1, 10)
crear_prof('02', 'Walter Torres Robledo', 2, 20)
leer_prof()
actualizar_prof('01', 'Jesús Carlos Sánchez Guzmán', 1, 10)
leer_prof()
eliminar_prof('02')
leer_prof()

#En el adminsitrador de archivos: C:\ABDS5A\Practicas - Git Presionar directorio y poner CMD para abrir directo en el directorio la ubicacion del entorno virtual
#python -m venv bdatos
#python tipo_proyectos.py