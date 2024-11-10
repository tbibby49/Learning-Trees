class TreesController < ApplicationController
  before_action :set_tree, only: %i[ show edit update destroy ]
  before_action :authenticate_teacher!

  # GET /trees or /trees.json
  def branch_builder
    @tree
    @tree = Tree.find(params[:id])
    @branch = @tree.branches.build

  end

  def index
    @trees = Tree.all
    @trees = Tree.accessible_by(current_teacher)
  end

  # GET /trees/1 or /trees/1.json
  def show
    @tree
    @tree = Tree.find(params[:id])
    @branch = @tree.branches.build
    @branches = @tree.branches.includes(:blossoms)

    @assessment_items = @tree.assessment_items
    @assessment_item = AssessmentItem.new

  end

  # GET /trees/new
  def new
    @tree = Tree.new
  end

  # GET /trees/1/edit
  def edit
  end

  # POST /trees or /trees.json
  def create
    @tree = Tree.new(tree_params)

    respond_to do |format|
      if @tree.save
        format.html { redirect_to tree_url(@tree), notice: "Tree was successfully created." }
        format.json { render :show, status: :created, location: @tree }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1 or /trees/1.json
  def update
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to tree_url(@tree), notice: "Tree was successfully updated." }
        format.json { render :show, status: :ok, location: @tree }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1 or /trees/1.json
  def destroy
    @tree.destroy!

    respond_to do |format|
      format.html { redirect_to trees_url, notice: "Tree was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_cutoffs
    @tree = Tree.find(params[:id])

    # Extract the cutoffs from the form
    cutoff_a = params[:cutoff_a].to_i
    cutoff_b = params[:cutoff_b].to_i
    cutoff_c = params[:cutoff_c].to_i
    cutoff_d = params[:cutoff_d].to_i

    # Save these cutoffs (you'll likely want to store them somewhere like a model)
    @tree.update(cutoff_a: cutoff_a, cutoff_b: cutoff_b, cutoff_c: cutoff_c, cutoff_d: cutoff_d)

    # Redirect or render as needed
    redirect_to @tree, notice: "Grade cutoffs have been updated."
  end

  def share
    @tree = Tree.find(params[:id])
    @teacher = Teacher.find(params[:teacher_id])
    TreeShare.create(tree: @tree, teacher: @teacher)
    redirect_to trees_path, notice: "Tree shared with #{@teacher.email}."
  end

  def unshare
    @tree = Tree.find(params[:id])
    TreeShare.find_by(tree: @tree, teacher_id: params[:teacher_id])&.destroy
    redirect_to trees_path, notice: "Tree unshared successfully."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree
      @tree = Tree.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tree_params
      params.require(:tree).permit(:name, :description, :point_total)
    end


end
