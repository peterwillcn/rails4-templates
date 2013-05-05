module ApplicationHelper
  def hbr(str)
    raw str.to_s.gsub(/\r\n|\r|\n/, '<br />')
  end
end
