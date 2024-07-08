module MarkingHelper
  def blossom_stage_class(stage)
    case stage
    when 'partially demonstrated'
      'gold'
    when 'fully demonstrated'
      'glow'
    else
      ''
    end
  end
end
