Time::DATE_FORMATS[:day_month_and_year] = "%d-%m-%Y"
Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") }