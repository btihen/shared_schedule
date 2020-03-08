class ReservationForm < FormObject

  # alias_method :reservation, :root_model

  delegate :id, :date, :host, :event, :space, :time_slot,
            :persisted?,    to: :reservation,  allow_nil: true

  # All the models that are apart of our form should be part attr_accessor.
  # This allows the form to be initialized with existing instances.
  attr_accessor :id, :date, :host, :event, :space, :time_slot

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Reservation')
  end

  # def initialize(attribs)
  #   super
  #   @root_model ||= Reservation.new
  # end

  # when the model will never already stored then use the following:
  # def persisted?
  #   return true  if id.present?
  #   return false
  # end



  # list attributes - which accept any form (Arrays)
  # attr_accessor :event_id, :space_id, :time_slot_id

  attribute :end_date,            :date
  attribute :start_date,          :date
  attribute :end_time_slot_id,    :integer
  attribute :start_time_slot_id,  :integer
  attribute :event_id,            :integer
  attribute :space_id,            :integer
  attribute :host,                :squished_string
  # attribute :description,         :trimmed_text

  validates :start_date,          presence: true
  # validates :end_date,            presence: true

  validate :validate_event
  validate :validate_space
  validate :validate_time_slots
  validate :validate_dates_and_times_available

  # is user needed / helpful?
  def self.new_from(reservation=nil, user: GuestUser.new)
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

  def reservation
    @reservation  ||= assign_reservation_attribs
  end

  def start_time_slot
    @start_time_slot  ||= (TimeSlot.find_by(id: start_time_slot_id) || TimeSlot.new)
  end

  def end_time_slot
    @end_time_slot    ||= (TimeSlot.find_by(id: end_time_slot_id) || start_time_slot)
  end

  def event
    @event            ||= (Event.find_by(id: event_id) || Event.new)
  end

  def space
    @space            ||= (Space.find_by(id: space_id) || Space.new)
  end

  private

  # consider moving to InitiativeServices::SaveInitiative
  def assign_reservation_attribs
    # tenant_id  = user.tenant_id
    reservaion = Reservation.find_by(id: id) || Reservation.new
    reservaion.start_time_slot  = start_time_slot
    reservaion.end_time_slot    = end_time_slot
    reservaion.event            = event
    reservaion.space            = space
    reservaion.start_date       = start_date
    reservaion.end_date         = end_date || start_date
    reservaion.host             = host
    reservaion
  end

  def validate_event
    return if event.valid?

    event.errors.each do |_attribute_name, desc|
      errors.add(:event_id, desc)
    end
  end

  def validate_space
    return if space.valid?

    event.errors.each do |_attribute_name, desc|
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
