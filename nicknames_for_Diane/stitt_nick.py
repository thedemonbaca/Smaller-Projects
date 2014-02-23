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
    """ Find any word that includes a vowel followed directly by a
    consonant"""

    # create a regex that follows this rule
    pair = re.compile("[aeiou].(tt)")

    if pair.search(word):
        return pair.search(word).group()
    else:
        return False


def removeVowCon(word):
    """ Remove the consonent which directly follows the first vowel in
    a word """

    # create a regex that follows this rule
    vowcon = re.search('(?<=[aeiou]).[^aeiouyw].*', word)

    if vowcon:
        return vowcon.group()
    else:
        return False


def addStitt(vowcon):
    """ Add Stitt to our newly transformed word called 'vowcon'"""

    return "Sti" + vowcon

def main():
    """ Let's go through the words and return a list of nick names for
    Diane Stitt .... yes! """

    nicknames = []
    for word in words.words('en-basic'):
        if findPair(word):
            vowcon = removeVowCon(word)
            if vowcon:
                nicknames.append(addStitt(vowcon))
    return nicknames
