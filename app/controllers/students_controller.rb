class StudentsController < ApplicationController
  before_action :authenticate_teacher!, only: [:create]
  before_action :authenticate_student!

  before_action :log_params, only: [:create]

  def new
    @student = Student.new
    Rails.logger.debug "New action called"
  end

  def dashboard
    @student = current_student
    @assigned_trees = @student.trees # Retrieves all trees assigned to the current student

  end

  def create
    @student = current_teacher.students.build(student_params)
    @student.class_id = params[:class_id]
    Rails.logger.debug "Attempting to save student: #{@student}"

    if @student.save
      redirect_to @student, notice: 'Student was successfully added.'
    else
      Rails.logger.error "Errors: #{@student.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def marking_page
    @student = current_student
    @assessment_item = AssessmentItem.find(params[:assessment_item_id])
    @branches = Tree.find(params[:tree_id]).branches
  end

  private

  def student_params
    params.require(:student).permit(:name, :username, :email, :password, :password_confirmation, :class_id)
  end

  def log_params
    Rails.logger.debug "Parameters: #{params.inspect}"
  end
end
