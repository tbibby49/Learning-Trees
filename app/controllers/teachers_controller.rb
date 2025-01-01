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
    if current_teacher
      @students = current_teacher.students
    else
      redirect_to root_path, notice: 'Please log in first.'
    end
  end

  def update_class_id
    @student = Student.find_by(email: params[:student_email]) # Find by email
    if @student.nil?
      redirect_to show_students_teacher_path, alert: 'Student not found.'
      return
    end

    if @student.update(class_id: params[:class_id])
      redirect_to show_students_teacher_path(current_teacher), notice: 'Class ID was successfully updated.'
    else
      redirect_to show_students_teacher_path(current_teacher), alert: 'There was an error updating the Class ID.'
    end
  end

  def reset_password
    student = Student.find(params[:student_id])
    new_password = SecureRandom.alphanumeric(8) # Generate a random password

    if student.update(password: new_password)
      flash[:notice] = "Password reset successfully. New password: #{new_password}"
    else
      flash[:alert] = "Failed to reset the password."
    end

    redirect_to show_students_teacher_path # Ensure you redirect to the appropriate page

  end

  private

  def student_params
    params.require(:student).permit(:email, :password, :password_confirmation)
  end

end
