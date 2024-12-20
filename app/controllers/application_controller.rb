class ApplicationController < ActionController::Base
  before_action :load_trees

  def after_sign_out_path_for(resource_or_scope)
    sign_out(resource_or_scope) if resource_or_scope.present?
    root_path
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Student)  # Check if the resource is a Student
      dashboard_student_path (resource)  # Redirect to the student's dashboard
    else
      super  # Default behavior for other user types, like teachers
    end
  end

  private

  def load_trees
    @trees = Tree.all
  end

end
