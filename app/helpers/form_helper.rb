# frozen_string_literal: true

# stuff available to all forms
module FormHelper

  def error_message_on(object, method)
    return unless object.respond_to?(:errors) && object.errors.include?(method)

    errors = field_errors(object, method).join(', ')
    content_tag(:div, errors, class: 'field_with_errors')
  end

  # makes a list of schools and ids for view forms
  def events_n_ids(tenant)
    Event.where(tenant_id: tenant.id)
          .sort_by(&:event_name)
          .collect { |e| [e.event_name, e.id] }
  end

  # makes a list of schools and ids for view forms
  def spaces_n_ids(tenant)
    Space.where(tenant_id: tenant.id)
          .sort_by(&:space_name)
          .collect { |s| [s.space_name, s.id] }
  end

  def react_school_names_n_ids
    # School.active.sort_by(&:school_name)
    #       .collect { |u| [u.school_name, u.id] }
    schools = SchoolQueries.active.sort_by(&:school_name)
    schools = SchoolView.collection(schools)
    @schools = schools.map{|school| {id: school.id, name: school.school_name}}
  end

  # assignable users for manager to assign to initiatives
  def user_names_n_ids
    # User.all.sort_by(&:last_name)
    #     .collect { |u| ["#{u.last_name}, #{u.first_name}", u.id] }
    # ASSIGNABLE users not blocked_by admin or when user_actively_disagrees with terms
    users = UserQueries.assignable.sort_by(&:last_name)
    user_views = UserView.collection(users)
    user_views.map{|user_vm| {id: user_vm.id, full_name: user_vm.full_name, title: user_vm.user_title, school_id: user_vm.school_id}}
    # users.map{|user| {id: user.id, full_name: user.full_name, title: user.title, school_id: user.school.id}}
  end

  def select_event(initiative = nil)
    initiative ||= Initiative.new
    # initiative_sm = InitiativeStateMachine.new(initiative)
    initiative_sm = initiative
    initiative_sm.aasm.events(permitted: true).map(&:name)
  end

  # def country_names_n_codes
  #   ISO3166::Country.all.sort_by(&:name).collect {|u| [u.name, u.alpha2]}
  # end

  # def age_names_n_ids
  #   AgeGroup.active.sort_by(&:age_group_name).collect {|u| [u.age_group_name, u.id]}
  # end

  # def date_names_n_ids
  #   OfferedDate.active.sort_by(&:date_name).collect {|u| [u.date_name, u.id]}
  # end

  # def discipline_names_n_ids
  #   DisciplineArea.active.sort_by(&:discipline_name).collect {|u| [u.discipline_name, u.id]}
  # end

  private

  def field_errors(object, method)
    object.errors[method].map { |error| "#{method.to_s.humanize} #{error}" }
  end
end
