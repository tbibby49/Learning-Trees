# app/controllers/teachers_controller.rb
class TeachersController < ApplicationController
  before_action :authenticate_teacher!

  def new_student
    @student = Student.new
  end

  def create_student
    @student = current_teacher.students.build(student_params)

    Rails.logger.debug "Attempting to save student: #{@student.inspect}"

    if @student.save
      Rails.logger.debug "Student saved successfully: #{@student.inspect}"
      redirect_to @student, notice: 'Student was successfully added.'
    else
      Rails.logger.error "Errors: #{@student.errors.full_messages.join(', ')}"
      render :new_student
    end
  end

  private

  def student_params
    params.require(:student).permit(:email, :password, :password_confirmation)
  end
end
