# move_the_avg.py
""" Module that allows you to simulate a the average of 5 star votes

The module is designed to allow the user to simulate how many of each
vote in a 5-star voting system is required to move the overall average
to +/- .05 of each star.

Just run this in your terminal and answer the questions it asks you

----------------------------------------------------------------------------
$ python move_the_avg.py
----------------------------------------------------------------------------
"""

# let's first find out how many of each star we have by asking the user
# to do a visual check of Facebook; for example.

print("\nPlease answer the following questions and we'll tell you how to"\
      + " move the average rating on a 5-star scale\n")
five_stars = input("How many five star entries do you see? ")
four_stars = input("How many four star entries do you see? ")
three_stars = input("How many three star entries do you see? ")
two_stars = input("How many two star entries do you see? ")
one_stars = input("How many one star entries do you see? ")

print("\nOk, thanks. Hang on a second while we run the numbers.\n")


# create a data structure for the user input
the_stars = {"one_stars" : one_stars, 
             "two_stars" : two_stars,
             "three_stars": three_stars,
             "four_stars": four_stars,
             "five_stars": five_stars}

# Put some functions together to get this thing moving
def gen_ratings_list(stars, amount_of_votes, running_tally):
    """ Append a number of stars depending on the vote """
    for num in range(amount_of_votes):
        running_tally.append(stars)
    return running_tally

    
def load_up_the_list(the_stars):
    """ Load up the list based on user input """
    # creat a running tally to simulate votes
    running_tally = []
    for star in the_stars:
        if star == "one_stars":
            gen_ratings_list(1, the_stars["one_stars"], running_tally)
        elif star == "two_stars":
            gen_ratings_list(2, the_stars["two_stars"], running_tally)
        elif star == "three_stars":
            gen_ratings_list(3, the_stars["three_stars"], running_tally)
        elif star == "four_stars":
            gen_ratings_list(4, the_stars["four_stars"], running_tally)
        elif star == "five_stars":
            gen_ratings_list(5, the_stars["five_stars"], running_tally)
    # Ok the data has been simulated
    return running_tally

def calculate_avg(running_tally):
    avg = 0.0
    for num in running_tally:
        avg += num
    return avg/len(running_tally)
            
def gen_report(the_stars):
    """ Find how many votes are needed to move the avg """
    # Generate a simulation of current data
    test_tally = load_up_the_list(the_stars)
    # Find the original average for comparison
    original_avg = calculate_avg(test_tally)
    # Log results here
    results_dict = {}
    running_total = len(test_tally)
    while calculate_avg(test_tally) >= 1.05:
        test_tally.append(1)
        if calculate_avg(test_tally) <= 3.05 and\
           calculate_avg(test_tally) >= 2.95:
            results_dict["3-star avg"] = len(test_tally) - running_total
            
        elif calculate_avg(test_tally) <= 2.05 and\
           calculate_avg(test_tally) >= 1.95:
            if len(results_dict) >= 2:
                pass
            else:
                results_dict["2-star avg"] = len(test_tally) - running_total

        elif calculate_avg(test_tally) <= 1.05 and\
           calculate_avg(test_tally) >= 0.95:
            results_dict["1-star avg"] = len(test_tally) - running_total
    # ok we have the results
    return results_dict

def main(the_stars):
    """ Generate the report that tells us what we need """
    results = gen_report(the_stars)
    
    ## Print the numbers that we gathered
    
    # Generate a simulation of current data
    test_tally = load_up_the_list(the_stars)
    # Find the original average for comparison
    original_avg = calculate_avg(test_tally)
    
    ## Print the results of the simulation
    print "###############################################################"
    print "############ Results of the voting simulation #################"
    print "###############################################################\n"
    
    print len(test_tally), " voters were entered into the simulation"
    print original_avg, " is the original average vote in this simulation\n"
    
    print results["3-star avg"], " Additional 1-star votes needed"\
        +" for a 3-star avg"
    print results["2-star avg"], " Additional 1-star votes needed"\
        +" for a 2-star avg"
    print results["1-star avg"], " Additional 1-star votes needed"\
        +"for a 1-star avg"

    print "\n#############################################################"
    print "# Remember to treat others how you would like to be treated #"
    print "#############################################################\n"
    

main(the_stars)

