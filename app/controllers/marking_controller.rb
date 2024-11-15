class MarkingController < ApplicationController
  before_action :authenticate_teacher!
  helper MarkingHelper

  def index
    @tree = Tree.find(params[:tree_id])
    @branches = @tree.branches.includes(:blossoms)
    @branch = Branch.find(params[:branch_id]) if params[:branch_id].present?  # Add this line if you need to reference a specific branch
    @students = @tree.students.distinct
    @student = Student.find(params[:student_id]) if params[:student_id].present?
    @assessment_item = AssessmentItem.find(params[:assessment_item_id]) if params[:assessment_item_id].present?
    @assessment_items = @tree.assessment_items
    @blossom_assessment = BlossomAssessment.find_by(student_id: params[:student_id], assessment_item_id: params[:assessment_item_id])
    @blossom_assessment ||= BlossomAssessment.new(student_id: params[:student_id], assessment_item_id: params[:assessment_item_id])

    if @student && @assessment_item
      @blossom_assessments = BlossomAssessment.where(student_id: @student.id, assessment_item_id: @assessment_item.id)
    else
      @blossom_assessments = BlossomAssessment.all
    end
  end

  def student_view
    @tree = Tree.find(params[:tree_id])

    if params[:student_id].present?
    @student = Student.find(params[:student_id])
    @blossom_assessments = BlossomAssessment.where(student_id: params[:student_id], assessment_item_id: params[:assessment_item_id])
    @blossom_stages = @blossom_assessments.each_with_object({}) do |assessment, hash|
      hash[assessment.blossom_id] = assessment.stage
    end
    @session_goals = SessionGoal.where(student: @student, tree: @tree)
  else
    # Handle the case where no student is selected yet
    @blossom_stages = {}
    @session_goals = []
  end

  @students = Student.joins(:trees).where(trees: { id: @tree.id }).distinct

    @branches = @tree.branches.includes(:blossoms)
    @assessment_items = @tree.assessment_items
    @session_goal = SessionGoal.new

    if params[:student_id].present? && params[:assessment_item_id].present?
      @blossom_assessments = BlossomAssessment.where(student_id: params[:student_id], assessment_item_id: params[:assessment_item_id])
      @blossom_stages = @blossom_assessments.each_with_object({}) do |assessment, hash|
        hash[assessment.blossom_id] = assessment.stage
      end
    else
      @blossom_stages = {}
    end

    @session_goals = SessionGoal.where(student: @student, tree: @tree)

  end



  def save_branch_blossom_stages
    student_id = params[:student_id]
    assessment_item_id = params[:assessment_item_id]
    blossoms_data = params.require(:blossoms).map do |blossom|
      blossom.permit(:blossom_id, :stage, :branch_id)
    end

    puts "Received student_id: #{student_id}"
    puts "Received assessment_item_id: #{assessment_item_id}"
    puts "Received blossoms_data: #{blossoms_data.inspect}"

    saved_blossoms = []
    puts "Blossoms data type: #{blossoms_data.class}"  # Should be Array
    puts "First blossom data: #{blossoms_data.first}"  # Should be a Hash with keys 'blossom_id' and 'stage'


    begin
      BlossomAssessment.transaction do
        blossoms_data.each do |blossom_data|
          blossom_id = blossom_data[:blossom_id]
          stage = blossom_data[:stage]
          branch_id = blossom_data[:branch_id]  # Retrieve branch_id here

          blossom_assessment = BlossomAssessment.find_or_initialize_by(
            student_id: student_id,
            assessment_item_id: assessment_item_id,
            blossom_id: blossom_id,
            branch_id: branch_id  # Set branch_id here
          )

          if blossom_assessment.update(stage: stage)
            saved_blossoms << {
              student_id: student_id,
              assessment_item_id: assessment_item_id,
              blossom_id: blossom_id,
              stage: stage,
              branch_id: branch_id  # Include branch_id here
            }
          else
            Rails.logger.error "BlossomAssessment update failed: #{blossom_assessment.errors.full_messages.join(", ")}"
            raise ActiveRecord::RecordInvalid.new(blossom_assessment)
          end
        end
      end

      render json: { message: 'Branch stages saved successfully', saved_blossoms: saved_blossoms }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to save branch stages: #{e.record.errors.full_messages.join(", ")}"
      render json: { error: "Failed to save branch stages: #{e.message}" }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "An error occurred: #{e.message}"
      render json: { error: "An error occurred: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.require(:document).permit(:file, :tree_id)
  end

end
