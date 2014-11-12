class NewslettersTable
  attr_accessor :rows

  def initialize data
    @rows = data.map(&method(:format))
  end

  def headers
    @headers ||= %w(id subject state locked sent recipients date)
  end

  def format item
    [
      item.id.to_s,
      item.subject,
      item.state,
      item.send_lock ? 'true' : 'false',
      item.sent_count.to_s,
      item.recipients_count.to_s,
      item.created_at.to_s
    ]
  end

  def max_length_at index
    max_lengths[index]
  end

  def max_lengths
    @max_lengths ||=
      (rows + [headers]).reduce(Array.new(headers.length, 0)) do |maxes, row|
        row.each_with_index.map do |value, index|
          [maxes[index], value.length].max
        end
      end
  end

  def row_size
    @row_size ||= max_lengths.reduce(&:+) + (5 * headers.length) - 1
  end

  def ruler
    @ruler ||= Array.new(row_size, "-").join + "\n"
  end

  def render
    lines = rows.map(&method(:row_for))
    headings = row_for(headers)

    (ruler + headings + ruler + lines.join + ruler)
  end

  def row_for row
    columns = row.each_with_index.map do |item, index|
      item + Array.new(max_length_at(index) - item.length, " ").join
    end

    ("  " + columns.join("  |  ") + "  \n")
  end
end
