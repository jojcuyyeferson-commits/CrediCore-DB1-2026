SERVER = '127.0.0.1,14330'
DATABASE = 'CrediCore'
USERNAME = 'sa'
PASSWORD = 'UnaContraseñaNueva123!'

conn_str = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={SERVER};'
    f'DATABASE={DATABASE};'
    f'UID={USERNAME};'
    f'PWD={PASSWORD}'
)

import streamlit as st
import pandas as pd
import pyodbc
import time

SERVER = '127.0.0.1,14330'
DATABASE = 'CrediCore'
USERNAME = 'sa'
PASSWORD = 'UnaContraseñaNueva123!'

conn_str = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={SERVER};'
    f'DATABASE={DATABASE};'
    f'UID={USERNAME};'
    f'PWD={PASSWORD}'
)

st.set_page_config(
    page_title="ERP CrediCore",
    layout="centered"
)

st.title("🏦 CrediCore - Módulo de Caja")
st.markdown(
    "Interfaz conectada directamente al motor transaccional de SQL Server"
)

# Conexión a SQL Server
try:
    conn = pyodbc.connect(conn_str)

    st.success("Conexión establecida con CrediCore")

except Exception as e:
    st.error(f"Error de conexión a la BD: {e}")
    st.stop()


# ==========================================
# ESTADO DE CUENTA
# ==========================================

st.subheader("Estado de Cuenta (Vista Segura)")

try:
    query = "SELECT * FROM vw_AtencionAlCliente"

    df = pd.read_sql(query, conn)

    st.dataframe(
        df,
        use_container_width=True
    )

except Exception as e:
    st.error(f"Error al consultar la vista: {e}")


st.divider()


# ==========================================
# PROCESAR PAGO
# ==========================================

st.subheader("Procesar Pago de Cuota")

with st.form("form_pago", clear_on_submit=True):

    id_credito = st.number_input(
        "Número de Crédito (ID)",
        min_value=1,
        step=1
    )

    monto_pago = st.number_input(
        "Monto a Abonar (Q)",
        min_value=1.0,
        step=100.0
    )

    btn_pagar = st.form_submit_button(
        "Ejecutar Transacción"
    )

    if btn_pagar:

        try:

            cursor = conn.cursor()

            cursor.execute(
                """
                EXEC SP_ProcesarPago
                    @IdCredito = ?,
                    @MontoAbono = ?
                """,
                int(id_credito),
                float(monto_pago)
            )

            conn.commit()

            st.success(
                "¡Pago procesado con éxito en SQL Server!"
            )

            time.sleep(3)

            st.rerun()

        except Exception as e:

            st.error(
                f"Transacción Rechazada por el Motor: {e}"
            )