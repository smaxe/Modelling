#set.seed(23)

# Amount of conditions
#conds<-sample(1:20, 1)
library(shiny)
the_fun <- function(conds,times){
  conds<-conds
  times <- times
  # Recursive Function to calculate the next state, depending on the random number
  proba_get <- function(vec,current_sum,rand_nxt){
    vec <- vec
    if (rand_nxt <= min(vec)||length(vec)==1){
      
      # Returns minimal Value of Vector (line)
      return(min(vec))
    }
    current_sum <- current_sum + min(vec)
    vec<-vec[which(vec!=min(vec))]
    return(proba_get(vec, current_sum, rand_nxt))
  }
  
  # First line: Q[1,]
  # Normalization per Line
  # Each line has sum = 1 (Probabilty of 1)
  # 
  normalize <- function(Q,conds){
    for (i in 1:conds){
      line_sum <- sum(Q[i,])
      
      
      # Without normalization
      Q[i,i]<- -(line_sum-Q[i,i])
      #With normalization
      #Q[i,j]<-Q[i,j]/line_sum
      
    }
    return(Q)
  }
  
  # Function for adding the times
  time_adder <- function(vec){
    final_vec <-0
    
    for(i in 1:length(vec)){
      final_vec <- c(final_vec,final_vec[length(final_vec)]+vec[i])
    }
    
    return(final_vec[-1])
  }
  
  # Addes the states
  states_adder <- function(states){
    fin_stat<-0
    for (i in 1:(length(states)-1)){
      if (states[i+1]>states[i]){
        fin_stat <- c(fin_stat, fin_stat[length(fin_stat)]+1)
      }
      else if (states[i+1]==states[i]){
        fin_stat <- c(fin_stat, fin_stat[length(fin_stat)])
      }
      else if (states[i+1]<states[i]){
        fin_stat <- c(fin_stat, fin_stat[length(fin_stat)]-1)
      }
    }
    
    if (states[length(states)]>fin_stat[length(fin_stat)]){
      fin_stat <- c(fin_stat, fin_stat[length(fin_stat)]+1)
    }
    else if (states[length(states)]==fin_stat[length(fin_stat)]){
      fin_stat <- c(fin_stat, fin_stat[length(fin_stat)])
    }
    else if (states[length(states)]<fin_stat[length(fin_stat)]){
      fin_stat <- c(fin_stat, fin_stat[length(fin_stat)]-1)
    }
    
    return(fin_stat[-1])
  }
  
  
  # Elements for Q (Transitionprobability Matrix)
  # Transitionsprobas between 1 and 100
  mat_elements=runif(conds^2,min=0, max=1)
  
  Q <-matrix(mat_elements,
             nrow=conds,
             ncol=conds,
             byrow = TRUE)  
  
  
  Q <- normalize(Q,conds)
  #Diagonal is negative sum of other elemnts in same row.
  #This gives me a sum of zero per line-
  # for (i in 1:conds){
  #   line_sum <- sum(Q[i,])
  #   Q[i,i]<- Q[i,i]-line_sum
  # }
  time_vec<-0
  states <- 1
  
  rando<-0
  for (i in 1:times){
    # Time for next jump dependend on proba of staying in current state.
    # Random uniformly distributed number
    rand_nxt <- runif(1,0,1)
    time_vec <- c(time_vec, rexp(1,rate=abs(Q[states,states])))
    current_state = states[length(states)]
    current_sum <- 0
    vec<-Q[current_state,Q[current_state,]!=Q[current_state,current_state]]
    states <- c(states, which(Q[current_state,]==proba_get(vec,current_sum,rand_nxt)))
    #print(rand_nxt)  
    rando<- c(rando,rand_nxt)
    
  }
  
  
  final_time <- time_adder(time_vec)
  final_states <- states_adder(states)
#   return(plot(final_time,states,type="s",
#               xlab="Relative Times", ylab = "State",
#               main = "Simple Markov-Chain"))
  return(qplot(final_time, states, geom="step", main = paste("Markov chain simulation ( states,  events)"),
               ylab = "states", xlab = "time") + theme_bw())
}

ui <- fluidPage(
  sliderInput(inputId = "times",
              label = "Choose amount of transition changes",
              value = 50, min = 1, max = 500),
  sliderInput(inputId = "conds",
              label = "Choose number of states",
              value = 3, min = 1, max = 200),
  plotOutput("myplot")
  #   actionButton(),
  #   submitButton()
)

server <- function(input, output) {
  
  output$myplot <- renderPlot({the_fun(conds = input$conds,times = input$times)})
  
}
shinyApp(server = server, ui = ui)
# myplot <- plot(final_time,final_states,type="s",
#      xlab="Relative Times", ylab = "State Transitions")
