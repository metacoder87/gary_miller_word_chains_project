            # meta_coder (Gary Miller) =)
            # gmiller052611@gmail.com
            # https://github.com/metacoder87/gary_miller_word_chains_project


require 'set'
# Word Chains
# Read the Word Chains RubyQuiz.
# http://rubyquiz.com/quiz44.html

# NB: You shouldn't have to use recursion for this one.

# NB: Review the entire outline before beginning.

puts "Phase I: Adjacent Words"
# Let's write a class WordChainer.
class WordChainer
# Begin writing the #initialize(dictionary_file_name) method. Read in the 
# dictionary file. Store the array of dictionary words in an instance variable 
# (e.g., @dictionary).
# https://assets.aaonline.io/fullstack/ruby/projects/word_chains/dictionary.txt

    attr_reader :all_seen_words

    def self.get_dict
        @@dict = Set.new(IO.readlines("dictionary.txt").map { |line| line.chomp.split("") })
    end

# Next, write a helper method adjacent_words(word). This should return all words 
# in the dictionary one letter different than the current word. 
# By "one letter different" we mean that both words have the same length and only 
# differ at one position, e.g. "mat" and "cat" count as adjacent words, but "cat" 
# and "cats" do not, nor do "cola" and "cool."

    def adjacent_words(word, matches = [])
       @@dict.select do |match|
            if match.length == word.length
                word.length.times do |i| 
                    matches << match.join('') if word[0...i] + word[i+1..-1] == match.join('')[0...i] + match.join('')[i+1..-1]
                end
            end
        end
        matches.uniq
    end

# Verify that your adjacent_words method is working.

# Hint: To speed up your search greatly, store your dictionary as a Set. 
# The Set#include? method is much faster than Array#include?, since the Array 
# version needs to iterate through all the elements of the array, whereas Set 
# uses a cool trick we'll learn about when we get to the algorithms curriculum.

puts "Phase IIa: Exploring all words"
# Next, let's begin writing a method #run(source, target). Our strategy is:

# Keep a list of @current_words. Start this with just [source].

# Also keep a list of @all_seen_words. Start this with just [source].
    # def run(source, *target)
    #     @all_seen_words = [source]
    #     @current_words = [source]
    #     until @current_words.empty?
    #         explore_current_words
    #     end
    # end

# Begin an outer loop which will run as long as @current_words is not empty. 
# This will halt our exploration when all words adjacent to @current_word have 
# been discovered.
        # until @current_words.empty?
# Inside this loop, create a new, empty list of new_current_words. We're going 
# to fill this up with new words (that aren't in @all_seen_words) that are 
# adjacent (one step away) from a word in @current_words.
            # new_current_words = []

# To fill up new_current_words, begin a second, inner loop through @current_words.
            # @current_words.each do |current_word| 
# For each current_word, begin a third loop, iterating through all 
# adjacent_words(current_word). This is a triply nested loop.
                # adjacent_words(current_word).each do |adjacent_word|
# For each adjacent_word, skip it if it's already in @all_seen_words; we don't 
# need to reconsider a word we've seen before.
                    # next if @all_seen_words.include?(adjacent_word)
# Otherwise, if it's a new word, add it to both new_current_words, and 
# @all_seen_words so we don't repeat it.
                        # new_current_words << adjacent_word
                        # @all_seen_words << adjacent_word
# After we finish looping through all the @current_words, print out 
# new_current_words, and reset @current_words to new_current_words.
                # end
            # end
            # p @current_words = new_current_words
# Make sure your run method eventually terminates: it should eventually enumerate 
# all the words that are reachable from source, at which point new_current_words 
# will come out empty. After setting @current_words = new_current_words the 
# outermost loop should terminate.
        # end
    # end
# After executing #run, @all_seen_words will contain a list of all the words 
# encountered in our 'exploration.'

