require 'set'
require 'date'

class Normalize

    def initialize(file = "CarMake.txt")
        @file = file
        prompt_intro
        @car_make = Set.new
        @num_error = 0
    end

    def create_list
        car_list = @car_make
        File.open(@file).each do|word|
            car_list.add(word.to_s.strip)
        end
    end


    def normalize_data(input)
        #year
        year = input[:year].to_i
        unless validate_year(input, year)
            return input
        end
        input[:year] = year

        #make
        make = validate_make(input, input[:make].downcase.capitalize)
        input[:make] = make

        #model
        model_array = input[:model].split
        model = model_array[0].downcase.capitalize
        input[:model] = model
        if model_array.size > 1
            input[:trim] = model_array[1].upcase
        end

        #trim
        trim = input[:trim].upcase
        trim == "BLANK" || trim == '' ? input[:trim] = nil : input[:trim] = trim
        input
    end

    def validate_year(input, year)
        max_year = Date.today.year + 2
        if year > (max_year) || year < 1900
            puts "The year inputted: \"#{year}\" is invalid. The year must be between 1900 to #{max_year}"
            puts "Input can't be normalize: #{input.inspect}\n\n"
            return false
        end
        true
    end

    def validate_make(input, make)
        unless @car_make.include?(make)
            @car_make.each do |brand_name|
                if brand_name.start_with?(make)
                    return brand_name
                end
            end
            puts "The make inputted: \"#{make}\" is invalid or not in the \"make\" database."
            puts "Input can't be normalize #{input.inspect}\n\n"
        end
        make
    end

    def given_block()
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
            if (output = normalize_data(input)) != expected_output
                puts "Example #{index + 1} failed,
                Expected: #{expected_output.inspect}
                Got:      #{output.inspect}\n\n"
            end
        end
    end

    def prompt_intro
        puts "Auction Edge Coding Challenge \n\n"
    end

end

solve = Normalize.new
solve.create_list
solve.given_block