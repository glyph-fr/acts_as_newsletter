class NewslettersTable
  attr_accessor :rows

  def initialize data
    @rows = data.map(&method(:format)).unshift(headers)
  end

  def headers
    %w(subject state sent recipients date)
  end

  def format item
    [
      item.subject,
      item.state_name,
      item.sent_count.to_s,
      item.recipients_count.to_s,
      item.created_at.to_s
    ]
  end

  def max_length_at index
    max_lengths[index]
  end

  def max_lengths
    @max_lengths ||= rows.reduce(Array.new(5, 0)) do |maxes, row|
      row.each_with_index.map do |value, index|
        [maxes[index], value.length].max
      end
    end
  end

  def row_size
    @row_size ||= max_lengths.reduce(&:+) + (3 * headers.length) + 4
  end

  def ruler
    @ruler ||= Array.new(row_size, "-").join + "\n"
  end

  def render
    lines = rows.map do |items|
      columns = items.each_with_index.map do |item, index|
        item + Array.new(max_length_at(index) - item.length, " ")
      end
      ("| " + columns.join(" | ") + " |\n")
    end

    (ruler + lines.join(ruler) + ruler)
  end
end