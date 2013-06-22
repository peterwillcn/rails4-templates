class <%= class_name.pluralize %>Controller < ApplicationController
  before_filter :set_<%= plural_name.singularize %>, only: [:show, :edit, :update, :destroy]
  
  def index
    @<%= plural_name %> = <%= class_name %>.page
  end

  def show
  end

  def new
    @<%= plural_name.singularize %> = <%= class_name %>.new
  end

  def edit
  end

  def create
    @<%= plural_name.singularize %> = <%= class_name %>.new(<%= plural_name.singularize %>_params)

    if @<%= plural_name.singularize %>.save
      redirect_to @<%= plural_name.singularize %>, notice: t('helpers.prompt.created', name: <%= class_name %>.model_name.human)
    else
      render action: 'new'
    end
  end

  def update
    if @<%= plural_name.singularize %>.update_attributes(<%= plural_name.singularize %>_params)
      redirect_to @<%= plural_name.singularize %>, notice: t('helpers.prompt.updated', name: <%= class_name %>.model_name.human)
    else
      render action: 'edit'
    end
  end

  def destroy
    @<%= plural_name.singularize %>.destroy

    redirect_to action: 'index'
  end
  
  
  private
  
  def set_<%= plural_name.singularize %>
    @<%= plural_name.singularize %> = <%= class_name %>.find(params[:id])
  end
  
  def <%= plural_name.singularize %>_params
    params.require(:<%= plural_name.singularize %>).permit(<%= attributes.map { |attribute| attribute.name.to_sym }.join(', ')  %>)
  end
end
