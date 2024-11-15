class StudentsController < ApplicationController
  before_action :authenticate_teacher!
  before_action :log_params, only: [:create]

  def new
    @student = Student.new
    Rails.logger.debug "New action called"

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

  private

  def student_params
    params.require(:student).permit(:name, :username, :email, :password, :password_confirmation, :class_id)
  end

  def log_params
    Rails.logger.debug "Parameters: #{params.inspect}"
  end
end
