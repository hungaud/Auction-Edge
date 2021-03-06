# Hung Auduong
# Auction Edge
# 04/16/2018
#
# This program normalizes a small set of data. Many time users will have typos or
# use shorthand in a given field. The small set of data are some of the example problems
# that Auction Edge encounter.
#
# Used Ruby gem 2.4.3


require 'set'
require 'date'

class Normalize

    # post: initialize the program with a default txt file. The txt file is a set of
    #       car makes that was found online and is used as a database.
    def initialize(file = "CarMake.txt")
        @file = file
        prompt_intro
        @car_make = Set.new
    end

    # post: create a set of car make name as a database
    #       used a hash set since each make should be unique.
    def create_list
        car_set = @car_make
        File.open(@file).each do |word|
            car_set.add(word.to_s.strip)
        end
    end

    # post: given block by Auction Edge with an array that includes several problems that
    #       the company faces. Each index includes what the user input and the expected
    #       output. Any failed normalization will print what the expected output should be.
    def given_block
        examples = [
        [{ :year => '2018', :make => 'fo', :model => 'focus', :trim => 'blank' },
         { :year => 2018, :make => 'Ford', :model => 'Focus', :trim => nil }],
        [{ :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' },
         { :year => '200', :make => 'blah', :model => 'foo', :trim => 'bar' }],
        [{ :year => '1999', :make => 'Chev', :model => 'IMPALA', :trim => 'st' },
         { :year => 1999, :make => 'Chevrolet', :model => 'Impala', :trim => 'ST' }],
        [{ :year => '2000', :make => 'ford', :model => 'focus se', :trim => '' },
         { :year => 2000, :make => 'Ford', :model => 'Focus', :trim => 'SE' }]
        ]

        examples.each_with_index do |(input, expected_output), index|
            if (output = normalize_data(input)) == expected_output
                puts "Example #{index + 1} passed!"
            else
                puts "Example #{index + 1} failed,
                Expected: #{expected_output.inspect}
                Got:      #{output.inspect}"
            end
        end
    end

    # post: Normalize the user's input by each field. It first checks if the year is
    #       in a valid range. Then checks if the make is a short hand or invalid input.
    #       After that, it normalizes the model and trim but does not check if its a valid input
    #       due to lack of database. It will also check if the user input the trim in the model
    #       and extract it to the "trim" field.
    #       returns corrected input or the input that can't be normalize
    def normalize_data(input)
        year = input[:year].to_i
        return input unless validate_year(input, year)
        input[:year] = year

        make = validate_make(input[:make])
        input[:make] = make

        model_array = input[:model].split
        model = model_array[0].downcase.capitalize
        input[:model] = model
        input[:trim] = model_array[1].upcase if model_array.size > 1

        trim = input[:trim].upcase
        trim == "BLANK" || trim == '' ? input[:trim] = nil : input[:trim] = trim
        input
    end

    private

    # pre:  1900 <= year <= 2 years in the future from today
    # post: helper method that returns boolean if the user's
    #       input for the year field is a valid input.
    def validate_year(input, year)
        max_year = Date.today.year + 2
        year <= max_year && year >= 1900
    end

    # pre:  car make in set
    # post: iterate through the set to find if user's input for "make" is a short hand
    #       of a make. It takes the first find that starts with user's input and returns
    #       it. If it can't find it then returns the original "make".
    def validate_make(make)
        unless @car_make.include?(make)
            @car_make.each do |brand_name|
                return brand_name if brand_name.start_with?(make.downcase.capitalize)
            end
        end
        make
    end

    # post: quick intro
    def prompt_intro
        puts "Auction Edge Coding Challenge \n\n"
    end

end

# drivers for the program
solve = Normalize.new
solve.create_list
solve.given_block