# Test your word chainer to make sure it outputs (1) first the words that are one 
# letter away from source, (2) next words that are one letter away from words one 
# letter away from source (i.e., two letters away from source), etc. This is a 
# breadth first enumeration of words that you can reach from the source.

# Call your TA over to check your work.

puts "Phase IIb: Refactor"
# Your code will contain a triply nested loop. Break out the inner loop that 
# iterates through @current_words and builds and assigns the new_current_words to 
# its own method: #explore_current_words.

    # def explore_current_words
    #     new_current_words = []
    #         @current_words.each do |current_word| 
    #             adjacent_words(current_word).each do |adjacent_word|
    #                 next if @all_seen_words.include?(adjacent_word)
    #                     new_current_words << adjacent_word
    #                     @all_seen_words << adjacent_word
    #                 end
    #             end
    #         p @current_words = new_current_words
    # end

puts "Phase III: Keep Track of Prior Words"
# So far we've written our program to build a set of @all_seen_words, adding new 
# words in breadth-first order. However, we don't record enough information to 
# construct a path of words from the source to the target.

# Let's change our program. For every new word we encounter, let's record which 
# previous word we modified to get to the new word. To do this, instead of keeping 
# an array of @all_seen_words, lets make it a hash, where the keys are new words, 
# and the value is the word we modified to get to the new word.

    def run(source, target)
        @all_seen_words = { source => nil }
        @current_words = [source]
        until @all_seen_words.include?(target)
            explore_current_words
        end
        build_path(target)
    end

# Let's start @all_seen_words out as { source => nil }, since source didn't come 
# from anywhere. Let's modify explore_current_words so that instead of merely 
# adding an adjacent_word to the array, we record it as the key, where the value 
# is the current_word we came from.

    def explore_current_words
        new_current_words = []
            @current_words.each do |current_word| 
                adjacent_words(current_word).each do |adjacent_word|
                    next if @all_seen_words.include?(adjacent_word)
                        new_current_words << adjacent_word
                        @all_seen_words[adjacent_word] = current_word
                    end
                end
                # new_current_words.each { |word| puts "#{word} came from #{@all_seen_words[word]}" }
            @current_words = new_current_words
    end

# Modify explore_current_words to print not just the new words, but where they 
# came from. At the end of explore_current_words, iterate through 
# new_current_words, and print out the new word and the word it came from (the 
# value in the @all_seen_words hash). Make sure this output makes sense. You may 
# want to use a longer word like "market" to reduce the verbosity of the output.

puts "Phase IV: Backtracking"
# Okay! Right now #run builds @all_seen_words, but it never constructs the path 
# from the source to the target. Let's use @all_seen_words to do this.

# Write a method named #build_path(target). It should look up the target in 
# @all_seen_words. This is the word we were at before the final step to target. 
# Then we need to look up the word we used to get the second to last word. Then 
# the word before that.

    def build_path(target)
        path = []
        path << target
        path << @all_seen_words[target]
        while @all_seen_words[path.last] != nil
            path << @all_seen_words[path.last]
        end
        p path.reverse.map { |word| word.upcase }.join(" became ")
    end

# Keep looking back and back in from target in @all_seen_words. Each time, add 
# the prior word to an array named path. Eventually you will reach nil, which 
# means we've reached the end of the path back to source.

# Have #run call build_path and return the array.

# Make sure to request a code review from your TA once you can find adjacent words

puts "Bonus Phase: Stop Early"
# Your run method will build the entire set of reachable words. This is wasteful 
# if the source is close to the target. We can stop early in that case. Modify 
#     run to stop looping when @all_seen_words contains the target.

end

WordChainer.get_dict
word = WordChainer.new
word.run('yet', 'ohm')
word.run('work', 'lose')
word.run('end', 'win')


            # meta_coder (Gary Miller) =)
            # gmiller052611@gmail.com
            # https://github.com/metacoder87/gary_miller_word_chains_project