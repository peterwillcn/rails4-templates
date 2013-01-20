module ApplicationHelper
  def hbr(str)
    raw str.gsub(/\r\n|\r|\n/, '<br />')
  end
end
