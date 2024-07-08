class ApplicationController < ActionController::Base
  before_action :load_trees

  private

  def load_trees
    @trees = Tree.all
  end
end
