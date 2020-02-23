class SpacesController < ApplicationController
    before_action :set_tenant, only: [:show, :edit, :update, :destroy]

  # GET /tenants
  # GET /tenants.json
  def index
    @space = Space.all
  end

  # GET /tenants/new
  def new
    @space = Space.new
  end

  # POST /tenants
  # POST /tenants.json
  def create
    @space = Space.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        format.html { redirect_to @space, notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @space }
      else
        format.html { render :new }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tenants/1
  # GET /tenants/1.json
  def show
    space_view = SpaceView(find_space)
    format.html { render 'space/show',
                  locals: {space_view: space_view}
                }
  end



  # def index
  #   index_by_relation(params[:list], current_user); return if performed?

  #   terms       = ActionController::Base.helpers.sanitize(search_params[:terms])
  #   found       = InitiativeQueries.search_active(terms)
  #   initiatives = InitiativeView.collection(found, view_context)

  #   respond_to do |format|
  #     format.html { render 'initiatives/index',
  #                   locals: {initiatives: initiatives} }
  #   end
  # end

  # def new
  #   # restore nested initiative - contacts are nested inside initiatives
  #   initiative  = Initiative.find(params[:initiative_id])

  #   # pre-populate the contact with known information
  #   attributes  = { attendee_id: current_user.id,
  #                   school_id: current_user.school&.id,
  #                   attendee_title: current_user.user_title,
  #                   initiative_id: initiative.id,
  #                   contact_message: ContactForm.default_message(initiative.id) }
  #   contact_form = ContactForm.new(attributes)
  #   initiative = InitiativeView.new(initiative, view_context)

  #   respond_to do |format|
  #     format.html { render 'contacts/new',
  #                   locals: {contact_form: contact_form, initiative: initiative} }
  #   end
  # end

  # def create
  #   contact_form = ContactForm.new(contact_params)
  #   contact_cmd  = ContactSaveCommand.new(contact_form)

  #   if contact_form.valid? && contact_cmd.run
  #     flash[:notice] = 'Your message was successfully sent.'

  #     redirect_to controller: 'initiatives', action: 'index'
  #   else
  #     initiative  = Initiative.find(contact_params[:initiative_id])
  #     initiative  = InitiativeView.new(initiative, view_context)

  #     respond_to do |format|
  #       flash[:alert] = 'Please fix the errors'
  #       format.html { render 'contacts/new',
  #                     locals: {contact_form: contact_form, initiative: initiative} }
  #     end
  #   end
  # end

  # def show
  #   initiative  = Initiative.find(params[:id])
  #   # check not blocked - redirect to start list
  #   disabled_response(initiative);     return if performed?

  #   if current_user.eql?(initiative.sponsor)
  #     # if person getting the details is sponsor send them to edit
  #     redirect_to edit_initiative_path(initiative)

  #   else
  #     # if person getting the details is not the sponsor then send them to the contact page
  #     redirect_to new_initiative_contact_path(initiative)
  #   end
  # end


  # GET /tenants/1/edit
  def edit
  end

  # PATCH/PUT /tenants/1
  # PATCH/PUT /tenants/1.json
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @space, notice: 'Space was successfully updated.' }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenants/1
  # DELETE /tenants/1.json
  def destroy
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to spaces_url, notice: 'Space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_space
      Space.find(params[:id])
    end
    def set_space
      @tenant = Space.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def space_params
      params.require(:space).permit(:space_name, :space_location, :time_zone, :tenant)
    end
end
