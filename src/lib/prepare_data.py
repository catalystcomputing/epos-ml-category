from spell_checker import SpellChecker

NWORDS = file('../../data/CombinedProductText.dat').read()

spell_checker = SpellChecker(NWORDS)

print spell_checker.correct('Cosmopolitan')