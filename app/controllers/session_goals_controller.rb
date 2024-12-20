class SessionGoalsController < ApplicationController
  before_action :set_tree
  before_action :set_student, only: [:create, :update, :edit, :destroy]
  before_action :set_session_goal, only: [ :show, :edit, :update, :destroy]

  def index
    Rails.logger.debug "Tree: #{@tree.inspect}"

    if params[:student_id].present?
      @student = Student.find(params[:student_id])
      Rails.logger.debug "Student: #{@student.inspect}"
      @session_goals = @tree.session_goals.where(student: @student)
    else
      @session_goals = @tree.session_goals
    end

    Rails.logger.debug "Session Goals: #{@session_goals.inspect}"
  end

  def new
    @session_goal = SessionGoal.new
    Rails.logger.debug "New Session Goal: #{@session_goal.inspect}"
  end

  def create
    @session_goal = @student.session_goals.build(session_goal_params)
    @session_goal.tree = @tree

    if @session_goal.save
      redirect_to tree_student_view_path(@tree, student_id: @student.id), notice: 'Session goal was successfully created.'
    else
      Rails.logger.debug "Params: #{params.inspect}"

    end
  end

  def edit
  end

  def update
    if @session_goal.update(session_goal_params)
      redirect_to tree_student_view_path(@tree, student_id: @student.id), notice: 'Session goal was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @session_goal = SessionGoal.find(params[:id]) # Corrected this line to use `params[:id]`
    @session_goal.destroy!
    redirect_to tree_student_view_path(@tree, student_id: @student.id), notice: 'Session goal was successfully deleted.'
  end

  private

  def set_tree
    @tree = Tree.find(params[:tree_id])
    Rails.logger.debug "Set Tree: #{@tree.inspect}"
  end

  def set_student
    student_id = params[:student_id] || params.dig(:session_goal, :student_id)
    raise ActiveRecord::RecordNotFound, "Student ID is missing" if student_id.blank?

    @student = Student.find(student_id)
    Rails.logger.debug "Set Student: #{@student.inspect}"
  end


  def set_session_goal
    @session_goal = @student.session_goals.find(params[:id])
    Rails.logger.debug "Set Session Goal: #{@session_goal.inspect}"
  end

  def session_goal_params
    params.require(:session_goal).permit(:date, :goal, :evidence, :document, :self_assess, :student_id, :goal_type)
  end
end
