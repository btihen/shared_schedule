class CalendarView

  delegate :url_helpers, to: 'Rails.application.routes'

  # # 1 == Monday & 7 == Sunday
  # def self.day_of_week(date: Date.today)
  #   date.cwday
  # end

  private
  attr_reader :month_begin_date, :month_end_date, :user,
              :date_of_interest, :month_number, :today

  public
  attr_reader :year_number, :month_number

  def initialize(tenant, user = GuestUser.new, date = Date.today)
    @user               = user
    @today              = Date.today
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

  def display_date(date)
    return ""  if date.blank?

    date.strftime("%Y-%m-%d")
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

  def choose_reservations_modal_html(space, date, reservations = [])
    dates_reservations = reservations.select{ |r| r.date_range.include?(date) }

    items = dates_reservations.each_with_index.map do |dr, index|
      background_color_class = if dr.is_cancelled? || dr.change_notice.present?
                                  'has-background-warning'
                                elsif index.even?
                                  'has-background-light'
                                else
                                  'has-background-grey-lighter'
                                end
      %Q{<div class="#{background_color_class}">
          <dl class="is-medium reservation">
            <dt>
              #{"<big><b>CANCELLED</b></big><br>" if dr.is_cancelled? }
              #{"<strike>" if dr.is_cancelled?}#{dr.start_time_slot}#{"</strike>" if dr.is_cancelled?}
            </dt>
            <dd>
              #{"<strike>" if dr.is_cancelled?}Event: <big><b>#{dr.event_name}</b></big><br>
              Host: #{dr.host_name.blank? ? "No one" : dr.host_name}#{"</strike>" if dr.is_cancelled?}
              #{change_notice(dr)}
              #{edit_button_html(dr)}
            </dd>
          </dl>
        </div>}
    end

    %Q{ <section class="modal-card-body">
          <div class="content is-medium has-text-centered">
            Space: <b>#{space.space_name}</b><br>
            Date: <b>#{display_date(date)}</b>
          </div>
          <hr>
          <div class="content is-medium has-text-left">
            #{items.join}
          </div>
        </section>
        <footer class="modal-card-foot">
          #{new_button_html(space, date)}
        </footer>
      }
  end

  def new_button_html(space, date)
    return ""  if user_cannot_reserve?(space, date)

    %Q{ <a class="button is-success"
            href="#{url_helpers.new_tenant_space_reservation_path(tenant_id: space.tenant.id,
                                                                  space_id: space.id,
                                                                  date: display_date(date))}">
          Add Reservation
        </a>
      }
  end

  def user_cannot_reserve?(space, date)
    !user_can_reserve?(space, date)
  end

  def user_can_reserve?(space, date)
    space.tenant.is_demo? || (user.tenant.id == space.tenant.id)
  end

  def change_notice(reservation_date)
    return "" if reservation_date.change_notice.blank?

    %Q{ <br>
        <b>CHANGE NOTICE:<br>#{reservation_date.change_notice}</b>
      }
  end

  def edit_button_html(reservation_date)
    return ""  if user_cannot_edit?(reservation_date)

    %Q{ <a class="button is-primary is-pulled-right"
            href="#{reservation_date.edit_reservation_path}">
          Edit
        </a>
      }
  end

  def user_cannot_edit?(reservation_date)
    !user_can_edit?(reservation_date)
  end

  def user_can_edit?(reservation_date)
    reservation_date.tenant.is_demo? ||
      (user.tenant.id == reservation_date.tenant.id)
  end

  def choose_modal_form(date, reservations = [])
    # show/edit reservations in modal when there are existing reservations
    return "reservation-details" if date_has_reservation?(date, reservations)
    # return "reservation-details" if reservations.any?{ |r| (r.start_date == date) || (r.end_date == date) }

    "reservation-new"   # form to create a new reservation on other days
  end

  def date_item_class_string(date, reservations = [])
    strings = ["modal-button"]
    strings << "is-today"   if date == today
    strings << "is-active"  if date_has_reservation?(date, reservations)
    strings.join(" ")
  end

  def date_item_tooltip_data(date, reservations = [])
    max_tip_length = 15
    return ""               if date_without_reservation?(date, reservations)
    strings = []
    strings << reservations.select{ |r| r.date_range.include?(date) }
                            .map{ |r| r.event_name.truncate(max_tip_length) }
    strings.join("\n")      # css hover::after needs 'white-space: pre-wrap;'
  end

  def date_class_string(date, reservations = [])
    return "calendar-date is-disabled"  if date_outside_month?(date)

    reservations_on_date = reservations.select{ |r| r.date_range.include?(date) }

    strings = ["calendar-date"]
    strings << "calendar-range" if reservations_on_date.any?{ |r| r.is_multi_day_event? }
    strings << "range-start"    if reservations_on_date.any?{ |r| r.is_range_start?(date) }
    strings << "range-end"      if reservations_on_date.any?{ |r| r.is_range_end?(date) }
    strings.join(" ")
  end

  def date_outside_month?(date)
    date.month != month_number
  end

  def date_in_month_of_interest?(date)
    date.month == month_number
  end

  def date_without_reservation?(date, reservations = [])
    !date_has_reservation?(date, reservations)
  end

  def date_has_reservation?(date, reservations = [])
    return false if reservations.blank?
    reservations.any?{ |r| r.date_range.include?(date) }
  end

  private

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
