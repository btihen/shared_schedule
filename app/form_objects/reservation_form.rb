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

  attribute :date,          :date
  attribute :host,          :squished_string #, default: ""
  attribute :event_id,      :integer
  attribute :space_id,      :integer
  attribute :time_slot_id,  :integer
  # attribute :title,         :squished_string
  # attribute :description,   :trimmed_text

  validates :date,          presence: true
  # validates :event,         presence: true
  # validates :space,         presence: true
  # validates :time_slot,     presence: true
  # validates :event_id,      presence: true
  # validates :space_id,      presence: true
  # validates :time_slot_id,  presence: true

  validate :validate_event
  validate :validate_space
  validate :validate_time_slot
  validate :validate_time_slot_available

  # is user needed / helpful?
  def self.new_from(reservation=nil, user: GuestUser.new)
    attribs = {}
    if reservation.present?
      attribs_init = {id: reservation.id,
                      date: reservation.date,
                      host: reservation.host,
                      event: reservation.event,
                      space: reservation.space,
                      time_slot: reservation.time_slot}
      attribs = attribs.merge(attribs_init)
    end
    new(attribs)
  end

  def reservation
    @reservation         ||= assign_reservation_attribs
  end

  def time_slot
    @time_slot  ||= (TimeSlot.find_by(id: time_slot_id) || TimeSlot.new)
  end

  def event
    @event      ||= (Event.find_by(id: event_id) || Event.new)
  end

  def space
    @space      ||= (Space.find_by(id: space_id) || Space.new)
  end

  private

  # consider moving to InitiativeServices::SaveInitiative
  def assign_reservation_attribs
    # tenant_id  = user.tenant_id
    reservaion = Reservation.find_by(id: id) || Reservation.new
    reservaion.time_slot  = time_slot
    reservaion.event      = event
    reservaion.space      = space
    reservaion.date       = date
    reservaion.host       = host
    reservaion
  end

  def validate_time_slot_available
    # check if space allows double booking
    # if not ensure timeslot has no overlaps on date
  end

  def validate_event
    return if event.valid?

    # key = :event_id
    # add_error_message(event, key)
    # event.errors.messages[:event_id].each do |message|
    #   errors.add(key, message)
    # end

    event.errors.each do |name, desc|
      # rename to match form name
      name = :event_id  if name.eql? :event
      errors.add(name, desc)
    end
  end

  def validate_space
    return if space.valid?

    # key = :space_id
    # add_error_message(space, key)
    event.errors.each do |name, desc|
      # rename to match form name
      name = :space_id  if name.eql? :space
      errors.add(name, desc)
    end
  end

  def validate_time_slot
    return if time_slot.valid?

    # key = :time_slot_id
    # add_error_message(time_slot, key)
    time_slot.errors.each do |name, desc|
      # rename to match form name
      name = :time_slot_id  if name.eql? :time_slot
      errors.add(name, desc)
    end
  end

  def add_error_message(object, key)
    return if object.errors.messages[:event_id].blank?

    object.errors.messages[key].each do |message|
      errors.add(key, message)
    end
  end

end
