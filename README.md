# Modelling
Master Course with emphasis in Markov Chains

The App has been developed to get first impressions about Markov Chains.
It takes two input values, number of transitions the model will do and
number of conditions, the model can have. 
A uniformly distributed matrix (with row&lines = number of conditions) is created and every line
is set to zero, by calculating the sum of each line but the value from the diagonal. The sum
is set negative a placed at the diagonal place. Each timepoint for the next transition
is based on a random uniformly distributed value with rate=Q[i,i]. To get the next state/condition, 
again runif(1,0,1) (one random uniformly distributed value between 0 and 1) is calculated and
compared to the transitions states Q[i,] of the line where we are currently. Depending
on their probabilities, we can choose the next state and we will have a birth, when the
index of the new transition is > current transition index or a death at the opposite condition.

Website with the App: https://maxsuter.shinyapps.io/NeuerOrdner/
