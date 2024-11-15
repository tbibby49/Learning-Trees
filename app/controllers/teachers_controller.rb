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

    else
      Rails.logger.error "Errors: #{@student.errors.full_messages.join(', ')}"
      render :new_student
    end
  end

  def show_students
    @students = current_teacher.students

  end

  def update_class_id
    @student = Student.find(params[:student_email])
    if @student.update(class_id: params[:class_id])
      redirect_to show_students_teacher_path(current_teacher), notice: 'Class ID was successfully updated.'
    else
      redirect_to show_students_teacher_path, alert: 'There was an error updating the class ID.'
    end
  end

  private

  def student_params
    params.require(:student).permit(:email, :password, :password_confirmation)
  end
end
