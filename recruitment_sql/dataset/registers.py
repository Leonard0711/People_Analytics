import os
import sys
from sqlalchemy import create_engine, text

def get_engine():
    password = os.getenv("MYSQL_PASSWORD")
    if not password:
        print("La variable password no fue definida")
        sys.exit(1)
    try:
        mysql_engine = create_engine(f"mysql+pymysql://root:{password}@127.0.0.1:3306/RECRUITMENT",
                                     pool_pre_ping=True, pool_recycle=1800, future=True)
        return mysql_engine
    except Exception as e:
        print(f"El error presentado {e}")
        sys.exit(1)

def request_data():
    nombre = input("Nombre: ").strip()
    apellidos = input("Apellidos: ").strip()
    fecha_nacimiento = input("Fecha de nacimiento (YYYY-MM-DD): ").strip()
    telefono = input("Teléfono: ").strip()
    correo = input("Correo electrónico: ").strip()
    sexo = input("Sexo (M/F): ").strip().upper()
    if not nombre:
        print("El campo 'nombre' debe estar completo")
        sys.exit(1)
    if not apellidos:
        print("El campo 'apellidos' debe estar completo")
        sys.exit(1)
    if not fecha_nacimiento:
        print("El campo 'fecha de nacimiento' debe estar completo")
        sys.exit(1)
    if not correo:
        print("El campo 'correo electrónico' debe estar completo")
        sys.exit(1)
    if sexo not in ['M', 'F']:
        print("El campo 'sexo' debe ser 'M' o 'F'")
        sys.exit(1)
    return nombre, apellidos, fecha_nacimiento, telefono, correo, sexo

def candidates_register(engine, nombre, apellidos, fecha_nacimiento, telefono, email, sexo):
    t = text("""
             INSERT INTO candidatos (nombre, apellidos, fecha_nacimiento, telefono, email, sexo)
             VALUES (:n, :a, :f, :tl, :e, :s)
             """)
    try:
        with engine.begin() as conn:
            conn.execute(t, {"n": nombre, "a": apellidos, "f": fecha_nacimiento, 
                             "tl": telefono, "e": email, "s": sexo})
            print("Candidato registrado")
    except Exception as e:
        print(f"Error al registrar al candidato: {e}")
        sys.exit(1)

def main():
    engine = get_engine()
    nombre, apellidos, fecha_nacimiento, telefono, correo, sexo = request_data()
    candidates_register(engine, nombre, apellidos, fecha_nacimiento, telefono, correo, sexo)

if __name__ == "__main__":
    main()
