module Konekt
  LISTENERS = Hash.new

  def self.subscribe(event_tag, &block)
    LISTENERS[event_tag] ||= []
    LISTENERS[event_tag] << block
  end

  def self.propagate(event)
    event.tags.each do |tag|
      Array(LISTENERS[tag]).each { |block| block.call event }
    end
  end

end
