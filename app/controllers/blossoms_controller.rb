class BlossomsController < ApplicationController
  before_action :set_tree
  before_action :set_branch

  before_action :set_blossom, only: %i[ show edit update destroy ]

  # GET /blossoms or /blossoms.json
  def index
    @blossoms = @branch.blossoms.all
    respond_to do |format|
      format.html
      format.json { render json: @blossoms, include: { branch: { include: :tree } } }
    end

  end

  # GET /blossoms/1 or /blossoms/1.json
  def show
    @tree = Tree.find(params[:tree_id])
    @branch = Branch.find(params[:branch_id])
    @blossom = Blossom.find(params[:id])
    @resources = @blossom.resources
  end

  def spheres
    @blossoms = @branch.blossoms.all
  end

  def update_positions
    positions_params = params.require(:positions).permit!
    positions_params.each do |blossom_id, position|
      blossom = Blossom.find(blossom_id)
      if blossom
        blossom.update(row: position[:row], column: position[:column])
        logger.debug "Updating blossom #{blossom_id} to row #{position[:row]}, column #{position[:column]}"
      else
        logger.debug "Updated position not persisting"
      end
    end
    head :ok
  end

  # GET /blossoms/new
  def new
    @blossom = @branch.blossoms.build

  end

  # GET /blossoms/1/edit
  def edit
    @resources = @blossom.resources
  end

  # POST /blossoms or /blossoms.json
  def create
    @branch = Branch.find(params[:branch_id])
    @blossom = @branch.blossoms.build(blossom_params)

    respond_to do |format|
      if @blossom.save
        format.html { redirect_to tree_branch_path(@branch.tree, @branch), notice: "Blossom was successfully created." }
        format.json { render :show, status: :created, location: @blossom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blossom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blossoms/1 or /blossoms/1.json
  def update
    respond_to do |format|
      if @blossom.update(blossom_params)
        format.html { redirect_to tree_branch_path(@branch.tree, @branch), notice: 'Blossom was successfully updated.' }
        format.json { render :show, status: :ok, location: @blossom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blossom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blossoms/1 or /blossoms/1.json
  def destroy
    @tree = Tree.find(params[:tree_id])
    @branch = @tree.branches.find(params[:branch_id])
    @blossom = @branch.blossoms.find(params[:id])
    @blossom.destroy!

    respond_to do |format|
      format.html { redirect_to tree_branch_path(@branch.tree, @branch), notice: "Blossom was successfully destroyed." }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.

    def set_tree
      @tree = Tree.find(params[:tree_id])
    end

    def set_branch
      @branch = @tree.branches.find(params[:branch_id])
    end

    def set_blossom
      @blossom = Blossom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blossom_params
      params.require(:blossom).permit(:name, :description, :permission, :branch_id, :tree_id, :position, :row, :column, resources_attributes: [:id, :name, :description, :document, :_destroy])
    end
end
