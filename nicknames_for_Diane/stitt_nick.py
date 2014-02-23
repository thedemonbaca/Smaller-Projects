"""
This is a program to generate nicknames for Diane Stitt. We'll be using
here last name; Stitt.

Rules:
    1) Stitt has to be at the beginning of the word

First attempt:
    * We're assuming that 'good' nicknames that make 'sense' will just be
      Stitt appended to any word that includes a vowel followed directly
      by a consonant.

Second attempt:
    * We'd like to narrow down the nicknames to include only those that
      follow the previous rule + a new rule. That new rule is that after
      the vowel should be followed by two t's. 


"""
from nltk.corpus import words
import re


def findPair(word):
    """ Find any word that includes two t's """

    if re.search("(?<=tt)\w+", word):
        return re.search("(?<=tt)\w+", word).group()
    else:
        return False


def addStitt(pair):
    """ Add Stitt to our newly transformed word called 'vowcon'"""

    return "Stitt" + pair

    
def data_structure(word, original_word, stitt_dict):
    """ Put this into a data structure """
    if word in stitt_dict:
        stitt_dict[word].append(original_word)
    else:
        stitt_dict[word] = [original_word] # cast to a list

        
def main():
    """ Let's go through the words and return a list of nick names for
    Diane Stitt .... yes! """

    stitt_dict = {}
    for word in words.words('en'):
        # find a word that includes two t's 
        if findPair(word):
            data_structure(addStitt(findPair(word)), # Add Stitt to the word
                           word, # include original word for comparison
                           stitt_dict) # use a dict to group nickname dups
            
    # return a dictionary where each key is a program generated nickname
    # mapped to a list of all words that generate that nickname
    return stitt_dict
