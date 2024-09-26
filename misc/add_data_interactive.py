from sqlalchemy import create_engine, Table, MetaData, insert
from sqlalchemy.orm import sessionmaker

def get_input(prompt):
    return input(prompt)

def main():
    # Database connection details
    DATABASE_URL = 'mariadb://root:Deepak%4022@localhost:3306/deepak_db'

    # Create database engine
    engine = create_engine(DATABASE_URL, echo=True)
    metadata = MetaData()
    metadata.reflect(bind=engine)

    # Define the tables
    exercises_table = Table('exercises', metadata, autoload_with=engine)
    sets_table = Table('sets', metadata, autoload_with=engine)

    # Create a session
    Session = sessionmaker(bind=engine)
    session = Session()

    # Get user input
    session_id = int(get_input("Enter session ID: "))
    exercise_name = get_input("Enter exercise name: ")
    exercise_type = get_input("Enter exercise type: ")

    # Insert exercise data
    with engine.connect() as conn:
        # Insert exercise into the exercises table
        insert_stmt = insert(exercises_table).values(
            session_id=session_id,
            name=exercise_name,
            type=exercise_type
        )
        result = conn.execute(insert_stmt)
        exercise_id = result.inserted_primary_key[0]

        # Get set data
        while True:
            reps = get_input("Enter repetitions (comma-separated, leave empty if none): ")
            if reps:
                reps = list(map(int, reps.split(',')))
            else:
                reps = []

            weights = get_input("Enter weights (comma-separated, leave empty if none): ")
            if weights:
                # Filter out empty strings and convert to floats
                weights = [float(weight) for weight in weights.split(',') if weight]
            else:
                weights = []

            # Insert sets data into the sets table
            if reps and weights:
                if len(reps) == len(weights):
                    for rep, weight in zip(reps, weights):
                        insert_stmt = insert(sets_table).values(
                            exercise_id=exercise_id,
                            reps=rep,
                            weight=weight
                        )
                        conn.execute(insert_stmt)
                    break
                else:
                    print("Error: Number of repetitions must match number of weights.")
            elif reps:
                for rep in reps:
                    insert_stmt = insert(sets_table).values(
                        exercise_id=exercise_id,
                        reps=rep,
                        weight=None
                    )
                    conn.execute(insert_stmt)
                break
            elif weights:
                print("Error: Weights provided without repetitions. Reps must be provided if weights are included.")
            else:
                print("No repetitions or weights provided. Please provide at least one.")

    print("Data added successfully.")

if __name__ == "__main__":
    main()
