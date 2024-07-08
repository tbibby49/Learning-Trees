class BranchesController < ApplicationController
  before_action :set_tree
  before_action :set_branch, only: %i[ show edit update destroy ]

  # GET /branches or /branches.json
  def index
    @branches = Branch.all
  end

  # GET /branches/1 or /branches/1.json
  def show
    @branch
    @branch = Branch.find(params[:id])
    @blossom = @branch.blossoms
  end

  # GET /branches/new
  def new
    @branch = Branch.new
  end

  # GET /branches/1/edit
  def edit
    @branch
  end

  # POST /branches or /branches.json
  def create
    @branch = Branch.new(branch_params)

    respond_to do |format|
      if @branch.save
        format.html { redirect_to tree_path(@tree), notice: "Branch was successfully created." }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /branches/1 or /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to tree_branch_url(@tree, @branch), notice: "Branch was successfully updated." }
        format.json { render :show, status: :ok, location: @branch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1 or /branches/1.json
  def destroy
    @branch.destroy!

    respond_to do |format|
      format.html { redirect_to tree_path(@tree), notice: "Branch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = @tree.branches.find(params[:id])
    end

    def set_tree
      @tree = Tree.find(params[:tree_id])
    end

    # Only allow a list of trusted parameters through.
    def branch_params
      params.require(:branch).permit(:name, :description, :point_total, :tree_id)

    end
end
