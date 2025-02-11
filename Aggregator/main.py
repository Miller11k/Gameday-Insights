from data_ingestion.initial_ingest import initialize_database, populate_database
from data_ingestion.team_aggregator import aggregate_team_game_logs
from sqlalchemy.orm import sessionmaker

def main():
    print("Starting main process...")
    engine = initialize_database()
    
    # Populate the database with raw data
    populate_database(engine, years=[2022, 2023, 2024])
    
    # Create a new session to perform the aggregation
    Session = sessionmaker(bind=engine)
    session = Session()
    try:
        aggregate_team_game_logs(session)
    finally:
        session.close()

if __name__ == "__main__":
    main()