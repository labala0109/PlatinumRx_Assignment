"""
01_Time_Converter.py
Convert minutes into human readable format.
"""

def convert_minutes(minutes):
    hours = minutes // 60
    remaining_minutes = minutes % 60

    if hours == 0:
        return f"{remaining_minutes} minutes"
    elif hours == 1:
        return f"1 hr {remaining_minutes} minutes"
    else:
        return f"{hours} hrs {remaining_minutes} minutes"


if __name__ == "__main__":
    print("Example Outputs:")
    print(convert_minutes(130))
    print(convert_minutes(110))
    print(convert_minutes(45))