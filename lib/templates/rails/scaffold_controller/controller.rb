class <%= class_name.pluralize %>Controller < ApplicationController
  before_action :set_<%= singular_name %>, only: [:show, :edit, :update, :destroy]
  
  def index
    @<%= plural_name %> = <%= class_name %>.page
  end

  def show
  end

  def new
    @<%= singular_name %> = <%= class_name %>.new
  end

  def edit
  end

  def create
    @<%= singular_name %> = <%= class_name %>.new(<%= singular_name %>_params)

    if @<%= singular_name %>.save
      redirect_to @<%= singular_name %>, notice: t('helpers.prompt.created', name: <%= class_name %>.model_name.human)
    else
      render action: 'new'
    end
  end

  def update
    if @<%= singular_name %>.update(<%= singular_name %>_params)
      redirect_to @<%= singular_name %>, notice: t('helpers.prompt.updated', name: <%= class_name %>.model_name.human)
    else
      render action: 'edit'
    end
  end

  def destroy
    @<%= singular_name %>.destroy

    redirect_to action: 'index'
  end
  
  
  private
  
    def set_<%= singular_name %>
      @<%= singular_name %> = <%= class_name %>.find(params[:id])
    end
    
    def <%= singular_name %>_params
      params.require(:<%= singular_name %>).permit(<%= attributes.map { |attribute| ":#{attribute.name}" }.join(', ')  %>)
    end
end
