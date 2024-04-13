from datetime import datetime, timedelta
past = datetime.now() - timedelta(days=2)
present = datetime.now()
if past < present:
    print(past)
else:
    print(present)
    
