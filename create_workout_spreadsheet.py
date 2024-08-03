import pandas as pd

# Define the data
data = {
    "Date": ["25/07/2024"] * 8,
    "Exercise": [
        "Pushup",
        "Shoulder bar",
        "Shoulder dumbbell raises",
        "Rotating Shoulder dumbbell raises",
        "Butterfly shoulder",
        "Rope to face (for shoulder)",
        "Collar"
    ],
    "Reps/Weights": [
        "12, 9, 7",
        "12(no weight), 10(5kg), 8(5kg), 6(5kg)",
        "12(7.5), 6(10), 3(10)",
        "8(7.5), 7(7.5), 6(7.5)",
        "8(16), 6(16), 4(16)",
        "12(16), 10(16), 8(20)",
        "12(only bar), 8(2.5), 6(2.5)"
    ]
}

# Create a DataFrame
df = pd.DataFrame(data)

# Save to Excel
df.to_excel("workout.xlsx", index=False)

print("Spreadsheet created successfully!")
