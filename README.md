# Modelling
Master Course with emphasis in Markov Chains

The first App has been developed to get first impressions about Markov Chains.
The take two input values, number of transitions the model will promote and
number of conditions, the model can have. 
A uniformly distributed matrix (with row&lines = number of conditions) is created and every line
is set to zero, by calculating the sum of each line but the value from the diagonal. The sum
is set negative a placed at the diagonal place. Each timepoint for the next transition
is based on a random uniformly distributed value with rate=Q[i,i].

