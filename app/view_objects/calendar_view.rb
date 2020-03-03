class CalendarView

  # # 1 == Monday & 7 == Sunday
  # def self.day_of_week(date: Date.today)
  #   date.cwday
  # end
  attr_reader :year_number

  def initialize(date: Date.today)
    @date_of_interest   = date
    @year_number        = date.year
    @month_number       = date.month
    @month_begin_date   = date.at_beginning_of_month
    @month_end_date     = date.at_beginning_of_month.next_month - 1.day

    raise StandardError  unless date_first_monday.monday?
    raise StandardError  unless date_last_sunday.sunday?
  end

  def prev_month
    Date.new(year_number, month_number, 15) - 1.month
  end

  def next_month
    Date.new(year_number, month_number, 15) + 1.month
  end

  def prev_month_string
    prev_month.strftime("%Y-%m-%d")
  end

  def next_month_string
    next_month.strftime("%Y-%m-%d")
  end

  def date_range
    (date_first_monday..date_last_sunday)
  end

  def full_month_name
    I18n.t("date.month_names")[month_number]
  end

  def abbr_month_name
    I18n.t("date.abbr_month_names")[month_number]
  end

  def choose_modal_form(date, reservations: [])
    return "edit-reservation-form" if reservations.any?{ |r| r.date == date }
    
    "new-reservation-form"
  end

  def date_item_class_string(date, reservations: [])
    strings = ["modal-button"]
    strings << "is-today"   if date == Date.today
    strings << "is-active"  if reservations.any?{ |r| r.date == date }
    strings.join(" ")
  end

  def date_item_tooltip_data(date, reservations: [])
    max_tip_length = 20
    return ""               if reservations.none?{ |r| r.date == date }
    strings = []
    strings << reservations.select{ |r| r.date == date }
                            .map{ |r| r.event_name.truncate(max_tip_length) }
    strings.join("\n")      # css hover::after needs 'white-space: pre-wrap;'
  end

  def date_class_string(date)
    strings = ["calendar-date"]
    strings << "is-disabled"    if date_outside_month?(date)
    # strings << "range-start"
    # strings << "range-end"
    strings.join(" ")
  end

  def date_outside_month?(date)
    date.month != month_number
  end

  def date_in_month_of_interest?(date)
    date.month == month_number
  end

  private
  attr_reader :month_begin_date, :month_end_date,
              :date_of_interest, :month_number

  def date_first_monday
    # days needed to go start on a monday
    month_start_offset = month_begin_date.cwday - 1

    (month_begin_date - month_start_offset.days)
  end

  def date_last_sunday
    # days needed to go until last sunday
    month_end_offset = 7 - month_end_date.cwday

    (month_end_date + month_end_offset.days)
  end
end