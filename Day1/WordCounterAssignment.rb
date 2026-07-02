module Logger
  def log(message)
    puts "[LOG] #{message}"
  end
end

class WordCounter
  include Logger

  STOPWORDS=["the", "a", "an", "and", "or", "but", "is", "are", "was", "were", "in", "on", "at", "to", "of"].freeze
  def initialize(text)
    @text=text.downcase.split
    @word_count = Hash.new(0)
  end

  def remove_stoppwords
    @text.reject{|words| STOPWORDS.include?(words)}
  end

  def count_words
    filtered_words = remove_stoppwords
    log("Counting words in the text...")
    filtered_words.each do |word|
      @word_count[word] += 1
    end
  end

  def sort_words_by_count
    @word_count.sort_by{|word, count| -count}.to_h
  end

  def return_top_words(n)

    #return nil if the given number is empty or when it is less than or equal to 0
    return {} if n<=0
  
    sorted_words = sort_words_by_count
    sorted_words.each_with_object(Hash.new(0)) do |(word, count), top_words|
      return top_words if top_words.size >= n
      top_words[word] = count
    end
  end
end


def calculate(users)
  users
  .select{|user| user[:age]>18 and user[:active]==true}
  .map{|user| user[:name]}
end
