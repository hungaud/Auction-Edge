The normalize data method checks the valid input for "make" with a sample database that I found online.
If I was able to find a database where it has the complete car make and it's model, I'd do it a bit differently.
Instead, I'd create a HashSet of car manufacturer objects. Each object will have data such a HashSet of
all the model for the manufacturer. That way I could check if it was a valid model as well.
It will also further strengthen my validate_make method because, instead of taking the first make that starts
with the same user input, it will find the car make that contains the model in it and returns it, making it more accurate.