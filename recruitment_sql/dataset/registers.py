import os
import sys
from sqlalchemy import create_engine, text
from typing import Union
import pandas as pd

password = os.getenv("MYSQL_PASSWORD")
if not password:
    print("La variable password no fue definida")

mysql_engine = create_engine(
    f"mysql+pymysql://root:{password}@127.0.0.1:3306/RECRUITMENT",
    pool_pre_ping=True, pool_recycle=1800, future=True
    )

def read_query(query: str, params: dict = None):
    with mysql_engine.connect() as conn:
        result = conn.execute(text(query), params or {})
        return result.fetchall()

def read_query_pd(query: str, params: dict = None) -> pd.DataFrame:
    with mysql_engine.connect() as conn:
        return pd.read_sql(text(query), conn, params=params)

def export_query_df(df: pd.DataFrame, name_path: str,
                    index: bool=False) -> None:
    df.to_csv(name_path, index=index)

def write_query(query: str, params: Union[dict, list]):
    with mysql_engine.begin() as conn:
        conn.execute(text(query), params or {})

if __name__ == "__main__":
    pass