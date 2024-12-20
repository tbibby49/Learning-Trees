class HomeController < ApplicationController
  def index
    if teacher_signed_in?
      redirect_to trees_path (current_teacher)
    elsif student_signed_in?
      redirect_to dashboard_student_path (current_student)
    end
  end
end
