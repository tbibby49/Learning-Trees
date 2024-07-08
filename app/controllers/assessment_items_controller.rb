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
      redirect_to tree_path(@tree), notice: 'Assessment item was successfully created.'
    else
      Rails.logger.error "Errors: #{@assessment_item.errors.full_messages}"
      @assessment_items = @tree.assessment_items
      render :new
    end
  end

  def destroy
    @assessment_item.destroy!
    redirect_to tree_path(@tree), notice: 'Assessment item was successfully deleted.'
  end

  private

  def set_tree
    @tree = Tree.find(params[:tree_id])
  end

  def set_assessment_item
    @assessment_item = @tree.assessment_items.find(params[:id])
  end

  def assessment_item_params
    params.require(:assessment_item).permit(:name, :document, :tree_id)
  end
end
