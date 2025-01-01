class TreesController < ApplicationController
  before_action :set_tree, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def authenticate_user!
    # Check if either teacher or student is signed in
    if teacher_signed_in?
      authenticate_teacher!
    elsif student_signed_in?
      authenticate_student!
    else
      redirect_to new_user_session_path, alert: "You must be signed in to view this page."
    end
  end

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
    @tree.teacher_id = current_teacher.id

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
    @tree = Tree.find(params[:id])

    # Check for associated BlossomAssessment records
    associated_assessments = BlossomAssessment.joins(:branch)
                                               .where(branches: { tree_id: @tree.id })

    if associated_assessments.exists?
      flash[:alert] = "Cannot delete tree because associated assessments exist."
      redirect_to assessments_tree_path(@tree) # Redirect to a custom page
    else
      @tree.destroy
      flash[:notice] = "Tree deleted successfully."
      redirect_to trees_path
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

  def assign_tree_to_student
    @tree = Tree.find(params[:id])

    # Check if a specific student email is provided, otherwise find all students with the class_id
    if params[:student_email].present?
      @student = Student.find_by(email: params[:student_email])

      if @student && !@tree.students.include?(@student)
        @tree.students << @student
        flash[:success] = "Tree successfully assigned to student."
      else
        flash[:warning] = "Student not found or already assigned."
      end
    elsif params[:class_id].present?
      students = Student.where(class_id: params[:class_id])

      if students.any?
        students.each do |student|
          unless @tree.students.include?(student)
            @tree.students << student
          end
        end
        flash[:success] = "Tree successfully assigned to all students in the class."
      else
        flash[:warning] = "No students found with the provided class ID."
      end
    else
      flash[:warning] = "No student email or class ID provided."
    end

    redirect_to @tree
  end

  def remove_from_student
    @tree = Tree.find(params[:id])
    @student = Student.find(params[:student_id])

    if @tree.students.include?(@student)
      @tree.students.delete(@student)  # Remove the student from the tree
      flash[:success] = "Tree successfully removed from student."
    else
      flash[:warning] = "Student does not have this tree assigned."
    end

    redirect_to show_students_teacher_path(current_teacher)  # Redirect back to the teacher's show_students page
  end

  # app/controllers/trees_controller.rb
def clone
  @tree = Tree.find(params[:id])
end

def create_cloned_tree
  @tree = Tree.find(params[:tree_id])

  # Check for uniqueness of the name
  new_name = params[:name]
  if Tree.exists?(name: new_name)
    flash[:alert] = "A tree with this name already exists. Please choose a different name."
    render :clone
  else
    # Clone the tree
    cloned_tree = @tree.dup
    cloned_tree.name = new_name
    cloned_tree.save!

    # Optionally, clone branches and blossoms as well
    @tree.branches.each do |branch|
      new_branch = branch.dup
      new_branch.tree = cloned_tree
      new_branch.save!

      branch.blossoms.each do |blossom|
        new_blossom = blossom.dup
        new_blossom.branch = new_branch
        new_blossom.save!
      end
    end

    # Redirect to the new cloned tree's page
    redirect_to tree_path(cloned_tree), notice: "Tree cloned successfully!"
  end
end

  def assessments
    @tree = Tree.find(params[:id])
    @assessments = BlossomAssessment.joins(:branch)
                                    .where(branches: { tree_id: @tree.id })
                                    .includes(:student, :assessment_item, :blossom)
  end

  def clear_assessments
    @tree = Tree.find(params[:id])
    @student = Student.find(params[:student_id]) if params[:student_id]

    if @student
      # Clear all BlossomAssessments for the specific student and tree
      BlossomAssessment.joins(:branch)
                       .where(branches: { tree_id: @tree.id }, student: @student)
                       .delete_all

      redirect_to assessments_tree_path(@tree), notice: "Successfully cleared assessments for #{@student.email}."
    else
      # Clear all BlossomAssessments for the entire tree
      BlossomAssessment.joins(:branch)
                       .where(branches: { tree_id: @tree.id })
                       .delete_all

      redirect_to trees_path, notice: "Successfully cleared all assessments associated with the tree."
    end
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
