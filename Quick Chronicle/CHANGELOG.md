# Changelog
This is a casual changelog🍉. Only for Dongying.Will.Become.Homeless.Cao.

## 2024-07-09
- Data migration (in progress): The original type of `date` was Date, which includes both the date and the time. What I need is simply the date, so keeping the type as Date requires additional effort for formatting. The solution now is to change the type from Date to **String**. There're already some records written into persistent store (database), so data migration is necessary.
