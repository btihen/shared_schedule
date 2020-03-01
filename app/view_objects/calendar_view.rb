class CalendarView

  # 1 == Monday & 7 == Sunday
  def self.day_of_week(date: Date.today)
    date.cwday
  end
  attr_reader :month_name, :year_number

  def initialize(date: Date.today)
    @date_of_interest   = date
    @year_number        = date.year
    @month_number       = date.month
    @month_name         = date.strftime("%B")
    @month_begin_date   = date.at_beginning_of_month
    @month_end_date     = date.at_beginning_of_month.next_month - 1.day
    @month_start_offset = month_begin_date.cwday - 1 # days needed to go start on a monday
    @month_end_offset   = 7 - month_end_date.cwday   # days needed to go until last sunday
    @days_in_month      = month_end_date.mday

    raise StandardError  unless date_first_monday.cwday == 1  # should be a Monday
    raise StandardError  unless date_last_sunday.cwday  == 7  # should be a Sunday
  end

  def date_in_month_of_interest?(date)
    date.month == month_number
  end

  def date_range
    (date_first_monday..date_last_sunday)
  end

  private
  attr_reader :month_begin_date,   :month_end_date,   :date_of_interest,
              :month_start_offset, :month_end_offset, :days_in_month,
              :month_number

  def date_first_monday
    month_begin_date - month_start_offset.days
  end

  def date_last_sunday
    month_end_date   + month_end_offset.days
  end
end
