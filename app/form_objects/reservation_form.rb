class ReservationForm < FormObject

  # alias_method :reservation, :root_model

  # when the model will never already stored then use the following instead:
  # def persisted?
  #   return true  if id.present?
  #   return false
  # end
  delegate :id, :persisted?, :host, :event, :space, :tenant,
            :start_date, :end_date, :start_time_slot, :end_time_slot,
            to: :reservation,  allow_nil: true

  # All the models that are apart of our form should be part attr_accessor.
  # This allows the form to be initialized with existing instances.
  attr_accessor :id, :host, :event, :reason, :space, #:tenant,
                :start_date, :end_date, :start_time_slot, :end_time_slot

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Reservation')
  end

  # is user needed / helpful?
  def self.new_from(reservation)
    attribs = {}
    if reservation.present?
      attribs_init = {id: reservation.id,
                      host: reservation.host,
                      event: reservation.event,
                      space: reservation.space,
                      end_date: reservation.end_date,
                      start_date: reservation.start_date,
                      end_time_slot: reservation.end_time_slot,
                      start_time_slot: reservation.start_time_slot}
      attribs = attribs.merge(attribs_init)
    end
    new(attribs)
  end

  # def initialize(attrs={})
  #   super
  # end

  # list attributes - which accept any form (Arrays)
  # attr_accessor :event_id, :space_id, :time_slot_id

  attribute :end_date,            :date
  attribute :start_date,          :date
  attribute :end_time_slot_id,    :integer
  attribute :start_time_slot_id,  :integer
  attribute :event_id,            :integer
  attribute :space_id,            :integer
  attribute :reason_id,           :integer
  # attribute :tenant_id,           :integer
  attribute :host,                :squished_string
  attribute :event_name,          :squished_string
  attribute :event_description,   :squished_string
  attribute :reason_name,         :squished_string
  attribute :reason_description,  :squished_string
  # attribute :description,         :trimmed_text

  validates :start_date,          presence: true
  # validates :end_date,            presence: true

  validate :validate_space
  validate :validate_event
  validate :validate_reason
  validate :validate_time_slots
  validate :validate_dates_and_times_available

  def reservation
    @reservation     ||= assign_reservation_attribs
  end

  def reason
    @reason          ||= assign_reason_attribs
  end

  def event
    @event           ||= assign_event_attribs
  end

  def tenant
    @tenant          ||= space.tenant
  end

  def space
    @space           ||= (Space.find_by(id: space_id) || Space.new)
  end

  def start_time_slot
    @start_time_slot ||= (TimeSlot.find_by(id: start_time_slot_id) || TimeSlot.new)
  end

  def end_time_slot
    @end_time_slot   ||= (TimeSlot.find_by(id: end_time_slot_id) || start_time_slot)
  end

  private

  def assign_reservation_attribs
    # get / create instance
    reservation = Reservation.find_by(id: id) || Reservation.new

    # update reservation attributes
    reservation.start_time_slot  = start_time_slot
    reservation.end_time_slot    = end_time_slot
    reservation.event            = event
    reservation.space            = space
    reservation.tenant           = space.tenant
    reservation.start_date       = start_date
    reservation.end_date         = (end_date.blank? ? start_date : end_date)
    reservation.start_date_time  = start_date_time  # calculated start-time for sorting
    reservation.host             = host
    reservation
  end

  def assign_reason_attribs
    # use incomming reason_id if available (should be there unless new)
    return Reason.find(reason_id) if reason_id.present?
    return event.reason           if event_id.present?

    # create new reason
    new_reason = Reason.new
    new_reason.reason_name        = reason_name
    new_reason.reason_description = reason_description
    new_reason.tenant             = tenant
    new_reason
  end

  def assign_event_attribs
    # use incomming event_id if available
    return Event.find(event_id)             if event_id.present?

    # create a new event if no other info available
    new_event = Event.new
    new_event.event_name        = event_name
    new_event.event_description = event_description
    new_event.reason            = reason
    new_event.tenant            = tenant
    new_event
  end

  def start_date_time
    return nil unless start_date.present? && start_time_slot.valid?

    start_date_obj = start_date.is_a?(String) ? Date.parse(start_date) : start_date
    DateTime.new(start_date_obj.year, start_date_obj.month, start_date_obj.day, start_time_slot.begin_time.hour, start_time_slot.begin_time.min, 0) #, "ECT")
  end

  def validate_reason
    return if reason.valid?

    reason.errors.each do |attribute_name, desc|
      attribute_sym = attribute_name.to_s.eql?(id) ? :reason_id : attribute_name.to_sym
      errors.add(attribute_sym, desc)
    end
  end

  def validate_event
    return if event.valid?

    event.errors.each do |attribute_name, desc|
      attribute_sym = attribute_name.to_s.eql?(id) ? :event_id : attribute_name.to_sym
      errors.add(attribute_sym, desc)
    end
  end

  def validate_space
    return if space.valid?

    space.errors.each do |_attribute_name, desc|
      errors.add(:space_id, desc)
    end
  end

  def validate_time_slots
    return if start_time_slot.valid? && end_time_slot.valid?

    start_time_slot.errors.each do |_attribute_name, desc|
      errors.add(:start_time_slot_id, desc)
    end
    end_time_slot.errors.each do |_attribute_name, desc|
      errors.add(:end_time_slot_id, desc)
    end
  end

  def validate_dates_and_times_available
    # check if space allows double booking
    # if not ensure timeslot has no overlaps on dates & times
  end

  # def reservation_end_date
  #   # reservation.date
  #   # I18n.l(reservation.date)
  #   reservation.end_date.in_time_zone(space.time_zone)
  #   # Time.at(1364046539).in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y %I:%M %p")
  # end

  # def reservation_start_date
  #   # reservation.date
  #   # I18n.l(reservation.date)
  #   reservation.start_date.in_time_zone(space.time_zone)
  #   # Time.at(1364046539).in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y %I:%M %p")
  # end


  # def date_time_range
  #   if is_event_one_time_slot?
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           start_date, start_time_slot.end_time)
  #   elsif is_event_one_day?
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           start_date, end_time_slot.end_time)
  #   else
  #     build_date_time_range(start_date, start_time_slot.begin_time,
  #                           end_date,   end_time_slot.end_time)
  #   end
  # end

  # def build_date_time_range(start_date, start_time, end_date, end_time)
  #   (build_date_time(start_date, start_time)..build_date_time(end_date, end_time))
  # end

  # def build_date_time(date, time)
  #   DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  # end


  # def resevation_start_end_range
  #   if is_event_one_time_slot?
  #     build_date_time_range(reservation_start_date, start_time_slot.start_time,
  #                           reservation_start_date, start_time_slot.finish_time)
  #   elsif is_event_one_day?
  #     build_date_time_range(reservation_start_date, start_time_slot.start_time,
  #                           reservation_start_date, end_time_slot.finish_time)
  #   else
  #     build_date_time_range(reservation_start_date, start_time_slot.start_time,
  #                           reservation_end_date, end_time_slot.finish_time)
  #   end
  # end

  # def build_date_time_range(start_date, start_time, end_date, end_time)
  #   (build_date_time(start_date, start_time)..build_date_time(end_date, end_time))
  # end

  # def build_date_time(date, time)
  #   DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  # end

  # def is_event_one_day?
  #   return true   if start_date == end_date
  #   false
  # end

  # def is_event_one_time_slot?
  #   return true   if is_event_one_day? && (start_time_slot == end_time_slot)
  #   false
  # end

end
