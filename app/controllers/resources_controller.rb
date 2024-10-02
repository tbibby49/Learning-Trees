class ResourcesController < ApplicationController
  before_action :set_tree
  before_action :set_branch
  before_action :set_blossom
  before_action :set_resource, only: [:show, :edit, :update, :destroy]  # Ensure :edit, :update, and :destroy are included

  def new
    @resource = @blossom.resources.build
  end

  def show
    # @resource is set by the before_action
  end

  def edit
    # @resource is set by the before_action
  end

  def create
    Rails.logger.debug "Resource params: #{resource_params.inspect}"
    @resource = @blossom.resources.build(resource_params)  # Use `build` to associate with blossom

    if @resource.save
      Rails.logger.info "Resource created successfully: #{@resource.inspect}"
      flash[:notice] = 'Resource was successfully added.'
      redirect_to edit_tree_branch_blossom_path(@blossom.branch, @branch.tree, @blossom)  # Redirect after successful creation
    else
      Rails.logger.error "Resource creation failed. Errors: #{@resource.errors.full_messages}"
      flash[:alert] = 'Failed to create resource. Please check the form for errors.'
      flash[:errors] = @resource.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    @resource = Resource.find(params[:id])
    puts "Resource params: #{resource_params.inspect}"

    if @resource.update(resource_params)
      puts "Resource updated: #{@resource.inspect}"
      puts "Document attached? #{@resource.document.attached?}"
      redirect_to edit_tree_branch_blossom_path(@blossom.branch, @branch.tree, @blossom), notice: 'Resource was successfully updated.'
    else
      Rails.logger.error "Resource update failed. Errors: #{@resource.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    @resource.destroy  # Destroy the resource
    redirect_to edit_tree_branch_blossom_path(@blossom.branch, @branch.tree, @blossom), notice: 'Resource was successfully deleted.'
  end

  private

  def set_tree
    @tree = Tree.find(params[:tree_id])
  end

  def set_branch
    @branch = @tree.branches.find(params[:branch_id])
  end

  def set_blossom
    @blossom = @branch.blossoms.find(params[:blossom_id])
  end

  def set_resource
    @resource = @blossom.resources.find(params[:id])  # Fetch the resource for editing or deletion
  end

  def resource_params
    params.require(:resource).permit(:name, :description, :document)
  end
end
