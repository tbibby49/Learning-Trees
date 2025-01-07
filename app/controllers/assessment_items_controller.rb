class AssessmentItemsController < ApplicationController
  before_action :set_tree
  before_action :set_assessment_item, only: [:show, :destroy]

  def new
    @assessment_item = AssessmentItem.new
    @assessment_items = @tree.assessment_items
  end

  def show
    @assessment_item = @tree.assessment_items.find(params[:id])
  end

  def create
    @assessment_item = AssessmentItem.new(assessment_item_params)
    @assessment_item.tree = @tree

    Rails.logger.debug "Params: #{assessment_item_params.inspect}"
    Rails.logger.debug "Tree ID: #{@tree.id}"

    if @assessment_item.save
      redirect_to tree_assessment_items_path(@tree), notice: 'Assessment item was successfully created.'
    else
      Rails.logger.error "Errors: #{@assessment_item.errors.full_messages}"
      @assessment_items = @tree.assessment_items
      render :new
    end
  end

  def destroy
    @assessment_item = @tree.assessment_items.find(params[:id])
    # Check for associated BlossomAssessment records
    associated_assessments = BlossomAssessment.where(assessment_item_id: @assessment_item.id)
    if associated_assessments.exists?
      flash[:alert] = "Cannot delete assessment item because associated assessments exist."
      redirect_to assessments_tree_path(@tree) # Redirect to the same page (index for the tree's assessment items)
    else
      @assessment_item.destroy
      flash[:notice] = "Assessment item deleted successfully."
      redirect_to tree_assessment_items_path(@tree) # Redirect to the same page after deletion
    end
  end

  def update_order
    order_data = params[:order] # This will be the array of IDs and order values
    order_data.each do |item|
      assessment_item = AssessmentItem.find(item[:id])
      assessment_item.update(order: item[:order]) # Update each assessment item's order
    end
    render json: { status: 'success' }
  end

  def upload_document
    @assessment_item = @tree.assessment_items.find(params[:id])

    if @assessment_item.update(document: params[:assessment_item][:document])
      flash[:notice] = "Document uploaded successfully."
    else
      flash[:alert] = "Failed to upload document."
    end
    redirect_to tree_assessment_items_path(@tree)
  end

  def delete_document
    @assessment_item = @tree.assessment_items.find(params[:id])

    if @assessment_item.document.attached?
      @assessment_item.document.purge # Remove the attached document
      flash[:notice] = "Document deleted successfully."
    else
      flash[:alert] = "No document to delete."
    end
    redirect_to tree_assessment_items_path(@tree) # Redirect back to the same page
  end

  private

  def set_tree
    @tree = Tree.find(params[:tree_id])
  end

  def set_assessment_item
    @assessment_item = @tree.assessment_items.find(params[:id])
  end

  def assessment_item_params
    params.require(:assessment_item).permit(:name, :document, :tree_id, :order)
  end
end
